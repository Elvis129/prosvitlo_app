import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/address_model.dart';
import '../../presentation/onboarding/view/onboarding_screen.dart';
import '../../presentation/home/view/home_screen.dart';
import '../../presentation/address_search/view/address_search_screen.dart';
import '../../presentation/schedule/view/schedule_screen.dart';
import '../../presentation/push_notifications/view/push_notifications_screen.dart';
import '../../presentation/settings/view/settings_screen.dart';
import '../../presentation/about/view/about_screen.dart';
import 'main_shell.dart';

/// Application router configuration
class AppRouter {
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String addressSearch = '/address-search';
  static const String schedule = '/schedule';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String about = '/about';

  static GoRouter router(
    bool isOnboardingComplete,
    ValueNotifier<bool> onboardingCompleteNotifier,
  ) {
    return GoRouter(
      initialLocation: isOnboardingComplete ? home : onboarding,
      refreshListenable: onboardingCompleteNotifier,
      redirect: (context, state) {
        final isOnboardingRoute = state.matchedLocation == onboarding;
        final currentOnboardingStatus = onboardingCompleteNotifier.value;

        // User hasn't completed onboarding and trying to access other routes
        if (!currentOnboardingStatus && !isOnboardingRoute) {
          return onboarding;
        }

        // User completed onboarding but trying to access onboarding screen
        if (currentOnboardingStatus && isOnboardingRoute) {
          return home;
        }

        // Allow navigation to requested route
        return null;
      },
      routes: [
        GoRoute(
          path: onboarding,
          builder: (context, state) => const OnboardingScreen(),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MainShell(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: home,
                  builder: (context, state) => const HomeScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: schedule,
                  builder: (context, state) => const ScheduleScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: notifications,
                  builder: (context, state) => const PushNotificationsScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: settings,
                  builder: (context, state) => const SettingsScreen(),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: addressSearch,
          builder: (context, state) {
            // Type-safe extraction of extra parameter to prevent runtime crashes
            final addressToEdit = state.extra is AddressModel
                ? state.extra as AddressModel
                : null;
            return AddressSearchScreen(addressToEdit: addressToEdit);
          },
        ),
        GoRoute(path: about, builder: (context, state) => const AboutScreen()),
      ],
    );
  }
}
