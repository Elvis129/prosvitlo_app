import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/extensions/localizations_extension.dart';

/// Empty state widget when no schedules are available
class ScheduleEmptyView extends StatelessWidget {
  const ScheduleEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today,
            size: 64,
            color: isDark ? AppColors.slateGray400 : AppColors.slateGray500,
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.scheduleNotFound,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.scheduleNotFoundMessage,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
