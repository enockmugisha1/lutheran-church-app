import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/data/hymns_data.dart';

class HymnsPage extends StatefulWidget {
  const HymnsPage({super.key});

  @override
  State<HymnsPage> createState() => _HymnsPageState();
}

class _HymnsPageState extends State<HymnsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  bool _showSearch = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0F0F0F) : Colors.white;
    final fg = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final accent = const Color(0xFFC9A84C);
    final maroon = const Color(0xFF4A1028);

    final results = _query.trim().isEmpty ? null : searchHymns(_query.trim());

    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 12, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.arrow_back_ios_new_rounded,
                        size: 20, color: fg),
                    splashRadius: 22,
                  ),
                  Expanded(
                    child: _showSearch
                        ? TextField(
                            controller: _searchController,
                            autofocus: true,
                            style: TextStyle(color: fg, fontSize: 16),
                            decoration: InputDecoration(
                              hintText: 'Shakisha indirimbo...',
                              hintStyle: TextStyle(
                                  color: isDark
                                      ? Colors.white38
                                      : Colors.grey.shade400),
                              border: InputBorder.none,
                            ),
                            onChanged: (v) => setState(() => _query = v),
                          )
                        : Text(
                            'Indirimbo',
                            style: GoogleFonts.cinzel(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: fg,
                            ),
                          ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _showSearch = !_showSearch;
                        if (!_showSearch) {
                          _query = '';
                          _searchController.clear();
                        }
                      });
                    },
                    icon: Icon(
                      _showSearch ? Icons.close : Icons.search_rounded,
                      color: fg,
                    ),
                    splashRadius: 22,
                  ),
                ],
              ),
            ),
          ),

          // ── Subtitle strip ───────────────────────────────────────────────
          if (!_showSearch)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 2, 20, 10),
              alignment: Alignment.centerLeft,
              child: Text(
                'TURIRIMBIRE IMANA • 414 indirimbo',
                style: GoogleFonts.lato(
                  fontSize: 11,
                  color: accent,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ),

          // ── Body ─────────────────────────────────────────────────────────
          Expanded(
            child: results != null
                ? _SearchResults(
                    results: results,
                    query: _query,
                    isDark: isDark,
                    fg: fg,
                    accent: accent,
                    maroon: maroon,
                  )
                : _CategoryList(isDark: isDark, fg: fg, accent: accent,
                    maroon: maroon),
          ),
        ],
      ),
    );
  }
}

// ── Category list ─────────────────────────────────────────────────────────

class _CategoryList extends StatelessWidget {
  const _CategoryList({
    required this.isDark,
    required this.fg,
    required this.accent,
    required this.maroon,
  });

  final bool isDark;
  final Color fg;
  final Color accent;
  final Color maroon;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: hymnCategories.length,
      itemBuilder: (context, i) {
        final cat = hymnCategories[i];
        return _CategoryTile(
          category: cat,
          isDark: isDark,
          fg: fg,
          accent: accent,
          maroon: maroon,
        );
      },
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.isDark,
    required this.fg,
    required this.accent,
    required this.maroon,
  });

  final HymnCategory category;
  final bool isDark;
  final Color fg;
  final Color accent;
  final Color maroon;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      color: isDark ? const Color(0xFF1C1C1C) : const Color(0xFFFAF7F2),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark
              ? Colors.white.withValues(alpha: 0.07)
              : Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: maroon.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.library_music_rounded,
              color: maroon, size: 20),
        ),
        title: Text(
          category.titleRw,
          style: GoogleFonts.lato(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: fg,
          ),
        ),
        subtitle: Text(
          '${category.hymns.length} indirimbo',
          style: GoogleFonts.lato(
            fontSize: 11,
            color: isDark ? Colors.white38 : Colors.grey.shade500,
          ),
        ),
        trailing: Icon(Icons.chevron_right_rounded,
            color: isDark ? Colors.white24 : Colors.black26),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => _HymnListPage(
              category: category,
              isDark: isDark,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Search results ────────────────────────────────────────────────────────

class _SearchResults extends StatelessWidget {
  const _SearchResults({
    required this.results,
    required this.query,
    required this.isDark,
    required this.fg,
    required this.accent,
    required this.maroon,
  });

  final List<Hymn> results;
  final String query;
  final bool isDark;
  final Color fg;
  final Color accent;
  final Color maroon;

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return Center(
        child: Text(
          'Nta ndirimbo yabonetse',
          style: GoogleFonts.lato(
              fontSize: 14,
              color: isDark ? Colors.white38 : Colors.grey.shade500),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: results.length,
      itemBuilder: (context, i) {
        final hymn = results[i];
        final cat = categoryForHymn(hymn.number);
        return _HymnTile(
          hymn: hymn,
          categoryTitle: cat?.titleRw ?? '',
          isDark: isDark,
          fg: fg,
          maroon: maroon,
        );
      },
    );
  }
}

// ── Hymn list page ────────────────────────────────────────────────────────

class _HymnListPage extends StatelessWidget {
  const _HymnListPage({required this.category, required this.isDark});

  final HymnCategory category;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF0F0F0F) : Colors.white;
    final fg = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final maroon = const Color(0xFF4A1028);

    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.arrow_back_ios_new_rounded,
                        size: 20, color: fg),
                    splashRadius: 22,
                  ),
                  Expanded(
                    child: Text(
                      category.titleRw,
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: fg,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: category.hymns.length,
              itemBuilder: (context, i) {
                final hymn = category.hymns[i];
                return _HymnTile(
                  hymn: hymn,
                  categoryTitle: '',
                  isDark: isDark,
                  fg: fg,
                  maroon: maroon,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Hymn tile ─────────────────────────────────────────────────────────────

class _HymnTile extends StatelessWidget {
  const _HymnTile({
    required this.hymn,
    required this.categoryTitle,
    required this.isDark,
    required this.fg,
    required this.maroon,
  });

  final Hymn hymn;
  final String categoryTitle;
  final bool isDark;
  final Color fg;
  final Color maroon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      leading: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: maroon.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '${hymn.number}',
          style: GoogleFonts.cinzel(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: maroon,
          ),
        ),
      ),
      title: Text(
        hymn.title,
        style: GoogleFonts.lato(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
      subtitle: categoryTitle.isNotEmpty
          ? Text(
              categoryTitle,
              style: GoogleFonts.lato(
                fontSize: 11,
                color: isDark ? Colors.white38 : Colors.grey.shade500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: Icon(Icons.chevron_right_rounded,
          color: isDark ? Colors.white24 : Colors.black26),
      onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => HymnDetailPage(hymn: hymn),
            ),
          ),
    );
  }
}

// ── Hymn detail page ──────────────────────────────────────────────────────

class HymnDetailPage extends StatefulWidget {
  const HymnDetailPage({super.key, required this.hymn});

  final Hymn hymn;

  @override
  State<HymnDetailPage> createState() => _HymnDetailPageState();
}

class _HymnDetailPageState extends State<HymnDetailPage> {
  double _fontSize = 17.0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0D0D0D) : const Color(0xFFFAF7F2);
    final fg = isDark ? const Color(0xFFF0EDE8) : const Color(0xFF1A1208);
    final maroon = const Color(0xFF4A1028);
    final accent = const Color(0xFFC9A84C);
    final cardBg = isDark ? const Color(0xFF1A1510) : Colors.white;

    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        slivers: [
          // ── App bar ──────────────────────────────────────────────────
          SliverAppBar(
            backgroundColor: bg,
            foregroundColor: fg,
            elevation: 0,
            pinned: true,
            expandedHeight: 120,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  size: 20, color: fg),
              splashRadius: 22,
            ),
            actions: [
              // Font size controls
              IconButton(
                icon: Icon(Icons.text_decrease_rounded,
                    color: fg.withValues(alpha: 0.7), size: 20),
                onPressed: () {
                  if (_fontSize > 13) setState(() => _fontSize -= 1);
                },
                tooltip: 'Mienye',
              ),
              IconButton(
                icon: Icon(Icons.text_increase_rounded,
                    color: fg.withValues(alpha: 0.7), size: 20),
                onPressed: () {
                  if (_fontSize < 26) setState(() => _fontSize += 1);
                },
                tooltip: 'Nongera',
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(56, 0, 100, 14),
              title: Text(
                widget.hymn.title,
                style: GoogleFonts.cinzel(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: fg,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // ── Number + source badges ────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Row(
                children: [
                  // Number badge
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: maroon,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${widget.hymn.number}',
                      style: GoogleFonts.cinzel(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.hymn.source != null)
                          Text(
                            widget.hymn.source!,
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: accent,
                            ),
                          ),
                        if (widget.hymn.tuneName != null)
                          Text(
                            widget.hymn.tuneName!,
                            style: GoogleFonts.lato(
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                              color: isDark
                                  ? Colors.white38
                                  : Colors.grey.shade500,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Divider ───────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Divider(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : maroon.withValues(alpha: 0.12),
              ),
            ),
          ),

          // ── No lyrics state ──────────────────────────────────────────
          if (widget.hymn.verses.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: maroon.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.music_note_rounded,
                            size: 36, color: maroon.withValues(alpha: 0.5)),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.hymn.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cinzel(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: fg,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Indirimbo N° ${widget.hymn.number}',
                        style: GoogleFonts.lato(
                          fontSize: 13,
                          color: accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Inyandiko y\'indirimbo ntirashyirwa muri verisiyo iri. Izashyirwa vuba.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          fontSize: 13,
                          color: isDark ? Colors.white38 : Colors.black38,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // ── Chorus box (shown first if present) ──────────────────────
          if (widget.hymn.chorus != null && widget.hymn.verses.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? accent.withValues(alpha: 0.07)
                        : accent.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: accent.withValues(alpha: 0.35), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: accent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'REFRAIN',
                              style: GoogleFonts.cinzel(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.hymn.chorus!,
                        style: GoogleFonts.lato(
                          fontSize: _fontSize,
                          height: 1.85,
                          color: fg,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // ── Verses ───────────────────────────────────────────────────
          if (widget.hymn.verses.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final verse = widget.hymn.verses[i];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : maroon.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Verse number
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: maroon.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${verse.number}',
                              style: GoogleFonts.cinzel(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: maroon,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              verse.text,
                              style: GoogleFonts.lato(
                                fontSize: _fontSize,
                                height: 1.9,
                                color: fg,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: widget.hymn.verses.length,
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 48)),
        ],
      ),
    );
  }
}
