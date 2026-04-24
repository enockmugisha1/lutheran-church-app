// lib/core/data/hymns_data.dart
// Structured hymn data for the Lutheran Church of Rwanda (LCR)
// Source: IGITABO — TURIRIMBIRE IMANA (Liturgy & Hymn Book, LCR)
// Bishop MUGABO Evarister — Rev.Dean SARAMBUYE Celestin (compiler)
// 414 hymns organised in 39 thematic / liturgical categories.
//
// Lyrics notation:
//   [Chorus] / [Refrain] = chorus line repeated between verses
//   (x2) = repeat the preceding line or phrase twice
//
// Source abbreviations:
//   TMW  = Tumuabudu Mungu wetu (Kiswahili)
//   EMP  = Empoya / Kihaya–Kinyambo
//   LBW  = Lutheran Book of Worship
//   TI   = Turirimb'Imana (1st Kinyarwanda edition)
//   Gush = Indirimbo zo Gushimisha Imana (Kinyarwanda)
//   AGK  = Indirimbo z'Agakiza (Kinyarwanda)

class HymnVerse {
  final int number;
  final String text;
  const HymnVerse({required this.number, required this.text});
}

class Hymn {
  final int number;
  final String title;
  final String? source;       // e.g. "TMW 6", "EMP 7", "Gush 225"
  final String? tuneName;     // tune reference in parentheses
  final List<HymnVerse> verses;
  final String? chorus;
  const Hymn({
    required this.number,
    required this.title,
    this.source,
    this.tuneName,
    this.verses = const [],
    this.chorus,
  });
}

class HymnCategory {
  final String id;
  final String titleRw;
  final String titleEn;
  final List<Hymn> hymns;
  const HymnCategory({
    required this.id,
    required this.titleRw,
    required this.titleEn,
    required this.hymns,
  });
}

// ---------------------------------------------------------------------------
// CATEGORY I — ADVENT: GUTEGEREZA UMUKIZA  (6 hymns, #1–6)
// ---------------------------------------------------------------------------

const List<Hymn> _adventHymns = [
  Hymn(
    number: 1,
    title: 'Bakristo Mutunganye imitima yanyu',
    source: 'TMW 6',
    tuneName: 'Wakristo iwekeni mioyo tayari',
    verses: [
      HymnVerse(
        number: 1,
        text:
            "Bakristo mutunganye Imitima yanyu,\n"
            "Yesu ayinjiremo n' umukiza wanyu,\n"
            "Dor' atuzaniye ubuntu n'imbabazi,\n"
            "Umucyo n'ubugingo biva k'Uwiteka.",
      ),
      HymnVerse(
        number: 2,
        text:
            "Dor' umukiz' araje Mutegur' inzira,\n"
            "Mwez' imitima yanyu Mwe gukor' ibibi,\n"
            "Ibimurakaza bikanamubabaza,\n"
            "Bibe bitakirangwa mu mitima yanyu.",
      ),
      HymnVerse(
        number: 3,
        text:
            "Umunt' usuzugura Acirwahw, iteka,\n"
            "Nah' umunyamurava akundwa n'Imana,\n"
            "Yes' akund' umuntu w'imyifatire myiza,\n"
            "Agakorer' Imana, ibishimishije.",
      ),
      HymnVerse(
        number: 4,
        text:
            "Untunganye Mukiza nd' umunyantegeke,\n"
            "Kubw' ubuntu bwawe gusa, wibere muri jye,\n"
            "Turi kumwe Mwami, Ngir' ubugingo bushya,\n"
            "Ibyo nkora n'ibyo mvuga, Bikagusingiza.",
      ),
    ],
  ),

  Hymn(
    number: 2,
    title: "Nimwugurur'Amarembo",
    source: 'TMW',
    tuneName: 'Fungua milango yote',
    verses: [
      HymnVerse(
        number: 1,
        text:
            "Nimwugurur' amarembo,\n"
            "Umwami Yesu yinjire,\n"
            "Umwami w'abami bose,\n"
            "Umukiza w'isi yose,\n"
            "Atuzaniy' ubugingo,\n"
            "muze tumuririmbire,\n"
            "Dushim' uwo Mwami,\n"
            "Umunyambabazi.",
      ),
      HymnVerse(
        number: 2,
        text:
            "Arakiza agir' ukuri,\n"
            "Akenyey' ubugwa neza\n"
            "Arangwa n'ubutungane,\n"
            "Ubuntu niyo ntwaro ye,\n"
            "Atubabarir' ibyaha,\n"
            "Muze tumuririmbire\n"
            "Dushim' uwo Mwami,\n"
            "Mukiz' ukomeye.",
      ),
      HymnVerse(
        number: 3,
        text:
            "Isi yose niyishime,\n"
            "Yakir' uwo Mwami mwiza\n"
            "Kand' imitima y'abantu,\n"
            "yigarurirwe na Yesu,\n"
            "Ninawe mucyo w'abantu,\n"
            "utumurikira twese,\n"
            "Dushim' uwo Mwami,\n"
            "uduhumuriza.",
      ),
      HymnVerse(
        number: 4,
        text:
            "Nimwugurur' amarembo,\n"
            "nimutunganye imitima\n"
            "Nimutegur' imikindo,\n"
            "bishimish' Umwami Yesu,\n"
            "Abazanir' ubugingo,\n"
            "n'ibyishimo mu mitima,\n"
            "Dushim' uwo Mwami,\n"
            "Umunyarukundo.",
      ),
      HymnVerse(
        number: 5,
        text:
            "Ngwino Mwami wanjye Yesu,\n"
            "unyinjire mu mutima,\n"
            "Winjiran' ubuntu bwawe,\n"
            "ngaragaz' ubwiza bawawe,\n"
            "Umwuka wawe anyobore,\n"
            "azangeze no mw'ijuru\n"
            "Mpore nshim' Umwami,\n"
            "ibihe bitazashira.",
      ),
    ],
  ),

  Hymn(
    number: 3,
    title: "Hoziyana twese dushim'uwaje",
    source: 'TMW 1',
    tuneName: 'Hosiana Asifiwe ajaye',
    verses: [
      HymnVerse(
        number: 1,
        text:
            "Hoziyana!\n"
            "Twese dushim' Uwaje\n"
            "Mwizina ry'Umwami.\n"
            "Hoziyana mw ijuru!\n"
            "Ubwo yaje mw izina ry'Umwami, (x2)\n"
            "Hoziyana! Hoziyana!\n"
            "Hoziyana mw ijuru! (x2)",
      ),
    ],
  ),

  Hymn(
    number: 4,
    title: 'Mukiza wacu Yesu tukwakire dute',
    source: 'Gush 226 / TMW',
    tuneName: 'Nikulakije vema',
    verses: [
      HymnVerse(
        number: 1,
        text:
            "Mukiza wacu Yesu,\n"
            "Tukwakire dute?\n"
            "Tukwakire twishimye;\n"
            "Ngwin' utwiberemo.\n"
            "Wez' imitima yacu,\n"
            "Kand' utumenyeshe\n"
            "Ingeso nziz' ukunda\n"
            "N'ibikunezeza.",
      ),
      HymnVerse(
        number: 2,
        text:
            "Wasiz' ibyawe byose,\n"
            "Uza mur'iyi si,\n"
            "Uraduhumuriza\n"
            "Kuko tubabaye.\n"
            "Nta watunyag' ubwami\n"
            "Bwawe bw'amahoro:\n"
            "Uhor' udutabara,\n"
            "Ukaturokora.",
      ),
      HymnVerse(
        number: 3,
        text:
            "Wasanze tur' imbohe,\n"
            "Uratubohora.\n"
            "Twar' ibisenzegeri,\n"
            "Uraducungura,\n"
            "Ngo tub' intore zawe,\n"
            "Duhoran' iteka,\n"
            "Tubone n'ubugingo\n"
            "Butazarangira.",
      ),
      HymnVerse(
        number: 4,
        text:
            "Mbe n'iki cyaguteye\n"
            "Kuv' ahw Iman' iri?\n"
            "Nta kind, n' urukundo\n"
            "N'imbabazi zawe.\n"
            "Ntushak' abanyabyaha\n"
            "Ko bazarimbuka;\n"
            "Byatumy' udutabara,\n"
            "Turababarirwa.",
      ),
    ],
  ),

  Hymn(
    number: 5,
    title: 'Kanguka Mutima wanjye',
    source: 'EMP 7',
    tuneName: 'Sisimuka',
    verses: [
      HymnVerse(
        number: 1,
        text:
            "Kanguka mutima wanjye udakerererwa,\n"
            "Dor' Umwami wawe araje, umusanganire\n"
            "Umusanganire.",
      ),
      HymnVerse(
        number: 2,
        text:
            "Ni Yesu Umwana w'Imana Umukiza wacu\n"
            "Umwami w'ijuru n'isi, aje kudukiza\n"
            "Aje kudukiza.",
      ),
      HymnVerse(
        number: 3,
        text:
            "Atuzaniy' ibyishimo kandi bihoraho,\n"
            "N'amahoro n'ubugingo n'ibyiza bye byose.\n"
            "N'ibyiza bye byose.",
      ),
      HymnVerse(
        number: 4,
        text:
            "Ajy' atuyobor' inzira, yo kujya mu ijuru,\n"
            "Muze tumusanganire, mutegerej' iki?\n"
            "Mutegereje iki?",
      ),
      HymnVerse(
        number: 5,
        text:
            "Twiyak' ibituzitira twitunganye vuba\n"
            "Dukurikir' Umukiza niwe Yesu Kristo,\n"
            "Niwe Yesu Kristo.",
      ),
    ],
  ),

  Hymn(
    number: 6,
    title: 'Hoziyana Mesiya',
    source: 'TMW 2',
    verses: [
      HymnVerse(
        number: 1,
        text:
            "Hoziyana Mesiya\n"
            "Arataha mu murwa we\n"
            "Mutungany' ahwanyura\n"
            "Mutegur' inzira zose\n"
            "Imiteguro myiza\n"
            "Ahinjiran'ishema.",
      ),
      HymnVerse(
        number: 2,
        text:
            "Hoziyana Mukiza\n"
            "Ngwino turakwakiriye\n"
            "Tugutuy'imitima\n"
            "Tuguhay'ikaz' iwacu\n"
            "Turagukinguriye\n"
            "Winjire mu mitima.",
      ),
      HymnVerse(
        number: 3,
        text:
            "Hosiyan' urintwari\n"
            "Udufashe natwe twese\n"
            "Tub' abawe by'ukuri\n"
            "Tugukorer' uk' ushaka\n"
            "Kuko utajya wemera\n"
            "Abantu batizera.",
      ),
      HymnVerse(
        number: 4,
        text:
            "Hoziyan' ur' Umwami\n"
            "Kaze neza Mwami mwiza\n"
            "Uwasizw' amavuta\n"
            "Ngwino turagukeneye\n"
            "Ikaze Hosiyana\n"
            "Hoziyana Haleluya.",
      ),
    ],
  ),
];

// ---------------------------------------------------------------------------
// CATEGORY II — KUVUKA KWA YESU / CHRISTMAS / NOHELI  (24 hymns, #7–30)
// ---------------------------------------------------------------------------

const List<Hymn> _christmasHymns = [
  Hymn(
    number: 7,
    title: "Mvuye mw'ijuru nonaha",
    source: 'TMW',
    tuneName: 'Natoka leo mbinguni',
    verses: [
      HymnVerse(
        number: 1,
        text:
            "Mvuye mw ijuru nonaha\n"
            "Mbazaniy'inkuru nziza\n"
            "Inkuru y'umunezero\n"
            "Kuri mwe no kuri bose.",
      ),
      HymnVerse(
        number: 2,
        text:
            "Umwana yabavukiye\n"
            "Yibyariwe na Mariya\n"
            "N'umwan'ingirakamaro\n"
            "Uzabater'ibyishimo.",
      ),
      HymnVerse(
        number: 3,
        text:
            "Ni Yes' Umwana w'Imana\n"
            "Umukiza w'isi yose\n"
            "Yaje gucungur' abantu\n"
            "Mu byaha n'ibyago byabo.",
      ),
      HymnVerse(
        number: 4,
        text:
            "Mbahay'iki kimenyetso\n"
            "Mujyemu kiraro cy'inka\n"
            "Murahasang' uruhinja\n"
            "Niwe Mwami wo mw ijuru.",
      ),
      HymnVerse(
        number: 5,
        text:
            "Natwe twese tumushime\n"
            "Tujyane nabo bashumba\n"
            "Tureb' ibyo bitangaza\n"
            "Imana yadukoreye.",
      ),
      HymnVerse(
        number: 6,
        text:
            "Yesu Mwana w'Uwiteka\n"
            "Hindur' umutima wanjye\n"
            "Wiber' ubuturo bwawe\n"
            "Uzabamo ibihe byose.",
      ),
    ],
  ),

  Hymn(
    number: 8,
    title: "Nimuze mwese mwebw'abungeri",
    source: 'EMP 20',
    tuneName: 'Mwije inywenainywe bashumba (Mel. Kihaya)',
    verses: [
      HymnVerse(
        number: 1,
        text:
            "Nimuze mwese mwebwe bungeri\n"
            "Tujy' i Bethelehemu kureba\n"
            "Umwana Yesu yatuvukiye\n"
            "Niwe mukiza w'abantu bose\n"
            "Ntimutinye!",
      ),
      HymnVerse(
        number: 2,
        text:
            "Muze tujye mu cyaro kureba\n"
            "Tureb' icy' intumwa zatubwiye\n"
            "Tujye guhimbaz' Umucunguzi\n"
            "Tumwamamaze mu bantu bose\n"
            "Haleluya!",
      ),
      HymnVerse(
        number: 3,
        text:
            "Ni koko, intumwa zatubwiye\n"
            "Inkuru nziza ishimishije\n"
            "Imana nisingizwe mw ijuru\n"
            "Mwis' amahoro, abe mu bayo\n"
            "Haleluya!",
      ),
    ],
  ),

  Hymn(
    number: 9,
    title: 'Bahungu bakobwa nimuze',
    source: 'Gush 228 / TMW 21',
    tuneName: 'Watoto njooni Bethelehemu',
    verses: [
      HymnVerse(
        number: 1,
        text:
            "Bahungu, bakobwa,\n"
            " nimuze mwese\n"
            "I Betelehemu\n"
            "Mu ruhongore;\n"
            "Tureb' ibyo Data\n"
            "Uri mw'ijuru\n"
            "Yaduhaye twese\n"
            " Mur'iri joro!",
      ),
      HymnVerse(
        number: 2,
        text:
            "Hamwe n'abashumba,\n"
            "Dushim' Umwami\n"
            "Uryamye mu byatsi\n"
            "Nk' uworoheje.\n"
            "dusang' ababyeyi\n"
            "Banezerewe;\n"
            " Duhuze n'Intumwa\n"
            "Kumusingiza.",
      ),
      HymnVerse(
        number: 3,
        text:
            "Nimupfukamire\n"
            "Umwami mwiza\n"
            "Uduh' ubugingo,\n"
            " Mumuhimbaze!\n"
            "Muvuze n'impundu\n"
            "Hamwe n'Intumwa;\n"
            "Mubwire n'abandi\n"
            "Ibyo mwabonye.",
      ),
      HymnVerse(
        number: 4,
        text:
            "Twese tumushime,\n"
            "Wa Mwami mwiza\n"
            "Tumuhimbarize\n"
            "Kukwadukunda.\n"
            "Dufatanye twese ,\n"
            "tuvuz'impundu,\n"
            "Ngw abatamumenye\n"
            " Baze gukizwa.",
      ),
    ],
  ),

  Hymn(
    number: 10,
    title: "Mw'ivuka ryawe Yesu bakuryamishije",
    source: 'Gush 225',
    verses: [
      HymnVerse(
        number: 1,
        text:
            "Mw'ivuka ryawe Yesu\n"
            "Bakuryamishije,\n"
            "Mu kiraro kigawa mu muvure w'inka\n"
            "Wasasiwe Mukiza\n"
            "Ahadakwiriye\n"
            "Nubwo uri uwaturemye\n"
            "Niko wagiriwe.",
      ),
      HymnVerse(
        number: 2,
        text:
            "Nimuze yemwe bana tumuhimbarize\n"
            "Ko yaryamishijw'atyomu muvurew'inka.\n"
            "Dushim'umwami Yesu tumukundir'ibyo\n"
            "Ko yabay'umukene kubw'abanyabyaha.",
      ),
      HymnVerse(
        number: 3,
        text:
            "Umfashe Mwami Yesu kuguhora hafi\n"
            "Ngo ngukunde tubane iminsi yanjye yose.\n"
            "Kandi n'abandi bana nabo ubiyereke\n"
            "Bagukunde dushimane urukundo rwawe.",
      ),
    ],
  ),

  Hymn(
    number: 11,
    title: "Uwera mwana w'Imana",
    source: 'EMP 18',
    tuneName: 'Yesu Mwana Alikwera (Mel. Kihaya)',
    verses: [
      HymnVerse(
        number: 1,
        text:
            "Uwera Mwana w'Imana\n"
            "Tukwakiran'ibyishimo\n"
            "Tukuvugiriz' ingoma\n"
            "Turirimban' indilimbo.",
      ),
      HymnVerse(
        number: 2,
        text:
            "Uwo mwana niwe mwami\n"
            "W'ijuru n'si mwitange\n"
            "Mbese tumwakire dute?\n"
            "Tumuh' imitima yacu.",
      ),
      HymnVerse(
        number: 3,
        text:
            "Hahirwa abazamwakira\n"
            "Yibere mu rugo rwabo\n"
            "Azabah' amahoro ye\n"
            "N'ibyishimo bidashira.",
      ),
    ],
  ),

  Hymn(
    number: 12,
    title: 'Rya joro ryatowe',
    source: 'Gush 223 / TMW 19',
    tuneName: 'Usiku Mtakatifu',
    verses: [
      HymnVerse(
        number: 1,
        text:
            "Rya joro ryatowe,\n"
            "Rubanda ruryamye,\n"
            "Mariya na Yosefu basa\n"
            "Bari maso barer' akana\n"
            "Kaje kava mw ijuru. x2",
      ),
      HymnVerse(
        number: 2,
        text:
            "Rya joro ryatowe,\n"
            "Intumwa z'Imana\n"
            "Zamenyesheje ba bungeri\n"
            "Icyabonetse mw isi yacu,\n"
            "Yuko Yesu yavutse. x2",
      ),
      HymnVerse(
        number: 3,
        text:
            "Rya joro ryatowe,\n"
            "Umucyo w'ukuri\n"
            "Twese waratumurikiye,\n"
            "Ngo udukure mu byaha byacu,\n"
            "Kuko Yesu yavutse. x2",
      ),
      HymnVerse(
        number: 4,
        text:
            "Rya joro ryatowe\n"
            "Rituma twishima.\n"
            "Dufatanye n'abo mw ijuru\n"
            "Kuririmbir' akana Yesu:\n"
            "Tuti: Shimwa, Mukiza! x2",
      ),
    ],
  ),

  Hymn(
    number: 13,
    title: 'Nkuramutse Mwami wanjye',
    source: 'TMW 13',
    tuneName: 'Salamu Yesu Bwanangu',
    verses: [
      HymnVerse(
        number: 1,
        text:
            "Nkuramutse Mwami wanjye\n"
            "Wowe Mukiza wanjye\n"
            "Ndaje kandi nkuzaniye\n"
            "Ibyo wampaye byose\n"
            "Umubiri n'umutima\n"
            "Ndetse n'ibitekerezo\n"
            "Nibyo ngutuye Mwami.",
      ),
      HymnVerse(
        number: 2,
        text:
            "Ni kubwanjye Mwami mwiza\n"
            "Uyu munsi wavutse\n"
            "Kubwurukundo wankunze\n"
            "Wanzaniye agakiza\n"
            "Kuv' isi itari yaremwa\n"
            "Wowe wari wateguye\n"
            "Kunkiriz' ubugingo.",
      ),
      HymnVerse(
        number: 3,
        text:
            "Nahoraga ntwikiriwe\n"
            "N'igicucu cy'urupfu\n"
            "Umutima wanjy'umeze\n"
            "Nkumurikwa n'izuba\n"
            "Ni wowe Mwami wampaye\n"
            "Kubaho no kunezerwa\n"
            "Nzajya mpora ngushima.",
      ),
    ],
  ),

  Hymn(
    number: 14,
    title: "Muze dushim'Uwiteka",
    source: 'EMP 9',
    tuneName: 'Mwije tusime Katonda',
    verses: [
      HymnVerse(
        number: 1,
        text:
            "Muze dushim' Uwiteka\n"
            "Ko yadukijije\n"
            "Yohereje Umwana we\n"
            "Ngo aze aducungure (x2)",
      ),
      HymnVerse(
        number: 2,
        text:
            "Kuko Imana yaremye\n"
            "Adamu na Eva\n"
            "Bibaniraga amahoro\n"
            "Mu ngobyi y'Imana (x2)",
      ),
      HymnVerse(
        number: 3,
        text:
            "Maze Satani aj' aboshya\n"
            "Kuyisuzugura\n"
            "Imana ibarakariye\n"
            "Baba nk'ibicibwa (x2)",
      ),
      HymnVerse(
        number: 4,
        text:
            "Nibw'Imana yashyizeho\n"
            "Gupfa nk'igihanoi\n"
            "Bab'imbohe za Satani\n"
            "Nta wubitayeho (x2)",
      ),
      HymnVerse(
        number: 5,
        text:
            "Nubwo twari kure yayo\n"
            "Ntiyatwibagiwe\n"
            "yoherej'Umwana wayo\n"
            "Aza kudukiza (x2)",
      ),
      HymnVerse(
        number: 6,
        text:
            "Yaraje yigir' umuntu\n"
            "Maz' adusubiza\n"
            "Icyubahiro cy'Imana\n"
            "Twari twarambuwe (x2)",
      ),
      HymnVerse(
        number: 7,
        text:
            "None muze tuyiramye\n"
            "Tuyiririmbire\n"
            "Dushimire Umwami Yesu\n"
            "Ko yatuvukiye (x2)",
      ),
    ],
  ),

  Hymn(
    number: 15,
    title: "Wasiz'ubwiza war'ufite mw'ijuru",
    source: 'Gush 224',
    verses: [
      HymnVerse(
        number: 1,
        text:
            "Wasiz' ubwiza war'ufite mw ijuru,\n"
            "Ubwo wazaga mw isi, Yesu;\n"
            "No mw ivuka ryawe nta hantu hariho\n"
            "Hagutunganiye, Mwami.\n"
            "Ngwin' uze mu mutima wanjye,\n"
            "Umbemo, ndabikwemereye.\n"
            "Ngwin' utahe mu mutima wanjye,\n"
            "Wiboneremw aho kuba.",
      ),
      HymnVerse(
        number: 2,
        text:
            "Mbes' abamarayika ntibagusingije,\n"
            "Ubwo wimikwaga, Krisito?\n"
            "Ariko, Mwami, wicishije bugufi,\n"
            "Utuvukir' utyo mw isi!\n"
            "Ngwin' ube mu mutima wanjye:\n"
            "Nizigiy' urwo rupfu rwawe!\n"
            "Ngwin' utahe mu mutima wanjye:\n"
            "Nizigiy' Umusaraba!",
      ),
      HymnVerse(
        number: 3,
        text:
            "Dor' inyoni yos' igir' aho yarika,\n"
            "Na y' ingunzu ntibur' intaho.\n"
            "Ariko Wowe, Mwami Yesu, wabuze\n"
            "Ah' urambik' umusaya.\n"
            "Waj' uzany' Ijambo rizima, Krisito,\n"
            "Ryo kubatur' abantu bawe.\n"
            "Bakwitura kwanga urukundo rwaw'ubwo,\n"
            "Bakumanika ku Giti.",
      ),
      HymnVerse(
        number: 4,
        text:
            "Waj' uzany' Ijambo rizima, Krisito,\n"
            "Ryo kubatur' abantu bawe.\n"
            "Bakwitura kwanga urukundo rwaw' ubwo,\n"
            "Bakumanika ku Giti.\n"
            "Ngwin' ube mu mutima wanjye;\n"
            "Nizigiy' urwo rupfu rwawe!\n"
            "Ngwin' utahe mu mutima wanjye;\n"
            "Nizigiy' Umusaraba!",
      ),
      HymnVerse(
        number: 5,
        text:
            "Abari mw ijuru bazagusingiza,\n"
            "N' uza kwima ya ngoma yawe.\n"
            "Nzumv' umbwir' uti: Mfit' aho nkugeneye,\n"
            "Ngwino, wimane nanjy' ubu!\n"
            "Bizanezeza cyane, Yesu,\n"
            "Ubwo nzumv' ijwi ryawe ryiza!\n"
            "Bizanezeza cyane, Mukiza:\n"
            "Nzagusingiza, ntahwema!",
      ),
    ],
  ),

  Hymn(
    number: 16,
    title: 'Ku rurembo rwa Dawidi Umwami',
    source: 'Gush 227',
    verses: [
      HymnVerse(
        number: 1,
        text:
            "Ku rurembo rwa Dawid' Umwami,\n"
            "Kera harih' uruhongore;\n"
            "Umwan' ahabikirwa na nyina\n"
            "Mu muvure w'inka warimo.\n"
            "Uwo mwana ni we Yesu,\n"
            "Kandi nyina yitwaga Mariya.",
      ),
      HymnVerse(
        number: 2,
        text:
            "Yaje mw is' asig' i We mw ijuru,\n"
            "Bamuraza mu ruhongore;\n"
            "Kand' uburiri bwar' umuvure,\n"
            "Nubwo yar' Umwami wa bose:\n"
            "Umukiza wacu wera\n"
            "Yabanye n'aboroheje nka twe.",
      ),
      HymnVerse(
        number: 3,
        text:
            "Kand' akir' umwana, yubahaga\n"
            "Ababyey' akabakorera;\n"
            "Yabagandukiye muri byose;\n"
            "Yabakundaga bihebuje.\n"
            "Natwe, nubwo tur' abana,\n"
            "Tumere nka Yes' uko yar' ari.",
      ),
      HymnVerse(
        number: 4,
        text:
            "Yatubereye nk'uworoheje,\n"
            "Kand' ari we Nyir'imbaraga!\n"
            "Yarakuraga nk'abandi bana:\n"
            "N' icyitegerezo cyacu.\n"
            "We yababaranye natwe;\n"
            "Bituma tunezeranwa na We.",
      ),
      HymnVerse(
        number: 5,
        text:
            "Uwo Mwana mwiza wo gukundaNone ni W' utegeka byose!\n"
            "Azagaruka, twe tumubone,\n"
            "Yes' Umwami n'Umucunguzi.\n"
            "Kand' ashorera tw' abana\n"
            "Ngw atugeze mw ijuru, tubane.",
      ),
      HymnVerse(
        number: 6,
        text:
            "Azaboneker' abamukunda,\n"
            "Atakiri mu ruhongore;\n"
            "Azab' ari mw ijuru ku ngoma,\n"
            "I buryo bw'Iman' ihoraho:\n"
            "Tuzamwikubit' imbere,\n"
            "Tumusingizany' iteka ryose.",
      ),
    ],
  ),

  Hymn(
    number: 17,
    title: 'Abungeri baringaga intama nijoro',
    source: 'Gush 229',
    verses: [
      HymnVerse(
        number: 1,
        text:
            "Abungeri barindaga\n"
            "Intama n'ijoro,\n"
            "Marayik' abiyereka\n"
            "Mu cyubahiro cye.",
      ),
      HymnVerse(
        number: 2,
        text:
            "Babony' icyo cyubahiro,\n"
            "Baterwa n'ubwoba,\n"
            "Marayik' arababwira\n"
            "Ati: Muhumure!",
      ),
      HymnVerse(
        number: 3,
        text:
            "Nimwumv' ubu, mbazaniye\n"
            "Inkuru y'ibyiza:\n"
            "Mu rurembo rwa Dawidi,\n"
            "Havuts' Umukiza.",
      ),
      HymnVerse(
        number: 4,
        text:
            "Ndabah' iki kimenyetso;\n"
            "Nuko, murabona\n"
            "Baryamishij' uruhinja\n"
            "Mu muvure w'inka.",
      ),
      HymnVerse(
        number: 5,
        text:
            "Amaze kubivug' atyo,\n"
            "Habonek' umutwe\n"
            "W'abamarayika benshi,\n"
            "Bahimbaza bati:",
      ),
      HymnVerse(
        number: 6,
        text:
            "Nukw icyubahiro kibe\n"
            "Ku Mana mw ijuru,\n"
            "Kand' ab' ikunda bo mw isi\n"
            "Bahabw' amahoro.",
      ),
    ],
  ),

  Hymn(
    number: 18,
    title: "Umva intumwa zo mw'ijuru",
    source: 'Gush 230',
    chorus:
        "Umv' intumwa zo mw ijuru\n"
        "Ziririmbira Yesu.",
    verses: [
      HymnVerse(
        number: 1,
        text:
            "Umv' intumwa zo mw ijuru\n"
            "Ziririmbira Yesu.\n"
            "Zit' Iman' ishimwe cyane:\n"
            "Amahor' abe mw isi:\n"
            "Kuk' Umwana way' avutse\n"
            "Uzakiz' abanyabyaha;\n"
            "Yesu n' Umukiza wacu;\n"
            "Yaje kuducungura.\n"
            "[Umv' intumwa zo mw ijuru\n"
            "Ziririmbira Yesu.]",
      ),
      HymnVerse(
        number: 2,
        text:
            "Nubwo mu kiraro cy'inka,\n"
            "Arimo wavukiye,\n"
            "Ur' Iman' isumba byose:\n"
            "Twese tugusingize.\n"
            "Tugushime cyane, Yesu:\n"
            "Ur' Iman' uri n'umuntu.\n"
            "Ur' Imanuweli wacu:\n"
            "Imana turi kumwe.",
      ),
      HymnVerse(
        number: 3,
        text:
            "Ur' izuba rituvira,\n"
            "Ur' amahoro yacu;\n"
            "Wemeye kuva mw ijuru,\n"
            "Wemeye kuva mw ijuru,\n"
            "Ub' umuntu wo gupfa.\n"
            "Watuzaniy' ubugingo,\n"
            "Ngo tukwizere, tubeho.\n"
            "Tunezerew' uyu munsi\n"
            "Ko duhaw' Umukiza.",
      ),
      HymnVerse(
        number: 4,
        text:
            "Nukw amoko yos' ashime\n"
            "Krist' Uwera w'Imana.\n"
            "Hose hose humvikane\n"
            "Indirimbo z'ihimwe.\n"
            "Amahoro nabe mw isi,\n"
            "Kuk' Umwami Yes' avutse.\n"
            "Yesu ni We Nshuti yacu,\n"
            "N' Umuvunyi duhawe.",
      ),
    ],
  ),

  Hymn(
    number: 19,
    title: 'Umwana yavukiye mu murwa',
    source: 'Gush 231',
    chorus:
        "Duhimbaz' uwo munsi\n"
        "Yesu yatuvukiye;\n"
        "Tubyamamaze hose\n"
        "Yuko haj' Umukiza.",
    verses: [
      HymnVerse(number: 1, text:
          "Umwana yavukiye\n"
          "Mu murwa wa Dawidi\n"
          "Ni we Yes' Uwiteka\n"
          "Yadusezeranije."),
      HymnVerse(number: 2, text:
          "Habayehw abungeri,\n"
          "Babona marayika,\n"
          "Baratinya; na w' ati:\n"
          "Noneho, mutinyuke!"),
      HymnVerse(number: 3, text:
          "Ati: Krist' Umukiza\n"
          "Yaje mu gihugu cye;\n"
          "Umuremyi wa byose\n"
          "Yavukiye mw icumbi!"),
      HymnVerse(number: 4, text:
          "Mwana wera w'Imana,\n"
          "Turagupfukamiye,\n"
          "Tugushimira cyane\n"
          "Yuk' utujemo, Yesu!"),
    ],
  ),

  Hymn(
    number: 20,
    title: 'Munezero, Munezero',
    source: 'Gush 232',
    verses: [
      HymnVerse(number: 1, text:
          "Munezero, Munezero,\n"
          "Birori bishimisha!\n"
          "Mu ndirimbo zo mw ijuru,\n"
          "Duhyiremo n'izacu!\n"
          "Yesu yaje kudukiza,\n"
          "Tumuhawe n'Uwiteka:\n"
          "Munezero, Munezero,\n"
          "Birori bishimisha!"),
      HymnVerse(number: 2, text:
          "Munezero, Munezero,\n"
          "Imitim' inezerwe!\n"
          "Tumwitabe, tumwitabe,\n"
          "Yes' uduhamagara.\n"
          "Dukunze kw aturokora,\n"
          "Tureke kubirazika:\n"
          "Munezero, Munezero,\n"
          "Imitim' inezerwe!"),
      HymnVerse(number: 3, text:
          "Munezero, Munezero,\n"
          "Jyan' ishimwe ku Mana!\n"
          "Amahoro n'amahoro!\n"
          "Ni kw Intumwa zivuga.\n"
          "Yesu ni W' uhira bose:\n"
          "Twese tumuririmbire:\n"
          "Munezero, Munezero,\n"
          "Jyan' ishimwe ku Mana!"),
    ],
  ),

  Hymn(
    number: 21,
    title: 'Yemwe bungeri ba kera',
    source: 'Gush 233',
    chorus:
        "Shimwa, Rurema! Shimwa, Rurema!\n"
        "Shimwa, Rurema, shimwa!\n"
        "Wow' usumba byose.\n"
        "Shimwa, Rurema! Shimwa, Rurema!\n"
        "Shimwa, Rurema, shimwa!\n"
        "Amahor' abe mw isi!",
    verses: [
      HymnVerse(number: 1, text:
          "Yemwe, bungeri ba kera,\n"
          "Mutubwir' ibya Yesu,\n"
          "Ibyo mwabonye rya joro,\n"
          "Igihe yavukaga."),
      HymnVerse(number: 2, text:
          "Twar' aho turaririye\n"
          "Umukumbi n'ijoro.\n"
          "Maze, tugubwa gitumo\n"
          "N'urangurur aty' ati:"),
      HymnVerse(number: 3, text:
          "Marayik' aratubwira,\n"
          "At' i Betelehemu\n"
          "Habavukiy' Umukiza:\n"
          "Ni We Mwami Krisito!"),
      HymnVerse(number: 4, text:
          "Uwo mwanya, haz' umutwe\n"
          "W'ingabo zo mw ijuru,\n"
          "Zigoswe n'umucyo mwinshi;\n"
          "Zirasingiza ziti:"),
      HymnVerse(number: 5, text:
          "Ntawe turahaguruka,\n"
          "Tujy' i Betelehemu,\n"
          "Dusangayo rwa Ruhinja,\n"
          "Ni ko kurushima, ngo:"),
      HymnVerse(number: 6, text:
          "Bungeri, turabashimye;\n"
          "Byose turabyumvise.\n"
          "Tujye kumusanga natwe,\n"
          "Tumusingize, tuti:"),
    ],
  ),

  Hymn(
    number: 22,
    title: "Inkuru nziza yavuye mw'ijuru",
    source: 'Gush 234',
    verses: [
      HymnVerse(number: 1, text:
          "Inkuru nziza yavuye mw ijuru\n"
          "Yazanywe no kuduhumuriza;\n"
          "Igaragazwa n'Umwami w'urukundo\n"
          "Wavukiy' abanyabyaha bose."),
      HymnVerse(number: 2, text:
          "Uwo wa muhanuzi yahanuye,\n"
          "Akamubwiririz' amahoro,\n"
          "N' Umwami Yesu watuvukiye twese:\n"
          "Tumuririmbire n'iri joro!"),
      HymnVerse(number: 3, text:
          "Ajy'adutera kwiringira rwose.\n"
          "Adusezeranir' amahoro.\n"
          "N'abafit' imitim' ihagaz' iganya,\n"
          "Abibuka ngo aba h' ubugingo."),
      HymnVerse(number: 4, text:
          "Dushime twes' Umucunguzi wacu\n"
          "Kw atadutinye tw' abanyabyaha!\n"
          "Kand' ubuntu bwe budukomeza mw isi.\n"
          "Tumwitabish' imitim' ikunze."),
    ],
  ),

  Hymn(
    number: 23,
    title: 'Bakristo nimuze munezerwe mwese',
    source: 'Gush 235',
    chorus: "Nimuze, tumusenge (x3)\nNi Kristo Yesu.",
    verses: [
      HymnVerse(number: 1, text:
          "Bakristo, nimuze,\n"
          "munezerwe mwese, nimuze,\n"
          "tugeran' i Betelehemu.\n"
          "Muze kureb' Umwami wahavukiye!"),
      HymnVerse(number: 2, text:
          "Imana Rurema,\n"
          "nubw' isumba byose,\n"
          "ntiyanze kubyarwa n'uwo woroheje.\n"
          "Iyaturemye, dor'uko yamanutse!"),
      HymnVerse(number: 3, text:
          "Muririmbe cyane,\n"
          "bamarayika mwese,\n"
          "Mut' Isumba byose niyubahwe,\n"
          "Kand' amahor' abe mu bo yishimira!"),
      HymnVerse(number: 4, text:
          "Tuje kukuramya,\n"
          "Mwami Yes' uvutse,\n"
          "Tuje kugusingiza, Mukiza Yesu,\n"
          "Nubw' ur' Imana, none turaturanye."),
    ],
  ),

  Hymn(
    number: 24,
    title: 'Umukiza ubwo yavukaga',
    source: 'Gush 236',
    verses: [
      HymnVerse(number: 1, text:
          "Umukiza wac' ubwo yavukaga,\n"
          "Nta cumbi yabonye, keretse mu nka.\n"
          "Nubwo bamuhej' i Betelehemu,\n"
          "Twe kumwim' icumbi: twe, tumwakire!"),
      HymnVerse(number: 2, text:
          "Marayika yaj' asang' abungeri;\n"
          "Izo nkuru nziz' azibabariye,\n"
          "Bagend' uwo mwanya kumusingiza.\n"
          "Natwe twe gutinda, tumusingize."),
      HymnVerse(number: 3, text:
          "Na ba banyabweng' aho babonye\n"
          "Ya nyenyer' irang' umwami Krisito,\n"
          "Bamusanze vuba, ibayobora,\n"
          "Bamutur' ibyiza bamuzanjiye."),
      HymnVerse(number: 4, text:
          "Ko nd' umwana muto, namutur' iki?\n"
          "Simfit' izahabu nk'abanyabwenge,\n"
          "Nta n'intama mfite, nka ba bungeri.\n"
          "Mfite kimwe gusa: muh' umutima!"),
    ],
  ),

  Hymn(
    number: 25,
    title: "Tur'abami bayobotse",
    source: 'Gush 237',
    chorus:
        "Ye… we…, Wa nyenyeri nziza we,\n"
        "Komez' utuyobore,\n"
        "Tujy' imbere; gumy' ugende,\n"
        "Tuger' ahw Umwam' ari!",
    verses: [
      HymnVerse(number: 1, text:
          "Tur' abami bayobotse,\n"
          "Tuje ngo turabukire\n"
          "Uyu Mwam' usumba byose,\n"
          "Dukurikiy' inyenyeri."),
      HymnVerse(number: 2, text:
          "Nje gutur' Umwami Yesu,\n"
          "Nzany' izi zahabu nziza.\n"
          "Ni We nyir'isi n'ijuru,\n"
          "N' Umwami w'abami bose."),
      HymnVerse(number: 3, text:
          "Nje gutur' Umwami Yesu,\n"
          "Nzany' iyi mibavu myiza:\n"
          "Byerekana yukw atwumva,\n"
          "Iyo tumusenze hose."),
      HymnVerse(number: 4, text:
          "Nje gutur' Umwami Yesu,\n"
          "Nzany' ishangi rihumura:\n"
          "Byerekana yuko azapfa\n"
          "Mu cyimbo cy'abanyabyaha."),
      HymnVerse(number: 5, text:
          "Tuje kugushengerera:\n"
          "Ur' Umwami n'Umukiza,\n"
          "Akir' amaturo yacu,\n"
          "Mcunguzi, Nyirigira!"),
    ],
  ),

  Hymn(
    number: 26,
    title: "Kera har'abungeri",
    source: 'Gush 238',
    chorus:
        "Noel! Noel! Noel! Noel!\n"
        "Havuts' Umwami w'Isirayeli!",
    verses: [
      HymnVerse(number: 1, text:
          "Kera har' abungeri mu gihugu cyera,\n"
          "Bumv' inkuru y'ibyiza ko Yes' avutse.\n"
          "Ku musozi n'ijoro, bumv' amajwi menshi\n"
          "Y'ingabo zo mw ijuru, zishima, ziti:"),
      HymnVerse(number: 2, text:
          "Mu gihgu cya kure, har' abanyabwenge.\n"
          "Bahishurirw' ikintu cyabatangaje."),
      HymnVerse(number: 3, text:
          "Nukw Iman' iberetse k' Umukiza yaje,\n"
          "Bajy' ahw ar' uwo mwanya ngo bamusenge.\n"
          "Baramupfukamira, bamutur' ibyiza;\n"
          "By'izahabu n'icyome n'ishangi na yo."),
      HymnVerse(number: 4, text:
          "Natwe tumusang' ubu; n' Umukiza wacu;\n"
          "Yaj 'aciye bugufi kubwac' ababi.\n"
          "Nyuma, ku Musaraba, yaradupfiriye,\n"
          "Aduhongerera ngo tutarimbuka."),
      HymnVerse(number: 5, text:
          "Nuko, tumushimire ko yatuvukiye,\n"
          "Tumutur' imitima yac' imenetse.\n"
          "Uyu munsi wa none, yonger' avukire\n"
          "Mu mitima ya benshi, bamushimishe."),
    ],
  ),

  Hymn(
    number: 27,
    title: 'Nkuko ba banyabwenge',
    source: 'Gush 239',
    verses: [
      HymnVerse(number: 1, text:
          "Nkuko ba banyabwenge\n"
          "Barebye ya nyenyeri,\n"
          "Bakayikurikira\n"
          "N'umunezero mwinshi,\n"
          "Natwe twifuze dutyo\n"
          "Kureb' Umwami Yesu."),
      HymnVerse(number: 2, text:
          "Bo batebutse vuba\n"
          "Gushak' urwo ruhinja;\n"
          "Bararupfukamira,\n"
          "Ni rwo Mwami w'ijuru:\n"
          "Natwe dushake Yesu,\n"
          "Twiboner' Umukiza."),
      HymnVerse(number: 3, text:
          "Bah' Umwan' amaturo\n"
          "Y'igiciro kinini;\n"
          "Baramurabukira,\n"
          "Urut' ab'isi bose:\n"
          "Natwe tugire dutyo,\n"
          "Duhe Yes' imitima."),
      HymnVerse(number: 4, text:
          "Yes' Uwera w'Imana,\n"
          "Uturindir' iteka\n"
          "Mu nzira yaw' ifunganye;\n"
          "Hanyum' uzatujyane\n"
          "Mu bwami bwo mw ijuru,\n"
          "Ah' umwijim' utaba."),
      HymnVerse(number: 5, text:
          "Abo mw ijuru bose,\n"
          "Nta tabaza bifuza:\n"
          "Ni Wowe mucyo waho\n"
          "N'izuba ritarenga.\n"
          "Yes' uzatuyaneyo,\n"
          "Tuguhimbaz' iteka."),
    ],
  ),

  Hymn(
    number: 28,
    title: 'Ku gshyitsi cya Yese',
    source: 'TMW 15',
    tuneName: 'Tawi limechipuka shinani mwaYese / LBW 58',
    verses: [
      HymnVerse(number: 1, text:
          "Ku gishyitsi cya Yese\n"
          "Hashibuts' ishami\n"
          "Nkuko byari byavuzwe\n"
          "N'abantu ba kera\n"
          "Lizan'ururabo\n"
          "Igihe cya n'ijoro\n"
          "Ni ho ryabumbuye."),
      HymnVerse(number: 2, text:
          "Yesaya yavuzeko\n"
          "Ururabo rwiza\n"
          "Ar' Umukiza Yesu\n"
          "Mariya yabyaye\n"
          "Mu ijoro rituje\n"
          "Ububasha bw'Imana\n"
          "Burigaragaza.\n\n"
          "Akokarabo gato\n"
          "Gahumura neza\n"
          "Kirukan' umwijima\n"
          "Karabengerana\n"
          "N' Umwana w'Imana\n"
          "Ni n'umwana w'Adamu\n"
          "Umukiza wacu."),
      HymnVerse(number: 4, text:
          "Igihe tuzapfira\n"
          "Yesu tuyobore\n"
          "Nituva muri yi si\n"
          "Tujye mu byishimo\n"
          "Ku Mana mw'ijuru\n"
          "Aho abera bose\n"
          "Baziber' iteka."),
    ],
  ),

  Hymn(
    number: 29,
    title: "Yes'avukiy'I Bethelehemu",
    source: 'Gush 164 / TMW 438',
    tuneName: 'Yesu zamani Bethlehemu',
    verses: [
      HymnVerse(number: 1, text:
          "Yes' avukiy' i Betelehemu,\n"
          "Bamuryamishije mu muvure:\n"
          "N' umunyambabazi nyinshi cyane:\n"
          "Nguk' uko yaj' anshaka! (x3)\n"
          "N' umunyambabazi nyinshi cyane:\n"
          "Nguk' uko yaj' anshaka!"),
      HymnVerse(number: 2, text:
          "Yesu yancunguriye ku Giti,\n"
          "Kand' abohor' umutima wanjye.\n"
          "Ntangazwa cyane n'imbabazi ze:\n"
          "Yaziz' ibyaha byanjye. (x3)\n"
          "Ntangazwa cyane n'imbabazi ze:\n"
          "Yaziz' ibyaha byanjye."),
      HymnVerse(number: 3, text:
          "Yesu ntahwema gukiz' abantu:\n"
          "Ntitugasubire mu ngeso mbi,\n"
          "Ngo tuzabane na We Mw ijuru:\n"
          "Araduhamagara, (x3)\n"
          "Ngo tuzabane na We mw ijuru:\n"
          "Araduhamagara."),
      HymnVerse(number: 4, text:
          "Yes' azagaruk atujyan' i We,\n"
          "Tugumane na W' iminsi yose,\n"
          "Kuko yabisezeranye natwe:\n"
          "Azaza, ntazatinda. (x3)\n"
          "Kuko yabisezeranye natwe:\n"
          "Azaza, ntazatinda."),
    ],
  ),

  Hymn(
    number: 30,
    title: 'Tunezerwe twese',
    source: 'TMW 37',
    tuneName: 'Sote tufurahi',
    verses: [
      HymnVerse(number: 1, text:
          "U: Tunezerwe twese\n"
          "B: Har'i nkuru nziza\n"
          "U: Mutebuke mwese\n"
          "B: Duhabw'ubugingo\n\n"
          "Ibyasezeranijwe\n"
          "Dore birasohoye\n"
          "Umukiza yavutse"),
      HymnVerse(number: 2, text:
          "U: Yesu yavukiye\n"
          "B: I Betelehemu\n"
          "U: Umubyeyi Mariya\n"
          "B: Yari yari yabibwiwe"),
      HymnVerse(number: 3, text:
          "U: Yaraye mu kiraro\n"
          "B: Uwo mwana mwiza\n"
          "U: Uwo mwana Yesu\n"
          "B: Yahuye n'ibyago"),
      HymnVerse(number: 4, text:
          "U: Uwo mwana wubaha\n"
          "B: N'Umwami w'intwari\n"
          "U: Tumubere abana\n"
          "B: Ni Umukiza w'isi"),
      HymnVerse(number: 5, text:
          "U: Ingabo zo mw'ijuru\n"
          "B: Zazany' iy' inkuru\n"
          "U: Ziyibwira abashumba\n"
          "B: Basanga ari ukuri"),
      HymnVerse(number: 6, text:
          "U: Imana ibana natwe\n"
          "B: Hano mur' iyi si\n"
          "U: Yashimye kudukunda\n"
          "B: Nubwo turi babi"),
      HymnVerse(number: 7, text:
          "Dukomeze twishime\n"
          "Dufite Umukiza\n"
          "Nimuze twigire iwe\n"
          "Turahamagarwa"),
      HymnVerse(number: 8, text:
          "Ab' uwo mwana bose\n"
          "Bafite ubugingo\n"
          "Uwo niwe mwami\n"
          "Kandi atanga impano"),
      HymnVerse(number: 9, text:
          "Habonetse inyenyeri\n"
          "Ivuye kwa Yesse\n"
          "Uwo mwami ahimbazwe\n"
          "Niwe mweza wacu"),
      HymnVerse(number: 10, text:
          "Bavandimwe mwese\n"
          "Mwamamaz' ubuntu\n"
          "Bose bamugane\n"
          "Bahabwe umugisha"),
    ],
  ),
];

// ---------------------------------------------------------------------------
// CATEGORY III — UMWAKA MUSHYA / NEW YEAR  (5 hymns, #31–35)
// ---------------------------------------------------------------------------
const List<Hymn> _newYearHymns = [
  Hymn(
    number: 31,
    title: "Duterane dushime Umwam'Imana",
    source: 'TMW 46',
    verses: [
      HymnVerse(number: 1, text:
          "Duterane dushime\n"
          "Umwam' Imana yacu\n"
          "Yaduhay' imbaraga\n"
          "Umwak' ushize wose."),
      HymnVerse(number: 2, text:
          "Twawubonyem'ibyago\n"
          "Tuwubonamw' ibyiza\n"
          "Ibyiza cyangw' ibibi\n"
          "Bitangwa n'Uwiteka."),
      HymnVerse(number: 3, text:
          "Uk' umubyeyi mwiza\n"
          "Yita kubo yabyaye\n"
          "Niko n'Imana yacu\n"
          "Irind' abantu bayo."),
      HymnVerse(number: 4, text:
          "Dor' ubu dutangiye\n"
          "Umwaka mushya mwami\n"
          "Komez' urwo rukundo\n"
          "Imbabazi n'ubuntu."),
      HymnVerse(number: 5, text:
          "Uri Data wa twese\n"
          "Kand' Umukiza wacu\n"
          "Uvura n'abarwayi\n"
          "Ugakiz' abakene."),
      HymnVerse(number: 6, text:
          "Utugirir' ubuntu\n"
          "Umwuka wawe Wera\n"
          "Utuyobor' inzira\n"
          "Ijya mu bwami bwawe."),
    ],
  ),

  Hymn(
    number: 32,
    title: 'Nguhaye Data Wera Uyu mwaka wose',
    source: 'Gush 421',
    verses: [
      HymnVerse(number: 1, text:
          "Nguhaye, Data wera,\n"
          "Uyu mwaka wose,\n"
          "Ngo mbone kub' uwawe\n"
          "Mu bibaho byose.\n"
          "Sinasaba kw ibyago\n"
          "Mbikurwaho rwose;\n"
          "Icyo ngusabye n'uko\n"
          "Nzajya ngushimisha."),
      HymnVerse(number: 2, text:
          "Mbe, ni nde wah' umwana\n"
          "Byos' ibyo yifuza?\n"
          "Nyamara se ntamwima\n"
          "Ibyiza by'ukuri.\n"
          "Nawe, Man' iby' uduha\n"
          "Biradukwiriye:\n"
          "Birut ibyo twibwira\n"
          "N'ibyo twisabira."),
      HymnVerse(number: 3, text:
          "Ahar' ubuntu bwawe\n"
          "Buzanyemerera\n"
          "Kubon' ihirwe ryinshi\n"
          "Ntari nsanzwe mfite;\n"
          "Byamera bityo, Mwami,\n"
          "Nzajya ngushimira,\n"
          "Ngo nkuz' izina ryawe\n"
          "Mu bataryemera."),
      HymnVerse(number: 4, text:
          "Nib' uzashaka yuko\n"
          "Mbon' imibabaro\n"
          "N'ibyago n'amakuba,\n"
          "Ngo mfush' ibyo nkunda;\n"
          "Nabw' uzamfashe, Mana,\n"
          "Ngo nibuke Yesu,\n"
          "Uburyo yihanganye,\n"
          "Ubwo yampfiraga."),
      HymnVerse(number: 5, text:
          "Nuko, mu byago byose.\n"
          "Nzajya ngusingiza,\n"
          "Menye kw iby' umpa byose,\n"
          "Biva mu rukundo.\n"
          "Nuk' uyu mwaka wose\n"
          "Ub' uwawe, Mana;\n"
          "Mu byiza no mu byago,\n"
          "Mbiguhimbarishe."),
    ],
  ),

  Hymn(
    number: 33,
    title: "Mwam'ujy'imbere mu nzira yacu",
    source: 'TMW 367',
    tuneName: 'Mwokozi Yesu utangulie',
    verses: [
      HymnVerse(number: 1, text:
          "Mwam' ujy' imbere mu nzira yacu.\n"
          "Tur'abana baw' uduhe\n"
          "Kugukurikir' iteka,\n"
          "Utuyobore, tujye kwa Data."),
      HymnVerse(number: 2, text:
          "Mu ngeso zacu no mu mirimo,\n"
          "Iby'ushaka ko dukora\n"
          "Mu rugendo rw'i Siyoni,\n"
          "Utubashishe kubisohoza."),
      HymnVerse(number: 3, text:
          "Ni haz' igiter' uturengere!\n"
          "Nitubon' iminsi mibi,\n"
          "Tube twihanganye cyane,\n"
          "Mu nzira yawe, ni ko bigenda."),
      HymnVerse(number: 4, text:
          "Ni tubazwa n' ibidutera,\n"
          "Udukomeze, tubashe\n"
          "Kubabarir' abatwanga;\n"
          "Tukwiringiye, bizanesheka."),
      HymnVerse(number: 5, text:
          "Naho habaho ikintu cyose\n"
          "Kudukurahw amahoro\n"
          "Ngo duterwe n'ubukonje\n"
          "Tuzacyihana, tuger' i Wawe."),
      HymnVerse(number: 6, text:
          "Duhishurire ibyo mw ijuru\n"
          "Amasezerano yawe\n"
          "Ab'impamba y'ubugingo;\n"
          "Maze hanyuma, tuger'i Wawe."),
      HymnVerse(number: 7, text:
          "Uru rugendo urutunganye!\n"
          "Kand' uduh' Umwuka Wera\n"
          "Ngw ab' impamba y'ubugingo,\n"
          "Utugezeyo, twisihim' iteka."),
      HymnVerse(number: 8, text:
          "Udushorere hose tugenda;\n"
          "Ni tunanirwa mu nzira,\n"
          "Uduhembure, Mukiza.\n"
          "Ubwo tuzapfa, tuzajy'iwawe."),
    ],
  ),

  Hymn(
    number: 34,
    title: 'Umva munyabyaha we',
    source: 'Gush 77',
    chorus:
        "Mbe mugenzi ingeso zawe\n"
        "Zimurikir'abandi?\n"
        "Icy'Umwami Yes'ashaka\n"
        "nuko mwamugumaho.",
    verses: [
      HymnVerse(number: 1, text:
          "Umva, munyabyaha we,\n"
          "Yes' ukw akuburira:\n"
          "Sigaho gukinisha\n"
          "Ubugingo n'urupfu!"),
      HymnVerse(number: 2, text:
          "Umubir' ushukana\n"
          "Uzasaz' ushireho,\n"
          "Ujy' iy' utagaruka:\n"
          "Nuko, wibikinaho."),
      HymnVerse(number: 3, text:
          "Takambir' Iman' ubu,\n"
          "Itarac' amateka:\n"
          "Yo ntikinish' ibyayo.\n"
          "Ngwin' usab' imbabazi!"),
      HymnVerse(number: 4, text:
          "Gupfa ntikuba kure:\n"
          "We kujarajar' utyo!\n"
          "Ntuzi k' uzarimbuka?\n"
          "We kugum' uk' ur' uko."),
      HymnVerse(number: 5, text:
          "Haguruka! Huguka!\n"
          "Hung' urupfu rw'iteka!\n"
          "Yesu n' ubukiriro:\n"
          "Wamuhungiyeho se?"),
    ],
  ),

  Hymn(
    number: 35,
    title: "Dushimish'Imana Umutima",
    source: 'TMW 262',
    tuneName: 'Tumshukuru Mungu / Nun danket alle Gott',
    verses: [
      HymnVerse(number: 1, text:
          "Dushimish' Imana,\n"
          "Umutima n'amajwi\n"
          "Iby'idukorera,\n"
          "biratangaje rwose.\n"
          "Aho twavukiye,\n"
          "kugeza na n'ubu\n"
          "N'igihe kizaza,\n"
          "ntidutererana."),
      HymnVerse(number: 2, text:
          "Mana y'imbaraga,\n"
          "Utwiher' amahoro\n"
          "Mu mitima yacu,\n"
          "hahoremo amahoro,\n"
          "N'umugisha wawe,\n"
          "uwudufashishe\n"
          "Dutsindir' ibyago,\n"
          "Hamwe n'amaganya."),
      HymnVerse(number: 3, text:
          "Dusingiz' Uwiteka,\n"
          "Niwe mubyeyi wacu,\n"
          "Dusingize na Yesu,\n"
          "Niwe waducunguye\n"
          "Umwuka we Wera,\n"
          "Uhor' atulinda.\n"
          "Iman'ihoraho,\n"
          "Imwe mu butatu."),
    ],
  ),
];

// ---------------------------------------------------------------------------
// CATEGORY IV — EPIFANIYA (UMUCYO W'ISI)  (7 hymns, #36–42)
// ---------------------------------------------------------------------------
const List<Hymn> _epiphanyHymns = [
  Hymn(
    number: 36,
    title: "Umucyo w'umwana w'Imana",
    source: 'EMP 29',
    tuneName: 'Omushana gwa Katonda',
    verses: [
      HymnVerse(number: 1, text:
          "Umucyo w'Umwana w'Imana\n"
          "Waturutse mw ijuru\n"
          "Umurika mu mwijima\n"
          "Uboneker' abantu\n"
          "Ubayobor'inzira\n"
          "Y'ubugingo bw'iteka."),
      HymnVerse(number: 2, text:
          "Jambo n'Umwana w'Imana\n"
          "Niwe wabay'umucyo\n"
          "Koyihinduye nk'umuntu\n"
          "Aza kubana natwe\n"
          "Tubon' icyubahiro\n"
          "Cy'uwo Mwana w'Imana."),
      HymnVerse(number: 3, text:
          "Iri jambo ryawe Mwami\n"
          "Niryo twahishuriwe\n"
          "Nirivugwe mumahanga\n"
          "Rigere kuri bose\n"
          "Nabo bagusingize\n"
          "Kuk'ur'umucyo wacu."),
      HymnVerse(number: 4, text:
          "Amoko yose y'abantu\n"
          "Yaba yagenderaga\n"
          "Mur'uyu mucyo w'Imana\n"
          "Habah' ubwumvikane\n"
          "Inzangano zashira\n"
          "Tukaba mu mahoro."),
    ],
  ),

  Hymn(
    number: 37,
    title: "Wowe Man'ikiranuka",
    source: 'Gush 330',
    verses: [
      HymnVerse(number: 1, text:
          "Wowe, Man' ikiranuka,\n"
          "Turashim' izina ryawe\n"
          "Kuk' uduhay' udukiza.\n\n"
          "Ujy' utuyobor' i Wawe."),
      HymnVerse(number: 2, text:
          "Waduhay' Umwami Yesu,\n"
          "Aza kutwigisha neza\n"
          "Ibir' i wawe mw ijuru,\n"
          "Ngo tukuyoboke neza."),
      HymnVerse(number: 3, text:
          "Wow' udusabir' iteka,\n"
          "Ube mu mitima yacu;\n"
          "Natwe tujye tugukunda,\n"
          "Kuk' ur' Umuvunyi wacu.\n\n"
          "Uhimbazwe, Mwami Yesu:\n"
          "Twibuka k' uzagaruka\n"
          "Kudushaka, twe n'abacu,\n"
          "Ng' uduh' ubugingo bushya."),
    ],
  ),

  Hymn(
    number: 38,
    title: "Mana yo mw'ijuru",
    source: 'Gush 23 / TMW 64',
    tuneName: 'Yesu Mwokozi',
    chorus:
        "Mwami, Mwana w'Uwiteka,\n"
        "Muri Wowe, Har' umucyo:\n"
        "Jy'udushorera, Mukiza.",
    verses: [
      HymnVerse(number: 1, text:
          "Mana yo mw ijuru,\n"
          "Byos' uri nyira byo,\n"
          "Kand' ubiduh' ubudasiba.\n"
          "Utang' utimana;\n"
          "Ujy' udukenura,\n"
          "Bituma tuguhimbaza."),
      HymnVerse(number: 2, text:
          "Imapan' ihebuje\n"
          "Yes' atugabira\n"
          "N' ubuntu bwe n'amahoro ye.\n"
          "Yatubabariye,\n"
          "Twaramugomeye:\n"
          "Mbes' ibyo s' igitangaza?"),
      HymnVerse(number: 3, text:
          "Mwami, ndakwinginze,\n"
          "Nubgo ntakwiriye,\n"
          "Nyigiza hafi, tugumane!\n"
          "Mpa kugukorera,\n"
          "Ndusheho kwemera\n"
          "Gukund' ibiri mw ijuru!"),
    ],
  ),

  Hymn(
    number: 39,
    title: 'Nyenyeri yo mu museke',
    source: 'Gush 403',
    verses: [
      HymnVerse(number: 1, text:
          "Nyenyeri yo mu museke,\n"
          "Ubonets' uri kw ijuru,\n"
          "Ur' umucy' utuvira.\n"
          "Tumurikir' imitima,\n"
          "Utweyurir' umwijima\n"
          "Ukunda kuba mw isi."),
      HymnVerse(number: 2, text:
          "Ni Wowe, Yesu, wanshatse\n"
          "Mu mwijima wa Satani,\n"
          "Ubwo nari muri wo.\n"
          "Wowe, Mucunguzi wanjye,\n"
          "Wankuye mu bwenge buke\n"
          "Kubw' urukundo rwawe."),
      HymnVerse(number: 3, text:
          "Wiyambuy' icyubahiro,\n"
          "Wigira nk'umugaragu\n"
          "Utagir' agaciro.\n"
          "Uhorw' ibyaha nakoze,\n"
          "Mpeshw' amahoro n'ubuntu\n"
          "N'urupfu rwawe, Yesu."),
      HymnVerse(number: 4, text:
          "Mucunguzi, mbane nawe,\n"
          "Njye nkwizeran' umurava:\n"
          "Uz' intege nke zanjye;\n"
          "Njye nkor' iby' ushaka byose."),
    ],
  ),

  Hymn(
    number: 40,
    title: 'Umurimo wawe Yesu',
    source: 'TMW 59',
    tuneName: 'Kazi ni yako Bwanangu',
    verses: [
      HymnVerse(number: 1, text:
          "Umurimo wawe Yesu, tujye tuwukora.\n"
          "Nta kintu cyose cyatuma usubir' inyuma.\n"
          "Ndetse nk'intete y'imbuto, iy'ibibwe mu butaka.\n"
          "Ibanza gusa nk'ipfuye, hanyum'ikazagondora;\n"
          "Igakura—ikeraho nyinshi."),
      HymnVerse(number: 2, text:
          "Yesu wababajwe mbere, Nyum' urazamurwa.\n"
          "N'abo bagukurikiye, niko bababazwa.\n"
          "Turakwinginz' udufashe, tunyure munziranziza;\n"
          "Mukiza nkuko wazutse, tuzashobore kuzuka.\n"
          "Tuyobore tugere mw ijuru."),
      HymnVerse(number: 3, text:
          "Mwami waradupfiriye, utagir' icyaha.\n"
          "Utuzanira kuzuka,\n"
          "ubwo wazukaga\n"
          "Utugir' intumwa zawe, twamamaz' izina ryawe\n"
          "Turitanze! dutume tugende."),
    ],
  ),

  Hymn(
    number: 41,
    title: "Inyenyeri y'umucyo",
    source: 'TMW 54',
    tuneName: 'Yesu u nyota kubwa',
    verses: [
      HymnVerse(number: 1, text:
          "Inyeyeri y'umucyo\n"
          "Yaturutse kwa Yakobo\n"
          "Umutim' ushimishwa\n"
          "No kugukorer' iteka\n"
          "None wakir' impano\n"
          "Tuzany' imbere yawe."),
      HymnVerse(number: 2, text:
          "Impano y'igiciro\n"
          "Nuguhora nkwiringira\n"
          "Ni wowe wayimpaye\n"
          "N'impano y'igitangaza\n"
          "Nzayihoran'iteka\n"
          "Nubwo nageragezwa"),
      HymnVerse(number: 3, text:
          "Umubav' uhumura\n"
          "Uwo niyo masengesho\n"
          "Imvugo n'ibyifuzo\n"
          "Ntibigahweme gusenga\n"
          "Nawe kand' uyakire\n"
          "Ab' impumuro nziza."),
      HymnVerse(number: 4, text:
          "Imibabaro yanjye\n"
          "Igihumurira neza\n"
          "Mbabazwa nibyo nkora\n"
          "Nkemera, nkihana neza\n"
          "Maz' ukambabalira\n"
          "Tukabana nishimye."),
    ],
  ),

  Hymn(
    number: 42,
    title: 'Nimukwize hose',
    source: 'TMW 60',
    tuneName: 'Ufalme wa Mungu',
    verses: [
      HymnVerse(number: 1, text:
          "Nimukwize hose\n"
          "Ubwami bwo mwijuru\n"
          "Imbaraga z'Uwiteka\n"
          "Zikiz' ab' umwijima\n"
          "Zibamar' ubwoba bwose\n"
          "Bahabw' ubugingo bw'iteka\n"
          "Mu bwami bw'ijuru."),
      HymnVerse(number: 2, text:
          "Umwanzi Satani\n"
          "Yesu yaramutsinze\n"
          "Umwami w'umwijima\n"
          "Yamunesheje kera\n"
          "Natwe tuzamutsinda Pe\n"
          "Kubw' imbaraga za Yesu\n"
          "Tumutsinde vuba."),
      HymnVerse(number: 3, text:
          "Intwari y'Imana\n"
          "Kuber'ubuntu bwinshi\n"
          "Usubiz'abantu bawe\n"
          "Murukundo nyakuri\n"
          "Baguhesh'icyubahiro\n"
          "Babe n'inyangamugayo\n"
          "Intwari z'iMana."),
      HymnVerse(number: 4, text:
          "Dushim' ubuntu bwe\n"
          "Kuko yadukijije\n"
          "Kandi nitumukorera\n"
          "Ibyo dukora byose\n"
          "Azajy'abih'umugisha\n"
          "Aduhe n'amahoro ye\n"
          "Dushim' ubuntu bwe."),
    ],
  ),
];

// ---------------------------------------------------------------------------
// CATEGORY V — KUBABAZWA NO GUPFA KWA YESU  (19 hymns, #43–61)
// ---------------------------------------------------------------------------
const List<Hymn> _passionHymns = [
  Hymn(
    number: 43,
    title: "Mwana w'Imana",
    source: 'TMW',
    tuneName: 'Mwokozi wangu',
    verses: [
      HymnVerse(number: 1, text:
          "Mwana w'Imana,\n"
          " mbega wakoz'iki,\n"
          "Cyatumy'ucirwahw' itekary'ababi?\n"
          "Impamvu n'iki yaguteye gupfa?\n"
          "Uyitubwire."),
      HymnVerse(number: 2, text:
          "Wapfuy' urupfu rw' abagome,Mwami,\n"
          "Uhemurwa, kand' ushinyagurirwa.\n"
          "Ntangajwe nuko wemeye kubambwa,\n"
          "Upfa nab' utyo."),
      HymnVerse(number: 3, text:
          "Ayo makuba wayatewe n'iki?\n"
          "N'ibyaha byanjye bakujijije pe!\n"
          "Ni jye wapfiriye,\n"
          "nd'umunyabyaha:\n"
          "Narahemutse. go.\n"
          "Waranshunguye."),
    ],
  ),

  Hymn(
    number: 44,
    title: "Mureb'umwana w'intama",
    source: 'TMW 76',
    tuneName: 'Mwana kondoo ayalipa',
    verses: [
      HymnVerse(number: 1, text:
          "Mureb' umwana w'Intama\n"
          "Agiye kudupfira\n"
          "Yikorey'ibyaha byacu\n"
          "Ngo ajye kuducungura\n"
          "Yatuberey'igitambo\n\n"
          "Yatumeneye amaraso\n"
          "Agirango dukizwe\n"
          "Yaratutsw'arakubitwa\n"
          "Banamucira mu maso\n"
          "Bamubamba ku giti."),
      HymnVerse(number: 2, text:
          "Iyo ntama nziz' ivugwa\n"
          "Niwe, Yesu Kirsto\n"
          "Umukiza w'isi yose\n"
          "woherejwe n'Imana\n"
          "Iti genda mwana wanjye\n"
          "Uyobore abayobye\n"
          "Zitur' abaziritse\n"
          "Ubazanehw'iminyago\n"
          "Ubacunguz'amaraso\n"
          "Yo mu rubavu rwawe."),
      HymnVerse(number: 3, text:
          "Haba no gushidikanya\n"
          "Yihuta kubyemera\n"
          "Ntiyigez' atiny' urupfu\n"
          "Akor' ibyo se ashaka\n"
          "N'imbabazi zitangaje\n"
          "N'urukundo ruhebuje\n\n"
          "Urwo yakunz'abantu,\n"
          "Natwe turukurikize\n"
          "Nituva muriyi si mbi,\n"
          "tuzajy'iwe mu ijuru."),
    ],
  ),

  Hymn(
    number: 45,
    title: "Muze kureb'I Gologota",
    source: 'Luth 352 / Gush',
    verses: [
      HymnVerse(number: 1, text:
          "Muze kureb' i Gologota\n"
          "Yes' uko ashinyagurirwa,\n"
          "Murebe Yes'ukundwa na Se\n"
          "Amenets' umutima we.\n\n"
          "Ni tw' apfira ku Musaraba!\n"
          "Tumwizere twihannye.\n"
          "Bantu b'Umwami, mushime\n"
          "Yes' Umucunguzi wanyu!\n\n"
          "Bamwambits' ikamba ry'amahwa:\n"
          "N' ibibi byacu yazize.\n"
          "Ubuntu n'urukundo byawe,\n"
          "Mbe, twabirondora dute?"),
      HymnVerse(number: 2, text:
          "Ni mwumv' ijwi ry' u\n"
          "ko yinginga:Ngo, Dat' ubababarire!\n"
          "Natwe twes' adusabir' atyo,\n"
          "Tw' abanyabyaha yazize.\n\n"
          "Nimwumve mwes' uko gutaka,\n"
          "Uko yatatse cyan' ati:\n"
          "Mbe, Mana yanjye, Mana yanjye,\n"
          "N'iki kikundekesheje?\n\n"
          "Nimwongere mwumv' iryo jwi rye,\n"
          "Ngo, Byose biranarangiye!\n"
          "Umwuka we wenda guhera,\n"
          "Ati: Dat' uz' unyakire!"),
      HymnVerse(number: 3, text:
          "Dor' uko tugupfukamiye,\n"
          "Turakuramya, Mukiza.\n"
          "Kand' ibyaremwe byose\n"
          "na byo\n"
          "Bizagusingiza, Yesu.\n\n"
          "Dufatany' ubugingo bumwe,\n"
          "Dushim' Uwadupfiriye.\n"
          "No mu bugingo no mu rupfu.\n"
          "Yesu Mwam' umbere byose!"),
    ],
  ),

  Hymn(
    number: 46,
    title: 'Umukiza wanjye Yesu',
    source: 'EMP 33',
    tuneName: 'Yesu omukama wange',
    verses: [
      HymnVerse(number: 1, text:
          "Umukiza wanjye Yesu,\n"
          "Wababajwe kubwanjye,\n"
          "Wabambwe ku musalaba,\n"
          "Unkiz'ibyaha byanjye,\n"
          "Ko wagize n'agahinda,\n"
          "Ngo jye ngir'umunezero,\n"
          "Shimwa mukiza wanjye,\n"
          "Singizwa iteka ryose."),
      HymnVerse(number: 2, text:
          "Washyizwe ku ngoyi\n"
          "Mwami,Ngo ngire umudendezo,\n"
          "Wemeye no guhemurwa,\n"
          "Ngo ngir' icyubahiro,\n"
          "Witangiy' aba dakwiye,\n"
          "Ubakurah' urubanza,\n"
          "Shimwa mukiza wanjye,\n"
          "Singizw' iteka ryose."),
      HymnVerse(number: 3, text:
          "Ubwo waremwag' inguma,\n"
          "washakaga kunkiza,\n"
          "Ko waruhijw' unduhura,\n"
          "Unshakir' amahoro,\n"
          "waciriw' iteka ribi,\n"
          "Maze unkura mu bwigunge,\n"
          "Shimwa mukiza wanjye,\n"
          "Singizw' iteka ryose."),
      HymnVerse(number: 4, text:
          "Mbese jye nzakwitur' iki?\n"
          "Mwami nzagushima nte?\n"
          "Nindek'ibyo wanga byose,\n"
          "Nkareka gucumura,\n"
          "Nkibuk'iby'urupfu rwawe,\n"
          "Bikanter' imbaraga nshya,\n"
          "Niryo shimwe ryanjye\n"
          "mwami,Rizakunezereza."),
    ],
  ),

  Hymn(
    number: 47,
    title: 'Umunyamibabaro',
    source: 'Gush 243',
    verses: [
      HymnVerse(number: 1, text:
          "Umuyamibabaro\n"
          "N' izina rintangaza\n"
          "Ry' Umwana w'Uwiteka:\n"
          "Tumushime, n Umukiza!"),
      HymnVerse(number: 2, text:
          "Yemeye guhemurwa\n"
          "No gushinyagurirwa,\n"
          "Apfir' abanyabyaha:\n"
          "Tumushime, n'Umukiza!"),
      HymnVerse(number: 3, text:
          "Twatsinzwe n'urubanza:\n"
          "We nta kibi yakoze!\n"
          "Yatuberey' incungu:\n"
          "Tumushime, n' Umukiza!"),
    ],
  ),
  Hymn(number: 48, title: "Har'umusozi wa kure"),
  Hymn(number: 49, title: 'Iyo nibwiye mu mutima'),
  Hymn(number: 50, title: 'I Gologota ku giti'),
  Hymn(number: 51, title: 'Unyigishe Mukiza'),
  Hymn(number: 52, title: "Hafi y'umusaraba"),
  Hymn(number: 53, title: "Munsi y'umusaraba w'Umukiza"),
  Hymn(number: 54, title: "Nitegerej'umusaraba"),
  Hymn(number: 55, title: 'Isi yose murebe'),
  Hymn(number: 56, title: 'Umwami Yesu yapfuye'),
  Hymn(number: 57, title: 'Nkuko Mose yamanitse'),
  Hymn(number: 58, title: 'Uwo ninde urambitswe?'),
  Hymn(number: 59, title: "Mbes'uriy'ubabaye"),
  Hymn(number: 60, title: 'Reba Yesu ku musaraba'),
  Hymn(number: 61, title: 'Mwami wakomeretse'),
];

// ---------------------------------------------------------------------------
// CATEGORY VI — KUZUKA KWA YESU / PASIKA  (10 hymns, #62–71)
// ---------------------------------------------------------------------------
const List<Hymn> _easterHymns = [
  Hymn(number: 62, title: 'Turirimbe Haleluya'),
  Hymn(number: 63, title: 'Byuka vuba mutima wanjye'),
  Hymn(number: 64, title: 'Nimunezerwe Haleluya'),
  Hymn(number: 65, title: "Dor'umunsi w'ibyishimo"),
  Hymn(number: 66, title: 'Umwami wacu Yesu yazutse'),
  Hymn(number: 67, title: "Tunezerewe k'Umukiza yaje"),
  Hymn(number: 68, title: "Nimureb'igitangaza"),
  Hymn(number: 69, title: 'Haleluya x3 hasimwe uwatuzukiye'),
  Hymn(number: 70, title: 'Ubu tunezerwe'),
  Hymn(number: 71, title: 'Mana turaguhimbaza'),
];

// ---------------------------------------------------------------------------
// CATEGORY VII — YESU ASUBIRA MU IJURU / ASCENSION  (5 hymns, #72–76)
// ---------------------------------------------------------------------------
const List<Hymn> _ascensionHymns = [
  Hymn(number: 72, title: "Yesu yatsinz'urugamba"),
  Hymn(number: 73, title: "Umukiza Yesu ubwo yar'amaze"),
  Hymn(number: 74, title: "Intwari yac'ikomeye"),
  Hymn(number: 75, title: "Uwambitswe ker'ikamba"),
  Hymn(number: 76, title: "Mw'ijuru imbere y'Imana"),
];

// ---------------------------------------------------------------------------
// CATEGORY VIII — MWUKA WERA AMANUKIR'INTUMWA / PENTEKOSTE  (9 hymns, #77–85)
// ---------------------------------------------------------------------------
const List<Hymn> _pentecostHymns = [
  Hymn(number: 77, title: "Mwuka Wera, ngwin'iwacu"),
  Hymn(number: 78, title: "Impano yac'iv a mw'ijuru"),
  Hymn(number: 79, title: "Uyu munsi w'ibyishimo bakristo"),
  Hymn(number: 80, title: 'Kurobanurwa kwejejwe'),
  Hymn(number: 81, title: 'Mwuka Wera wo Mu ijuru'),
  Hymn(number: 82, title: "Mwuka Wer'udukunda"),
  Hymn(number: 83, title: "Ubwo Yesu yar'agiye"),
  Hymn(number: 84, title: 'Manukir\'ubu'),
  Hymn(number: 85, title: "Ngwino Mwuka Nyir'ubuntu"),
];

// ---------------------------------------------------------------------------
// CATEGORY IX — UBUTATU BWERA / TRINITY  (4 hymns, #86–89)
// ---------------------------------------------------------------------------
const List<Hymn> _trinityHymns = [
  Hymn(number: 86, title: "Ur'uwer'uwera Mwami"),
  Hymn(number: 87, title: "Hashimw'Ima yonyine"),
  Hymn(number: 88, title: "Dushim'Imana Data"),
  Hymn(number: 89, title: "Dusingiz'Umuremyi"),
];

// ---------------------------------------------------------------------------
// CATEGORY X — UMUBATIZO / BAPTISM  (6 hymns, #90–95)
// ---------------------------------------------------------------------------
const List<Hymn> _baptismHymns = [
  Hymn(number: 90, title: 'Ubwami bwawe Mukiza'),
  Hymn(number: 91, title: 'Mwami tukuzaniye'),
  Hymn(number: 92, title: 'Nta kindi gihesha gukiranuka'),
  Hymn(number: 93, title: 'Umunsi mwiza nibuka'),
  Hymn(number: 94, title: "Mwami ureban'impuhwe"),
  Hymn(number: 95, title: 'Ababatijwe none'),
];

// ---------------------------------------------------------------------------
// CATEGORY XI — GUKOMEZWA / CONFIRMATION  (5 hymns, #96–100)
// ---------------------------------------------------------------------------
const List<Hymn> _confirmationHymns = [
  Hymn(number: 96, title: 'Uwo njya nikomezaho'),
  Hymn(number: 97, title: "Iyo turi hamwe n'Umukiza wacu"),
  Hymn(number: 98, title: 'Ndi kumwe nawe Yesu'),
  Hymn(number: 99, title: 'Nkomeze njye niringira'),
  Hymn(number: 100, title: "Kundish'Iman'umutima"),
];

// ---------------------------------------------------------------------------
// CATEGORY XII — IFUNGURO RYERA / HOLY COMMUNION  (9 hymns, #101–109)
// ---------------------------------------------------------------------------
const List<Hymn> _communionHymns = [
  Hymn(number: 101, title: "Niki cyankiz'ibyaha?"),
  Hymn(number: 102, title: "Amaraso y'Umucunguzi"),
  Hymn(number: 103, title: "Amaraso y'Umukiza"),
  Hymn(number: 104, title: 'Tungana mutima wanjye'),
  Hymn(number: 105, title: 'Utaratanga Mukiza'),
  Hymn(number: 106, title: "Ai gitare cy'Imana"),
  Hymn(number: 107, title: 'Utuzanye hano gusangira'),
  Hymn(number: 108, title: 'Duteraniye hano twese'),
  Hymn(number: 109, title: 'Amaraso yose'),
];

// ---------------------------------------------------------------------------
// CATEGORY XIII — UBUKWE / WEDDING  (4 hymns, #110–113)
// ---------------------------------------------------------------------------
const List<Hymn> _weddingHymns = [
  Hymn(number: 110, title: 'Ubu bukwe Mwami'),
  Hymn(number: 111, title: "Mana Data yo mw'ijuru"),
  Hymn(number: 112, title: 'Aba bombi Mana Data'),
  Hymn(number: 113, title: "Umukiz'abe hamwe namwe"),
];

// ---------------------------------------------------------------------------
// CATEGORY XIV — GUSHYINGURA / GUHAMBA / BURIAL  (11 hymns, #114–124)
// ---------------------------------------------------------------------------
const List<Hymn> _burialHymns = [
  Hymn(number: 114, title: "Tunezezwa n'iby'iyisi"),
  Hymn(number: 115, title: 'Mbese tuzahurirayo'),
  Hymn(number: 116, title: 'Abakunda Yesu bakamwizera'),
  Hymn(number: 117, title: 'Kuri wa munsi tuzazukaho'),
  Hymn(number: 118, title: "Mw'ijuru mw'ijuru"),
  Hymn(number: 119, title: 'Ni hehe abizera bazajya kuba'),
  Hymn(number: 120, title: "Ubw'Impanda z'Uwiteka"),
  Hymn(number: 121, title: 'Harih\'indi si nziza cyane'),
  Hymn(number: 122, title: "Ubwo nzamar'imirimo"),
  Hymn(number: 123, title: "Ni igihe git'intambar'igashira"),
  Hymn(number: 124, title: "Mw'ijuru hariho isi nziza"),
];

// ---------------------------------------------------------------------------
// CATEGORY XV — GUSENGA MU GITONDO / MORNING PRAYER  (7 hymns, #125–131)
// ---------------------------------------------------------------------------
const List<Hymn> _morningHymns = [
  Hymn(number: 125, title: 'Tubyuke kare cyane'),
  Hymn(number: 126, title: 'Buri munsi mu gitondo'),
  Hymn(number: 127, title: 'Ndagushimira Mana'),
  Hymn(number: 128, title: 'Dukanguke Dukanguke'),
  Hymn(number: 129, title: 'Ibikorwa byanjye byose'),
  Hymn(number: 130, title: "Dushim'Imana twes'abayikunda"),
  Hymn(number: 131, title: "Duhimbaz'Uwitek'Imana"),
];

// ---------------------------------------------------------------------------
// CATEGORY XVI — GUSENGA NIMUGOROBA / EVENING PRAYER  (8 hymns, #132–139)
// ---------------------------------------------------------------------------
const List<Hymn> _eveningHymns = [
  Hymn(number: 132, title: 'Uko bwije buri munsi'),
  Hymn(number: 133, title: 'Mukiza ni wowe zuba ryanjye'),
  Hymn(number: 134, title: "Mfashwe n'umunaniro"),
  Hymn(number: 135, title: "Mwam'ubugingo bwacu"),
  Hymn(number: 136, title: 'Izuba rirarenze'),
  Hymn(number: 137, title: 'Iri joro Mana yanjye'),
  Hymn(number: 138, title: "Kuv'ubu sintiny'ibizab'ejo"),
  Hymn(number: 139, title: 'Mwami vuga nanjye ndumva'),
];

// ---------------------------------------------------------------------------
// CATEGORY XVII — GUSENGA IBIHE BYOSE / ALL SEASONS PRAYER  (18 hymns, #140–157)
// ---------------------------------------------------------------------------
const List<Hymn> _allSeasonsHymns = [
  Hymn(number: 140, title: 'Uduhagarare hagati Mukiza'),
  Hymn(number: 141, title: 'Ntumpiteho Mukiza'),
  Hymn(number: 142, title: 'Udushobozе Mukiza'),
  Hymn(number: 143, title: "Unjy'imbere Man'isumbaby ose"),
  Hymn(number: 144, title: 'Ai Mukunzi wanjye we'),
  Hymn(number: 145, title: "Ibihe nseng'Uwiteka"),
  Hymn(number: 146, title: 'Muze mwenyine twihererane'),
  Hymn(number: 147, title: 'Mutabazi wacu Yesu'),
  Hymn(number: 148, title: "Nimweger'Umwami"),
  Hymn(number: 149, title: 'Mu gihe cyo gusenga'),
  Hymn(number: 150, title: "Mp'amavuta Yesu mbone kwaka"),
  Hymn(number: 151, title: "Ai Mana y'ukuri komeza"),
  Hymn(number: 152, title: 'Harihw\'icyo nkwaka Mwami'),
  Hymn(number: 153, title: 'Yesu niwe nshuti yacu'),
  Hymn(number: 154, title: "Ngwino soko y'umugisha"),
  Hymn(number: 155, title: 'Umpe kukwegera Mana yanjye'),
  Hymn(number: 156, title: "Ntimukifuz'iby'iyisi"),
  Hymn(number: 157, title: "Mutabaz'ubuntu bwawe"),
];

// ---------------------------------------------------------------------------
// CATEGORY XVIII — KWICUZA NO GUSABA IMBABAZI / REPENTANCE  (14 hymns, #158–171)
// ---------------------------------------------------------------------------
const List<Hymn> _repentanceHymns = [
  Hymn(number: 158, title: 'Ngirir\'ubuntu Mukiza'),
  Hymn(number: 159, title: "Ngwino zan'ibyaha byawe"),
  Hymn(number: 160, title: "Umukuru w'Abatambyi"),
  Hymn(number: 161, title: 'Hagarara Munyabyaha'),
  Hymn(number: 162, title: 'Nshuti yanjye uri hehe'),
  Hymn(number: 163, title: "Imbabazi z'Umukiza"),
  Hymn(number: 164, title: 'Ndagutakambira Mwami'),
  Hymn(number: 165, title: "Utegerej'iki se ncuti?"),
  Hymn(number: 166, title: 'Yesu tuguhungiyeho'),
  Hymn(number: 167, title: "Mbane naw'iteka mukiza"),
  Hymn(number: 168, title: 'Yesu mukiza ntabara'),
  Hymn(number: 169, title: "Ubu nj'uko ndi niringiye"),
  Hymn(number: 170, title: "Mwunger'udukunda jy'uturagira"),
  Hymn(number: 171, title: "Ayi Mana ndondor'umenye"),
];

// ---------------------------------------------------------------------------
// CATEGORY XIX — GUSHIMA IMANA / PRAISE  (22 hymns, #172–193)
// ---------------------------------------------------------------------------
const List<Hymn> _praiseHymns = [
  Hymn(number: 172, title: "Muze dushim'Uwiteka"),
  Hymn(number: 173, title: "Muze dushimir'Imana"),
  Hymn(number: 174, title: "Dushim'Iman'Ihoraho"),
  Hymn(number: 175, title: "Mwa bari mw'isi yose mwe"),
  Hymn(number: 176, title: 'Mwami turagushima'),
  Hymn(number: 177, title: 'Imana yarambabariye'),
  Hymn(number: 178, title: "Reka nshim'Umwami Yesu"),
  Hymn(number: 179, title: 'Yesu ni wowe dushima'),
  Hymn(number: 180, title: 'Mana Rurema ndagushima'),
  Hymn(number: 181, title: 'Ushimwe Mana ko wampaye Yesu'),
  Hymn(number: 182, title: "Yaba narinz'indimi nyinshi"),
  Hymn(number: 183, title: 'Yesu yageze mu Rwanda'),
  Hymn(number: 184, title: 'Iteka nagendaga ndemerewe'),
  Hymn(number: 185, title: 'Ndashima cyane Yesu'),
  Hymn(number: 186, title: "Nshim'Umwami wo mw'ijuru"),
  Hymn(number: 187, title: "Yes'ashimwe turamushim'umukiza"),
  Hymn(number: 188, title: 'Wa mutima wanjye we'),
  Hymn(number: 189, title: 'Shimwa mwami Yesu ko wamviriye'),
  Hymn(number: 190, title: "Habay'umunsi w'ishimwe mw'ijuru"),
  Hymn(number: 191, title: 'Ndagushimiye Mukiza'),
  Hymn(number: 192, title: "Mwami mwiza w'ijuru"),
  Hymn(number: 193, title: "Dushim'Uwiteka"),
];

// ---------------------------------------------------------------------------
// CATEGORY XX — GUHAMYA / TESTIMONY  (43 hymns, #194–236)
// ---------------------------------------------------------------------------
const List<Hymn> _testimonyHymns = [
  Hymn(number: 194, title: 'Uwiteka ni umunyambabazi'),
  Hymn(number: 195, title: 'Imana ni ubuhungiro'),
  Hymn(number: 196, title: 'Sinzava kuri Yesu'),
  Hymn(number: 197, title: "Dor'Umukiza w'igitangaza"),
  Hymn(number: 198, title: 'Yesu ndagukunda cyane'),
  Hymn(number: 199, title: 'Jye mpisemo Yesu'),
  Hymn(number: 200, title: "Nubwo nsazwe n'ibyaha"),
  Hymn(number: 201, title: 'Yesu ntahinduka'),
  Hymn(number: 202, title: 'Jye ndi umukristo'),
  Hymn(number: 203, title: 'Kugukunda mwami Yesu'),
  Hymn(number: 204, title: 'Nishimiye ko menye rwose'),
  Hymn(number: 205, title: "Nari kure y'Imana mu ngoyi"),
  Hymn(number: 206, title: 'Kubana na Yesu iteka'),
  Hymn(number: 207, title: "Mwa bitang'igicuri mwe"),
  Hymn(number: 208, title: 'Nishimiye ko Data'),
  Hymn(number: 209, title: 'Azamanuka mu bicu'),
  Hymn(number: 210, title: "Imbata ya Yes' igira"),
  Hymn(number: 211, title: "Ubuntu bw'Imana"),
  Hymn(number: 212, title: 'Igituma nkunda Yesu'),
  Hymn(number: 213, title: 'Nkunda kwizigira Yesu'),
  Hymn(number: 214, title: "Nabony'umukunzi mwiza"),
  Hymn(number: 215, title: "Iby'Iman'ikora"),
  Hymn(number: 216, title: "Nari mboshywe rwose n'umwanzi"),
  Hymn(number: 217, title: "Nzi ko umukiz'ankunda"),
  Hymn(number: 218, title: "Igitabo cy'Imana"),
  Hymn(number: 219, title: 'Mwami ndi uwawe Uri uwanjye'),
  Hymn(number: 220, title: 'Yesu ni ubugingo bwacu'),
  Hymn(number: 221, title: 'Yesu ni umukiza ndamwiringiye'),
  Hymn(number: 222, title: "Iby'isi Yesu yabinkuyemo"),
  Hymn(number: 223, title: 'Twarabatuwe rwose'),
  Hymn(number: 224, title: "Ndumva ko umutim'ucyeye"),
  Hymn(number: 225, title: 'Dukomeze gutambuka'),
  Hymn(number: 226, title: 'Ubwo nagendaga ndemerewe'),
  Hymn(number: 227, title: "Numva Yes'anyemeza"),
  Hymn(number: 228, title: "Ngiy'inkuru twumvise"),
  Hymn(number: 229, title: 'Yesu ni wowe musa mbonyemo'),
  Hymn(number: 230, title: 'Ibyaha byanjye Yesu yarabyikoreye'),
  Hymn(number: 231, title: 'Umutwaro wanjye Kristo yarayikoreye'),
  Hymn(number: 232, title: "Jyan'umucyo mur'Afurika"),
  Hymn(number: 233, title: "Sinzibagirw'igihe nakizwaga"),
  Hymn(number: 234, title: 'Nemeye gukurikira Yesu'),
  Hymn(number: 235, title: 'Yesu niwe nihishemo'),
  Hymn(number: 236, title: "Uburyo Yes'ankunda"),
];

// ---------------------------------------------------------------------------
// CATEGORY XXI — IZINA RYA YESU / NAME OF JESUS  (4 hymns, #237–240)
// ---------------------------------------------------------------------------
const List<Hymn> _nameOfJesusHymns = [
  Hymn(number: 237, title: 'Izina ryiza rihebuje'),
  Hymn(number: 238, title: 'Izina rya Yesu turaryubaha'),
  Hymn(number: 239, title: "Mw'isi yacu no mw'ijuru"),
  Hymn(number: 240, title: 'Aba Yesu bishimira'),
];

// ---------------------------------------------------------------------------
// CATEGORY XXII — GUSINGIZA NO GUHIMBAZ'IMANA / GLORIFICATION  (18 hymns, #241–258)
// ---------------------------------------------------------------------------
const List<Hymn> _glorificationHymns = [
  Hymn(number: 241, title: "Nimwireber'iyo ntwari"),
  Hymn(number: 242, title: 'Wowe Mana ndaguhimbaza'),
  Hymn(number: 243, title: "Yes'ur'Umukiza wanjye"),
  Hymn(number: 244, title: "Nzaririmb'igitangaza"),
  Hymn(number: 245, title: 'Ijuru ryawe Mana riraguhimbaza'),
  Hymn(number: 246, title: 'Ngukunde Yesu mwami wanjye'),
  Hymn(number: 247, title: 'Muganga wacu ni Yesu'),
  Hymn(number: 248, title: "Haleluya haj'umunsi"),
  Hymn(number: 249, title: 'Reka twongere twishimire'),
  Hymn(number: 250, title: "Ibyaha byanjye byose n'ibyago"),
  Hymn(number: 251, title: "Mpimbariz'Iman'ibyo yankoreye"),
  Hymn(number: 252, title: "Nagir'indim'igihumbi"),
  Hymn(number: 253, title: 'Ngaho mutima wanjye'),
  Hymn(number: 254, title: 'Bartimayo utabonaga'),
  Hymn(number: 255, title: 'Yesu mulokozi wange'),
  Hymn(number: 256, title: 'Mu ijuru hariyo amahoro menshi'),
  Hymn(number: 257, title: "Nimuze tureb'imbere"),
  Hymn(number: 258, title: 'Haguruka haguruka'),
];

// ---------------------------------------------------------------------------
// CATEGORY XXIII — YESU ARADUTEGEEREJE MW'IJURU  (16 hymns, #259–274)
// ---------------------------------------------------------------------------
const List<Hymn> _jesusWaitsHymns = [
  Hymn(number: 259, title: "Dor'isoko y'amazi meza"),
  Hymn(number: 260, title: "Numvise Yes'ambwir'ati:"),
  Hymn(number: 261, title: 'Nimuze dusange Yesu'),
  Hymn(number: 262, title: "Muze musange Yes'ubakunda"),
  Hymn(number: 263, title: "Mbe ntiwaturw'ibyo byaha byawe"),
  Hymn(number: 264, title: "Umv'iryo jwi rikwinginga"),
  Hymn(number: 265, title: "Ab'Umwami yacunguye"),
  Hymn(number: 266, title: 'Yes\' araduhamagara'),
  Hymn(number: 267, title: "Numva Yes'ampamagara"),
  Hymn(number: 268, title: 'Ubwo nari nsinjirijwe cyane'),
  Hymn(number: 269, title: 'Iyo ntinye ko kwizera kwanjye'),
  Hymn(number: 270, title: 'Kwa data mu ijuru ntawubabara'),
  Hymn(number: 271, title: "Iyi si turimo n'iy'ibyago"),
  Hymn(number: 272, title: "Tumeny'ubwami buri mw'ijuru"),
  Hymn(number: 273, title: "Kera har'umubibyi wasohoy'imbuto"),
  Hymn(number: 274, title: "Muriyo nzir'iruhije"),
];

// ---------------------------------------------------------------------------
// CATEGORY XXIX — KWITABA YESU / ANSWERING JESUS  (14 hymns, #275–288)
// ---------------------------------------------------------------------------
const List<Hymn> _answeringJesusHymns = [
  Hymn(number: 275, title: "Shobuj'uguhamagara"),
  Hymn(number: 276, title: 'Nyakir\'uko ndi Mukiza'),
  Hymn(number: 277, title: "Umwami Yes'agirati:"),
  Hymn(number: 278, title: "Muze ku mwami w'ubugingo"),
  Hymn(number: 279, title: "Dor'inzir'ijya mw'ijuru"),
  Hymn(number: 280, title: 'Mwami Yesu turaje'),
  Hymn(number: 281, title: "Mwa bagore b'I Rwanda"),
  Hymn(number: 282, title: 'Bene data bizeye Yesu'),
  Hymn(number: 283, title: 'Ngwino witabe Yesu'),
  Hymn(number: 284, title: "Mukiza numvis'ijwi"),
  Hymn(number: 285, title: 'Uhagaze Mukiza'),
  Hymn(number: 286, title: "Nsiz'ububata n'umwijima"),
  Hymn(number: 287, title: 'Mwami wahamagaye'),
  Hymn(number: 288, title: 'Nimuze mwa ndushyi mwe'),
];

// ---------------------------------------------------------------------------
// CATEGORY XXX — TURWANE INTAMBARA NZIZA / SPIRITUAL WARFARE  (12 hymns, #289–300)
// ---------------------------------------------------------------------------
const List<Hymn> _warfareHymns = [
  Hymn(number: 289, title: "Uzajy'urwan'intambara"),
  Hymn(number: 290, title: 'Nimuze ngabo za Yesu'),
  Hymn(number: 291, title: 'Bayoboke mubyuke'),
  Hymn(number: 292, title: 'Basirikare ba Kristo'),
  Hymn(number: 293, title: "Dor'ibendera ya Yesu"),
  Hymn(number: 294, title: 'Urwan\'intambara nziza'),
  Hymn(number: 295, title: "Har'uwitwa Danieli"),
  Hymn(number: 296, title: "Uwab'atinyutse ibyago"),
  Hymn(number: 297, title: "Yemw'abari kuri Yesu"),
  Hymn(number: 298, title: "Mwa ngabo z'Umwami mwe"),
  Hymn(number: 299, title: "Nind'uzarwanana n'Umwami Yesu"),
  Hymn(number: 300, title: 'Utinyuke kuyoborwa'),
];

// ---------------------------------------------------------------------------
// CATEGORY XXXI — UBUMWE BW'ABAKRISTO / CHRISTIAN UNITY  (8 hymns, #301–308)
// ---------------------------------------------------------------------------
const List<Hymn> _unityHymns = [
  Hymn(number: 301, title: "Twebwe twese tur'ingingo"),
  Hymn(number: 302, title: 'Umwami wacu Yesu niwe'),
  Hymn(number: 303, title: 'Mukiza wadutoreye kuba'),
  Hymn(number: 304, title: 'Hose habera heza inshuti'),
  Hymn(number: 305, title: 'Mwami wanjye nshaka kuba'),
  Hymn(number: 306, title: 'Ndashaka gusa nawe Yesu'),
  Hymn(number: 307, title: "Nunguk'ubuntu bwa Yesu"),
  Hymn(number: 308, title: "Gukundana kw'aba Yesu"),
];

// ---------------------------------------------------------------------------
// CATEGORY XXXII — URUKUNDO RW'IMANA / GOD'S LOVE  (9 hymns, #309–317)
// ---------------------------------------------------------------------------
const List<Hymn> _godsLoveHymns = [
  Hymn(number: 309, title: 'Urukundo rwa Yesu nzi ko'),
  Hymn(number: 310, title: "Yesu arush'abandi bose"),
  Hymn(number: 311, title: 'Hari umukunzi nka Yesu wacu'),
  Hymn(number: 312, title: 'Ninde ufite urukundo'),
  Hymn(number: 313, title: "Mureb'urukundo rukomeye cyane"),
  Hymn(number: 314, title: "Nari meze nk'intama"),
  Hymn(number: 315, title: "Mbeg'urukundo rw'Imana yacu"),
  Hymn(number: 316, title: "Niboney'Urukundo"),
  Hymn(number: 317, title: 'Urukundo rwa Yesu koko'),
];

// ---------------------------------------------------------------------------
// CATEGORY XXXIII — IZ'ABANA / CHILDREN'S HYMNS  (9 hymns, #318–326)
// ---------------------------------------------------------------------------
const List<Hymn> _childrenHymns = [
  Hymn(number: 318, title: 'Ndi agatama ka Yesu'),
  Hymn(number: 319, title: 'Amaboko yawe Yesu'),
  Hymn(number: 320, title: "Bana mw'ijuru abiringiy'Umucunguzi"),
  Hymn(number: 321, title: "Hari ubw'Abagore"),
  Hymn(number: 322, title: 'Umwami Yesu Kristo'),
  Hymn(number: 323, title: 'Bana ntimugire icyaha'),
  Hymn(number: 324, title: 'Yesu Mwungeri wanjye'),
  Hymn(number: 325, title: 'Nubwo ndi umwana muto'),
  Hymn(number: 326, title: 'Mumushime bana bato'),
];

// ---------------------------------------------------------------------------
// CATEGORY XXXIV — KUGARUKA KWA YESU / SECOND COMING  (5 hymns, #327–331)
// ---------------------------------------------------------------------------
const List<Hymn> _secondComingHymns = [
  Hymn(number: 327, title: "Ubw'umwami Yes'azaza"),
  Hymn(number: 328, title: "Murinzi we menyesh'igihe"),
  Hymn(number: 329, title: "Umwam'ageze kw' irembo"),
  Hymn(number: 330, title: "Dor'is'ukunt'ikwifuza"),
  Hymn(number: 331, title: "Yemw'abasubir'iyo muva"),
];

// ---------------------------------------------------------------------------
// CATEGORY XXXV — AMASARURA / HARVEST  (4 hymns, #332–335)
// ---------------------------------------------------------------------------
const List<Hymn> _harvestHymns = [
  Hymn(number: 332, title: "Kor'ugifit'uburyo"),
  Hymn(number: 333, title: 'Biba mu gitondo'),
  Hymn(number: 334, title: "Umurima w'Imana ureze"),
  Hymn(number: 335, title: 'Twe turahinga gusa'),
];

// ---------------------------------------------------------------------------
// CATEGORY XXXVI — GUSEZERANAHO / FAREWELL  (4 hymns, #336–339)
// ---------------------------------------------------------------------------
const List<Hymn> _farewellHymns = [
  Hymn(number: 336, title: "Ngaho mugend'amahoro"),
  Hymn(number: 337, title: 'Iki gihe twamaranye'),
  Hymn(number: 338, title: 'Yemwe nshuti twabanye'),
  Hymn(number: 339, title: "Abakund'Imana mwese"),
];

// ---------------------------------------------------------------------------
// CATEGORY XXXVII — GUHUMURIZWA / COMFORT  (12 hymns, #340–351)
// ---------------------------------------------------------------------------
const List<Hymn> _comfortHymns = [
  Hymn(number: 340, title: "Ntukajy'urambirwa kumwizera"),
  Hymn(number: 341, title: 'Ntabwo nkwiye kujya niganyira'),
  Hymn(number: 342, title: "Iy'urushye iy'uremerewe"),
  Hymn(number: 343, title: "Yemwe mwes'abananiwe"),
  Hymn(number: 344, title: 'We mutim\'urira uze kwa Yesu'),
  Hymn(number: 345, title: "Ubw'Iman'idukunda"),
  Hymn(number: 346, title: "Yemwe mwa bushyo bw'Imana"),
  Hymn(number: 347, title: "Amahoro Yesu ah'abantu be"),
  Hymn(number: 348, title: "Iy'utewe n'amakub'akomeye"),
  Hymn(number: 349, title: 'Uwishinze ku byasezeranijwe'),
  Hymn(number: 350, title: "Ubw'Umwami Yes Yes'ankunda"),
  Hymn(number: 351, title: "Jye mfit'Umukiz'ujyamvugira"),
];

// ---------------------------------------------------------------------------
// CATEGORY XXXVIII — AMATURO / OFFERINGS  (4 hymns, #352–355)
// ---------------------------------------------------------------------------
const List<Hymn> _offeringHymns = [
  Hymn(number: 352, title: 'Nubwo wagira bike'),
  Hymn(number: 353, title: 'Kugukorera ni byiza'),
  Hymn(number: 354, title: 'Nyigiza hafi mwami Yesu'),
  Hymn(number: 355, title: 'Yesu Mukiza wanjye'),
];

// ---------------------------------------------------------------------------
// CATEGORY XXXIX — IZINDI / GENERAL  (59 hymns, #356–414)
// ---------------------------------------------------------------------------
const List<Hymn> _generalHymns = [
  Hymn(number: 356, title: "Nind'utegek'ibi byose"),
  Hymn(number: 357, title: "Mwam'utuvubir'imvura"),
  Hymn(number: 358, title: 'Tuzagusingiza dute?'),
  Hymn(number: 359, title: "Ubuntu bw'umwami"),
  Hymn(number: 360, title: "Wiber'iwacu Mwami"),
  Hymn(number: 361, title: 'Ijambo ry\'Imana riraguhamagara'),
  Hymn(number: 362, title: "Jambo ry'Imana jy'imbere"),
  Hymn(number: 363, title: 'Emera mutima wanjye'),
  Hymn(number: 364, title: 'Yesu niwe Muyobozi'),
  Hymn(number: 365, title: 'Mana nkuko wafashaga'),
  Hymn(number: 366, title: "Mbwir'amgambo ya Yesu"),
  Hymn(number: 367, title: 'Uhereye kera kose'),
  Hymn(number: 368, title: 'Mana nduburiramaso yanjye'),
  Hymn(number: 369, title: "Yesu yatwis'amatabaza ye"),
  Hymn(number: 370, title: 'Iminsi irahita vuba'),
  Hymn(number: 371, title: 'Abantu benshi cyane'),
  Hymn(number: 372, title: "Singishak'ubutunzi"),
  Hymn(number: 373, title: 'Mwisi ndi umushyitsi'),
  Hymn(number: 374, title: "Har'intama urwenda n'icyenda"),
  Hymn(number: 375, title: "Tunganir'Imana ubudasiba"),
  Hymn(number: 376, title: "Twebw'abasiganirwa"),
  Hymn(number: 377, title: 'Ai Data wo mu ijuru'),
  Hymn(number: 378, title: "Intumwa z'umwami Yesu"),
  Hymn(number: 379, title: "Urutare rw'Imana"),
  Hymn(number: 380, title: 'Wa gatabaza kanjye we'),
  Hymn(number: 381, title: "Har'umwami wa kera"),
  Hymn(number: 382, title: 'Habay\'umuntu twizeho'),
  Hymn(number: 383, title: 'Kera narabatijwe'),
  Hymn(number: 384, title: "Abakund'ibyisi"),
  Hymn(number: 385, title: "Abo mur'i yis'izashira"),
  Hymn(number: 386, title: "Teg'amatwi wumve"),
  Hymn(number: 387, title: "Jyuhor'undinganirije"),
  Hymn(number: 388, title: 'Ndakwizeye Yesu'),
  Hymn(number: 389, title: 'Ngwino mutima wanjye'),
  Hymn(number: 390, title: 'Nijye nijye gusa'),
  Hymn(number: 391, title: "Bene wacu bo mw'isi"),
  Hymn(number: 392, title: 'Ndeger\'umusaraba naniwe'),
  Hymn(number: 393, title: 'Amasezerano yose'),
  Hymn(number: 394, title: 'Mana Data wa twese'),
  Hymn(number: 395, title: 'Ni Yesu wangize kuba'),
  Hymn(number: 396, title: 'Inzu yawe Mana'),
  Hymn(number: 397, title: "Kera nari mw'isayo"),
  Hymn(number: 398, title: "Mukiz'utuboneze"),
  Hymn(number: 399, title: 'Mwami ndakwimitse wime'),
  Hymn(number: 400, title: 'Imana niyo mwungeri'),
  Hymn(number: 401, title: "Impara yaguy'umwuma"),
  Hymn(number: 402, title: 'Genda mu mucyo wa Yesu'),
  Hymn(number: 403, title: 'Ngwino mwami wacu Yesu'),
  Hymn(number: 404, title: "Har'umurwa mwiza"),
  Hymn(number: 405, title: "Dor'Abera bo mw'ijuru"),
  Hymn(number: 406, title: "Muhimbaz'Uwiteka"),
  Hymn(number: 407, title: "Man'ishobora byose"),
  Hymn(number: 408, title: 'Mbumbatiwe nawe Yesu'),
  Hymn(number: 409, title: 'Yesu niwe mucyo'),
  Hymn(number: 410, title: "Ukunda kujy'ambabarira"),
  Hymn(number: 411, title: "Tugiy'iwacu mw'ijuru"),
  Hymn(number: 412, title: "Umwam'agaby'ingabo ze"),
  Hymn(number: 413, title: 'Icyampa ukanyikorerera'),
  Hymn(number: 414, title: "Imbabazi z'Umwami Yesu"),
];

// ---------------------------------------------------------------------------
// MASTER CATEGORY LIST
// ---------------------------------------------------------------------------

const List<HymnCategory> hymnCategories = [
  HymnCategory(
    id: 'advent',
    titleRw: 'I. ADVENT: GUTEGEREZA UMUKIZA',
    titleEn: 'I. Advent: Waiting for the Saviour',
    hymns: _adventHymns,
  ),
  HymnCategory(
    id: 'christmas',
    titleRw: 'II. KUVUKA KWA YESU / CHRISTMAS / NOHELI',
    titleEn: 'II. Birth of Jesus / Christmas',
    hymns: _christmasHymns,
  ),
  HymnCategory(
    id: 'new_year',
    titleRw: 'III. UMWAKA MUSHYA',
    titleEn: 'III. New Year',
    hymns: _newYearHymns,
  ),
  HymnCategory(
    id: 'epiphany',
    titleRw: "IV. EPIFANIYA (UMUCYO W'ISI)",
    titleEn: 'IV. Epiphany (Light of the World)',
    hymns: _epiphanyHymns,
  ),
  HymnCategory(
    id: 'passion',
    titleRw: 'V. KUBABAZWA NO GUPFA KWA YESU',
    titleEn: 'V. Suffering and Death of Jesus',
    hymns: _passionHymns,
  ),
  HymnCategory(
    id: 'easter',
    titleRw: 'VI. KUZUKA KWA YESU / PASIKA',
    titleEn: 'VI. Resurrection of Jesus / Easter',
    hymns: _easterHymns,
  ),
  HymnCategory(
    id: 'ascension',
    titleRw: 'VII. YESU ASUBIRA MU IJURU',
    titleEn: 'VII. Ascension of Jesus',
    hymns: _ascensionHymns,
  ),
  HymnCategory(
    id: 'pentecost',
    titleRw: "VIII. MWUKA WERA AMANUKIR'INTUMWA (PENTEKOSTE)",
    titleEn: 'VIII. Holy Spirit / Pentecost',
    hymns: _pentecostHymns,
  ),
  HymnCategory(
    id: 'trinity',
    titleRw: 'IX. UBUTATU BWERA',
    titleEn: 'IX. Holy Trinity',
    hymns: _trinityHymns,
  ),
  HymnCategory(
    id: 'baptism',
    titleRw: 'X. UMUBATIZO',
    titleEn: 'X. Baptism',
    hymns: _baptismHymns,
  ),
  HymnCategory(
    id: 'confirmation',
    titleRw: 'XI. GUKOMEZWA',
    titleEn: 'XI. Confirmation',
    hymns: _confirmationHymns,
  ),
  HymnCategory(
    id: 'communion',
    titleRw: 'XII. IFUNGURO RYERA',
    titleEn: 'XII. Holy Communion',
    hymns: _communionHymns,
  ),
  HymnCategory(
    id: 'wedding',
    titleRw: 'XIII. UBUKWE',
    titleEn: 'XIII. Wedding',
    hymns: _weddingHymns,
  ),
  HymnCategory(
    id: 'burial',
    titleRw: 'XIV. GUSHYINGURA / GUHAMBA',
    titleEn: 'XIV. Burial / Funeral',
    hymns: _burialHymns,
  ),
  HymnCategory(
    id: 'morning',
    titleRw: 'XV. GUSENGA MU GITONDO',
    titleEn: 'XV. Morning Prayer',
    hymns: _morningHymns,
  ),
  HymnCategory(
    id: 'evening',
    titleRw: 'XVI. GUSENGA NIMUGOROBA',
    titleEn: 'XVI. Evening Prayer',
    hymns: _eveningHymns,
  ),
  HymnCategory(
    id: 'all_seasons',
    titleRw: 'XVII. GUSENGA IBIHE BYOSE',
    titleEn: 'XVII. Prayer for All Seasons',
    hymns: _allSeasonsHymns,
  ),
  HymnCategory(
    id: 'repentance',
    titleRw: 'XVIII. KWICUZA NO GUSABA IMBABAZI',
    titleEn: 'XVIII. Repentance and Forgiveness',
    hymns: _repentanceHymns,
  ),
  HymnCategory(
    id: 'praise',
    titleRw: 'XIX. GUSHIMA IMANA',
    titleEn: 'XIX. Praise',
    hymns: _praiseHymns,
  ),
  HymnCategory(
    id: 'testimony',
    titleRw: 'XX. GUHAMYA',
    titleEn: 'XX. Testimony / Witness',
    hymns: _testimonyHymns,
  ),
  HymnCategory(
    id: 'name_of_jesus',
    titleRw: 'XXI. IZINA RYA YESU',
    titleEn: 'XXI. The Name of Jesus',
    hymns: _nameOfJesusHymns,
  ),
  HymnCategory(
    id: 'glorification',
    titleRw: "XXII. GUSINGIZA NO GUHIMBAZ'IMANA",
    titleEn: 'XXII. Glorification of God',
    hymns: _glorificationHymns,
  ),
  HymnCategory(
    id: 'jesus_waits',
    titleRw: "XXIII. YESU ARADUTEGEEREJE MW'IJURU",
    titleEn: 'XXIII. Jesus Invites Us to Heaven',
    hymns: _jesusWaitsHymns,
  ),
  HymnCategory(
    id: 'answering_jesus',
    titleRw: 'XXIX. KWITABA YESU',
    titleEn: 'XXIX. Answering the Call of Jesus',
    hymns: _answeringJesusHymns,
  ),
  HymnCategory(
    id: 'warfare',
    titleRw: 'XXX. TURWANE INTAMBARA NZIZA',
    titleEn: 'XXX. Fight the Good Fight',
    hymns: _warfareHymns,
  ),
  HymnCategory(
    id: 'unity',
    titleRw: "XXXI. UBUMWE BW'ABAKRISTO",
    titleEn: 'XXXI. Christian Unity',
    hymns: _unityHymns,
  ),
  HymnCategory(
    id: 'gods_love',
    titleRw: "XXXII. URUKUNDO RW'IMANA",
    titleEn: "XXXII. God's Love",
    hymns: _godsLoveHymns,
  ),
  HymnCategory(
    id: 'children',
    titleRw: "XXXIII. IZ'ABANA",
    titleEn: "XXXIII. Children's Hymns",
    hymns: _childrenHymns,
  ),
  HymnCategory(
    id: 'second_coming',
    titleRw: 'XXXIV. KUGARUKA KWA YESU',
    titleEn: 'XXXIV. Second Coming of Jesus',
    hymns: _secondComingHymns,
  ),
  HymnCategory(
    id: 'harvest',
    titleRw: 'XXXV. AMASARURA',
    titleEn: 'XXXV. Harvest',
    hymns: _harvestHymns,
  ),
  HymnCategory(
    id: 'farewell',
    titleRw: 'XXXVI. GUSEZERANAHO',
    titleEn: 'XXXVI. Farewell',
    hymns: _farewellHymns,
  ),
  HymnCategory(
    id: 'comfort',
    titleRw: 'XXXVII. GUHUMURIZWA',
    titleEn: 'XXXVII. Comfort',
    hymns: _comfortHymns,
  ),
  HymnCategory(
    id: 'offerings',
    titleRw: 'XXXVIII. AMATURO',
    titleEn: 'XXXVIII. Offerings',
    hymns: _offeringHymns,
  ),
  HymnCategory(
    id: 'general',
    titleRw: 'XXXIX. IZINDI',
    titleEn: 'XXXIX. General',
    hymns: _generalHymns,
  ),
];

// ---------------------------------------------------------------------------
// HELPER FUNCTIONS
// ---------------------------------------------------------------------------

/// Returns a flat list of all 414 hymns.
List<Hymn> get allHymns =>
    hymnCategories.expand((cat) => cat.hymns).toList();

/// Find a hymn by its number (1–414).
Hymn? hymnByNumber(int number) {
  for (final cat in hymnCategories) {
    for (final hymn in cat.hymns) {
      if (hymn.number == number) return hymn;
    }
  }
  return null;
}

/// Find the category that contains a given hymn number.
HymnCategory? categoryForHymn(int number) {
  for (final cat in hymnCategories) {
    if (cat.hymns.any((h) => h.number == number)) return cat;
  }
  return null;
}

/// Search hymns by title (case-insensitive, partial match).
List<Hymn> searchHymns(String query) {
  final q = query.toLowerCase();
  return allHymns
      .where((h) => h.title.toLowerCase().contains(q))
      .toList();
}
