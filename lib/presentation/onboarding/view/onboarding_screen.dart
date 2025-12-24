import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/extensions/localizations_extension.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/router/app_router.dart';
import '../viewmodel/onboarding_cubit.dart';
import '../viewmodel/onboarding_state.dart';
import '../widgets/feature_item.dart';

/// Onboarding screen introducing app features
/// Shows logo, description, and key features before entering the app
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  // Features list using l10n keys
  List<Map<String, dynamic>> _getFeatures(BuildContext context) {
    final l10n = context.l10n;
    return [
      {
        'icon': Icons.location_on,
        'title': l10n.onboardingFeature1Title,
        'description': l10n.onboardingFeature1Description,
      },
      {
        'icon': Icons.schedule,
        'title': l10n.onboardingFeature2Title,
        'description': l10n.onboardingFeature2Description,
      },
      {
        'icon': Icons.notifications_active,
        'title': l10n.onboardingFeature3Title,
        'description': l10n.onboardingFeature3Description,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingCompleted) {
          context.go(AppRouter.home);
        } else if (state is OnboardingError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.xxl),

                // Adaptive logo (30% of screen width)
                Builder(
                  builder: (context) {
                    final logoSize = MediaQuery.of(context).size.width * 0.3;
                    return Container(
                      width: logoSize,
                      height: logoSize,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Image.asset('assets/image/logo.png'),
                    );
                  },
                ),

                const SizedBox(height: AppSpacing.xxl),

                // Title
                Text(
                  context.l10n.onboardingAppTitle,
                  style: AppTextStyles.heading1,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSpacing.lg),

                // Description
                Text(
                  context.l10n.onboardingAppSubtitle,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSpacing.xxl),

                // Features list
                ..._getFeatures(context).map(
                  (feature) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: FeatureItem(
                      icon: feature['icon'] as IconData,
                      title: feature['title'] as String,
                      description: feature['description'] as String,
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                // Continue Button
                BlocBuilder<OnboardingCubit, OnboardingState>(
                  builder: (context, state) {
                    return AppButton(
                      text: context.l10n.onboardingStart,
                      onPressed: () {
                        context.read<OnboardingCubit>().completeOnboarding(
                          context,
                        );
                      },
                      isLoading: state is OnboardingLoading,
                      width: double.infinity,
                    );
                  },
                ),

                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
