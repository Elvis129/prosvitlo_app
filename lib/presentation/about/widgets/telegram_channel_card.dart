import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/config/app_links.dart';
import '../../../core/extensions/localizations_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/services/log_color.dart';

/// Telegram channel card
class TelegramChannelCard extends StatelessWidget {
  const TelegramChannelCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: InkWell(
        onTap: () => _openTelegramChannel(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.campaign,
                    color: AppColors.primaryBlue,
                    size: 24,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AutoSizeText(
                      maxLines: 1,
                      minFontSize: 10,
                      context.l10n.telegramChannelTitle,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                context.l10n.telegramChannelDescription,
                style: AppTextStyles.small.copyWith(
                  color: AppColors.slateGray,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  const Icon(
                    Icons.telegram,
                    color: AppColors.primaryBlue,
                    size: 18,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: AutoSizeText(
                      '@ProSvitloKhm',
                      maxLines: 1,
                      minFontSize: 8,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),

                  const Icon(
                    Icons.open_in_new,
                    size: 18,
                    color: AppColors.slateGray,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openTelegramChannel(BuildContext context) async {
    await _openUrl(context, AppLinks.telegramChannel);
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.errorOpeningLink)),
          );
        }
      }
    } catch (e) {
      logError('Failed to open URL: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.errorGeneric(e.toString()))),
        );
      }
    }
  }
}
