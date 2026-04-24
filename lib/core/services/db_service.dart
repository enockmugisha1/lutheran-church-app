import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const _wordHlDdl = '''
  CREATE TABLE IF NOT EXISTS word_highlights (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    book_id    TEXT NOT NULL,
    chapter    INTEGER NOT NULL,
    verse      INTEGER NOT NULL,
    start_off  INTEGER NOT NULL,
    end_off    INTEGER NOT NULL,
    color      INTEGER NOT NULL,
    created_at INTEGER NOT NULL
  )
''';

/// Singleton SQLite service — notes, saved verses, highlights.
class DbService {
  DbService._();
  static final DbService instance = DbService._();

  Database? _db;

  Future<Database> get db async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final path = join(await getDatabasesPath(), 'lcr_app.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: (db, v) async {
        await db.execute('''
          CREATE TABLE notes (
            id        INTEGER PRIMARY KEY AUTOINCREMENT,
            title     TEXT NOT NULL DEFAULT '',
            content   TEXT NOT NULL,
            book_id   TEXT,
            chapter   INTEGER,
            verse     INTEGER,
            created_at INTEGER NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE saved_verses (
            id        INTEGER PRIMARY KEY AUTOINCREMENT,
            book_id   TEXT NOT NULL,
            book_name TEXT NOT NULL,
            chapter   INTEGER NOT NULL,
            verse     INTEGER NOT NULL,
            text      TEXT NOT NULL,
            created_at INTEGER NOT NULL,
            UNIQUE(book_id, chapter, verse)
          )
        ''');
        await db.execute('''
          CREATE TABLE highlights (
            id        INTEGER PRIMARY KEY AUTOINCREMENT,
            book_id   TEXT NOT NULL,
            chapter   INTEGER NOT NULL,
            verse     INTEGER NOT NULL,
            color     INTEGER NOT NULL,
            created_at INTEGER NOT NULL,
            UNIQUE(book_id, chapter, verse)
          )
        ''');
        await db.execute(_wordHlDdl);
      },
      onUpgrade: (db, oldV, newV) async {
        if (oldV < 2) await db.execute(_wordHlDdl);
      },
    );
  }

  // ─── Notes ────────────────────────────────────────────────────────────────

  Future<int> insertNote({
    required String content,
    String title = '',
    String? bookId,
    int? chapter,
    int? verse,
  }) async {
    final d = await db;
    return d.insert('notes', {
      'title': title,
      'content': content,
      'book_id': bookId,
      'chapter': chapter,
      'verse': verse,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    final d = await db;
    return d.query('notes', orderBy: 'created_at DESC');
  }

  Future<void> deleteNote(int id) async {
    final d = await db;
    await d.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  // ─── Saved Verses ─────────────────────────────────────────────────────────

  Future<void> saveVerse({
    required String bookId,
    required String bookName,
    required int chapter,
    required int verse,
    required String text,
  }) async {
    final d = await db;
    await d.insert('saved_verses', {
      'book_id': bookId,
      'book_name': bookName,
      'chapter': chapter,
      'verse': verse,
      'text': text,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> unsaveVerse({
    required String bookId,
    required int chapter,
    required int verse,
  }) async {
    final d = await db;
    await d.delete('saved_verses',
        where: 'book_id = ? AND chapter = ? AND verse = ?',
        whereArgs: [bookId, chapter, verse]);
  }

  Future<bool> isVerseSaved({
    required String bookId,
    required int chapter,
    required int verse,
  }) async {
    final d = await db;
    final rows = await d.query('saved_verses',
        where: 'book_id = ? AND chapter = ? AND verse = ?',
        whereArgs: [bookId, chapter, verse]);
    return rows.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getAllSavedVerses() async {
    final d = await db;
    return d.query('saved_verses', orderBy: 'created_at DESC');
  }

  // ─── Highlights ───────────────────────────────────────────────────────────

  Future<void> setHighlight({
    required String bookId,
    required int chapter,
    required int verse,
    required int color,
  }) async {
    final d = await db;
    await d.insert('highlights', {
      'book_id': bookId,
      'chapter': chapter,
      'verse': verse,
      'color': color,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeHighlight({
    required String bookId,
    required int chapter,
    required int verse,
  }) async {
    final d = await db;
    await d.delete('highlights',
        where: 'book_id = ? AND chapter = ? AND verse = ?',
        whereArgs: [bookId, chapter, verse]);
  }

  /// Returns a map of verse number → color int for the given chapter.
  Future<Map<int, int>> getChapterHighlights({
    required String bookId,
    required int chapter,
  }) async {
    final d = await db;
    final rows = await d.query('highlights',
        where: 'book_id = ? AND chapter = ?',
        whereArgs: [bookId, chapter]);
    return {for (final r in rows) r['verse'] as int: r['color'] as int};
  }

  // ─── Word-level highlights ─────────────────────────────────────────────────

  /// Save (or replace) a word highlight range within a verse.
  Future<void> setWordHighlight({
    required String bookId,
    required int chapter,
    required int verse,
    required int startOff,
    required int endOff,
    required int color,
  }) async {
    final d = await db;
    await d.insert('word_highlights', {
      'book_id': bookId,
      'chapter': chapter,
      'verse': verse,
      'start_off': startOff,
      'end_off': endOff,
      'color': color,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Remove all word highlights for a specific verse.
  Future<void> removeWordHighlightsForVerse({
    required String bookId,
    required int chapter,
    required int verse,
  }) async {
    final d = await db;
    await d.delete('word_highlights',
        where: 'book_id = ? AND chapter = ? AND verse = ?',
        whereArgs: [bookId, chapter, verse]);
  }

  /// Returns word highlights for a chapter: verse → list of (id, start, end, color).
  Future<Map<int, List<Map<String, int>>>> getChapterWordHighlights({
    required String bookId,
    required int chapter,
  }) async {
    final d = await db;
    final rows = await d.query('word_highlights',
        where: 'book_id = ? AND chapter = ?',
        whereArgs: [bookId, chapter]);
    final result = <int, List<Map<String, int>>>{};
    for (final r in rows) {
      final verse = r['verse'] as int;
      result.putIfAbsent(verse, () => []).add({
        'id':        r['id'] as int,
        'start_off': r['start_off'] as int,
        'end_off':   r['end_off'] as int,
        'color':     r['color'] as int,
      });
    }
    return result;
  }
}
