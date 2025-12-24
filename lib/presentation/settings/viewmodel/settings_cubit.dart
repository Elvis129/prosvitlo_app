import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../data/repositories/address_repository.dart';
import '../../../data/repositories/donation_repository.dart';
import '../../../data/services/log_color.dart';
import '../../../core/config/app_theme_mode.dart';
import '../../../app.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _settingsRepository;
  final AddressRepository _addressRepository;
  final DonationRepository _donationRepository;

  SettingsCubit(
    this._settingsRepository,
    this._addressRepository,
    this._donationRepository,
  ) : super(SettingsInitial());

  Future<void> loadSettings() async {
    emit(SettingsLoading());

    try {
      final themeMode = _settingsRepository.getThemeMode();
      final notificationsEnabled = _settingsRepository
          .getNotificationsEnabled();
      final addresses = await _addressRepository.getSavedAddressesOrdered();

      // Load donation info from repository
      final donationInfo = await _donationRepository.getDonationInfo();

      emit(
        SettingsLoaded(
          themeMode: themeMode,
          notificationsEnabled: notificationsEnabled,
          addresses: addresses,
          donationInfo: donationInfo,
        ),
      );
    } catch (e, stackTrace) {
      logError('Failed to load settings: $e\n$stackTrace');
      emit(SettingsError('Failed to load settings'));
    }
  }

  Future<void> changeThemeMode(String mode) async {
    try {
      await _settingsRepository.saveThemeMode(mode);

      // Update global theme notifier to trigger app rebuild
      final themeMode = AppThemeMode.fromString(mode);
      themeModeNotifier.value = themeMode;

      // Reload settings
      await loadSettings();
    } catch (e, stackTrace) {
      logError('Failed to change theme mode: $e\n$stackTrace');
      emit(SettingsError('Failed to change theme'));
    }
  }

  Future<void> toggleNotifications(bool enabled) async {
    try {
      await _settingsRepository.saveNotificationsEnabled(enabled);
      await loadSettings();
    } catch (e, stackTrace) {
      logError('Failed to toggle notifications: $e\n$stackTrace');
      emit(SettingsError('Failed to save notification settings'));
    }
  }

  Future<void> deleteAddress(String addressId) async {
    final currentState = state;
    if (currentState is! SettingsLoaded) return;

    try {
      await _addressRepository.deleteAddress(addressId);

      // Update state locally instead of reloading
      final updatedAddresses = currentState.addresses
          .where((address) => address.id != addressId)
          .toList();

      emit(currentState.copyWith(addresses: updatedAddresses));
    } catch (e, stackTrace) {
      logError('Failed to delete address: $e\n$stackTrace');
      emit(SettingsError('Failed to delete address'));
    }
  }

  Future<void> updateAddressName(String addressId, String newName) async {
    final currentState = state;
    if (currentState is! SettingsLoaded) return;

    try {
      // Find the address
      final address = currentState.addresses.firstWhere(
        (a) => a.id == addressId,
      );

      // Update the name
      final updatedAddress = address.copyWith(name: newName);
      await _addressRepository.updateAddress(updatedAddress);

      // Update state locally instead of reloading
      final updatedAddresses = currentState.addresses
          .map((a) => a.id == addressId ? updatedAddress : a)
          .toList();

      emit(currentState.copyWith(addresses: updatedAddresses));
    } catch (e, stackTrace) {
      logError('Failed to update address name: $e\n$stackTrace');
      emit(SettingsError('Failed to update address name'));
    }
  }

  /// Manually refresh settings from repositories
  Future<void> refreshSettings() async {
    await loadSettings();
  }

  /// Sync addresses order from repository without full reload
  /// This avoids flickering when order changes on HomeScreen
  Future<void> syncAddressesOrder() async {
    final currentState = state;
    if (currentState is! SettingsLoaded) return;

    try {
      // Get current order from repository
      final orderedAddresses = await _addressRepository
          .getSavedAddressesOrdered();

      // Only update if order actually changed
      final currentIds = currentState.addresses.map((a) => a.id).toList();
      final newIds = orderedAddresses.map((a) => a.id).toList();

      if (currentIds.toString() != newIds.toString()) {
        emit(currentState.copyWith(addresses: orderedAddresses));
      }
    } catch (e, stackTrace) {
      logError('Failed to sync addresses order: $e\n$stackTrace');
      // Don't emit error, just silently fail to avoid disrupting UI
    }
  }
}
