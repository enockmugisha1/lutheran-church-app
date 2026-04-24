import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:hive/hive.dart';
import '../services/local_bible_service.dart';

/// Professional notification service for daily spiritual reminders.
///
/// Schedules:
///  - Morning devotion reminder (6:30 AM)
///  - Verse of the day (7:00 AM)
///  - Evening prayer reminder (8:00 PM)
///
/// Stores settings in Hive and respects the user's notification toggle.
class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _hiveBox = 'settings';
  static const String _keyMorningEnabled = 'notif_morning';
  static const String _keyEveningEnabled = 'notif_evening';
  static const String _keyVotdEnabled = 'notif_votd';

  // Notification channel IDs
  static const String _channelIdVotd = 'lcr_votd';
  static const String _channelIdPrayer = 'lcr_prayer';

  // Notification IDs
  static const int _idMorning = 100;
  static const int _idVotd = 101;
  static const int _idEvening = 102;

  /// Initialize the notification plugin. Call once at app startup.
  static Future<void> init() async {
    // Initialize timezone database
    tz_data.initializeTimeZones();
    // Use Africa/Kigali (UTC+2) as default for Rwanda
    tz.setLocalLocation(tz.getLocation('Africa/Kigali'));

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const linuxSettings = LinuxInitializationSettings(
      defaultActionName: 'Open',
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      linux: linuxSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Request permission on Android 13+
    if (!kIsWeb && Platform.isAndroid) {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.requestNotificationsPermission();

      // Create all notification channels so FCM messages always appear
      const channels = [
        AndroidNotificationChannel(
          'lcr_push',
          'Church Notifications',
          description: 'Push notifications from LCR church',
          importance: Importance.high,
          enableVibration: true,
          playSound: true,
        ),
        AndroidNotificationChannel(
          'lcr_prayer',
          'Prayer Reminders',
          description: 'Daily prayer time reminders',
          importance: Importance.high,
          enableVibration: true,
          playSound: true,
        ),
        AndroidNotificationChannel(
          'lcr_votd',
          'Verse of the Day',
          description: 'Daily Bible verse notifications',
          importance: Importance.defaultImportance,
          enableVibration: false,
          playSound: true,
        ),
      ];

      for (final ch in channels) {
        await androidPlugin?.createNotificationChannel(ch);
      }
    }
  }

  static void _onNotificationTap(NotificationResponse response) {
    // Could navigate to specific page based on payload
    debugPrint('Notification tapped: ${response.payload}');
  }

  // ── Schedule All Daily Notifications ──────────────────────────────────────

  /// Schedule all daily notifications (or cancel if disabled).
  static Future<void> syncSchedule({required bool enabled}) async {
    if (!enabled) {
      await cancelAll();
      return;
    }
    await _scheduleMorningPrayer();
    await _scheduleVerseOfDay();
    await _scheduleEveningPrayer();
  }

  /// Schedule morning devotion at 6:30 AM daily.
  static Future<void> _scheduleMorningPrayer() async {
    if (!_isEnabled(_keyMorningEnabled)) return;

    await _plugin.zonedSchedule(
      _idMorning,
      '🌅 Isengesho ryo mu Gitondo',
      'Tangira umunsi wawe n\'Imana. Kanda hano usenge.',
      _nextInstanceOfTime(6, 30),
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelIdPrayer,
          'Prayer Reminders',
          channelDescription: 'Daily prayer time reminders',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFF5C2E8A),
          styleInformation: const BigTextStyleInformation(
            'Tangira umunsi wawe n\'Imana. Kanda hano usenge.',
            contentTitle: '🌅 Isengesho ryo mu Gitondo',
          ),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'morning_prayer',
    );
  }

  /// Schedule verse of the day at 7:00 AM daily.
  static Future<void> _scheduleVerseOfDay() async {
    if (!_isEnabled(_keyVotdEnabled)) return;

    // Get today's verse for the notification body
    final votd = LocalBibleService.verseOfDay();
    final body = votd != null
        ? '"${_truncate(votd.text, 120)}" — ${votd.bookName} ${votd.chapter}:${votd.verse}'
        : 'Kanda hano usome ijambo ry\'uyu munsi.';

    await _plugin.zonedSchedule(
      _idVotd,
      '📖 Ijambo ry\'Uyu Munsi',
      body,
      _nextInstanceOfTime(7, 0),
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelIdVotd,
          'Verse of the Day',
          channelDescription: 'Daily Bible verse notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFFD4AF37),
          styleInformation: BigTextStyleInformation(
            body,
            contentTitle: '📖 Ijambo ry\'Uyu Munsi',
          ),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'votd',
    );
  }

  /// Schedule evening prayer at 8:00 PM daily.
  static Future<void> _scheduleEveningPrayer() async {
    if (!_isEnabled(_keyEveningEnabled)) return;

    await _plugin.zonedSchedule(
      _idEvening,
      '🌙 Isengesho ryo mu Mugoroba',
      'Soza umunsi wawe ushimira Imana. Kanda hano usenga.',
      _nextInstanceOfTime(20, 0),
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelIdPrayer,
          'Prayer Reminders',
          channelDescription: 'Daily prayer time reminders',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFF5C6BC0),
          styleInformation: const BigTextStyleInformation(
            'Soza umunsi wawe ushimira Imana. Kanda hano usenga.',
            contentTitle: '🌙 Isengesho ryo mu Mugoroba',
          ),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'evening_prayer',
    );
  }

  // ── Instant Notification (for testing / one-offs) ─────────────────────────

  /// Show an immediate notification (e.g. after a bookmark or share action).
  static Future<void> showInstant({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch % 100000,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelIdVotd,
          'LCR Notifications',
          channelDescription: 'General app notifications',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFF5C2E8A),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
        ),
      ),
      payload: payload,
    );
  }

  // ── Cancel ────────────────────────────────────────────────────────────────

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  static Future<void> cancelById(int id) async {
    await _plugin.cancel(id);
  }

  // ── Individual Toggle Helpers ─────────────────────────────────────────────

  static Future<void> setMorningEnabled(bool v) async {
    final box = Hive.box(_hiveBox);
    await box.put(_keyMorningEnabled, v);
    if (v) {
      await _scheduleMorningPrayer();
    } else {
      await cancelById(_idMorning);
    }
  }

  static Future<void> setEveningEnabled(bool v) async {
    final box = Hive.box(_hiveBox);
    await box.put(_keyEveningEnabled, v);
    if (v) {
      await _scheduleEveningPrayer();
    } else {
      await cancelById(_idEvening);
    }
  }

  static Future<void> setVotdEnabled(bool v) async {
    final box = Hive.box(_hiveBox);
    await box.put(_keyVotdEnabled, v);
    if (v) {
      await _scheduleVerseOfDay();
    } else {
      await cancelById(_idVotd);
    }
  }

  static bool isMorningEnabled() => _isEnabled(_keyMorningEnabled);
  static bool isEveningEnabled() => _isEnabled(_keyEveningEnabled);
  static bool isVotdEnabled() => _isEnabled(_keyVotdEnabled);

  // ── Helpers ───────────────────────────────────────────────────────────────

  static bool _isEnabled(String key) {
    try {
      final box = Hive.box(_hiveBox);
      return box.get(key, defaultValue: true) as bool;
    } catch (_) {
      return true;
    }
  }

  /// Returns the next occurrence of the given [hour]:[minute] in the local tz.
  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  static String _truncate(String s, int maxLen) {
    if (s.length <= maxLen) return s;
    return '${s.substring(0, maxLen)}...';
  }
}
