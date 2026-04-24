import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lutheran/core/theme/app_theme.dart';
import 'package:share_plus/share_plus.dart';
import 'package:lutheran/features/settings/presentation/providers/settings_provider.dart';

// ─── Prayer Data Model ──────────────────────────────────────────────────────
class PrayerEntry {
  final String title;
  final String titleEn;
  final String category;
  final String text;
  final String?
  season; // null = all seasons, else matches LiturgicalSeason name
  final String? timeOfDay; // 'morning', 'evening', or null = any time
  const PrayerEntry({
    required this.title,
    this.titleEn = '',
    required this.category,
    required this.text,
    this.season,
    this.timeOfDay,
  });
}

// ─── Real Lutheran Prayers ──────────────────────────────────────────────────
const _prayers = [
  // ══════════════════════════════════════════════════════════════════════════
  //  MORNING PRAYERS (Amasengesho yo mu Gitondo)
  // ══════════════════════════════════════════════════════════════════════════
  PrayerEntry(
    category: 'Mu Gitondo',
    title: 'Isengesho ryo mu Gitondo (Luther)',
    titleEn: 'Luther\'s Morning Prayer',
    timeOfDay: 'morning',
    text:
        'Ndagushimira, Mana Data yanjye yo mu ijuru, kubera Yesu Kristo Umwana wawe mukundwa, ko wanrinze muri iri joro ryose mu byago n\'ibibi byose, kandi ndagusaba ngo unkingire no kuri uyu munsi ibyaha n\'ibibi byose, kugira ngo ibikorwa byanjye byose n\'ubuzima bwanjye bigushimishe. Kuko mbikurikije mu maboko yawe, njye ubwanjye, umubiri wanjye, ubugingo bwanjye n\'ibintu byanjye byose. Umumalayika wawe wera abe kumwe nanjye, kugira ngo umwanzi mubi adafite ububasha ku bwanjye. Amina.',
  ),
  PrayerEntry(
    category: 'Mu Gitondo',
    title: 'Gushimira Imana ku Munsi Mushya',
    titleEn: 'Thanksgiving for a New Day',
    timeOfDay: 'morning',
    text:
        'Mana Data wa twese, ushimwe ku bw\'iki gitondo cyiza uduhaye. Turagushimira ku bw\'uburindzi bwawe mu ijoro ryakeye, no ku bw\'imbaraga nshya uduhaye ngo dukore imirimo yacu. Turagusaba ngo uduhe umutima wo gushimira mu byatubaho byose, kandi utuyobore mu nzira z\'ukuri n\'amahoro. Mu izina rya Yesu Kristo. Amina.',
  ),
  PrayerEntry(
    category: 'Mu Gitondo',
    title: 'Isengesho ryo Mbere y\'Akazi',
    titleEn: 'Prayer Before Work',
    timeOfDay: 'morning',
    text:
        'Mana Data, ndagiye ku kazi. Turagusaba ngo uyobore imirimo yanjye y\'uyu munsi. Mpe ubwenge bwo gukora neza, umutima wo gufashanya n\'abo nkorana, n\'imbaraga zo gutsinda ibibazo. Imirimo yanjye ihere icyubahiro izina ryawe. Amina.',
  ),

  // ══════════════════════════════════════════════════════════════════════════
  //  EVENING PRAYERS (Amasengesho yo mu Mugoroba)
  // ══════════════════════════════════════════════════════════════════════════
  PrayerEntry(
    category: 'Mu Mugoroba',
    title: 'Isengesho ryo mu Mugoroba (Luther)',
    titleEn: 'Luther\'s Evening Prayer',
    timeOfDay: 'evening',
    text:
        'Ndagushimira, Mana Data yanjye yo mu ijuru, kubera Yesu Kristo Umwana wawe mukundwa, ko wanrinze neza muri uyu munsi wose, kandi ndagusaba ngo ubabarire ibyaha byanjye byose n\'amakosa yose nakoze, kandi unkingire muri iri joro neza. Kuko mbikurikije mu maboko yawe, njye ubwanjye, umubiri wanjye, ubugingo bwanjye n\'ibintu byanjye byose. Umumalayika wawe wera abe kumwe nanjye, kugira ngo umwanzi mubi adafite ububasha ku bwanjye. Amina.',
  ),
  PrayerEntry(
    category: 'Mu Mugoroba',
    title: 'Isengesho ryo mu Mugoroba',
    titleEn: 'Evening Prayer',
    timeOfDay: 'evening',
    text:
        'Mwami Yesu, turi mu mugoroba, dore umunsi uragiye. Turagusaba uburindzi bwawe muri iri joro. Urinde ingo zacu, urinde abacu, kandi uduhe gusinzira neza mu mahoro yawe. Ejo tuzazinduke dushimira rwawe rwose. Amina.',
  ),
  PrayerEntry(
    category: 'Mu Mugoroba',
    title: 'Isengesho ryo Gusaba Amahoro mu Ijoro',
    titleEn: 'Prayer for Peaceful Night',
    timeOfDay: 'evening',
    text:
        'Uwiteka, urakoze iby\'uyu munsi wose. Ndagushimira ubuzima, umutima mwiza, n\'abantu bankunze. Nshyire imbaho z\'amahoro nkomereza ijoro. Uze unzuze isengesho ryo gukunda abandi. Urinde ingo zacu n\'abana bacu muri iri joro. Amina.',
  ),

  // ══════════════════════════════════════════════════════════════════════════
  //  SEASONAL PRAYERS (Amasengesho akurikira Ibihe by'Itorero)
  // ══════════════════════════════════════════════════════════════════════════
  PrayerEntry(
    category: 'Igihe cy\'Itorero',
    title: 'Isengesho ry\'Igisibo (Advent)',
    titleEn: 'Advent Prayer',
    season: 'advent',
    text:
        'Mwami Imana ushoborabyose, turagusaba ngo udufashe gutegura imitima yacu guhabwa Umwami wacu Yesu Kristo. Nk\'uko Yohana Umubatiza yateguye inzira y\'Umwami, natwe dutegure ubuzima bwacu guhura n\'Umukiza wacu. Dushyireho amahoro, urukundo n\'ibyiringiro muri iki gihe cy\'igisibo. Mu izina rya Yesu Kristo. Amina.',
  ),
  PrayerEntry(
    category: 'Igihe cy\'Itorero',
    title: 'Isengesho cya Noheli',
    titleEn: 'Christmas Prayer',
    season: 'christmastide',
    text:
        'Mana Data wa twese, ushimwe ku bw\'impano y\'Umwana wawe Yesu Kristo, waje mu isi akazuka muri twe mu buntu n\'ukuri. Turagusaba ngo urumuri rwe rumurikire mu buzima bwacu no mu mitima yacu, kandi uduhe kwamamaza ibyishimo by\'ivuka rye mu bantu bose. Mu izina rya Yesu Kristo Umwami wacu. Amina.',
  ),
  PrayerEntry(
    category: 'Igihe cy\'Itorero',
    title: 'Isengesho cya Epifaniya',
    titleEn: 'Epiphany Prayer',
    season: 'epiphany',
    text:
        'Mwami Imana, wahishuye ubwiza bwawe mu mahanga yose kubera Inyenyeri yayoboye abanyabutumire, turagusaba ngo uduhe kumenya no gushimira urumuri rw\'Umwana wawe Yesu Kristo, kandi utuyobore kugira ngo tuzabone ubwiza bwawe buhoraho. Mu izina rya Yesu Kristo. Amina.',
  ),
  PrayerEntry(
    category: 'Igihe cy\'Itorero',
    title: 'Isengesho cy\'Igisibo Kinini (Lent)',
    titleEn: 'Lenten Prayer',
    season: 'lent',
    text:
        'Mana Ushoborabyose n\'Uhoraho, watugiriye neza ku buryo watanze Umwana wawe w\'ikinege ngo apfire ibyaha byacu, turagusaba ngo uduhe imitima yicuza kandi yizera, kugira ngo twitoze ibyaha byacu, twishimire imbabazi zawe, kandi tugendere mu bushya bw\'ubugingo. Mu izina rya Yesu Kristo Umwami wacu. Amina.',
  ),
  PrayerEntry(
    category: 'Igihe cy\'Itorero',
    title: 'Isengesho cya Pasika',
    titleEn: 'Easter Prayer',
    season: 'eastertide',
    text:
        'Mana ushoborabyose, wazuye Umwami wacu Yesu Kristo mu bapfuye, turagushimira ku bw\'intsinzi yake ku rupfu, icyaha na Satani. Turagusaba ngo ibyiringiro by\'izuka riduheshe ibyishimo n\'amahoro, kandi utuyobore kubaho mu bushya bw\'ubugingo bwawe. Mu izina rya Yesu Kristo Umwami wacu. Amina.',
  ),
  PrayerEntry(
    category: 'Igihe cy\'Itorero',
    title: 'Isengesho cy\'Iminsi Mikuru ya Pasika',
    titleEn: 'Holy Week / Triduum Prayer',
    season: 'easterTriduum',
    text:
        'Mwami Yesu Kristo, mu iminsi mikuru y\'ububabare bwawe, utwigisha urukundo rw\'ikirenga rwatumye uba ingabire ku bwacu. Turagusaba ngo iyo mpano yawe iduhindure, idufashe kwikuramo ibyanduye, kandi idusanire mu buntu. Turizihiza umusaraba wawe, tuzize intsinzi y\'izuka ryawe. Amina.',
  ),
  PrayerEntry(
    category: 'Igihe cy\'Itorero',
    title: 'Isengesho cya Pentekositi',
    titleEn: 'Pentecost Prayer',
    season: 'pentecost',
    text:
        'Mana, wahaye Itorero ryawe Umwuka Wera ku munsi wa Pentekositi, turagusaba ngo ukomeze Itorero ryawe mu kwizera no mu rukundo kubera Umwuka wawe Wera, kandi utuyobore mu kuri kose. Dufashe kwamamaza ubutumwa bwiza mu mahanga yose. Mu izina rya Yesu Kristo Umwami wacu. Amina.',
  ),
  PrayerEntry(
    category: 'Igihe cy\'Itorero',
    title: 'Isengesho cy\'Igihe Gisanzwe',
    titleEn: 'Ordinary Time Prayer',
    season: 'ordinary',
    text:
        'Mwami Imana, mu gihe gisanzwe cy\'itorero, turagusaba ngo uduhe gukura mu kwizera, mu rukundo no mu kwizigama. Dufashe gukurikira Umwana wawe Yesu mu buzima bwacu bwa buri munsi, kandi tugire umutima wo gukorera bagenzi bacu. Mu izina rya Yesu Kristo. Amina.',
  ),

  // ══════════════════════════════════════════════════════════════════════════
  //  GENERAL PRAYERS (Amasengesho Asanzwe)
  // ══════════════════════════════════════════════════════════════════════════
  PrayerEntry(
    category: 'Kwicuza',
    title: 'Isengesho ryo Kwicuza Ibyaha',
    titleEn: 'Prayer of Confession',
    text:
        'Mana y\'imbabazi, turicuza imbere yawe kuko twacumuye mu bitekerezo, mu magambo no mu bikorwa. Ntitwagukundishije umutima wacu wose, kandi ntitwakunze bagenzi bacu nk\'uko twikunda. Turakwinginga ngo utubabarire kubera Umwana wawe Yesu Kristo, utwoze imitima yacu, kandi uduhe imbaraga zo kugendera mu bushake bwawe. Amina.',
  ),
  PrayerEntry(
    category: 'Kwicuza',
    title: 'Isengesho ryo Kugaruka ku Mana',
    titleEn: 'Prayer of Repentance',
    text:
        'Mwami, naje imbere yawe ncumuye kandi nkeneye imbabazi zawe. Nkuye mu nzira yawe, nacumuye mu byo natekereje, mvuze kandi nkora. Ariko nzi ko uri Imana y\'urukundo n\'imbabazi. Nyicuze koko, Mwami, undekurire ibyaha byanjye byose. Mpinduremo umuntu mushya ku bwa Yesu Kristo. Amina.',
  ),
  PrayerEntry(
    category: 'Umuryango',
    title: 'Isengesho ry\'Umuryango',
    titleEn: 'Family Prayer',
    text:
        'Mana Data, turagushimira ku bw\'umuryango wacu. Turagusaba ngo uduhambire mu rukundo rwawe. Urinde abana bacu, uyobore ababyeyi, kandi uduhe kubaho mu bwumvikane n\'amahoro. Umuryango wacu ube icyitegererezo cy\'itorero ryawe. Amina.',
  ),
  PrayerEntry(
    category: 'Umuryango',
    title: 'Isengesho ry\'Abana',
    titleEn: 'Prayer for Children',
    text:
        'Mwami Yesu wamaze gukunda abana ukabemera, turagusaba ngo urinde abana bacu. Ubayobore mu nzira yawe, ubakize ibishuko by\'isi, kandi ubakuze mu bwenge no mu kwizera. Bazaguke bazi ko bakundwa n\'Imana. Amina.',
  ),
  PrayerEntry(
    category: 'Uburwayi',
    title: 'Isengesho ry\'Abarwayi',
    titleEn: 'Prayer for the Sick',
    text:
        'Mwami Imana, tweza amaboko yacu asenga ku bw\'abarwayi. Turagusaba ngo ubasure mu burwayi bwabo, ubahe ihumure n\'imbaraga zo kwihangana. Niba ari ubushake bwawe, ubahe gukira neza, bazagaruke mu materaniro yo kugusingiza. Amina.',
  ),
  PrayerEntry(
    category: 'Itorero',
    title: 'Isengesho ry\'Itorero',
    titleEn: 'Prayer for the Church',
    text:
        'Mwami w\'Itorero, turagusaba ngo ugumishe Itorero ryawe mu kwizera no mu rukundo. Shyigikira abashumba n\'abigisha bayo, ubagire abizera kandi b\'intwari. Ohereza Mwuka wawe Wera kugira ngo Itorero rikomere mu kwamamaza ubutumwa bwiza. Mu izina rya Yesu Kristo. Amina.',
  ),
  PrayerEntry(
    category: 'Itorero',
    title: 'Isengesho ryo Mbere yo Gusenga',
    titleEn: 'Prayer Before Worship',
    text:
        'Mana Data wo mu ijuru, turi imbere yawe turi abacumuzi. Ariko twaje ku bw\'imbabazi zawe mu izina rya Yesu. Turagusaba ngo ufungure imitima yacu guhabwa ijambo ryawe. Mwuka Wawe Wera aduhe gusobanukirwa n\'ukuri, kandi adushoboze kubaho mu bushake bwawe. Amina.',
  ),
  PrayerEntry(
    category: 'Uburindzi',
    title: 'Isengesho ry\'Urugendo',
    titleEn: 'Prayer for Travelling',
    text:
        'Mwami Imana, turi mu rugendo, turagusaba ngo udufatanye urugendo rwacu. Urinde inzira zacu, uturinde ibyago, kandi utugeze ahari amahoro. Nk\'uko wayoboye Abisirayeli mu ishyamba, natwe uduyobore mu nzira zacu zose. Mu izina rya Yesu. Amina.',
  ),
  PrayerEntry(
    category: 'Uburindzi',
    title: 'Isengesho cyo Gusaba Amahoro mu Gihugu',
    titleEn: 'Prayer for Peace in the Nation',
    text:
        'Mana Ushoborabyose, turagusaba amahoro mu gihugu cyacu. Yobora abayobozi bacu ngo bayobore abantu mu butabera n\'ukuri. Hagarika intambara n\'amakimbirane, maze uhagururire amahoro n\'ubumwe mu bana b\'u Rwanda. Mu izina rya Yesu Kristo, Umwami w\'amahoro. Amina.',
  ),
  PrayerEntry(
    category: 'Agahinda',
    title: 'Isengesho mu Gihe cy\'Agahinda',
    titleEn: 'Prayer in Time of Grief',
    text:
        'Mana y\'ihumure ryose, turi mu gihe cy\'agahinda n\'intimba. Turagusaba ngo ube hafi yacu muri iki gihe gikomeye. Uzuze imitima yacu amahoro yawe, kandi uduheshe ibyiringiro by\'izuka n\'ubugingo buhoraho. Nk\'uko Yesu yajyaga arira hamwe n\'abarira, natwe twumve ko uri kumwe natwe. Amina.',
  ),
  PrayerEntry(
    category: 'Kwiga',
    title: 'Isengesho ry\'Abiga',
    titleEn: 'Prayer for Students',
    text:
        'Mwami Imana, turagusaba ku bw\'abiga n\'abanyeshuri. Ubafashe gusobanukirwa amasomo yabo, ubahe ubwenge n\'ubushake bwo kwiga. Ubategure kuzakorera igihugu n\'Itorero ryawe neza. Mu izina rya Yesu. Amina.',
  ),
  PrayerEntry(
    category: 'Gushimira',
    title: 'Gushimira ku biribwa',
    titleEn: 'Prayer Before Meals',
    text:
        'Mwami Imana, turagushimira ku bw\'ibi biribwa utugeneye. Turagusaba ngo ubihe umugisha kubera ubugingo bwacu, kandi uduhe umutima w\'ubupfura n\'urukundo. Ibuke n\'abadafite ibyo kurya, ubahe kubona ibyo bakeneye. Amina.',
  ),
  PrayerEntry(
    category: 'Gushimira',
    title: 'Gushimira Imana ku Bw\'Itorero',
    titleEn: 'Thanksgiving for the Church',
    text:
        'Mwami Imana, turagushimira ku bw\'Itorero ryawe uri hano ku isi. Ushimwe ku bw\'ijambo ryawe riduhisha n\'amasakramentu yawe aduha imbaraga. Turagusaba ngo ugumishe Itorero ryawe mu kwizera, kandi uryohereze mu mahanga yose. Mu izina rya Yesu Kristo, Umwami wacu. Amina.',
  ),
];

// ─── Category definitions ────────────────────────────────────────────────────
const _allCategories = [
  'Byose',
  'Mu Gitondo',
  'Mu Mugoroba',
  'Igihe cy\'Itorero',
  'Kwicuza',
  'Umuryango',
  'Uburwayi',
  'Itorero',
  'Uburindzi',
  'Gushimira',
  'Kwiga',
  'Agahinda',
];

class PrayerPage extends StatelessWidget {
  const PrayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;
    final hour = DateTime.now().hour;
    // Default to time-relevant category
    final defaultCat = hour < 12
        ? 'Mu Gitondo'
        : (hour >= 17 ? 'Mu Mugoroba' : 'Byose');
    final selectedCategory = defaultCat.obs;

    // Get current liturgical season for highlighting
    LiturgicalSeason? currentSeason;
    try {
      final sp = Get.find<SettingsProvider>();
      currentSeason = sp.currentSeason.value;
    } catch (_) {}

    return Scaffold(
      appBar: AppBar(title: const Text('Amasengesho'), elevation: 0),
      body: Column(
        children: [
          // Time-of-day banner
          _TimeBanner(isDark: isDark, hour: hour),
          // Category filter chips
          SizedBox(
            height: 48,
            child: Obx(
              () => ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _allCategories.length,
                itemBuilder: (context, i) {
                  final cat = _allCategories[i];
                  final isSelected = selectedCategory.value == cat;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (_) => selectedCategory.value = cat,
                      selectedColor: AppTheme.maroon.withValues(alpha: 0.1),
                      checkmarkColor: AppTheme.maroon,
                      backgroundColor: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : Colors.grey.shade100,
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: isSelected
                              ? AppTheme.gold.withValues(alpha: 0.5)
                              : Colors.transparent,
                        ),
                      ),
                      labelStyle: GoogleFonts.lato(
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected
                            ? AppTheme.maroon
                            : (isDark ? Colors.white70 : Colors.grey.shade700),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Prayer list
          Expanded(
            child: Obx(() {
              final filtered = selectedCategory.value == 'Byose'
                  ? _prayers
                  : _prayers
                        .where((p) => p.category == selectedCategory.value)
                        .toList();

              // Sort: season-relevant prayers first
              final sorted = List<PrayerEntry>.from(filtered);
              final season = currentSeason;
              if (season != null) {
                sorted.sort((a, b) {
                  final aMatch = a.season == season.name ? 0 : 1;
                  final bMatch = b.season == season.name ? 0 : 1;
                  return aMatch.compareTo(bMatch);
                });
              }

              if (sorted.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.volunteer_activism_rounded,
                        size: 48,
                        color: isDark ? Colors.white24 : Colors.grey.shade300,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Nta masengesho abonetse',
                        style: TextStyle(
                          color: isDark ? Colors.white38 : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: sorted.length,
                itemBuilder: (context, i) {
                  final prayer = sorted[i];
                  final isSeasonMatch =
                      prayer.season != null &&
                      currentSeason != null &&
                      prayer.season == currentSeason.name;
                  return _PrayerCard(
                    prayer: prayer,
                    isDark: isDark,
                    primary: primary,
                    isSeasonHighlight: isSeasonMatch,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ─── Time of Day Banner ──────────────────────────────────────────────────────
class _TimeBanner extends StatelessWidget {
  final bool isDark;
  final int hour;
  const _TimeBanner({required this.isDark, required this.hour});

  @override
  Widget build(BuildContext context) {
    final bool isMorning = hour < 12;
    final bool isEvening = hour >= 17;
    final Color bannerColor;
    final IconData icon;
    final String label;

    if (isMorning) {
      bannerColor = const Color(0xFFFF9800);
      icon = Icons.wb_sunny_rounded;
      label = 'Mu gitondo — Isengesho ryo mu gitondo';
    } else if (isEvening) {
      bannerColor = const Color(0xFF5C6BC0);
      icon = Icons.nightlight_round;
      label = 'Mu mugoroba — Isengesho ryo mu mugoroba';
    } else {
      bannerColor = const Color(0xFF26A69A);
      icon = Icons.wb_twilight_rounded;
      label = 'Ku manywa — Senga igihe icyo ari cyo cyose';
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            bannerColor.withValues(alpha: isDark ? 0.2 : 0.1),
            bannerColor.withValues(alpha: isDark ? 0.08 : 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bannerColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: bannerColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.lato(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: bannerColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Prayer Card ─────────────────────────────────────────────────────────────
class _PrayerCard extends StatelessWidget {
  final PrayerEntry prayer;
  final bool isDark;
  final Color primary;
  final bool isSeasonHighlight;
  const _PrayerCard({
    required this.prayer,
    required this.isDark,
    required this.primary,
    this.isSeasonHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isSeasonHighlight
        ? primary
        : (isDark ? const Color(0xFF3A3847) : Colors.grey.shade100);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252430) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: isSeasonHighlight ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getCategoryColor(prayer.category).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            _getIcon(prayer.category),
            size: 20,
            color: _getCategoryColor(prayer.category),
          ),
        ),
        title: Text(
          prayer.title,
          style: GoogleFonts.lato(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: isDark ? const Color(0xFFF0EDE8) : const Color(0xFF1A1A1A),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (prayer.titleEn.isNotEmpty)
              Text(
                prayer.titleEn,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.white38 : Colors.grey.shade500,
                ),
              ),
            if (isSeasonHighlight)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Igihe cy\'ubu',
                    style: GoogleFonts.lato(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: primary,
                    ),
                  ),
                ),
              ),
          ],
        ),
        children: [
          const Divider(height: 20),
          Text(
            prayer.text,
            style: GoogleFonts.notoSerif(
              fontSize: 15,
              height: 1.8,
              color: isDark ? const Color(0xFFF0EDE8) : const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () =>
                  Share.share('${prayer.title}\n\n${prayer.text}\n\n— LCR App'),
              icon: Icon(Icons.share_rounded, size: 16, color: primary),
              label: Text(
                'Sangira',
                style: TextStyle(fontSize: 12, color: primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String cat) {
    switch (cat) {
      case 'Mu Gitondo':
        return const Color(0xFFFF9800);
      case 'Mu Mugoroba':
        return const Color(0xFF5C6BC0);
      case 'Igihe cy\'Itorero':
        return const Color(0xFF7E57C2);
      case 'Kwicuza':
        return const Color(0xFF26A69A);
      case 'Gushimira':
        return const Color(0xFFE57373);
      case 'Uburindzi':
        return const Color(0xFF42A5F5);
      case 'Uburwayi':
        return const Color(0xFFEF5350);
      case 'Umuryango':
        return const Color(0xFF66BB6A);
      case 'Itorero':
        return const Color(0xFF7E57C2);
      case 'Kwiga':
        return const Color(0xFFFF7043);
      case 'Agahinda':
        return const Color(0xFF78909C);
      default:
        return const Color(0xFFE57373);
    }
  }

  IconData _getIcon(String cat) {
    switch (cat) {
      case 'Mu Gitondo':
        return Icons.wb_sunny_rounded;
      case 'Mu Mugoroba':
        return Icons.nightlight_round;
      case 'Igihe cy\'Itorero':
        return Icons.church_rounded;
      case 'Gushimira':
        return Icons.favorite_rounded;
      case 'Kwicuza':
        return Icons.auto_awesome_rounded;
      case 'Uburindzi':
        return Icons.security_rounded;
      case 'Uburwayi':
        return Icons.medical_services_rounded;
      case 'Umuryango':
        return Icons.family_restroom_rounded;
      case 'Itorero':
        return Icons.church_rounded;
      case 'Kwiga':
        return Icons.school_rounded;
      case 'Agahinda':
        return Icons.healing_rounded;
      default:
        return Icons.volunteer_activism_rounded;
    }
  }
}
