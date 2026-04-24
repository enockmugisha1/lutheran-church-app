import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:lutheran/core/services/notification_service.dart';

enum LiturgicalSeason {
  advent,
  christmastide,
  epiphany,
  lent,
  easterTriduum,
  eastertide,
  pentecost,
  ordinary,
}

class SettingsProvider extends GetxController {
  static const String _hiveBoxName = 'settings';
  static const String _languageKey = 'language';
  static const String _themeModeKey = 'themeMode';
  static const String _textSizeKey = 'textSize';
  static const String _notificationsKey = 'notifications';

  late Box<dynamic> _settingsBox;

  final Rx<String> language = 'rw'.obs;
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;
  final Rx<double> textSize = 1.0.obs;
  final Rx<bool> notificationsEnabled = true.obs;
  final Rx<LiturgicalSeason> currentSeason = LiturgicalSeason.ordinary.obs;

  @override
  void onInit() async {
    super.onInit();
    await _initializeHive();
    _loadSettings();
    _updateLiturgicalSeason();
  }

  Future<void> _initializeHive() async {
    try {
      if (!Hive.isBoxOpen(_hiveBoxName)) {
        _settingsBox = await Hive.openBox(_hiveBoxName);
      } else {
        _settingsBox = Hive.box(_hiveBoxName);
      }
    } catch (e) {
      print('Error initializing Hive: $e');
    }
  }

  void _loadSettings() {
    try {
      // Load language (default: Kinyarwanda)
      final savedLanguage = _settingsBox.get(_languageKey, defaultValue: 'rw');
      language.value = savedLanguage;

      // Load theme mode
      final themeModeIndex = _settingsBox.get(_themeModeKey, defaultValue: 0);
      themeMode.value = ThemeMode.values[themeModeIndex];

      // Load text size
      final savedTextSize = _settingsBox.get(_textSizeKey, defaultValue: 1.0);
      textSize.value = savedTextSize;

      // Load notifications setting
      final savedNotifications =
          _settingsBox.get(_notificationsKey, defaultValue: true);
      notificationsEnabled.value = savedNotifications;
    } catch (e) {
      print('Error loading settings: $e');
    }
  }

  Future<void> setLanguage(String newLanguage) async {
    try {
      language.value = newLanguage;
      await _settingsBox.put(_languageKey, newLanguage);
      Get.updateLocale(Locale(newLanguage));
    } catch (e) {
      print('Error setting language: $e');
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    try {
      themeMode.value = mode;
      await _settingsBox.put(_themeModeKey, mode.index);
    } catch (e) {
      print('Error setting theme mode: $e');
    }
  }

  Future<void> setTextSize(double size) async {
    try {
      // Clamp size between 0.8 and 1.5
      final clampedSize = size.clamp(0.8, 1.5);
      textSize.value = clampedSize;
      await _settingsBox.put(_textSizeKey, clampedSize);
    } catch (e) {
      print('Error setting text size: $e');
    }
  }

  Future<void> toggleNotifications(bool enabled) async {
    try {
      notificationsEnabled.value = enabled;
      await _settingsBox.put(_notificationsKey, enabled);
      // Sync scheduled notifications with new preference
      await NotificationService.syncSchedule(enabled: enabled);
    } catch (e) {
      print('Error toggling notifications: $e');
    }
  }

  void _updateLiturgicalSeason() {
    // This method calculates the current liturgical season based on the date
    final now = DateTime.now();
    final month = now.month;
    final day = now.day;

    // Approximate dates for liturgical seasons (can be adjusted)
    if ((month == 11 && day >= 27) || (month == 12 && day <= 24)) {
      currentSeason.value = LiturgicalSeason.advent;
    } else if ((month == 12 && day >= 25) || (month == 1 && day <= 5)) {
      currentSeason.value = LiturgicalSeason.christmastide;
    } else if (month == 1 && day >= 6) {
      currentSeason.value = LiturgicalSeason.epiphany;
    } else if (month == 2 || (month == 3 && day <= 6)) {
      currentSeason.value = LiturgicalSeason.lent;
    } else if (month == 3 || (month == 4 && day <= 9)) {
      currentSeason.value = LiturgicalSeason.easterTriduum;
    } else if (month == 4 || (month == 5 && day <= 18)) {
      currentSeason.value = LiturgicalSeason.eastertide;
    } else if (month == 5 || (month == 6 && day <= 8)) {
      currentSeason.value = LiturgicalSeason.pentecost;
    } else {
      currentSeason.value = LiturgicalSeason.ordinary;
    }
  }

  Color getSeasonColor() {
    switch (currentSeason.value) {
      case LiturgicalSeason.advent:
        return const Color(0xFF6B3FA0); // Purple
      case LiturgicalSeason.christmastide:
        return const Color(0xFFFFD700); // Gold
      case LiturgicalSeason.epiphany:
        return const Color(0xFF64B5F6); // Light Blue
      case LiturgicalSeason.lent:
        return const Color(0xFF5C2E8A); // Violet-Purple (Lent)
      case LiturgicalSeason.easterTriduum:
        return const Color(0xFF000000); // Black
      case LiturgicalSeason.eastertide:
        return const Color(0xFFFFFFFF); // White
      case LiturgicalSeason.pentecost:
        return const Color(0xFFFF6B6B); // Red
      case LiturgicalSeason.ordinary:
        return const Color(0xFF4CAF50); // Green
    }
  }

  String getSeasonName() {
    final seasonNames = {
      LiturgicalSeason.advent: 'Igisibo (Advent)',
      LiturgicalSeason.christmastide: 'Noheli (Christmas)',
      LiturgicalSeason.epiphany: 'Epifaniya',
      LiturgicalSeason.lent: 'Igisibo Kinini (Lent)',
      LiturgicalSeason.easterTriduum: 'Iminsi Mikuru ya Pasika',
      LiturgicalSeason.eastertide: 'Igihe cya Pasika',
      LiturgicalSeason.pentecost: 'Pentekositi',
      LiturgicalSeason.ordinary: 'Igihe Gisanzwe',
    };
    return seasonNames[currentSeason.value] ?? 'Igihe Gisanzwe';
  }

  @override
  void onClose() {
    _settingsBox.close();
    super.onClose();
  }
}
