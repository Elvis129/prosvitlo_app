import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../data/models/firebase_notification_model.dart';
import '../../../data/repositories/firebase_push_repository.dart';
import '../../../data/services/firebase_messaging_service.dart';
import '../../../data/services/log_color.dart';

part 'push_notifications_state.dart';

/// Cubit for managing push notifications
class PushNotificationsCubit extends Cubit<PushNotificationsState> {
  final FirebasePushRepository? _repository;
  final FirebaseMessagingService? _messagingService;

  PushNotificationsCubit({
    required FirebasePushRepository? repository,
    required FirebaseMessagingService? messagingService,
  }) : _repository = repository,
       _messagingService = messagingService,
       super(const PushNotificationsState());

  /// Initialize Firebase Messaging
  Future<void> initialize() async {
    // If Firebase is unavailable, set unavailable status
    if (_repository == null || _messagingService == null) {
      emit(
        state.copyWith(
          status: PushNotificationsStatus.unavailable,
          notificationsEnabled: false,
        ),
      );
      return;
    }

    try {
      emit(state.copyWith(status: PushNotificationsStatus.loading));

      // Initialize Firebase Messaging
      await _messagingService.initialize();

      // Register token on backend (with timeout)
      try {
        await _repository.registerToken().timeout(
          const Duration(seconds: 5),
          onTimeout: () {},
        );
      } catch (e) {
        logWarning('Token registration failed: $e');
      }

      // Load notification history (from local cache if backend unavailable)
      try {
        await loadNotifications();
      } catch (e) {
        logWarning('Failed to load notifications: $e');
      }

      // Load saved addresses (from local cache if backend unavailable)
      try {
        await loadUserAddresses();
      } catch (e) {
        logWarning('Failed to load user addresses: $e');
      }

      // Listen to new messages
      _messagingService.onMessage.listen(_handleNewMessage);

      // Listen to token refresh
      _messagingService.onTokenRefresh.listen(_handleTokenRefresh);

      emit(
        state.copyWith(
          status: PushNotificationsStatus.success,
          notificationsEnabled: _repository.areNotificationsEnabled(),
        ),
      );
    } catch (e) {
      logWarning('Push notifications initialization error: $e');
      // Don't block the app, just set initial state
      emit(
        state.copyWith(
          status: PushNotificationsStatus.success,
          notificationsEnabled: false,
        ),
      );
    }
  }

  /// Load notification history
  Future<void> loadNotifications() async {
    if (_repository == null) return;

    try {
      final notifications = await _repository.getNotifications();
      emit(state.copyWith(notifications: notifications));
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: 'Error loading notifications: ${e.toString()}',
        ),
      );
    }
  }

  /// Load user's saved addresses
  Future<void> loadUserAddresses() async {
    if (_repository == null) return;

    try {
      final addresses = await _repository.getUserAddresses();
      emit(state.copyWith(userAddresses: addresses));
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: 'Error loading addresses: ${e.toString()}',
        ),
      );
    }
  }

  /// Add saved address
  Future<void> addUserAddress({
    required String city,
    required String street,
    required String houseNumber,
  }) async {
    if (_repository == null) return;

    try {
      await _repository.addUserAddress(
        city: city,
        street: street,
        houseNumber: houseNumber,
      );
      await loadUserAddresses();
    } catch (e) {
      emit(
        state.copyWith(errorMessage: 'Error adding address: ${e.toString()}'),
      );
    }
  }

  /// Remove saved address
  Future<void> removeUserAddress({
    required String city,
    required String street,
    required String houseNumber,
  }) async {
    if (_repository == null) return;

    try {
      await _repository.removeUserAddress(
        city: city,
        street: street,
        houseNumber: houseNumber,
      );
      await loadUserAddresses();
    } catch (e) {
      emit(
        state.copyWith(errorMessage: 'Error removing address: ${e.toString()}'),
      );
    }
  }

  /// Toggle notifications
  Future<void> toggleNotifications(bool enabled) async {
    if (_repository == null) return;

    try {
      await _repository.toggleNotifications(enabled);
      emit(state.copyWith(notificationsEnabled: enabled));
    } catch (e) {
      logError('Error toggling notifications: $e');
      emit(
        state.copyWith(
          errorMessage: 'Error toggling notifications: ${e.toString()}',
        ),
      );
    }
  }

  /// Handle new message
  void _handleNewMessage(RemoteMessage message) {
    // Update notification history
    loadNotifications();
  }

  /// Handle token refresh
  void _handleTokenRefresh(String newToken) async {
    if (_repository == null) return;

    try {
      await _repository.registerToken();
    } catch (e) {
      emit(
        state.copyWith(errorMessage: 'Error refreshing token: ${e.toString()}'),
      );
    }
  }

  /// Clear cache
  Future<void> clearCache() async {
    if (_repository == null) return;

    try {
      await _repository.clearCache();
      emit(state.copyWith(notifications: [], userAddresses: []));
    } catch (e) {
      emit(
        state.copyWith(errorMessage: 'Error clearing cache: ${e.toString()}'),
      );
    }
  }
}
