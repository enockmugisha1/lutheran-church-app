import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lutheran/core/data/hymns_data.dart';

const _maroon    = Color(0xFF4A1028);
const _darkMaroon = Color(0xFF2A0818);
const _gold      = Color(0xFFC9A84C);
const _lightGold = Color(0xFFFFF8E7);

// ─── Responsive helpers ───────────────────────────────────────────────────────
// Scale a value relative to a 390-dp baseline (mid-range Android/Samsung).
// Clamped so tiny screens (≤320 dp) and huge screens (≥480 dp) don't go wild.
double _r(BuildContext ctx, double base) {
  final sw = MediaQuery.of(ctx).size.width;
  return (base * (sw / 390)).clamp(base * 0.80, base * 1.18);
}

// Responsive horizontal page padding.
double _hpad(BuildContext ctx) {
  final sw = MediaQuery.of(ctx).size.width;
  if (sw < 360) return 10.0;
  if (sw > 430) return 20.0;
  return 14.0;
}

// Responsive font size — scales with screen width.
double _fs(BuildContext ctx, double base) => _r(ctx, base);

final RegExp _hymnRefRegex = RegExp(
  r'(?:\bTI\b|\bIndirimbo(?:\s+yo)?(?:\s+ya)?\b)\D*(\d{1,3})',
  caseSensitive: false,
);

Hymn? _hymnFromNote(String text) {
  final match = _hymnRefRegex.firstMatch(text);
  if (match == null) return null;
  final hymnNo = int.tryParse(match.group(1) ?? '');
  if (hymnNo == null) return null;
  return hymnByNumber(hymnNo);
}

int? _hymnNumberFromText(String text) {
  final match = _hymnRefRegex.firstMatch(text);
  if (match == null) return null;
  return int.tryParse(match.group(1) ?? '');
}

List<Hymn> _collectPartHymns(List<_Sec> sections) {
  final collected = <Hymn>[];
  final seen = <int>{};

  for (final sec in sections) {
    for (final line in sec.lines) {
      final hymnNo = _hymnNumberFromText(line.text);
      if (hymnNo == null || seen.contains(hymnNo)) continue;
      final hymn = hymnByNumber(hymnNo);
      if (hymn == null) continue;
      seen.add(hymnNo);
      collected.add(hymn);
    }
  }

  return collected;
}

// Ordination-document hymn title overrides (keyed by TI number).
// Used when the app's hymns_data.dart title does not match the ceremony hymnal.
const Map<int, String> _ordinationHymnTitles = {
  84: "Duhimbaz'Uwiteka Imana",
  45: "Impano Yacu Iva Mw'Ijuru",
  47: "Kurobanurwa Kwejejwe",
  99: "Nimweger' Umwami",
  130: "Nishimiye ko Data wa Twese",
};

// Full lyrics for every hymn used in the ordination ceremony, keyed by TI number.
// Applied as fallback when hymns_data.dart has no verses, and as override when
// the stored verses belong to a different song.
const Map<int, String> _ordDocFallbackLyrics = {
  84:
      "1. Duhimbaz'Uwiteka Imana no kuyisenga,\n"
      "   Kuko ariyo yaremye ibyo mw'isi n'ibyijuru,\n"
      "   Yesu Mwami, wez'imitima yacu,\n"
      "   Ngo turirimbir'Imana.\n\n"
      "2. Duhimbaz'Uwiteka Imana no kuyisenga,\n"
      "   Kuko ijy'itegeka neza mu bihugu byose,\n"
      "   Izaduh'ibidukwiriye byose,\n"
      "   Twizer'iri jambo ryayo.\n\n"
      "3. Duhimbaz'Uwiteka Imana no kuyisenga,\n"
      "   Yaraturemye niyo yaduhay'ubugingo,\n"
      "   Iturinda mu byago byacu byose,\n"
      "   Niy'itugirir'ubuntu.\n\n"
      "4. Duhimbaz'Uwiteka Imana no kuyisenga,\n"
      "   Ibihumeka byose bishim'izina ryayo,\n"
      "   Tuyikunde, kukw'ar'umucyo wacu,\n"
      "   Tuyisabe iminsi yose.",

  45:
      "1. Impano yacu iva mw'ijuru, Umwuka Wera w'Imana,\n"
      "   Ngwino umurike mu mwi'jima, tumenyereye kubamo,\n"
      "   Uri umucyo uva mu ijuru, murikir'imitima yacu.\n\n"
      "2. Impano yacu iva mu ijuru, niyo mazi y'ubugingo,\n"
      "   Aturuka ahera cyane, amar'inyot'abizera,\n"
      "   Ngwin'uduhembur'imitima, utwiher'ubugingo bushya.\n\n"
      "3. Impano yacu iva mu ijuru, Umwuka Wera w'Imana,\n"
      "   Manukira nu bantu bawe, uduh'ubususurike,\n"
      "   Tuyoboz'imbaraga zawe, uduhe n'urukindo rwawe.",

  47:
      "1. Kurobanurwa kwejejwe, guturuka ku Mana,\n"
      "   Kukw'Ijambo ryayo ryera, ryifitiy'ubutware,\n"
      "   Yadutegetse kwigisha, no kuyobora abemeye,\n"
      "   Gukurikira Yesu.\n\n"
      "2. Ibisarurwa ni byinshi, abakozi ni bake,\n"
      "   Umuh'imbaraga zawe, zituruka mu ijuru,\n"
      "   Akore muburyo bwose, aruwo kwizerwa rwose,\n"
      "   Asohoz'umurimo.\n\n"
      "3. Kandi azajy'akumvira, kuruta abantu b'isi,\n"
      "   Asobanurir'abantu, amategeko yawe,\n"
      "   Kandi nubwo yababazwa, ntaziger'acik'intege,\n"
      "   Akomez'umurego.\n\n"
      "4. Azajye yirinda wubwe, kwic'itegeko ryawe,\n"
      "   Nkukw'abakozi b'Imana, bakwiriye kwitwara,\n"
      "   Byaba bibabaje cyane, ababerey'ikigusha,\n"
      "   Aho kubayobora.\n\n"
      "5. Umurinde kugendera, mu nzira z'umwijima,\n"
      "   Ubwibone n'ubugome, urwango n'umujinya,\n"
      "   Azabitsind'abihashye, abe nk'umushumba koko,\n"
      "   Uragiriye Umwami.",

  99:
      "1. Nimweger' Umwami, muze tumuramye,\n"
      "   Tumwubahe mubikorwa,\n"
      "   Ari kumwe natwe, tumuteg'amatwi,\n"
      "   Twumv'Ijambo ry'agakiza.\n"
      "   Abizera mwese muzan'imitima,\n"
      "   Umuh'amaturo.\n\n"
      "2. Nimweger' Umwami, nyir'icyubahiro,\n"
      "   Asingizw'ibihe byose.\n"
      "   N'abamarayika, bose baririmbe,\n"
      "   Ikuzo ry'Imana yera,\n"
      "   Twemere, Mukiza, tukuririmbire,\n"
      "   Natwe abadakwiye.\n\n"
      "3. Nimwitandukanye, n'amagambo y'isi,\n"
      "   Niby'idushukisha byose.\n"
      "   Ibyifuzo byacu, n'urukundo rwacu,\n"
      "   Bikwerekereho mwami.\n"
      "   Ni wowe, wenyine, ukwiye gushimwa,\n"
      "   Nibyaremwe byose.\n\n"
      "4. Imitima yacu, turayigutuye,\n"
      "   Uyibem'iteka ryose.\n"
      "   Ur'umwami wacu, udufashe natwe,\n"
      "   Tugukund'iminsi yose.\n"
      "   Twibere, abawe, maz'ubane natwe,\n"
      "   Tujye tukuramya.",

  130:
      "Korari / Chorus:\n"
      "   Nishimiye ko Yes' ankunda,\n"
      "   Arankunda! Arankunda!\n"
      "   Nishimiye ko Yes'ankunda!\n"
      "   Nubwo ntakwiriye.\n\n"
      "1. Nishimiye ko Data wa twese,\n"
      "   Yandikishij'iby'urukundo rwe,\n"
      "   Mu byiz'Imana yavuze byose,\n"
      "   Nta kirut'iki ko Yes'ankunda.\n\n"
      "2. Kandi iyo nyobye, nkamushavuza,\n"
      "   Ntareka kunkunda ntakwiriye,\n"
      "   Kand'ikinsubiz'aho Yes'ari,\n"
      "   Cyane n'ukwibuk'urukundo rwe.\n\n"
      "3. Ni ndeb'ubwiza bwe bwo mw'ijuru,\n"
      "   Nzajya ndirimb'ik'iteka ryose,\n"
      "   Nzajya mubaza ndirimba ntya nti:\n"
      "   Yesu n'iki cyakunkundishije.\n\n"
      "4. Kand'urukundo ni rwo rwazanye,\n"
      "   Yesu kunshunguz'urupfu rubi,\n"
      "   Kukw'arankunda ndabizi neza,\n"
      "   Nanjye ndamukunda ndamushima.",
};

// ─── Local data classes ───────────────────────────────────────────────────────

class _Line {
  final String role;
  final String text;
  const _Line(this.role, this.text);
}

class _Sec {
  final String title;
  final List<_Line> lines;
  const _Sec(this.title, this.lines);
}

// ─── IGICE I: Kurobanura Abashumba ───────────────────────────────────────────

const _part1 = <_Sec>[
  _Sec('ABAFITE INSHINGANO', <_Line>[
    _Line(
      'Info',
      '✦ Musenyeri Uyobora Umuhango: Rt. Rev. Bishop Dr. Fredrick Onael Shoo',
    ),
    _Line(
      'Info',
      '✦ Abarobanurwa: Shemasi MUKUNZI Reminant · Shemasi RURANGIRWA Emmanuel · Shemasi NDAYISHIMIYE Noel',
    ),
    _Line('Info', '✦ Uyobora Liturgiya: Dean Rev. Dr. Ntidendereza David'),
    _Line(
      'Info',
      '✦ Ufasha Musenyeri: Rt. Rev. Prince A. Kalisa – Bishop Elect',
    ),
    _Line(
      'Info',
      '✦ Kwerekana Abarobanurwa: Umunyamabanga Mukuru Rev. Musafiri Jackson',
    ),
    _Line(
      'Info',
      '✦ Utwara Umusaraba: Deaconess kuva muri serivisi y\'Icyongereza',
    ),
  ]),
  _Sec('AKARASISI (PROCESSION)', <_Line>[
    _Line(
      'Note',
      'Utwara umusaraba (imbere), abakorari, abakiristo, Abavugabutumwa, Abashumba, Abashumba b\'intara, Abarobanurwa, Dean, Elect Bishop, Madam Roe Rose Mbise, Rev. Dr. Samuel Dawai, Em. Bishop Mugabo Evalister, Bishop George Wilson Kalisa, Rt. Rev. Bishop Victor Bwanangera Kambuli Kikagu, Rt. Rev. Bishop Dr. Fredrick Onael Shoo.',
    ),
  ]),
  _Sec('GUTANGIRA AMATERANIRO', <_Line>[
    _Line(
      'Musenyeri',
      'Mu izina rya Data wa twese n\'Umwana, n\'Umwuka Wera + Amina.',
    ),
    _Line('Note', 'Indirimbo ya 84 muri Turirimbir\'Imana'),
    _Line(
      'Uyoboye Liturgiya',
      'Mucishe bugufi imitima yanyu twaturire Imana ibyaha byacu.',
    ),
    _Line(
      'Bose',
      'Mana ishobora byose, Data wa twese w\'imbabazi nyinshi, jyewe umunyantege nke n\'umunyabyaha, ndicuza imbere yawe ibicumuro byose nakoze mubitekerezo, mu magambo no mubikorwa. Kuko ntahwema kukubabaza nkwiriye igihano cy\'iteka. Ariko ibyaha byange byose ndabyatuye kandi mbyihannye byukuri. Ndakwinginze kubw\'ubuntu bwawe bwinshi ungirire imbabazi, unkize, umpe Umwuka wawe Wera ngire imyifatire mishya. Amina.',
    ),
    _Line(
      'Musenyeri',
      'Niba mwihannye by\'ukuri kandi musaba imbabazi z\'ibyaha byanyu mubikuye kumutima, kubw\'ububasha bw\'Ijambo rye, n\'itegeko rye, ndabamenyesha yuko Imana kubw\'ubuntu bwayo ibababariye ibyaha byanyu byose mu izina rya Data wa twese n\'Umwana, n\'Umwuka Wera + Amina.',
    ),
    _Line('Note', 'Korari'),
  ]),
  _Sec('KWEREKANA ABAROBANURWA', <_Line>[
    _Line(
      'Umunyamabanga Mukuru',
      'Agaragaze abo Itorero ry\'Abalutheri ry\'u Rwanda (LCR) biciye mu nama zabibifite munshingano zazo bemereye ko barobanurirwa ubushumba — bamaze kugenzura umuhamagaro wabo, ubushacye, amashuri, ndetse n\'imyitozo bakoze, hiyongereyeho imyirondoro yabo migufi.',
    ),
    _Line(
      'Musenyeri',
      'Dusenge: Mana ishobora byose kandi ihoraho, ise w\'umwami wacu Yesu Kristo. Turakwinginze ngo utwigishe gusaba neza kugirango tubone abakozi mubisarurwa byawe. Kubw\'ubuntu bwawe uduhe abashumba beza, maze ushyire amagambo yawe mu kanwa kabo. Aba bagaragu bawe ubahe kwirinda ubwabo no kurinda inyigisho z\'itorero ryawe basohoza amabwiriza yawe nkabizerwa. Mana Ijambo ryawe rihore muri bo, ryere imbuto nyinsho. Batange ubuhamya nkuko bikwiriye abakozi bawe kugirango itorero ryawe ryubakwe murubwo buryo, rikorere abantu bose mukwizera gukomeye, kandi rihore rikumenya ubwawe muri Yesu Kristo Umwami wacu. Amina.',
    ),
    _Line(
      'Musenyeri',
      'Avuge amazina yabarobanurwa — ubwo mwahamagariwe kwinjira muruyu murimo wejejwe w\'ubushumba, reka dufatanye kumva ubuziranenge bwuyu muhamagaro, twumve impanuro n\'amasezerano y\'Ijambo ry\'Imana.',
    ),
  ]),
  _Sec('IBICE BY\'IJAMBO RY\'IMANA (12)', <_Line>[
    _Line(
      'Note',
      'Mat. 28:19-20  ·  1.Pet. 5:2-4  ·  Yn. 15:12-13, 16  ·  Efe. 4:11-13  ·  Lk. 17:7-10  ·  2Tim. 2:1-5  ·  Yn. 20:21-23  ·  Mat. 10:7-8, 19-20  ·  Yn. 21:15-17  ·  Mk. 10:43b-45  ·  1Kor. 4:1-2  ·  2.Tim. 4:1-2',
    ),
    _Line(
      'Info',
      'Abasoma ibice: Rev. Mugambage Pascal · Rev. Mulisa Emmanuel · Rev. Muteteri Henarriet · Rev. Nyundo Nathanael · Rev. Mukama Eddy Santos · Rev. Manirarora Emmanuel · Rev. Twesige George · Rev. Hagumubuzima Seth · Rev. Kagorora John · Rev. Makara Edward · Rev. Sekamana Jean Claude · Rev. Rutayisire Tharsis',
    ),
    _Line(
      'Musenyeri',
      'Uwiteka abagirire ubuntu mushobore kubika aya amagambo mumitima yanyu. Abe umugenga wo kubaho kwanyu ajye ahora abibutsa inshingano zanyu, abongerere umwete wo gusenga muhore mwizeye kubwuyu murimo mwahamagariwe n\'umushumba mukuru. Musenge cyane mwizeye mw\'Izina rya Yesu. Musabe Imana ibuzuze ubuntu n\'imbaraga, mugaragaze mumagambo no mubikorwa yuko muri abakozi b\'Imana koko. Imana ibafashe kurwanya intambara yo kwizera maze muhabwe ubugingo bw\'iteka mwahamagariwe.',
    ),
    _Line('Note', 'Korari'),
  ]),
  _Sec('KWEMERA KW\'INTUMWA', <_Line>[
    _Line(
      'Musenyeri',
      'Ngaho vugira imbere y\'Imana, n\'imbere yiri teraniro kwemera kwawe ari nako kwemera kw\'intumwa.',
    ),
    _Line(
      'Abarobanurwa',
      'Nemera Imana Data wa Twese ushobora byose, umuremyi w\'juru n\'isi, nemera Yesu Kristo Umwana we w\'ikinege umwami wacu. Wasamwe inda kubw\'Umwuka Wera, akabyarwa n\'umwari Mariya, akababazwa ku ngoma ya Pontiyo Pilato, akabambwa kumusaraba, agapfa, agahambwa, akamanuka ikuzimu mu bapfuye, ku munsi wa gatatu akazuka, akajya mw\'ijuru, yicaye uburyo bw\'Imana Data wa twese ushobora byose, niho azava ajye gucira imanza abazima nabapfuye. Nemera Umwuka Wera, Itorero rimwe ry\'abera bose, ubumwe bw\'abera, kubabarirwa ibyaha, kuzuka kw\'umubiri, n\'ubugingo budashira. Amina.',
    ),
    _Line(
      'Musenyeri',
      'Imana kubwubuntu bwayo ibashoboze guhagararara muruko kwizera kugeza kumperuka. Kandi nabene Data babakriisto ukubakomerezemo, ndetse nabataribo ubazane muruko kwizera.',
    ),
    _Line('Note', 'Korari'),
  ]),
  _Sec('IBIBAZO BY\'INDAHIRO Y\'UBUSHUMBA', <_Line>[
    _Line(
      'Musenyeri',
      'Imbere y\'Imana n\'imbere yiri teraniro ndakubaza nti; uremera kwakira no gukora umurimo wejejwe w\'ubushumba mu izina rya Data wa twese, n\'Umwana, n\'Umwuka Wera; wihatira kuwusohoza muri byose kugirango icyubahiro cy\'Imana kigaragare maze abantu bakizwe?',
    ),
    _Line('Urobanurwa', 'YEGO NDABYEMEYE.'),
    _Line(
      'Musenyeri',
      'Uremera kubwiriza neza ubutumwa bwiza nkuko buri mubyanditswe byera, gutanga amasakaramentu (umubatizo n\'ifunguro ryera) nkuko itorero LCR ribihamya mu myemerere yaryo?',
    ),
    _Line('Urobanurwa', 'YEGO NDABYEMEYE.'),
    _Line(
      'Musenyeri',
      'Uremera gukorera itorero LCR mu rukundo no mubwizerwa ushishikariza abantu gukomera mukwizera umwami wacu Yesu Kristo? Uremera gufasha abakene, gusura abarwayi, n\'abatishoboye, guhumuriza abababaye, ubayobora mu nzira ya gikiristo, kandi uremera ko uzashaka intama zazimiye, izavunitse ukazunga, izikomeretse ukazomora?',
    ),
    _Line('Urobanurwa', 'YEGO NDABYEMEYE.'),
    _Line(
      'Musenyeri',
      'Mu buryo bwo guhambura abahambiriwe n\'ibyaha, uremera yuko utazamena ibanga ry\'umuntu wicujije ibyaha bye muri mwembi babiri gusa?',
    ),
    _Line('Urobanurwa', 'YEGO NDABYEMEYE.'),
    _Line(
      'Musenyeri',
      'Uremera gukurikiza amabwiriza yose y\'itorero no kwubaha abagukuriye mu kazi ufite umutima utuje?',
    ),
    _Line('Urobanurwa', 'YEGO NDABYEMEYE.'),
    _Line(
      'Musenyeri',
      'Uremera ko uzitwara neza ukaba ikitegererezo ku bantu bose ntugire umuntu uwo ariwe wese ubera igisitaza. Ugatunga neza urugo rwawe urutoza gusenga no gusoma Ijambo ry\'Imana buri munsi?',
    ),
    _Line('Urobanurwa', 'YEGO NDABYEMEYE.'),
    _Line(
      'Musenyeri',
      'Uremera gukorera Imana yawe igihe cyose haba mu gihe gikwiye n\'igihe cyidakwiye? (nukuvuga mu bihe bikomeye)',
    ),
    _Line('Urobanurwa', 'YEGO NDABYEMEYE.'),
    _Line('Musenyeri', 'Ngaho vuga indahiro yawe y\'ubushumba.'),
    _Line(
      'Urobanurwa',
      'Jyewe ______________, imbere y\'Imana imenya byose n\'imbere yiri teraniro ndahiriye yuko nfashijwe n\'Imana ibyo byose nzabisohoza koko. Ndibuka yuko ibyo byose umunsi w\'amateka uzabihishura.',
    ),
    _Line(
      'Musenyeri',
      'Imana nyiribushobozi bwose izagufashe gusohoza iyi ndahiro.',
    ),
  ]),
  _Sec('KUROBANURA — ORDINATION DECLARATION', <_Line>[
    _Line('Note', 'Urobanurwa apfukame imbere ya Musenyeri.'),
    _Line(
      'Musenyeri',
      'KUBW\'UBUBASHA NAHAWE MBYEMEREWE N\'IMANA, NGUHAYE UMURIMO W\'UBUSHUMBA MU IZINA RYA DATA WA TWESE N\'UMWANA, N\'UMWUKA WERA. AMINA.',
    ),
  ]),
  _Sec('GUTANGA IBIKORESHO BY\'UBUSHUMBA', <_Line>[
    _Line(
      'Musenyeri',
      'Akira Stola — Ikimenyetso cy\'urukundo rwa Kristo. Yesu yaravuze ati: "Kunkorera ntibiruhije n\'umutwaro wanjye nturemereye." (Mat. 11:30)',
    ),
    _Line(
      'Musenyeri',
      'Akira Bibiliya — Ijambo ry\'Imana niyo nkota y\'Umwuka.',
    ),
    _Line('Musenyeri', 'Akira Igikombe — Ikimenyetso cy\'amasakaramentu yera.'),
  ]),
  _Sec('GUSHYIRAHO IBIGANZA (LAYING ON OF HANDS)', <_Line>[
    _Line('Musenyeri', 'Nimuze tumurambikeho ibiganza.'),
    _Line(
      'Note',
      'Abashumba bose n\'Abasenyeri bose bari muri liturgiya barambitseho ibiganza.\nIndirimbo yo gusaba Umwuka Wera — Bose TI 45',
    ),
    _Line(
      'Musenyeri',
      'Mwami Mwuka Wera, manukira uyu mugaragu wawe ahabwe umurimo w\'ubushumba mu itorero ry\'Imana uyu munsi tumurambitseho ibiganza, abo azababarira ibyaha byabo bazaba bababariwe, abo atazababarira bazagumane ibyaha byabo. Akira imbaraga zo kubwiriza ubutumwa bwiza no gutanga amasakaramentu mu itorero aho uzahamagarwa hose. Amina.',
    ),
    _Line(
      'Note',
      'Umunyamabanga mukuru amuhe icyemezo cy\'ubushumba n\'itegeko ry\'itorero. · Korari',
    ),
  ]),
  _Sec('ISENGESHO RYO GUSOZA', <_Line>[
    _Line(
      'Musenyeri',
      'Mwami Mana nyir\'ubuntu, Data wa twese wo mu ijuru, turasabira uyu muvandimwe/bavandimwe bacu ubahe umurimo wejejwe w\'ubushumba, kuko ari wowe wabubahaye mwami, ubahe imbaraga zo kubwiriza Ijambo ryawe banezerewe hamwe no gutanga amasakaramentu yera uko bikwiriye. Mwami Yesu Kristo wowe mutambyi mukuru witanzeho ituro ryejejwe kandi rikwiye, ubahe gutera ikirenge mucyawe byukuri. Wemere kubayobora, ubahe urukundo rwawe bashobore gushaka abazimiye n\'abafite intege nke batiganda cyangwa kwinuba, ntibazadohoke kubutwari bwo kugukorera igihe cyose, ubongerere umunezero wo gufatanya no gukorana neza n\'abantu bose. Ubahe kwihanganira byose kandi ubakomeze mu Ijambo rwawe no mu kwizera guhera none kugeza iteka rwose. Amina.',
    ),
    _Line(
      'Musenyeri',
      'Ngaho nimugende muragire umukumbi w\'Imana, uri hano, mutaragirira ibihembo cyangwa izindi nyungu zigayitse, ahubwo mube ikitegererezo. Niho muzahabwa ikamba ry\'icyubahiro ritangirika ubwo umushumba mukuru azaza.',
    ),
    _Line(
      'Note',
      'Indirimbo 47 muri Turirimbire Imana · Babajyane babereke aho bicara mubandi bashumba.',
    ),
  ]),
];

// ─── IGICE II: Amateraniro yo Kucyumweru ─────────────────────────────────────

const _part2 = <_Sec>[
  _Sec('IBISOMSWA (READINGS)', <_Line>[
    _Line('Info', '✦ Zaburi: Zaburi 36:5-7'),
    _Line('Info', '✦ Urwandiko: 1 Yohana 3:1-3'),
    _Line('Info', '✦ Ivangeri: Yohana 17:4-10'),
    _Line(
      'Info',
      'Umusomyi wa Zaburi: Rev. Kabahungu Angelo  ·  Umusomyi w\'urwandiko: Shemasi Mutoni Prisca  ·  Umusomyi w\'ivangeri: Rev. Ruhinda Theonest',
    ),
    _Line('Note', 'Abantu bose bahaguruka kumva Ivangeri yuyu munsi.'),
  ]),
  _Sec('KWEMERA KWA NIKEA (NICENE CREED)', <_Line>[
    _Line(
      'Bose',
      'Nemera Imana imwe yonyine, Data wa twese ushobora byose, Umuremyi w\'ijuru n\'isi, nibiboneka byose nibitaboneka, n\'Umwami umwe wenyine Yesu Kristo, Umwana w\'Imana wavutse ar\'ikinege, yabyawe na se byose bitarabaho, Imana iva mu Mana, umucyo uva mu mucyo. Imana y\'ukuri yaravutse ntiyaremwe, angana na se. Byose byaremwe na se ku bwacu twebwe abantu, no kubwo gucungurwa kwacu. Yamanutse avuye mw\'ijuru ab\'umunyamubiri, k\'ubw\'Umwuka Wera mu mwari Mariya ab\'umuntu kandi abambwa ku musaraba ku bwacu mugihe cya Pontio Pilato, arababazwa, arahambwa, ku munsi wa gatatu arazuka nkuko ibyanditswe bivuga, azamuka mw\'ijuru, yicaye iburyo bwa Data wa twese, kandi azagaruka mucyubahiro gucir\'imanza abazima n\'abapfuye, ubutware bwe ntibuzashira, n\'Umwuka Wera, Umwami kandi umutanga bugingo, akomoka kuri Data wa twese n\'Umwana wavugiye mubahanuzi, nemera Itorero rimwe ryera ryo kw\'isi yose ry\'intumwa, natura umubatizo umwe wo kubabarira ibyaha, kandi ntegereje kuzuka kw\'abapfuye n\'ubugingo bw\'is\'izaza. Amina.',
    ),
  ]),
  _Sec('IVUGABUTUMWA (SERMON)', <_Line>[
    _Line('Info', 'Umubwirizi: Rt. Rev. Prince A. Kalisa – Bishop Elect'),
    _Line('Info', 'Ijambo ry\'Imana: 1 Yohana 3:1-3'),
    _Line(
      'Note',
      'Korari itegura umubwiriza. Gusemura igihe cy\'ivugabutumwa nigihe bibaye ngombwa.',
    ),
  ]),
  _Sec('AMATURO (OFFERING)', <_Line>[
    _Line(
      'Note',
      'Indirimbo 99 muri Turirimbire Imana — Indirimbo yo kuzana amaturo.',
    ),
    _Line(
      'Uyoboye Liturgiya',
      'Mana nyir\'ubuntu n\'imbabazi, turagushimir\'ibyo waduahaye byose. Kandi turakwinginze wakir\'aya maturo y\'abantu bawe uhe n\'umugisha abayatuye bose, uyatumishe urukundo rwawe yere imbuto z\'Umwuka, kugirango ubwami bwawe kukwire hose, kubwa Yesu Kristo umwami wacu. Amina.',
    ),
    _Line('Uyoboye Liturgiya', 'Uwiteka namwitur\'iki?'),
    _Line('Bose', 'Kubw\'ibyiza yangiriye byose.'),
    _Line('Uyoboye Liturgiya', 'Nzakir\'igikombe cy\'agakiza.'),
    _Line('Bose', 'Nambaz\'izina ry\'Uwiteka.'),
    _Line('Uyoboye Liturgiya', 'Uwiteka nd\'umugaragu wawe.'),
    _Line('Bose', 'Umwana wawe wabohoy\'ingoyi.'),
    _Line('Uyoboye Liturgiya', 'Nzagutambir\'igitambo cy\'ishimwe.'),
    _Line('Bose', 'Nambaz\'izina ry\'Uwiteka.'),
  ]),
  _Sec('AMASENGESHO Y\'ABARI HOSE (INTERCESSIONS)', <_Line>[
    _Line(
      'Uyoboye Liturgiya',
      'Man\'ishobora byose, Data wa twese uhoraho, ureban\'imbabazi. Itorero ryawe kw\'isi yose, urihe kugira ubumwe namahoro. No mugihe ribabazwa kubw\'izina ryawe uryihanganishe kandi urikomeze rikwiz\'ubutumwa mu mahanga yose.',
    ),
    _Line('Bose', 'Mana wakire gusenga kwacu.'),
    _Line(
      'Uyoboye Liturgiya',
      'Mwami Yesu, nkuko uri umutwe w\'itorero, uhe umugisha abayobozi b\'itorero ku isi yose. Turasabira Umwepiskopi wacu, abashumba, n\'abainjilisti bose, hamwe nabandi bakorera itorero bose.',
    ),
    _Line('Bose', 'Mana wakire gusenga kwacu.'),
    _Line(
      'Uyoboye Liturgiya',
      'Turasabira abategetsi ku isi yose, cyane cyane abayobozi b\'igihugu cyacu cy\'u Rwanda — uhereye kuri Perezida, ba Minisitiri bose n\'abandi bayobozi mu nzego zose, bayobore Igihugu mu kuri no mubutabera.',
    ),
    _Line('Bose', 'Mana wakire gusenga kwacu.'),
    _Line(
      'Uyoboye Liturgiya',
      'Turasabira abarwayi bose, ubakize kandi ufashe abarwaza babo ubatere umutima utinuba kandi utiheba. Ufashe abagenzi, abatishoboye, imfubyi, abapfakazi, abafite ubumuga, hamwe n\'abafite ububabare bw\'umubiri n\'umutima.',
    ),
    _Line('Bose', 'Mana wakire gusenga kwacu.'),
    _Line(
      'Uyoboye Liturgiya',
      'Ufashe abateraniye hano bose baje kugusenga, ubabarire n\'abatashoboye kuhagera kuber\'intege nke cyangwa impamvu zigaragara. Uzibure amatwi n\'imitima y\'abatizera Ijambo ryawe, bagire umutima wihana bakugarukire.',
    ),
    _Line('Bose', 'Mana wakire gusenga kwacu.'),
  ]),
  _Sec('ISENGESHO RYA NYAGASANI (LORD\'S PRAYER)', <_Line>[
    _Line(
      'Bose',
      'Data wa twese uri mu ijuru, izina ryawe ryubahwe, ubwami bwawe buze, iby\'ushaka bibeho mw\'isi nkuko bibaho mu ijuru, uduhe ifunguro ryacu ry\'uyu munsi, utubabarire ibyaha byacu, nkuko natwe tubabarira ababitugirira ntuduhane mubityoshya, ahubwo udukize umubi, kuko ubwami, n\'ubushobozi, n\'icyubahiro ar\'ibyawe, none n\'iteka ryose. Amina.',
    ),
  ]),
  _Sec('UMUGISHA W\'UWITEKA (BENEDICTION)', <_Line>[
    _Line('Musenyeri', 'Imana ibane namwe.'),
    _Line('Bose', 'Ibe mu mutima wawe.'),
    _Line('Musenyeri', 'Duhimaz\'Uwiteka.'),
    _Line('Bose', 'Dushimir\'Imana.'),
    _Line(
      'Musenyeri',
      'Uwiteka abahe umugisha abarinde, Uwiteka ababonekere abababarire, Uwiteka abareban\'impuhwe abahe amahoro — mu izina rya Data wa twese, n\'Umwana, n\'Umwuka Wera. Amina.',
    ),
    _Line('Bose', 'AMEN, AMEN, AMEN.'),
  ]),
];

// ─── IGICE III: Gusezera Musenyeri Mugabo Sempiga Evalister ──────────────────

const _part3 = <_Sec>[
  _Sec('MUSENYERI USEZERWA', <_Line>[
    _Line('Info', 'Emeritus Bishop MUGABO SEMPIGA EVALISTER'),
    _Line(
      'Info',
      'Musenyeri ukora umuhango wo gusezera: Rt. Rev. Bishop Dr. Fredrick Onael Shoo',
    ),
    _Line(
      'Info',
      'Imirimo Musenyeri yakoreye itorero ibazwa na: Rt. Rev. Prince A. Kalisa – Bishop Elect',
    ),
  ]),
  _Sec('IBICE BY\'IJAMBO RY\'IMANA (5)', <_Line>[
    _Line(
      'Info',
      '① Matayo 19:27-29  ·  ② Ibyak. 20:24  ·  ③ Hebr. 6:10  ·  ④ Ibyak. 20:32  ·  ⑤ Zaburi 27:4',
    ),
    _Line(
      'Info',
      'Abasoma: Rev. Ntawutaramiryundi Joas · Rev. Mahirane William · Rev. Ruhinda Theonest · Dean Rev. Dr. Ntidendereza David · Rt. Rev. Prince A. Kalisa Bishop Elect',
    ),
    _Line(
      'Musenyeri',
      'Imana igufashe guhora wibuka izo mpanuro z\'Ijambo ry\'Imana.',
    ),
  ]),
  _Sec('AMASENGESHO (PRAYERS)', <_Line>[
    _Line(
      'Note',
      'Gusengera Musenyeri no gusengera umuryango we: Rt. Rev. Bishop Dr. Fredrick Onael Shoo, Rt. Rev. Bishop Victor Bwanangera Kambuli Kikagu, Rt. Rev. Prince A. Kalisa Bishop Elect.\nMusenyeri ashyiraho amaboko afatanije nabasenyeri bagenzi be.',
    ),
  ]),
  _Sec('GUTANGARIZA GUSEZERA', <_Line>[
    _Line(
      'Musenyeri',
      'Musenyeri Mugabo Sempiga Evalister agiye mucyiruhuko cy\'izabukuru.',
    ),
    _Line(
      'Note',
      'Ijambo rigufi rya Musenyeri ucuye igihe: Emeritus Bishop Mugabo Sempiga Evalister',
    ),
  ]),
  _Sec('UMUGISHA WO GUSOZA', <_Line>[
    _Line(
      'Musenyeri',
      'Uwiteka abahe umugisha abarinde, Uwiteka ababonekere abababarire, Uwiteka abarebane impuhwe abahe amahoro — mu izina rya Data wa twese, n\'Umwana, n\'Umwuka Wera. Amina.',
    ),
    _Line('Musenyeri', 'Mugende n\'amahoro y\'Imana.'),
    _Line('Note', 'Impano, kwifotoza, gusabana — nyuma y\'amateraniro.'),
  ]),
];

// ─── Schedule data ────────────────────────────────────────────────────────────

const _schedule = <(String, String, String)>[
  (
    '08:30',
    'Kugera aho amateraniro akorerwa',
    'Abakiristo, Korari, Abarobanurwa, Abashumba, Abasenyeri, Abatumirwa',
  ),
  (
    '08:30 – 09:00',
    'Briefing / Guhana amakuru',
    'Rt. Rev. Prince A. Kalisa & Dean Rev. Dr. Ntidendereza David',
  ),
  (
    '09:00 – 09:30',
    'Kwambara kwabasenyeri nabashumba',
    'Abasenyeri nabashumba',
  ),
  (
    '09:30 – 09:45',
    'Kujya aho akarasisi kazahera',
    'GS Rev. Musafiri Jackson & Ass. GS Mr. Rurangwa Meshack',
  ),
  (
    '09:45 – 10:00',
    'Akarasisi ko kwinjira',
    'GS Rev. Musafiri Jackson & Ass. GS Mr. Rurangwa Meshack',
  ),
  ('09:50', 'Kuhagera kw\'abashyitsi bakuru', 'GS Rev. Musafiri Jackson'),
  ('10:00 – 10:02', 'Iminota yo kwibuka', 'Dean Rev. Dr. Ntidendereza David'),
  (
    '10:02 – 11:00',
    'Kurobanura abashumba',
    'Rt. Rev. Bishop Dr. Fredrick Onael Shoo',
  ),
  (
    '11:00 – 12:00',
    'Amateraniro yo kucyumweru',
    'Dean Rev. Dr. Ntidendereza David',
  ),
  (
    '12:00 – 12:40',
    'Gusezera Emeritus Bishop Mugabo Sempiga Evalister',
    'Rt. Rev. Bishop Dr. Fredrick Onael Shoo',
  ),
  ('12:40 – 12:45', 'Amatangazo magufi', 'Mr. Rurangwa Meshack – Ass. to GS'),
  (
    '12:45 – 12:50',
    'Ijambo ry\'ikaze no kwakira abashyitsi',
    'Rt. Rev. Prince A. Kalisa – Bishop Elect',
  ),
  ('12:50 – 12:53', 'Intashyo kuva Anglican Church', 'Umuyobozi'),
  ('12:53 – 12:56', 'Intashyo kuva Interfaith', 'Umuyobozi'),
  ('12:56 – 01:00', 'Intashyo kuva CPR', 'Umuyobozi'),
  ('01:00 – 01:03', 'Intashyo kuva ELCC', 'Rt. Rev. Bishop Victor Bwanangera'),
  (
    '01:03 – 01:10',
    'Intashyo kuva LUCCEA',
    'Rt. Rev. Bishop Dr. Fredrick Onael Shoo & Madam Roe Rose Mbise',
  ),
  ('01:10 – 01:13', 'Intashyo kuva LWF', 'Rev. Dr. Samuel Dawai'),
  ('01:13 – 01:16', 'Intashyo kuva RIC', 'Umuyobozi'),
  ('01:16 – 01:20', 'Ijambo ry\'umuyobozi w\'Akarere ka Kicukiro', 'Umuyobozi'),
  (
    '01:20 – 01:30',
    'Ijambo ry\'umushyitsi mukuru',
    'Rt. Rev. Bishop Dr. Fredrick Onael Shoo',
  ),
  ('01:30', 'Gufata amafoto · Gusoza amateraniro · Ifunguro rya kumanywa', ''),
];

// ─── Main page ────────────────────────────────────────────────────────────────

class SpecialOrdinationPage extends StatelessWidget {
  const SpecialOrdinationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF080808) : const Color(0xFFF8F5F0);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: bg,
        body: NestedScrollView(
          headerSliverBuilder: (ctx, _) => [_SliverHeader(isDark: isDark)],
          body: TabBarView(
            children: [
              _LiturgyTab(sections: _part1, isDark: isDark),
              _LiturgyTab(sections: _part2, isDark: isDark),
              _Part3Tab(isDark: isDark),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Sliver header + pinned tab bar ──────────────────────────────────────────

class _SliverHeader extends StatelessWidget {
  final bool isDark;
  const _SliverHeader({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final expandH = sw < 360 ? 220.0 : (sw > 430 ? 280.0 : 258.0);
    final titleFs = sw < 360 ? 24.0 : (sw > 430 ? 34.0 : 30.0);
    final subFs   = sw < 360 ? 10.5 : (sw > 430 ? 13.0 : 12.0);
    final hPad    = sw < 360 ? 14.0 : (sw > 430 ? 26.0 : 22.0);

    return SliverAppBar(
      expandedHeight: expandH,
      pinned: true,
      backgroundColor: _darkMaroon,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      actions: [
        IconButton(
          icon: const Icon(Icons.share_rounded, size: 22),
          tooltip: 'Sangira',
          onPressed: () => Share.share(
            'Amateraniro Arimo Umuhango wo Kurobanura Abashumba\n'
            'Lutheran Church of Rwanda (LCR)\n'
            'EAST AFRICA CHRISTIAN UNIVERSITY — Gymnasium Hall, Masaka\n'
            'Itariki: 26 Mata 2026 | 9:00am – 1:30pm\n\n'
            'Abarobanurwa:\n'
            '• Shemasi MUKUNZI Reminant\n'
            '• Shemasi RURANGIRWA Emmanuel\n'
            '• Shemasi NDAYISHIMIYE Noel\n\n'
            'LCR App',
          ),
        ),
        const SizedBox(width: 4),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Rich gradient background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A0510), _darkMaroon, Color(0xFF5C1630)],
                  stops: [0.0, 0.55, 1.0],
                ),
              ),
            ),
            // Decorative circles
            Positioned(
              right: -50,
              top: -50,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _gold.withValues(alpha: 0.06),
                ),
              ),
            ),
            Positioned(
              left: -30,
              bottom: 60,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.03),
                ),
              ),
            ),
            // Content
            SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(hPad, 54, hPad, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // LCR badge
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _gold.withValues(alpha: 0.55),
                            ),
                            borderRadius: BorderRadius.circular(20),
                            color: _gold.withValues(alpha: 0.09),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.church_rounded,
                                size: 11,
                                color: _gold,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'LCR · AMATERANIRO YIHARIYE',
                                style: GoogleFonts.lato(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  color: _gold,
                                  letterSpacing: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Kurobanura\nAbashumba',
                      style: GoogleFonts.cinzel(
                        fontSize: titleFs,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.15,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Ordination of Pastors & Sunday Service',
                      style: GoogleFonts.lato(
                        fontSize: subFs,
                        color: Colors.white60,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const Spacer(),
                    // Pills row
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: const [
                        _Pill(
                          icon: Icons.calendar_today_rounded,
                          label: 'Mata 26, 2026',
                        ),
                        _Pill(
                          icon: Icons.access_time_rounded,
                          label: '9:00am – 1:30pm',
                        ),
                        _Pill(
                          icon: Icons.location_on_rounded,
                          label: 'EACU · Masaka',
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(sw < 360 ? 50 : 54),
        child: Container(
          color: isDark ? const Color(0xFF0D0D0D) : Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(
                height: 1,
                thickness: 1,
                color: isDark ? Colors.white10 : Colors.grey.shade200,
              ),
              TabBar(
                labelColor: isDark ? Colors.white : Colors.black,
                unselectedLabelColor:
                    isDark ? Colors.white54 : Colors.black45,
                indicatorColor: _gold,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.label,
                dividerColor: Colors.transparent,
                isScrollable: sw < 380,
                tabAlignment:
                    sw < 380 ? TabAlignment.start : TabAlignment.fill,
                labelPadding: sw < 380
                    ? const EdgeInsets.symmetric(horizontal: 16)
                    : EdgeInsets.zero,
                labelStyle: GoogleFonts.cinzel(
                  fontSize: _fs(context, 13),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.6,
                ),
                unselectedLabelStyle: GoogleFonts.cinzel(
                  fontSize: _fs(context, 12),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
                tabs: [
                  Tab(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text('I. KUROBANURA',
                          style: GoogleFonts.cinzel(
                            fontSize: _fs(context, 12.5),
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          )),
                    ),
                  ),
                  Tab(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text('II. KUCYUMWERU',
                          style: GoogleFonts.cinzel(
                            fontSize: _fs(context, 12.5),
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          )),
                    ),
                  ),
                  Tab(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text('III. GUSEZERA',
                          style: GoogleFonts.cinzel(
                            fontSize: _fs(context, 12.5),
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Info pill ────────────────────────────────────────────────────────────────

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Pill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: Colors.white70),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.lato(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.white70,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Liturgy tab (generic scrollable sections) ────────────────────────────────

class _LiturgyTab extends StatelessWidget {
  final List<_Sec> sections;
  final bool isDark;
  const _LiturgyTab({required this.sections, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final p = _hpad(context);
    final partHymns = _collectPartHymns(sections);

    return ListView(
      padding: EdgeInsets.fromLTRB(p, 16, p, 40),
      children: [
        if (partHymns.isNotEmpty)
          _PartSongsCard(hymns: partHymns, isDark: isDark),
        for (final sec in sections) _SectionCard(sec: sec, isDark: isDark),
      ],
    );
  }
}

// ─── Part 3 tab (retirement + schedule) ──────────────────────────────────────

class _Part3Tab extends StatelessWidget {
  final bool isDark;
  const _Part3Tab({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final p = _hpad(context);
    final partHymns = _collectPartHymns(_part3);

    return ListView(
      padding: EdgeInsets.fromLTRB(p, 16, p, 40),
      children: [
        if (partHymns.isNotEmpty)
          _PartSongsCard(hymns: partHymns, isDark: isDark),
        for (final sec in _part3) _SectionCard(sec: sec, isDark: isDark),
        const SizedBox(height: 8),
        _ScheduleCard(isDark: isDark),
        const SizedBox(height: 12),
        _VenueMapCard(isDark: isDark),
      ],
    );
  }
}

class _PartSongsCard extends StatelessWidget {
  final List<Hymn> hymns;
  final bool isDark;
  const _PartSongsCard({required this.hymns, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cardBg  = isDark ? const Color(0xFF141414) : Colors.white;
    final border  = isDark ? Colors.white10 : Colors.grey.shade200;
    final hPad    = _hpad(context);
    final headerFs = _fs(context, 13.5);
    final chipTitleFs = _fs(context, 13.0);
    final chipBadgeFs = _fs(context, 11.5);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(hPad, 14, hPad, 14),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 18,
                  decoration: BoxDecoration(
                    color: _gold,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'INDIRIMBO Z\'IKI GICE',
                  style: GoogleFonts.cinzel(
                    fontSize: headerFs,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : Colors.black,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: hymns.map((hymn) {
                final hasContent =
                    hymn.verses.isNotEmpty ||
                    _ordDocFallbackLyrics[hymn.number] != null;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? _gold.withValues(alpha: 0.08)
                        : _gold.withValues(alpha: 0.11),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark
                          ? _gold.withValues(alpha: 0.25)
                          : _gold.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'TI ${hymn.number}',
                        style: GoogleFonts.lato(
                          fontSize: chipBadgeFs,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: _r(context, 200)),
                        child: Text(
                          _ordinationHymnTitles[hymn.number] ?? hymn.title,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.lato(
                            fontSize: chipTitleFs,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        hasContent
                            ? Icons.verified_rounded
                            : Icons.info_outline_rounded,
                        size: 14,
                        color: hasContent
                            ? (isDark ? _lightGold : Colors.black87)
                            : (isDark ? Colors.white60 : Colors.black45),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section card ─────────────────────────────────────────────────────────────

class _SectionCard extends StatefulWidget {
  final _Sec sec;
  final bool isDark;
  const _SectionCard({required this.sec, required this.isDark});

  @override
  State<_SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<_SectionCard> {
  bool _open = true;

  @override
  Widget build(BuildContext context) {
    final isDark  = widget.isDark;
    final cardBg  = isDark ? const Color(0xFF141414) : Colors.white;
    final border  = isDark ? Colors.white10 : Colors.grey.shade200;
    final hPad    = _hpad(context);
    final titleFs = _fs(context, 13.5);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Section header
          GestureDetector(
            onTap: () => setState(() => _open = !_open),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: EdgeInsets.fromLTRB(hPad, 14, 14, 14),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: _open ? Radius.zero : const Radius.circular(16),
                  bottomRight: _open ? Radius.zero : const Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 3,
                    height: 18,
                    decoration: BoxDecoration(
                      color: _gold,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.sec.title,
                      style: GoogleFonts.cinzel(
                        fontSize: titleFs,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : Colors.black,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _open ? 0.0 : -0.25,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: isDark ? Colors.white38 : Colors.black26,
                      size: _fs(context, 22),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Lines
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 220),
            crossFadeState: _open
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: EdgeInsets.fromLTRB(hPad, 10, hPad, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.sec.lines
                    .map((l) => _LineWidget(line: l, isDark: isDark))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Line widget ──────────────────────────────────────────────────────────────

class _LineWidget extends StatelessWidget {
  final _Line line;
  final bool isDark;
  const _LineWidget({required this.line, required this.isDark});

  @override
  Widget build(BuildContext context) {
    // Responsive font sizes — scale with screen width
    final bodyFs  = _fs(context, 15.5);
    final labelFs = _fs(context, 11.5);
    final noteFs  = _fs(context, 13.5);

    switch (line.role) {
      // ── Note (grey italic box) ──────────────────────────────────────────────
      case 'Note':
        final hymn = _hymnFromNote(line.text);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark ? Colors.white12 : Colors.grey.shade200,
                  ),
                ),
                child: Text(
                  line.text,
                  style: GoogleFonts.lato(
                    fontSize: noteFs,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.black87,
                    height: 1.6,
                  ),
                ),
              ),
              if (hymn != null) ...[
                const SizedBox(height: 10),
                _HymnInlineCard(hymn: hymn, isDark: isDark),
              ],
            ],
          ),
        );

      // ── Info (plain label) ──────────────────────────────────────────────────
      case 'Info':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            line.text,
            style: GoogleFonts.lato(
              fontSize: noteFs,
              height: 1.6,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        );

      // ── Congregation / All (box) ────────────────────────────────────────────
      case 'Bose':
      case 'Abakiristo':
      case 'Abarobanurwa':
        final bool isCandidate = line.role == 'Abarobanurwa';
        final boxColor = isCandidate ? _gold : _maroon;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: boxColor.withValues(alpha: isDark ? 0.14 : 0.07),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: boxColor.withValues(alpha: isDark ? 0.28 : 0.18),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isCandidate ? Icons.person_rounded : Icons.people_rounded,
                      size: _fs(context, 13),
                      color: boxColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      line.role.toUpperCase(),
                      style: GoogleFonts.lato(
                        fontSize: labelFs,
                        fontWeight: FontWeight.w900,
                        color: boxColor,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  line.text,
                  style: GoogleFonts.notoSerif(
                    fontSize: bodyFs,
                    height: 1.75,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? (isCandidate ? _lightGold : Colors.white)
                        : (isCandidate ? const Color(0xFF5A3A00) : Colors.black),
                  ),
                ),
              ],
            ),
          ),
        );

      // ── Urobanurwa (ordination candidate — gold accent) ─────────────────────
      case 'Urobanurwa':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _gold.withValues(alpha: isDark ? 0.20 : 0.13),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'U',
                  style: TextStyle(
                    fontSize: labelFs,
                    fontWeight: FontWeight.w900,
                    color: isDark ? _lightGold : const Color(0xFF7A5500),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      line.role,
                      style: GoogleFonts.lato(
                        fontSize: labelFs,
                        fontWeight: FontWeight.w800,
                        color: isDark ? _lightGold : const Color(0xFF7A5500),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      line.text,
                      style: GoogleFonts.notoSerif(
                        fontSize: bodyFs,
                        height: 1.7,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      // ── Leader / Bishop (navy-blue accent) ─────────────────────────────────
      default:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A237E)
                      .withValues(alpha: isDark ? 0.22 : 0.10),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  line.role.isNotEmpty ? line.role[0] : 'L',
                  style: TextStyle(
                    fontSize: labelFs,
                    fontWeight: FontWeight.w900,
                    color: isDark
                        ? const Color(0xFF9FA8DA)
                        : const Color(0xFF1A237E),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      line.role,
                      style: GoogleFonts.lato(
                        fontSize: labelFs,
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? const Color(0xFF9FA8DA)
                            : const Color(0xFF1A237E),
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      line.text,
                      style: GoogleFonts.notoSerif(
                        fontSize: bodyFs,
                        height: 1.72,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black,
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
}

class _HymnInlineCard extends StatelessWidget {
  final Hymn hymn;
  final bool isDark;
  const _HymnInlineCard({required this.hymn, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bg = isDark
        ? _gold.withValues(alpha: 0.08)
        : _gold.withValues(alpha: 0.10);
    final border = isDark
        ? _gold.withValues(alpha: 0.30)
        : _gold.withValues(alpha: 0.40);
    final fg = isDark ? Colors.white : Colors.black87;
    // Ceremony-specific lyrics take priority over whatever is stored in hymns_data
    final ceremonyLyrics = _ordDocFallbackLyrics[hymn.number];
    final displayTitle = _ordinationHymnTitles[hymn.number] ?? hymn.title;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: _gold.withValues(alpha: isDark ? 0.06 : 0.12),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: _gold,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'TI ${hymn.number}',
                  style: GoogleFonts.lato(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  displayTitle,
                  style: GoogleFonts.cinzel(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.music_note_rounded,
                size: 17,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ],
          ),
          if (hymn.source != null && ceremonyLyrics == null) ...[
            const SizedBox(height: 6),
            Text(
              hymn.source!,
              style: GoogleFonts.lato(
                fontSize: 12,
                color: isDark ? Colors.white54 : Colors.black54,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          // Ceremony lyrics override app-stored verses so the correct song is shown
          if (ceremonyLyrics != null) ...[
            const SizedBox(height: 10),
            Text(
              ceremonyLyrics,
              style: GoogleFonts.lato(fontSize: 15, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black, height: 1.8),
            ),
          ] else if (hymn.verses.isNotEmpty) ...[
            if (hymn.chorus != null) ...[
              const SizedBox(height: 10),
              Text(
                hymn.chorus!,
                style: GoogleFonts.lato(
                  fontSize: 14.5,
                  color: fg,
                  fontStyle: FontStyle.italic,
                  height: 1.7,
                ),
              ),
            ],
            const SizedBox(height: 8),
            for (final verse in hymn.verses)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${verse.number}. ',
                        style: GoogleFonts.lato(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      TextSpan(
                        text: verse.text,
                        style: GoogleFonts.lato(
                          fontSize: 14.5,
                          color: fg,
                          height: 1.75,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

// ─── Venue map card ───────────────────────────────────────────────────────────

class _VenueMapCard extends StatelessWidget {
  final bool isDark;
  const _VenueMapCard({required this.isDark});

  // Google Plus Code for EACU Gymnasium Hall, Kabuga, Kigali
  static const _plusCodeFull = '2668+FX Kabuga';

  Future<void> _openMaps() async {
    // Plus Code opens directly to the exact building — no searching needed
    final encoded = Uri.encodeComponent(_plusCodeFull);
    final webUri  = Uri.parse('https://maps.google.com/?q=$encoded');
    final geoUri  = Uri.parse('geo:0,0?q=$encoded');
    final iosUri  = Uri.parse('maps://?q=$encoded');

    if (await canLaunchUrl(geoUri)) {
      await launchUrl(geoUri, mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(iosUri)) {
      await launchUrl(iosUri, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? const Color(0xFF141414) : Colors.white;
    final border = isDark ? Colors.white10 : Colors.grey.shade200;

    return GestureDetector(
      onTap: _openMaps,
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            // ── Header ────────────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 3, height: 18,
                    decoration: BoxDecoration(
                      color: _gold,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'AHO AMATERANIRO AKORERWA',
                      style: GoogleFonts.cinzel(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : Colors.black87,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: _gold.withValues(alpha: isDark ? 0.18 : 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _gold.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.map_rounded,
                          size: 11,
                          color: _gold,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Google Maps',
                          style: GoogleFonts.lato(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: _gold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Map preview ───────────────────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.zero,
              child: SizedBox(
                height: 160,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Map-style background
                    Container(
                      color: isDark
                          ? const Color(0xFF1A2030)
                          : const Color(0xFFE8F0E8),
                    ),
                    // Road grid lines — horizontal
                    for (int i = 1; i <= 5; i++)
                      Positioned(
                        top: i * 26.0,
                        left: 0, right: 0,
                        child: Container(
                          height: 1,
                          color: (isDark ? Colors.white : Colors.black)
                              .withValues(alpha: 0.06),
                        ),
                      ),
                    // Road grid lines — vertical
                    for (int i = 1; i <= 7; i++)
                      Positioned(
                        left: i * 46.0,
                        top: 0, bottom: 0,
                        child: Container(
                          width: 1,
                          color: (isDark ? Colors.white : Colors.black)
                              .withValues(alpha: 0.06),
                        ),
                      ),
                    // Main road — horizontal
                    Positioned(
                      top: 78, left: 0, right: 0,
                      child: Container(
                        height: 7,
                        color: (isDark
                            ? Colors.white.withValues(alpha: 0.10)
                            : Colors.white.withValues(alpha: 0.70)),
                      ),
                    ),
                    // Main road — vertical
                    Positioned(
                      left: 140, top: 0, bottom: 0,
                      child: Container(
                        width: 7,
                        color: (isDark
                            ? Colors.white.withValues(alpha: 0.10)
                            : Colors.white.withValues(alpha: 0.70)),
                      ),
                    ),
                    // Campus block
                    Positioned(
                      left: 110, top: 50,
                      child: Container(
                        width: 80, height: 55,
                        decoration: BoxDecoration(
                          color: _gold.withValues(alpha: 0.22),
                          border: Border.all(
                            color: _gold.withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    // Pin
                    const Positioned(
                      left: 138, top: 28,
                      child: Icon(
                        Icons.location_pin,
                        color: Color(0xFFD32F2F),
                        size: 36,
                      ),
                    ),
                    // Tap overlay with ripple
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _openMaps,
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                    // "Tap to open" label
                    Positioned(
                      right: 10, bottom: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.open_in_new_rounded,
                                size: 11, color: Colors.white70),
                            const SizedBox(width: 4),
                            Text(
                              'Fungura Google Maps',
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
              ),
            ),

            // ── Address row ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD32F2F).withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      size: 18,
                      color: Color(0xFFD32F2F),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'East Africa Christian University',
                          style: GoogleFonts.lato(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Gymnasium Hall · Masaka, Kicukiro · Kigali',
                          style: GoogleFonts.lato(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white70 : Colors.black87,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(
                              Icons.grid_on_rounded,
                              size: 13,
                              color: isDark ? _gold.withValues(alpha: 0.7) : Colors.black54,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _plusCodeFull,
                              style: GoogleFonts.lato(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: isDark ? Colors.white30 : Colors.black26,
                    size: 20,
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

// ─── Schedule card ────────────────────────────────────────────────────────────

class _ScheduleCard extends StatelessWidget {
  final bool isDark;
  const _ScheduleCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? const Color(0xFF141414) : Colors.white;
    final border = isDark ? Colors.white10 : Colors.grey.shade200;
    final divider = isDark ? Colors.white10 : Colors.grey.shade100;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 18,
                  decoration: BoxDecoration(
                    color: _gold,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'GAHUNDA Y\'AMATERANIRO',
                  style: GoogleFonts.cinzel(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : Colors.black,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '26 / 04 / 2026',
                  style: GoogleFonts.lato(
                    fontSize: 10,
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
                ),
              ],
            ),
          ),
          for (int i = 0; i < _schedule.length; i++) ...[
            if (i > 0)
              Divider(height: 1, color: divider, indent: 16, endIndent: 16),
            _ScheduleRow(item: _schedule[i], isDark: isDark, index: i),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  final (String, String, String) item;
  final bool isDark;
  final int index;
  const _ScheduleRow({
    required this.item,
    required this.isDark,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final sw        = MediaQuery.of(context).size.width;
    final timeW     = sw < 360 ? 72.0 : (sw > 430 ? 100.0 : 88.0);
    final activityFs = _fs(context, 13.5);
    final personFs   = _fs(context, 12.0);
    final timeFs     = _fs(context, 11.5);
    final hPad       = sw < 360 ? 10.0 : (sw > 430 ? 20.0 : 14.0);

    final (time, activity, person) = item;
    final isHighlight = index == 7 || index == 8 || index == 9;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 11),
      color: isHighlight
          ? (isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey.shade50)
          : Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: timeW,
            child: Text(
              time,
              style: GoogleFonts.lato(
                fontSize: timeFs,
                fontWeight: FontWeight.w800,
                color: isHighlight
                    ? (isDark ? _lightGold : Colors.black)
                    : (isDark ? Colors.white60 : Colors.black54),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity,
                  style: GoogleFonts.lato(
                    fontSize: activityFs,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : Colors.black,
                    height: 1.4,
                  ),
                ),
                if (person.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    person,
                    style: GoogleFonts.lato(
                      fontSize: personFs,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white60 : Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
