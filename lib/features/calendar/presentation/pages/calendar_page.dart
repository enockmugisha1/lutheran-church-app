import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:lutheran/core/data/calendar_data_2026.dart';

const _rwMonths = [
  'Mutarama','Gashyantare','Werurwe','Mata',
  'Gicurasi','Kamena','Nyakanga','Kanama',
  'Nzeli','Ukwakira','Ugushyingo','Ukuboza',
];

const _rwDays = ['Cy','Mb','Ka','Ga','Ka','Ga','Ca'];

// ── Lutheran liturgical season colors ─────────────────────────────────────────
const _liturgicalColors = {
  'white':  Color(0xFFF5F0E8),  // Christmas, Easter, feasts
  'green':  Color(0xFF4CAF50),  // Ordinary time
  'red':    Color(0xFFD32F2F),  // Pentecost, martyrs, Reformation
  'purple': Color(0xFF7B1FA2),  // Advent, Lent
  'blue':   Color(0xFF1565C0),  // Advent (alternative)
  'black':  Color(0xFF212121),  // Good Friday
  'gold':   Color(0xFFFFB300),  // All Saints, special feasts
};

const _liturgicalLabels = {
  'white':  'Umunsi Mukuru',
  'green':  'Iminsi isanzwe',
  'red':    'Ubutatu Bwera',
  'purple': 'Igisibo/Uko',
  'blue':   'Gutegereza',
  'black':  'Ijumaa Ryiza',
  'gold':   'Abera bose',
};

Color? _litColor(String? code) =>
    code != null ? _liturgicalColors[code.toLowerCase()] : null;

class _CalCtrl extends GetxController {
  final selected = DateTime.now().obs;
  final focused  = DateTime.now().obs;
}

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl   = Get.put(_CalCtrl());
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg     = isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F5F5);
    final card   = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final border = isDark ? Colors.white12 : Colors.grey.shade200;
    final primary = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          // ── Header ────────────────────────────────────────────────────────
          Container(
            color: bg,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 20, right: 20, bottom: 14,
            ),
            child: Text(
              'Kalendari 2026',
              style: GoogleFonts.cinzel(
                fontSize: 22, fontWeight: FontWeight.w900,
                color: primary, letterSpacing: 0.3,
              ),
            ),
          ),

          // ── Calendar card ─────────────────────────────────────────────────
          Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
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
            child: Obx(() => TableCalendar(
              firstDay: DateTime(2026, 1, 1),
              lastDay: DateTime(2026, 12, 31),
              focusedDay: ctrl.focused.value,
              selectedDayPredicate: (d) => isSameDay(d, ctrl.selected.value),
              onDaySelected: (sel, foc) {
                ctrl.selected.value = sel;
                ctrl.focused.value  = foc;
              },
              calendarFormat: CalendarFormat.month,
              availableCalendarFormats: const {CalendarFormat.month: 'Kwezi'},
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronIcon: Icon(Icons.chevron_left, color: primary),
                rightChevronIcon: Icon(Icons.chevron_right, color: primary),
                titleTextFormatter: (date, _) =>
                    '${_rwMonths[date.month - 1]} ${date.year}',
                titleTextStyle: GoogleFonts.cinzel(
                  fontSize: 16, fontWeight: FontWeight.w800,
                  color: primary, letterSpacing: 0.3,
                ),
                headerPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: GoogleFonts.lato(
                  fontSize: 11, fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white38 : Colors.grey.shade400,
                ),
                weekendStyle: GoogleFonts.lato(
                  fontSize: 11, fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white38 : Colors.grey.shade400,
                ),
                dowTextFormatter: (date, _) => _rwDays[date.weekday % 7],
              ),
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                defaultTextStyle: GoogleFonts.lato(
                  fontSize: 13, fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
                weekendTextStyle: GoogleFonts.lato(
                  fontSize: 13, fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
                todayDecoration: BoxDecoration(
                  border: Border.all(color: primary, width: 1.5),
                  shape: BoxShape.circle,
                ),
                todayTextStyle: GoogleFonts.lato(
                  fontSize: 13, fontWeight: FontWeight.w800, color: primary,
                ),
                selectedDecoration: BoxDecoration(
                  color: primary, shape: BoxShape.circle,
                ),
                selectedTextStyle: GoogleFonts.lato(
                  fontSize: 13, fontWeight: FontWeight.w800,
                  color: isDark ? Colors.black : Colors.white,
                ),
                markersMaxCount: 1,
              ),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (ctx, day, _) {
                  final r = CalendarData2026.getReading(day);
                  if (r == null) return null;
                  final lc = _litColor(r.liturgicalColor);
                  return Positioned(
                    bottom: 4,
                    child: Container(
                      width: 5, height: 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: lc ?? (isDark ? Colors.white54 : Colors.black38),
                      ),
                    ),
                  );
                },
              ),
            )),
          ),

          // ── Reading panel ─────────────────────────────────────────────────
          Expanded(
            child: Obx(() {
              final reading = CalendarData2026.getReading(ctrl.selected.value);
              if (reading == null) {
                return Center(
                  child: Text(
                    'Nta makuru abonetse',
                    style: GoogleFonts.lato(
                      fontSize: 14, fontStyle: FontStyle.italic,
                      color: isDark ? Colors.white38 : Colors.grey.shade400,
                    ),
                  ),
                );
              }
              return _ReadingPanel(
                reading: reading,
                date: ctrl.selected.value,
                isDark: isDark,
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ─── Reading Panel ────────────────────────────────────────────────────────────
class _ReadingPanel extends StatelessWidget {
  final DailyReading reading;
  final DateTime date;
  final bool isDark;
  const _ReadingPanel({
    required this.reading, required this.date, required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final card    = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final primary = isDark ? Colors.white : Colors.black;
    final border  = isDark ? Colors.white12 : Colors.grey.shade200;

    final litColor = _litColor(reading.liturgicalColor);
    final litLabel = reading.liturgicalColor != null
        ? _liturgicalLabels[reading.liturgicalColor!.toLowerCase()]
        : null;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
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
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Liturgical season color band ──────────────────────────────
            if (litColor != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: litColor.withValues(alpha: 0.18),
                  child: Row(
                    children: [
                      Container(
                        width: 10, height: 10,
                        decoration: BoxDecoration(
                          color: litColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        litLabel ?? reading.liturgicalColor!,
                        style: GoogleFonts.lato(
                          fontSize: 11, fontWeight: FontWeight.w700,
                          color: litColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // ── Rest of content ───────────────────────────────────────────
            Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Day header
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primary.withValues(alpha: 0.06),
                    border: Border.all(
                        color: primary.withValues(alpha: 0.20), width: 1.5),
                  ),
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style: GoogleFonts.cinzel(
                        fontSize: 20, fontWeight: FontWeight.w900,
                        color: primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    reading.dayName,
                    style: GoogleFonts.cinzel(
                      fontSize: 16, fontWeight: FontWeight.w800,
                      color: primary, height: 1.2,
                    ),
                  ),
                ),
              ],
            ),

            // Theme
            if (reading.theme != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: border),
                ),
                child: Text(
                  reading.theme!,
                  style: GoogleFonts.notoSerif(
                    fontSize: 13, fontStyle: FontStyle.italic, height: 1.5,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.80)
                        : Colors.black87,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Readings
            if (reading.psalm != null)
              _Row(icon: Icons.music_note_rounded,
                  label: 'Zaburi', value: reading.psalm!, isDark: isDark),
            if (reading.epistle != null)
              _Row(icon: Icons.mail_outline_rounded,
                  label: 'Abapostoro', value: reading.epistle!, isDark: isDark),
            if (reading.gospel != null)
              _Row(icon: Icons.menu_book_rounded,
                  label: 'Ubutumwa', value: reading.gospel!, isDark: isDark),
            if (reading.morningReading != null)
              _Row(icon: Icons.wb_sunny_rounded,
                  label: 'Mu gitondo', value: reading.morningReading!, isDark: isDark),
            if (reading.eveningReading != null)
              _Row(icon: Icons.nightlight_round,
                  label: 'Mu mugoroba', value: reading.eveningReading!, isDark: isDark),

            if (reading.psalm == null &&
                reading.epistle == null &&
                reading.gospel == null &&
                reading.morningReading == null &&
                reading.eveningReading == null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'Nta makuru abonetse',
                    style: GoogleFonts.lato(
                      color: isDark ? Colors.white38 : Colors.grey.shade400,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ],
            ), // inner Column
            ), // Padding
          ], // outer Column children
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isDark;
  const _Row({
    required this.icon, required this.label,
    required this.value, required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final primary = isDark ? Colors.white : Colors.black;
    final subtle  = isDark ? Colors.white24 : Colors.grey.shade400;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: primary.withValues(alpha: 0.10)),
            ),
            child: Icon(icon, size: 16, color: subtle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: GoogleFonts.lato(
                    fontSize: 9, fontWeight: FontWeight.w900,
                    color: subtle, letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.lato(
                    fontSize: 15, fontWeight: FontWeight.w600,
                    color: primary,
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
