import 'package:flutter/material.dart';
import '../../../data/models/outage_info_model.dart';
import '../../../data/models/outage_status_model.dart';
import '../../../core/extensions/localizations_extension.dart';

/// Represents the next upcoming outage of any type
sealed class NextOutage {
  final DateTime time;
  final bool isActive;

  const NextOutage({required this.time, required this.isActive});

  /// Gets display label for the outage type
  String typeLabel(BuildContext context);

  /// Gets the time range string
  String getTimeRange();
}

/// Emergency outage
class EmergencyOutage extends NextOutage {
  final OutageInfoModel outage;

  const EmergencyOutage({
    required this.outage,
    required super.time,
    required super.isActive,
  });

  @override
  String typeLabel(BuildContext context) => context.l10n.outageTypeEmergency;

  @override
  String getTimeRange() => outage.getTimeRange();
}

/// Planned outage
class PlannedOutage extends NextOutage {
  final OutageInfoModel outage;

  const PlannedOutage({
    required this.outage,
    required super.time,
    required super.isActive,
  });

  @override
  String typeLabel(BuildContext context) => context.l10n.outageTypePlanned;

  @override
  String getTimeRange() => outage.getTimeRange();
}

/// Schedule-based outage
class ScheduleOutage extends NextOutage {
  final OutageInterval interval;

  const ScheduleOutage({
    required this.interval,
    required super.time,
    required super.isActive,
  });

  @override
  String typeLabel(BuildContext context) => context.l10n.outageTypeScheduled;

  @override
  String getTimeRange() {
    return '${interval.startHour.toString().padLeft(2, '0')}:00 - '
        '${interval.endHour.toString().padLeft(2, '0')}:00';
  }
}
