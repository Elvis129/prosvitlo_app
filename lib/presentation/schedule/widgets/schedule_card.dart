import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/schedule_model.dart';
import 'schedule_image.dart';

/// Card displaying a single schedule with date and image
class ScheduleCard extends StatelessWidget {
  final ScheduleModel schedule;
  final VoidCallback onImageTap;

  const ScheduleCard({
    super.key,
    required this.schedule,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with date
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.primaryBlue.withValues(alpha: 0.2)
                  : AppColors.primaryBlue.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: AppColors.primaryBlue,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  schedule.formattedDate,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textLight : AppColors.primaryBlue,
                  ),
                ),
                if (schedule.altText != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    '(${schedule.altText})',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.textLightSecondary
                          : AppColors.slateGray500,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Schedule image
          Hero(
            tag: 'schedule_${schedule.imageUrl}',
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: GestureDetector(
                onTap: onImageTap,
                child: ScheduleImage(imageUrl: schedule.imageUrl),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
