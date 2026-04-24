import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:lutheran/features/community/presentation/pages/community_page.dart';
import 'package:lutheran/features/hymns/presentation/pages/hymns_page.dart';
import 'package:lutheran/features/prayer/presentation/pages/prayer_page.dart';
import 'package:lutheran/features/catechism/presentation/pages/catechism_page.dart';
import 'package:lutheran/features/settings/presentation/pages/settings_page.dart';

import 'package:lutheran/features/profile/presentation/pages/profile_page.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Byinshi'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Worship ──
            _SectionHeader(title: 'Gusenga & Ubucuti'),
            const SizedBox(height: 12),
            _MenuCard(
              children: [
                _MenuItem(
                  icon: Icons.music_note_rounded,
                  color: const Color(0xFF26A69A),
                  title: 'Indirimbo',
                  subtitle: 'Indirimbo z\'Itorero rya Luteri',
                  isDark: isDark,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HymnsPage()),
                  ),
                ),
                const Divider(height: 1, indent: 72),
                _MenuItem(
                  icon: Icons.people_rounded,
                  color: const Color(0xFF66BB6A),
                  title: 'Ubucuti',
                  subtitle: 'Gutumanahana n\'abavandimwe',
                  isDark: isDark,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CommunityPage()),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Spiritual Tools ──
            _SectionHeader(title: 'Ibikoresho by\'Umwuka'),
            const SizedBox(height: 12),
            _MenuCard(
              children: [
                _MenuItem(
                  icon: Icons.volunteer_activism_rounded,
                  color: const Color(0xFFE57373),
                  title: 'Amasengesho Asanzwe',
                  subtitle: 'Amasengesho y\'ibihe bitandukanye',
                  isDark: isDark,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PrayerPage()),
                  ),
                ),
                const Divider(height: 1, indent: 72),
                _MenuItem(
                  icon: Icons.menu_book_rounded,
                  color: const Color(0xFF5C6BC0),
                  title: 'Catechism Ntoya ya Luteri',
                  subtitle: 'Amategeko, Kwizera, Isengesho rya Data',
                  isDark: isDark,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CatechismPage()),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Church Info ──
            _SectionHeader(title: 'Amakuru y\'Itorero'),
            const SizedBox(height: 12),
            _MenuCard(
              children: [
                _MenuItem(
                  icon: Icons.church_rounded,
                  color: const Color(0xFF4CAF50),
                  title: 'Ibyerekeranye na LCR',
                  subtitle: 'Itorero rya Luteri mu Rwanda',
                  isDark: isDark,
                  onTap: () => _showAboutLCR(context, isDark),
                ),
                const Divider(height: 1, indent: 72),
                _MenuItem(
                  icon: Icons.share_rounded,
                  color: const Color(0xFF26A69A),
                  title: 'Sangira iyi App',
                  subtitle: 'Bwira abandi bantu iby\'iyi app',
                  isDark: isDark,
                  onTap: () => Share.share(
                    'Koresha LCR App - Itorero rya Luteri mu Rwanda!\n\nIyi app irimo Bibiliya, Indirimbo, Amasengesho, Kalendari y\'Itorero, Liturgiya, n\'ibindi byinshi. Yifashishe mu gukomeza ukwizera kwawe buri munsi.\n\nYikurire kuri Play Store.',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Profile & Settings ──
            _SectionHeader(title: 'Konti & Igenamiterere'),
            const SizedBox(height: 12),
            _MenuCard(
              children: [
                _MenuItem(
                  icon: Icons.person_rounded,
                  color: const Color(0xFF1A2456),
                  title: 'Umwirondoro',
                  subtitle: 'Ibyerekeranye nawe, imibare, konti',
                  isDark: isDark,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfilePage()),
                  ),
                ),
                const Divider(height: 1, indent: 72),
                _MenuItem(
                  icon: Icons.settings_rounded,
                  color: Colors.grey.shade600,
                  title: 'Igenamiterere',
                  subtitle: 'Ururimi, Insanganyamatsiko, Inyuguti',
                  isDark: isDark,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsPage()),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),
            Center(
              child: Opacity(
                opacity: 0.5,
                child: Column(
                  children: [
                    Text(
                      'LCR · Itorero rya Luteri mu Rwanda',
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'v1.0.0 · © 2026',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showAboutLCR(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final primary = Theme.of(context).colorScheme.primary;
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.85,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          primary,
                          Color.lerp(primary, Colors.black, 0.25)!,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.church_rounded,
                          size: 40,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Itorero rya Luteri mu Rwanda',
                                style: GoogleFonts.cinzel(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Lutheran Church of Rwanda (LCR)',
                                style: GoogleFonts.lato(
                                  color: Colors.white60,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Ubutumwa Bwacu',
                    style: GoogleFonts.cinzel(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Itorero rya Luteri mu Rwanda (LCR) ryashingwe ku bushake bwo kwamamaza ubutumwa bwiza bwa Yesu Kristo mu Rwanda no ku isi hose. Twishingiye ku nyigisho z\'Itorero rya Luteri nk\'uko byanditswe na Martin Luther, tukemera ko umuntu akizwa ubuntu ku bw\'ukwizera muri Kristo wenyine.',
                    style: GoogleFonts.lato(fontSize: 14, height: 1.7),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ibyo Twizera',
                    style: GoogleFonts.cinzel(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _BulletPoint(
                    'Bibiliya yera ni yo isoko y\'inyigisho n\'ubuzima bwacu bwose.',
                  ),
                  _BulletPoint(
                    'Umuntu akizwa ubuntu n\'ukwizera gusa, ku bwa Kristo wenyine.',
                  ),
                  _BulletPoint(
                    'Ubatizo n\'Isakramentu Yera ni inzira Imana ikoreshamo ubuntu bwayo.',
                  ),
                  _BulletPoint(
                    'Itorero ni umubiri wa Kristo, ubusabane bw\'abizera.',
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Iyi App',
                    style: GoogleFonts.cinzel(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Iyi app yakozwe kugira ngo ifashe abakiristu b\'Itorero rya Luteri mu Rwanda kugera ku bikoresho by\'idini byihuse: Bibiliya, Indirimbo, Amasengesho, Kalendari y\'Itorero, Liturgiya, na Catechism Ntoya ya Luteri.',
                    style: GoogleFonts.lato(fontSize: 14, height: 1.7),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.lato(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: Colors.grey.shade500,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final List<Widget> children;
  const _MenuCard({required this.children});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252430) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF3A3847) : Colors.grey.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final bool isDark;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color, Color.lerp(color, Colors.black, 0.15)!],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
      title: Text(
        title,
        style: GoogleFonts.lato(fontWeight: FontWeight.w700, fontSize: 14),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        size: 20,
        color: Colors.grey,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;
  const _BulletPoint(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 7, right: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.lato(fontSize: 14, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}
