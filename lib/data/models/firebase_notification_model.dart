import 'dart:convert';
import 'package:equatable/equatable.dart';

/// Notification type - defines target audience
enum NotificationType {
  /// Notification for all users
  all,

  /// Notification for specific addresses
  address;

  /// Parses string value to NotificationType
  static NotificationType fromString(String value) {
    return NotificationType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => NotificationType.all,
    );
  }
}

/// Notification category - defines the type of information
enum NotificationCategory {
  /// General information
  general,

  /// Power outage notification
  outage,

  /// Power restored notification
  restored,

  /// Scheduled outage notification
  scheduled,

  /// Emergency outage notification
  emergency;

  /// Parses string value to NotificationCategory
  static NotificationCategory fromString(String value) {
    return NotificationCategory.values.firstWhere(
      (e) => e.name == value,
      orElse: () => NotificationCategory.general,
    );
  }
}

/// Firebase notification model from backend
class FirebaseNotificationModel extends Equatable {
  /// Notification ID (backend generated)
  final int id;

  /// Target audience type
  final NotificationType notificationType;

  /// Category of notification
  final NotificationCategory category;

  /// Notification title
  final String title;

  /// Notification body text
  final String body;

  /// Additional data payload
  final Map<String, dynamic>? data;

  /// Target addresses (empty if for all users)
  final List<NotificationAddress> addresses;

  /// Notification creation timestamp
  /// Notification creation timestamp
  final DateTime createdAt;

  /// Whether this notification is for all users
  bool get isForAll => notificationType == NotificationType.all;

  /// Whether this notification has specific addresses
  bool get hasAddresses => addresses.isNotEmpty;

  /// Whether this is an emergency notification
  bool get isEmergency => category == NotificationCategory.emergency;

  const FirebaseNotificationModel({
    required this.id,
    required this.notificationType,
    required this.category,
    required this.title,
    required this.body,
    this.data,
    this.addresses = const [],
    required this.createdAt,
  });

  factory FirebaseNotificationModel.fromJson(Map<String, dynamic> json) {
    final createdAtStr = json['created_at'] as String;
    final parsedTime = DateTime.parse(createdAtStr).toLocal();

    // Parse data field - backend may send it as String or Map
    Map<String, dynamic>? parsedData;
    if (json['data'] != null) {
      final dataValue = json['data'];
      if (dataValue is String) {
        // If data is a String, decode it to Map
        try {
          parsedData = jsonDecode(dataValue) as Map<String, dynamic>;
        } catch (e) {
          // If decoding fails, set to null
          parsedData = null;
        }
      } else if (dataValue is Map) {
        // If data is already a Map, use it directly
        parsedData = Map<String, dynamic>.from(dataValue);
      }
    }

    return FirebaseNotificationModel(
      id: json['id'] as int,
      notificationType: NotificationType.fromString(
        json['notification_type'] as String,
      ),
      category: NotificationCategory.fromString(
        json['category'] as String? ?? 'general',
      ),
      title: json['title'] as String,
      body: json['body'] as String,
      data: parsedData,
      addresses: (json['addresses'] as List<dynamic>? ?? [])
          .map((a) => NotificationAddress.fromJson(a as Map<String, dynamic>))
          .toList(),
      // Parse datetime - backend sends UTC, convert to local time for correct time difference calculations
      createdAt: parsedTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'notification_type': notificationType.name,
      'category': category.name,
      'title': title,
      'body': body,
      'data': data,
      'addresses': addresses.map((a) => a.toJson()).toList(),
      // Always save as UTC to maintain consistency with backend format
      'created_at': createdAt.toUtc().toIso8601String(),
    };
  }

  /// Creates a copy with updated fields
  FirebaseNotificationModel copyWith({
    int? id,
    NotificationType? notificationType,
    NotificationCategory? category,
    String? title,
    String? body,
    Map<String, dynamic>? data,
    List<NotificationAddress>? addresses,
    DateTime? createdAt,
  }) {
    return FirebaseNotificationModel(
      id: id ?? this.id,
      notificationType: notificationType ?? this.notificationType,
      category: category ?? this.category,
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
      addresses: addresses ?? this.addresses,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    notificationType,
    category,
    title,
    body,
    data,
    addresses,
    createdAt,
  ];
}

/// Address in notification - represents a target address for notification
class NotificationAddress extends Equatable {
  /// City name
  final String city;

  /// Street name
  final String street;

  /// House number (kept as houseNumber for Firebase API compatibility)
  final String houseNumber;

  const NotificationAddress({
    required this.city,
    required this.street,
    required this.houseNumber,
  });

  factory NotificationAddress.fromJson(Map<String, dynamic> json) {
    return NotificationAddress(
      city: json['city'] as String,
      street: json['street'] as String,
      houseNumber: json['house_number'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'city': city, 'street': street, 'house_number': houseNumber};
  }

  @override
  List<Object?> get props => [city, street, houseNumber];
}

/// User's saved address model for push notifications
class UserAddressModel extends Equatable {
  /// Address ID (backend generated)
  final int id;

  /// Device identifier
  final String deviceId;

  /// City name
  final String city;

  /// Street name
  final String street;

  /// House number (kept as houseNumber for Firebase API compatibility)
  final String houseNumber;

  /// Address creation timestamp (stored as UTC, parsed as local)
  final DateTime createdAt;

  const UserAddressModel({
    required this.id,
    required this.deviceId,
    required this.city,
    required this.street,
    required this.houseNumber,
    required this.createdAt,
  });

  factory UserAddressModel.fromJson(Map<String, dynamic> json) {
    return UserAddressModel(
      id: json['id'] as int,
      deviceId: json['device_id'] as String,
      city: json['city'] as String,
      street: json['street'] as String,
      houseNumber: json['house_number'] as String,
      // Parse as UTC and convert to local time
      createdAt: DateTime.parse(json['created_at'] as String).toUtc().toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device_id': deviceId,
      'city': city,
      'street': street,
      'house_number': houseNumber,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    deviceId,
    city,
    street,
    houseNumber,
    createdAt,
  ];
}
