import 'package:shared_preferences/shared_preferences.dart';
import '../../data/services/local_storage_service.dart';
import '../../data/services/api_client.dart';
import '../../data/services/address_search_service.dart';
import '../../data/services/outage_service.dart';
import '../../data/services/schedule_service.dart';
import '../../data/services/firebase_messaging_service.dart';
import '../../data/services/admob_service.dart';
import '../../data/repositories/address_repository.dart';
import '../../data/repositories/outage_repository.dart';
import '../../data/repositories/schedule_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/repositories/firebase_push_repository.dart';
import '../../data/repositories/donation_repository.dart';
import '../config/app_config.dart';
import '../config/firebase_status.dart';
import '../../data/services/log_color.dart';

/// Dependency Injection container for all app dependencies
class AppDependencies {
  // Firebase status
  final FirebaseStatus firebaseStatus;

  // Services
  final LocalStorageService localStorageService;
  final ApiClient apiClient;
  final AddressSearchService addressSearchService;
  final OutageService outageService;
  final ScheduleService scheduleService;
  final FirebaseMessagingService? firebaseMessagingService;
  final AdMobService adMobService;

  // Repositories
  final AddressRepository addressRepository;
  final OutageRepository outageRepository;
  final ScheduleRepository scheduleRepository;
  final SettingsRepository settingsRepository;
  final DonationRepository donationRepository;
  final FirebasePushRepository? firebasePushRepository;

  AppDependencies._({
    required this.firebaseStatus,
    required this.localStorageService,
    required this.apiClient,
    required this.addressSearchService,
    required this.outageService,
    required this.scheduleService,
    this.firebaseMessagingService,
    required this.adMobService,
    required this.addressRepository,
    required this.outageRepository,
    required this.scheduleRepository,
    required this.settingsRepository,
    required this.donationRepository,
    this.firebasePushRepository,
  });

  /// Initialize all dependencies
  static Future<AppDependencies> initialize({
    required FirebaseStatus firebaseStatus,
  }) async {
    // Initialize services
    final localStorageService = await LocalStorageService.getInstance();
    final apiClient = ApiClient(baseUrl: AppConfig.baseUrl);
    final addressSearchService = AddressSearchService(apiClient: apiClient);
    final outageService = OutageService(apiClient);
    final scheduleService = ScheduleService(baseUrl: AppConfig.baseUrl);
    final adMobService = AdMobService.instance;

    // Initialize repositories
    final addressRepository = AddressRepository(
      addressSearchService,
      localStorageService,
    );
    final outageRepository = OutageRepository(outageService);
    final donationRepository = DonationRepository(apiClient);
    final scheduleRepository = ScheduleRepository(scheduleService);
    final settingsRepository = SettingsRepository(localStorageService);

    // Initialize Firebase services only if available
    final firebaseDeps = firebaseStatus.isAvailable
        ? await _initializeFirebaseDeps(apiClient)
        : null;

    return AppDependencies._(
      firebaseStatus: firebaseStatus,
      localStorageService: localStorageService,
      apiClient: apiClient,
      addressSearchService: addressSearchService,
      outageService: outageService,
      scheduleService: scheduleService,
      firebaseMessagingService: firebaseDeps?.messagingService,
      adMobService: adMobService,
      addressRepository: addressRepository,
      donationRepository: donationRepository,
      outageRepository: outageRepository,
      scheduleRepository: scheduleRepository,
      settingsRepository: settingsRepository,
      firebasePushRepository: firebaseDeps?.pushRepository,
    );
  }

  /// Initialize Firebase dependencies (optional feature)
  static Future<_FirebaseDeps> _initializeFirebaseDeps(
    ApiClient apiClient,
  ) async {
    final messagingService = FirebaseMessagingService();
    final prefs = await SharedPreferences.getInstance();
    final pushRepository = FirebasePushRepository(
      apiClient: apiClient,
      messagingService: messagingService,
      prefs: prefs,
    );

    return _FirebaseDeps(
      messagingService: messagingService,
      pushRepository: pushRepository,
    );
  }

  /// Initialize Firebase Messaging in background (best effort)
  ///
  /// Executes asynchronously after app startup.
  /// Errors don't block the app - push notifications are optional.
  Future<void> initializeFirebase() async {
    if (!AppConfig.enableFirebase || firebaseStatus.isUnavailable) return;
    if (firebaseMessagingService == null || firebasePushRepository == null) {
      return;
    }

    try {
      await firebaseMessagingService!.initialize();
      await firebasePushRepository!.registerToken();
    } catch (e) {
      logWarning('Firebase initialization failed: $e');
    }
  }

  /// Initialize AdMob in background (best effort)
  ///
  /// Executes asynchronously after app startup.
  /// Errors don't block the app - ads are optional.
  Future<void> initializeAdMob() async {
    try {
      await adMobService.initialize();
    } catch (e) {
      logWarning('AdMob initialization failed: $e');
    }
  }

  /// Preload data for faster access (best effort)
  ///
  /// Loads data in background to improve UX.
  /// Errors are ignored - data will load on first request.
  Future<void> preloadData() async {
    try {
      // Load schedules in advance
      await scheduleRepository.getCurrentSchedules(limit: 7);
    } catch (e) {
      logInfo('Preload data skipped: $e');
    }
  }
}

/// Helper for Firebase dependencies
class _FirebaseDeps {
  final FirebaseMessagingService messagingService;
  final FirebasePushRepository pushRepository;

  _FirebaseDeps({required this.messagingService, required this.pushRepository});
}
