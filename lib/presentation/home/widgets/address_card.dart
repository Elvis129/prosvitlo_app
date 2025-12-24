import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/address_with_status_model.dart';
import '../../../data/models/outage_status_model.dart';
import 'address_card_header.dart';
import 'address_card_expanded_content.dart';

/// Card displaying address with power status and outages
class AddressCard extends StatelessWidget {
  final AddressWithStatus addressWithStatus;
  final bool isExpanded;

  const AddressCard({
    super.key,
    required this.addressWithStatus,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    final status = addressWithStatus.status;
    final isLoading = addressWithStatus.isLoading;

    // Check if there are any active outages (emergency or planned)
    final hasActiveOutages =
        addressWithStatus.outages?.hasAnyActiveOutage ?? false;

    // Check if there's an active scheduled outage right now
    final hasActiveScheduledOutage = status?.hasActiveScheduledOutage ?? false;

    // Power is on only if status is 'on' AND there are no active outages AND no active scheduled outages
    final bool hasPower =
        status?.status == PowerStatus.on &&
        !hasActiveOutages &&
        !hasActiveScheduledOutage;
    final bool isPowerOff =
        status?.status == PowerStatus.off ||
        hasActiveOutages ||
        hasActiveScheduledOutage;

    final Color statusColor = hasPower
        ? AppColors.success
        : isPowerOff
        ? AppColors.error
        : AppColors.warning;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card header (always visible)
              AddressCardHeader(
                addressWithStatus: addressWithStatus,
                status: status,
                isLoading: isLoading,
                isPowerOff: isPowerOff,
                isExpanded: isExpanded,
                statusColor: statusColor,
              ),

              // Expanded information
              if (isExpanded) ...[
                const SizedBox(height: AppSpacing.lg),
                const Divider(),
                const SizedBox(height: AppSpacing.md),
                AddressCardExpandedContent(
                  addressWithStatus: addressWithStatus,
                  status: status,
                  isPowerOff: isPowerOff,
                  statusColor: statusColor,
                  hasActiveScheduledOutage: hasActiveScheduledOutage,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
