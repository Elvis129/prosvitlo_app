import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/address_with_status_model.dart';
import '../../../data/services/log_color.dart';

/// Service for caching home screen data (addresses with statuses)
class HomeCacheService {
  static const String _cacheKey = 'cached_addresses_with_status';

  /// Saves addresses with their statuses to cache
  ///
  /// Returns true if successful, false otherwise.
  /// Errors are logged but not thrown.
  Future<bool> save(List<AddressWithStatus> addresses) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = addresses.map((a) => a.toJson()).toList();
      await prefs.setString(_cacheKey, json.encode(jsonList));
      return true;
    } catch (e) {
      logWarning('[HomeCacheService] Failed to save cache: $e');
      return false;
    }
  }

  /// Loads addresses with their statuses from cache
  ///
  /// Returns null if no cache exists or if an error occurs.
  /// Errors are logged but not thrown.
  Future<List<AddressWithStatus>?> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString(_cacheKey);

      if (cachedJson == null) return null;

      final List<dynamic> jsonList = json.decode(cachedJson);
      return jsonList.map((json) => AddressWithStatus.fromJson(json)).toList();
    } catch (e) {
      logWarning('[HomeCacheService] Failed to load cache: $e');
      return null;
    }
  }

  /// Clears all cached data
  ///
  /// Returns true if successful, false otherwise.
  /// Errors are logged but not thrown.
  Future<bool> clear() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKey);
      return true;
    } catch (e) {
      logWarning('[HomeCacheService] Failed to clear cache: $e');
      return false;
    }
  }
}
