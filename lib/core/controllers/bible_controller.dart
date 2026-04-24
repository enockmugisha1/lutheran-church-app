import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../services/bible_api_service.dart';
import '../services/local_bible_service.dart';
import '../services/english_bible_service.dart';
import '../../features/settings/presentation/providers/settings_provider.dart';

class BibleController extends GetxController {
  // Verse of the Day
  final Rx<BiblePassage?> verseOfDay = Rx<BiblePassage?>(null);
  final isLoadingVotd = false.obs;

  // Hive cache keys for VOTD
  static const String _votdBox    = 'settings';
  static const String _keyVotdRef     = 'cached_votd_ref';
  static const String _keyVotdContent = 'cached_votd_content';
  static const String _keyVotdDate    = 'cached_votd_date';

  // Hive box used for caching API chapter content offline
  static const String _chapterBox = 'chapter_cache';

  // ── Chapter offline cache helpers ─────────────────────────────────────────
  String _chapterKey(int bibleId, String passageId) =>
      'ch_${bibleId}_$passageId';

  Future<void> _cacheChapterPassage(BiblePassage p, int bibleId) async {
    try {
      final box = await Hive.openBox<String>(_chapterBox);
      final key = _chapterKey(bibleId, p.id);
      // Store as "reference\x1fcontent" to keep it in a single string
      await box.put(key, '${p.reference}\x1f${p.content}');
    } catch (_) {}
  }

  Future<BiblePassage?> _loadCachedChapterPassage(
      int bibleId, String passageId) async {
    try {
      final box = await Hive.openBox<String>(_chapterBox);
      final raw = box.get(_chapterKey(bibleId, passageId));
      if (raw == null) return null;
      final parts = raw.split('\x1f');
      if (parts.length < 2) return null;
      return BiblePassage(
          id: passageId, reference: parts[0], content: parts.sublist(1).join('\x1f'));
    } catch (_) {
      return null;
    }
  }

  // Books list
  final books = <BibleBook>[].obs;
  final isLoadingBooks = false.obs;

  // Chapters
  final chapters = <BibleChapter>[].obs;
  final selectedBook = Rx<BibleBook?>(null);
  final isLoadingChapters = false.obs;

  // Chapter reading
  final currentPassage = Rx<BiblePassage?>(null);
  final isLoadingPassage = false.obs;
  final selectedChapter = Rx<BibleChapter?>(null);

  // Search (YouVersion API has no search endpoint — results always empty)
  final searchResults = <BibleSearchVerse>[].obs;
  final isSearching = false.obs;
  final searchQuery = ''.obs;
  final searchTotal = 0.obs;

  // Selected Bible version (YouVersion integer ID) — default to Kinyarwanda
  final selectedBibleId = BibleApiService.kBysbId.obs;
  final bibleAbbr = 'BYSB'.obs;

  // Available Bibles for the current language
  final availableBibles = <BibleInfo>[].obs;
  final isLoadingBibles = false.obs;
  // Live search query for Bible version picker
  final bibleSearchQuery = ''.obs;

  /// Returns availableBibles filtered by bibleSearchQuery.
  List<BibleInfo> get filteredBibles {
    final q = bibleSearchQuery.value.toLowerCase().trim();
    if (q.isEmpty) return availableBibles;
    return availableBibles.where((b) =>
      b.title.toLowerCase().contains(q) ||
      b.abbreviation.toLowerCase().contains(q) ||
      b.languageTag.toLowerCase().contains(q),
    ).toList();
  }

  // ── Local (offline) Kinyarwanda Bible ──────────────────────────────────────
  /// All 66 books from the bundled local JSON (always available offline).
  List<LocalBook> get localBooks => LocalBibleService.books;

  /// Local-Bible chapter currently being read (offline Kinyarwanda).
  final localChapter = Rx<LocalChapter?>(null);
  final selectedLocalBook = Rx<LocalBook?>(null);
  final selectedLocalChapterNum = 1.obs;

  // Search results from local Bible
  final localSearchResults = <LocalVerseResult>[].obs;

  // Error state
  final apiError = Rx<String?>(null);

  bool get _isKinyarwanda => selectedBibleId.value == BibleApiService.kBysbId;
  bool get _isKjv        => selectedBibleId.value == BibleApiService.kKjvId;

  @override
  void onInit() {
    super.onInit();
    // Load cached VOTD instantly first, then refresh in background
    _loadCachedVotd();

    // Sync Bible version with the persisted UI language BEFORE loading VOTD
    try {
      final sp = Get.find<SettingsProvider>();
      if (sp.language.value == 'en') {
        selectedBibleId.value = BibleApiService.kKjvId;
        bibleAbbr.value = 'KJV';
      }
      // When the user toggles EN ↔ RW, reload VOTD in the new language
      ever(sp.language, (lang) {
        final isEn = lang == 'en';
        if (isEn && selectedBibleId.value == BibleApiService.kBysbId) {
          selectedBibleId.value = BibleApiService.kKjvId;
          bibleAbbr.value = 'KJV';
        } else if (!isEn && selectedBibleId.value == BibleApiService.kKjvId) {
          selectedBibleId.value = BibleApiService.kBysbId;
          bibleAbbr.value = 'BYSB';
        }
        loadVerseOfDay();
        loadBooks();
      });
    } catch (_) {
      // SettingsProvider not yet registered — language switch will still work
      // once the user manually toggles
    }

    _initAndLoad();
  }

  /// Wait for the local Bible to finish loading, then fetch VOTD & books.
  Future<void> _initAndLoad() async {
    await Future.wait([
      LocalBibleService.ensureReady(),
      EnglishBibleService.ensureReady(),
    ]);
    loadVerseOfDay();
    loadBooks();
  }

  /// Instantly load VOTD from Hive cache (no async wait).
  void _loadCachedVotd() {
    try {
      final box = Hive.box(_votdBox);
      final cachedDate = box.get(_keyVotdDate) as String?;
      final today = DateTime.now().toIso8601String().substring(0, 10);

      if (cachedDate == today) {
        final ref = box.get(_keyVotdRef) as String?;
        final content = box.get(_keyVotdContent) as String?;
        if (ref != null && content != null && content.isNotEmpty) {
          verseOfDay.value = BiblePassage(
            id: 'cached',
            reference: ref,
            content: content,
          );
        }
      }
    } catch (_) {
      // Cache miss — will load fresh below
    }
  }

  /// Save VOTD to Hive for instant loading on next app open.
  Future<void> _cacheVotd(BiblePassage passage) async {
    try {
      final box = Hive.box(_votdBox);
      final today = DateTime.now().toIso8601String().substring(0, 10);
      await box.put(_keyVotdDate, today);
      await box.put(_keyVotdRef, passage.reference);
      await box.put(_keyVotdContent, passage.content);
    } catch (_) {}
  }

  Future<void> loadVerseOfDay() async {
    isLoadingVotd.value = true;
    apiError.value = null;

    // Always read language directly from SettingsProvider — selectedBibleId
    // may not yet be synced when this is called during startup.
    bool useKinyarwanda = _isKinyarwanda;
    try {
      final sp = Get.find<SettingsProvider>();
      useKinyarwanda = sp.language.value != 'en';
      // Keep selectedBibleId in sync
      if (!useKinyarwanda && selectedBibleId.value == BibleApiService.kBysbId) {
        selectedBibleId.value = BibleApiService.kKjvId;
        bibleAbbr.value = 'KJV';
      } else if (useKinyarwanda && selectedBibleId.value == BibleApiService.kKjvId) {
        selectedBibleId.value = BibleApiService.kBysbId;
        bibleAbbr.value = 'BYSB';
      }
    } catch (_) {}

    if (useKinyarwanda) {
      final result = LocalBibleService.verseOfDay();
      if (result != null) {
        final passage = BiblePassage(
          id: '${result.bookId}.${result.chapter}.${result.verse}',
          reference: '${result.bookName} ${result.chapter}:${result.verse}',
          content: result.text,
        );
        verseOfDay.value = passage;
        await _cacheVotd(passage);
      } else {
        apiError.value = 'local_error';
      }
    } else {
      // Use bundled offline KJV — no network needed
      final offlineResult = EnglishBibleService.verseOfDay();
      if (offlineResult != null) {
        final passage = BiblePassage(
          id: '${offlineResult.bookId}.${offlineResult.chapter}.${offlineResult.verse}',
          reference: '${offlineResult.bookNameEn} ${offlineResult.chapter}:${offlineResult.verse}',
          content: offlineResult.text,
        );
        verseOfDay.value = passage;
        await _cacheVotd(passage);
      } else {
        apiError.value = 'local_error';
      }
    }
    isLoadingVotd.value = false;
  }

  /// Load Bibles for the given language tag (RFC 4647).
  /// Pass '*' to load all available Bibles across every language.
  Future<void> loadBiblesForLanguage(String languageTag) async {
    bibleSearchQuery.value = ''; // clear search when language changes
    isLoadingBibles.value = true;
    final result = await BibleApiService.fetchBibles(
      languageRanges: [languageTag],
      allPages: true,
    );
    availableBibles.assignAll(result);
    isLoadingBibles.value = false;
  }

  /// Switch to a different Bible version and reload books + VOTD.
  Future<void> switchBible(BibleInfo bible) async {
    selectedBibleId.value = bible.id;
    bibleAbbr.value = bible.abbreviation.isNotEmpty ? bible.abbreviation : bible.title;
    books.clear();
    chapters.clear();
    currentPassage.value = null;
    await Future.wait([loadVerseOfDay(), loadBooks()]);
  }

  Future<void> loadBooks() async {
    isLoadingBooks.value = true;

    if (_isKinyarwanda) {
      // Populate from bundled local Bible — instant, no network needed
      books.assignAll(
        LocalBibleService.books.map((lb) => BibleBook(
          id: lb.id,
          name: lb.name,
          abbreviation: lb.id,
          chapters: lb.chapters.map((ch) => BibleChapter(
            id: ch.number,
            number: ch.number.toString(),
            passageId: '${lb.id}.${ch.number}',
          )).toList(),
        )).toList(),
      );
    } else if (_isKjv) {
      // Use bundled KJV — no network needed
      books.assignAll(
        EnglishBibleService.books.map((lb) => BibleBook(
          id: lb.id,
          name: lb.nameEn,         // English name
          abbreviation: lb.id,
          chapters: lb.chapters.map((ch) => BibleChapter(
            id: ch.number,
            number: ch.number.toString(),
            passageId: '${lb.id}.${ch.number}',
          )).toList(),
        )).toList(),
      );
    } else {
      final result = await BibleApiService.fetchBooks(selectedBibleId.value);
      if (result.isNotEmpty) {
        books.assignAll(result);
      }
    }
    isLoadingBooks.value = false;
  }

  Future<void> selectBook(BibleBook book) async {
    selectedBook.value = book;
    chapters.clear();
    currentPassage.value = null;
    isLoadingChapters.value = true;

    if (_isKinyarwanda) {
      // Chapters already embedded in BibleBook from loadBooks()
      if (book.chapters.isNotEmpty) {
        chapters.assignAll(book.chapters);
      }
    } else {
      if (book.chapters.isNotEmpty) {
        chapters.assignAll(book.chapters);
      } else {
        final result = await BibleApiService.fetchChapters(
          selectedBibleId.value,
          book.id,
        );
        chapters.assignAll(result);
      }
    }
    isLoadingChapters.value = false;
  }

  Future<void> selectChapter(BibleChapter chapter) async {
    selectedChapter.value = chapter;
    isLoadingPassage.value = true;

    if (_isKinyarwanda) {
      // Parse "BOOKID.CHAPNUM" from passageId
      final parts = chapter.passageId.split('.');
      final bookId = parts.isNotEmpty ? parts[0] : '';
      final chNum = parts.length > 1 ? (int.tryParse(parts[1]) ?? 1) : 1;
      final localCh = LocalBibleService.chapter(bookId, chNum);

      if (localCh != null && localCh.verses.isNotEmpty) {
        // Format each verse as "number text" on its own line for clean reading
        final buffer = StringBuffer();
        for (final v in localCh.verses) {
          buffer.write('${v.number}  ${v.text}\n\n');
        }
        final book = selectedBook.value;
        final bookName = book != null ? book.name : bookId;
        currentPassage.value = BiblePassage(
          id: chapter.passageId,
          reference: '$bookName ${chapter.number}',
          content: buffer.toString().trimRight(),
        );
      } else {
        currentPassage.value = null;
      }
    } else if (_isKjv) {
      // Use bundled English KJV — fully offline
      final parts = chapter.passageId.split('.');
      final bookId = parts.isNotEmpty ? parts[0] : '';
      final chNum = parts.length > 1 ? (int.tryParse(parts[1]) ?? 1) : 1;
      final localCh = EnglishBibleService.chapter(bookId, chNum);
      if (localCh != null && localCh.verses.isNotEmpty) {
        final buffer = StringBuffer();
        for (final v in localCh.verses) {
          buffer.write('${v.number}  ${v.text}\n\n');
        }
        final book = selectedBook.value;
        final bookName = book != null ? book.name : bookId;
        currentPassage.value = BiblePassage(
          id: chapter.passageId,
          reference: '$bookName ${chapter.number}',
          content: buffer.toString().trimRight(),
        );
      } else {
        currentPassage.value = null;
      }
    } else {
      final bibleId = selectedBibleId.value;
      // Try network first; fall back to cached version when offline.
      final result = await BibleApiService.fetchChapter(bibleId, chapter.passageId);
      if (result != null) {
        currentPassage.value = result;
        _cacheChapterPassage(result, bibleId); // save for offline use
      } else {
        // Network failed — try the local cache
        currentPassage.value =
            await _loadCachedChapterPassage(bibleId, chapter.passageId);
      }
    }
    isLoadingPassage.value = false;
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      searchResults.clear();
      searchTotal.value = 0;
      return;
    }
    searchQuery.value = query;
    if (_isKinyarwanda) {
      final results = LocalBibleService.search(query, limit: 100);
      searchResults.assignAll(results.map((r) => BibleSearchVerse(
        id: '${r.bookId}.${r.chapter}.${r.verse}',
        reference: r.reference,
        text: r.text,
      )).toList());
      searchTotal.value = searchResults.length;
    } else if (_isKjv) {
      final results = EnglishBibleService.search(query, limit: 100);
      searchResults.assignAll(results.map((r) => BibleSearchVerse(
        id: '${r.bookId}.${r.chapter}.${r.verse}',
        reference: r.referenceEn,
        text: r.text,
      )).toList());
      searchTotal.value = searchResults.length;
    }
    isSearching.value = false;
  }

  void clearSearch() {
    searchResults.clear();
    searchQuery.value = '';
    searchTotal.value = 0;
  }

  // ── Local Bible (offline) methods ──────────────────────────────────────────

  /// Open a local book and load chapter 1.
  void selectLocalBook(LocalBook book) {
    selectedLocalBook.value = book;
    selectLocalChapter(1);
  }

  /// Load a specific chapter from the local Kinyarwanda Bible.
  void selectLocalChapter(int chapterNum) {
    final book = selectedLocalBook.value;
    if (book == null) return;
    selectedLocalChapterNum.value = chapterNum;
    localChapter.value = book.chapterByNumber(chapterNum);
  }

  /// Search the local Bible for [query] and populate [localSearchResults].
  void searchLocal(String query) {
    if (query.trim().isEmpty) {
      localSearchResults.clear();
      return;
    }
    localSearchResults.assignAll(
      LocalBibleService.search(query, limit: 100),
    );
  }

  void clearLocalSearch() => localSearchResults.clear();
}
