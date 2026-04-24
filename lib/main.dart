import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/localization/app_localizations.dart';
import 'core/services/db_service.dart';
import 'core/services/streak_service.dart';
import 'core/services/local_bible_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/cloud_messaging_service.dart';
import 'core/controllers/bible_controller.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/widgets/auth_gate.dart';
import 'features/settings/presentation/providers/settings_provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive (needed before anything else)
  await Hive.initFlutter();
  await Future.wait([
    Hive.openBox(AppConstants.settingsBox),
    Hive.openBox(AppConstants.bookmarksBox),
  ]);

  // Start these in parallel — Bible loads in background, doesn't block UI
  await Future.wait([
    StreakService.init(),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  ]);

  // Start Bible loading in background (don't await — UI shows immediately)
  LocalBibleService.init();

  // Warm up SQLite so Profile page loads instantly (no spinner on first open)
  DbService.instance.db.ignore();

  // Initialize notifications (depends on Firebase being ready)
  await NotificationService.init();
  await CloudMessagingService.init();

  // Initialize GetX SettingsProvider
  final settingsProvider = Get.put(SettingsProvider());

  // Eagerly initialize BibleController so VOTD loads from cache instantly
  Get.put(BibleController());

  // Schedule daily notifications based on user preference
  NotificationService.syncSchedule(
    enabled: settingsProvider.notificationsEnabled.value,
  );

  runApp(LutheranApp(settingsProvider: settingsProvider));
}

class LutheranApp extends StatelessWidget {
  final SettingsProvider settingsProvider;
  const LutheranApp({super.key, required this.settingsProvider});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(seasonColor: settingsProvider.getSeasonColor()),
        darkTheme: AppTheme.darkTheme(seasonColor: settingsProvider.getSeasonColor()),
        themeMode: ThemeMode.system,
        locale: Locale(settingsProvider.language.value),
        supportedLocales: const [
          Locale('rw'), // Kinyarwanda
          Locale('en'), // English
          Locale('fr'), // French
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          // Fall back to English for Material localization (rw not supported by Flutter)
          if (locale?.languageCode == 'rw') return const Locale('en');
          for (final supported in supportedLocales) {
            if (supported.languageCode == locale?.languageCode) return supported;
          }
          return const Locale('en');
        },
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const AuthGate(),
      ),
    );
  }
}
