import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lutheran/core/services/unsplash_service.dart';
import 'package:lutheran/core/data/calendar_data_2026.dart';
import 'package:lutheran/core/controllers/bible_controller.dart';
import 'package:lutheran/core/services/local_bible_service.dart';
import 'package:lutheran/core/services/streak_service.dart';
import 'package:lutheran/features/home/presentation/controllers/home_page_controller.dart';
import 'package:lutheran/features/hymns/presentation/pages/hymns_page.dart';
import 'package:lutheran/features/liturgy/presentation/pages/liturgy_page.dart';
import 'package:lutheran/features/liturgy/presentation/pages/special_ordination_page.dart';
import 'package:lutheran/features/prayer/presentation/pages/prayer_page.dart';
import 'package:lutheran/features/settings/presentation/providers/settings_provider.dart';
import 'package:share_plus/share_plus.dart';

// ─── Kinyarwanda day / month names ───────────────────────────────────────────
const _rwDays = [
  'Ku wa Mbere', 'Ku wa Kabiri', 'Ku wa Gatatu', 'Ku wa Kane',
  'Ku wa Gatanu', 'Ku wa Gatandatu', 'Ku Cyumweru',
];
const _rwMonths = [
  'Mutarama', 'Gashyantare', 'Werurwe', 'Mata',
  'Gicurasi', 'Kamena', 'Nyakanga', 'Kanama',
  'Nzeli', 'Ukwakira', 'Ugushyingo', 'Ukuboza',
];
const _enDays = [
  'Monday', 'Tuesday', 'Wednesday', 'Thursday',
  'Friday', 'Saturday', 'Sunday',
];
const _enMonths = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

bool _isOrdinationWeek() {
  final now = DateTime.now();
  return now.isAfter(DateTime(2026, 4, 20)) && now.isBefore(DateTime(2026, 4, 28));
}

String _greeting(bool isEn) {
  final h = DateTime.now().hour;
  if (isEn) {
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
  if (h < 12) return 'Mwaramutse';
  return 'Mwiriwe';
}

 // ─── HomeDashboard ────────────────────────────────────────────────────────────
class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});
  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _streak = 0;
  int _tab = 0; // 0 = Today, 1 = Community

  @override
  void initState() {
    super.initState();
    _initStreak();
  }

  Future<void> _initStreak() async {
    await StreakService.recordOpen();
    if (mounted) setState(() => _streak = StreakService.currentStreak);
  }

  @override
  Widget build(BuildContext context) {
    final sp = Get.find<SettingsProvider>();
    final today = DateTime.now();
    final reading = CalendarData2026.getReading(today);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF5F5F5);
    final appBarBg = isDark ? const Color(0xFF111111) : Colors.white;

    // Obx ensures the whole dashboard rebuilds when language is toggled
    return Obx(() {
    final isEn = sp.language.value == 'en';
    final dayName = isEn ? _enDays[today.weekday - 1] : _rwDays[today.weekday - 1];
    final monthName = isEn ? _enMonths[today.month - 1] : _rwMonths[today.month - 1];

    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        slivers: [
          // ── App bar with Today / Community tabs ────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: appBarBg,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            shadowColor: isDark ? Colors.white10 : Colors.black12,
            titleSpacing: 18,
            title: Row(
              children: [
                _TabLabel(
                  label: isEn ? 'Today' : 'Uyu Munsi',
                  selected: _tab == 0,
                  isDark: isDark,
                  onTap: () => setState(() => _tab = 0),
                ),
                const SizedBox(width: 20),
                _TabLabel(
                  label: isEn ? 'Community' : 'Umuryango',
                  selected: _tab == 1,
                  isDark: isDark,
                  onTap: () => setState(() => _tab = 1),
                ),
              ],
            ),
            actions: [
              if (_streak > 0) ...[
                _StreakBadge(streak: _streak, isDark: isDark),
                const SizedBox(width: 4),
              ],
              GestureDetector(
                onTap: () => sp.setLanguage(isEn ? 'rw' : 'en'),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white12 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: isDark ? Colors.white24 : Colors.grey.shade300),
                  ),
                  child: Text(
                    isEn ? 'RW' : 'EN',
                    style: GoogleFonts.lato(
                      fontSize: 11, fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: Icon(
                  Icons.notifications_none_rounded,
                  color: isDark ? Colors.white70 : Colors.black87,
                  size: 24,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isEn ? 'No new notifications' : 'Nta menyesha mishya',
                        style: GoogleFonts.lato(fontSize: 13),
                      ),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              const SizedBox(width: 4),
            ],
          ),

          SliverToBoxAdapter(
            child: _tab == 1
                ? _CommunityView(isDark: isDark, isEn: isEn)
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Greeting Hero ─────────────────────────────────────────────
                _GreetingHero(
                  isDark: isDark,
                  isEn: isEn,
                  dayName: dayName,
                  monthName: monthName,
                  today: today,
                ),

                const SizedBox(height: 20),

                // ── Special Event Banner (ordination week) ────────────────────
                if (_isOrdinationWeek()) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: _SpecialEventBanner(isDark: isDark, isEn: isEn),
                  ),
                  const SizedBox(height: 20),
                ],

                // ── Verse of the Day ─────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: reading != null
                      ? _DailyReadingCard(
                          reading: reading,
                          isDark: isDark,
                          isEn: isEn,
                        )
                      : _EmptyReadingCard(isDark: isDark, isEn: isEn),
                ),

                const SizedBox(height: 28),

                // ── Indirimbo ─────────────────────────────────────────────────
                _SectionHeader(
                  label: isEn ? 'Hymns' : 'Indirimbo',
                  isDark: isDark,
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: _IndirimboCard(isDark: isDark, isEn: isEn),
                ),

                const SizedBox(height: 28),

                // ── Guided Prayer ─────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: _GuidedPrayerCard(isDark: isDark, isEn: isEn),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }); // closes Obx
  }   // closes build()
}

// ─── Section Header ───────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String label;
  final bool isDark;

  const _SectionHeader({
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Container(
            width: 3, height: 18,
            decoration: BoxDecoration(
              color: isDark ? Colors.white : Colors.black,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.cinzel(
              fontSize: 15, fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : Colors.black,
              letterSpacing: 0.2,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

// ─── Streak Badge ─────────────────────────────────────────────────────────────
class _StreakBadge extends StatelessWidget {
  final int streak;
  final bool isDark;
  const _StreakBadge({required this.streak, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white24 : Colors.black.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department_rounded,
            size: 14,
            color: isDark ? Colors.white : Colors.black,
          ),
          const SizedBox(width: 4),
          Text(
            '$streak',
            style: GoogleFonts.lato(
              fontSize: 13, fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Daily Reading Card ───────────────────────────────────────────────────────
class _DailyReadingCard extends StatefulWidget {
  final DailyReading reading;
  final bool isDark;
  final bool isEn;
  const _DailyReadingCard({
    required this.reading,
    required this.isDark,
    required this.isEn,
  });

  @override
  State<_DailyReadingCard> createState() => _DailyReadingCardState();
}

class _DailyReadingCardState extends State<_DailyReadingCard> {
  String? _passageText;
  bool _loading = true;
  bool _expanded = false;

  static const _bookMap = <String, String>{
    'Itang': 'GEN', 'Gen': 'GEN', 'Kuva': 'EXO', 'Kuv': 'EXO', 'Lew': 'LEV',
    'Kub': 'NUM', 'Guteg': 'DEU', 'Amag': 'DEU', 'Yos': 'JOS', 'Amu': 'JDG',
    'Rut': 'RUT', '1Sam': '1SA', '2Sam': '2SA', '1Abam': '1KI', '2Abam': '2KI',
    '1Ngo': '1CH', '2Ngoma': '2CH', '2Ngo': '2CH', 'Ezra': 'EZR', 'Neh': 'NEH',
    'Est': 'EST', 'Yob': 'JOB', 'Yobu': 'JOB', 'Zab': 'PSA', 'Imig': 'PRO',
    'Umubw': 'ECC', 'umubw': 'ECC', 'Yes': 'ISA', 'Yer': 'JER', 'Lar': 'LAM',
    'Ezek': 'EZK', 'Dan': 'DAN', 'Hos': 'HOS', 'Yow': 'JOL', 'Amos': 'AMO',
    'Obad': 'OBA', 'Yon': 'JON', 'Mik': 'MIC', 'Mika': 'MIC', 'Nah': 'NAM',
    'Habak': 'HAB', 'Zef': 'ZEP', 'Hag': 'HAG', 'Zak': 'ZEC', 'Zek': 'ZEC',
    'Mal': 'MAL', 'Mat': 'MAT', 'Mar': 'MRK', 'Luk': 'LUK', 'Lk': 'LUK',
    'Yoh': 'JHN', 'Ibyak': 'ACT', 'Rom': 'ROM', 'Abar': 'ROM',
    '1Kor': '1CO', '2Kor': '2CO', 'Gal': 'GAL',
    'Efe': 'EPH', 'Efes': 'EPH', 'Eph': 'EPH', 'Fil': 'PHP', 'Filp': 'PHP',
    'Kol': 'COL', '1Tes': '1TH', '2Tes': '2TH', '1Tim': '1TI', '2Tim': '2TI',
    'Tit': 'TIT', 'Tito': 'TIT', 'Heb': 'HEB', 'Hebr': 'HEB', 'Yak': 'JAS',
    '1Pet': '1PE', 'Pet': '1PE', '2Pet': '2PE', '1Yo': '1JN', '1Yoh': '1JN',
    '2Yoh': '2JN', '3Yoh': '3JN', 'Yuda': 'JUD', 'Ibyah': 'REV',
  };

  @override
  void initState() {
    super.initState();
    _loadCurrentReading();
  }

  String? get _currentRef {
    final isSunday =
        widget.reading.psalm != null || widget.reading.gospel != null;
    if (isSunday) {
      final hour = DateTime.now().hour;
      if (hour < 12) return widget.reading.psalm ?? widget.reading.gospel;
      return widget.reading.gospel ?? widget.reading.epistle;
    }
    final hour = DateTime.now().hour;
    if (hour < 12) return widget.reading.morningReading;
    return widget.reading.eveningReading ?? widget.reading.morningReading;
  }

  bool get _isMorning => DateTime.now().hour < 12;

  String? _parseToUsfm(String ref) {
    final match = RegExp(r'^([A-Za-z0-9]+)\.(\d+)').firstMatch(ref.trim());
    if (match == null) return null;
    final usfm = _bookMap[match.group(1)!];
    if (usfm == null) return null;
    return '$usfm.${match.group(2)!}';
  }

  (int?, int?) _parseVerseRange(String ref) {
    final match = RegExp(r':(\d+)(?:-(\d+))?').firstMatch(ref);
    if (match == null) return (null, null);
    final start = int.tryParse(match.group(1)!);
    final end =
        match.group(2) != null ? int.tryParse(match.group(2)!) : null;
    return (start, end);
  }

  void _loadCurrentReading() {
    final ref = _currentRef;
    if (ref == null) {
      setState(() => _loading = false);
      return;
    }
    final passageId = _parseToUsfm(ref);
    if (passageId == null) {
      setState(() => _loading = false);
      return;
    }
    final parts = passageId.split('.');
    final bookId = parts.isNotEmpty ? parts[0] : '';
    final chNum = parts.length > 1 ? (int.tryParse(parts[1]) ?? 1) : 1;
    final localCh = LocalBibleService.chapter(bookId, chNum);
    if (localCh != null && localCh.verses.isNotEmpty) {
      final (startV, endV) = _parseVerseRange(ref);
      final buffer = StringBuffer();
      for (final v in localCh.verses) {
        if (startV != null && v.number < startV) continue;
        if (endV != null && v.number > endV) continue;
        buffer.write('${v.number}  ${v.text}\n\n');
      }
      _passageText = buffer.toString().trimRight();
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final isEn = widget.isEn;

    BibleController? ctrl;
    try {
      ctrl = Get.find<BibleController>();
    } catch (_) {}

    final timeLabel = _isMorning
        ? (isEn ? 'MORNING' : 'MU GITONDO')
        : (isEn ? 'EVENING' : 'MU MUGOROBA');

    return Column(
      children: [
        // ── VOTD ─────────────────────────────────────────────────────────
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 190),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Stack(
              children: [
                // Background image — daily Unsplash photo
                Positioned.fill(
                  child: _UnsplashBg(slot: 'votd', fallback: 'assets/images/card_bg.png'),
                ),
                // Gradient overlay — darkest top & bottom, slightly lighter middle
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.80),
                          Colors.black.withValues(alpha: 0.50),
                          Colors.black.withValues(alpha: 0.85),
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                ),
                // Decorative oversized open-quote in background
                Positioned(
                  top: -8, left: 14,
                  child: Text(
                    '\u201C',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 110,
                      height: 1,
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Label row
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.20)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.auto_stories_outlined,
                                    size: 10, color: Colors.white.withValues(alpha: 0.7)),
                                const SizedBox(width: 5),
                                Text(
                                  isEn ? 'VERSE OF THE DAY' : 'IJAMBO RY\'UYU MUNSI',
                                  style: GoogleFonts.lato(
                                    fontSize: 9, fontWeight: FontWeight.w900,
                                    color: Colors.white70, letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Verse text
                      if (ctrl != null)
                        Obx(() {
                          final votd = ctrl!.verseOfDay.value;
                          if (votd != null) {
                            // Strip any existing leading/trailing quotes from source text
                            final verseText = votd.content
                                .replaceAll(RegExp(r'^[\u201C\u201D\u2018\u2019"]+'), '')
                                .replaceAll(RegExp(r'[\u201C\u201D\u2018\u2019"]+$'), '')
                                .trim();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '\u201C$verseText\u201D',
                                  style: GoogleFonts.notoSerif(
                                    fontSize: 16, height: 1.8,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white.withValues(alpha: 0.95),
                                  ),
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    // Reference with a thin white left accent bar
                                    Container(
                                      width: 3, height: 16,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.45),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        votd.reference,
                                        style: GoogleFonts.cinzel(
                                          fontSize: 11, fontWeight: FontWeight.w700,
                                          color: Colors.white60,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => Share.share(
                                        '\u201C$verseText\u201D\n\n\u2014 ${votd.reference}\n\nLCR App',
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 7),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                              color: Colors.white.withValues(alpha: 0.2)),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.share_outlined,
                                                size: 12, color: Colors.white70),
                                            const SizedBox(width: 5),
                                            Text(
                                              isEn ? 'Share' : 'Sangira',
                                              style: GoogleFonts.lato(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            // Skeleton shimmer placeholders
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity, height: 14,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: double.infinity, height: 14,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.06),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: 160, height: 14,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.04),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                              ],
                            );
                          }
                        }),
                    ],
                  ),
                ),
              ],        // close Stack children
            ),          // close Stack
          ),            // close ClipRRect
        ),              // close outer Container

        // ── Today's Reading ───────────────────────────────────────────────
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1C1C) : Colors.white,
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(20)),
            border: Border(
              left: BorderSide(
                  color: isDark ? Colors.white12 : Colors.grey.shade200),
              right: BorderSide(
                  color: isDark ? Colors.white12 : Colors.grey.shade200),
              bottom: BorderSide(
                  color: isDark ? Colors.white12 : Colors.grey.shade200),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _passageText != null
                      ? () => setState(() => _expanded = !_expanded)
                      : null,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      Container(
                        width: 38, height: 38,
                        decoration: BoxDecoration(
                          color: _isMorning
                              ? const Color(0xFFF59E0B).withValues(alpha: isDark ? 0.18 : 0.12)
                              : const Color(0xFF6366F1).withValues(alpha: isDark ? 0.18 : 0.12),
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(
                            color: _isMorning
                                ? const Color(0xFFF59E0B).withValues(alpha: 0.35)
                                : const Color(0xFF6366F1).withValues(alpha: 0.35),
                          ),
                        ),
                        child: Icon(
                          _isMorning
                              ? Icons.wb_sunny_rounded
                              : Icons.nightlight_round,
                          color: _isMorning
                              ? const Color(0xFFF59E0B)
                              : const Color(0xFF818CF8),
                          size: 17,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              timeLabel,
                              style: GoogleFonts.lato(
                                fontSize: 9, fontWeight: FontWeight.w800,
                                color:
                                    isDark ? Colors.white38 : Colors.grey.shade500,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _currentRef ?? widget.reading.dayName,
                              style: GoogleFonts.lato(
                                fontSize: 13, fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.reading.theme != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.06)
                                : Colors.black.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.reading.theme!,
                            style: GoogleFonts.lato(
                              fontSize: 10, fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white54 : Colors.black54,
                            ),
                          ),
                        ),
                      const SizedBox(width: 6),
                      if (_passageText != null)
                        AnimatedRotation(
                          turns: _expanded ? 0.5 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 22,
                            color: isDark ? Colors.white38 : Colors.grey.shade400,
                          ),
                        ),
                    ],
                  ),
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: _loading
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: SizedBox(
                              width: 20, height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        )
                      : _passageText != null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? Colors.white.withValues(alpha: 0.03)
                                          : Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isDark
                                            ? Colors.white12
                                            : Colors.grey.shade200,
                                      ),
                                    ),
                                    child: Text(
                                      _passageText!,
                                      style: GoogleFonts.notoSerif(
                                        fontSize: 13, height: 1.75,
                                        color: isDark
                                            ? Colors.white.withValues(alpha: 0.85)
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () {
                                      try {
                                        Get.find<HomePageController>()
                                            .selectTab(1);
                                      } catch (_) {}
                                    },
                                    child: Text(
                                      isEn
                                          ? 'Read full chapter →'
                                          : 'Soma igice cyose →',
                                      style: GoogleFonts.lato(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: isDark
                                            ? Colors.white60
                                            : Colors.black54,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                  crossFadeState: _expanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 250),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyReadingCard extends StatelessWidget {
  final bool isDark;
  final bool isEn;
  const _EmptyReadingCard({required this.isDark, required this.isEn});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1C) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.menu_book_outlined,
              color: isDark ? Colors.white38 : Colors.grey.shade400),
          const SizedBox(width: 12),
          Text(
            isEn ? 'No readings for today' : 'Nta makuru abonetse',
            style: TextStyle(
                color: isDark ? Colors.white38 : Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

// ─── Quick Action Chip ────────────────────────────────────────────────────────
class _QuickChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final Color accent;
  final VoidCallback onTap;

  const _QuickChip({
    required this.icon,
    required this.label,
    required this.isDark,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 80,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1C1C) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: accent.withValues(alpha: isDark ? 0.25 : 0.18),
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: isDark ? 0.08 : 0.10),
                blurRadius: 10, offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: isDark ? 0.15 : 0.10),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: accent, size: 21),
              ),
              const SizedBox(height: 7),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontSize: 10, fontWeight: FontWeight.w700, height: 1.2,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Guided Prayer Card ───────────────────────────────────────────────────────
class _GuidedPrayerCard extends StatelessWidget {
  final bool isDark;
  final bool isEn;
  const _GuidedPrayerCard({required this.isDark, required this.isEn});

  static const _prayers = [
    (
      'Umuryango / Family',
      'Data w\'ijuru, ndakuramutse ngushimira impano y\'umuryango wanjye. '
      'Ubarinde, ubashoboze gukundana no gutumanahana mu mahoro. '
      'Ubafashe gukomezanya no kunakirana mu ngorane, kandi ubone kubabana nk\'umuryango wawe w\'ukuri.',
      'Heavenly Father, I thank you for the gift of my family. Guard them and enable them to love one another and communicate in peace. Help them to support each other through hardship, and may they truly live as your family.',
    ),
    (
      'Itorero / Church',
      'Mana, komeza itorero ryawe no guhuza abayobozi baryobora mu ubwenge n\'urukundo. '
      'Iryo torero niribe urumuri mu mujyi wacu no mu Rwanda yose, '
      'kandi urifashe gutanga inkuru nziza kuri buri wese ukeneye kumva ijambo ryawe.',
      'God, strengthen your Church and unite its leaders in wisdom and love. May the Church be a light in our city and throughout Rwanda, and help it to bring the good news to all who need to hear your word.',
    ),
    (
      'Ubuzima / Health',
      'Uwiteka Muganga, ngirira neza mubiri wanjye, umutima wanjye, n\'umwuka wanjye. '
      'Bakira abarwayi bose, uhe inkunga abantu bashungutse no gutura mu makuba, '
      'kandi utuyobore mu nzira y\'ubuzima buzira neza, umubiri n\'umwuka.',
      'Lord and Healer, have mercy on my body, mind and spirit. Heal all who are sick, comfort those suffering and in trouble, and lead us on the path of wholeness in body and spirit.',
    ),
    (
      'Amahoro / Peace',
      'Mana y\'amahoro, duhe amahoro mu miryango yacu, mu bihugu byacu, no ku isi yose. '
      'Ubane n\'abashoboye gutumanahana no gusezerana amahoro, '
      'kandi ufashe isi gukira inzangano, urwango, n\'intambara zose.',
      'God of peace, grant peace in our families, our nations, and across the earth. Be with all who work for dialogue and lasting peace, and help the world to be healed of all hatred, division and war.',
    ),
    (
      'Akazi n\'Inyigisho / Work & Studies',
      'Imana, nyobora akazi n\'inyigisho byanjye. '
      'Mpe ubwenge bwo gukora neza no kwihangana igihe bingoye. '
      'Ngerekane gushimira igihe ibintu bigenda neza, kandi ibyo nkora byose nibikorwe mu izina ryawe kandi bibone kukugira icyubahiro.',
      'God, guide my work and studies. Give me wisdom to perform well and patience when things are difficult. Teach me gratitude when things go well, and may everything I do be done in your name and bring you honour.',
    ),
    (
      'Isengesho ryo mu Gitondo / Morning Prayer',
      'Mana, nasubiye imbere yawe uyu munsi mushya watanze. '
      'Ngorora inzira zanjye kandi ubane nanjye mu bikorwa byose bya none. '
      'Unkingire ingorane no gushukwa, inema yawe igume iri nanjye, '
      'kandi ibikorwa byanjye byose nibikorwe ku bwawe.',
      'God, I come before you in this new day you have given. Order my steps and be with me in everything I do today. Protect me from trouble and temptation, may your grace remain with me, and may all my work be done for you.',
    ),
    (
      'Isengesho ryo mu Mugoroba / Evening Prayer',
      'Uwiteka, urakoze iby\'uyu munsi wose. '
      'Ndagushimira ubuzima, amahoro, n\'urukundo rw\'abantu bankunze. '
      'Nsubire mu butumire nzindukire amaguru meza, '
      'uze unzindukire n\'ijoro ry\'amahoro no kuzirikana ijambo ryawe.',
      'Lord, thank you for all of this day. I am grateful for life, peace, and the love of those around me. May I rest well tonight, and watch over me through a night of peace and reflection on your word.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final idx = DateTime.now().day % _prayers.length;
    final prayer = _prayers[idx];
    final title = prayer.$1;
    final text = isEn ? prayer.$3 : prayer.$2;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          // Unsplash background — candle/prayer theme
          Positioned.fill(
            child: _UnsplashBg(
              slot: 'prayer',
              fallback: 'assets/images/card_bg.png',
            ),
          ),
          // Dark gradient overlay — heavier at bottom for text readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.72),
                    Colors.black.withValues(alpha: 0.82),
                  ],
                ),
              ),
            ),
          ),
          // Tap ripple layer
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PrayerPage()),
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          // Content — all white text over dark background
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.20),
                        ),
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEn ? 'Guided Prayer' : 'Isengesho ry\'Uyu Munsi',
                            style: GoogleFonts.lato(
                              fontSize: 13, fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            title,
                            style: GoogleFonts.lato(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.55),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: Colors.white38,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Text(
                    text,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.notoSerif(
                      fontSize: 14, height: 1.7, fontStyle: FontStyle.italic,
                      color: Colors.white.withValues(alpha: 0.90),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  isEn ? 'Tap to pray →' : 'Kanda usenga →',
                  style: GoogleFonts.lato(
                    fontSize: 11, fontWeight: FontWeight.w700,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// ─── Tab Label ────────────────────────────────────────────────────────────────
class _TabLabel extends StatelessWidget {
  final String label;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;
  const _TabLabel({required this.label, required this.selected,
    required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: GoogleFonts.cinzel(
            fontSize: 15,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
            color: selected
                ? (isDark ? Colors.white : Colors.black)
                : (isDark ? Colors.white38 : Colors.grey.shade400),
          )),
          const SizedBox(height: 3),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2, width: selected ? 24.0 : 0.0,
            decoration: BoxDecoration(
              color: isDark ? Colors.white : Colors.black,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Community View ───────────────────────────────────────────────────────────
class _CommunityView extends StatefulWidget {
  final bool isDark;
  final bool isEn;
  const _CommunityView({required this.isDark, required this.isEn});

  @override
  State<_CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<_CommunityView> {
  final _prayerCtrl = TextEditingController();
  final List<Map<String, String>> _requests = [
    {'name': 'Amina K.', 'text': "Nsaba gusenga umuryango wanjye w'indwara.", 'en': "Please pray for my family's healing.", 'time': '8:00'},
    {'name': 'Jean P.', 'text': 'Nsaba gusenga akazi nshaka.', 'en': "Pray for the job opportunity I'm seeking.", 'time': '7:30'},
    {'name': 'Grace M.', 'text': "Nsaba amasengesho y'amashuri yanjye.", 'en': 'Prayers for my upcoming exams.', 'time': '6:45'},
  ];

  static const _plans = [
    ('Kwiga Umurangireze', 'Read the Gospels', 28, Icons.menu_book_outlined),
    ('Zaburi 30 Iminsi', 'Psalms — 30 Days', 30, Icons.self_improvement_outlined),
    ('Gukurikira Yesu', 'Discipleship & Faith', 21, Icons.directions_walk_outlined),
    ('Gusenga Buri Munsi', 'Daily Prayer Guide', 14, Icons.volunteer_activism_outlined),
  ];

  @override
  void dispose() {
    _prayerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final isEn = widget.isEn;
    final cardBg = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final div = isDark ? Colors.white10 : Colors.grey.shade200;

    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Study Plans ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 24, 18, 12),
            child: Text(isEn ? 'STUDY PLANS' : 'GAHUNDA YO KWIGA',
              style: GoogleFonts.lato(fontSize: 10, fontWeight: FontWeight.w800,
                letterSpacing: 1.4, color: isDark ? Colors.white38 : Colors.grey.shade500)),
          ),
          SizedBox(
            height: 118,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              itemCount: _plans.length,
              itemBuilder: (context, i) {
                final (rw, en, days, icon) = _plans[i];
                final filled = i.isEven;
                final bg = filled ? (isDark ? Colors.white : Colors.black) : cardBg;
                final fg = filled ? (isDark ? Colors.black : Colors.white)
                    : (isDark ? Colors.white : Colors.black);
                return Container(
                  width: 145,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: bg, borderRadius: BorderRadius.circular(16),
                    border: filled ? null : Border.all(color: div),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(icon, size: 20, color: fg.withValues(alpha: 0.75)),
                      const Spacer(),
                      Text(isEn ? en : rw, style: GoogleFonts.lato(
                        fontSize: 12, fontWeight: FontWeight.w700, color: fg, height: 1.3),
                        maxLines: 2),
                      const SizedBox(height: 3),
                      Text('$days ${isEn ? "days" : "iminsi"}', style: GoogleFonts.lato(
                        fontSize: 10, color: fg.withValues(alpha: 0.5))),
                    ],
                  ),
                );
              },
            ),
          ),

          // ── Prayer Requests ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 28, 18, 12),
            child: Row(
              children: [
                Text(isEn ? 'PRAYER REQUESTS' : 'AMASENGESHO',
                  style: GoogleFonts.lato(fontSize: 10, fontWeight: FontWeight.w800,
                    letterSpacing: 1.4, color: isDark ? Colors.white38 : Colors.grey.shade500)),
                const Spacer(),
                GestureDetector(
                  onTap: () => _showAddPrayer(context, isDark, isEn),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white : Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(children: [
                      Icon(Icons.add, size: 12, color: isDark ? Colors.black : Colors.white),
                      const SizedBox(width: 4),
                      Text(isEn ? 'Add' : 'Ongeraho', style: GoogleFonts.lato(
                        fontSize: 11, fontWeight: FontWeight.w700,
                        color: isDark ? Colors.black : Colors.white)),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              decoration: BoxDecoration(
                color: cardBg, borderRadius: BorderRadius.circular(16),
                border: Border.all(color: div),
              ),
              child: Column(
                children: [
                  for (int i = 0; i < _requests.length; i++) ...[
                    if (i > 0) Divider(height: 1, color: div, indent: 56),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(shape: BoxShape.circle,
                              color: isDark ? Colors.white12 : Colors.grey.shade100),
                            child: Center(child: Text(_requests[i]['name']![0],
                              style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : Colors.black))),
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Text(_requests[i]['name']!, style: GoogleFonts.lato(
                                  fontSize: 12, fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : Colors.black)),
                                const Spacer(),
                                Text(_requests[i]['time']!, style: GoogleFonts.lato(
                                  fontSize: 10, color: isDark ? Colors.white38 : Colors.grey.shade400)),
                              ]),
                              const SizedBox(height: 4),
                              Text(isEn ? _requests[i]['en']! : _requests[i]['text']!,
                                style: GoogleFonts.lato(fontSize: 12.5, height: 1.5,
                                  color: isDark ? Colors.white70 : Colors.grey.shade700)),
                              const SizedBox(height: 6),
                              Row(children: [
                                Icon(Icons.volunteer_activism_outlined, size: 13,
                                  color: isDark ? Colors.white38 : Colors.grey.shade400),
                                const SizedBox(width: 4),
                                Text(isEn ? 'Pray' : 'Senga', style: GoogleFonts.lato(
                                  fontSize: 11, fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white38 : Colors.grey.shade400)),
                              ]),
                            ],
                          )),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // ── Notes ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 28, 18, 12),
            child: Text(isEn ? 'MY NOTES' : 'INYANDIKO ZANJYE',
              style: GoogleFonts.lato(fontSize: 10, fontWeight: FontWeight.w800,
                letterSpacing: 1.4, color: isDark ? Colors.white38 : Colors.grey.shade500)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: GestureDetector(
              onTap: () => _showAddNote(context, isDark, isEn),
              child: Container(
                width: double.infinity, padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: div)),
                child: Row(children: [
                  Icon(Icons.edit_note_rounded, size: 20,
                    color: isDark ? Colors.white38 : Colors.grey.shade400),
                  const SizedBox(width: 10),
                  Text(isEn ? 'Write a note or reflection...' : 'Andika icyo wiyumvira...',
                    style: GoogleFonts.lato(fontSize: 13,
                      color: isDark ? Colors.white38 : Colors.grey.shade400)),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddPrayer(BuildContext context, bool isDark, bool isEn) {
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF141414) : Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isEn ? 'Prayer Request' : 'Icyo Usaba Gusenga',
              style: GoogleFonts.cinzel(fontSize: 16, fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : Colors.black)),
            const SizedBox(height: 14),
            TextField(controller: _prayerCtrl, maxLines: 3,
              decoration: InputDecoration(
                hintText: isEn ? 'Share your prayer request...' : 'Sangira icyo ushaka gusenga...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
            const SizedBox(height: 14),
            SizedBox(width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_prayerCtrl.text.trim().isNotEmpty) {
                    final now = TimeOfDay.now();
                    setState(() {
                      _requests.insert(0, {
                        'name': FirebaseAuth.instance.currentUser?.displayName?.split(' ').first ?? 'Me',
                        'text': _prayerCtrl.text.trim(),
                        'en': _prayerCtrl.text.trim(),
                        'time': '${now.hour}:${now.minute.toString().padLeft(2, '0')}',
                      });
                    });
                    _prayerCtrl.clear();
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.white : Colors.black,
                  foregroundColor: isDark ? Colors.black : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: Text(isEn ? 'Share Request' : 'Sangira',
                  style: GoogleFonts.lato(fontWeight: FontWeight.w700)),
              )),
          ]),
      ),
    );
  }

  void _showAddNote(BuildContext context, bool isDark, bool isEn) {
    final noteCtrl = TextEditingController();
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF141414) : Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isEn ? 'New Note' : 'Inyandiko Nshya',
              style: GoogleFonts.cinzel(fontSize: 16, fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : Colors.black)),
            const SizedBox(height: 14),
            TextField(controller: noteCtrl, maxLines: 5,
              decoration: InputDecoration(
                hintText: isEn ? 'Write your reflection or sermon notes...' : 'Andika icyo wiyumvira...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
            const SizedBox(height: 14),
            SizedBox(width: double.infinity,
              child: ElevatedButton(
                onPressed: () { noteCtrl.dispose(); Navigator.pop(context); },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.white : Colors.black,
                  foregroundColor: isDark ? Colors.black : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: Text(isEn ? 'Save Note' : 'Bika',
                  style: GoogleFonts.lato(fontWeight: FontWeight.w700)),
              )),
          ]),
      ),
    );
  }
}

// ─── Greeting Hero ────────────────────────────────────────────────────────────
/// Full-width hero banner with Unsplash background, greeting, date,
/// and a short rotating daily scripture for inspiration.
class _GreetingHero extends StatefulWidget {
  final bool isDark;
  final bool isEn;
  final String dayName;
  final String monthName;
  final DateTime today;

  const _GreetingHero({
    required this.isDark,
    required this.isEn,
    required this.dayName,
    required this.monthName,
    required this.today,
  });

  @override
  State<_GreetingHero> createState() => _GreetingHeroState();
}

class _GreetingHeroState extends State<_GreetingHero> {
  String _displayed = '';
  bool _cursorVisible = true;

  late final String _fullText;
  int _charIdx = 0;
  bool _isDeleting = false;

  Timer? _typeTimer;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    final userName = FirebaseAuth.instance.currentUser?.displayName;
    final name = (userName != null && userName.trim().isNotEmpty)
        ? userName.trim().split(' ').first
        : null;
    _fullText = name != null
        ? '${_greeting(widget.isEn)}, $name!'
        : '${_greeting(widget.isEn)}!';

    // Blinking cursor — always on
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted) setState(() => _cursorVisible = !_cursorVisible);
    });

    // Small delay before first type starts
    Future.delayed(const Duration(milliseconds: 400), _tick);
  }

  void _tick() {
    if (!mounted) return;

    if (!_isDeleting) {
      // Typing forward
      if (_charIdx < _fullText.length) {
        setState(() => _displayed = _fullText.substring(0, ++_charIdx));
        _typeTimer = Timer(const Duration(milliseconds: 70), _tick);
      } else {
        // Finished typing — pause then start deleting
        _typeTimer = Timer(const Duration(milliseconds: 1800), () {
          _isDeleting = true;
          _tick();
        });
      }
    } else {
      // Deleting backward
      if (_charIdx > 0) {
        setState(() => _displayed = _fullText.substring(0, --_charIdx));
        _typeTimer = Timer(const Duration(milliseconds: 40), _tick);
      } else {
        // Fully deleted — pause then start typing again
        _typeTimer = Timer(const Duration(milliseconds: 600), () {
          _isDeleting = false;
          _tick();
        });
      }
    }
  }

  @override
  void dispose() {
    _typeTimer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 220,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Unsplash background
          _UnsplashBg(slot: 'hero', fallback: 'assets/images/hero_bg.png'),

          // Gradient — lighter at top, heavier at bottom
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.45, 1.0],
                colors: [
                  Colors.black.withValues(alpha: 0.15),
                  Colors.black.withValues(alpha: 0.50),
                  Colors.black.withValues(alpha: 0.82),
                ],
              ),
            ),
          ),

          // Content pinned to bottom
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Date pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                    ),
                    child: Text(
                      '${widget.dayName} · ${widget.monthName} ${widget.today.day}, ${widget.today.year}'.toUpperCase(),
                      style: GoogleFonts.lato(
                        fontSize: 9, fontWeight: FontWeight.w700,
                        color: Colors.white.withValues(alpha: 0.85),
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Greeting with typewriter effect + blinking cursor
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.cinzel(
                        fontSize: 26, fontWeight: FontWeight.w800,
                        color: Colors.white, letterSpacing: 0.2, height: 1.15,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 10, offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      children: [
                        TextSpan(text: _displayed),
                        if (_cursorVisible)
                          TextSpan(
                            text: '|',
                            style: GoogleFonts.cinzel(
                              fontSize: 26, fontWeight: FontWeight.w300,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Indirimbo Card ──────────────────────────────────────────────────────────
class _IndirimboCard extends StatelessWidget {
  final bool isDark;
  final bool isEn;
  const _IndirimboCard({required this.isDark, required this.isEn});

  @override
  Widget build(BuildContext context) {
    final card   = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final border = isDark ? Colors.white12 : Colors.grey.shade200;
    final primary = isDark ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HymnsPage()),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
              blurRadius: 16, offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: primary.withValues(alpha: 0.10)),
              ),
              child: Icon(Icons.music_note_rounded, size: 22, color: primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEn ? 'Hymns' : 'Indirimbo',
                    style: GoogleFonts.lato(
                      fontSize: 14, fontWeight: FontWeight.w800,
                      color: primary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    isEn ? 'Browse church hymns & songs' : 'Indirimbo z\'itorero',
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      color: isDark ? Colors.white38 : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 14,
                color: isDark ? Colors.white24 : Colors.black26),
          ],
        ),
      ),
    );
  }
}

// ─── Liturgy Card ────────────────────────────────────────────────────────────
/// Shows today's liturgical readings on the home dashboard.
/// Tapping opens the full LiturgyPage.
class _LiturgyCard extends StatelessWidget {
  final DailyReading? reading;
  final bool isDark;
  final bool isEn;
  const _LiturgyCard({required this.reading, required this.isDark, required this.isEn});

  static const _colorMap = {
    'white':  Color(0xFFF5F0E8),
    'green':  Color(0xFF4CAF50),
    'red':    Color(0xFFD32F2F),
    'purple': Color(0xFF7B1FA2),
    'blue':   Color(0xFF1565C0),
    'black':  Color(0xFF424242),
    'gold':   Color(0xFFFFB300),
  };

  static const _seasonLabels = {
    'white':  ('Umunsi Mukuru',       'Feast Day'),
    'green':  ('Iminsi isanzwe',      'Ordinary Time'),
    'red':    ('Ubutatu Bwera',        'Pentecost / Martyrs'),
    'purple': ('Igisibo / Uko',        'Lent / Advent'),
    'blue':   ('Gutegereza',          'Advent'),
    'black':  ('Ijumaa Ryiza',        'Good Friday'),
    'gold':   ('Abera bose',          'All Saints'),
  };

  @override
  Widget build(BuildContext context) {
    final card   = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final border = isDark ? Colors.white12 : Colors.grey.shade200;

    final colorKey = reading?.liturgicalColor?.toLowerCase();
    final litColor = colorKey != null ? _colorMap[colorKey] : null;
    final seasonLabel = colorKey != null ? _seasonLabels[colorKey] : null;
    final seasonName  = isEn ? (seasonLabel?.$2 ?? '') : (seasonLabel?.$1 ?? '');

    final hasReadings = reading != null && (
      reading!.psalm != null || reading!.epistle != null ||
      reading!.gospel != null || reading!.morningReading != null);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LiturgyPage()),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: litColor?.withValues(alpha: 0.30) ?? border),
          boxShadow: [
            BoxShadow(
              color: (litColor ?? Colors.black).withValues(alpha: isDark ? 0.12 : 0.06),
              blurRadius: 16, offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Colored season band
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: (litColor ?? (isDark ? Colors.white12 : Colors.grey.shade100))
                    .withValues(alpha: 0.15),
                child: Row(
                  children: [
                    if (litColor != null) ...[
                      Container(
                        width: 10, height: 10,
                        decoration: BoxDecoration(
                          color: litColor, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Icon(Icons.church_rounded,
                        size: 14,
                        color: litColor ?? (isDark ? Colors.white54 : Colors.black38)),
                    const SizedBox(width: 6),
                    Text(
                      seasonName.isNotEmpty
                          ? seasonName
                          : (isEn ? 'Today\'s Liturgy' : 'Liturgiya y\'Uyu Munsi'),
                      style: GoogleFonts.lato(
                        fontSize: 11, fontWeight: FontWeight.w800,
                        color: litColor ?? (isDark ? Colors.white54 : Colors.black54),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.arrow_forward_ios_rounded,
                        size: 12,
                        color: isDark ? Colors.white24 : Colors.black26),
                  ],
                ),
              ),
            ),

            // Readings list
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: hasReadings
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (reading!.theme != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              reading!.theme!,
                              style: GoogleFonts.notoSerif(
                                fontSize: 13, fontStyle: FontStyle.italic,
                                height: 1.4,
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.80)
                                    : Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        _ReadingRow(
                          icon: Icons.music_note_rounded,
                          label: isEn ? 'Psalm' : 'Zaburi',
                          value: reading!.psalm,
                          isDark: isDark,
                          litColor: litColor,
                        ),
                        _ReadingRow(
                          icon: Icons.mail_outline_rounded,
                          label: isEn ? 'Epistle' : 'Abapostoro',
                          value: reading!.epistle,
                          isDark: isDark,
                          litColor: litColor,
                        ),
                        _ReadingRow(
                          icon: Icons.menu_book_rounded,
                          label: isEn ? 'Gospel' : 'Ubutumwa',
                          value: reading!.gospel,
                          isDark: isDark,
                          litColor: litColor,
                        ),
                      ],
                    )
                  : Text(
                      isEn ? 'Tap to view today\'s service' : 'Kanda urebe serivisi ya none',
                      style: GoogleFonts.lato(
                        fontSize: 13, fontStyle: FontStyle.italic,
                        color: isDark ? Colors.white38 : Colors.grey.shade500,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final bool isDark;
  final Color? litColor;
  const _ReadingRow({
    required this.icon, required this.label,
    required this.value, required this.isDark, required this.litColor,
  });

  @override
  Widget build(BuildContext context) {
    if (value == null) return const SizedBox.shrink();
    final subtle = isDark ? Colors.white38 : Colors.grey.shade500;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 14,
              color: litColor?.withValues(alpha: 0.8) ?? subtle),
          const SizedBox(width: 8),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.lato(
              fontSize: 9, fontWeight: FontWeight.w800,
              color: subtle, letterSpacing: 0.6,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value!,
              style: GoogleFonts.lato(
                fontSize: 13, fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Unsplash daily background widget ────────────────────────────────────────
/// Fetches a daily Unsplash photo for [slot] and displays it full-size.
/// Falls back to the local [fallback] asset while loading or on error.
class _UnsplashBg extends StatefulWidget {
  final String slot;
  final String fallback;
  const _UnsplashBg({required this.slot, required this.fallback});

  @override
  State<_UnsplashBg> createState() => _UnsplashBgState();
}

class _UnsplashBgState extends State<_UnsplashBg> {
  String? _url;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final url = await UnsplashService.getDailyUrl(widget.slot);
    if (mounted) setState(() => _url = url);
  }

  @override
  Widget build(BuildContext context) {
    if (_url == null) {
      // Still loading or fetch failed — show local asset
      return Image.asset(widget.fallback, fit: BoxFit.cover);
    }
    return CachedNetworkImage(
      imageUrl: _url!,
      fit: BoxFit.cover,
      fadeInDuration: const Duration(milliseconds: 400),
      placeholder: (_, _) => Image.asset(widget.fallback, fit: BoxFit.cover),
      errorWidget: (_, _, _) => Image.asset(widget.fallback, fit: BoxFit.cover),
    );
  }
}

// ─── Special Event Banner ─────────────────────────────────────────────────────

class _SpecialEventBanner extends StatelessWidget {
  final bool isDark;
  final bool isEn;
  const _SpecialEventBanner({required this.isDark, required this.isEn});

  static const _gold = Color(0xFFC9A84C);
  static const _maroon = Color(0xFF4A1028);

  @override
  Widget build(BuildContext context) {
    final eventDate = DateTime(2026, 4, 26);
    final now = DateTime.now();
    final daysLeft = eventDate.difference(now).inDays;
    final isToday = now.year == eventDate.year &&
        now.month == eventDate.month &&
        now.day == eventDate.day;
    final isPast = now.isAfter(eventDate.add(const Duration(days: 1)));

    final countLabel = isToday
        ? (isEn ? 'TODAY' : 'UYU MUNSI')
        : isPast
            ? (isEn ? 'COMPLETED' : 'BYARANGIYE')
            : (isEn
                ? 'IN $daysLeft DAY${daysLeft == 1 ? "" : "S"}'
                : 'MU MINSI $daysLeft');

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SpecialOrdinationPage()),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A0510), Color(0xFF3D0D22), Color(0xFF5C1A30)],
            stops: [0.0, 0.5, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: _maroon.withValues(alpha: 0.45),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            // Decorative circle
            Positioned(
              right: -20, top: -20,
              child: Container(
                width: 90, height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _gold.withValues(alpha: 0.08),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      color: _gold.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _gold.withValues(alpha: 0.40)),
                    ),
                    child: const Icon(Icons.church_rounded, color: _gold, size: 20),
                  ),
                  const SizedBox(width: 12),
                  // Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: _gold.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: _gold.withValues(alpha: 0.45)),
                              ),
                              child: Text(
                                countLabel,
                                style: GoogleFonts.lato(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900,
                                  color: _gold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                isEn ? '· SPECIAL EVENT' : '· IGIKORWA GIHAMBAYE',
                                style: GoogleFonts.lato(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white30,
                                  letterSpacing: 0.6,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isEn ? 'Ordination of Pastors' : 'Kurobanura Abashumba',
                          style: GoogleFonts.cinzel(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isEn ? 'EACU · Masaka · Apr 26, 2026' : 'EACU · Masaka · Mata 26, 2026',
                          style: GoogleFonts.lato(
                            fontSize: 10,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Arrow
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: Colors.white60,
                    ),
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
