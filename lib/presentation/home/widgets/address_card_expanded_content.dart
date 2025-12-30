import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/address_with_status_model.dart';
import '../../../data/models/outage_status_model.dart';
import '../../../core/utils/time_formatter.dart';
import '../../../core/extensions/localizations_extension.dart';
import 'outage_section_card.dart';
import 'scheduled_outages_section.dart';
import 'tomorrow_outages_section.dart';

/// Expanded content section of the address card
class AddressCardExpandedContent extends StatelessWidget {
  final AddressWithStatus addressWithStatus;
  final OutageStatusModel? status;
  final bool isPowerOff;
  final Color statusColor;
  final bool hasActiveScheduledOutage;

  const AddressCardExpandedContent({
    super.key,
    required this.addressWithStatus,
    required this.status,
    required this.isPowerOff,
    required this.statusColor,
    required this.hasActiveScheduledOutage,
  });

  @override
  Widget build(BuildContext context) {
    final address = addressWithStatus.address;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Address
        Row(
          children: [
            const Icon(Icons.location_on, size: 20, color: AppColors.slateGray),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(address.fullAddress, style: AppTextStyles.body),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),

        // Queue
        Row(
          children: [
            const Icon(Icons.numbers, size: 20, color: AppColors.slateGray),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: AutoSizeText(
                maxLines: 2,
                minFontSize: 10,
                context.l10n.addressQueue(address.queue),
                style: AppTextStyles.body,
              ),
            ),
          ],
        ),

        if (status != null) ...[
          const SizedBox(height: AppSpacing.lg),
          const Divider(),
          const SizedBox(height: AppSpacing.md),

          // Status type
          Row(
            children: [
              Icon(
                isPowerOff ? Icons.report_problem : Icons.check_circle_outline,
                size: 20,
                color: statusColor,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AutoSizeText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  isPowerOff
                      ? context.l10n.outageTypePlannedOutage
                      : context.l10n.outageTypeActiveSupply,
                  style: AppTextStyles.body.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Update time
          if (status!.lastUpdated != null) ...[
            Row(
              children: [
                const Icon(Icons.update, size: 20, color: AppColors.slateGray),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AutoSizeText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    context.l10n.lastUpdated(
                      TimeFormatter.formatDateTime(status!.lastUpdated!),
                    ),
                    style: AppTextStyles.small.copyWith(
                      color: AppColors.slateGray,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
          ],

          // Notes (only show if there are no active outages)
          // Don't show generic status notes when there's any active outage,
          // as they may be contradictory (e.g., "power on" during actual outage)
          if (status!.notes != null &&
              !hasActiveScheduledOutage &&
              (addressWithStatus.outages?.activeEmergency.isEmpty ?? true) &&
              (addressWithStatus.outages?.activePlanned.isEmpty ?? true)) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(status!.notes!, style: AppTextStyles.body),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],

          // Today's outages
          ScheduledOutagesSection(status: status!, isPowerOff: isPowerOff),

          // Tomorrow's outages
          TomorrowOutagesSection(addressWithStatus: addressWithStatus),

          // Emergency outages
          if (addressWithStatus.outages?.hasEmergencyOutage ?? false)
            OutageSectionCard(
              title: context.l10n.outageEmergencyTitle,
              icon: Icons.warning,
              color: AppColors.error,
              outages: [
                ...addressWithStatus.outages!.activeEmergency,
                ...addressWithStatus.outages!.upcomingEmergency,
              ],
              showActiveBadge:
                  addressWithStatus.outages!.activeEmergency.isNotEmpty,
            ),

          // Planned outages
          if (addressWithStatus.outages?.hasPlannedOutage ?? false)
            OutageSectionCard(
              title: context.l10n.outagePlannedTitle,
              icon: Icons.info_outline,
              color: AppColors.primaryBlue,
              outages: [
                ...addressWithStatus.outages!.activePlanned,
                ...addressWithStatus.outages!.upcomingPlanned,
              ],
              showActiveBadge:
                  addressWithStatus.outages!.activePlanned.isNotEmpty,
            ),
        ],
      ],
    );
  }
}
