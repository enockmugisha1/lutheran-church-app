import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations);

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'rw': _rw,
    'en': _en,
    'fr': _fr,
  };

  String get(String key) =>
      _localizedValues[locale.languageCode]?[key] ?? key;

  // ── Navigation ─────────────────────────────────────────────────────────────
  String get home          => get('home');
  String get bible         => get('bible');
  String get calendar      => get('calendar');
  String get liturgy       => get('liturgy');
  String get hymns         => get('hymns');
  String get community     => get('community');
  String get more          => get('more');
  String get prayer        => get('prayer');
  String get settings      => get('settings');

  // ── Common actions ─────────────────────────────────────────────────────────
  String get search        => get('search');
  String get share         => get('share');
  String get bookmark      => get('bookmark');
  String get read          => get('read');
  String get listen        => get('listen');
  String get cancel        => get('cancel');
  String get save          => get('save');
  String get delete        => get('delete');
  String get retry         => get('retry');
  String get loading       => get('loading');
  String get copied        => get('copied');
  String get close         => get('close');
  String get yes           => get('yes');
  String get no            => get('no');

  // ── Auth / Splash ──────────────────────────────────────────────────────────
  String get appName           => get('app_name');
  String get appSubtitle       => get('app_subtitle');
  String get signIn            => get('sign_in');
  String get continueOffline   => get('continue_offline');
  String get offlineHint       => get('offline_hint');
  String get signOut           => get('sign_out');
  String get signOutConfirm    => get('sign_out_confirm');
  String get signOutTitle      => get('sign_out_title');
  String get register          => get('register');
  String get signInOrRegister  => get('sign_in_or_register');
  String get guestLabel        => get('guest_label');
  String get guestSubtitle     => get('guest_subtitle');

  // ── Bible page ─────────────────────────────────────────────────────────────
  String get oldTestament      => get('old_testament');
  String get newTestament      => get('new_testament');
  String get chapter           => get('chapter');
  String get verse             => get('verse');
  String get reading           => get('reading');
  String get verseOfDay        => get('verse_of_day');
  String get books             => get('books');
  String get versions          => get('version');
  String get todayTab          => get('today_tab');
  String get booksTab          => get('books_tab');
  String get versionsTab       => get('versions_tab');
  String get selectChapter     => get('select_chapter');
  String get selectVersion     => get('select_version');
  String get startReading      => get('start_reading');
  String get noInternet        => get('no_internet');
  String get noInternetRetry   => get('no_internet_retry');
  String get loadingBible      => get('loading_bible');
  String get searchingBibles   => get('searching_bibles');
  String get searchBibleHint   => get('search_bible_hint');
  String get noBiblesFound     => get('no_bibles_found');
  String get noSearchResults   => get('no_search_results');
  String get date              => get('date');
  String get decrease          => get('decrease');
  String get increase          => get('increase');
  String get copyText          => get('copy_text');
  String get noPassageFound    => get('no_passage_found');
  String get allBibles         => get('all_bibles');
  String get offlineBadge      => get('offline_badge');

  // ── Bible stats card ───────────────────────────────────────────────────────
  String get otBooks           => get('ot_books');
  String get ntBooks           => get('nt_books');
  String get allChapters       => get('all_chapters');
  String get allVerses         => get('all_verses');
  String get offlineReady      => get('offline_ready');

  // ── Profile page ───────────────────────────────────────────────────────────
  String get profile           => get('profile');
  String get editProfile       => get('edit_profile');
  String get personalInfo      => get('personal_info');
  String get name              => get('name');
  String get email             => get('email');
  String get church            => get('church');
  String get language          => get('language');
  String get bibleStats        => get('bible_stats');
  String get actions           => get('actions');
  String get readingStreak     => get('reading_streak');
  String get signInPromptTitle => get('sign_in_prompt_title');
  String get signInPromptBody  => get('sign_in_prompt_body');
  String get days              => get('days');

  // ── More page ──────────────────────────────────────────────────────────────
  String get spiritualTools    => get('spiritual_tools');
  String get churchInfo        => get('church_info');
  String get accountSettings   => get('account_settings');
  String get dailyPrayers      => get('daily_prayers');
  String get dailyPrayersSub   => get('daily_prayers_sub');
  String get catechism         => get('catechism');
  String get catechismSub      => get('catechism_sub');
  String get aboutLCR          => get('about_lcr');
  String get aboutLCRSub       => get('about_lcr_sub');
  String get shareApp          => get('share_app');
  String get shareAppSub       => get('share_app_sub');

  // ── Calendar / Season ──────────────────────────────────────────────────────
  String get today             => get('today');
  String get dailyReading      => get('daily_reading');
  String get season            => get('season');
  String get feastDay          => get('feast_day');

  // ── Liturgy ────────────────────────────────────────────────────────────────
  String get morningPrayer     => get('morning_prayer');
  String get eveningPrayer     => get('evening_prayer');
  String get compline          => get('compline');
  String get divineService     => get('divine_service');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();
  @override
  bool isSupported(Locale locale) =>
      ['rw', 'en', 'fr'].contains(locale.languageCode);
  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
//  Kinyarwanda
// ─────────────────────────────────────────────────────────────────────────────
const Map<String, String> _rw = {
  // Navigation
  'home': 'Ahabanza',
  'bible': 'Bibiliya',
  'calendar': 'Kalindari',
  'liturgy': 'Liturgiya',
  'hymns': 'Indirimbo',
  'community': 'Ubucuti',
  'more': 'Byinshi',
  'prayer': 'Isengesho',
  'settings': 'Igenamiterere',

  // Common
  'search': 'Shakisha',
  'share': 'Sangiza',
  'bookmark': 'Agaciro',
  'read': 'Soma',
  'listen': 'Umva',
  'cancel': 'Hagarika',
  'save': 'Bika',
  'delete': 'Siba',
  'retry': 'Ongera Ugerageze',
  'loading': 'Tegereza...',
  'copied': 'Byakopishijwe!',
  'close': 'Funga',
  'yes': 'Yego',
  'no': 'Oya',

  // Auth / Splash
  'app_name': 'Itorero rya Lutherani',
  'app_subtitle': 'Itorero rya Luteri mu Rwanda',
  'sign_in': 'Injira',
  'continue_offline': 'Komeza Udasubira',
  'offline_hint': 'Bibiliya, Kalindari, na Liturgiya\nbiboneka hatabayeho gusubira.',
  'sign_out': 'Sohoka',
  'sign_out_confirm': 'Urifuza gusohoka mu konti yawe?',
  'sign_out_title': 'Sohoka',
  'register': 'Iyandikishe',
  'sign_in_or_register': 'Injira / Iyandikishe',
  'guest_label': 'Nta konti (Mukerarugendo)',
  'guest_subtitle': 'Injira kugira ngo ubone ibikorwa byose',

  // Bible
  'old_testament': 'Isezerano rya Kera',
  'new_testament': 'Isezerano Rishya',
  'chapter': 'Igice',
  'verse': 'Umurongo',
  'reading': 'Gusoma',
  'verse_of_day': 'IJAMBO RY\'UYU MUNSI',
  'books': 'Ibitabo',
  'version': 'Verisiyo',
  'today_tab': 'Kuri Uyu Munsi',
  'books_tab': 'Ibitabo',
  'versions_tab': 'Verisiyo',
  'select_chapter': 'Hitamo Igice',
  'select_version': 'Hitamo Verisiyo',
  'start_reading': 'Tangira Gusoma',
  'no_internet': 'Ntamurandasi',
  'no_internet_retry': 'Ntamurandasi — Gerageza Nanone',
  'loading_bible': 'Gukurura Bibiliya...',
  'searching_bibles': 'Gushakisha Bibiliya...',
  'search_bible_hint': 'Shakisha ururimi cyangwa izina rya Bibiliya...',
  'no_bibles_found': 'Nta Bibiliya ibonetse.\nGerageza indi ndimi.',
  'no_search_results': 'Nta bisubizo. Gerageza ijambo rindi.',
  'date': 'Itariki',
  'decrease': 'Mbanisha',
  'increase': 'Tunganya',
  'copy_text': 'Kopisha',
  'no_passage_found': 'Inyandiko ntiyabonetse.\nGerageza nanone.',
  'all_bibles': 'Bibiliya',
  'offline_badge': 'offline',

  // Bible stats
  'ot_books': 'Ibitabo by\'Isezerano rya Kera',
  'nt_books': 'Ibitabo by\'Isezerano Rishya',
  'all_chapters': 'Imigabane yose',
  'all_verses': 'Inzandiko zose',
  'offline_ready': 'Offline (Kinyarwanda)',

  // Profile
  'profile': 'Umwirondoro',
  'edit_profile': 'Hindura Umwirondoro',
  'personal_info': 'Amakuru y\'Umuntu',
  'name': 'Izina',
  'email': 'Email',
  'church': 'Itorero',
  'language': 'Ururimi',
  'bible_stats': 'Ibyerekeranye na Bibiliya',
  'actions': 'Ibikorwa',
  'reading_streak': 'Iminsi Gukurikirana',
  'sign_in_prompt_title': 'Fungura Konti Yawe',
  'sign_in_prompt_body':
      'Fungura konti kugira ngo ubike aho usomye, ukurikirane imirimo yawe y\'umwuka, kandi ufatanye n\'abandi mu muryango.',
  'days': 'Iminsi',

  // More
  'spiritual_tools': 'Ibikoresho by\'Umwuka',
  'church_info': 'Amakuru y\'Itorero',
  'account_settings': 'Konti & Igenamiterere',
  'daily_prayers': 'Amasengesho Asanzwe',
  'daily_prayers_sub': 'Amasengesho y\'ibihe bitandukanye',
  'catechism': 'Catechism Ntoya ya Luteri',
  'catechism_sub': 'Amategeko, Kwizera, Isengesho rya Data',
  'about_lcr': 'Ibyerekeranye na LCR',
  'about_lcr_sub': 'Itorero rya Luteri mu Rwanda',
  'share_app': 'Sangira iyi App',
  'share_app_sub': 'Bwira abandi bantu iby\'iyi app',

  // Calendar
  'today': 'Uyu munsi',
  'daily_reading': 'Isomo ry\'umunsi',
  'season': 'Igihe',
  'feast_day': 'Umunsi mukuru',

  // Liturgy
  'morning_prayer': 'Isengesho ryo mu gitondo',
  'evening_prayer': 'Isengesho ryo mu mugoroba',
  'compline': 'Isengesho ryo mu ijoro',
  'divine_service': 'Serivisi y\'Imana',
};

// ─────────────────────────────────────────────────────────────────────────────
//  English
// ─────────────────────────────────────────────────────────────────────────────
const Map<String, String> _en = {
  // Navigation
  'home': 'Home',
  'bible': 'Bible',
  'calendar': 'Calendar',
  'liturgy': 'Liturgy',
  'hymns': 'Hymns',
  'community': 'Community',
  'more': 'More',
  'prayer': 'Prayer',
  'settings': 'Settings',

  // Common
  'search': 'Search',
  'share': 'Share',
  'bookmark': 'Bookmark',
  'read': 'Read',
  'listen': 'Listen',
  'cancel': 'Cancel',
  'save': 'Save',
  'delete': 'Delete',
  'retry': 'Try Again',
  'loading': 'Loading...',
  'copied': 'Copied!',
  'close': 'Close',
  'yes': 'Yes',
  'no': 'No',

  // Auth / Splash
  'app_name': 'Lutheran Church',
  'app_subtitle': 'Lutheran Church of Rwanda',
  'sign_in': 'Sign In',
  'continue_offline': 'Continue without signing in',
  'offline_hint': 'Bible, Calendar, and Liturgy\nwork without an account.',
  'sign_out': 'Sign Out',
  'sign_out_confirm': 'Do you want to sign out of your account?',
  'sign_out_title': 'Sign Out',
  'register': 'Register',
  'sign_in_or_register': 'Sign In / Register',
  'guest_label': 'No account (Guest)',
  'guest_subtitle': 'Sign in to access all features',

  // Bible
  'old_testament': 'Old Testament',
  'new_testament': 'New Testament',
  'chapter': 'Chapter',
  'verse': 'Verse',
  'reading': 'Reading',
  'verse_of_day': 'VERSE OF THE DAY',
  'books': 'Books',
  'version': 'Version',
  'today_tab': 'Today',
  'books_tab': 'Books',
  'versions_tab': 'Versions',
  'select_chapter': 'Select Chapter',
  'select_version': 'Select Version',
  'start_reading': 'Start Reading',
  'no_internet': 'No internet',
  'no_internet_retry': 'No internet — Try again',
  'loading_bible': 'Loading Bible...',
  'searching_bibles': 'Searching Bibles...',
  'search_bible_hint': 'Search by language or Bible name...',
  'no_bibles_found': 'No Bibles found.\nTry a different language.',
  'no_search_results': 'No results found. Try a different word.',
  'date': 'Date',
  'decrease': 'Decrease',
  'increase': 'Increase',
  'copy_text': 'Copy',
  'no_passage_found': 'Passage not found.\nPlease try again.',
  'all_bibles': 'Bibles',
  'offline_badge': 'offline',

  // Bible stats
  'ot_books': 'Old Testament Books',
  'nt_books': 'New Testament Books',
  'all_chapters': 'Total Chapters',
  'all_verses': 'Total Verses',
  'offline_ready': 'Offline (Kinyarwanda)',

  // Profile
  'profile': 'Profile',
  'edit_profile': 'Edit Profile',
  'personal_info': 'Personal Info',
  'name': 'Name',
  'email': 'Email',
  'church': 'Church',
  'language': 'Language',
  'bible_stats': 'Bible Statistics',
  'actions': 'Actions',
  'reading_streak': 'Reading Streak',
  'sign_in_prompt_title': 'Create Your Account',
  'sign_in_prompt_body':
      'Sign in to save your reading progress, track your spiritual journey, and connect with the community.',
  'days': 'Days',

  // More
  'spiritual_tools': 'Spiritual Tools',
  'church_info': 'Church Info',
  'account_settings': 'Account & Settings',
  'daily_prayers': 'Daily Prayers',
  'daily_prayers_sub': 'Prayers for different occasions',
  'catechism': 'Luther\'s Small Catechism',
  'catechism_sub': 'Commandments, Creed, Lord\'s Prayer',
  'about_lcr': 'About LCR',
  'about_lcr_sub': 'Lutheran Church of Rwanda',
  'share_app': 'Share this App',
  'share_app_sub': 'Tell others about this app',

  // Calendar
  'today': 'Today',
  'daily_reading': 'Daily Reading',
  'season': 'Season',
  'feast_day': 'Feast Day',

  // Liturgy
  'morning_prayer': 'Morning Prayer',
  'evening_prayer': 'Evening Prayer',
  'compline': 'Compline',
  'divine_service': 'Divine Service',
};

// ─────────────────────────────────────────────────────────────────────────────
//  French
// ─────────────────────────────────────────────────────────────────────────────
const Map<String, String> _fr = {
  // Navigation
  'home': 'Accueil',
  'bible': 'Bible',
  'calendar': 'Calendrier',
  'liturgy': 'Liturgie',
  'hymns': 'Hymnes',
  'community': 'Communauté',
  'more': 'Plus',
  'prayer': 'Prière',
  'settings': 'Paramètres',

  // Common
  'search': 'Rechercher',
  'share': 'Partager',
  'bookmark': 'Signet',
  'read': 'Lire',
  'listen': 'Écouter',
  'cancel': 'Annuler',
  'save': 'Enregistrer',
  'delete': 'Supprimer',
  'retry': 'Réessayer',
  'loading': 'Chargement...',
  'copied': 'Copié!',
  'close': 'Fermer',
  'yes': 'Oui',
  'no': 'Non',

  // Auth / Splash
  'app_name': 'Église Luthérienne',
  'app_subtitle': 'Église Luthérienne du Rwanda',
  'sign_in': 'Se Connecter',
  'continue_offline': 'Continuer sans connexion',
  'offline_hint': 'Bible, Calendrier et Liturgie\nfonctionnent sans compte.',
  'sign_out': 'Se Déconnecter',
  'sign_out_confirm': 'Voulez-vous vous déconnecter?',
  'sign_out_title': 'Déconnexion',
  'register': 'S\'inscrire',
  'sign_in_or_register': 'Connexion / Inscription',
  'guest_label': 'Sans compte (Invité)',
  'guest_subtitle': 'Connectez-vous pour accéder à toutes les fonctions',

  // Bible
  'old_testament': 'Ancien Testament',
  'new_testament': 'Nouveau Testament',
  'chapter': 'Chapitre',
  'verse': 'Verset',
  'reading': 'Lecture',
  'verse_of_day': 'VERSET DU JOUR',
  'books': 'Livres',
  'version': 'Version',
  'today_tab': 'Aujourd\'hui',
  'books_tab': 'Livres',
  'versions_tab': 'Versions',
  'select_chapter': 'Sélectionner le chapitre',
  'select_version': 'Sélectionner la version',
  'start_reading': 'Commencer la lecture',
  'no_internet': 'Pas d\'internet',
  'no_internet_retry': 'Pas d\'internet — Réessayer',
  'loading_bible': 'Chargement de la Bible...',
  'searching_bibles': 'Recherche de Bibles...',
  'search_bible_hint': 'Rechercher par langue ou nom de Bible...',
  'no_bibles_found': 'Aucune Bible trouvée.\nEssayez une autre langue.',
  'no_search_results': 'Aucun résultat. Essayez un autre mot.',
  'date': 'Date',
  'decrease': 'Réduire',
  'increase': 'Agrandir',
  'copy_text': 'Copier',
  'no_passage_found': 'Passage introuvable.\nVeuillez réessayer.',
  'all_bibles': 'Bibles',
  'offline_badge': 'hors ligne',

  // Bible stats
  'ot_books': 'Livres de l\'Ancien Testament',
  'nt_books': 'Livres du Nouveau Testament',
  'all_chapters': 'Chapitres au total',
  'all_verses': 'Versets au total',
  'offline_ready': 'Hors ligne (Kinyarwanda)',

  // Profile
  'profile': 'Profil',
  'edit_profile': 'Modifier le profil',
  'personal_info': 'Informations personnelles',
  'name': 'Nom',
  'email': 'Email',
  'church': 'Église',
  'language': 'Langue',
  'bible_stats': 'Statistiques bibliques',
  'actions': 'Actions',
  'reading_streak': 'Série de lectures',
  'sign_in_prompt_title': 'Créez votre compte',
  'sign_in_prompt_body':
      'Connectez-vous pour sauvegarder votre progression, suivre votre parcours spirituel et rejoindre la communauté.',
  'days': 'Jours',

  // More
  'spiritual_tools': 'Outils spirituels',
  'church_info': 'Info sur l\'Église',
  'account_settings': 'Compte & Paramètres',
  'daily_prayers': 'Prières quotidiennes',
  'daily_prayers_sub': 'Prières pour différentes occasions',
  'catechism': 'Petit Catéchisme de Luther',
  'catechism_sub': 'Commandements, Credo, Notre Père',
  'about_lcr': 'À propos de LCR',
  'about_lcr_sub': 'Église Luthérienne du Rwanda',
  'share_app': 'Partager cette application',
  'share_app_sub': 'Parlez de cette app à d\'autres',

  // Calendar
  'today': 'Aujourd\'hui',
  'daily_reading': 'Lecture Quotidienne',
  'season': 'Saison',
  'feast_day': 'Jour de Fête',

  // Liturgy
  'morning_prayer': 'Prière du Matin',
  'evening_prayer': 'Prière du Soir',
  'compline': 'Complies',
  'divine_service': 'Service Divin',
};
