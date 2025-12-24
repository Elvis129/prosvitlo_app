import 'package:equatable/equatable.dart';

/// Power status enum
enum PowerStatus { on, off, unknown }

/// Represents a time interval during which power outage is scheduled
class OutageInterval extends Equatable {
  /// Start hour of outage (0-23)
  final int startHour;

  /// End hour of outage (0-23)
  final int endHour;

  /// Display label for this interval
  final String label;

  const OutageInterval({
    required this.startHour,
    required this.endHour,
    required this.label,
  });

  factory OutageInterval.fromJson(Map<String, dynamic> json) {
    return OutageInterval(
      startHour: (json['start_hour'] as num).toInt(),
      endHour: (json['end_hour'] as num).toInt(),
      label: json['label'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'start_hour': startHour, 'end_hour': endHour, 'label': label};
  }

  @override
  List<Object?> get props => [startHour, endHour, label];
}

/// Power outage status for a specific address
class OutageStatusModel extends Equatable {
  /// Static regex patterns for parsing queue numbers (optimization)
  static final _queueWithSubRegex = RegExp(r'(\d+)\.(\d+)');
  static final _queueSimpleRegex = RegExp(r'(\d+)');

  /// Address identifier this status belongs to
  final String addressId;

  /// Current power status
  final PowerStatus status;

  /// Queue identifier (e.g., "6.2. підчерга")
  final String queue;

  /// Last update timestamp
  final DateTime? lastUpdated;

  /// Additional notes or comments
  final String? notes;

  /// Source URL for this status information
  final String? sourceUrl;

  /// List of upcoming scheduled outages
  /// List of upcoming scheduled outages
  final List<OutageInterval> upcomingOutages;

  /// Whether power is currently on
  bool get isPowerOn => status == PowerStatus.on;

  /// Whether power is currently off
  bool get isPowerOff => status == PowerStatus.off;

  /// Whether there are upcoming outages scheduled
  bool get hasUpcomingOutages => upcomingOutages.isNotEmpty;

  /// Check if there's an active outage interval right now
  bool get hasActiveScheduledOutage {
    if (upcomingOutages.isEmpty) return false;

    final now = DateTime.now();
    final currentHour = now.hour;

    return upcomingOutages.any((interval) {
      // Check if current hour is within the outage interval
      if (interval.startHour <= interval.endHour) {
        // Same day interval (e.g., 10-14)
        return currentHour >= interval.startHour &&
            currentHour < interval.endHour;
      } else {
        // Overnight interval (e.g., 22-02)
        return currentHour >= interval.startHour ||
            currentHour < interval.endHour;
      }
    });
  }

  const OutageStatusModel({
    required this.addressId,
    required this.status,
    required this.queue,
    this.lastUpdated,
    this.notes,
    this.sourceUrl,
    this.upcomingOutages = const [],
  });

  /// Extracts main queue number from queue string
  /// Examples: "6.2" -> 6, "3 черга" -> 3
  int get queueNumber {
    final match = _queueWithSubRegex.firstMatch(queue);
    if (match != null) {
      return int.parse(match.group(1) ?? '0');
    }
    final simpleMatch = _queueSimpleRegex.firstMatch(queue);
    return int.parse(simpleMatch?.group(1) ?? '0');
  }

  /// Creates OutageStatusModel from JSON
  /// Handles both 'on'/'off' and 'active'/'inactive' status values for API compatibility
  factory OutageStatusModel.fromJson(Map<String, dynamic> json) {
    final upcomingList = json['upcomingOutages'] as List<dynamic>? ?? [];
    return OutageStatusModel(
      addressId: json['addressId'] as String,
      status: _parseStatus(json['status'] as String?),
      queue: json['queue'] as String,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String).toUtc().toLocal()
          : null,
      notes: json['notes'] as String?,
      sourceUrl: json['sourceUrl'] as String?,
      upcomingOutages: upcomingList
          .map((e) => OutageInterval.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Parses power status from string
  /// Accepts: 'on', 'active' -> PowerStatus.on
  ///          'off', 'inactive' -> PowerStatus.off
  ///          anything else -> PowerStatus.unknown
  static PowerStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'on':
      case 'active':
        return PowerStatus.on;
      case 'off':
      case 'inactive':
        return PowerStatus.off;
      default:
        return PowerStatus.unknown;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'addressId': addressId,
      'status': status.name,
      'queue': queue,
      'lastUpdated': lastUpdated?.toIso8601String(),
      'notes': notes,
      'sourceUrl': sourceUrl,
      'upcomingOutages': upcomingOutages.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
    addressId,
    status,
    queue,
    lastUpdated,
    notes,
    sourceUrl,
    upcomingOutages,
  ];
}
