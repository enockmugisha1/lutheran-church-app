class AppConstants {
  // App Info
  static const String appName = 'Lutheran Church';
  static const String appVersion = '1.0.0';

  // Languages
  static const String defaultLanguage = 'rw'; // Kinyarwanda
  static const List<String> supportedLanguages = ['rw', 'en', 'fr'];

  // Liturgical Seasons
  static const List<String> liturgicalSeasons = [
    'Advent',
    'Christmas',
    'Epiphany',
    'Lent',
    'Easter',
    'Pentecost',
    'Ordinary Time',
  ];

  // Database
  static const String dbName = 'lutheran_church.db';
  static const int dbVersion = 1;

  // Hive Boxes
  static const String settingsBox = 'settings';
  static const String bibleBox = 'bible';
  static const String bookmarksBox = 'bookmarks';

  // Shared Preferences Keys
  static const String keyLanguage = 'language';
  static const String keyThemeMode = 'theme_mode';
  static const String keyNotifications = 'notifications_enabled';
  static const String keyTextSize = 'text_size';
}
