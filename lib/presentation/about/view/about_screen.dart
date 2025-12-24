import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/extensions/localizations_extension.dart';
import '../../../core/di/app_dependencies.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/donation_banner.dart';
import '../../../data/services/log_color.dart';
import '../viewmodel/about_cubit.dart';
import '../viewmodel/about_state.dart';
import '../widgets/app_info_section.dart';
import '../widgets/disclaimer_card.dart';
import '../widgets/donation_card_dialog.dart';
import '../widgets/feedback_section.dart';
import '../widgets/telegram_channel_card.dart';

/// Screen with app information, support links, and privacy policy
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dependencies = Provider.of<AppDependencies>(context, listen: false);

    return BlocProvider(
      create: (context) =>
          AboutCubit(dependencies.donationRepository)..loadAboutInfo(),
      child: Scaffold(
        appBar: AppBar(title: Text(context.l10n.aboutTitle)),
        body: BlocBuilder<AboutCubit, AboutState>(
          builder: (context, state) {
            if (state is AboutLoading || state is AboutInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AboutError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text(
                    state.message,
                    style: AppTextStyles.body,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            if (state is AboutLoaded) {
              return ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  // Donation banner
                  if (state.donationInfo != null &&
                      state.donationInfo!.url.isNotEmpty)
                    DonationBanner(
                      onTap: () => _handleDonationTap(context, state),
                    ),

                  const SizedBox(height: AppSpacing.xl),

                  // Feedback section
                  Text(
                    context.l10n.aboutFeedback,
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const FeedbackSection(),

                  const SizedBox(height: AppSpacing.md),

                  // Telegram channel
                  const TelegramChannelCard(),

                  const SizedBox(height: AppSpacing.xl),

                  // About app section
                  Text(
                    context.l10n.aboutAppInfo,
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppInfoSection(appVersion: state.appVersion),

                  const SizedBox(height: AppSpacing.lg),

                  // Disclaimer
                  const DisclaimerCard(),

                  const SizedBox(height: AppSpacing.xxl),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Future<void> _handleDonationTap(
    BuildContext context,
    AboutLoaded state,
  ) async {
    if (state.donationInfo == null) return;

    try {
      final uri = Uri.parse(state.donationInfo!.url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          await DonationCardDialog.show(context, state.donationInfo!);
        }
      }
    } catch (e) {
      logError('[AboutScreen] Failed to open donation link: $e');
      if (context.mounted) {
        await DonationCardDialog.show(context, state.donationInfo!);
      }
    }
  }
}
