import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Widget displayed when push notifications are unavailable
class NotificationUnavailableView extends StatelessWidget {
  const NotificationUnavailableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.notifications_off_outlined,
              size: 80,
              color: AppColors.slateGray400,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Push Notifications Unavailable',
              style: AppTextStyles.heading2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Push notifications are currently disabled or not supported on this device.',
              style: AppTextStyles.body.copyWith(color: AppColors.slateGray500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'To enable notifications, please check your device settings.',
              style: AppTextStyles.body.copyWith(color: AppColors.slateGray500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
