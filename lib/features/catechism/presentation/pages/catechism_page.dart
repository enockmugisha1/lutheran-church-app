import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lutheran/core/theme/app_theme.dart';
import 'package:share_plus/share_plus.dart';

// ─────────────────────────────────────────────
//  Catechism Data Models
// ─────────────────────────────────────────────
class CatechismSection {
  final String titleRw;
  final String titleEn;
  final IconData icon;
  final List<CatechismItem> items;
  const CatechismSection({
    required this.titleRw,
    required this.titleEn,
    required this.icon,
    required this.items,
  });
}

class CatechismItem {
  final String title;
  final String text;
  final String? explanation;
  const CatechismItem({
    required this.title,
    required this.text,
    this.explanation,
  });
}

// ─────────────────────────────────────────────
//  Luther's Small Catechism Data (Kinyarwanda)
// ─────────────────────────────────────────────
const _catechismSections = [
  // ── 1. The Ten Commandments ──
  CatechismSection(
    titleRw: 'Amategeko Icumi',
    titleEn: 'The Ten Commandments',
    icon: Icons.article_outlined,
    items: [
      CatechismItem(
        title: 'Itegeko rya Mbere',
        text: 'Ntuzagire izindi mana imbere yanjye.',
        explanation:
            'Tugomba gutinya Imana, tukayikunda kandi tukayiringira kurusha ibindi byose.',
      ),
      CatechismItem(
        title: 'Itegeko rya Kabiri',
        text: 'Ntuzifashishe izina ry\'Uwiteka Imana yawe nk\'ubusa.',
        explanation:
            'Tugomba gutinya no gukunda Imana ngo tudasebya, tudasengera iby\'ubusa, tudasinya, tugateshwa cyangwa tukayobya mu izina ryayo, ahubwo turizane mu ngorane zacu zose, dusengeshe kandi dutashimire.',
      ),
      CatechismItem(
        title: 'Itegeko rya Gatatu',
        text: 'Wibuke gukomeza umunsi w\'isabato.',
        explanation:
            'Tugomba gutinya no gukunda Imana ngo tutazirengagiza ijambo ryayo n\'imyigishirize, ahubwo turihere icyubahiro, turumve kandi turigire.',
      ),
      CatechismItem(
        title: 'Itegeko rya Kane',
        text: 'Wubahe papa wawe na mama wawe.',
        explanation:
            'Tugomba gutinya no gukunda Imana ngo tutazirengagiza ababyeyi bacu n\'abatuyobora, ahubwo tubaheshe icyubahiro, tubakoreshe, tubumve, tubakunde kandi tubaheshe icyubahiro.',
      ),
      CatechismItem(
        title: 'Itegeko rya Gatanu',
        text: 'Ntuzice.',
        explanation:
            'Tugomba gutinya no gukunda Imana ngo tutagirira nabi mugenzi wacu mu mubiri we, ahubwo tumufashe kandi tumwitereho mu makuba ye yose.',
      ),
      CatechismItem(
        title: 'Itegeko rya Gatandatu',
        text: 'Ntuzasambane.',
        explanation:
            'Tugomba gutinya no gukunda Imana ngo tube abera kandi b\'ingirakamaro mu magambo no mu bikorwa, maze umugabo n\'umugore bakunde kandi bahaneshe icyubahiro.',
      ),
      CatechismItem(
        title: 'Itegeko rya Karindwi',
        text: 'Ntuzibe.',
        explanation:
            'Tugomba gutinya no gukunda Imana ngo tutiganyire amafaranga cyangwa ibintu bya mugenzi wacu, ahubwo tumufashe kubika no kurinda ibintu bye.',
      ),
      CatechismItem(
        title: 'Itegeko rya Munani',
        text: 'Ntuzahamye mugenzi wawe.',
        explanation:
            'Tugomba gutinya no gukunda Imana ngo tutagambana mugenzi wacu ibinyoma, tukamurega, tukamubeshyera, cyangwa tukamusebya, ahubwo tumurengere, tuvuge ibyiza bimurenga kandi tworohereze ibintu byose neza.',
      ),
      CatechismItem(
        title: 'Itegeko rya Cyenda',
        text: 'Ntuzifuze inzu ya mugenzi wawe.',
        explanation:
            'Tugomba gutinya no gukunda Imana ngo tutagambirira kubeshya no gufata umurage wa mugenzi wacu, ahubwo tumufashe kubika ibintu bye.',
      ),
      CatechismItem(
        title: 'Itegeko rya Cumi',
        text:
            'Ntuzifuze umugore wa mugenzi wawe, cyangwa umugaragu we, cyangwa umuja we, cyangwa inka ye, cyangwa indogobe ye, cyangwa icyo afite cyose.',
        explanation:
            'Tugomba gutinya no gukunda Imana ngo tutashukira umugore wa mugenzi wacu, abagaragu be cyangwa amatungo ye, ahubwo tubakoreze ko baguma kandi bakora ibyo basabwa.',
      ),
    ],
  ),

  // ── 2. The Apostles' Creed ──
  CatechismSection(
    titleRw: 'Kwizera kwa Intumwa',
    titleEn: 'The Apostles\' Creed',
    icon: Icons.church_outlined,
    items: [
      CatechismItem(
        title: 'Igice cya Mbere: Irema',
        text: 'Nizera Imana, Data Ushoborabyose, Umuremyi w\'ijuru n\'isi.',
        explanation:
            'Nizera ko Imana yaremye njye hamwe n\'ibiremwa byose, ko yampaye umubiri n\'ubugingo, amaso, amatwi n\'ingingo zose, ubwenge n\'amarangamutima yose; kandi ko azaguma ampindagira, imyambaro n\'inkweto, ibiryo n\'ibinyobwa, inzu n\'urugo, umugore n\'abana, imirima, amatungo n\'ibintu byose nkeneye; ko ampa ibintu byose byo ku mubiri no mu bugingo kandi akanturinda ibibi n\'ingorane. Ibyo byose kubw\'ubuntu n\'impuhwe ze gusa, nta giciro cyangwa agaciro kanjye, kandi ibyo byose ari byo ngomba kumushimira no kumuhimbaza, kumukoresha no kumusingiza.',
      ),
      CatechismItem(
        title: 'Igice cya Kabiri: Ugucungurwa',
        text:
            'Kandi nizera Yesu Kristo, Umwana we w\'ikinege, Umwami wacu; wasamwe na Mwuka Wera, wavutse na Bikira Mariya; wababazwe n\'u Ponsyo Pilato, wabambwe ku musaraba, arapfa, ashyingurwa; amanuka mu kuzimu; ku munsi wa gatatu azuka mu bapfuye; arazamuka ajya mu ijuru, yicara iburyo bw\'Imana Data Ushoborabyose; aho niho azava kuza gucira urubanza abazima n\'abapfuye.',
        explanation:
            'Nizera ko Yesu Kristo, Imana yavutse na Data igihe cy\'iteka, kandi ari n\'umuntu nyawe wavutse na Bikira Mariya, ari Umwami wanjye; wancunguye njye, umuntu w\'umucumuzi wanditswe n\'urupfu, antekura mu byaha byose, urupfu n\'ubushobozi bwa Satani — atari amareza cyangwa zahabu, ahubwo amaraso ye y\'agaciro n\'ijambo ryugirurutse — kugira ngo mbe uwundi, nkore ibyo Imana ishaka nkiri mu isi hanyuma nzabone ubugingo buhoraho. Ibyo ni ukuri nyakuri.',
      ),
      CatechismItem(
        title: 'Igice cya Gatatu: Kwezwa',
        text:
            'Nizera Mwuka Wera; Itorero Ryera rya Gikristu, ubusabane bw\'abera; imbabazi z\'ibyaha; kuzuka kw\'umubiri; n\'ubugingo buhoraho. Amina.',
        explanation:
            'Nizera ko ntashobora kwizera Yesu Kristo, Umwami wanjye, cyangwa ngo mze kuri We ku bwanjye bwite; ahubwo Mwuka Wera yampamagaye mu butumwa bwiza, yandumurishije impano ze, yanyerekanye kandi yangumishije mu kwizera kwukuri. Mu buryo bumwe, ahamagara, yohereza, yumurisha kandi yeza Itorero ryose hano ku isi kandi arigumishiriza muri Yesu Kristo mu kwizera kumwe kw\'ukuri.',
      ),
    ],
  ),

  // ── 3. The Lord's Prayer ──
  CatechismSection(
    titleRw: 'Isengesho rya Data',
    titleEn: 'The Lord\'s Prayer',
    icon: Icons.volunteer_activism_outlined,
    items: [
      CatechismItem(
        title: 'Intangiriro',
        text: 'Data wacu uri mu ijuru,',
        explanation:
            'Imana ishaka kudushishikariza gutya ko twemere ko ari yo Data wacu koko, n\'uko turiya bana bayo koko, ngo dusenge twizeye nta kumuka, nk\'uko abana bakunda bakoresha ba se.',
      ),
      CatechismItem(
        title: 'Isabo rya Mbere',
        text: 'Izina ryawe ryubahwe.',
        explanation:
            'Izina ry\'Imana rirekobera ryera, ariko dusaba ngo natwe turyubahishe.',
      ),
      CatechismItem(
        title: 'Isabo rya Kabiri',
        text: 'Ubwami bwawe buze.',
        explanation:
            'Ubwami bw\'Imana buzana ubwabwo, ntabwo dukeneye kubusengera; ariko dusaba ngo butuzire.',
      ),
      CatechismItem(
        title: 'Isabo rya Gatatu',
        text: 'Ubushake bwawe bukorwe mu isi nk\'uko bukorwa mu ijuru.',
        explanation:
            'Ubushake bwiza bw\'Imana bukorwa natwe tutabusengera; ariko dusaba ngo bukorwe natwe.',
      ),
      CatechismItem(
        title: 'Isabo rya Kane',
        text: 'Uduhe uyu munsi ibyokurya byacu bya buri munsi.',
        explanation:
            'Imana itanga ibyokurya bya buri munsi nta n\'isengero ryacu; ariko dusaba ngo itwemeze kubimenya no kubikira ishimwe.',
      ),
      CatechismItem(
        title: 'Isabo rya Gatanu',
        text:
            'Utubabarire ibicumuro byacu, nk\'uko natwe tubabarira ababicumura.',
        explanation:
            'Dusaba muri iri sabo ngo Data wo mu ijuru atarebesha amaso ibyaha byacu, kandi adakwiye kutwima ibyo dusaba kubera ibyo, kuko tutabibereye icyo dusaba; ahubwo ko yabiduhera ku bw\'ubuntu, nubwo turi abacumuzi bakomeye.',
      ),
      CatechismItem(
        title: 'Isabo rya Gatandatu',
        text: 'Ntudushyire mu bishuko.',
        explanation:
            'Imana ntibigeza umuntu; ariko dusaba ngo Imana idurinde kandi idukize, kugira ngo Satani, isi n\'umubiri wacu bitatudindiza mu kwizera kwacu.',
      ),
      CatechismItem(
        title: 'Isabo rya Karindwi',
        text: 'Ahubwo udukize ikibi. Amina.',
        explanation:
            'Dusaba muri iri sabo ngo Data wo mu ijuru adukize ibibi byose byo ku mubiri, ubugingo, ibintu n\'icyubahiro.',
      ),
    ],
  ),

  // ── 4. Holy Baptism ──
  CatechismSection(
    titleRw: 'Ubatizo Wera',
    titleEn: 'Holy Baptism',
    icon: Icons.water_drop_outlined,
    items: [
      CatechismItem(
        title: 'Ubatizo ni iki?',
        text:
            'Ubatizo si amazi gusa, ahubwo ni amazi akoreshwa mu itegeko ry\'Imana kandi ahuriyeho n\'ijambo ry\'Imana.',
        explanation:
            'Kristo Umwami wacu yavuze ati: "Nimujye mu mahanga yose, mubigishe, mubabatize mu izina rya Data na Mwana na Mwuka Wera." (Matayo 28:19)',
      ),
      CatechismItem(
        title: 'Ubatizo utanga iki?',
        text:
            'Uduha imbabazi z\'ibyaha, udukiza urupfu na Satani, kandi utanga ubugingo buhoraho abizera byose, nk\'uko amagambo n\'amasezerano y\'Imana abiteganya.',
        explanation:
            '"Uwizera kandi akabatizwa azakizwa; ariko utizera azacirwa urubanza." (Mariko 16:16)',
      ),
      CatechismItem(
        title: 'Amazi ashobora ate gukora ibyo bintu bikomeye?',
        text:
            'Si amazi gusa akora ibintu, ahubwo ni ijambo ry\'Imana riri mu mazi kandi ririmo. Kuko amazi adafite ijambo ry\'Imana ari amazi gusa, ntabwo ari ubatizo; ariko hamwe n\'ijambo ry\'Imana aba ari ubatizo koko.',
      ),
    ],
  ),

  // ── 5. Holy Communion ──
  CatechismSection(
    titleRw: 'Isakramentu Yera',
    titleEn: 'The Sacrament of the Altar (Holy Communion)',
    icon: Icons.local_bar_outlined,
    items: [
      CatechismItem(
        title: 'Isakramentu y\'Altari ni iki?',
        text:
            'Ni umubiri nyawe n\'amaraso ya Yesu Kristo Umwami wacu, mu cyangwa munsi ya umugati n\'umuvinyo, yagenwe na Kristo ubwe kugira ngo turye tunywe, twe abakristu.',
        explanation:
            'Umwami wacu Yesu Kristo, mu ijoro yakiranurwamo, yafashe umugati, amaze gushimira, awumanyura, awuha abigishwa be ababwira ati: "Nimufate murye; uyu ni umubiri wanjye." Yafashe n\'igikombe, amaze gushimira, akibaha ababwira ati: "Nimunywe mwese kuri iki; iki ni amaraso yanjye y\'isezerano rishya, ameserwa benshi ngo bababarirwe ibyaha. Mujye mubikora, uko mubikoze kwibuka njye."',
      ),
      CatechismItem(
        title: 'Kurya no kunywa bishobora bite gukora ibintu bikomeye?',
        text:
            'Kurya no kunywa gusa ntibikora ibintu, ahubwo amagambo ari aha: "Bimeserwemo ngo bababarirwe ibyaha." Aya magambo hamwe no kurya no kunywa ni ingenzi muri Isakramentu; kandi uwemera ayo magambo afite ibyo avuga koko, ni ukuvuga imbabazi z\'ibyaha.',
      ),
      CatechismItem(
        title: 'Ni nde ukwiriye kwakira Isakramentu?',
        text:
            'Gusiba no kwambara ibimenyo birategurira umubiri neza; ariko ni uwizera aya magambo: "Bimeserwemo ngo bababarirwe ibyaha" ni we ukwiye koko kandi aba ateguye neza. Ariko utemera cyangwa akekeranya ntakwiye, kuko ijambo "ngo mwe" risaba imitima yizera.',
      ),
    ],
  ),

  // ── 6. Confession & Absolution ──
  CatechismSection(
    titleRw: 'Kwatura no Guhabwa Imbabazi',
    titleEn: 'Confession & Absolution',
    icon: Icons.spa_outlined,
    items: [
      CatechismItem(
        title: 'Kwatura ni iki?',
        text:
            'Kwatura birimo ibice bibiri: icya mbere ni uko twatura ibyaha byacu, icya kabiri ni uko twakira imbabazi z\'umucumuzi nk\'izo Imana yatanze, twizere ko ibyaha byacu bibabarirwa mu izina rya Kristo.',
      ),
      CatechismItem(
        title: 'Ni ayahe mahaha tugomba kwatura?',
        text:
            'Imbere y\'Imana tugomba kwemera ko turi abacumuzi mu byo twese kandi ko tutaruzuza n\'itegeko rimwe gusa nk\'uko bikwiye.',
        explanation:
            'Ariko imbere y\'umucumuzi tugomba kwatura ibyaha twiziko kandi biduhangayikishije imitima.',
      ),
    ],
  ),

  // ── 7. Daily Prayers ──
  CatechismSection(
    titleRw: 'Amasengesho ya Buri Munsi',
    titleEn: 'Daily Prayers',
    icon: Icons.wb_sunny_outlined,
    items: [
      CatechismItem(
        title: 'Isengesho ryo mu Gitondo',
        text:
            'Mu izina rya Data na Mwana na Mwuka Wera. Amina.\n\nNdagushimira, Data wanjye wo mu ijuru, ku bwa Yesu Kristo, Umwana wawe mukundwa, ko wanyirindiye muri iri joro ibyago n\'ibibi byose, kandi ngusaba ngo undinde no kuri uyu munsi ibyaha n\'ibibi byose, kugira ngo ibyo nkora byose n\'ubuzima bwanjye bikushimishe. Kuko nibigushiriye mu maboko yawe, umubiri wanjye n\'ubugingo bwanjye n\'ibintu byanjye byose. Nuzinduke umulinde wanjye kugira ngo umwanzi mubi adatera ku bwanjye. Amina.',
      ),
      CatechismItem(
        title: 'Isengesho ryo mu Mugoroba',
        text:
            'Mu izina rya Data na Mwana na Mwuka Wera. Amina.\n\nNdagushimira, Data wanjye wo mu ijuru, ku bwa Yesu Kristo, Umwana wawe mukundwa, ko wanyirindiye kuri uyu munsi ibyago byose, kandi ngusaba ngo unbabarire ibyaha byanjye byose nkoreye uyu munsi, kandi unyirindire muri iri joro. Kuko nibigushiriye mu maboko yawe, umubiri wanjye n\'ubugingo bwanjye n\'ibintu byanjye byose. Umulinde wawe wera arindishure. Amina.',
      ),
      CatechismItem(
        title: 'Ishimwe ry\'Ibyo Kurya',
        text:
            'Amaso yose akureba, kandi ubaha ibyokurya byabo mu gihe cyabo. Urabumbura ikiganza cyawe, uhaze ibizima byose ibyo bifuza.\n\nMwami Imana, Data wo mu ijuru, duha umugisha natwe n\'izi mpano zawe duhabwa mu buntu bwawe, ku bwa Yesu Kristo Umwami wacu. Amina.',
      ),
    ],
  ),

  // ── 8. Table of Duties ──
  CatechismSection(
    titleRw: 'Imbonerahamwe y\'Inshingano',
    titleEn: 'Table of Duties',
    icon: Icons.checklist_outlined,
    items: [
      CatechismItem(
        title: 'Ku Babishopu, Abashumba n\'Abigisha',
        text:
            '"Ni ngombwa ko umubishopu aba umuntu utariho umugayo, umugabo w\'umugore umwe, uzi kwifata, ufite uburenganzira, ukundisha abashyitsi, ushobora kwigisha." (1 Tim. 3:2)',
      ),
      CatechismItem(
        title: 'Ku Bakristu bose mu Bikorwa',
        text:
            '"Buri wese yumvire abatware bamutegeka." (Rom. 13:1)\n\n"Utanga, atange mu mutima utaryarya; uyobora, ayobore adahwema; ugirira impuhwe, azigire anezerewe." (Rom. 12:8)',
      ),
      CatechismItem(
        title: 'Ku Babyeyi',
        text:
            '"Namwe ba se, ntimukarakaze abana banyu, ahubwo mubakuze mu kubacyaha no kubahugura mu by\'Umwami." (Efe. 6:4)',
      ),
      CatechismItem(
        title: 'Ku Bana',
        text:
            '"Bana banyu, ni mwumvire ababyeyi banyu muri Umwami, kuko ari byo bikwiye. Wubahe papa wawe na mama wawe—iri ni ryo tegeko rya mbere ririmo isezerano—kugira ngo ubone ibyiza kandi urambe mu isi." (Efe. 6:1-3)',
      ),
    ],
  ),
];

// ─────────────────────────────────────────────
//  Catechism List Page
// ─────────────────────────────────────────────
class CatechismPage extends StatelessWidget {
  const CatechismPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Catechism Ntoya'), elevation: 0),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: AppTheme.maroonGradient,
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Catechism Ntoya ya Luteri',
                  style: GoogleFonts.cinzel(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Luther\'s Small Catechism',
                  style: GoogleFonts.lato(color: Colors.white60, fontSize: 13),
                ),
                const SizedBox(height: 12),
                Text(
                  'Ibice by\'ingenzi by\'inyigisho ya Gikristu nk\'uko byanditswe na Martin Luther kugira ngo bifashe buri mukristu gusobanukirwa ukwizera kwe.',
                  style: GoogleFonts.lato(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Sections list
          ..._catechismSections.map(
            (section) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _CatechismSectionCard(
                section: section,
                isDark: isDark,
                primary: primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CatechismSectionCard extends StatelessWidget {
  final CatechismSection section;
  final bool isDark;
  final Color primary;

  const _CatechismSectionCard({
    required this.section,
    required this.isDark,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CatechismDetailPage(section: section),
          ),
        ),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.gold.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.gold.withValues(alpha: 0.3)),
          ),
          child: Center(
            child: Icon(section.icon, size: 22, color: AppTheme.gold),
          ),
        ),
        title: Text(
          section.titleRw,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          section.titleEn,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.maroon.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${section.items.length}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppTheme.maroon,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Catechism Detail Page
// ─────────────────────────────────────────────
class CatechismDetailPage extends StatelessWidget {
  final CatechismSection section;
  const CatechismDetailPage({super.key, required this.section});

  String _buildShareText() {
    final buf = StringBuffer();
    buf.writeln('${section.titleRw} (${section.titleEn})');
    buf.writeln('━' * 30);
    for (final item in section.items) {
      buf.writeln('\n${item.title}');
      buf.writeln(item.text);
      if (item.explanation != null) {
        buf.writeln('\nIbisobanuro: ${item.explanation}');
      }
    }
    buf.writeln('\n— Catechism Ntoya ya Luteri');
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(section.titleRw),
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
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: AppTheme.maroonGradient,
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.gold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(section.icon, size: 26, color: AppTheme.gold),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        section.titleRw,
                        style: GoogleFonts.cinzel(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        section.titleEn,
                        style: GoogleFonts.lato(
                          color: Colors.white60,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Items
          ...List.generate(section.items.length, (i) {
            final item = section.items[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _CatechismItemCard(
                item: item,
                index: i + 1,
                isDark: isDark,
                primary: primary,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _CatechismItemCard extends StatelessWidget {
  final CatechismItem item;
  final int index;
  final bool isDark;
  final Color primary;

  const _CatechismItemCard({
    required this.item,
    required this.index,
    required this.isDark,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? const Color(0xFF252430) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: isDark ? 0.15 : 0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '$index',
                      style: GoogleFonts.cinzel(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.title,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main text
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              item.text,
              style: GoogleFonts.notoSerif(
                fontSize: 15,
                height: 1.8,
                color: isDark
                    ? const Color(0xFFF0EDE8)
                    : const Color(0xFF1A1A1A),
              ),
            ),
          ),

          // Explanation
          if (item.explanation != null) ...[
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1A1930)
                    : const Color(0xFFFDF9F0),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF3A3847)
                      : const Color(0xFFE8E0D0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline_rounded,
                        size: 16,
                        color: const Color(0xFFB5942A),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'IBISOBANURO',
                        style: GoogleFonts.lato(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFFB5942A),
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.explanation!,
                    style: GoogleFonts.lato(
                      fontSize: 13.5,
                      height: 1.7,
                      fontStyle: FontStyle.italic,
                      color: isDark
                          ? const Color(0xFFD0CDCB)
                          : const Color(0xFF4A4540),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
