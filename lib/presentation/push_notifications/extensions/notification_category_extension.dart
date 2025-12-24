import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/firebase_notification_model.dart';

/// Extension for NotificationCategory with UI helpers
extension NotificationCategoryExtension on NotificationCategory {
  /// Returns icon for this category
  IconData get icon {
    switch (this) {
      case NotificationCategory.outage:
        return Icons.flash_off;
      case NotificationCategory.restored:
        return Icons.flash_on;
      case NotificationCategory.scheduled:
        return Icons.schedule;
      case NotificationCategory.emergency:
        return Icons.warning;
      case NotificationCategory.general:
        return Icons.notifications;
    }
  }

  /// Returns primary color for this category
  Color get color {
    switch (this) {
      case NotificationCategory.outage:
        return AppColors.error;
      case NotificationCategory.restored:
        return AppColors.success;
      case NotificationCategory.scheduled:
        return AppColors.primaryBlue;
      case NotificationCategory.emergency:
        return AppColors.warning;
      case NotificationCategory.general:
        return AppColors.slateGray500;
    }
  }

  /// Returns background color for this category based on theme
  Color getBackgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (this) {
      case NotificationCategory.outage:
        return isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : AppColors.error.withValues(alpha: 0.08);
      case NotificationCategory.restored:
        return isDark
            ? AppColors.success.withValues(alpha: 0.15)
            : AppColors.success.withValues(alpha: 0.08);
      case NotificationCategory.scheduled:
        return isDark
            ? AppColors.primaryBlue.withValues(alpha: 0.15)
            : AppColors.primaryBlue50;
      case NotificationCategory.emergency:
        return isDark
            ? AppColors.warning.withValues(alpha: 0.15)
            : AppColors.warning.withValues(alpha: 0.08);
      case NotificationCategory.general:
        return isDark
            ? AppColors.slateGray700.withValues(alpha: 0.3)
            : AppColors.slateGray200.withValues(alpha: 0.5);
    }
  }
}
