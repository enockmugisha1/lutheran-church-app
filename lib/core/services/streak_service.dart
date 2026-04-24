import 'package:hive_flutter/hive_flutter.dart';

/// Tracks daily reading streaks locally using Hive.
/// Call [recordOpen] once per app launch (e.g. in HomeDashboard.initState).
class StreakService {
  static const _boxName = 'streak_box';
  static const _keyLastOpened = 'last_opened';
  static const _keyCurrentStreak = 'current_streak';
  static const _keyLongestStreak = 'longest_streak';

  static Box? _box;

  static Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  static int get currentStreak =>
      (_box?.get(_keyCurrentStreak, defaultValue: 0) ?? 0) as int;

  static int get longestStreak =>
      (_box?.get(_keyLongestStreak, defaultValue: 0) ?? 0) as int;

  /// Call when the app/home screen opens. Idempotent per day.
  static Future<void> recordOpen() async {
    if (_box == null) await init();
    final today = _fmt(DateTime.now());
    final lastOpened = _box!.get(_keyLastOpened) as String?;
    if (lastOpened == today) return; // already recorded today

    int current = (_box!.get(_keyCurrentStreak, defaultValue: 0)) as int;
    if (lastOpened == _fmt(DateTime.now().subtract(const Duration(days: 1)))) {
      current++; // consecutive day
    } else {
      current = 1; // streak broken or first time
    }

    int longest = (_box!.get(_keyLongestStreak, defaultValue: 0)) as int;
    if (current > longest) longest = current;

    await _box!.put(_keyLastOpened, today);
    await _box!.put(_keyCurrentStreak, current);
    await _box!.put(_keyLongestStreak, longest);
  }

  static String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
