# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A multi-platform Lutheran Church mobile/desktop application built with Flutter (Dart). The app is Kinyarwanda-first and targets Rwandan Lutheran communities. It includes a Bible reader, liturgy companion, hymnal, liturgical calendar, catechism tools, and a community prayer wall.

## Commands

```bash
# Install dependencies
flutter pub get

# Run the app (Android/iOS device or emulator)
flutter run

# Build APK
flutter build apk --release

# Build web
flutter build web

# Lint / analyze
flutter analyze

# Format code
dart format lib/

# Run tests
flutter test

# Run a single test file
flutter test test/widget_test.dart

# Regenerate Hive adapters (when adding new Hive models)
flutter pub run build_runner build --delete-conflicting-outputs
```

## Architecture

The app follows a **feature-based Clean Architecture** pattern:

```
lib/
├── main.dart               # Entry point; initializes Firebase, Hive, services
├── firebase_options.dart   # Firebase config
├── core/
│   ├── constants/          # App-wide constants (liturgical colors, routes)
│   ├── controllers/        # Global GetX controllers (BibleController, etc.)
│   ├── data/               # Hardcoded static data (liturgy texts, calendar, VOTD verses)
│   ├── localization/       # Custom AppLocalizations for Kinyarwanda/English/French
│   ├── services/           # Shared services (Auth, Bible APIs, DB, Notifications)
│   ├── theme/              # AppTheme (deep maroon primary, warm gold accent)
│   └── widgets/            # Reusable core widgets
└── features/               # One directory per feature
    ├── home/               # Dashboard + bottom navigation (5 tabs)
    ├── bible/              # Bible reader; uses LocalBibleService (SQLite) + BibleApiService
    ├── liturgy/            # Daily liturgy; data from core/data/liturgy_data.dart
    ├── calendar/           # Liturgical calendar; data from core/data/calendar_data_2026.dart
    ├── hymns/              # Hymnal library
    ├── catechism/          # Luther's Catechism
    ├── auth/               # Firebase email/password + Google Sign-In
    ├── community/          # Prayer wall (Firestore-backed)
    ├── prayer/             # Prayer features
    ├── profile/            # User profile (Firestore user document)
    ├── settings/           # Language selector, notifications, preferences
    ├── more/               # Extra features
    └── onboarding/         # App introduction (planned)
```

## State Management

- **GetX** (`get` package) is the primary state management and navigation framework. Global controllers are registered in `main.dart` via `Get.put()`.
- **Provider** is also present for some features.
- Bottom navigation is tab-based inside `HomePage`; GetX handles routing.

## Initialization Sequence (main.dart)

Services are initialized in a specific order on startup:
1. Hive (local NoSQL storage for settings & bookmarks)
2. Firebase + StreakService — initialized in parallel
3. `LocalBibleService` — loads the offline Bible into SQLite in the background (non-blocking)
4. `DbService` warmup — pre-loads SQLite for instant profile rendering
5. Notification services (`NotificationService`, `CloudMessagingService`)
6. GetX controllers (`SettingsProvider`, `BibleController`) registered globally

Do not reorder these without understanding the dependency chain.

## Localization

- Default language: **Kinyarwanda** (`rw`)
- Also supports English (`en`) and French (`fr`)
- Translation strings live in `lib/core/localization/app_localizations.dart` as Dart maps
- Language preference is stored per-user in Firestore and locally via `SettingsProvider`

## Data Storage Layers

| Layer | Package | Used For |
|-------|---------|----------|
| Hive | `hive_flutter` | Settings, bookmarks (offline, fast) |
| SQLite | `sqflite` | Offline Bible text, DB service |
| Firestore | `cloud_firestore` | User profiles, posts, prayers |
| Firebase Storage | `firebase_storage` | Media assets |
| SharedPreferences | `shared_preferences` | Lightweight persisted prefs |

## Firebase

- Project ID: `lutheran-church-app-b6da5`
- Services: Authentication, Cloud Firestore, Firebase Storage, Cloud Messaging
- Android config: `google-services.json`; multi-platform config: `firebase_options.dart`
- Firestore security rules are in `firestore.rules`

## Key Services

- `AuthService` — Firebase Auth (email/password + Google Sign-In); creates Firestore user doc on register
- `LocalBibleService` — loads offline Bible into SQLite; must be awaited before Bible features work
- `BibleApiService` — external API for additional translations
- `NotificationService` + `CloudMessagingService` — local + FCM push notifications with daily reminders
- `DBService` — SQLite wrapper; warmed up in `main.dart` for instant reads

## Static Content

Large static datasets are hardcoded as Dart files (not JSON/assets) for performance:
- `lib/core/data/liturgy_data.dart` — liturgy texts
- `lib/core/data/calendar_data_2026.dart` — 2026 liturgical calendar
- `lib/core/data/kjv_votd_verses.dart` — Verse of the Day pool

When adding a new year's calendar, create a new `calendar_data_YYYY.dart` file following the same structure.

## Theme

- Primary: Deep Maroon `#4A1028`
- Accent: Warm Gold `#C9A84C`
- Surface: Warm off-white `#FAF7F2`
- Header font: Google Fonts Cinzel
- Material 3 enabled; dark mode supported via system setting
- Liturgical season colors defined in `lib/core/constants/liturgical_colors.dart`
