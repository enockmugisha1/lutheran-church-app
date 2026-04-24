import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lutheran/core/data/liturgy_data.dart';
import 'package:lutheran/core/theme/app_theme.dart';
import 'package:lutheran/features/liturgy/presentation/pages/special_ordination_page.dart';
import 'package:lutheran/features/settings/presentation/providers/settings_provider.dart';

bool _isOrdinationWeek() {
  final now = DateTime.now();
  return now.isAfter(DateTime(2026, 4, 20)) && now.isBefore(DateTime(2026, 4, 28));
}

class LiturgyPage extends StatelessWidget {
  const LiturgyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final services = LiturgyData.services;
    final query = ''.obs;
    final settingsProvider = Get.find<SettingsProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ibitabo by\'Amatangazo'),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Shakisha isengesho...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Obx(
                  () => query.value.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => query.value = '',
                        )
                      : const SizedBox.shrink(),
                ),
              ),
              onChanged: (v) => query.value = v.toLowerCase(),
            ),
          ),
        ),
      ),
      body: Obx(() {
        final filtered = query.value.isEmpty
            ? services
            : services
                  .where(
                    (s) =>
                        s.titleRw.toLowerCase().contains(query.value) ||
                        s.titleEn.toLowerCase().contains(query.value),
                  )
                  .toList();

        if (filtered.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off_rounded,
                  size: 60,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Nta makuru abonetse',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final showSpecial = _isOrdinationWeek() && query.value.isEmpty;
        final offset = showSpecial ? 1 : 0;

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          itemCount: filtered.length + offset,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, i) {
            if (showSpecial && i == 0) {
              return _SpecialLiturgyFeatureCard(isDark: isDark);
            }
            final svc = filtered[i - offset];
            final seasonColor = settingsProvider.getSeasonColor();
            return _LiturgyCard(
              svc: svc,
              seasonColor: seasonColor,
              isDark: isDark,
            );
          },
        );
      }),
    );
  }
}

class _LiturgyCard extends StatelessWidget {
  final LiturgyService svc;
  final Color seasonColor;
  final bool isDark;

  const _LiturgyCard({
    required this.svc,
    required this.seasonColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: seasonColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(svc.icon, style: const TextStyle(fontSize: 24)),
          ),
        ),
        title: Text(
          svc.titleRw,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          svc.titleEn,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, size: 20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => LiturgyDetailPage(service: svc)),
          );
        },
      ),
    );
  }
}

class LiturgyDetailPage extends StatelessWidget {
  final LiturgyService service;
  const LiturgyDetailPage({super.key, required this.service});

  String _buildShareText() {
    final buf = StringBuffer();
    buf.writeln(service.titleRw);
    buf.writeln(service.titleEn);
    buf.writeln();
    for (final section in service.sections) {
      buf.writeln('── ${section.title} ──');
      for (final line in section.lines) {
        if (line.speaker == 'Note') {
          buf.writeln('[${line.text}]');
        } else {
          buf.writeln('${line.speaker}: ${line.text}');
        }
      }
      buf.writeln();
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(service.titleRw),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            tooltip: 'Sangira',
            onPressed: () => Share.share(_buildShareText()),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppTheme.seasonGradient(primary),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.titleEn,
                  style: GoogleFonts.lato(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                if (service.description.isNotEmpty)
                  Text(
                    service.description,
                    style: GoogleFonts.notoSerif(
                      color: Colors.white,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ...service.sections.map(
            (section) => _SectionWidget(section: section, isDark: isDark),
          ),
        ],
      ),
    );
  }
}

class _SectionWidget extends StatelessWidget {
  final LiturgySection section;
  final bool isDark;
  const _SectionWidget({required this.section, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  section.title,
                  style: GoogleFonts.cinzel(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: primary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ...section.lines.map((line) => _LineWidget(line: line, isDark: isDark)),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _LineWidget extends StatelessWidget {
  final LiturgyLine line;
  final bool isDark;
  const _LineWidget({required this.line, required this.isDark});

  @override
  Widget build(BuildContext context) {
    if (line.speaker == 'Note') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.grey.shade200,
            ),
          ),
          child: Text(
            line.text,
            style: GoogleFonts.lato(
              fontStyle: FontStyle.italic,
              color: isDark ? Colors.white70 : Colors.grey.shade700,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ),
      );
    }

    final bool isCongregation =
        line.speaker == 'Abakristu' || line.speaker == 'Bose';
    final bool isUmushumba = line.speaker == 'Umushumba';

    if (isCongregation) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(
              0xFF7B1113,
            ).withValues(alpha: isDark ? 0.15 : 0.07),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(
                0xFF7B1113,
              ).withValues(alpha: isDark ? 0.3 : 0.15),
            ),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.people_rounded,
                    size: 14,
                    color: Color(0xFF7B1113),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    line.speaker.toUpperCase(),
                    style: GoogleFonts.lato(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF7B1113),
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                line.text,
                style:
                    AppTheme.liturgyTextStyle(
                      fontSize: 15,
                      isCongregation: true,
                      dark: isDark,
                    ).copyWith(
                      color: isDark
                          ? const Color(0xFFFFCDD2)
                          : const Color(0xFF7B1113),
                    ),
              ),
            ],
          ),
        ),
      );
    }

    // Umushumba / Reader
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(
                0xFF1A237E,
              ).withValues(alpha: isDark ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              isUmushumba ? 'U' : 'S',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? const Color(0xFF9FA8DA)
                    : const Color(0xFF1A237E),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.speaker,
                  style: GoogleFonts.lato(
                    fontSize: 11,
                    color: isDark
                        ? const Color(0xFF9FA8DA)
                        : const Color(0xFF1A237E),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  line.text,
                  style: AppTheme.liturgyTextStyle(fontSize: 15, dark: isDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Special featured card (ordination week) ──────────────────────────────────

class _SpecialLiturgyFeatureCard extends StatelessWidget {
  final bool isDark;
  const _SpecialLiturgyFeatureCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final daysLeft = DateTime(2026, 4, 26).difference(DateTime.now()).inDays;
    final isToday = daysLeft <= 0;
    final badge = isToday ? 'UYU MUNSI' : 'MU MINSI $daysLeft';

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SpecialOrdinationPage()),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A0510), Color(0xFF4A1028), Color(0xFF5C1A30)],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF4A1028),
              blurRadius: 16, offset: Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20, bottom: -20,
              child: Container(
                width: 130, height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(201, 168, 76, 0.07),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(201, 168, 76, 0.18),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Color.fromRGBO(201, 168, 76, 0.45)),
                        ),
                        child: Text(
                          badge,
                          style: GoogleFonts.lato(
                            fontSize: 9, fontWeight: FontWeight.w900,
                            color: const Color(0xFFC9A84C), letterSpacing: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'LITURGIYA YIHARIYE',
                        style: GoogleFonts.lato(
                          fontSize: 9, fontWeight: FontWeight.w700,
                          color: Colors.white38, letterSpacing: 0.9,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: Colors.white38),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Kurobanura Abashumba',
                    style: GoogleFonts.cinzel(
                      fontSize: 19, fontWeight: FontWeight.w800,
                      color: Colors.white, height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ordination of Pastors & Sunday Service',
                    style: GoogleFonts.lato(
                      fontSize: 12, color: Colors.white54, fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8, runSpacing: 6,
                    children: [
                      _FeaturePill(icon: Icons.calendar_today_rounded, label: 'Mata 26, 2026'),
                      _FeaturePill(icon: Icons.access_time_rounded,    label: '9:00am – 1:30pm'),
                      _FeaturePill(icon: Icons.location_on_rounded,    label: 'EACU · Masaka'),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color.fromRGBO(255, 255, 255, 0.10)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ABAROBANURWA',
                          style: GoogleFonts.lato(
                            fontSize: 9, fontWeight: FontWeight.w900,
                            color: const Color(0xFFC9A84C), letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        for (final name in [
                          'Shemasi MUKUNZI Reminant',
                          'Shemasi RURANGIRWA Emmanuel',
                          'Shemasi NDAYISHIMIYE Noel',
                        ])
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Row(
                              children: [
                                Container(
                                  width: 4, height: 4,
                                  margin: const EdgeInsets.only(right: 8, top: 1),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFC9A84C),
                                  ),
                                ),
                                Text(
                                  name,
                                  style: GoogleFonts.lato(
                                    fontSize: 12.5, fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(255, 255, 255, 0.85),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
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

class _FeaturePill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FeaturePill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color.fromRGBO(255, 255, 255, 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: Colors.white60),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.lato(
              fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }
}
