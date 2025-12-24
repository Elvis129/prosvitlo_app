import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/repositories/schedule_repository.dart';
import '../../../data/models/schedule_model.dart';
import '../../../data/services/log_color.dart';
import 'schedule_state.dart';

/// Cached schedules data
class CachedSchedules {
  final List<ScheduleModel> schedules;
  final DateTime? lastUpdated;

  const CachedSchedules(this.schedules, this.lastUpdated);
}

class ScheduleCubit extends Cubit<ScheduleState> {
  final ScheduleRepository _repository;

  static const String _cacheKey = 'cached_schedules';
  static const String _cacheVersionKey = 'cached_schedules_version';

  ScheduleCubit(this._repository) : super(ScheduleInitial());

  /// Loads schedules (from cache first, then updates from server)
  Future<void> loadSchedules({bool forceRefresh = false}) async {
    logInfo(
      '[ScheduleCubit] loadSchedules called (forceRefresh: $forceRefresh)',
    );

    try {
      // Load from cache first (unless forcing refresh)
      if (!forceRefresh) {
        final cachedData = await _loadFromCache();
        if (cachedData != null) {
          if (cachedData.schedules.isNotEmpty) {
            logInfo(
              '[ScheduleCubit] Loaded ${cachedData.schedules.length} schedules from cache',
            );
            emit(
              ScheduleLoaded(
                cachedData.schedules,
                lastUpdated: cachedData.lastUpdated,
              ),
            );
          } else {
            emit(ScheduleLoading());
          }
        } else {
          emit(ScheduleLoading());
        }
      } else {
        emit(ScheduleLoading());
      }

      // Fetch from server
      logInfo('[ScheduleCubit] Fetching schedules from server...');
      final schedules = await _repository.getCurrentSchedules(limit: 7);
      final now = DateTime.now();
      logInfo(
        '[ScheduleCubit] Received ${schedules.length} schedules from server',
      );

      // Check if data changed (compare versions)
      final hasChanges = await _hasChanges(schedules);

      if (hasChanges || forceRefresh) {
        logInfo(
          '[ScheduleCubit] Data changed or force refresh, emitting ScheduleLoaded',
        );
        emit(ScheduleLoaded(schedules, lastUpdated: now));
        // Save to cache
        await _saveToCache(schedules, now);
      } else {
        logInfo('[ScheduleCubit] Data unchanged, keeping current state');
        // Data unchanged, don't update UI
        // If no cached data in state, show it
        final currentState = state;
        if (currentState is! ScheduleLoaded) {
          emit(ScheduleLoaded(schedules, lastUpdated: now));
        }
        // Otherwise keep current state without rebuild
      }
    } catch (e) {
      logError('[ScheduleCubit] Error loading schedules: $e');

      // If we have cached data, keep showing it instead of error
      final currentState = state;
      if (currentState is ScheduleLoaded && currentState.schedules.isNotEmpty) {
        return;
      }

      // Try loading from cache if not done yet
      final cachedData = await _loadFromCache();
      if (cachedData != null) {
        if (cachedData.schedules.isNotEmpty) {
          emit(
            ScheduleLoaded(
              cachedData.schedules,
              lastUpdated: cachedData.lastUpdated,
            ),
          );
          return;
        }
      }

      // No cached data, show error
      emit(ScheduleError(e.toString()));
    }
  }

  /// Refreshes schedules with loading indicator on existing data
  Future<void> refreshSchedules() async {
    final currentState = state;

    // Show refreshing state if we have existing data
    if (currentState is ScheduleLoaded && currentState.schedules.isNotEmpty) {
      emit(
        ScheduleRefreshing(
          currentState.schedules,
          lastUpdated: currentState.lastUpdated,
        ),
      );
    }

    await loadSchedules(forceRefresh: true);
  }

  /// Saves schedules to cache
  Future<void> _saveToCache(
    List<ScheduleModel> schedules,
    DateTime lastUpdated,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = schedules.map((s) => s.toJson()).toList();
      await prefs.setString(_cacheKey, json.encode(jsonList));
      await prefs.setString('${_cacheKey}_time', lastUpdated.toIso8601String());

      // Save versions for change detection
      final versions = schedules.map((s) => '${s.id}_${s.version}').join(',');
      await prefs.setString(_cacheVersionKey, versions);
    } catch (e) {
      // Ignore cache save errors
    }
  }

  /// Loads schedules from cache
  Future<CachedSchedules?> _loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString(_cacheKey);
      final timeStr = prefs.getString('${_cacheKey}_time');

      if (cachedJson != null) {
        final List<dynamic> jsonList = json.decode(cachedJson);
        final schedules = jsonList.map((json) {
          final schedule = ScheduleModel.fromJson(json);
          // Normalize URLs from cache for current platform
          return ScheduleModel(
            id: schedule.id,
            date: schedule.date,
            imageUrl: schedule.imageUrl,
            altText: schedule.altText,
            version: schedule.version,
            createdAt: schedule.createdAt,
            updatedAt: schedule.updatedAt,
          );
        }).toList();
        final lastUpdated = timeStr != null ? DateTime.parse(timeStr) : null;
        return CachedSchedules(schedules, lastUpdated);
      }
    } catch (e) {
      // Ignore cache load errors
    }
    return null;
  }

  /// Checks if data changed (version comparison)
  /// Compares version strings to detect changes without full data comparison
  Future<bool> _hasChanges(List<ScheduleModel> newSchedules) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedVersions = prefs.getString(_cacheVersionKey);

      if (cachedVersions == null) return true;

      final newVersions = newSchedules
          .map((s) => '${s.id}_${s.version}')
          .join(',');
      return cachedVersions != newVersions;
    } catch (e) {
      return true; // On error assume data changed
    }
  }
}
