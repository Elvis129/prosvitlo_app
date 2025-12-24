import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/address_with_status_model.dart';
import '../../../core/extensions/localizations_extension.dart';

/// Section showing scheduled outages for tomorrow
class TomorrowOutagesSection extends StatelessWidget {
  final AddressWithStatus addressWithStatus;

  const TomorrowOutagesSection({super.key, required this.addressWithStatus});

  @override
  Widget build(BuildContext context) {
    if (addressWithStatus.tomorrowStatus != null &&
        addressWithStatus.tomorrowStatus!.upcomingOutages.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 20,
                color: AppColors.slateGray,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                context.l10n.outageTomorrowTitle,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ...addressWithStatus.tomorrowStatus!.upcomingOutages
              .take(5)
              .map(
                (interval) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.primaryBlue.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.flash_off,
                          color: AppColors.primaryBlue,
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
    }
    return const SizedBox.shrink();
  }
}
