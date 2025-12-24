import 'package:equatable/equatable.dart';
import '../services/service_strings.dart';

/// Local notification type
enum NotificationType { outage, restored, scheduled, emergency }

/// Local notification model (distinct from Firebase push notifications)
class NotificationModel extends Equatable {
  /// Unique notification identifier
  final String id;

  /// Notification title
  final String title;

  /// Notification message content
  final String message;

  /// Type of notification
  final NotificationType type;

  /// Notification creation timestamp (stored as UTC, displayed as local)
  final DateTime timestamp;

  /// Whether notification has been read by user
  final bool isRead;

  /// Queue number this notification relates to (if applicable)
  /// Queue number this notification relates to (if applicable)
  final int? queueNumber;

  /// Whether this is an emergency notification
  bool get isEmergency => type == NotificationType.emergency;

  /// Whether this is a scheduled notification
  bool get isScheduled => type == NotificationType.scheduled;

  /// Whether notification is unread
  bool get isUnread => !isRead;

  /// Human-readable time display
  String get displayTime {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) return ServiceStrings.justNow;
    if (diff.inMinutes < 60) return '${diff.inMinutes} хв тому';
    if (diff.inHours < 24) return '${diff.inHours} год тому';
    return '${timestamp.day}.${timestamp.month}.${timestamp.year}';
  }

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.queueNumber,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'].toString(),
      title: json['title'] as String,
      message: json['message'] as String,
      type: _parseType(json['type'] as String?),
      // Parse as UTC and convert to local time
      timestamp: DateTime.parse(json['timestamp'] as String).toUtc().toLocal(),
      isRead: json['isRead'] as bool? ?? false,
      queueNumber: json['queueNumber'] as int?,
    );
  }

  /// Safely parses notification type from string
  static NotificationType _parseType(String? type) {
    switch (type?.toLowerCase()) {
      case 'outage':
        return NotificationType.outage;
      case 'restored':
        return NotificationType.restored;
      case 'scheduled':
        return NotificationType.scheduled;
      case 'emergency':
        return NotificationType.emergency;
      default:
        return NotificationType.outage;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'queueNumber': queueNumber,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    int? queueNumber,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      queueNumber: queueNumber ?? this.queueNumber,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    message,
    type,
    timestamp,
    isRead,
    queueNumber,
  ];
}
