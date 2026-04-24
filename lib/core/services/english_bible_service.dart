import 'dart:convert';
import 'package:flutter/services.dart';
import 'local_bible_service.dart';

/// Offline English KJV Bible service.
/// Reads from assets/data/english_kjv.json — same JSON structure as the
/// Kinyarwanda Bible, so it reuses the same model classes (LocalBook, etc.).
class EnglishBibleService {
  static const String _assetPath = 'assets/data/english_kjv.json';

  static List<LocalBook>? _books;
  static Future<void>? _initFuture;
  static bool get isReady => _books != null;

  static Future<void> init() {
    _initFuture ??= _doInit();
    return _initFuture!;
  }

  static Future<void> _doInit() async {
    if (_books != null) return;
    final raw = await rootBundle.loadString(_assetPath);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    _books = (decoded['books'] as List)
        .map((b) => LocalBook.fromJson(b as Map<String, dynamic>))
        .toList();
  }

  static Future<void> ensureReady() => init();

  static List<LocalBook> get books => _books ?? [];

  static LocalBook? bookById(String id) {
    try {
      return books.firstWhere((b) => b.id == id.toUpperCase());
    } catch (_) {
      return null;
    }
  }

  static LocalChapter? chapter(String bookId, int chapterNum) =>
      bookById(bookId)?.chapterByNumber(chapterNum);

  static String? verse(String bookId, int chapterNum, int verseNum) =>
      chapter(bookId, chapterNum)?.verseText(verseNum);

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

  /// Returns the VOTD cycling through the same curated list as the Kinyarwanda
  /// service, but from the KJV text.
  static LocalVerseResult? verseOfDay() {
    final today = DateTime.now();
    final dayOfYear = today.difference(DateTime(today.year)).inDays;
    // Reuse the same curated VOTD refs list from LocalBibleService
    const refs = LocalBibleService.kVotdRefs;
    final ref = refs[dayOfYear % refs.length];
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
}
