import 'package:flutter/material.dart';
import '../../../core/extensions/localizations_extension.dart';

/// Header showing last update time
class ScheduleUpdateHeader extends StatelessWidget {
  final DateTime lastUpdated;

  const ScheduleUpdateHeader({super.key, required this.lastUpdated});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.access_time,
            size: 14,
            color: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 4),
          Text(
            context.l10n.scheduleUpdated(
              _formatLastUpdated(context, lastUpdated),
            ),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Formats last update time in human-readable format
  String _formatLastUpdated(BuildContext context, DateTime lastUpdated) {
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);

    if (difference.inMinutes < 1) {
      return context.l10n.scheduleUpdateTime;
    } else if (difference.inMinutes < 60) {
      return context.l10n.scheduleUpdatedMinutesAgo(difference.inMinutes);
    } else if (difference.inHours < 24) {
      return context.l10n.scheduleUpdatedHoursAgo(difference.inHours);
    } else {
      return context.l10n.scheduleUpdatedDaysAgo(difference.inDays);
    }
  }
}
