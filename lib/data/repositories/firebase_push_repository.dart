import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/firebase_notification_model.dart';
import '../services/api_client.dart';
import '../services/firebase_messaging_service.dart';
import '../services/log_color.dart';

/// Repository for managing Firebase push notifications
/// Handles FCM token registration, user addresses, and notification history
class FirebasePushRepository {
  final ApiClient _apiClient;
  final FirebaseMessagingService _messagingService;
  final SharedPreferences _prefs;

  static const String _notificationsCacheKey = 'firebase_notifications_cache';
  static const String _userAddressesCacheKey = 'user_addresses_cache';
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _tokenRegisteredKey = 'token_registered';
  static const String _lastTokenKey = 'last_fcm_token';

  FirebasePushRepository({
    required ApiClient apiClient,
    required FirebaseMessagingService messagingService,
    required SharedPreferences prefs,
  }) : _apiClient = apiClient,
       _messagingService = messagingService,
       _prefs = prefs;

  // ============= FCM Token Management =============

  /// Registers FCM token on backend
  /// Skips registration if token is already registered to avoid unnecessary network calls
  Future<void> registerToken() async {
    final token = _messagingService.fcmToken;
    final deviceId = _messagingService.deviceId;

    if (token == null || deviceId == null) {
      throw Exception('FCM token or device ID unavailable');
    }

    // Check if token is already registered
    final lastToken = _prefs.getString(_lastTokenKey);
    final isRegistered = _prefs.getBool(_tokenRegisteredKey) ?? false;

    if (isRegistered && lastToken == token) {
      logInfo('✅ [registerToken] Token already registered, skipping');
      return;
    }

    final platform = Platform.isAndroid ? 'android' : 'ios';

    try {
      await _apiClient.post(
        '/tokens/register',
        data: {'device_id': deviceId, 'fcm_token': token, 'platform': platform},
      );

      // Save that token is registered
      await _prefs.setBool(_tokenRegisteredKey, true);
      await _prefs.setString(_lastTokenKey, token);
    } catch (e) {
      logError('[registerToken] $e');
      throw Exception('Token registration error: $e');
    }
  }

  /// Removes FCM token from backend and deletes local token
  Future<void> unregisterToken() async {
    final deviceId = _messagingService.deviceId;

    if (deviceId == null) {
      throw Exception('Device ID unavailable');
    }

    try {
      await _apiClient.delete('/tokens/unregister/$deviceId');
      await _messagingService.deleteToken();
    } catch (e) {
      throw Exception('Token removal error: $e');
    }
  }

  /// Toggles notifications on/off
  /// Saves setting locally, sends to backend, and registers token if enabling
  Future<void> toggleNotifications(bool enabled) async {
    try {
      // Save locally
      await _prefs.setBool(_notificationsEnabledKey, enabled);

      // Send to backend if deviceId available
      await _sendToggleToBackend(enabled);

      // Register token if enabling
      if (enabled) {
        await _registerIfEnabled();
      }
    } catch (e) {
      throw Exception('Error toggling notifications: $e');
    }
  }

  /// Sends notification toggle state to backend (ignores errors)
  Future<void> _sendToggleToBackend(bool enabled) async {
    final deviceId = _messagingService.deviceId;
    if (deviceId == null) return;

    try {
      await _apiClient.patch(
        '/tokens/toggle',
        data: {'device_id': deviceId, 'enabled': enabled},
      );
    } catch (e) {
      // Ignore backend error - notifications are enabled locally
      logError('[toggleNotifications] Backend toggle failed: $e');
    }
  }

  /// Registers token if deviceId and token are available (ignores errors)
  Future<void> _registerIfEnabled() async {
    final deviceId = _messagingService.deviceId;
    final token = _messagingService.fcmToken;

    if (deviceId == null || token == null) return;

    try {
      await registerToken();
    } catch (e) {
      // Ignore token registration error - notifications are already enabled locally
      logError('[toggleNotifications] Token registration failed: $e');
    }
  }

  /// Whether notifications are enabled (defaults to true)
  bool areNotificationsEnabled() {
    return _prefs.getBool(_notificationsEnabledKey) ?? true;
  }

  // ============= User Addresses =============

  /// Adds a saved address for this device
  /// Returns the created address model
  Future<UserAddressModel> addUserAddress({
    required String city,
    required String street,
    required String houseNumber,
  }) async {
    final deviceId = _messagingService.deviceId;

    if (deviceId == null) {
      throw Exception('Device ID unavailable');
    }

    try {
      final response = await _apiClient.post(
        '/addresses/add',
        data: {
          'device_id': deviceId,
          'city': city,
          'street': street,
          'house_number': houseNumber,
        },
      );

      final address = UserAddressModel.fromJson(response.data);

      // Update local cache
      final addresses = await getUserAddresses();
      addresses.add(address);
      await _cacheUserAddresses(addresses);

      return address;
    } catch (e) {
      throw Exception('Error adding address: $e');
    }
  }

  /// Gets saved user addresses
  /// Returns cached addresses if deviceId unavailable or on error
  Future<List<UserAddressModel>> getUserAddresses() async {
    final deviceId = _messagingService.deviceId;

    if (deviceId == null) {
      // Return from cache if no deviceId
      return _getCachedUserAddresses();
    }

    try {
      final response = await _apiClient.get('/addresses/$deviceId');

      final addresses = (response as List)
          .map((json) => UserAddressModel.fromJson(json))
          .toList();

      // Save to local cache
      await _cacheUserAddresses(addresses);

      return addresses;
    } catch (e) {
      // On error return from cache
      return _getCachedUserAddresses();
    }
  }

  /// Removes a saved address
  Future<void> removeUserAddress({
    required String city,
    required String street,
    required String houseNumber,
  }) async {
    final deviceId = _messagingService.deviceId;

    if (deviceId == null) {
      throw Exception('Device ID unavailable');
    }

    try {
      await _apiClient.delete(
        '/addresses/remove',
        data: {
          'device_id': deviceId,
          'city': city,
          'street': street,
          'house_number': houseNumber,
        },
      );

      // Update local cache
      final addresses = await getUserAddresses();
      addresses.removeWhere(
        (a) =>
            a.city == city &&
            a.street == street &&
            a.houseNumber == houseNumber,
      );
      await _cacheUserAddresses(addresses);
    } catch (e) {
      throw Exception('Error removing address: $e');
    }
  }

  // ============= Notifications History =============

  /// Gets notification history with optional filtering
  /// Returns cached notifications on error
  Future<List<FirebaseNotificationModel>> getNotifications({
    int limit = 50,
    String? notificationType,
  }) async {
    final deviceId = _messagingService.deviceId;

    if (deviceId == null) {
      // Return from cache if no deviceId
      logInfo('📦 [getNotifications] No device_id, returning from CACHE');
      return _getCachedNotifications();
    }

    try {
      final queryParams = {
        'limit': limit.toString(),
        if (notificationType != null) 'notification_type': notificationType,
      };

      final response = await _apiClient.getList(
        '/notifications/$deviceId',
        queryParameters: queryParams,
      );

      logInfo(
        '📱 [getNotifications] Response from BACKEND: ${response.length}',
      );

      final notifications = response
          .map((json) => FirebaseNotificationModel.fromJson(json))
          .toList();

      logInfo(
        '✅ [getNotifications] Parsed ${notifications.length} notifications',
      );

      // Зберігаємо в локальний кеш
      await _cacheNotifications(notifications);

      return notifications;
    } catch (e, stackTrace) {
      // При помилці повертаємо з кешу
      logError('[getNotifications] $e');
      logError('[getNotifications] StackTrace: $stackTrace');
      final cached = _getCachedNotifications();
      logInfo(
        '📦 [getNotifications] Returning ${cached.length} notifications from CACHE',
      );
      return cached;
    }
  }

  // ============= Local Cache =============

  /// Caches notifications locally (backup)
  Future<void> _cacheNotifications(
    List<FirebaseNotificationModel> notifications,
  ) async {
    final jsonList = notifications.map((n) => n.toJson()).toList();
    await _prefs.setString(_notificationsCacheKey, jsonEncode(jsonList));
  }

  /// Gets notifications from local cache
  List<FirebaseNotificationModel> _getCachedNotifications() {
    final cached = _prefs.getString(_notificationsCacheKey);
    if (cached == null) return [];

    try {
      final jsonList = jsonDecode(cached) as List;
      return jsonList
          .map((json) => FirebaseNotificationModel.fromJson(json))
          .toList();
    } catch (e) {
      logError('[_getCachedNotifications] Cache parsing error: $e');
      return [];
    }
  }

  /// Caches user addresses locally
  Future<void> _cacheUserAddresses(List<UserAddressModel> addresses) async {
    final jsonList = addresses.map((a) => a.toJson()).toList();
    await _prefs.setString(_userAddressesCacheKey, jsonEncode(jsonList));
  }

  /// Gets addresses from local cache
  List<UserAddressModel> _getCachedUserAddresses() {
    final cached = _prefs.getString(_userAddressesCacheKey);
    if (cached == null) return [];

    try {
      final jsonList = jsonDecode(cached) as List;
      return jsonList.map((json) => UserAddressModel.fromJson(json)).toList();
    } catch (e) {
      logError('[_getCachedUserAddresses] Cache parsing error: $e');
      return [];
    }
  }

  /// Checks if notifications cache exists
  bool hasCachedNotifications() {
    return _prefs.containsKey(_notificationsCacheKey);
  }

  /// Checks if user addresses cache exists
  bool hasCachedAddresses() {
    return _prefs.containsKey(_userAddressesCacheKey);
  }

  /// Clears local cache
  Future<void> clearCache() async {
    await _prefs.remove(_notificationsCacheKey);
    await _prefs.remove(_userAddressesCacheKey);
  }
}
