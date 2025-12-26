import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/extensions/localizations_extension.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/address_with_status_model.dart';
import '../../../data/models/outage_status_model.dart';
import '../../../core/utils/time_formatter.dart';
import '../viewmodel/home_cubit.dart';
import 'next_outage_preview.dart';

/// Header of the address card with status icon, address name, and expand button
class AddressCardHeader extends StatelessWidget {
  final AddressWithStatus addressWithStatus;
  final OutageStatusModel? status;
  final bool isLoading;
  final bool isPowerOff;
  final bool isExpanded;
  final Color statusColor;

  const AddressCardHeader({
    super.key,
    required this.addressWithStatus,
    required this.status,
    required this.isLoading,
    required this.isPowerOff,
    required this.isExpanded,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    final address = addressWithStatus.address;

    return Row(
      children: [
        // Status icon
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isPowerOff ? Icons.power_off : Icons.power,
            color: statusColor,
            size: 24,
          ),
        ),
        const SizedBox(width: AppSpacing.md),

        // Address info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                address.name,
                style: AppTextStyles.heading3.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 4),
              if (isLoading)
                const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else if (status != null) ...[
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      isPowerOff
                          ? context.l10n.homePowerOff
                          : context.l10n.homePowerOn,
                      style: AppTextStyles.heading3.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // Last updated time
                    if (addressWithStatus.lastUpdated != null) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 12,
                            color: AppColors.slateGray,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            TimeFormatter.formatRelativeTime(
                              addressWithStatus.lastUpdated!,
                            ),
                            style: AppTextStyles.small.copyWith(
                              color: AppColors.slateGray,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                // Show next outage time in collapsed view
                if (!isExpanded)
                  NextOutagePreview(
                    addressWithStatus: addressWithStatus,
                    status: status!,
                  ),
              ],
            ],
          ),
        ),

        // Expand/collapse button
        IconButton(
          onPressed: () {
            context.read<HomeCubit>().toggleExpanded(address.id);
          },
          icon: Icon(
            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: AppColors.slateGray,
          ),
        ),
      ],
    );
  }
}
