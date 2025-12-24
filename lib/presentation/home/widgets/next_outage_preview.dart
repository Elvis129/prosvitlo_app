import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/address_with_status_model.dart';
import '../../../data/models/outage_status_model.dart';
import '../utils/outage_utils.dart';
import '../models/next_outage_model.dart';

/// Widget showing preview of the next outage in collapsed card view
class NextOutagePreview extends StatelessWidget {
  final AddressWithStatus addressWithStatus;
  final OutageStatusModel status;

  const NextOutagePreview({
    super.key,
    required this.addressWithStatus,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final nextOutage = OutageUtils.findNextOutage(addressWithStatus, status);

    if (nextOutage == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          // Outage type badge
          _OutageTypeBadge(outage: nextOutage),
          const SizedBox(width: 4),

          // Time/date of outage
          Expanded(child: _OutageTimeText(outage: nextOutage)),
        ],
      ),
    );
  }
}

/// Badge showing the type of outage (emergency, planned, or schedule)
class _OutageTypeBadge extends StatelessWidget {
  final NextOutage outage;

  const _OutageTypeBadge({required this.outage});

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    if (outage is EmergencyOutage) {
      badgeColor = AppColors.error;
    } else if (outage is PlannedOutage) {
      badgeColor = AppColors.primaryBlue;
    } else {
      badgeColor = AppColors.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        outage.typeLabel(context),
        style: AppTextStyles.small.copyWith(
          color: badgeColor,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }
}

/// Text showing the time or date+time of the outage
class _OutageTimeText extends StatelessWidget {
  final NextOutage outage;

  const _OutageTimeText({required this.outage});

  @override
  Widget build(BuildContext context) {
    if (outage is ScheduleOutage) {
      // For schedule - only time
      return Text(
        outage.getTimeRange(),
        style: AppTextStyles.small.copyWith(color: AppColors.slateGray),
      );
    } else {
      // For emergency/planned - date and time
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final outageDate = DateTime(
        outage.time.year,
        outage.time.month,
        outage.time.day,
      );

      String datePrefix = '';
      if (outageDate.isAfter(today)) {
        // If not today - show date
        datePrefix =
            '${outage.time.day.toString().padLeft(2, '0')}.${outage.time.month.toString().padLeft(2, '0')} ';
      }

      return Text(
        '$datePrefix${outage.getTimeRange()}',
        style: AppTextStyles.small.copyWith(color: AppColors.slateGray),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
  }
}
