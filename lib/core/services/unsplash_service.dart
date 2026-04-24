import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Fetches a daily background photo from the Unsplash API.
///
/// - One API call per day per slot (cached in SharedPreferences).
/// - Keywords rotate by day-of-week so each day looks different.
/// - Falls back gracefully to null when offline or quota is exceeded.
/// - Always uses content_filter=high.
class UnsplashService {
  static const _accessKey = 'ubG3zpeRVWY3JWaWeKA1p7QBJ1dp94oc-rDA0S8vJsk';
  static const _endpoint = 'https://api.unsplash.com/photos/random';

  // ── Day-of-week keywords (Sunday = 0 … Saturday = 6) ──────────────────────
  static const _queries = [
    'cross sunset sky',          // Sunday
    'open bible light rays',     // Monday
    'mountain sunrise golden',   // Tuesday
    'church window light',       // Wednesday
    'dove sky clouds',           // Thursday
    'candle prayer dark',        // Friday
    'sunrise nature peaceful',   // Saturday
  ];

  // ── SharedPreferences keys ─────────────────────────────────────────────────
  // Each "slot" (votd / hero) stores its own cached URL + the date it was fetched.
  static String _urlKey(String slot)  => 'unsplash_url_$slot';
  static String _dateKey(String slot) => 'unsplash_date_$slot';

  /// Returns today's background URL for [slot] (e.g. "votd" or "hero").
  ///
  /// If a URL was already fetched today it is returned from cache.
  /// Returns `null` on any error so callers can fall back to a local asset.
  static Future<String?> getDailyUrl(String slot) async {
    final today = _todayString();
    final prefs = await SharedPreferences.getInstance();

    // Return cached value if it was fetched today.
    final cachedDate = prefs.getString(_dateKey(slot));
    if (cachedDate == today) {
      return prefs.getString(_urlKey(slot));
    }

    // Fetch a new photo from Unsplash.
    // Prayer slot uses its own rotating keywords; others use day-of-week.
    const prayerQueries = [
      'candle flame dark prayer',
      'hands folded prayer light',
      'church altar candle glow',
      'soft light window prayer',
      'rosary beads gentle light',
      'kneeling prayer silhouette',
      'candlelight cross shadow',
    ];
    final query = slot == 'prayer'
        ? prayerQueries[DateTime.now().weekday % prayerQueries.length]
        : _queries[DateTime.now().weekday % 7]; // weekday 1–7 → 1-6,0
    try {
      final uri = Uri.parse(_endpoint).replace(queryParameters: {
        'query': query,
        'content_filter': 'high',
        'orientation': 'landscape',
        'client_id': _accessKey,
      });

      final response = await http
          .get(uri)
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        // Prefer "regular" (1080px wide) — good balance of quality vs. size.
        final url = (data['urls'] as Map<String, dynamic>)['regular'] as String?;
        if (url != null) {
          await prefs.setString(_urlKey(slot), url);
          await prefs.setString(_dateKey(slot), today);
          return url;
        }
      }
    } catch (_) {
      // Network error, timeout, or JSON parse failure — return null.
    }
    return null;
  }

  /// Clear cached URLs (useful for testing or manual refresh).
  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    for (final slot in ['votd', 'hero']) {
      await prefs.remove(_urlKey(slot));
      await prefs.remove(_dateKey(slot));
    }
  }

  static String _todayString() {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }
}
