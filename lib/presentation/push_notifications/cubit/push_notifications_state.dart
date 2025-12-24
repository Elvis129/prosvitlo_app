part of 'push_notifications_cubit.dart';

/// Status of push notifications feature
enum PushNotificationsStatus {
  /// Initial state
  initial,

  /// Loading notifications
  loading,

  /// Notifications loaded successfully
  success,

  /// Error loading notifications
  error,

  /// Push notifications unavailable (disabled or not supported)
  unavailable,
}

/// State for push notifications feature
class PushNotificationsState extends Equatable {
  final PushNotificationsStatus status;
  final List<FirebaseNotificationModel> notifications;
  final List<UserAddressModel> userAddresses;
  final bool notificationsEnabled;
  final String? errorMessage;

  const PushNotificationsState({
    this.status = PushNotificationsStatus.initial,
    this.notifications = const [],
    this.userAddresses = const [],
    this.notificationsEnabled = true,
    this.errorMessage,
  });

  PushNotificationsState copyWith({
    PushNotificationsStatus? status,
    List<FirebaseNotificationModel>? notifications,
    List<UserAddressModel>? userAddresses,
    bool? notificationsEnabled,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PushNotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      userAddresses: userAddresses ?? this.userAddresses,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    notifications,
    userAddresses,
    notificationsEnabled,
    errorMessage,
  ];
}
