import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'core/config/app_config.dart';
import 'core/config/app_theme_mode.dart';
import 'core/config/firebase_status.dart';
import 'core/di/app_dependencies.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'presentation/address_search/viewmodel/address_search_cubit.dart';
import 'presentation/home/viewmodel/home_cubit.dart';
import 'presentation/onboarding/viewmodel/onboarding_cubit.dart';
import 'presentation/push_notifications/cubit/push_notifications_cubit.dart';
import 'presentation/schedule/viewmodel/schedule_cubit.dart';
import 'presentation/settings/viewmodel/settings_cubit.dart';
import 'presentation/splash/splash_screen.dart';

// Global ValueNotifier for theme changes
final themeModeNotifier = ValueNotifier<AppThemeMode>(AppThemeMode.system);

// Global ValueNotifier for onboarding completion status
final onboardingCompleteNotifier = ValueNotifier<bool>(false);

class LightOutageApp extends StatefulWidget {
  final FirebaseStatus firebaseStatus;

  const LightOutageApp({super.key, required this.firebaseStatus});

  @override
  State<LightOutageApp> createState() => _LightOutageAppState();
}

class _LightOutageAppState extends State<LightOutageApp> {
  late AppDependencies _dependencies;
  bool _isInitialized = false;
  bool _isOnboardingComplete = false;
  AppThemeMode _themeMode = AppThemeMode.system;
  late GoRouter _router;

  @override
  void initState() {
    super.initState();
    _initializeApp();

    // Listen to theme changes
    themeModeNotifier.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    themeModeNotifier.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) {
      setState(() {
        _themeMode = themeModeNotifier.value;
      });
    }
  }

  Future<void> _initializeApp() async {
    // Start timer for minimum animation duration
    final startTime = DateTime.now();

    // Initialize all dependencies with Firebase status
    _dependencies = await AppDependencies.initialize(
      firebaseStatus: widget.firebaseStatus,
    );

    // Load initial settings
    _isOnboardingComplete = _dependencies.settingsRepository
        .isOnboardingComplete();
    final themeModeString = _dependencies.settingsRepository.getThemeMode();
    _themeMode = AppThemeMode.fromString(themeModeString);
    themeModeNotifier.value = _themeMode;
    onboardingCompleteNotifier.value = _isOnboardingComplete;

    // Initialize router once
    _router = AppRouter.router(
      _isOnboardingComplete,
      onboardingCompleteNotifier,
    );

    // Initialize Firebase Messaging if available
    if (widget.firebaseStatus.isAvailable) {
      _dependencies.initializeFirebase();
    }

    // Initialize AdMob
    _dependencies.initializeAdMob();

    // Preload data in background for faster access
    _dependencies.preloadData();

    // Ensure minimum splash duration for animation visibility
    final elapsed = DateTime.now().difference(startTime);
    final minDuration = AppConfig.splashMinDuration;
    if (elapsed < minDuration) {
      await Future.delayed(minDuration - elapsed);
    }

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  ThemeMode _getThemeMode() => _themeMode.toThemeMode();

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const SplashScreen();
    }

    return Provider<AppDependencies>.value(
      value: _dependencies,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => OnboardingCubit(
              _dependencies.settingsRepository,
              onboardingCompleteNotifier,
            ),
          ),
          BlocProvider(
            create: (context) => HomeCubit(
              _dependencies.addressRepository,
              _dependencies.outageRepository,
              _dependencies.settingsRepository,
              _dependencies.donationRepository,
            ),
          ),
          BlocProvider(
            create: (context) =>
                AddressSearchCubit(_dependencies.addressRepository),
          ),
          BlocProvider(
            create: (context) =>
                ScheduleCubit(_dependencies.scheduleRepository),
          ),
          BlocProvider(
            create: (context) => SettingsCubit(
              _dependencies.settingsRepository,
              _dependencies.addressRepository,
              _dependencies.donationRepository,
            )..loadSettings(),
          ),
          BlocProvider(
            create: (context) => PushNotificationsCubit(
              repository: _dependencies.firebasePushRepository,
              messagingService: _dependencies.firebaseMessagingService,
            )..initialize(),
          ),
        ],
        child: MaterialApp.router(
          title: 'ProСвітло',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: _getThemeMode(),
          routerConfig: _router,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('uk')],
        ),
      ),
    );
  }
}
