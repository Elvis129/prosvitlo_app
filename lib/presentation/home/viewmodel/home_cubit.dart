import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/address_repository.dart';
import '../../../data/repositories/donation_repository.dart';
import '../../../data/services/log_color.dart';
import '../../../data/repositories/outage_repository.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../data/services/api_exception.dart';
import '../../../data/models/address_with_status_model.dart';
import '../../../data/models/address_outages_model.dart';
import '../services/auto_refresh_service.dart';
import '../services/home_cache_service.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final AddressRepository _addressRepository;
  final OutageRepository _outageRepository;
  final SettingsRepository _settingsRepository;
  final DonationRepository _donationRepository;
  final AutoRefreshService _autoRefreshService;
  final HomeCacheService _cacheService;

  HomeCubit(
    this._addressRepository,
    this._outageRepository,
    this._settingsRepository,
    this._donationRepository, {
    AutoRefreshService? autoRefreshService,
    HomeCacheService? cacheService,
  }) : _autoRefreshService = autoRefreshService ?? AutoRefreshService(),
       _cacheService = cacheService ?? HomeCacheService(),
       super(HomeInitial());

  /// Reload addresses (called after adding/removing)
  Future<void> refreshAddresses() async {
    await loadData(forceRefresh: true);
  }

  /// Load data (from cache first, then update from server)
  Future<void> loadData({bool forceRefresh = false}) async {
    try {
      // Load from cache first (unless forcing refresh)
      if (!forceRefresh) {
        final cachedData = await _cacheService.load();
        if (cachedData != null && cachedData.isNotEmpty) {
          emit(HomeLoaded(addresses: cachedData));
        } else {
          emit(HomeLoading());
        }
      } else {
        emit(HomeLoading());
      }

      // Get all saved addresses (in saved order)
      final addresses = await _addressRepository.getSavedAddressesOrdered();

      if (addresses.isEmpty) {
        emit(HomeLoaded(addresses: []));
        await _cacheService.clear();
        return;
      }

      // Load statuses for all addresses in parallel (today and tomorrow)
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final tomorrowDateStr =
          '${tomorrow.year}-${tomorrow.month.toString().padLeft(2, '0')}-${tomorrow.day.toString().padLeft(2, '0')}';

      final statusMap = await _outageRepository.getMultipleStatuses(addresses);
      final tomorrowStatusMap = await _outageRepository.getMultipleStatuses(
        addresses,
        scheduleDate: tomorrowDateStr,
      );

      final now = DateTime.now();

      // Load emergency and planned outages information in parallel
      logInfo(
        '[HomeCubit] Fetching outages for ${addresses.length} addresses in parallel',
      );
      final outagesFutures = addresses.map((addr) async {
        try {
          final outages = await _outageRepository.getAddressOutages(
            addr.city,
            addr.street,
            addr.house,
          );
          return MapEntry(addr.id, outages);
        } catch (e) {
          logError(
            '[HomeCubit] Error fetching outages for address ${addr.id}: $e',
          );
          return MapEntry(addr.id, null);
        }
      });

      final outagesResults = await Future.wait(outagesFutures);
      final outagesMap = Map.fromEntries(
        outagesResults
            .where((entry) => entry.value != null)
            .cast<MapEntry<String, AddressOutagesModel>>(),
      );
      logInfo(
        '[HomeCubit] Successfully fetched outages for ${outagesMap.length}/${addresses.length} addresses',
      );

      // Update statuses with last update time
      final updatedAddresses = addresses.map((addr) {
        final status = statusMap[addr.id];
        final tomorrowStatus = tomorrowStatusMap[addr.id];
        final outages = outagesMap[addr.id];
        return AddressWithStatus(
          address: addr,
          status: status,
          tomorrowStatus: tomorrowStatus,
          outages: outages,
          isLoading: false,
          lastUpdated: now,
        );
      }).toList();

      // Check if data has changed
      final hasChanges = _hasDataChanged(updatedAddresses);

      if (hasChanges || forceRefresh) {
        emit(HomeLoaded(addresses: updatedAddresses));

        // Save to cache
        await _cacheService.save(updatedAddresses);

        // Schedule auto-refresh timer
        _autoRefreshService.scheduleRefresh(updatedAddresses, () => loadData());
      } else {
        // Data unchanged, but update lastUpdated time
        final currentState = state;
        if (currentState is HomeLoaded) {
          final updatedWithTime = currentState.addresses.map((addr) {
            final newAddr = updatedAddresses.firstWhere(
              (a) => a.address.id == addr.address.id,
              orElse: () => addr,
            );
            return newAddr.copyWith(lastUpdated: now);
          }).toList();
          emit(currentState.copyWith(addresses: updatedWithTime));
          await _cacheService.save(updatedWithTime);
        }
      }
    } on ApiException catch (e) {
      // If we have cached data, show it instead of error
      final currentState = state;
      if (currentState is HomeLoaded && currentState.addresses.isNotEmpty) {
        // Don't change state, keep cached data
        return;
      }

      // If not loaded from cache yet, try to load
      final cachedData = await _cacheService.load();
      if (cachedData != null && cachedData.isNotEmpty) {
        emit(HomeLoaded(addresses: cachedData));
        return;
      }

      emit(HomeError(e.userMessage));
    } catch (e) {
      // If we have cached data, show it
      final currentState = state;
      if (currentState is HomeLoaded && currentState.addresses.isNotEmpty) {
        return;
      }

      // Try to load from cache
      final cachedData = await _cacheService.load();
      if (cachedData != null && cachedData.isNotEmpty) {
        emit(HomeLoaded(addresses: cachedData));
        return;
      }

      emit(HomeError('Error loading data: ${e.toString()}'));
    }
  }

  /// Force data refresh
  Future<void> refresh() async {
    await loadData(forceRefresh: true);
  }

  /// Update when app returns to foreground
  Future<void> onAppResumed() async {
    await loadData();
  }

  /// Check if data has changed compared to current state
  ///
  /// Uses Equatable comparison for reliable change detection.
  /// AddressWithStatus implements Equatable, so we can safely compare objects.
  bool _hasDataChanged(List<AddressWithStatus> newAddresses) {
    final currentState = state;
    if (currentState is! HomeLoaded) return true;

    final currentAddresses = currentState.addresses;
    if (currentAddresses.length != newAddresses.length) return true;

    // Compare each address using Equatable's == operator
    // This automatically compares all fields defined in props
    for (int i = 0; i < newAddresses.length; i++) {
      final newAddr = newAddresses[i];
      final currentAddr = currentAddresses.firstWhere(
        (a) => a.address.id == newAddr.address.id,
        orElse: () => newAddr,
      );

      // Equatable handles deep comparison of all fields
      if (newAddr != currentAddr) return true;
    }

    return false; // Data unchanged
  }

  void toggleExpanded(String addressId) {
    final currentState = state;
    if (currentState is HomeLoaded) {
      final expandedIds = Set<String>.from(currentState.expandedAddressIds);
      if (expandedIds.contains(addressId)) {
        expandedIds.remove(addressId);
      } else {
        expandedIds.add(addressId);
      }
      emit(currentState.copyWith(expandedAddressIds: expandedIds));
    }
  }

  /// Checks if donation dialog should be shown and returns URL
  Future<String?> checkAndGetDonationUrl() async {
    if (!_settingsRepository.shouldShowDonationDialog()) {
      return null;
    }

    // Load donation info from repository
    try {
      final donationInfo = await _donationRepository.getDonationInfo();
      return donationInfo?.url;
    } catch (e) {
      logError('[HomeCubit] Failed to load donation URL: $e');
      return null;
    }
  }

  /// Marks that donation dialog was shown (tomorrow)
  Future<void> markDonationDialogShown() async {
    await _settingsRepository.markDonationDialogShown();
  }

  /// Mark dialog shown for specified days (after clicking "Support")
  Future<void> markDonationDialogShownForDays(int days) async {
    await _settingsRepository.markDonationDialogShownForDays(days);
  }

  /// Mark that user already donated (hide for 30 days)
  Future<void> markUserAlreadyDonated() async {
    await _settingsRepository.markDonationDialogShownForDays(30);
  }

  /// Reorder addresses by moving one from oldIndex to newIndex
  /// Updates both local state and persistent storage
  Future<void> reorderAddresses(int oldIndex, int newIndex) async {
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    try {
      // Adjust newIndex if moving down (standard ReorderableList behavior)
      final adjustedNewIndex = oldIndex < newIndex ? newIndex - 1 : newIndex;

      // Optimistic update - reorder in UI immediately without waiting for storage
      final reorderedAddresses = List<AddressWithStatus>.from(
        currentState.addresses,
      );
      final movedItem = reorderedAddresses.removeAt(oldIndex);
      reorderedAddresses.insert(adjustedNewIndex, movedItem);

      // Update state immediately for smooth UI
      emit(currentState.copyWith(addresses: reorderedAddresses));

      // Save to repository in background using its reorderAddresses method
      // This handles both saving addresses and their order
      await _addressRepository.reorderAddresses(oldIndex, newIndex);

      // Update cache
      await _cacheService.save(reorderedAddresses);

      logInfo(
        '[HomeCubit] Addresses reordered: $oldIndex -> $adjustedNewIndex',
      );
    } catch (e) {
      logError('[HomeCubit] Error reordering addresses: $e');
      // Reload data on error to restore correct state
      await loadData(forceRefresh: true);
    }
  }

  /// Get current addresses for external use (e.g., SettingsCubit)
  List<AddressWithStatus> getCurrentAddresses() {
    final currentState = state;
    if (currentState is HomeLoaded) {
      return currentState.addresses;
    }
    return [];
  }
}
