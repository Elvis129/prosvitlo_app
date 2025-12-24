import 'package:equatable/equatable.dart';

/// Emergency or planned power outage information model
class OutageInfoModel extends Equatable {
  /// Outage identifier
  final String id;

  /// Name of responsible entity (REM)
  final String remName;

  /// City name
  final String city;

  /// Street name
  final String street;

  /// Affected house numbers
  final String houseNumbers;

  /// Type of work being performed
  final String workType;

  /// Date when outage was created/announced
  final DateTime createdDate;

  /// Outage start time
  final DateTime startTime;

  /// Outage end time
  /// Outage end time
  final DateTime endTime;

  /// Whether the outage is currently active
  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  /// Whether the outage is upcoming (hasn't started yet)
  bool get isUpcoming => DateTime.now().isBefore(startTime);

  /// Whether the outage is finished
  bool get isFinished => DateTime.now().isAfter(endTime);

  /// Full address string
  String get fullAddress => '$city, $street ($houseNumbers)';

  /// Outage duration
  Duration get duration => endTime.difference(startTime);

  /// @deprecated Use extension method timeRange instead
  /// Formats time range in readable format
  String getTimeRange() {
    final startFormatted =
        '${startTime.day.toString().padLeft(2, '0')}.${startTime.month.toString().padLeft(2, '0')} ${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
    final endFormatted =
        '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
    return '$startFormatted - $endFormatted';
  }

  const OutageInfoModel({
    required this.id,
    required this.remName,
    required this.city,
    required this.street,
    required this.houseNumbers,
    required this.workType,
    required this.createdDate,
    required this.startTime,
    required this.endTime,
  });

  factory OutageInfoModel.fromJson(Map<String, dynamic> json) {
    return OutageInfoModel(
      id: json['id'].toString(),
      remName: json['rem_name'] as String,
      city: json['city'] as String,
      street: json['street'] as String,
      houseNumbers: json['house_numbers'] as String,
      workType: json['work_type'] as String,
      // Parse as UTC and convert to local time
      createdDate: DateTime.parse(
        json['created_date'] as String,
      ).toUtc().toLocal(),
      startTime: DateTime.parse(json['start_time'] as String).toUtc().toLocal(),
      endTime: DateTime.parse(json['end_time'] as String).toUtc().toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rem_name': remName,
      'city': city,
      'street': street,
      'house_numbers': houseNumbers,
      'work_type': workType,
      'created_date': createdDate.toIso8601String(),
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    remName,
    city,
    street,
    houseNumbers,
    workType,
    createdDate,
    startTime,
    endTime,
  ];
}

/// Extension for formatting OutageInfoModel data
extension OutageInfoFormatting on OutageInfoModel {
  /// Formats time range in readable format
  String get timeRange {
    final start = startTime;
    final end = endTime;
    return '${_formatDate(start)} ${_formatTime(start)} - ${_formatTime(end)}';
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}';

  String _formatTime(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}
