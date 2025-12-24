import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/config/app_links.dart';
import '../../../core/extensions/localizations_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/services/log_color.dart';

/// App information section
class AppInfoSection extends StatelessWidget {
  final String appVersion;

  const AppInfoSection({required this.appVersion, super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          _buildInfoRow(
            context,
            Icons.info_outline,
            context.l10n.aboutVersion,
            appVersion,
          ),
          const Divider(height: AppSpacing.lg),
          _buildInfoRow(
            context,
            Icons.person_outline,
            context.l10n.aboutDeveloper,
            'YuZak',
          ),
          const Divider(height: AppSpacing.lg),
          _buildInfoRow(
            context,
            Icons.source_outlined,
            context.l10n.aboutDataSource,
            AppLinks.dataSourceDisplay,
            onTap: () => _openDataSource(context),
          ),
          const Divider(height: AppSpacing.lg),
          _buildInfoRow(
            context,
            Icons.privacy_tip_outlined,
            context.l10n.aboutPrivacyPolicy,
            context.l10n.aboutPrivacyPolicy,
            onTap: () => _openPrivacyPolicy(context),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    VoidCallback? onTap,
  }) {
    final isClickable = onTap != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.slateGray),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.caption),
                  Text(
                    value,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isClickable
                          ? AppColors.primaryBlue
                          : AppColors.slateGray,
                    ),
                  ),
                ],
              ),
            ),
            if (isClickable)
              const Icon(
                Icons.open_in_new,
                size: 16,
                color: AppColors.slateGray,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _openDataSource(BuildContext context) async {
    await _openUrl(context, AppLinks.dataSource);
  }

  Future<void> _openPrivacyPolicy(BuildContext context) async {
    await _openUrl(context, AppLinks.privacyPolicy);
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
