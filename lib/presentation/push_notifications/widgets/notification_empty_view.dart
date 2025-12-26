import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/extensions/localizations_extension.dart';

/// Empty state widget for notifications
class NotificationEmptyView extends StatelessWidget {
  const NotificationEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.notifications_off_outlined,
            size: 64,
            color: AppColors.slateGray400,
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            context.l10n.notificationsEmpty,
            textAlign: TextAlign.center,
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            context.l10n.notificationsStoragePeriod,
            style: AppTextStyles.body.copyWith(color: AppColors.slateGray500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
