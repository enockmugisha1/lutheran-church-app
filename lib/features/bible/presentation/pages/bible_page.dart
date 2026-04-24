import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:lutheran/core/controllers/bible_controller.dart';
import 'package:lutheran/core/localization/app_localizations.dart';
import 'package:lutheran/core/services/bible_api_service.dart';
import 'package:lutheran/core/services/db_service.dart';
import 'package:lutheran/core/services/local_bible_service.dart';
import 'package:lutheran/core/services/english_bible_service.dart';
import 'package:lutheran/core/services/notification_service.dart';

// ─── Brand colours ────────────────────────────────────────────────────────────
const _kNavy   = Color(0xFF0D1B3E);
const _kNavy2  = Color(0xFF1A2456);
const _kPurple = Color(0xFF2D1B69);
const _kGold   = Color(0xFFD4AF37);
const _kGoldDim= Color(0xFFB8860B);
const _kCardDk = Color(0xFF131929);
const _kSurfDk = Color(0xFF1C2340);
const _kBorderDk = Color(0xFF2A3050);

// ─── Language list ─────────────────────────────────────────────────────────────
// Kinyarwanda first (primary audience), then sorted by relevance.
const _kLanguages = [
  ('Kinyarwanda',   'rw'),  // Bibiliya Yera, Bibiliya Ntagatifu
  ('All / Byose',   '*'),   // All available Bibles
  ('English',       'en'),
  ('Français',      'fr'),
  ('Kiswahili',     'sw'),
  ('Deutsch',       'de'),
  ('Español',       'es'),
  ('हिन्दी',         'hi'),
  ('Ελληνικά',      'grc'),
  ('Sanskrit',      'sa'),
  ('اردو',          'ur'),
  ('中文',           'zh-Hans'),
  ('Nederlands',    'nl'),
  ('Polski',        'pl'),
  ('Bahasa',        'id'),
];

// ─── OT book IDs ─────────────────────────────────────────────────────────────
const _kOtIds = {
  'GEN','EXO','LEV','NUM','DEU','JOS','JDG','RUT','1SA','2SA',
  '1KI','2KI','1CH','2CH','EZR','NEH','EST','JOB','PSA','PRO',
  'ECC','SNG','ISA','JER','LAM','EZK','DAN','HOS','JOL','AMO',
  'OBA','JON','MIC','NAH','HAB','ZEP','HAG','ZEC','MAL',
};

// ═════════════════════════════════════════════════════════════════════════════
//  BiblePage — root

// ═════════════════════════════════════════════════════════════════════════════
//  BiblePage — root (clean, no tabs)
// ═════════════════════════════════════════════════════════════════════════════
class BiblePage extends StatefulWidget {
  const BiblePage({super.key});
  @override
  State<BiblePage> createState() => _BiblePageState();
}

class _BiblePageState extends State<BiblePage> {
  late final BibleController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.put(BibleController());
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = dark ? const Color(0xFF0F0F0F) : Colors.white;
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 18,
        title: Text('Bibiliya Yera',
          style: GoogleFonts.cinzel(
            fontSize: 17, fontWeight: FontWeight.w800,
            color: dark ? Colors.white : Colors.black,
          )),
        actions: [
          Obx(() => GestureDetector(
            onTap: () => _showVersionSheet(context, dark),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: dark ? Colors.white12 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: dark ? Colors.white24 : Colors.grey.shade300),
              ),
              child: Text(_ctrl.bibleAbbr.value,
                style: GoogleFonts.lato(
                  fontSize: 11, fontWeight: FontWeight.w800,
                  color: dark ? Colors.white : Colors.black,
                )),
            ),
          )),
        ],
      ),
      body: _BooksView(ctrl: _ctrl),
    );
  }

  void _showVersionSheet(BuildContext context, bool dark) {
    _ctrl.loadBiblesForLanguage('*');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: dark ? const Color(0xFF141414) : Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _VersionPickerSheet(ctrl: _ctrl, isDark: dark),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
//  Books view — simple clean list
// ═════════════════════════════════════════════════════════════════════════════
class _BooksView extends StatefulWidget {
  final BibleController ctrl;
  const _BooksView({required this.ctrl});
  @override
  State<_BooksView> createState() => _BooksViewState();
}

class _BooksViewState extends State<_BooksView> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context)!;
    return Obx(() {
      if (widget.ctrl.isLoadingBooks.value) {
        return Center(child: CircularProgressIndicator(
          color: dark ? Colors.white54 : Colors.black38));
      }
      if (widget.ctrl.books.isEmpty) {
        return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.wifi_off_rounded, size: 48,
              color: dark ? Colors.white24 : Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(loc.noInternetRetry,
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade500)),
          const SizedBox(height: 16),
          TextButton(onPressed: widget.ctrl.loadBooks, child: const Text('Ongera ugerageze')),
        ]));
      }

      final q = _query.toLowerCase();
      final filtered = q.isEmpty
          ? widget.ctrl.books.toList()
          : widget.ctrl.books.where((b) =>
              b.name.toLowerCase().contains(q) ||
              b.id.toLowerCase().contains(q)).toList();
      final ot = filtered.where((b) => _kOtIds.contains(b.id)).toList();
      final nt = filtered.where((b) => !_kOtIds.contains(b.id)).toList();

      final isKjv = widget.ctrl.selectedBibleId.value == BibleApiService.kKjvId;
      final verseResults = q.length >= 3
          ? (isKjv
              ? EnglishBibleService.search(q, limit: 15)
              : LocalBibleService.search(q, limit: 15))
          : <LocalVerseResult>[];

      return Column(children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _searchCtrl,
            onChanged: (v) => setState(() => _query = v),
            style: GoogleFonts.lato(fontSize: 14,
                color: dark ? Colors.white : Colors.black),
            decoration: InputDecoration(
              hintText: loc.search,
              hintStyle: GoogleFonts.lato(fontSize: 13,
                  color: dark ? Colors.white38 : Colors.grey.shade400),
              prefixIcon: Icon(Icons.search_rounded, size: 18,
                  color: dark ? Colors.white38 : Colors.grey.shade500),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.close_rounded, size: 16,
                          color: dark ? Colors.white38 : Colors.grey.shade500),
                      onPressed: () { _searchCtrl.clear(); setState(() => _query = ''); })
                  : null,
              filled: true,
              fillColor: dark ? const Color(0xFF1A1A1A) : Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 40),
            children: [
              // Verse search results
              if (verseResults.isNotEmpty) ...[
                _SectionHeader('IBYAVUYE', dark),
                ...verseResults.map((r) => _VerseResultTile(
                    result: r, dark: dark, ctrl: widget.ctrl)),
                const SizedBox(height: 8),
              ],
              if (ot.isNotEmpty) ...[
                _SectionHeader(loc.oldTestament.toUpperCase(), dark,
                    subtitle: '${ot.length} ibitabo'),
                ...ot.map((b) => _BookListTile(book: b, dark: dark, ctrl: widget.ctrl)),
              ],
              if (nt.isNotEmpty) ...[
                _SectionHeader(loc.newTestament.toUpperCase(), dark,
                    subtitle: '${nt.length} ibitabo'),
                ...nt.map((b) => _BookListTile(book: b, dark: dark, ctrl: widget.ctrl)),
              ],
              if (filtered.isEmpty && verseResults.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Center(child: Text('Nta gitabo cyabonetse',
                    style: GoogleFonts.lato(
                        fontSize: 13, color: Colors.grey.shade500))),
                ),
            ],
          ),
        ),
      ]);
    });
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final bool dark;
  final String? subtitle;
  const _SectionHeader(this.title, this.dark, {this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Row(
        children: [
          Text(title, style: GoogleFonts.lato(
            fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.4,
            color: dark ? Colors.white38 : Colors.grey.shade500)),
          if (subtitle != null) ...[
            const SizedBox(width: 8),
            Text(subtitle!, style: GoogleFonts.lato(
              fontSize: 10, color: dark ? Colors.white24 : Colors.grey.shade400)),
          ],
        ],
      ),
    );
  }
}

class _BookListTile extends StatelessWidget {
  final BibleBook book;
  final bool dark;
  final BibleController ctrl;
  const _BookListTile({required this.book, required this.dark, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ctrl.selectBook(book);
        Navigator.push(context, _slideRoute(_ChapterGridPage(ctrl: ctrl, book: book)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(children: [
          Expanded(child: Text(book.name, style: GoogleFonts.lato(
            fontSize: 15, fontWeight: FontWeight.w600,
            color: dark ? Colors.white : Colors.black))),
          Text('${book.chapters.length}', style: GoogleFonts.lato(
            fontSize: 12, color: dark ? Colors.white38 : Colors.grey.shade400)),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right_rounded, size: 18,
              color: dark ? Colors.white24 : Colors.grey.shade300),
        ]),
      ),
    );
  }
}

class _VerseResultTile extends StatelessWidget {
  final LocalVerseResult result;
  final bool dark;
  final BibleController ctrl;
  const _VerseResultTile({required this.result, required this.dark, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final book = ctrl.books.firstWhereOrNull((b) => b.id == result.bookId);
        if (book != null) {
          ctrl.selectBook(book);
          final ch = book.chapters.firstWhereOrNull(
              (c) => c.passageId == '${result.bookId}.${result.chapter}');
          if (ch != null) {
            ctrl.selectChapter(ch);
            Navigator.push(context, _slideRoute(_ChapterGridPage(ctrl: ctrl, book: book)));
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${ctrl.selectedBibleId.value == BibleApiService.kKjvId ? result.bookNameEn : result.bookName} ${result.chapter}:${result.verse}',
            style: GoogleFonts.lato(fontSize: 11, fontWeight: FontWeight.w700,
                color: dark ? Colors.white54 : Colors.grey.shade500)),
          const SizedBox(height: 3),
          Text(result.text, maxLines: 2, overflow: TextOverflow.ellipsis,
            style: GoogleFonts.lato(fontSize: 13, height: 1.5,
                color: dark ? Colors.white : Colors.black)),
        ]),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
//  Version picker bottom sheet
// ═════════════════════════════════════════════════════════════════════════════
class _VersionPickerSheet extends StatefulWidget {
  final BibleController ctrl;
  final bool isDark;
  const _VersionPickerSheet({required this.ctrl, required this.isDark});
  @override
  State<_VersionPickerSheet> createState() => _VersionPickerSheetState();
}

class _VersionPickerSheetState extends State<_VersionPickerSheet> {
  String _selectedLang = '*';
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      widget.ctrl.bibleSearchQuery.value = _searchCtrl.text;
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = widget.isDark;
    final bg = dark ? const Color(0xFF141414) : Colors.white;
    final fg = dark ? Colors.white : Colors.black;
    final divColor = dark ? Colors.white10 : Colors.grey.shade200;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, scrollCtrl) => Column(children: [
        // Handle
        Center(child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          width: 36, height: 4,
          decoration: BoxDecoration(
            color: dark ? Colors.white24 : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(2)),
        )),
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
          child: Row(children: [
            Text(AppLocalizations.of(context)!.selectVersion,
              style: GoogleFonts.cinzel(fontSize: 15, fontWeight: FontWeight.w800, color: fg)),
            const Spacer(),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.close_rounded, size: 20,
                  color: dark ? Colors.white54 : Colors.grey.shade500)),
          ]),
        ),
        // Search
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
          child: TextField(
            controller: _searchCtrl,
            style: GoogleFonts.lato(fontSize: 14, color: fg),
            decoration: InputDecoration(
              hintText: 'Shakisha inyandiko...',
              hintStyle: GoogleFonts.lato(color: dark ? Colors.white38 : Colors.grey.shade400),
              prefixIcon: Icon(Icons.search_rounded, size: 18,
                  color: dark ? Colors.white38 : Colors.grey.shade500),
              filled: true,
              fillColor: dark ? Colors.white10 : Colors.grey.shade100,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        // Language chips
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            children: _kLanguages.map((lang) {
              final selected = _selectedLang == lang.$2;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedLang = lang.$2);
                  widget.ctrl.loadBiblesForLanguage(lang.$2);
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: selected
                        ? (dark ? Colors.white : Colors.black)
                        : (dark ? Colors.white10 : Colors.grey.shade100),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(lang.$1, style: GoogleFonts.lato(
                    fontSize: 12, fontWeight: FontWeight.w600,
                    color: selected
                        ? (dark ? Colors.black : Colors.white)
                        : (dark ? Colors.white54 : Colors.grey.shade600))),
                ),
              );
            }).toList(),
          ),
        ),
        Divider(height: 20, color: divColor),
        // Bible list
        Expanded(
          child: Obx(() {
            if (widget.ctrl.isLoadingBibles.value) {
              return const Center(child: CircularProgressIndicator());
            }
            final bibles = widget.ctrl.filteredBibles;
            if (bibles.isEmpty) {
              return Center(child: Text('Nta Bibiliya ibonetse',
                style: GoogleFonts.lato(color: Colors.grey.shade500)));
            }
            return ListView.builder(
              controller: scrollCtrl,
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 40),
              itemCount: bibles.length,
              itemBuilder: (context, i) {
                final bible = bibles[i];
                final isActive = widget.ctrl.selectedBibleId.value == bible.id;
                return InkWell(
                  onTap: () async {
                    await widget.ctrl.switchBible(bible);
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: isActive
                              ? (dark ? Colors.white : Colors.black)
                              : (dark ? Colors.white10 : Colors.grey.shade100),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(child: Text(
                          bible.abbreviation.length > 4
                              ? bible.abbreviation.substring(0, 4) : bible.abbreviation,
                          style: GoogleFonts.lato(fontSize: 11, fontWeight: FontWeight.w800,
                            color: isActive
                                ? (dark ? Colors.black : Colors.white)
                                : (dark ? Colors.white70 : Colors.black)),
                        )),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(bible.title, style: GoogleFonts.lato(
                            fontSize: 13, fontWeight: FontWeight.w700, color: fg),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                          if (bible.languageTag.isNotEmpty)
                            Text(bible.languageTag, style: GoogleFonts.lato(
                              fontSize: 11, color: dark ? Colors.white38 : Colors.grey.shade500)),
                        ],
                      )),
                      if (isActive)
                        Icon(Icons.check_rounded, size: 18,
                            color: dark ? Colors.white : Colors.black),
                    ]),
                  ),
                );
              },
            );
          }),
        ),
      ]),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
//  Chapter grid page — clean
// ═════════════════════════════════════════════════════════════════════════════
class _ChapterGridPage extends StatelessWidget {
  final BibleController ctrl;
  final BibleBook book;
  const _ChapterGridPage({required this.ctrl, required this.book});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = dark ? const Color(0xFF0F0F0F) : Colors.white;
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20,
              color: dark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(book.name, style: GoogleFonts.cinzel(
          fontSize: 16, fontWeight: FontWeight.w800,
          color: dark ? Colors.white : Colors.black)),
      ),
      body: Obx(() {
        if (ctrl.isLoadingChapters.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final chapters = ctrl.chapters.isEmpty ? book.chapters : ctrl.chapters;
        if (chapters.isEmpty) {
          return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.error_outline_rounded, size: 40,
                color: dark ? Colors.white24 : Colors.grey.shade300),
            const SizedBox(height: 12),
            Text('Nta migabane ibonetse', style: GoogleFonts.lato(
                fontSize: 14, color: Colors.grey.shade500)),
            const SizedBox(height: 16),
            TextButton(onPressed: () => ctrl.selectBook(book),
                child: const Text('Ongera ugerageze')),
          ]));
        }
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5, crossAxisSpacing: 10, mainAxisSpacing: 10),
          itemCount: chapters.length,
          itemBuilder: (context, i) {
            final ch = chapters[i];
            return GestureDetector(
              onTap: () {
                ctrl.selectChapter(ch);
                Navigator.push(context,
                    _slideRoute(_ChapterReaderPage(ctrl: ctrl, book: book, chapter: ch)));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: dark ? const Color(0xFF1A1A1A) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: dark ? Colors.white10 : Colors.grey.shade200),
                ),
                child: Center(child: Text(
                  ch.number,
                  style: GoogleFonts.lato(fontSize: 15, fontWeight: FontWeight.w700,
                      color: dark ? Colors.white : Colors.black),
                )),
              ),
            );
          },
        );
      }),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
//  Sub-page: Chapter reader (clean YouVersion-style)
// ═════════════════════════════════════════════════════════════════════════════
class _ChapterReaderPage extends StatefulWidget {
  final BibleController ctrl;
  final BibleBook book;
  final BibleChapter chapter;
  const _ChapterReaderPage({
    required this.ctrl,
    required this.book,
    required this.chapter,
  });

  @override
  State<_ChapterReaderPage> createState() => _ChapterReaderPageState();
}

// ── Text segment (heading or body) ───────────────────────────────────────────
class _TextSegment {
  final String text;
  final bool isHeading;
  const _TextSegment(this.text, {this.isHeading = false});
}

List<_TextSegment> _splitHeadings(String content) {
  const m = BiblePassage.headingMarker;
  final parts = content.split(m);
  final result = <_TextSegment>[];
  for (int i = 0; i < parts.length; i++) {
    final p = parts[i].trim();
    if (p.isEmpty) continue;
    // odd-indexed parts (between markers) are headings
    result.add(_TextSegment(p, isHeading: i.isOdd));
  }
  return result;
}

// Highlight palette — user picks one of these
const _kHighlightColors = [
  Color(0xFFFFEB9A), // yellow
  Color(0xFFB5EAB5), // green
  Color(0xFFB3D9FF), // blue
  Color(0xFFFFB3B3), // red/pink
  Color(0xFFD9B3FF), // purple
];

/// One saved word-highlight range inside a verse.
class _WordHl {
  final int id;
  final int startOff;
  final int endOff;
  final int colorIdx;
  const _WordHl({required this.id, required this.startOff,
      required this.endOff, required this.colorIdx});
}

class _ChapterReaderPageState extends State<_ChapterReaderPage> {
  double _fontSize = 17;
  int? _selectedVerse;                       // verse number currently tapped
  Map<int, int> _highlights = {};            // verse → whole-verse color index
  Map<int, List<_WordHl>> _wordHighlights = {}; // verse → word ranges
  Set<int> _saved = {};
  // Word selection captured from SelectableText — shown in action bar
  ({int verse, int start, int end})? _wordSel;

  String get _bookId {
    // passageId is like "GEN.1" — take the part before the dot
    final parts = widget.chapter.passageId.split('.');
    return parts.isNotEmpty ? parts.first : widget.book.id;
  }

  int get _chapterNum => int.tryParse(widget.chapter.number) ?? 1;

  @override
  void initState() {
    super.initState();
    _loadDbData();
  }

  Future<void> _loadDbData() async {
    final h = await DbService.instance.getChapterHighlights(
        bookId: _bookId, chapter: _chapterNum);
    // Word highlights use sqflite features not available on web.
    final wh = kIsWeb
        ? <int, List<Map<String, int>>>{}
        : await DbService.instance.getChapterWordHighlights(
            bookId: _bookId, chapter: _chapterNum);
    if (!mounted) return;
    setState(() {
      _highlights = h;
      _wordHighlights = {
        for (final e in wh.entries)
          e.key: e.value.map((m) => _WordHl(
            id:       m['id']!,
            startOff: m['start_off']!,
            endOff:   m['end_off']!,
            colorIdx: m['color']!,
          )).toList(),
      };
    });
  }

  Future<void> _saveWordHighlight(int verseNum, int start, int end, int colorIdx) async {
    if (kIsWeb) return;
    await DbService.instance.setWordHighlight(
      bookId: _bookId, chapter: _chapterNum, verse: verseNum,
      startOff: start, endOff: end, color: colorIdx,
    );
    await _loadDbData();
  }

  Future<void> _clearWordHighlights(int verseNum) async {
    await DbService.instance.removeWordHighlightsForVerse(
      bookId: _bookId, chapter: _chapterNum, verse: verseNum,
    );
    if (mounted) setState(() => _wordHighlights.remove(verseNum));
  }

  List<TextSpan> _spansForVerse(String text, List<_WordHl>? whs, bool dark) {
    final fg = dark ? const Color(0xFFEEECE5) : const Color(0xFF1A1A1A);
    final base = GoogleFonts.notoSerif(
        fontSize: _fontSize, height: 1.85, color: fg, letterSpacing: 0.1);
    if (whs == null || whs.isEmpty) return [TextSpan(text: text, style: base)];

    final sorted = List<_WordHl>.from(whs)
      ..sort((a, b) => a.startOff.compareTo(b.startOff));
    final spans = <TextSpan>[];
    int cursor = 0;
    for (final hl in sorted) {
      final s = hl.startOff.clamp(0, text.length);
      final e = hl.endOff.clamp(0, text.length);
      if (s > cursor) spans.add(TextSpan(text: text.substring(cursor, s), style: base));
      if (e > s) {
        final hlColor = _kHighlightColors[hl.colorIdx % _kHighlightColors.length];
        spans.add(TextSpan(
          text: text.substring(s, e),
          style: base.copyWith(backgroundColor: hlColor.withValues(alpha: 0.55)),
        ));
      }
      cursor = e;
    }
    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor), style: base));
    }
    return spans;
  }

  List<LocalVerse> get _localVerses {
    final bibleId = widget.ctrl.selectedBibleId.value;
    if (bibleId == BibleApiService.kBysbId) {
      // Kinyarwanda local Bible
      return LocalBibleService.bookById(_bookId)
              ?.chapterByNumber(_chapterNum)?.verses ?? [];
    } else if (bibleId == BibleApiService.kKjvId) {
      // English KJV — bundled offline
      return EnglishBibleService.bookById(_bookId)
              ?.chapterByNumber(_chapterNum)?.verses ?? [];
    }
    return []; // other versions: fall through to API reader
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = dark ? const Color(0xFF0F0F0F) : Colors.white;
    final fg = dark ? const Color(0xFFEEECE5) : const Color(0xFF1A1A1A);
    final verses = _localVerses;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: dark ? Colors.white : Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${widget.book.name} ${widget.chapter.number}',
          style: GoogleFonts.lato(
            fontSize: 15, fontWeight: FontWeight.w700,
            color: dark ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.text_fields_rounded,
                color: dark ? Colors.white54 : Colors.grey.shade500, size: 20),
            onPressed: () => _showFontSheet(context, dark),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: GestureDetector(
        onTap: () => setState(() => _selectedVerse = null),
        child: verses.isNotEmpty
            ? _buildLocalReader(verses, dark, fg)
            : _buildApiReader(dark, fg),
      ),
      bottomNavigationBar: _selectedVerse != null
          ? _VerseActionBar(
              verse: _selectedVerse!,
              bookId: _bookId,
              bookName: widget.book.name,
              chapter: _chapterNum,
              verseText: verses.isNotEmpty
                  ? (verses.firstWhere((v) => v.number == _selectedVerse,
                          orElse: () => const LocalVerse(number: 0, text: '')).text)
                  : '',
              highlights: _highlights,
              isDark: dark,
              onHighlight: (verseNum, colorIdx) async {
                if (colorIdx < 0) {
                  await DbService.instance.removeHighlight(
                      bookId: _bookId, chapter: _chapterNum, verse: verseNum);
                  setState(() {
                    _highlights.remove(verseNum);
                    _selectedVerse = null;
                  });
                } else {
                  await DbService.instance.setHighlight(
                      bookId: _bookId, chapter: _chapterNum,
                      verse: verseNum, color: colorIdx);
                  setState(() {
                    _highlights[verseNum] = colorIdx;
                    _selectedVerse = null;
                  });
                }
              },
              onSave: (verseNum, text) async {
                final isSaved = _saved.contains(verseNum);
                if (isSaved) {
                  await DbService.instance.unsaveVerse(
                      bookId: _bookId, chapter: _chapterNum, verse: verseNum);
                  setState(() { _saved.remove(verseNum); _selectedVerse = null; });
                } else {
                  await DbService.instance.saveVerse(
                    bookId: _bookId, bookName: widget.book.name,
                    chapter: _chapterNum, verse: verseNum, text: text);
                  setState(() { _saved.add(verseNum); _selectedVerse = null; });
                  // Notify the user
                  await NotificationService.showInstant(
                    title: '${widget.book.name} $_chapterNum:$verseNum',
                    body: text,
                  );
                }
              },
              onNote: (verseNum, text) => _showNoteSheet(context, dark, verseNum, text),
              onDismiss: () => setState(() {
                _selectedVerse = null;
                _wordSel = null;
              }),
              wordSel: _wordSel,
              onWordHighlight: (colorIdx) async {
                final ws = _wordSel;
                if (ws == null) return;
                await _saveWordHighlight(ws.verse, ws.start, ws.end, colorIdx);
                setState(() { _wordSel = null; _selectedVerse = null; });
              },
              onClearWordHighlight: () async {
                final ws = _wordSel;
                if (ws != null) await _clearWordHighlights(ws.verse);
                setState(() { _wordSel = null; _selectedVerse = null; });
              },
            )
          : _ChapterNavBar(
              book: widget.book,
              chapter: widget.chapter,
              isDark: dark,
              ctrl: widget.ctrl,
            ),
    );
  }

  Widget _buildLocalReader(List<LocalVerse> verses, bool dark, Color fg) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
          22, 12, 22, MediaQuery.of(context).padding.bottom + 24),
      itemCount: verses.length + 1,
      itemBuilder: (context, i) {
        // Header: large chapter number
        if (i == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 28, top: 12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.chapter.number,
                  style: GoogleFonts.cinzel(
                    fontSize: 64, fontWeight: FontWeight.w800,
                    color: dark ? Colors.white : Colors.black,
                    height: 1.0,
                  )),
              Text(widget.book.name,
                  style: GoogleFonts.lato(
                    fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.5,
                    color: dark ? Colors.white38 : Colors.grey.shade500,
                  )),
            ]),
          );
        }
        final v = verses[i - 1];
        final isSelected = _selectedVerse == v.number;
        final hlIdx = _highlights[v.number];
        final hlColor = hlIdx != null ? _kHighlightColors[hlIdx] : null;
        final isSavedVerse = _saved.contains(v.number);
        return GestureDetector(
          onTap: () => setState(() =>
              _selectedVerse = isSelected ? null : v.number),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.only(bottom: 2),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected
                  ? (dark ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.05))
                  : hlColor?.withValues(alpha: dark ? 0.25 : 0.35),
              borderRadius: BorderRadius.circular(6),
            ),
            child: SelectableText.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: ' ${v.number} ',
                    style: GoogleFonts.lato(
                      fontSize: _fontSize * 0.65,
                      fontWeight: FontWeight.w700,
                      color: dark ? Colors.white38 : Colors.grey.shade400,
                      height: 0,
                    ),
                  ),
                  if (isSavedVerse)
                    WidgetSpan(
                      child: Icon(Icons.bookmark_rounded,
                          size: _fontSize * 0.65,
                          color: dark ? Colors.white38 : Colors.grey.shade400),
                    ),
                  // Verse text — splits into coloured spans where word highlights exist
                  ..._spansForVerse(v.text, _wordHighlights[v.number], dark),
                ],
              ),
              // When user selects text: capture range, open bottom action bar,
              // then return the native Copy toolbar so selection handles stay.
              contextMenuBuilder: (ctx, editState) {
                final sel = editState.textEditingValue.selection;
                final prefixLen = ' ${v.number} '.length + (isSavedVerse ? 1 : 0);
                if (sel.isValid && !sel.isCollapsed) {
                  final s = (sel.start - prefixLen).clamp(0, v.text.length);
                  final e = (sel.end   - prefixLen).clamp(0, v.text.length);
                  if (e > s) {
                    // Defer so we don't call setState inside build
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          _selectedVerse = v.number;
                          _wordSel = (verse: v.number, start: s, end: e);
                        });
                      }
                    });
                  }
                }
                // Native toolbar (Copy / Select All) stays on screen
                return AdaptiveTextSelectionToolbar.editableText(
                    editableTextState: editState);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildApiReader(bool dark, Color fg) {
    return Obx(() {
      if (widget.ctrl.isLoadingPassage.value) {
        return const Center(child: CircularProgressIndicator());
      }
      final p = widget.ctrl.currentPassage.value;
      if (p == null || p.content.isEmpty) {
        return Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.error_outline_rounded, size: 40,
                color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text('Nta nyandiko ibonetse',
                style: GoogleFonts.lato(color: Colors.grey.shade500)),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => widget.ctrl.selectChapter(widget.chapter),
              child: const Text('Ongera ugerageze'),
            ),
          ]),
        );
      }
      final segments = _splitHeadings(p.content);
      return ListView.builder(
        padding: EdgeInsets.fromLTRB(
            22, 12, 22, MediaQuery.of(context).padding.bottom + 80),
        itemCount: segments.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 28, top: 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.chapter.number,
                    style: GoogleFonts.cinzel(fontSize: 64,
                        fontWeight: FontWeight.w800,
                        color: dark ? Colors.white : Colors.black, height: 1.0)),
                Text(widget.book.name,
                    style: GoogleFonts.lato(fontSize: 13, fontWeight: FontWeight.w600,
                        color: dark ? Colors.white38 : Colors.grey.shade500)),
              ]),
            );
          }
          final seg = segments[i - 1];
          if (seg.isHeading) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
              child: Text(seg.text,
                  style: GoogleFonts.lato(
                    fontSize: _fontSize - 1, fontWeight: FontWeight.w800,
                    color: dark ? Colors.white : Colors.black,
                    letterSpacing: 0.1,
                  )),
            );
          }
          return Text(seg.text,
              style: GoogleFonts.notoSerif(
                  fontSize: _fontSize, height: 1.85, color: fg, letterSpacing: 0.1));
        },
      );
    });
  }

  void _showFontSheet(BuildContext context, bool dark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: dark ? const Color(0xFF1A1A1A) : Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Ubunini bw\'inyuguti',
              style: GoogleFonts.cinzel(fontSize: 15, fontWeight: FontWeight.w700,
                  color: dark ? Colors.white : Colors.black)),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            IconButton(
              icon: Icon(Icons.remove_rounded,
                  color: dark ? Colors.white : Colors.black),
              onPressed: () {
                setState(() => _fontSize = (_fontSize - 1).clamp(13, 26));
                Navigator.pop(context);
              },
            ),
            const SizedBox(width: 16),
            Text('${_fontSize.round()}',
                style: GoogleFonts.lato(fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: dark ? Colors.white : Colors.black)),
            const SizedBox(width: 16),
            IconButton(
              icon: Icon(Icons.add_rounded,
                  color: dark ? Colors.white : Colors.black),
              onPressed: () {
                setState(() => _fontSize = (_fontSize + 1).clamp(13, 26));
                Navigator.pop(context);
              },
            ),
          ]),
        ]),
      ),
    );
  }

  void _showNoteSheet(BuildContext ctx, bool dark, int verseNum, String text) {
    final ctrl = TextEditingController();
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: dark ? const Color(0xFF1A1A1A) : Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.book.name} $_chapterNum:$verseNum',
                style: GoogleFonts.lato(fontSize: 11,
                    color: dark ? Colors.white38 : Colors.grey.shade500)),
            const SizedBox(height: 4),
            Text(text,
                style: GoogleFonts.notoSerif(fontSize: 13, height: 1.6,
                    color: dark ? Colors.white70 : Colors.grey.shade700),
                maxLines: 3, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 14),
            TextField(
              controller: ctrl, maxLines: 4, autofocus: true,
              decoration: InputDecoration(
                hintText: 'Andika icyo wiyumvira...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (ctrl.text.trim().isNotEmpty) {
                    await DbService.instance.insertNote(
                      content: ctrl.text.trim(),
                      title: '${widget.book.name} $_chapterNum:$verseNum',
                      bookId: _bookId, chapter: _chapterNum, verse: verseNum,
                    );
                    ctrl.dispose();
                    if (ctx.mounted) {
                      Navigator.pop(ctx);
                      setState(() => _selectedVerse = null);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: dark ? Colors.white : Colors.black,
                  foregroundColor: dark ? Colors.black : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: Text('Bika Inyandiko',
                    style: GoogleFonts.lato(fontWeight: FontWeight.w700)),
              ),
            ),
          ]),
      ),
    );
  }

}

// ─── Chapter prev/next navigation bar ────────────────────────────────────────
class _ChapterNavBar extends StatelessWidget {
  final BibleBook book;
  final BibleChapter chapter;
  final bool isDark;
  final BibleController ctrl;
  const _ChapterNavBar({
    required this.book, required this.chapter,
    required this.isDark, required this.ctrl,
  });

  @override
  Widget build(BuildContext context) {
    final chapters = ctrl.chapters.isEmpty ? book.chapters : ctrl.chapters;
    final idx = chapters.indexWhere((c) => c.passageId == chapter.passageId);
    final hasPrev = idx > 0;
    final hasNext = idx >= 0 && idx < chapters.length - 1;
    final bg = isDark ? const Color(0xFF111111) : Colors.white;
    final fg = isDark ? Colors.white : Colors.black;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border(top: BorderSide(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
          width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 52,
          child: Row(children: [
            // Prev
            Expanded(
              child: hasPrev
                  ? InkWell(
                      onTap: () {
                        final prev = chapters[idx - 1];
                        ctrl.selectChapter(prev);
                        Navigator.pushReplacement(context,
                            _slideRoute(_ChapterReaderPage(
                                ctrl: ctrl, book: book, chapter: prev)));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chevron_left_rounded, size: 22, color: fg),
                          const SizedBox(width: 4),
                          Text(chapters[idx - 1].number,
                            style: GoogleFonts.lato(
                              fontSize: 14, fontWeight: FontWeight.w600, color: fg)),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            // Center label
            Text('${book.name} ${chapter.number}',
              style: GoogleFonts.lato(
                fontSize: 13, fontWeight: FontWeight.w700,
                color: isDark ? Colors.white54 : Colors.grey.shade500)),
            // Next
            Expanded(
              child: hasNext
                  ? InkWell(
                      onTap: () {
                        final next = chapters[idx + 1];
                        ctrl.selectChapter(next);
                        Navigator.pushReplacement(context,
                            _slideRoute(_ChapterReaderPage(
                                ctrl: ctrl, book: book, chapter: next)));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(chapters[idx + 1].number,
                            style: GoogleFonts.lato(
                              fontSize: 14, fontWeight: FontWeight.w600, color: fg)),
                          const SizedBox(width: 4),
                          Icon(Icons.chevron_right_rounded, size: 22, color: fg),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ]),
        ),
      ),
    );
  }
}


// ─── Verse action bar ─────────────────────────────────────────────────────────
class _VerseActionBar extends StatelessWidget {
  final int verse;
  final String bookId;
  final String bookName;
  final int chapter;
  final String verseText;
  final Map<int, int> highlights;
  final bool isDark;
  final void Function(int verse, int colorIdx) onHighlight;
  final void Function(int verse, String text) onSave;
  final void Function(int verse, String text) onNote;
  final VoidCallback onDismiss;
  // Word-level highlight (optional — only set when user has a text selection)
  final ({int verse, int start, int end})? wordSel;
  final void Function(int colorIdx)? onWordHighlight;
  final VoidCallback? onClearWordHighlight;

  const _VerseActionBar({
    required this.verse, required this.bookId, required this.bookName,
    required this.chapter, required this.verseText, required this.highlights,
    required this.isDark, required this.onHighlight, required this.onSave,
    required this.onNote, required this.onDismiss,
    this.wordSel, this.onWordHighlight, this.onClearWordHighlight,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF1C1C1C) : Colors.white;
    final border = isDark ? Colors.white10 : Colors.grey.shade200;
    final currentHl = highlights[verse];

    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border(top: BorderSide(color: border)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 12, offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Word highlight row (shown only when text is selected) ─────────
            if (wordSel != null) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Row(
                  children: [
                    Icon(Icons.format_color_text_rounded, size: 14,
                        color: isDark ? Colors.white54 : Colors.grey.shade600),
                    const SizedBox(width: 6),
                    Text('Highlight selected words',
                        style: GoogleFonts.lato(fontSize: 11, fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white54 : Colors.grey.shade600)),
                    const Spacer(),
                    // Clear word highlights for this verse
                    GestureDetector(
                      onTap: onClearWordHighlight,
                      child: Container(
                        width: 26, height: 26,
                        margin: const EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: isDark ? Colors.white30 : Colors.grey.shade300),
                        ),
                        child: Icon(Icons.format_color_reset_rounded, size: 13,
                            color: isDark ? Colors.white54 : Colors.grey.shade500),
                      ),
                    ),
                    // Word highlight colour swatches
                    for (int i = 0; i < _kHighlightColors.length; i++)
                      GestureDetector(
                        onTap: () => onWordHighlight?.call(i),
                        child: Container(
                          width: 26, height: 26,
                          margin: const EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                            color: _kHighlightColors[i],
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Divider(height: 1, color: isDark ? Colors.white10 : Colors.grey.shade200),
            ],
            // ── Verse highlight row ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
              child: Row(
                children: [
                  Icon(Icons.format_paint_rounded, size: 14,
                      color: isDark ? Colors.white38 : Colors.grey.shade500),
                  const SizedBox(width: 6),
                  Text('Highlight verse',
                      style: GoogleFonts.lato(fontSize: 11, fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white38 : Colors.grey.shade500)),
                  const Spacer(),
                  // Clear highlight
                  if (currentHl != null)
                    GestureDetector(
                      onTap: () => onHighlight(verse, -1),
                      child: Container(
                        width: 28, height: 28, margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: isDark ? Colors.white30 : Colors.grey.shade300),
                        ),
                        child: Icon(Icons.close_rounded, size: 14,
                            color: isDark ? Colors.white54 : Colors.grey.shade500),
                      ),
                    ),
                  // Color dots
                  for (int i = 0; i < _kHighlightColors.length; i++)
                    GestureDetector(
                      onTap: () => onHighlight(verse, i),
                      child: Container(
                        width: 28, height: 28, margin: const EdgeInsets.only(left: 6),
                        decoration: BoxDecoration(
                          color: _kHighlightColors[i],
                          shape: BoxShape.circle,
                          border: currentHl == i
                              ? Border.all(
                                  color: isDark ? Colors.white : Colors.black, width: 2)
                              : null,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Divider(height: 1, color: border),
            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ActionBtn(
                    icon: Icons.bookmark_outline_rounded,
                    label: 'Save',
                    isDark: isDark,
                    onTap: () => onSave(verse, verseText),
                  ),
                  _ActionBtn(
                    icon: Icons.edit_note_rounded,
                    label: 'Note',
                    isDark: isDark,
                    onTap: () => onNote(verse, verseText),
                  ),
                  _ActionBtn(
                    icon: Icons.copy_rounded,
                    label: 'Copy',
                    isDark: isDark,
                    onTap: () {
                      Clipboard.setData(ClipboardData(
                          text: '$verseText\n\u2014 $bookName $chapter:$verse'));
                      onDismiss();
                    },
                  ),
                  _ActionBtn(
                    icon: Icons.share_rounded,
                    label: 'Share',
                    isDark: isDark,
                    onTap: () {
                      Share.share('$verseText\n\u2014 $bookName $chapter:$verse');
                      onDismiss();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.label,
      required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = isDark ? Colors.white70 : Colors.black87;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 22, color: c),
          const SizedBox(height: 4),
          Text(label, style: GoogleFonts.lato(
              fontSize: 10, fontWeight: FontWeight.w600, color: c)),
        ]),
      ),
    );
  }
}


// ═════════════════════════════════════════════════════════════════════════════
//  Shared helpers
// ═════════════════════════════════════════════════════════════════════════════

/// Renders [text] with any occurrence of [query] highlighted.
class _HighlightText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle baseStyle;
  final TextStyle highlightStyle;

  const _HighlightText({
    required this.text,
    required this.query,
    required this.baseStyle,
    required this.highlightStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Text(text, style: baseStyle, maxLines: 2, overflow: TextOverflow.ellipsis);
    }
    final lower = text.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;
    while (true) {
      final idx = lower.indexOf(query, start);
      if (idx == -1) {
        spans.add(TextSpan(text: text.substring(start), style: baseStyle));
        break;
      }
      if (idx > start) {
        spans.add(TextSpan(text: text.substring(start, idx), style: baseStyle));
      }
      spans.add(TextSpan(
        text: text.substring(idx, idx + query.length),
        style: highlightStyle,
      ));
      start = idx + query.length;
    }
    return RichText(
      text: TextSpan(children: spans),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
class _Badge extends StatelessWidget {
  final String label;
  const _Badge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _kGold,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.lato(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white70, size: 17),
      ),
    );
  }
}

class _DbSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool dark;
  const _DbSectionHeader({required this.title, required this.icon, required this.dark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: dark ? Colors.white54 : Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.cinzel(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: dark ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final bool dark;
  const _EmptyState({required this.icon, required this.message, required this.dark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 52, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              fontSize: 14,
              color: Colors.grey.shade500,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _FullErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  final bool dark;
  final String message;

  const _FullErrorState({
    required this.onRetry,
    required this.dark,
    this.message = '',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_rounded, size: 56, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            message.isEmpty ? AppLocalizations.of(context)!.noInternetRetry : message,
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              fontSize: 15,
              color: Colors.grey.shade500,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 22),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(AppLocalizations.of(context)!.retry),
            style: ElevatedButton.styleFrom(
              backgroundColor: _kNavy2,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}

// Slide-from-right page transition
Route<T> _slideRoute<T>(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondary) => page,
    transitionsBuilder: (context, anim, secondary, child) => SlideTransition(
      position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
          .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
      child: child,
    ),
    transitionDuration: const Duration(milliseconds: 280),
  );
}
