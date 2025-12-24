/// Конфігурація додатку
class AppConfig {
  // API Base URL
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://prosvitlo-backend.fly.dev/api/v1',
  );

  // Firebase configuration
  static const bool enableFirebase = true;

  // Feature flags
  static const bool enableAnalytics = false;
  static const bool enableCrashReporting = false;

  // Cache durations
  static const Duration donationCacheDuration = Duration(hours: 24);
  static const Duration scheduleCacheDuration = Duration(hours: 1);

  // UI Configuration
  static const Duration splashMinDuration = Duration(milliseconds: 1000);
}
