import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'log_color.dart';
import 'service_strings.dart';

/// Background message handler (must be a top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('🔔 Background message: ${message.notification?.title}');
}

/// Service for Firebase Cloud Messaging integration
/// Singleton pattern ensures single instance across the app
class FirebaseMessagingService {
  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._internal();
  factory FirebaseMessagingService() => _instance;
  FirebaseMessagingService._internal();

  FirebaseMessaging? _messaging;
  FlutterLocalNotificationsPlugin? _localNotifications;
  String? _fcmToken;
  String? _deviceId;

  // Stream controllers for handling messages
  final _messageStreamController = StreamController<RemoteMessage>.broadcast();
  final _tokenRefreshController = StreamController<String>.broadcast();

  Stream<RemoteMessage> get onMessage => _messageStreamController.stream;
  Stream<String> get onTokenRefresh => _tokenRefreshController.stream;

  String? get fcmToken => _fcmToken;
  String? get deviceId => _deviceId;

  /// Initialize Firebase Messaging and request permissions
  Future<void> initialize() async {
    try {
      _messaging = FirebaseMessaging.instance;
      _deviceId = await _getDeviceId();

      // Request notification permissions
      final hasPermission = await requestPermission();
      if (!hasPermission) {
        return;
      }

      // Get FCM token
      // On iOS simulator, try to get APNS token first
      try {
        if (Platform.isIOS) {
          await _messaging!.getAPNSToken();
        }
        _fcmToken = await _messaging!.getToken();
      } catch (e) {
        logWarning('Failed to get FCM token: $e');
        // Continue without token
      }

      // Setup message handlers
      _setupMessageHandlers();

      // Listen for token refresh
      _messaging!.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        _tokenRefreshController.add(newToken);
      });
    } catch (e) {
      logError('Error initializing Firebase Messaging: $e');
      // Don't throw error to avoid stopping the app
    }
  }

  /// Request notification permissions from user
  Future<bool> requestPermission() async {
    try {
      final settings = await _messaging!.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      return settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    } catch (e) {
      logError('Error requesting permission: $e');
      return false;
    }
  }

  /// Initialize local notifications plugin
  Future<void> _initializeLocalNotifications() async {
    _localNotifications = FlutterLocalNotificationsPlugin();

    const androidSettings = AndroidInitializationSettings(
      '@drawable/ic_stat_notification',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications!.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // TODO: Handle notification tap
      },
    );

    // Create notification channel for Android
    const androidChannel = AndroidNotificationChannel(
      'prosvitlo_channel',
      ServiceStrings.notificationChannelName,
      description: ServiceStrings.notificationChannelDescription,
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
    );

    await _localNotifications!
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);
  }

  /// Show local notification when app is in foreground
  Future<void> _showLocalNotification(RemoteMessage message) async {
    if (_localNotifications == null) {
      logError('_localNotifications is null!');
      return;
    }

    final notification = message.notification;
    if (notification == null) {
      logError('message.notification is null!');
      return;
    }

    final androidDetails = AndroidNotificationDetails(
      'prosvitlo_channel',
      ServiceStrings.notificationChannelName,
      channelDescription: ServiceStrings.notificationChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: 'ic_stat_notification',
      largeIcon: const DrawableResourceAndroidBitmap('ic_notification_large'),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Use Random for unique notification ID to avoid collisions
    final notificationId = Random().nextInt(1 << 31);

    await _localNotifications!.show(
      notificationId,
      notification.title,
      notification.body,
      details,
      payload: message.data.toString(),
    );
  }

  /// Setup message handlers for foreground, background, and terminated states
  void _setupMessageHandlers() async {
    // Initialize local notifications
    await _initializeLocalNotifications();

    // Setup background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Configure notification presentation for foreground messages
    await _messaging!.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Foreground messages - when app is open
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Show local notification (for Android)
      _showLocalNotification(message);

      // Pass to stream for saving to history
      _messageStreamController.add(message);
    });

    // Background messages - when app is minimized
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _messageStreamController.add(message);
    });

    // Check if app was opened from a notification
    _checkInitialMessage();
  }

  /// Check if app was opened from a notification in terminated state
  Future<void> _checkInitialMessage() async {
    final initialMessage = await _messaging?.getInitialMessage();
    if (initialMessage != null) {
      logInfo(
        '📬 App opened from terminated state: ${initialMessage.notification?.title}',
      );
      _messageStreamController.add(initialMessage);
    }
  }

  /// Get unique device ID for registration
  Future<String> _getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? 'unknown_ios_device';
    }

    return 'unknown_device';
  }

  /// Delete FCM token (when uninstalling app or logging out)
  Future<void> deleteToken() async {
    try {
      await _messaging?.deleteToken();
      _fcmToken = null;
    } catch (e) {
      logError('Error deleting token: $e');
    }
  }

  /// Subscribe to a topic for receiving topic-based notifications
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging?.subscribeToTopic(topic);
    } catch (e) {
      logError('Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging?.unsubscribeFromTopic(topic);
    } catch (e) {
      logError('Error unsubscribing from topic: $e');
    }
  }

  /// Clean up resources and close streams
  void dispose() {
    _messageStreamController.close();
    _tokenRefreshController.close();
  }
}
