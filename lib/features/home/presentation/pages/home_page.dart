import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lutheran/core/localization/app_localizations.dart';
import 'package:lutheran/features/bible/presentation/pages/bible_page.dart';
import 'package:lutheran/features/calendar/presentation/pages/calendar_page.dart';
import 'package:lutheran/features/home/presentation/controllers/home_page_controller.dart';
import 'package:lutheran/features/home/presentation/widgets/home_dashboard.dart';
import 'package:lutheran/features/liturgy/presentation/pages/liturgy_page.dart';
import 'package:lutheran/features/profile/presentation/pages/profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomePageController());

    final pages = [
      const HomeDashboard(),
      const BiblePage(),
      const LiturgyPage(),
      const CalendarPage(),
      const ProfilePage(),
    ];

    return Obx(
      () => Scaffold(
        body: pages[controller.selectedIndex.value],
        bottomNavigationBar: _AppBottomNav(
          selectedIndex: controller.selectedIndex.value,
          onTap: controller.selectTab,
        ),
      ),
    );
  }
}

class _AppBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _AppBottomNav({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context)!;

    final navBg   = isDark ? const Color(0xFF111111) : Colors.white;
    final active  = isDark ? Colors.white : Colors.black;
    final inactive = isDark ? Colors.white38 : Colors.grey.shade400;

    final items = [
      (l.home,       Icons.home_rounded,          Icons.home_outlined),
      (l.bible,      Icons.menu_book_rounded,      Icons.menu_book_outlined),
      ('Liturgiya',  Icons.church_rounded,          Icons.church_outlined),
      (l.calendar,   Icons.calendar_month_rounded, Icons.calendar_month_outlined),
      ('Mwirondoro', Icons.person_rounded,         Icons.person_outline_rounded),
    ];

    return Container(
      color: navBg,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top border line
          Container(height: 0.5, color: isDark ? Colors.white10 : Colors.grey.shade200),
          SafeArea(
            top: false,
            child: SizedBox(
              height: 60,
              child: Row(
                children: List.generate(items.length, (i) {
                  final selected = selectedIndex == i;
                  final label    = items[i].$1;
                  final iconFill = items[i].$2;
                  final iconOut  = items[i].$3;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onTap(i),
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Active indicator bar at top
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 2,
                            width: selected ? 24 : 0,
                            margin: const EdgeInsets.only(bottom: 6),
                            decoration: BoxDecoration(
                              color: active,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),

                          // Icon or avatar
                          i == 4
                              ? _ProfileNavAvatar(selected: selected, isDark: isDark)
                              : Icon(
                                  selected ? iconFill : iconOut,
                                  size: 22,
                                  color: selected ? active : inactive,
                                ),

                          const SizedBox(height: 4),

                          // Label
                          Text(
                            label,
                            style: GoogleFonts.lato(
                              fontSize: 10,
                              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                              color: selected ? active : inactive,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileNavAvatar extends StatelessWidget {
  final bool selected;
  final bool isDark;
  const _ProfileNavAvatar({required this.selected, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final user     = FirebaseAuth.instance.currentUser;
    final initial  = user?.displayName?.isNotEmpty == true
        ? user!.displayName![0].toUpperCase()
        : (user?.email?.isNotEmpty == true ? user!.email![0].toUpperCase() : '?');
    final photoUrl = user?.photoURL;
    final active   = isDark ? Colors.white : Colors.black;
    final inactive = isDark ? Colors.white38 : Colors.grey.shade400;

    return Container(
      width: 26, height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? active : inactive,
          width: 1.5,
        ),
      ),
      child: ClipOval(
        child: photoUrl != null
            ? Image.network(photoUrl, fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Center(
                  child: Text(initial,
                    style: GoogleFonts.lato(fontSize: 10, fontWeight: FontWeight.w700,
                      color: selected ? active : inactive))))
            : Center(
                child: Text(initial,
                  style: GoogleFonts.lato(fontSize: 10, fontWeight: FontWeight.w700,
                    color: selected ? active : inactive))),
      ),
    );
  }
}
