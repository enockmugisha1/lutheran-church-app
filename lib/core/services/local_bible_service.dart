import 'dart:convert';
import 'package:flutter/services.dart';

/// Offline-capable service that reads the Kinyarwanda Bible
/// from the bundled JSON asset (assets/data/kinyarwanda_bible.json).
///
/// The JSON structure is:
/// {
///   "version": "Bibiliya Yera 2001",
///   "books": [
///     {
///       "id": "GEN",
///       "name": "Itangiriro",          // Kinyarwanda name
///       "name_en": "Genesis",           // English name
///       "testament": "OT",
///       "chapters": [
///         {
///           "chapter": 1,
///           "verses": [{ "verse": 1, "text": "..." }, ...]
///         }
///       ]
///     }
///   ]
/// }
class LocalBibleService {
  static const String _assetPath = 'assets/data/kinyarwanda_bible.json';

  // Singleton cache — loaded once, reused for the lifetime of the app
  static Map<String, dynamic>? _cache;
  static List<LocalBook>? _books;
  static Future<void>? _initFuture;
  static bool get isReady => _books != null;

  /// Load and cache the local Bible JSON.
  /// Safe to call multiple times — subsequent calls return the same Future.
  static Future<void> init() {
    _initFuture ??= _doInit();
    return _initFuture!;
  }

  static Future<void> _doInit() async {
    if (_cache != null) return;
    final raw = await rootBundle.loadString(_assetPath);
    _cache = jsonDecode(raw) as Map<String, dynamic>;
    _books = (_cache!['books'] as List)
        .map((b) => LocalBook.fromJson(b as Map<String, dynamic>))
        .toList();
  }

  /// Ensure the Bible is loaded before accessing data.
  static Future<void> ensureReady() => init();

  /// All 66 books in canonical order.
  static List<LocalBook> get books {
    return _books ?? [];
  }

  /// Find a book by its ID (e.g. "GEN", "JHN").
  static LocalBook? bookById(String id) {
    try {
      return books.firstWhere((b) => b.id == id.toUpperCase());
    } catch (_) {
      return null;
    }
  }

  /// Get all verses for a chapter as a [LocalChapter].
  static LocalChapter? chapter(String bookId, int chapterNum) {
    return bookById(bookId)?.chapterByNumber(chapterNum);
  }

  /// Get a single verse text, or null if not found.
  static String? verse(String bookId, int chapterNum, int verseNum) {
    return chapter(bookId, chapterNum)?.verseText(verseNum);
  }

  /// Search across all verses for the given query (case-insensitive).
  /// Returns up to [limit] results.
  static List<LocalVerseResult> search(String query, {int limit = 50}) {
    if (query.trim().isEmpty) return [];
    final q = query.toLowerCase();
    final results = <LocalVerseResult>[];
    for (final book in books) {
      for (final ch in book.chapters) {
        for (final v in ch.verses) {
          if (v.text.toLowerCase().contains(q)) {
            results.add(LocalVerseResult(
              bookId: book.id,
              bookName: book.name,
              bookNameEn: book.nameEn,
              chapter: ch.number,
              verse: v.number,
              text: v.text,
            ));
            if (results.length >= limit) return results;
          }
        }
      }
    }
    return results;
  }

  /// Returns the "Verse of the Day" from the local Bible, cycling through
  /// a curated list deterministically by day-of-year.
  static LocalVerseResult? verseOfDay() {
    final today = DateTime.now();
    final dayOfYear = today.difference(DateTime(today.year)).inDays;
    final ref = kVotdRefs[dayOfYear % kVotdRefs.length];
    final text = verse(ref.$1, ref.$2, ref.$3);
    if (text == null) return null;
    final book = bookById(ref.$1);
    if (book == null) return null;
    return LocalVerseResult(
      bookId: book.id,
      bookName: book.name,
      bookNameEn: book.nameEn,
      chapter: ref.$2,
      verse: ref.$3,
      text: text,
    );
  }

  /// Curated VOTD references (bookId, chapter, verse).
  static const List<(String, int, int)> kVotdRefs = [
    ('JHN', 3, 16),   ('PSA', 23, 1),  ('PHP', 4, 13),  ('ROM', 8, 28),
    ('JER', 29, 11),  ('ISA', 40, 31), ('PRO', 3, 5),   ('MAT', 11, 28),
    ('JOS', 1, 9),    ('PSA', 46, 1),  ('ROM', 8, 38),  ('PHP', 4, 6),
    ('MAT', 5, 14),   ('JHN', 14, 6),  ('ROM', 12, 2),  ('PSA', 119, 105),
    ('GAL', 5, 22),   ('1CO', 13, 4),  ('HEB', 11, 1),  ('PSA', 27, 1),
    ('ISA', 41, 10),  ('2TI', 1, 7),   ('MAT', 6, 33),  ('JHN', 10, 10),
    ('ROM', 5, 8),    ('EPH', 2, 8),   ('PSA', 37, 4),  ('MAT', 28, 19),
    ('REV', 21, 4),   ('PSA', 121, 1), ('JHN', 15, 13), ('ROM', 6, 23),
    ('PHP', 4, 7),    ('MAT', 6, 9),   ('PSA', 91, 1),  ('ISA', 53, 5),
    ('JHN', 11, 25),  ('1CO', 10, 13), ('HEB', 4, 16),  ('PSA', 139, 14),
    ('MAT', 5, 9),    ('ROM', 8, 1),   ('LUK', 1, 37),  ('JHN', 16, 33),
    ('PSA', 34, 8),   ('MAT', 22, 37), ('ROM', 15, 13), ('PSA', 103, 12),
    ('JHN', 1, 1),    ('GAL', 2, 20),  ('PHP', 1, 6),   ('MAT', 19, 26),
    ('PSA', 62, 1),   ('JHN', 3, 17),  ('ISA', 26, 3),  ('2CH', 7, 14),
    ('MAT', 5, 3),    ('PSA', 16, 11), ('JHN', 14, 27), ('GEN', 1, 1),
  ];
}

// ─── Models ──────────────────────────────────────────────────────────────────

class LocalBook {
  final String id;
  final String name;      // Kinyarwanda
  final String nameEn;    // English
  final String testament; // "OT" or "NT"
  final List<LocalChapter> chapters;

  const LocalBook({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.testament,
    required this.chapters,
  });

  factory LocalBook.fromJson(Map<String, dynamic> j) => LocalBook(
    id: j['id'] as String,
    name: j['name'] as String,
    nameEn: j['name_en'] as String,
    testament: j['testament'] as String,
    chapters: (j['chapters'] as List)
        .map((c) => LocalChapter.fromJson(c as Map<String, dynamic>))
        .toList(),
  );

  LocalChapter? chapterByNumber(int num) {
    try {
      return chapters.firstWhere((c) => c.number == num);
    } catch (_) {
      return null;
    }
  }

  bool get isOldTestament => testament == 'OT';
  bool get isNewTestament => testament == 'NT';
}

class LocalChapter {
  final int number;
  final List<LocalVerse> verses;

  const LocalChapter({required this.number, required this.verses});

  factory LocalChapter.fromJson(Map<String, dynamic> j) => LocalChapter(
    number: j['chapter'] as int,
    verses: (j['verses'] as List)
        .map((v) => LocalVerse.fromJson(v as Map<String, dynamic>))
        .toList(),
  );

  String? verseText(int num) {
    try {
      return verses.firstWhere((v) => v.number == num).text;
    } catch (_) {
      return null;
    }
  }
}

class LocalVerse {
  final int number;
  final String text;

  const LocalVerse({required this.number, required this.text});

  factory LocalVerse.fromJson(Map<String, dynamic> j) => LocalVerse(
    number: j['verse'] as int,
    text: j['text'] as String,
  );
}

class LocalVerseResult {
  final String bookId;
  final String bookName;
  final String bookNameEn;
  final int chapter;
  final int verse;
  final String text;

  const LocalVerseResult({
    required this.bookId,
    required this.bookName,
    required this.bookNameEn,
    required this.chapter,
    required this.verse,
    required this.text,
  });

  /// Human-readable reference, e.g. "Itangiriro 1:1"
  String get reference => '$bookName $chapter:$verse';

  /// English reference, e.g. "Genesis 1:1"
  String get referenceEn => '$bookNameEn $chapter:$verse';
}
