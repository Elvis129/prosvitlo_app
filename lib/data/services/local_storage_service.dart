import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/address_model.dart';

/// Service for local storage using SharedPreferences
/// Handles all persistent data storage for the app
class LocalStorageService {
  static const String _keyOnboardingComplete = 'onboarding_complete';
  static const String _keySelectedAddress = 'selected_address';
  static const String _keySavedAddresses = 'saved_addresses';
  static const String _keyAddressesOrder = 'addresses_order';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyNotificationsEnabled = 'notifications_enabled';
  static const String _keyLastDonationDialogDate = 'last_donation_dialog_date';

  final SharedPreferences _prefs;
  static LocalStorageService? _instance;

  LocalStorageService(this._prefs);

  /// Get singleton instance of LocalStorageService
  static Future<LocalStorageService> getInstance() async {
    if (_instance != null) return _instance!;
    final prefs = await SharedPreferences.getInstance();
    _instance = LocalStorageService(prefs);
    return _instance!;
  }

  // === Onboarding ===

  /// Mark onboarding as complete
  Future<bool> saveOnboardingComplete() {
    return _prefs.setBool(_keyOnboardingComplete, true);
  }

  /// Check if user has completed onboarding
  bool loadOnboardingComplete() {
    return _prefs.getBool(_keyOnboardingComplete) ?? false;
  }

  // === Selected Address ===

  /// Save the currently selected address
  Future<bool> saveAddress(AddressModel address) {
    final json = jsonEncode(address.toJson());
    return _prefs.setString(_keySelectedAddress, json);
  }

  /// Load the currently selected address
  AddressModel? loadAddress() {
    final json = _prefs.getString(_keySelectedAddress);
    if (json == null) return null;

    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return AddressModel.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  /// Clear the selected address
  Future<bool> clearAddress() {
    return _prefs.remove(_keySelectedAddress);
  }

  // === Saved Addresses (List) ===

  /// Save list of addresses
  Future<bool> saveAddresses(List<AddressModel> addresses) async {
    try {
      final List<Map<String, dynamic>> addressesList = addresses
          .map((address) => address.toJson())
          .toList();
      final String addressesJson = jsonEncode(addressesList);
      return _prefs.setString(_keySavedAddresses, addressesJson);
    } catch (e) {
      return false;
    }
  }

  /// Load list of saved addresses
  Future<List<AddressModel>> loadAddresses() async {
    final String? addressesJson = _prefs.getString(_keySavedAddresses);
    if (addressesJson == null) {
      return [];
    }

    try {
      final List<dynamic> addressesList = jsonDecode(addressesJson);
      return addressesList
          .map((json) => AddressModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Clear the list of saved addresses
  Future<bool> clearAddresses() {
    return _prefs.remove(_keySavedAddresses);
  }

  // === Address Order ===

  /// Save the order of addresses (list of address IDs)
  Future<bool> saveAddressesOrder(List<String> addressIds) {
    return _prefs.setString(_keyAddressesOrder, jsonEncode(addressIds));
  }

  /// Load the saved order of addresses (list of address IDs)
  /// Returns null if no order is saved
  List<String>? loadAddressesOrder() {
    final String? orderJson = _prefs.getString(_keyAddressesOrder);
    if (orderJson == null) return null;

    try {
      final List<dynamic> orderList = jsonDecode(orderJson);
      return orderList.cast<String>();
    } catch (e) {
      return null;
    }
  }

  /// Clear the saved addresses order
  Future<bool> clearAddressesOrder() {
    return _prefs.remove(_keyAddressesOrder);
  }

  // === Theme Mode ===

  /// Save theme mode (light/dark/system)
  Future<bool> saveThemeMode(String mode) {
    return _prefs.setString(_keyThemeMode, mode);
  }

  /// Load saved theme mode, defaults to 'system'
  String loadThemeMode() {
    return _prefs.getString(_keyThemeMode) ?? 'system';
  }

  // === Notifications ===

  /// Save notifications enabled state
  Future<bool> saveNotificationsEnabled(bool enabled) {
    return _prefs.setBool(_keyNotificationsEnabled, enabled);
  }

  /// Check if notifications are enabled, defaults to true
  bool loadNotificationsEnabled() {
    return _prefs.getBool(_keyNotificationsEnabled) ?? true;
  }

  // === Donation Dialog ===

  /// Save the date when donation dialog was last shown
  Future<bool> saveDonationDialogShownDate(DateTime date) {
    return _prefs.setString(_keyLastDonationDialogDate, date.toIso8601String());
  }

  /// Load the last date when donation dialog was shown
  DateTime? loadLastDonationDialogDate() {
    final dateString = _prefs.getString(_keyLastDonationDialogDate);
    if (dateString == null) return null;

    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Check if donation dialog should be shown based on interval
  /// [daysInterval] Number of days between showing the dialog (default: 1 day)
  bool shouldShowDonationDialog({int daysInterval = 1}) {
    final lastShownDate = loadLastDonationDialogDate();
    if (lastShownDate == null) return true; // First launch

    final now = DateTime.now();
    final daysSinceLastShown = now.difference(lastShownDate).inDays;

    // Show if enough days have passed
    return daysSinceLastShown >= daysInterval;
  }

  // === Clear All Data ===

  /// Clear all stored data (use with caution)
  Future<bool> clearAll() {
    return _prefs.clear();
  }
}
