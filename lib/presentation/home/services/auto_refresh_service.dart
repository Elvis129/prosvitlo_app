import 'dart:async';
import '../../../data/models/address_with_status_model.dart';

/// Service for calculating and scheduling automatic data refreshes
/// based on outage end times
class AutoRefreshService {
  Timer? _timer;

  /// Calculates the next refresh time based on upcoming outage end times
  ///
  /// Finds the nearest outage end time across all addresses and returns
  /// a DateTime representing when the next refresh should occur.
  ///
  /// Returns null if no upcoming outages are found.
  ///
  /// ⚠️ Assumptions:
  /// - All times are in local timezone
  /// - Outages don't cross midnight (endHour is within same day)
  /// - If current hour > endHour, outage is considered completed
  DateTime? calculateNextRefresh(List<AddressWithStatus> addresses) {
    DateTime? nextEndTime;
    final now = DateTime.now();
    final currentHour = now.hour + now.minute / 60.0;

    for (final addressWithStatus in addresses) {
      final status = addressWithStatus.status;
      if (status == null || status.upcomingOutages.isEmpty) continue;

      for (final outage in status.upcomingOutages) {
        final endHour = outage.endHour.toDouble();

        // Skip if outage already ended today
        if (currentHour >= endHour) continue;

        // Calculate end time for today
        final endTime = DateTime(
          now.year,
          now.month,
          now.day,
          outage.endHour,
          0,
        );

        // Update if this is earlier than current nextEndTime
        if (nextEndTime == null || endTime.isBefore(nextEndTime)) {
          nextEndTime = endTime;
        }
      }
    }

    // Add 1 minute buffer after outage ends
    if (nextEndTime != null) {
      return nextEndTime.add(const Duration(minutes: 1));
    }

    return null;
  }

  /// Schedules a refresh callback at the calculated next refresh time
  ///
  /// Automatically cancels any previously scheduled refresh.
  /// If no refresh time can be calculated, no timer is set.
  void scheduleRefresh(
    List<AddressWithStatus> addresses,
    void Function() onRefresh,
  ) {
    cancelScheduledRefresh();

    final nextRefreshTime = calculateNextRefresh(addresses);
    if (nextRefreshTime == null) return;

    final now = DateTime.now();
    final duration = nextRefreshTime.difference(now);

    if (duration.inSeconds > 0) {
      _timer = Timer(duration, onRefresh);
    }
  }

  /// Cancels any currently scheduled refresh
  void cancelScheduledRefresh() {
    _timer?.cancel();
    _timer = null;
  }

  /// Disposes the service and cancels any pending timers
  void dispose() {
    cancelScheduledRefresh();
  }
}
