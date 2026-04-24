# Hymn Verses Integration Guide

## Current Status

Your Lutheran Church app now has:
- ✅ **414 hymns** with titles and metadata
- ✅ **All hymns are clickable** in the UI (no longer disabled)
- ✅ **18 hymns have verse content** (4.3%)
- ❌ **396 hymns need verses** (95.7%)

## What Changed

### UI Improvements
1. **All hymns now clickable** - Previously, only hymns with verses were clickable. Now all 414 can be tapped.
2. **Placeholder message for empty hymns** - When users tap hymns without verses, they see:
   - 🎵 Icon
   - "Indirimbo idakora" (Song not yet available)
   - Message asking community to contribute verses

### File Modified
- `lib/features/hymns/presentation/pages/hymns_page.dart`
  - Made all hymns clickable (lines 413-423)
  - Added conditional display for hymns with/without verses (lines 571-644)

## How to Add Hymn Verses

### Option 1: Quick Check with Helper Tool
```bash
# Check overall statistics
python3 scripts/hymn_verse_generator.py stats

# Check specific hymn
python3 scripts/hymn_verse_generator.py check 1

# List all hymns without verses
python3 scripts/hymn_verse_generator.py list-missing
```

### Option 2: Manual Addition (Recommended for now)

Since extracting from the IGITABO 3 PDF programmatically is complex, here's the manual approach:

**Step 1:** Open `lib/core/data/hymns_data.dart`

**Step 2:** Find a hymn without verses. Example: Hymn 19
```dart
// BEFORE (no verses)
Hymn(
  number: 19,
  title: 'Umwana yavukiye mu murwa',
),
```

**Step 3:** Look up the hymn in IGITABO 3.docx.pdf and copy the verses

**Step 4:** Add verses in this format:
```dart
// AFTER (with verses)
Hymn(
  number: 19,
  title: 'Umwana yavukiye mu murwa',
  verses: [
    HymnVerse(
      number: 1,
      text:
          "Umwana yavukiye mu murwa wa Bethilehemu,\n"
          "Yesu Kristo mwami wanjye,\n"
          "Urambura ubwoba no guciza ibibi,\n"
          "N'iguhe inzira y'ubugingo.",
    ),
    HymnVerse(
      number: 2,
      text:
          "Imana yatugombagombaga cyane,\n"
          "Nuko iwe Umwana ivugayo,\n"
          "Ati ni mwami navugamba ngo ninkora,\n"
          "Dusenge icyubahiro cyese.",
    ),
    // ... add more verses as needed
  ],
),
```

## Format Guidelines

### Verse Text Rules
- Use `\n` for line breaks (not actual newlines in the code)
- Wrap long lines in Dart at reasonable lengths (80-100 chars)
- Keep verse structure with musical phrasing in mind

### Example Proper Formatting:
```dart
HymnVerse(
  number: 1,
  text:
      "Line 1 of verse 1,\n"
      "Line 2 of verse 1,\n"
      "Line 3 of verse 1.",
),
```

NOT like this:
```dart
// ❌ WRONG - entire verse on one line
HymnVerse(number: 1, text: "Line 1,\nLine 2,\nLine 3."),
```

## Priority Hymns to Add

Based on liturgical importance, prioritize these categories:
1. **Christmas** (Hymns ~19-23)
2. **Easter** (Hymns ~24-35)
3. **Pentecost** (Hymns ~36-42)
4. **Baptism** (Hymns ~95-100)
5. **Communion** (Hymns ~104-110)

## Community Contribution

To enable community members to contribute verses:

1. **Save time** - Not all 414 verses need to be perfect initially
2. **Start with most-used** - Add verses for hymns sung most frequently first
3. **Test in app** - Run `flutter run` to verify verses display correctly

## Next Steps

### Short term (This week)
- [ ] Add verses for at least the 6 hymns used in each main category
- [ ] Test that verses display properly in the app
- [ ] Create a community form/issue for verse contributions

### Medium term
- [ ] Add remaining verses for all 414 hymns
- [ ] Extract verses automatically from IGITABO PDF (if extraction method improves)
- [ ] Add tune names and source references where available

### Long term
- [ ] Audio recordings for each hymn
- [ ] Musical notation (ABC or MusicXML)
- [ ] Lyrics with chord notation for musicians

## Troubleshooting

### Verses don't show after adding them
1. Run `flutter pub get`
2. Run `flutter clean`
3. Run `flutter run`

### Quote/escaping issues
- Use single quotes for Dart strings
- Escape internal quotes with backslash: `\"`
- Use `\n` for line breaks

### Formatting looks weird in app
- Make sure `\n` characters are in the right places
- Check that the Dart formatting is correct (no syntax errors)
- Run `flutter analyze` to check for issues

## IGITABO 3 Reference

The official LCR hymn book "IGITABO - TURIRIMBIRE IMANA" contains:
- All 414 hymns organized in 39 liturgical categories
- Verses in Kinyarwanda (primary language)
- Some verses translated to English/French
- Tune names and musical sources

File location: `/home/enock/lutheran/IGITABO 3.docx.pdf`

## Resources

- **Hymn Data Structure**: `lib/core/data/hymns_data.dart`
- **Hymn Display UI**: `lib/features/hymns/presentation/pages/hymns_page.dart`
- **Helper Tool**: `scripts/hymn_verse_generator.py`
- **IGITABO PDF**: `IGITABO 3.docx.pdf`

## Questions?

When adding verses, ensure:
1. ✅ Text matches IGITABO 3 exactly (preserve Kinyarwanda)
2. ✅ Verse numbers are sequential (1, 2, 3, ...)
3. ✅ No syntax errors in Dart code
4. ✅ App compiles and runs (`flutter analyze` passes)
