// lib/core/data/liturgy_data.dart
// Structured liturgy data for the Lutheran Church of Rwanda (LCR)
// Source: GAHUNDA Y'AMATERANIRO (Worship Guide) — Kinyarwanda

class LiturgyResponse {
  final String leader;       // What the leader says (Umushumba/Bose)
  final String congregation; // What the congregation says (Abakristu/Bose)
  const LiturgyResponse({required this.leader, required this.congregation});
}

class LiturgyLine {
  final String speaker; // 'Umushumba', 'Abakristu', 'Bose', 'Note'
  final String text;
  const LiturgyLine({required this.speaker, required this.text});
}

class LiturgySection {
  final String title;
  final List<LiturgyLine> lines;
  const LiturgySection({required this.title, required this.lines});
}

class LiturgyService {
  final String id;
  final String titleRw;    // Kinyarwanda title
  final String titleEn;    // English title
  final String description;
  final List<LiturgySection> sections;
  final String icon;
  const LiturgyService({
    required this.id,
    required this.titleRw,
    required this.titleEn,
    required this.description,
    required this.sections,
    required this.icon,
  });
}

// ---------------------------------------------------------------------------
// Service data
// ---------------------------------------------------------------------------

const List<LiturgySection> _sundayServiceSections = [
  // 1. IMYITEGURO — Preparation
  LiturgySection(
    title: 'IMYITEGURO (Preparation)',
    lines: [
      LiturgyLine(
        speaker: 'Note',
        text: 'Itorero riritererana mu mahoro. Umushumba ajya ku gicumbi.',
      ),
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Mu izina rya Data wa twese n\'iry\'Umwana n\'iry\'Umwuka Wera. Amen.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen.'),
      LiturgyLine(
        speaker: 'Umushumba',
        text: 'Uwiteka Imana ari kumwe natwe.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Ibe mu mutima wawe.'),
    ],
  ),

  // 2. KWATURA IBICUMURO — Confession
  LiturgySection(
    title: 'KWATURA IBICUMURO (Confession of Sins)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Bavandimwe, tujye imbere y\'Imana twatura ibicumuro byacu, kugira ngo tubabarirwe.',
      ),
      LiturgyLine(
        speaker: 'Note',
        text: 'Abantu bose bajya hasi cyangwa baramye.',
      ),
      LiturgyLine(
        speaker: 'Bose',
        text:
            'Mana ishobora byose, Data wa twese w\'imbabazi nyinshi. Njyewe umunyantege nke n\'umunyabyaha, ndicuza imbere yawe, ibicumuro byose nakoze mu bitekerezo, mu magambo no mu bikorwa. Kuko ntahwema kukubabaza nkwiriye igihano cy\'iteka. Ariko ibyaha byanjye byose ndabyatuye kandi mbyihanye byukuri. Ndakwinginze kubw\'ubuntu bwawe bwinshi ungirire imbabazi, unkize, umpe umwuka wawe wera ngire imyifatire mishya. Amen.',
      ),
    ],
  ),

  // 3. KUBABARIRWA IBYAHA — Absolution
  LiturgySection(
    title: 'KUBABARIRWA IBYAHA (Absolution)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Imana nyir\'imbabazi n\'ubushobozi bwose, yatugiriye ibambe, iduha umwana wayo w\'ikinege Yesu Kristo ngo adupfire ku musaraba, ku bw\'izina rye itubabariye ibyaha byacu byose. Amen.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen.'),
    ],
  ),

  // 4. MANA UTUBABARIRE / KYRIE
  LiturgySection(
    title: 'MANA UTUBABARIRE / KYRIE (Kyrie)',
    lines: [
      LiturgyLine(speaker: 'Umushumba', text: 'Dusabe Imana mu mahoro.'),
      LiturgyLine(speaker: 'Bose', text: 'Mwami tubabarire.'),
      LiturgyLine(
        speaker: 'Umushumba',
        text: 'Dusabe dushyize hamwe amahoro n\'agakiza k\'Imana.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Mwami tubabarire.'),
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Dusabe Imana dutuye mu mutima wayo, ngo itudufashe mu bihe byose.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Mwami tubabarire.'),
      LiturgyLine(
        speaker: 'Umushumba',
        text: 'Imana mana ishobora byose, ihore itubabarira.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen.'),
    ],
  ),

  // 5. ICYUBAHIRO CY'IMANA / GLORIA
  LiturgySection(
    title: 'ICYUBAHIRO CY\'IMANA / GLORIA (Gloria)',
    lines: [
      LiturgyLine(
        speaker: 'Bose',
        text:
            'Icyubahiro ni cy\'Imana iri mu ijuru. '
            'Amahoro abe mu isi mu bantu yishimira. '
            'Imana yacu ihimbazwe, ishimwe ribe iryayo, '
            'kubera ubuntu bwayo ihora itugirira. '
            'Imana iradukunda niyo mpamvu yaduhaye gushyikirana iteka.',
      ),
    ],
  ),

  // 6. INDAMUTSO N'ISENGESHO
  LiturgySection(
    title: 'INDAMUTSO N\'ISENGESHO (Salutation and Collect)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text: 'Uwiteka Imana ari kumwe natwe.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Ibe mu mutima wawe.'),
      LiturgyLine(speaker: 'Umushumba', text: 'Tusenga.'),
      LiturgyLine(
        speaker: 'Note',
        text:
            'Umushumba asoma isengesho ry\'umunsi (collect), arangiza agira ati:',
      ),
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            '...kubw\'Umwana wawe Yesu Kristo umwami wacu, uzima kandi ubusoze n\'umwuka wera Imana imwe iteka ryose.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen.'),
    ],
  ),

  // 7. IJAMBO RY'IMANA — Word of God
  LiturgySection(
    title: 'IJAMBO RY\'IMANA (Word of God)',
    lines: [
      LiturgyLine(
        speaker: 'Note',
        text: 'Umuntu washinzwe gusoma Urwandiko rwa mbere (Inzira yo kuri) asoma.',
      ),
      LiturgyLine(
        speaker: 'Umusomyi',
        text: 'Urwandiko rwa mbere rwasomwe. (Amasomo avuga)',
      ),
      LiturgyLine(
        speaker: 'Bose',
        text: 'Imana ngira ngo ikuze.',
      ),
    ],
  ),

  // 8. URWANDIKO, INDIRIMBO, IVANJILI
  LiturgySection(
    title: 'URWANDIKO, INDIRIMBO, IVANJILI',
    lines: [
      LiturgyLine(
        speaker: 'Note',
        text:
            'Indirimbo y\'iyerekwa (Hallelujah cyangwa indirimbo y\'iyerekwa) iririmbwa.',
      ),
      LiturgyLine(
        speaker: 'Umushumba',
        text: 'Uwiteka Imana ari kumwe natwe.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Ibe mu mutima wawe.'),
      LiturgyLine(
        speaker: 'Umushumba',
        text: 'Ivanjili y\'Umwami Yesu Kristo nk\'uko Mutagatifu [N.] yayanditse.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Imana ngira ngo ikuze.'),
      LiturgyLine(
        speaker: 'Note',
        text: 'Ivanjili isomwa. Irangiye Umushumba agira ati:',
      ),
      LiturgyLine(
        speaker: 'Umushumba',
        text: 'Ivanjili y\'Umwami Yesu Kristo.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Imana ngira ngo ikuze.'),
      LiturgyLine(
        speaker: 'Note',
        text: 'Umushumba asakaza Ijambo ry\'Imana (indirimbo nyuma y\'isakaza).',
      ),
    ],
  ),

  // 9. KWEMERA KW'INTUMWA — Apostles' Creed
  LiturgySection(
    title: 'KWEMERA KW\'INTUMWA (Apostles\' Creed)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text: 'Twemere hamwe ukwizera kw\'intumwa.',
      ),
      LiturgyLine(
        speaker: 'Bose',
        text:
            'Nemera Imana Data wa twese ushobora byose, umuremyi w\'ijuru n\'isi.\n\n'
            'Nemera Yesu Kristo, Umwana we w\'ikinege, Umwami wacu, '
            'wasamwe inda kubw\'Umwuka Wera, akabyarwa n\'Umwari Mariya, '
            'akababazwa ku ngoma ya Pontio Pilato, akabambwa ku musaraba, '
            'agapfa, agahambwa, akamanuka ikuzimu mu bapfuye, '
            'ku munsi wa gatatu akazuka, akajya mu ijuru, '
            'yicaye iburyo bw\'Imana Data wa twese ishobora byose, '
            'niho azava, aje gucira imanza abazima n\'abapfuye.\n\n'
            'Nemera Umwuka Wera, itorero rimwe ry\'abera bose, '
            'ubumwe bw\'abera, kubabarirwa ibyaha, '
            'kuzuka k\'umubiri n\'ubugingo budashira. Amen.',
      ),
    ],
  ),

  // 10. GUSABIRA ABANTU BOSE — Intercessions
  LiturgySection(
    title: 'GUSABIRA ABANTU BOSE (Intercessions)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Bavandimwe, dusabire itorero, isi yose n\'ibiremwa byose.',
      ),
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Saba Imana ngo irinde itorero ryayo n\'abayobozi bayo bose...',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Umva isengesho ryacu, Mwami.'),
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Saba Imana ngo ihe amahoro igihugu cyacu n\'abayobozi ba leta...',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Umva isengesho ryacu, Mwami.'),
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Saba Imana ngo ifashe abarwayi, abakene, abafite agahinda n\'abagomba ngo babafashe...',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Umva isengesho ryacu, Mwami.'),
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Saba Imana ngo irinde uyu murryango w\'itorero n\'abo tukunda bose...',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Umva isengesho ryacu, Mwami.'),
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Mwami Data wa twese, dusabye byose bidukeneye. Wumva isengesho ryacu kubw\'Umwana wawe Yesu Kristo.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen.'),
    ],
  ),

  // 11. ISENGESHO RY'UMWAMI — Lord's Prayer
  LiturgySection(
    title: 'ISENGESHO RY\'UMWAMI (Lord\'s Prayer)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Dusenge nk\'uko Umwami wacu Yesu Kristo yatwigishije, tuvuge:',
      ),
      LiturgyLine(
        speaker: 'Bose',
        text:
            'Data wa twese uri mu ijuru, '
            'izina ryawe ryubahwe, '
            'ubwami bwawe buze, '
            'ibyushaka bibeho mu isi nkuko bibaho mu ijuru, '
            'uduhe ifunguro ryacu ry\'uyu munsi, '
            'utubabarire ibyaha byacu '
            'nkuko natwe tubabarira ababitugirira, '
            'ntuduhane mu bitwoshya, '
            'ahubwo udukize umubi, '
            'kuko ubwami n\'ubushobozi n\'icyubahiro ari Ibyawe, '
            'none n\'iteka ryose. Amina.',
      ),
    ],
  ),

  // 12. IMPEREKEZA / UMUGISHA — Benediction
  LiturgySection(
    title: 'IMPEREKEZA / UMUGISHA (Benediction)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text: 'Nimugende mu mahoro.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Imana ishimwe.'),
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Uwiteka aguhe umugisha akurinde.\n'
            'Uwiteka akubonekere akubabarire.\n'
            'Uwiteka akurebane impuhwe aguhe amahoro.\n'
            'Mu izina rya Data wa twese n\'iry\'Umwana, n\'iry\'Umwuka Wera. Amen.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen. Amen. Amen.'),
    ],
  ),
];

// ---------------------------------------------------------------------------
// 2. GUHAZWA — Holy Communion
// ---------------------------------------------------------------------------
const List<LiturgySection> _holyCommunionSections = [
  LiturgySection(
    title: 'GUSEZERANAHO (Greeting)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text: 'Amahoro abe muri mwe.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Abe mu mutima wawe.'),
    ],
  ),

  LiturgySection(
    title: 'PREFACE (Preface)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text: 'Mutunganye imitima.',
      ),
      LiturgyLine(
        speaker: 'Bose',
        text: 'Tuyitunganyirije Umwami.',
      ),
      LiturgyLine(
        speaker: 'Umushumba',
        text: 'Dushime Uwiteka Imana yacu.',
      ),
      LiturgyLine(
        speaker: 'Bose',
        text: 'Birakwiye kandi ni byiza.',
      ),
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Ni byiza, birakwiye, biraturusha kugushimira, kukuririmba, '
            'no gukuratira icyubahiro Data wa twese, Mana y\'iteka ryose, '
            'kubw\'Umwana wawe Umwami wacu Yesu Kristo...',
      ),
    ],
  ),

  LiturgySection(
    title: 'SANCTUS (Sanctus)',
    lines: [
      LiturgyLine(
        speaker: 'Bose',
        text:
            'Uri Uwera, Uri Uwera, Uri Uwera, '
            'Mwami Mana nyiringabo, '
            'mu ijuru n\'isi icyubahiro ni icyawe. '
            'Hoziyana mu ijuru, '
            'arahirwa uza mu izina ry\'Umwami, '
            'Hoziyana.',
      ),
    ],
  ),

  LiturgySection(
    title: 'AMAGAMBO Y\'ISEZERANO (Words of Institution)',
    lines: [
      LiturgyLine(
        speaker: 'Note',
        text: 'Umushumba asoma amagambo y\'isezerano.',
      ),
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'IJORO YAGAMBANIWEMO, UMWAMI WACU YESU YAFASHE UMUGATI, '
            'ARASHIMIRA, ARAWUMANYURA, AWUHA UMUGISHA, '
            'AWUHA ABIGISHWA BE AGIRA ATI: '
            'NIMWAKIRE MURYE, UYU NI UMUBIRI WANJYE UBATANGIWE, '
            'MUJYE MUKORA MUTYO KUGIRA NGO MUNYIBUKE.\n\n'
            'BAMAZE KURYA, AFATA IGIKOMBE, ARASHIMIRA, ABAHEREZA AVUGA ATI: '
            'NIMWAKIRE MUNYWEHO MWESE, '
            'AYO NI AMARASO YANJYE Y\'ISEZERANO RISHYA '
            'YAVUYE KUBWANYU NO KUBWA BENSHI '
            'KUGIRA NGO MUKIZW\'IBYAHA. '
            'UKO MUNYWEYEHO MUJYE MUNYIBUKA. AMEN.',
      ),
    ],
  ),

  LiturgySection(
    title: 'ISENGESHO RY\'UMWAMI (Lord\'s Prayer)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Dusenge nk\'uko Umwami wacu Yesu Kristo yatwigishije, tuvuge:',
      ),
      LiturgyLine(
        speaker: 'Bose',
        text:
            'Data wa twese uri mu ijuru, '
            'izina ryawe ryubahwe, '
            'ubwami bwawe buze, '
            'ibyushaka bibeho mu isi nkuko bibaho mu ijuru, '
            'uduhe ifunguro ryacu ry\'uyu munsi, '
            'utubabarire ibyaha byacu '
            'nkuko natwe tubabarira ababitugirira, '
            'ntuduhane mu bitwoshya, '
            'ahubwo udukize umubi, '
            'kuko ubwami n\'ubushobozi n\'icyubahiro ari Ibyawe, '
            'none n\'iteka ryose. Amina.',
      ),
    ],
  ),

  LiturgySection(
    title: 'AGNUS DEI',
    lines: [
      LiturgyLine(
        speaker: 'Bose',
        text:
            'Umwana w\'Imana, ukuraho ibyaha by\'isi, '
            'utubabarire.\n'
            'Umwana w\'Imana, ukuraho ibyaha by\'isi, '
            'utubabarire.\n'
            'Umwana w\'Imana, ukuraho ibyaha by\'isi, '
            'uduhe amahoro.',
      ),
    ],
  ),

  LiturgySection(
    title: 'GUTANGA UBUTEGETSI (Distribution)',
    lines: [
      LiturgyLine(
        speaker: 'Note',
        text:
            'Umushumba ahereza abakristu umubiri n\'amaraso ya Kristo, avuga:',
      ),
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Umubiri wa Kristo ubatanzwe kubwanyu. '
            'Amaraso ya Kristo yavuye kubwanyu.',
      ),
      LiturgyLine(
        speaker: 'Uwakiriye',
        text: 'Amen.',
      ),
    ],
  ),

  LiturgySection(
    title: 'GUSHIMIRA NYUMA Y\'ISAKRAMENTU (Post-Communion Thanksgiving)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text: 'Dushime Uwiteka Imana yacu.',
      ),
      LiturgyLine(
        speaker: 'Bose',
        text: 'Birakwiye kandi ni byiza.',
      ),
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Dusenge: Mwami Data wa twese wo mu ijuru, turagushimira byimazeyo '
            'kuko watugaburiye umubiri n\'amaraso y\'Umwana wawe Yesu Kristo. '
            'Tuyakire nk\'impuhwe zawe kuri twe. '
            'Uduhe umwuka wawe wera kugira ngo twizere ubuntu bwawe '
            'kandi dukorere bagenzi bacu. Kubw\'Umwana wawe Yesu Kristo Umwami wacu.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen.'),
    ],
  ),

  LiturgySection(
    title: 'IMPEREKEZA / UMUGISHA (Benediction)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text: 'Nimugende mu mahoro.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Imana ishimwe.'),
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Uwiteka aguhe umugisha akurinde.\n'
            'Uwiteka akubonekere akubabarire.\n'
            'Uwiteka akurebane impuhwe aguhe amahoro.\n'
            'Mu izina rya Data wa twese n\'iry\'Umwana, n\'iry\'Umwuka Wera. Amen.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen. Amen. Amen.'),
    ],
  ),
];

// ---------------------------------------------------------------------------
// 3. ISENGESHO RYO MU GITONDO — Morning Prayer
// ---------------------------------------------------------------------------
const List<LiturgySection> _morningPrayerSections = [
  LiturgySection(
    title: 'IFUNGURO (Opening)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Mu izina rya Data wa twese n\'iry\'Umwana n\'iry\'Umwuka Wera.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen.'),
      LiturgyLine(
        speaker: 'Umushumba',
        text: 'Uwiteka Imana ari kumwe natwe.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Ibe mu mutima wawe.'),
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Gusa nk\'uko ibuye ryahindutse inzira y\'umusaraba, '
            'none natwe uyu munsi tuzuka mu kurenganura kwawe. '
            'Dukurikirize inzira zawe, Mwami.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen.'),
    ],
  ),

  LiturgySection(
    title: 'ZABURI / INDIRIMBO (Psalm / Hymn)',
    lines: [
      LiturgyLine(
        speaker: 'Note',
        text:
            'Umuntu asoma zaburi y\'umunsi cyangwa iririmba indirimbo y\'umunsi.',
      ),
    ],
  ),

  LiturgySection(
    title: 'KWATURA IBICUMURO (Confession)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Bavandimwe, tujye imbere y\'Imana twatura ibicumuro byacu.',
      ),
      LiturgyLine(
        speaker: 'Bose',
        text:
            'Mana ishobora byose, Data wa twese w\'imbabazi nyinshi. '
            'Njyewe umunyantege nke n\'umunyabyaha, ndicuza imbere yawe, '
            'ibicumuro byose nakoze mu bitekerezo, mu magambo no mu bikorwa. '
            'Kuko ntahwema kukubabaza nkwiriye igihano cy\'iteka. '
            'Ariko ibyaha byanjye byose ndabyatuye kandi mbyihanye byukuri. '
            'Ndakwinginze kubw\'ubuntu bwawe bwinshi ungirire imbabazi, '
            'unkize, umpe umwuka wawe wera ngire imyifatire mishya. Amen.',
      ),
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Imana nyir\'imbabazi n\'ubushobozi bwose, yatugiriye ibambe, '
            'iduha umwana wayo w\'ikinege Yesu Kristo ngo adupfire ku musaraba, '
            'ku bw\'izina rye itubabariye ibyaha byacu byose. Amen.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen.'),
    ],
  ),

  LiturgySection(
    title: 'AMASOMO (Scripture Readings)',
    lines: [
      LiturgyLine(
        speaker: 'Note',
        text: 'Amasomo avuka asomwa; indirimbo iririmbwa hagati.',
      ),
      LiturgyLine(
        speaker: 'Umusomyi',
        text: 'Amasomo avugwa aramaze.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Imana ngira ngo ikuze.'),
    ],
  ),

  LiturgySection(
    title: 'ISENGESHO RY\'UMWAMI (Lord\'s Prayer)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Dusenge nk\'uko Umwami wacu Yesu Kristo yatwigishije, tuvuge:',
      ),
      LiturgyLine(
        speaker: 'Bose',
        text:
            'Data wa twese uri mu ijuru, '
            'izina ryawe ryubahwe, '
            'ubwami bwawe buze, '
            'ibyushaka bibeho mu isi nkuko bibaho mu ijuru, '
            'uduhe ifunguro ryacu ry\'uyu munsi, '
            'utubabarire ibyaha byacu '
            'nkuko natwe tubabarira ababitugirira, '
            'ntuduhane mu bitwoshya, '
            'ahubwo udukize umubi, '
            'kuko ubwami n\'ubushobozi n\'icyubahiro ari Ibyawe, '
            'none n\'iteka ryose. Amina.',
      ),
    ],
  ),

  LiturgySection(
    title: 'ISENGESHO RY\'UMUGOROBA (Morning Collect)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Mwami Imana, Data wa twese, turagushimira kuko wadukiriye '
            'ku bw\'ijoro ryashize. Uduhe uyu munsi amahoro no kugira imico myiza, '
            'ngo tubeho mu guha icyubahiro izina ryawe, '
            'kubw\'Umwana wawe Yesu Kristo. Amen.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen.'),
    ],
  ),

  LiturgySection(
    title: 'UMUGISHA (Benediction)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Uwiteka aguhe umugisha akurinde.\n'
            'Uwiteka akubonekere akubabarire.\n'
            'Uwiteka akurebane impuhwe aguhe amahoro.\n'
            'Mu izina rya Data wa twese n\'iry\'Umwana, n\'iry\'Umwuka Wera. Amen.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen. Amen. Amen.'),
    ],
  ),
];

// ---------------------------------------------------------------------------
// 4. ISENGESHO RYO MU MUGOROBA — Evening Prayer
// ---------------------------------------------------------------------------
const List<LiturgySection> _eveningPrayerSections = [
  LiturgySection(
    title: 'IFUNGURO (Opening)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Mu izina rya Data wa twese n\'iry\'Umwana n\'iry\'Umwuka Wera.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen.'),
      LiturgyLine(
        speaker: 'Umushumba',
        text: 'Uwiteka Imana ari kumwe natwe.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Ibe mu mutima wawe.'),
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Umutegetsi wacu Yesu Kristo ni we urumuri rw\'isi. '
            'Umuntu ukurikira Yesu ntazagenda mu mwijima, '
            'azagira urumuri rw\'ubugingo.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen.'),
    ],
  ),

  LiturgySection(
    title: 'ZABURI / INDIRIMBO (Psalm / Hymn)',
    lines: [
      LiturgyLine(
        speaker: 'Note',
        text:
            'Umuntu asoma zaburi y\'ijoro cyangwa iririmba indirimbo y\'ijoro.',
      ),
    ],
  ),

  LiturgySection(
    title: 'KWATURA IBICUMURO (Confession)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Bavandimwe, uyu munsi uzira, dujye imbere y\'Imana twatura ibicumuro byacu.',
      ),
      LiturgyLine(
        speaker: 'Bose',
        text:
            'Mana ishobora byose, Data wa twese w\'imbabazi nyinshi. '
            'Njyewe umunyantege nke n\'umunyabyaha, ndicuza imbere yawe, '
            'ibicumuro byose nakoze mu bitekerezo, mu magambo no mu bikorwa. '
            'Kuko ntahwema kukubabaza nkwiriye igihano cy\'iteka. '
            'Ariko ibyaha byanjye byose ndabyatuye kandi mbyihanye byukuri. '
            'Ndakwinginze kubw\'ubuntu bwawe bwinshi ungirire imbabazi, '
            'unkize, umpe umwuka wawe wera ngire imyifatire mishya. Amen.',
      ),
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Imana nyir\'imbabazi n\'ubushobozi bwose, yatugiriye ibambe, '
            'iduha umwana wayo w\'ikinege Yesu Kristo ngo adupfire ku musaraba, '
            'ku bw\'izina rye itubabariye ibyaha byacu byose. Amen.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen.'),
    ],
  ),

  LiturgySection(
    title: 'AMASOMO (Scripture Readings)',
    lines: [
      LiturgyLine(
        speaker: 'Note',
        text: 'Amasomo y\'ijoro asomwa.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Imana ngira ngo ikuze.'),
    ],
  ),

  LiturgySection(
    title: 'MAGNIFICAT / NUNC DIMITTIS',
    lines: [
      LiturgyLine(
        speaker: 'Bose',
        text:
            'Umwuka wanjye urahimbaza Uwiteka, '
            'kandi umutima wanjye winahira Imana Umukiza wanjye; '
            'kuko yasuzumiye ubugingo buke bw\'umugaragu we; '
            'kuko kuva ubu abantu bose b\'ibihe byose bazandita umugisha. '
            'Kuko Uwushobora byose yakoze ibikomeye kuri njye, '
            'kandi izina rye ni ryera.',
      ),
    ],
  ),

  LiturgySection(
    title: 'ISENGESHO RY\'UMWAMI (Lord\'s Prayer)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Dusenge nk\'uko Umwami wacu Yesu Kristo yatwigishije, tuvuge:',
      ),
      LiturgyLine(
        speaker: 'Bose',
        text:
            'Data wa twese uri mu ijuru, '
            'izina ryawe ryubahwe, '
            'ubwami bwawe buze, '
            'ibyushaka bibeho mu isi nkuko bibaho mu ijuru, '
            'uduhe ifunguro ryacu ry\'uyu munsi, '
            'utubabarire ibyaha byacu '
            'nkuko natwe tubabarira ababitugirira, '
            'ntuduhane mu bitwoshya, '
            'ahubwo udukize umubi, '
            'kuko ubwami n\'ubushobozi n\'icyubahiro ari Ibyawe, '
            'none n\'iteka ryose. Amina.',
      ),
    ],
  ),

  LiturgySection(
    title: 'ISENGESHO RY\'IJORO (Evening Collect)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Mwami Imana, Data wa twese, turagushimira kubw\'akarorero k\'uyu munsi. '
            'Utweshe amahoro n\'agakiza mu ijoro ryose, '
            'ngo bukeye tubashe kukuroreka no kukuririmba, '
            'kubw\'Umwana wawe Yesu Kristo Umwami wacu. Amen.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen.'),
    ],
  ),

  LiturgySection(
    title: 'UMUGISHA (Benediction)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Uwiteka aguhe umugisha akurinde.\n'
            'Uwiteka akubonekere akubabarire.\n'
            'Uwiteka akurebane impuhwe aguhe amahoro.\n'
            'Mu izina rya Data wa twese n\'iry\'Umwana, n\'iry\'Umwuka Wera. Amen.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen. Amen. Amen.'),
    ],
  ),
];

// ---------------------------------------------------------------------------
// 5. KUBATIZA ABANA BATO — Infant Baptism
// ---------------------------------------------------------------------------
const List<LiturgySection> _infantBaptismSections = [
  LiturgySection(
    title: 'IFUNGURO (Opening)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Mu izina rya Data wa twese n\'iry\'Umwana n\'iry\'Umwuka Wera.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen.'),
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Uyu mwana azaza imbere yacu ngo abatizwe. '
            'Ubatizo ni ukwamburwa icyaha cya rusange kandi ni ukuzaliwa ubwa kabiri, '
            'nk\'uko Yesu yabibwiye Nikodemu. '
            'Nimuteranire hamwe dusabire uyu mwana.',
      ),
    ],
  ),

  LiturgySection(
    title: 'IVANJILI (Scripture — Matthew 28:18-20)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Mwumve ijambo ry\'Umwami wacu Yesu Kristo nk\'uko Mutagatifu Matayo yabinyandikiye '
            '(Matayo 28:18–20):\n\n'
            '"Yesu yegera, abwira ati: Ubutegetsi bwose mu ijuru no mu isi bunziriwe. '
            'Nimugende rero, mufashe amahanga yose kuba abigishwa banjye, '
            'mubabatize mu izina rya Data, n\'iry\'Umwana, n\'iry\'Umwuka Wera, '
            'mubigishe kubahiriza ibyo nabategetse byose; kandi dore ndi kumwe namwe '
            'iminsi yose, guhera ubu kugeza ku iherezo ry\'ibihe." Amen.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen.'),
    ],
  ),

  LiturgySection(
    title: 'IBIBAZO BY\'ABABYEYI N\'ABASUBIZI (Parents\' and Sponsors\' Vows)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Nimubaze ababyeyi n\'abasubizi b\'uyu mwana:\n\n'
            'Mwizeye ko uyu mwana afite icyaha cya rusange, '
            'akeneye gukiranurwa no gukirizwa kubw\'Umwuka Wera?',
      ),
      LiturgyLine(
        speaker: 'Ababyeyi',
        text: 'Yego, tweye.',
      ),
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Mwizera kandi ko ubatizo, nk\'uko Yesu yabishyize mu bikorwa, '
            'ari ubuntu bw\'Imana?',
      ),
      LiturgyLine(
        speaker: 'Ababyeyi',
        text: 'Yego, tweye.',
      ),
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Mwiyemeza rero kumugisha uyu mwana mu kwizera, '
            'kumwigisha inzira z\'Imana ndetse no kumuzana ku matekaniro n\'ibyigisho by\'itorero?',
      ),
      LiturgyLine(
        speaker: 'Ababyeyi',
        text: 'Yego, Imana itugire inkomezi.',
      ),
    ],
  ),

  LiturgySection(
    title: 'ISENGESHO (Prayer Before Baptism)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Dusenge: Mwami Imana, Data wa twese, uragirirwa gukuza uyu mwana '
            'mu ngabire zawe kandi umbe kumwe nawe iminsi yose. '
            'Umpe umwuka wawe wera yubahwe mu mubiri no mu mutima wa [izina ry\'umwana], '
            'kugira ngo abeho guha icyubahiro izina ryawe ryera. Amen.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen.'),
    ],
  ),

  LiturgySection(
    title: 'UBATIZO (Baptism)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Nkubatiza mu izina rya Data wa twese n\'iry\'Umwana n\'iry\'Umwuka Wera. Amen.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen.'),
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Amahoro akomeze kuba nawe [izina ry\'umwana], '
            'ubu wandikiwe mu gitabo cy\'ubugingo bw\'iteka. Amen.',
      ),
    ],
  ),

  LiturgySection(
    title: 'ISENGESHO NYUMA Y\'UBATIZO (Prayer After Baptism)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Dusenge: Mwami Imana, turagushimira kuko ubatijwe '
            '[izina ry\'umwana] ubu azaba undi wawe. '
            'Umufashe gukura mu kwizera, ngo azabashe gutunga ubugingo budashira. '
            'Kubw\'Umwana wawe Yesu Kristo. Amen.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen.'),
    ],
  ),

  LiturgySection(
    title: 'UMUGISHA (Benediction)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Uwiteka aguhe umugisha akurinde.\n'
            'Uwiteka akubonekere akubabarire.\n'
            'Uwiteka akurebane impuhwe aguhe amahoro.\n'
            'Mu izina rya Data wa twese n\'iry\'Umwana, n\'iry\'Umwuka Wera. Amen.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen. Amen. Amen.'),
    ],
  ),
];

// ---------------------------------------------------------------------------
// 6. GUSEZERANYA ABASHYINGIRWA — Wedding Service
// ---------------------------------------------------------------------------
const List<LiturgySection> _weddingServiceSections = [
  LiturgySection(
    title: 'IFUNGURO (Opening Words)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Mu izina rya Data wa twese n\'iry\'Umwana n\'iry\'Umwuka Wera.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen.'),
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Mwami mana waremye umugabo n\'umugore, '
            'ushyingira iki gihe [amazina y\'abashakanye] mu itorero ryawe ry\'abera. '
            'Turakwinginze ube kumwe nabo ubu no iminsi yose y\'ubugingo bwabo.',
      ),
    ],
  ),

  LiturgySection(
    title: 'AMASOMO (Scripture Readings)',
    lines: [
      LiturgyLine(
        speaker: 'Note',
        text:
            'Amasomo avuga ubushingirwa asomwa, nko muri Itangiriro 2:18-24 '
            'cyangwa Abaefezo 5:21-33.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Imana ngira ngo ikuze.'),
    ],
  ),

  LiturgySection(
    title: 'IMPANO N\'IBIBAZO (Declaration of Intent)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Wowe [izina ry\'umugabo], ese urashaka kwishyingira uyu mugore '
            '[izina ry\'umugore], kumwita uwo wiyemeje imbere y\'Imana no guhamya '
            'ukwizera kwanyu hamwe mu bihe byose, mu byiza no mu bibi, '
            'mu buzima n\'indwara, kugeza urupfu rubatandukanya?',
      ),
      LiturgyLine(
        speaker: 'Umugabo',
        text: 'Yego, nshaka.',
      ),
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Wowe [izina ry\'umugore], ese urashaka kwishyingira uyu mugabo '
            '[izina ry\'umugabo], kumwita uwo wiyemeje imbere y\'Imana no guhamya '
            'ukwizera kwanyu hamwe mu bihe byose, mu byiza no mu bibi, '
            'mu buzima n\'indwara, kugeza urupfu rubatandukanya?',
      ),
      LiturgyLine(
        speaker: 'Umugore',
        text: 'Yego, nshaka.',
      ),
    ],
  ),

  LiturgySection(
    title: 'INDAHIRO (Vows)',
    lines: [
      LiturgyLine(
        speaker: 'Umugabo',
        text:
            'Njye [izina ry\'umugabo] nkwemera wowe [izina ry\'umugore] '
            'nkwite umugore wanjye, ndakwiyemeje imbere y\'Imana n\'itorero, '
            'kukwishimira, kukubabarira, kukubahiriza no kukurinda, '
            'mu byiza no mu bibi, mu buzima n\'indwara, '
            'kugeza urupfu rutandukanya. '
            'Iri ni isezerano ryanjye ry\'ukuri, Imana intabaze.',
      ),
      LiturgyLine(
        speaker: 'Umugore',
        text:
            'Njye [izina ry\'umugore] nkwemera wowe [izina ry\'umugabo] '
            'nkwite umugabo wanjye, ndakwiyemeje imbere y\'Imana n\'itorero, '
            'kukwishimira, kukubabarira, kukubahiriza no kukurinda, '
            'mu byiza no mu bibi, mu buzima n\'indwara, '
            'kugeza urupfu rutandukanya. '
            'Iri ni isezerano ryanjye ry\'ukuri, Imana intabaze.',
      ),
    ],
  ),

  LiturgySection(
    title: 'IMPETA (Ring Ceremony)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Impeta ni ikimenyetso cy\'isezerano n\'urukundo rwa Kristo. '
            'Nimupane impeta zanyu.',
      ),
      LiturgyLine(
        speaker: 'Umugabo',
        text:
            'Ndakuha iyi mpeta nk\'ikimenyetso cy\'isezerano ryanjye, '
            'kandi nk\'ikimenyetso cy\'urukundo rwanjye kuri wewe.',
      ),
      LiturgyLine(
        speaker: 'Umugore',
        text:
            'Ndakuha iyi mpeta nk\'ikimenyetso cy\'isezerano ryanjye, '
            'kandi nk\'ikimenyetso cy\'urukundo rwanjye kuri wewe.',
      ),
    ],
  ),

  LiturgySection(
    title: 'GUSEZERANAHO N\'UMUGISHA (Declaration and Blessing)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Kubw\'isezerano mwahuje imbere y\'Imana n\'itorero, '
            'ndabahamyaho ko muri umugabo n\'umugore. '
            'Ibyo Imana yashyize hamwe, umuntu ntabikurane.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen.'),
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Uwiteka aguhe umugisha n\'akurinde, '
            'akubonekere kandi akubabarire, '
            'akurebane impuhwe aguhe amahoro, '
            'none n\'iteka ryose. Amen.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen. Amen. Amen.'),
    ],
  ),
];

// ---------------------------------------------------------------------------
// 7. GUHEREKEZA UMURAMBO W'UMUKRISTO — Christian Funeral
// ---------------------------------------------------------------------------
const List<LiturgySection> _funeralServiceSections = [
  LiturgySection(
    title: 'IJAMBO RY\'IFUNGURO (Opening Words)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Yesu avuga ati: "Ndi we kuzuka n\'ubugingo; '
            'ukwizera mwe nanjye azapfa azarokoka, '
            'kandi umuntu wese uzima akwizera we ntazapfa iteka ryose." '
            '(Yohana 11:25-26)',
      ),
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Mu izina rya Data wa twese n\'iry\'Umwana n\'iry\'Umwuka Wera.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen.'),
    ],
  ),

  LiturgySection(
    title: 'ISENGESHO (Opening Prayer)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Mwami Imana, Data wa twese, turagiranye umunsi w\'agahinda. '
            'Uduhe ubwenge bwawe no gutuza mu mutima wacu. '
            'Turemeshe ko [izina ry\'uwabuze] yari uwawe, '
            'kandi ko azazuka ku munsi wa nyuma. Amen.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen.'),
    ],
  ),

  LiturgySection(
    title: 'AMASOMO (Scripture Readings)',
    lines: [
      LiturgyLine(
        speaker: 'Note',
        text:
            'Amasomo akenewe asomwa, nko muri Zaburi 23, '
            'Yohana 14:1-6, cyangwa 1 Abatesalonika 4:13-18.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Imana ngira ngo ikuze.'),
    ],
  ),

  LiturgySection(
    title: 'ISAKAZA (Homily / Message)',
    lines: [
      LiturgyLine(
        speaker: 'Note',
        text: 'Umushumba asakaza ijambo ry\'Imana ry\'uyu munsi.',
      ),
    ],
  ),

  LiturgySection(
    title: 'GUSABIRA (Intercessions)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Dusabire umuryango wa [izina ry\'uwabuze] ndetse n\'abamubanye. '
            'Mwami, ubahe gutuza no gukomera mu kwizera kwabo.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Umva isengesho ryacu, Mwami.'),
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Dusabire itorero ryawe n\'abantu bose bafite agahinda. '
            'Ubahe kumenya ko hari kuzuka kandi hari ubugingo budashira.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Umva isengesho ryacu, Mwami.'),
    ],
  ),

  LiturgySection(
    title: 'ISENGESHO RY\'UMWAMI (Lord\'s Prayer)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Dusenge nk\'uko Umwami wacu Yesu Kristo yatwigishije, tuvuge:',
      ),
      LiturgyLine(
        speaker: 'Bose',
        text:
            'Data wa twese uri mu ijuru, '
            'izina ryawe ryubahwe, '
            'ubwami bwawe buze, '
            'ibyushaka bibeho mu isi nkuko bibaho mu ijuru, '
            'uduhe ifunguro ryacu ry\'uyu munsi, '
            'utubabarire ibyaha byacu '
            'nkuko natwe tubabarira ababitugirira, '
            'ntuduhane mu bitwoshya, '
            'ahubwo udukize umubi, '
            'kuko ubwami n\'ubushobozi n\'icyubahiro ari Ibyawe, '
            'none n\'iteka ryose. Amina.',
      ),
    ],
  ),

  LiturgySection(
    title: 'GUSHYINGURA (Committal)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Kuko byagombaga ko [izina ry\'uwabuze] asubire mu ibumba ry\'ubutaka, '
            'nkitanga umubiri we ku butaka, '
            'mu kwizera kuzuka k\'abapfuye n\'ubugingo budashira, '
            'kubw\'Umwami wacu Yesu Kristo, uzahinduza umubiri wacu w\'ubugome '
            'ngo ube nk\'umubiri we w\'icyubahiro, '
            'nk\'uko ashoboye gutura ibintu byose. Amen.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen.'),
    ],
  ),

  LiturgySection(
    title: 'UMUGISHA W\'IMPERUKA (Closing Blessing)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Uwiteka aguhe umugisha akurinde.\n'
            'Uwiteka akubonekere akubabarire.\n'
            'Uwiteka akurebane impuhwe aguhe amahoro.\n'
            'Mu izina rya Data wa twese n\'iry\'Umwana, n\'iry\'Umwuka Wera. Amen.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen. Amen. Amen.'),
    ],
  ),
];

// ---------------------------------------------------------------------------
// 8. GUSENGERA AMASARURA — Harvest Thanksgiving
// ---------------------------------------------------------------------------
const List<LiturgySection> _harvestThanksgivingSections = [
  LiturgySection(
    title: 'IFUNGURO (Opening)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Mu izina rya Data wa twese n\'iry\'Umwana n\'iry\'Umwuka Wera.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen.'),
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Uwiteka Imana ari kumwe natwe.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Ibe mu mutima wawe.'),
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Turahaye icyubahiro Imana iduha amasarura. '
            'Nitwibuke ko ibimera byose, imvura, urumuri rw\'izuba '
            'n\'imbaraga zo gukorana ni ingabire z\'Imana. '
            'Dushime Uwiteka kubw\'ubuntu bwe bwose.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen.'),
    ],
  ),

  LiturgySection(
    title: 'ZABURI (Psalm — Psalm 65)',
    lines: [
      LiturgyLine(
        speaker: 'Bose',
        text:
            'Wowe Imana, ni wewe ukwiriye indirimbo y\'ishimwe i Siyoni, '
            'kandi ibirahiro birazuzuzwa kuri wewe. '
            'Uwiteka uri mu gicumbi cyawe cy\'indegemo: '
            'umuntu w\'imihati ni we uzagiriwa akabuto. '
            'Ubumwe bwawe buradukiriza, '
            'uduha ibintu byiza byo kuri iwe mu nyumba yawe nziza.',
      ),
    ],
  ),

  LiturgySection(
    title: 'AMASOMO (Scripture Readings)',
    lines: [
      LiturgyLine(
        speaker: 'Note',
        text:
            'Amasomo y\'amasarura asomwa, nko muri Gutegeka kwa kabiri 26:1-11 '
            'cyangwa Luka 12:16-21.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Imana ngira ngo ikuze.'),
    ],
  ),

  LiturgySection(
    title: 'ISAKAZA (Homily)',
    lines: [
      LiturgyLine(
        speaker: 'Note',
        text: 'Umushumba asakaza ijambo ry\'Imana ry\'amasarura.',
      ),
    ],
  ),

  LiturgySection(
    title: 'GUTANGA IBITANGWA (Offering of First Fruits)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Mwami Data wa twese, twakira ibitangwa by\'ishimwe '
            'tuguhereza nk\'ikimenyetso cy\'ingabire zawe kuri twe. '
            'Biduhe umugisha ngo bihe umunna wacu agakiza n\'ubuzima.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen.'),
    ],
  ),

  LiturgySection(
    title: 'ISENGESHO RY\'UMWAMI (Lord\'s Prayer)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Dusenge nk\'uko Umwami wacu Yesu Kristo yatwigishije, tuvuge:',
      ),
      LiturgyLine(
        speaker: 'Bose',
        text:
            'Data wa twese uri mu ijuru, '
            'izina ryawe ryubahwe, '
            'ubwami bwawe buze, '
            'ibyushaka bibeho mu isi nkuko bibaho mu ijuru, '
            'uduhe ifunguro ryacu ry\'uyu munsi, '
            'utubabarire ibyaha byacu '
            'nkuko natwe tubabarira ababitugirira, '
            'ntuduhane mu bitwoshya, '
            'ahubwo udukize umubi, '
            'kuko ubwami n\'ubushobozi n\'icyubahiro ari Ibyawe, '
            'none n\'iteka ryose. Amina.',
      ),
    ],
  ),

  LiturgySection(
    title: 'UMUGISHA (Benediction)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Uwiteka aguhe umugisha akurinde.\n'
            'Uwiteka akubonekere akubabarire.\n'
            'Uwiteka akurebane impuhwe aguhe amahoro.\n'
            'Mu izina rya Data wa twese n\'iry\'Umwana, n\'iry\'Umwuka Wera. Amen.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen. Amen. Amen.'),
    ],
  ),
];

// ---------------------------------------------------------------------------
// 9. GUSENGERA IGIHUGU — Prayer for the Nation
// ---------------------------------------------------------------------------
const List<LiturgySection> _prayerForNationSections = [
  LiturgySection(
    title: 'IFUNGURO (Opening)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Mu izina rya Data wa twese n\'iry\'Umwana n\'iry\'Umwuka Wera.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen.'),
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Turakwinginze Mwami Imana, Data wa twese, '
            'utubeho kumwe muri iyi gusenga igihugu cyacu. '
            'Uduhe amahoro, umutungo, ubumwe n\'agaciro k\'ubwoko bwawe.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen.'),
    ],
  ),

  LiturgySection(
    title: 'AMASOMO (Scripture)',
    lines: [
      LiturgyLine(
        speaker: 'Note',
        text:
            'Amasomo asomwa, nko muri Yeremia 29:7 '
            'cyangwa 1 Timoteyo 2:1-4.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Imana ngira ngo ikuze.'),
    ],
  ),

  LiturgySection(
    title: 'ISAKAZA (Homily)',
    lines: [
      LiturgyLine(
        speaker: 'Note',
        text: 'Umushumba asakaza ijambo ry\'Imana ry\'igihugu.',
      ),
    ],
  ),

  LiturgySection(
    title: 'GUSABIRA IGIHUGU (Intercessions for the Nation)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Dusabire igihugu cyacu n\'abayobozi bayo. '
            'Mwami, uhe abayobozi bacu ubwenge, uburinganire n\'impuhwe, '
            'kugira ngo bategeke mu butabera.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Umva isengesho ryacu, Mwami.'),
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Dusabire amahoro n\'ubumwe mu gihugu cyacu. '
            'Mwami, ukure amacakubiri no gukunda igihugu, '
            'uduhe ubumwe nk\'abana ba Rwanda.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Umva isengesho ryacu, Mwami.'),
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Dusabire abakene n\'abatishoboye mu gihugu cyacu. '
            'Mwami, ubashe kuborohesha no kubasha kubafasha.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Umva isengesho ryacu, Mwami.'),
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Dusabire itorero ryawe ngo ribeho mu kwizera no mu bikorwa, '
            'rikagira uruhare mu kubaka igihugu cyacu.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Umva isengesho ryacu, Mwami.'),
    ],
  ),

  LiturgySection(
    title: 'ISENGESHO RY\'UMWAMI (Lord\'s Prayer)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Dusenge nk\'uko Umwami wacu Yesu Kristo yatwigishije, tuvuge:',
      ),
      LiturgyLine(
        speaker: 'Bose',
        text:
            'Data wa twese uri mu ijuru, '
            'izina ryawe ryubahwe, '
            'ubwami bwawe buze, '
            'ibyushaka bibeho mu isi nkuko bibaho mu ijuru, '
            'uduhe ifunguro ryacu ry\'uyu munsi, '
            'utubabarire ibyaha byacu '
            'nkuko natwe tubabarira ababitugirira, '
            'ntuduhane mu bitwoshya, '
            'ahubwo udukize umubi, '
            'kuko ubwami n\'ubushobozi n\'icyubahiro ari Ibyawe, '
            'none n\'iteka ryose. Amina.',
      ),
    ],
  ),

  LiturgySection(
    title: 'UMUGISHA (Benediction)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Uwiteka aguhe umugisha akurinde.\n'
            'Uwiteka akubonekere akubabarire.\n'
            'Uwiteka akurebane impuhwe aguhe amahoro.\n'
            'Mu izina rya Data wa twese n\'iry\'Umwana, n\'iry\'Umwuka Wera. Amen.',
      ),
      LiturgyLine(speaker: 'Bose', text: 'Amen. Amen. Amen.'),
    ],
  ),
];

// ---------------------------------------------------------------------------
// 10. KWATURA IBICUMURO — Individual Confession
// ---------------------------------------------------------------------------
const List<LiturgySection> _individualConfessionSections = [
  LiturgySection(
    title: 'KWAKIRA UMUNTU (Receiving the Penitent)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Wicare/Haguruka imbere y\'Imana. '
            'Nitura ibyaha byawe, kuko Uwiteka ari inyangamugayo kandi ni we ukubabarira.',
      ),
    ],
  ),

  LiturgySection(
    title: 'KWATURA IBICUMURO — INSHURO YA MBERE (First Form of Confession)',
    lines: [
      LiturgyLine(
        speaker: 'Uwatura',
        text:
            'Mana ishobora byose, Data wa twese w\'imbabazi nyinshi. '
            'Njyewe umunyantege nke n\'umunyabyaha, ndicuza imbere yawe, '
            'ibicumuro byose nakoze mu bitekerezo, mu magambo no mu bikorwa. '
            'Kuko ntahwema kukubabaza nkwiriye igihano cy\'iteka. '
            'Ariko ibyaha byanjye byose ndabyatuye kandi mbyihanye byukuri. '
            'Ndakwinginze kubw\'ubuntu bwawe bwinshi ungirire imbabazi, '
            'unkize, umpe umwuka wawe wera ngire imyifatire mishya. Amen.',
      ),
    ],
  ),

  LiturgySection(
    title: 'KWATURA IBICUMURO — INSHURO YA KABIRI (Second Form of Confession)',
    lines: [
      LiturgyLine(
        speaker: 'Uwatura',
        text:
            'Mana ishobora byose, Data wa twese wo mu ijuru, '
            'ndihana ko nagucumuyeho, ngacumura no kuri bagenzi banjye, '
            'mu bitekerezo, mu magambo no mu bikorwa. '
            'Ndakwinginze ungirire imbabazi kubw\'Umwana wawe Yesu Kristo, '
            'umbabarire ibyaha byanjye byose. '
            'Unyuhagize umwuka wawe wera, '
            'uhembure umutima wanjye, '
            'nshobore kubabarira abandi '
            'mu bugingo bushya mu cyubahiro cy\'izina ryawe ryera. Amen.',
      ),
    ],
  ),

  LiturgySection(
    title: 'KUBABARIRWA IBYAHA (Absolution)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Imana nyir\'imbabazi n\'ubushobozi bwose, yatugiriye ibambe, '
            'iduha umwana wayo w\'ikinege Yesu Kristo ngo adupfire ku musaraba, '
            'ku bw\'izina rye itubabariye ibyaha byacu byose. '
            'Nkubwira nk\'umugaragu w\'Ijambo rye: '
            'Ibyaha byawe byose bibabarirwa, mu izina rya Data wa twese '
            'n\'iry\'Umwana n\'iry\'Umwuka Wera. Amen.',
      ),
      LiturgyLine(
        speaker: 'Uwatura',
        text: 'Amen.',
      ),
    ],
  ),

  LiturgySection(
    title: 'ISENGESHO (Closing Prayer)',
    lines: [
      LiturgyLine(
        speaker: 'Umushumba',
        text:
            'Mwami Imana, turagushimira ko wababariye '
            'uyu mugaragu/umugaraguzi wawe. '
            'Umuhe umwuka wawe wera kugira ngo azabeho mu bugingo bushya, '
            'azitondere kugucumura, azakorere bagenzi be mu rukundo. '
            'Kubw\'Umwana wawe Yesu Kristo. Amen.',
      ),
      LiturgyLine(speaker: 'Uwatura', text: 'Amen.'),
      LiturgyLine(
        speaker: 'Umushumba',
        text: 'Nigende mu mahoro.',
      ),
      LiturgyLine(
        speaker: 'Uwatura',
        text: 'Imana ishimwe.',
      ),
    ],
  ),
];

// ---------------------------------------------------------------------------
// LiturgyData — central registry
// ---------------------------------------------------------------------------

class LiturgyData {
  static const List<LiturgyService> _services = [
    LiturgyService(
      id: 'sunday_service',
      titleRw: 'GUSENGA KU CYUMWERU',
      titleEn: 'Sunday Divine Service',
      description:
          'Isengesho rya buri cyumweru ry\'itorero ry\'Abaluteri b\'u Rwanda (LCR). '
          'Riharurwa n\'IMYITEGURO, IJAMBO RY\'IMANA, no gushimira Imana.',
      sections: _sundayServiceSections,
      icon: '⛪',
    ),
    LiturgyService(
      id: 'holy_communion',
      titleRw: 'GUHAZWA',
      titleEn: 'Holy Communion',
      description:
          'Isakramentu ry\'umubiri n\'amaraso ya Kristo, rihabwa abakirisitu '
          'mu kwizera, risimbuza amasezerano mashya.',
      sections: _holyCommunionSections,
      icon: '🍞',
    ),
    LiturgyService(
      id: 'morning_prayer',
      titleRw: 'ISENGESHO RYO MU GITONDO',
      titleEn: 'Morning Prayer',
      description:
          'Isengesho riturira umunsi, riharurwa n\'indirimbo, amasomo n\'isengesho '
          'ry\'Umwami.',
      sections: _morningPrayerSections,
      icon: '🌅',
    ),
    LiturgyService(
      id: 'evening_prayer',
      titleRw: 'ISENGESHO RYO MU MUGOROBA',
      titleEn: 'Evening Prayer',
      description:
          'Isengesho ry\'umugoroba, riharurwa n\'indirimbo, amasomo, '
          'Magnificat n\'isengesho ry\'ijoro.',
      sections: _eveningPrayerSections,
      icon: '🌇',
    ),
    LiturgyService(
      id: 'infant_baptism',
      titleRw: 'KUBATIZA ABANA BATO',
      titleEn: 'Infant Baptism',
      description:
          'Gahunda yo kubatiza abana bato mu izina rya Data, Umwana n\'Umwuka Wera, '
          'nk\'uko Yesu yatwegekeye.',
      sections: _infantBaptismSections,
      icon: '💧',
    ),
    LiturgyService(
      id: 'wedding_service',
      titleRw: 'GUSEZERANYA ABASHYINGIRWA',
      titleEn: 'Wedding Service',
      description:
          'Gahunda y\'ubushingirwa imbere y\'Imana n\'itorero, '
          'irimo indahiro, impeta n\'umugisha.',
      sections: _weddingServiceSections,
      icon: '💍',
    ),
    LiturgyService(
      id: 'funeral_service',
      titleRw: 'GUHEREKEZA UMURAMBO W\'UMUKRISTO',
      titleEn: 'Christian Funeral',
      description:
          'Gahunda yo guherekeza umurambo w\'umukristo, '
          'irimo amasomo, isakaza no gushyingura mu kwizera.',
      sections: _funeralServiceSections,
      icon: '✝️',
    ),
    LiturgyService(
      id: 'harvest_thanksgiving',
      titleRw: 'GUSENGERA AMASARURA',
      titleEn: 'Harvest Thanksgiving',
      description:
          'Gushima Imana kubw\'amasarura yo mu mirima n\'ingabire zayo zose '
          'zituraho buri mwaka.',
      sections: _harvestThanksgivingSections,
      icon: '🌾',
    ),
    LiturgyService(
      id: 'prayer_for_nation',
      titleRw: 'GUSENGERA IGIHUGU',
      titleEn: 'Prayer for the Nation',
      description:
          'Gusabira igihugu cy\'u Rwanda, abayobozi bayo n\'amahoro '
          'mu baturage bose.',
      sections: _prayerForNationSections,
      icon: '🇷🇼',
    ),
    LiturgyService(
      id: 'individual_confession',
      titleRw: 'KWATURA IBICUMURO',
      titleEn: 'Individual Confession',
      description:
          'Kwatura ibicumuro kuri buri wese imbere y\'Imana no gutumanahiwa '
          'kubabarirwa kubw\'Umwami Yesu Kristo.',
      sections: _individualConfessionSections,
      icon: '🙏',
    ),
  ];

  static List<LiturgyService> get services => _services;

  static LiturgyService? getById(String id) {
    try {
      return _services.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}
