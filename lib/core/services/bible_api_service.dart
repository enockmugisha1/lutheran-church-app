import 'dart:convert';
import 'package:http/http.dart' as http;

/// Bible API service using api.youversion.com
/// Manage your developer token at: https://api.youversion.com
class BibleApiService {
  static const String _baseUrl = 'https://api.youversion.com/v1';
  static const String _apiKey = '1lA0RTixzR5k7EVc2X6cS1IiSPbMb6Q4s7m2J1D6Qs5WsbKx';

  // YouVersion integer Bible IDs
  // Kinyarwanda Bibles from Bible Society of Rwanda
  static const int kBysbId = 351;   // Bibiliya Yera (Kinyarwanda) — PRIMARY
  static const int kKbntId = 430;   // Kinyarwanda Bibiliya Ntagatifu
  // English fallbacks
  static const int kAsvId = 12;     // American Standard Version
  static const int kKjvId = 1;      // King James Version
  static const int kBsbId = 3034;   // Berean Standard Bible

  static Map<String, String> get _headers => {
    'x-yvp-app-key': _apiKey,
    'Accept': 'application/json',
  };

  static Future<T?> _get<T>(
    String path,
    T Function(Map<String, dynamic>) parser,
  ) async {
    try {
      final uri = Uri.parse('$_baseUrl$path');
      final res = await http.get(uri, headers: _headers).timeout(
        const Duration(seconds: 10),
      );
      // 204 = no content (e.g. no Bibles for that language) — treat as empty
      if (res.statusCode == 204) return null;
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        return parser(body);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Fetch Bibles available for the given language ranges (RFC 4647 Basic Range).
  /// Pass ['*'] to get all available Bibles regardless of language.
  /// Pass ['en'] for English only, ['fr'] for French only, etc.
  /// Set [allPages] to true to fetch every page (up to ~500 results).
  static Future<List<BibleInfo>> fetchBibles({
    List<String> languageRanges = const ['*'],
    bool allPages = true,
  }) async {
    final langParam = languageRanges
        .map((l) => 'language_ranges[]=${Uri.encodeComponent(l)}')
        .join('&');

    final all = <BibleInfo>[];
    String? pageToken;

    do {
      final tokenParam = pageToken != null
          ? '&page_token=${Uri.encodeComponent(pageToken)}'
          : '';
      final path = '/bibles?$langParam&page_size=100$tokenParam';

      String? nextToken;
      final result = await _get(path, (body) {
        final data = body['data'] as List?;
        nextToken = body['next_page_token'] as String?;
        return data
                ?.map((e) => BibleInfo.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];
      });

      if (result == null) break;
      all.addAll(result);
      pageToken = (allPages && nextToken != null && nextToken!.isNotEmpty)
          ? nextToken
          : null;
    } while (pageToken != null);

    return all;
  }

  /// Fetch all books for a Bible (chapters are included in the response)
  static Future<List<BibleBook>> fetchBooks(int bibleId) async {
    final result = await _get('/bibles/$bibleId/books', (body) {
      final data = body['data'] as List?;
      return data
              ?.map((e) => BibleBook.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
    });
    return result ?? [];
  }

  /// Fetch chapters for a specific book
  static Future<List<BibleChapter>> fetchChapters(
    int bibleId,
    String bookId,
  ) async {
    final result = await _get('/bibles/$bibleId/books/$bookId/chapters', (body) {
      final data = body['data'] as List?;
      return data
              ?.map((e) => BibleChapter.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
    });
    return result ?? [];
  }

  /// Fetch a chapter's text by its passage ID (e.g. "GEN.1")
  static Future<BiblePassage?> fetchChapter(
    int bibleId,
    String passageId, {
    bool includeHeadings = true,
    bool includeNotes = false,
  }) async {
    return _get(
      '/bibles/$bibleId/passages/$passageId?format=html&include_headings=$includeHeadings&include_notes=$includeNotes',
      (body) => BiblePassage.fromJson(body),
    );
  }

  /// Fetch a single verse by its passage ID (e.g. "JHN.3.16")
  static Future<BiblePassage?> fetchVerse(
    int bibleId,
    String verseId,
  ) async {
    return _get(
      '/bibles/$bibleId/passages/$verseId?format=text',
      (body) => BiblePassage.fromJson(body),
    );
  }

  /// Get a "Verse of the Day" — deterministic by day-of-year, cycles through
  /// a curated list of inspiring verses.
  static Future<BiblePassage?> fetchVerseOfDay({
    int bibleId = kBysbId,
  }) async {
    final today = DateTime.now();
    final dayOfYear = today.difference(DateTime(today.year)).inDays;
    final verseId = _votdVerses[dayOfYear % _votdVerses.length];
    return fetchVerse(bibleId, verseId);
  }

  // Curated list of 60 uplifting verse IDs (USFM format: BOK.CH.V)
  static const List<String> _votdVerses = [
    'JHN.3.16', 'PSA.23.1', 'PHP.4.13', 'ROM.8.28', 'JER.29.11',
    'ISA.40.31', 'PRO.3.5', 'MAT.11.28', 'JOS.1.9', 'PSA.46.1',
    'ROM.8.38', 'PHP.4.6', 'MAT.5.14', 'JHN.14.6', 'ROM.12.2',
    'PSA.119.105', 'GAL.5.22', '1CO.13.4', 'HEB.11.1', 'PSA.27.1',
    'ISA.41.10', '2TI.1.7', 'MAT.6.33', 'JHN.10.10', 'ROM.5.8',
    'EPH.2.8', 'PSA.37.4', 'MAT.28.19', 'REV.21.4', 'PSA.121.1',
    'JHN.15.13', 'ROM.6.23', 'PHP.4.7', 'MAT.6.9', 'PSA.91.1',
    'ISA.53.5', 'JHN.11.25', '1CO.10.13', 'HEB.4.16', 'PSA.139.14',
    'MAT.5.9', 'ROM.8.1', 'LUK.1.37', 'JHN.16.33', 'PSA.34.8',
    'MAT.22.37', 'ROM.15.13', 'PSA.103.12', 'JHN.1.1', 'GAL.2.20',
    'PHP.1.6', 'MAT.19.26', 'PSA.62.1', 'JHN.3.17', 'ISA.26.3',
    '2CH.7.14', 'MAT.5.3', 'PSA.16.11', 'JHN.14.27', 'REV.3.20',
  ];
}

// ─── Data Models ───────────────────────────────────────────────────────────

class BibleInfo {
  final int id;
  final String title;
  final String abbreviation;
  final String languageTag;

  const BibleInfo({
    required this.id,
    required this.title,
    required this.abbreviation,
    required this.languageTag,
  });

  factory BibleInfo.fromJson(Map<String, dynamic> j) => BibleInfo(
    id: j['id'] as int? ?? 0,
    title: j['title'] as String? ?? j['localized_title'] as String? ?? '',
    abbreviation: j['abbreviation'] as String? ?? '',
    languageTag: j['language_tag'] as String? ?? '',
  );
}

class BibleBook {
  final String id;
  final String name;
  final String abbreviation;
  final List<BibleChapter> chapters;

  const BibleBook({
    required this.id,
    required this.name,
    required this.abbreviation,
    this.chapters = const [],
  });

  factory BibleBook.fromJson(Map<String, dynamic> j) => BibleBook(
    id: j['id'] as String? ?? '',
    name: j['title'] as String? ?? '',
    abbreviation: j['abbreviation'] as String? ?? '',
    chapters:
        (j['chapters'] as List?)
            ?.map((e) => BibleChapter.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

class BibleChapter {
  final int id;
  /// Human-readable chapter number string (e.g. "1", "2")
  final String number;
  /// USFM passage ID used for API calls (e.g. "GEN.1")
  final String passageId;

  const BibleChapter({
    required this.id,
    required this.number,
    required this.passageId,
  });

  factory BibleChapter.fromJson(Map<String, dynamic> j) {
    final titleRaw = j['title'];
    final idRaw = j['id'];
    final num = titleRaw?.toString() ?? idRaw?.toString() ?? '';
    return BibleChapter(
      id: int.tryParse(idRaw?.toString() ?? '') ?? 0,
      number: num,
      passageId: j['passage_id'] as String? ?? '',
    );
  }
}

class BiblePassage {
  final String id;
  final String reference;
  final String content;
  // YouVersion does not return per-passage copyright; always empty.
  final String copyright;

  const BiblePassage({
    required this.id,
    required this.reference,
    required this.content,
    this.copyright = '',
  });

  factory BiblePassage.fromJson(Map<String, dynamic> j) => BiblePassage(
    id: j['id'] as String? ?? '',
    reference: j['reference'] as String? ?? '',
    content: _cleanContent(j['content'] as String? ?? ''),
  );

  // Heading marker used to embed section titles in plain text
  static const headingMarker = '\x01';

  static String _cleanContent(String raw) {
    // 1. Convert heading tags → \x01Title\x01 markers before stripping HTML
    final headingRe = RegExp(
        r'<\s*(h[1-6])[^>]*>(.*?)<\s*/\s*h[1-6]\s*>',
        caseSensitive: false, dotAll: true);
    String s = raw.replaceAllMapped(headingRe, (m) {
      final text = m.group(2)!
          .replaceAll(RegExp(r'<[^>]*>'), '')
          .trim();
      if (text.isEmpty) return '';
      return '\n$headingMarker$text$headingMarker\n';
    });
    // 2. Strip remaining HTML tags, verse-number brackets, extra spaces
    s = s
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll(RegExp(r'\[\d+\]'), '')
        .replaceAll(RegExp(r' {2,}'), ' ')
        .trim();
    return s;
  }
}

/// Kept for search UI compatibility — YouVersion API does not expose a search
/// endpoint, so search results will always be empty.
class BibleSearchVerse {
  final String id;
  final String reference;
  final String text;

  const BibleSearchVerse({
    required this.id,
    required this.reference,
    required this.text,
  });

  factory BibleSearchVerse.fromJson(Map<String, dynamic> j) => BibleSearchVerse(
    id: j['id'] as String? ?? '',
    reference: j['reference'] as String? ?? '',
    text: BiblePassage._cleanContent(j['text'] as String? ?? ''),
  );
}

class BibleSearchResult {
  final String query;
  final int total;
  final List<BibleSearchVerse> verses;

  const BibleSearchResult({
    required this.query,
    required this.total,
    this.verses = const [],
  });
}
