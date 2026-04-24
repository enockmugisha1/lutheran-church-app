import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'notification_service.dart';

/// Top-level background message handler — must be a top-level function.
/// Called when the app is in background or terminated and a push arrives.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('[FCM] Background message: ${message.messageId}');
  // The local notification plugin will show the notification automatically
  // if the message has a `notification` payload. For data-only messages
  // we show it manually:
  if (message.notification == null && message.data.isNotEmpty) {
    await NotificationService.showInstant(
      title: message.data['title'] ?? 'LCR',
      body: message.data['body'] ?? '',
      payload: jsonEncode(message.data),
    );
  }
}

/// Firebase Cloud Messaging service.
///
/// Handles:
///  1. Requesting push notification permission
///  2. Getting & storing the FCM device token
///  3. Subscribing to topic channels (e.g. "announcements", "devotions")
///  4. Handling foreground, background, and terminated-state messages
///  5. Saving the token in Firestore for server-side targeting
class CloudMessagingService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static const String _hiveBox = 'settings';
  static const String _keyFcmToken = 'fcm_token';
  static const String _keyTopicAnnouncements = 'fcm_topic_announcements';
  static const String _keyTopicDevotions = 'fcm_topic_devotions';
  static const String _keyTopicEvents = 'fcm_topic_events';

  // ── Topic names ───────────────────────────────────────────────────────────
  static const String topicAnnouncements = 'announcements';
  static const String topicDevotions = 'daily_devotions';
  static const String topicEvents = 'church_events';

  /// Initialize FCM. Call once after Firebase.initializeApp().
  static Future<void> init() async {
    // 1. Request permission (iOS + Android 13+)
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: true,
      provisional: false,
    );
    debugPrint('[FCM] Permission: ${settings.authorizationStatus}');

    // 2. Register the background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 3. Get device token & save it
    await _refreshToken();

    // Listen for token refreshes (can happen at any time)
    _messaging.onTokenRefresh.listen((newToken) {
      _saveToken(newToken);
    });

    // 4. Subscribe to default topics
    await _syncTopicSubscriptions();

    // 5. Handle foreground messages — show a local notification
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // 6. Handle notification taps (when app was in background)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

    // 7. Check if the app was opened from a terminated-state notification
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageTap(initialMessage);
    }
  }

  // ── Token Management ──────────────────────────────────────────────────────

  /// Get the current FCM token (from cache or fresh).
  static Future<String?> getToken() async {
    try {
      final box = Hive.box(_hiveBox);
      final cached = box.get(_keyFcmToken) as String?;
      if (cached != null && cached.isNotEmpty) return cached;
      return await _refreshToken();
    } catch (_) {
      return null;
    }
  }

  static Future<String?> _refreshToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await _saveToken(token);
      }
      return token;
    } catch (e) {
      debugPrint('[FCM] Error getting token: $e');
      return null;
    }
  }

  /// Save the token locally (Hive) and to Firestore for server-side push.
  static Future<void> _saveToken(String token) async {
    try {
      // Save locally
      final box = Hive.box(_hiveBox);
      await box.put(_keyFcmToken, token);

      // Save to Firestore under the user's document
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'fcmToken': token,
          'platform': defaultTargetPlatform.name,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
      debugPrint('[FCM] Token saved: ${token.substring(0, 20)}...');
    } catch (e) {
      debugPrint('[FCM] Error saving token: $e');
    }
  }

  // ── Topic Subscriptions ───────────────────────────────────────────────────

  /// Subscribe/unsubscribe from default topics based on user prefs.
  static Future<void> _syncTopicSubscriptions() async {
    // Subscribe to all topics by default (user can toggle individually)
    await _ensureTopic(topicAnnouncements, _keyTopicAnnouncements);
    await _ensureTopic(topicDevotions, _keyTopicDevotions);
    await _ensureTopic(topicEvents, _keyTopicEvents);
  }

  static Future<void> _ensureTopic(String topic, String hiveKey) async {
    if (kIsWeb) return; // Topic subscriptions not supported on web
    final box = Hive.box(_hiveBox);
    final enabled = box.get(hiveKey, defaultValue: true) as bool;
    if (enabled) {
      await _messaging.subscribeToTopic(topic);
      debugPrint('[FCM] Subscribed to: $topic');
    } else {
      await _messaging.unsubscribeFromTopic(topic);
    }
  }

  /// Toggle a specific topic on/off.
  static Future<void> setTopicEnabled(String topic, bool enabled) async {
    String? key;
    if (topic == topicAnnouncements) key = _keyTopicAnnouncements;
    if (topic == topicDevotions) key = _keyTopicDevotions;
    if (topic == topicEvents) key = _keyTopicEvents;

    if (key != null) {
      final box = Hive.box(_hiveBox);
      await box.put(key, enabled);
    }

    if (kIsWeb) return; // Topic subscriptions not supported on web
    if (enabled) {
      await _messaging.subscribeToTopic(topic);
    } else {
      await _messaging.unsubscribeFromTopic(topic);
    }
  }

  static bool isTopicEnabled(String topic) {
    String? key;
    if (topic == topicAnnouncements) key = _keyTopicAnnouncements;
    if (topic == topicDevotions) key = _keyTopicDevotions;
    if (topic == topicEvents) key = _keyTopicEvents;
    if (key == null) return true;

    try {
      final box = Hive.box(_hiveBox);
      return box.get(key, defaultValue: true) as bool;
    } catch (_) {
      return true;
    }
  }

  // ── Message Handlers ──────────────────────────────────────────────────────

  /// Handle messages that arrive while the app is in the foreground.
  /// FCM won't show a notification automatically, so we use the local plugin.
  static void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('[FCM] Foreground message: ${message.messageId}');

    final notification = message.notification;
    if (notification != null) {
      NotificationService.showInstant(
        title: notification.title ?? 'LCR',
        body: notification.body ?? '',
        payload: jsonEncode(message.data),
      );
    } else if (message.data.isNotEmpty) {
      // Data-only message
      NotificationService.showInstant(
        title: message.data['title'] ?? 'LCR',
        body: message.data['body'] ?? '',
        payload: jsonEncode(message.data),
      );
    }
  }

  /// Handle notification tap (app was in background or terminated).
  static void _handleMessageTap(RemoteMessage message) {
    debugPrint('[FCM] Message tap: ${message.data}');
    // Navigation can be handled here based on message.data['type']
    // For example: navigate to a specific page
    final type = message.data['type'];
    if (type == 'devotion') {
      // Could navigate to Bible/VOTD page
    } else if (type == 'event') {
      // Could navigate to Calendar
    } else if (type == 'announcement') {
      // Could navigate to Community page
    }
  }

  // ── Cleanup ───────────────────────────────────────────────────────────────

  /// Delete the token (e.g. on sign-out). Stops all push notifications.
  static Future<void> deleteToken() async {
    try {
      await _messaging.deleteToken();
      final box = Hive.box(_hiveBox);
      await box.delete(_keyFcmToken);
    } catch (e) {
      debugPrint('[FCM] Error deleting token: $e');
    }
  }
}
