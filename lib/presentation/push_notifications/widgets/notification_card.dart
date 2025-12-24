import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/utils/time_formatter.dart';
import '../../../data/models/firebase_notification_model.dart';
import '../extensions/notification_category_extension.dart';

/// Card displaying a single notification
class NotificationCard extends StatelessWidget {
  final FirebaseNotificationModel notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final category = notification.category;
    final icon = category.icon;
    final color = category.color;
    final backgroundColor = category.getBackgroundColor(context);

    return AppCard(
      color: backgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: AppTextStyles.heading3.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(notification.body, style: AppTextStyles.body),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Theme.of(
                        context,
                      ).iconTheme.color?.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      TimeFormatter.formatRelativeTime(notification.createdAt),
                      style: AppTextStyles.small.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
                if (notification.addresses.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  ...notification.addresses.map(
                    (address) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Theme.of(
                              context,
                            ).iconTheme.color?.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${address.city}, ${address.street}, ${address.houseNumber}',
                              style: AppTextStyles.small.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
