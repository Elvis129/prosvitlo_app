import '../services/local_storage_service.dart';

class SettingsRepository {
  final LocalStorageService _storageService;

  SettingsRepository(this._storageService);

  /// Save the theme mode preference (light/dark/system)
  Future<bool> saveThemeMode(String mode) {
    return _storageService.saveThemeMode(mode);
  }

  /// Get the saved theme mode preference
  String getThemeMode() {
    return _storageService.loadThemeMode();
  }

  /// Save the notifications enabled/disabled state
  Future<bool> saveNotificationsEnabled(bool enabled) {
    return _storageService.saveNotificationsEnabled(enabled);
  }

  /// Check if notifications are enabled
  bool getNotificationsEnabled() {
    return _storageService.loadNotificationsEnabled();
  }

  /// Mark the onboarding flow as complete
  Future<bool> saveOnboardingComplete() {
    return _storageService.saveOnboardingComplete();
  }

  /// Check if the user has completed onboarding
  bool isOnboardingComplete() {
    return _storageService.loadOnboardingComplete();
  }

  /// Check if the donation dialog should be shown (based on time interval)
  bool shouldShowDonationDialog() {
    return _storageService.shouldShowDonationDialog();
  }

  /// Mark the donation dialog as shown (saves current timestamp)
  Future<bool> markDonationDialogShown() {
    return _storageService.saveDonationDialogShownDate(DateTime.now());
  }
}
