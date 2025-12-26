import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/outage_status_model.dart';
import '../../../core/extensions/localizations_extension.dart';

/// Section showing scheduled outages for today
class ScheduledOutagesSection extends StatelessWidget {
  final OutageStatusModel status;
  final bool isPowerOff;

  const ScheduledOutagesSection({
    super.key,
    required this.status,
    required this.isPowerOff,
  });

  @override
  Widget build(BuildContext context) {
    if (status.upcomingOutages.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const Icon(Icons.schedule, size: 20, color: AppColors.slateGray),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AutoSizeText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  context.l10n.outageTodayTitle,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ...status.upcomingOutages
              .take(5)
              .map(
                (interval) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.warning.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.flash_off,
                          color: AppColors.warning,
                          size: 18,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            interval.label,
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        ],
      );
    } else if (isPowerOff) {
      // Show "no more outages today" message if power is currently off
      return Column(
        children: [
          const Divider(),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.success,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    context.l10n.outageNoMoreToday,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
