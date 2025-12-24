import '../../../data/models/address_with_status_model.dart';
import '../../../data/models/outage_status_model.dart';
import '../models/next_outage_model.dart';

/// Utility functions for finding and analyzing outages
class OutageUtils {
  /// Finds the current or next scheduled outage from a status
  ///
  /// Returns the current active outage if exists, otherwise returns the next upcoming one.
  /// Handles time properly to avoid midnight crossing issues.
  static OutageInterval? findCurrentOrNextScheduledOutage(
    OutageStatusModel status,
  ) {
    final now = DateTime.now();
    final currentHour = now.hour;
    final currentMinute = now.minute;
    final currentTimeInMinutes = currentHour * 60 + currentMinute;

    // First, find CURRENT active outage
    for (final interval in status.upcomingOutages) {
      final startTimeInMinutes = interval.startHour * 60;
      // Handle case where endHour might be 24 (normalize to 1440 minutes)
      final endHour = interval.endHour == 24 ? 24 : interval.endHour;
      final endTimeInMinutes = endHour * 60;

      if (currentTimeInMinutes >= startTimeInMinutes &&
          currentTimeInMinutes < endTimeInMinutes) {
        return interval; // Current active outage
      }
    }

    // If no current outage, find next upcoming one
    for (final interval in status.upcomingOutages) {
      final startTimeInMinutes = interval.startHour * 60;
      if (startTimeInMinutes > currentTimeInMinutes) {
        return interval; // Next upcoming outage
      }
    }

    return null; // No current or upcoming outages
  }

  /// Finds the next outage of any type (emergency, planned, or scheduled)
  ///
  /// Returns a strongly-typed NextOutage object.
  /// Properly handles time comparison and active/upcoming status.
  static NextOutage? findNextOutage(
    AddressWithStatus addressWithStatus,
    OutageStatusModel? status,
  ) {
    final now = DateTime.now();
    final currentTimeInMinutes = now.hour * 60 + now.minute;

    // Collect all possible outages with their start times
    final List<NextOutage> allOutages = [];

    // Add active emergency outages (already ongoing)
    if (addressWithStatus.outages != null) {
      for (final outage in addressWithStatus.outages!.activeEmergency) {
        allOutages.add(
          EmergencyOutage(
            outage: outage,
            time: outage.startTime,
            isActive: true,
          ),
        );
      }

      // Add active planned outages (already ongoing)
      for (final outage in addressWithStatus.outages!.activePlanned) {
        allOutages.add(
          PlannedOutage(outage: outage, time: outage.startTime, isActive: true),
        );
      }

      // Add upcoming emergency outages
      for (final outage in addressWithStatus.outages!.upcomingEmergency) {
        allOutages.add(
          EmergencyOutage(
            outage: outage,
            time: outage.startTime,
            isActive: false,
          ),
        );
      }

      // Add upcoming planned outages
      for (final outage in addressWithStatus.outages!.upcomingPlanned) {
        allOutages.add(
          PlannedOutage(
            outage: outage,
            time: outage.startTime,
            isActive: false,
          ),
        );
      }
    }

    // Add scheduled outages
    if (status != null && status.upcomingOutages.isNotEmpty) {
      final scheduleInterval = findCurrentOrNextScheduledOutage(status);
      if (scheduleInterval != null) {
        // Create DateTime for scheduled outage (today)
        // Handle midnight crossing: if startHour >= 24, add a day
        final startHourNormalized = scheduleInterval.startHour.toInt();
        final scheduleTime = DateTime(
          now.year,
          now.month,
          now.day,
          startHourNormalized % 24,
        );

        final startTimeInMinutes = scheduleInterval.startHour * 60;
        final isActive =
            currentTimeInMinutes >= startTimeInMinutes &&
            currentTimeInMinutes < scheduleInterval.endHour * 60;

        allOutages.add(
          ScheduleOutage(
            interval: scheduleInterval,
            time: scheduleTime,
            isActive: isActive,
          ),
        );
      }
    }

    // If no outages
    if (allOutages.isEmpty) return null;

    // Sort by start time
    allOutages.sort((a, b) => a.time.compareTo(b.time));

    // Return the nearest one
    return allOutages.first;
  }
}
