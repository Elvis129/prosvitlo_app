import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

/// Power outage schedule model - represents a schedule image for a specific date
class ScheduleModel extends Equatable {
  /// Schedule identifier
  final String id;

  /// Date this schedule is for (date only, no time)
  final DateTime date;

  /// URL to schedule image
  final String imageUrl;

  /// Alternative text for image accessibility
  final String? altText;

  /// Schedule version identifier
  final String version;

  /// When this schedule was created
  final DateTime createdAt;

  /// When this schedule was last updated
  final DateTime updatedAt;

  /// Whether this schedule is for today
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Whether this schedule is for tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  /// Whether this schedule is in the past
  bool get isPast => date.isBefore(DateTime.now());

  /// @deprecated Use extension method formattedDate instead
  /// Formatted date for display
  String get formattedDate {
    return DateFormat('d MMMM yyyy', 'uk').format(date);
  }

  const ScheduleModel({
    required this.id,
    required this.date,
    required this.imageUrl,
    this.altText,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    // Clean empty altText to null
    final altTextRaw = json['alt_text'] as String?;
    final altText = (altTextRaw?.isEmpty ?? true) ? null : altTextRaw;

    return ScheduleModel(
      id: json['id'].toString(),
      // Parse as UTC and convert to local time
      date: DateTime.parse(json['date'] as String).toUtc().toLocal(),
      imageUrl: json['image_url'] as String,
      altText: altText,
      version: json['version'] as String,
      createdAt: DateTime.parse(json['created_at'] as String).toUtc().toLocal(),
      updatedAt: DateTime.parse(json['updated_at'] as String).toUtc().toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String().split('T')[0], // YYYY-MM-DD format
      'image_url': imageUrl,
      'alt_text': altText,
      'version': version,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    date,
    imageUrl,
    altText,
    version,
    createdAt,
    updatedAt,
  ];
}

/// Extension for formatting ScheduleModel data
extension ScheduleModelFormatting on ScheduleModel {
  /// Formatted date for display using intl package
  String get formattedDate {
    return DateFormat('d MMMM yyyy', 'uk').format(date);
  }
}
