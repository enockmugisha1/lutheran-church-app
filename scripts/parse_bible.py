#!/usr/bin/env python3
"""
Parse Kinyarwanda Bible PDF text into structured JSON.
"""
import re
import json
import sys
from pathlib import Path

# Mapping: chapter_prefix -> (book_id, book_name_rw, book_name_en, testament)
BOOKS = [
    # Old Testament
    ("GEN",  "Intangiriro",        "Itangiriro",             "Genesis",             "OT"),
    ("EXO",  "Kuva",               "Kuva",                    "Exodus",              "OT"),
    ("LEV",  "Abalewi",            "Abalewi",                 "Leviticus",           "OT"),
    ("NUM",  "Kubara",             "Kubara",                  "Numbers",             "OT"),
    ("DEU",  "Ivug",               "Gutegeka Kwa Kabiri",     "Deuteronomy",         "OT"),
    ("JOS",  "Yosuwa",             "Yosuwa",                  "Joshua",              "OT"),
    ("JDG",  "Abacamanza",         "Abacamanza",              "Judges",              "OT"),
    ("RUT",  "Rusi",               "Rusi",                    "Ruth",                "OT"),
    ("1SA",  "1 Samweli",          "I Samweli",               "1 Samuel",            "OT"),
    ("2SA",  "2 Samweli",          "II Samweli",              "2 Samuel",            "OT"),
    ("1KI",  "1 Abami",            "I Abami",                 "1 Kings",             "OT"),
    ("2KI",  "2 Abami",            "II Abami",                "2 Kings",             "OT"),
    ("1CH",  "1 Ngoma",            "I Ngoma",                 "1 Chronicles",        "OT"),
    ("2CH",  "2 Ngoma",            "II Ngoma",                "2 Chronicles",        "OT"),
    ("EZR",  "Ezira",              "Ezira",                   "Ezra",                "OT"),
    ("NEH",  "Nehemiya",           "Nehemiya",                "Nehemiah",            "OT"),
    ("EST",  "Esiteri",            "Esiteri",                 "Esther",              "OT"),
    ("JOB",  "Yobu",               "Yobu",                    "Job",                 "OT"),
    ("PSA",  "Zaburi",             "Zaburi",                  "Psalms",              "OT"),
    ("PRO",  "Imigani",            "Imigani",                 "Proverbs",            "OT"),
    ("ECC",  "Umubwiriza",         "Umubwiriza",              "Ecclesiastes",        "OT"),
    ("SNG",  "Indirimbo Ya Salomo","Indirimbo ya Salomo",     "Song of Solomon",     "OT"),
    ("ISA",  "Yesaya",             "Yesaya",                  "Isaiah",              "OT"),
    ("JER",  "Yeremiya",           "Yeremiya",                "Jeremiah",            "OT"),
    ("LAM",  "Amag",               "Amaganya ya Yeremiya",    "Lamentations",        "OT"),
    ("EZK",  "Ezekiyeli",          "Ezekiyeli",               "Ezekiel",             "OT"),
    ("DAN",  "Daniyeli",           "Daniyeli",                "Daniel",              "OT"),
    ("HOS",  "Hoseya",             "Hoseya",                  "Hosea",               "OT"),
    ("JOL",  "Yoweli",             "Yoweli",                  "Joel",                "OT"),
    ("AMO",  "Amosi",              "Amosi",                   "Amos",                "OT"),
    ("OBA",  "Obadiya",            "Obadiya",                 "Obadiah",             "OT"),
    ("JNA",  "Yona",               "Yona",                    "Jonah",               "OT"),
    ("MIC",  "Mika",               "Mika",                    "Micah",               "OT"),
    ("NAH",  "Nahumu",             "Nahumu",                  "Nahum",               "OT"),
    ("HAB",  "Habakuki",           "Habakuki",                "Habakkuk",            "OT"),
    ("ZEP",  "Zefaniya",           "Zefaniya",                "Zephaniah",           "OT"),
    ("HAG",  "Hagayi",             "Hagayi",                  "Haggai",              "OT"),
    ("ZEC",  "Zekariya",           "Zekariya",                "Zechariah",           "OT"),
    ("MAL",  "Malaki",             "Malaki",                  "Malachi",             "OT"),
    # New Testament
    ("MAT",  "Matayo",             "Matayo",                  "Matthew",             "NT"),
    ("MRK",  "Mariko",             "Mariko",                  "Mark",                "NT"),
    ("LUK",  "Luka",               "Luka",                    "Luke",                "NT"),
    ("JHN",  "Yohana",             "Yohana",                  "John",                "NT"),
    ("ACT",  "Ibyakozwe N\u2019intumwa","Ibyakozwe n'intumwa",  "Acts",                "NT"),
    ("ROM",  "Abaroma",            "Abaroma",                 "Romans",              "NT"),
    ("1CO",  "1 Abakorinto",       "I Abakorinto",            "1 Corinthians",       "NT"),
    ("2CO",  "2 Abakorinto",       "II Abakorinto",           "2 Corinthians",       "NT"),
    ("GAL",  "Abagalatiya",        "Abagalatiya",             "Galatians",           "NT"),
    ("EPH",  "Abefeso",            "Abefeso",                 "Ephesians",           "NT"),
    ("PHP",  "Abafilipi",          "Abafilipi",               "Philippians",         "NT"),
    ("COL",  "Abakolosayi",        "Abakolosayi",             "Colossians",          "NT"),
    ("1TH",  "1 Abatesalonike",    "I Abatesalonike",         "1 Thessalonians",     "NT"),
    ("2TH",  "2 Abatesalonike",    "II Abatesalonike",        "2 Thessalonians",     "NT"),
    ("1TI",  "1 Timoteyo",         "I Timoteyo",              "1 Timothy",           "NT"),
    ("2TI",  "2 Timoteyo",         "II Timoteyo",             "2 Timothy",           "NT"),
    ("TIT",  "Tito",               "Tito",                    "Titus",               "NT"),
    ("PHM",  "Filemoni",           "Filemoni",                "Philemon",            "NT"),
    ("HEB",  "Abaheburayo",        "Abaheburayo",             "Hebrews",             "NT"),
    ("JAS",  "Yakobo",             "Yakobo",                  "James",               "NT"),
    ("1PE",  "1 Petero",           "I Petero",                "1 Peter",             "NT"),
    ("2PE",  "2 Petero",           "II Petero",               "2 Peter",             "NT"),
    ("1JN",  "1 Yohana",           "I Yohana",                "1 John",              "NT"),
    ("2JN",  "2 Yohana",           "II Yohana",               "2 John",              "NT"),
    ("3JN",  "3 Yohana",           "III Yohana",              "3 John",              "NT"),
    ("JUD",  "Yuda",               "Yuda",                    "Jude",                "NT"),
    ("REV",  "Ibyahishuwe Yohana", "Ibyahishuwe",             "Revelation",          "NT"),
]

# Build lookup: chapter_prefix (uppercase) -> book info
CHAPTER_PREFIX_MAP = {}
for book in BOOKS:
    book_id, ch_prefix, name_rw, name_en, testament = book
    CHAPTER_PREFIX_MAP[ch_prefix.upper()] = {
        "id": book_id,
        "name_rw": name_rw,
        "name_en": name_en,
        "testament": testament,
        "chapter_prefix": ch_prefix,
    }

# Pattern to detect chapter headers: "BookPrefix ChapterNumber"
CHAPTER_RE = re.compile(
    r'^(' + '|'.join(re.escape(b[1]) for b in BOOKS) + r')\s*(\d+)$',
    re.IGNORECASE
)

# Pattern for verse start: one or more digits immediately followed by text (or space then text)
VERSE_START_RE = re.compile(r'^(\d+)\s*(.*)')

# Lines to skip (copyright, page numbers, etc.)
SKIP_PATTERNS = [
    re.compile(r'^Bibiliya Yera\s*$', re.IGNORECASE),
    re.compile(r'^©\s*\d{4}'),
    re.compile(r'^Bible Society of Rwanda'),
    re.compile(r'^\d{1,4}$'),  # bare page numbers
    re.compile(r'^Kinyarwanda Language\s*$'),
    re.compile(r'^Kinyarwanda - All Bible\s*$'),
    re.compile(r'^ISEZERANO RYA (KERA|RISHYA)\s*$', re.IGNORECASE),
    re.compile(r'^Igitabo Cy', re.IGNORECASE),  # book intro headers
    re.compile(r'^Old Teswtament\s*$', re.IGNORECASE),
    re.compile(r'^New Teswtament\s*$', re.IGNORECASE),
    re.compile(r'^\d+\.\d+$'),  # page ref like 1.031
]


def should_skip(line):
    for p in SKIP_PATTERNS:
        if p.match(line):
            return True
    return False


def parse_bible(text_path):
    with open(text_path, 'r', encoding='utf-8') as f:
        raw_lines = f.readlines()

    # Strip all lines
    lines = [l.rstrip('\n') for l in raw_lines]

    # Build chapter prefix -> book_id map (case-insensitive, normalized)
    prefix_to_book = {}
    for book_id, ch_prefix, name_rw, name_en, testament in BOOKS:
        prefix_to_book[ch_prefix.upper()] = (book_id, name_rw, name_en, testament)

    books_data = {}  # book_id -> {meta, chapters: {num -> {num -> verse_text}}}
    book_order = []

    current_book_id = None
    current_chapter = None
    current_verse_num = None
    current_verse_lines = []

    def save_verse():
        nonlocal current_verse_lines
        if current_book_id and current_chapter and current_verse_num is not None:
            text = ' '.join(current_verse_lines).strip()
            text = re.sub(r'\s+', ' ', text)
            if text:
                books_data[current_book_id]["chapters"] \
                    .setdefault(current_chapter, {})[current_verse_num] = text
        current_verse_lines = []

    i = 0
    total = len(lines)
    while i < total:
        line = lines[i].strip()
        i += 1

        if not line:
            continue

        if should_skip(line):
            continue

        # Check if it's a chapter header
        m = CHAPTER_RE.match(line)
        if m:
            save_verse()
            prefix_matched = m.group(1).upper()
            ch_num = int(m.group(2))

            if prefix_matched in prefix_to_book:
                book_id, name_rw, name_en, testament = prefix_to_book[prefix_matched]
                current_book_id = book_id
                current_chapter = ch_num
                current_verse_num = None

                if book_id not in books_data:
                    books_data[book_id] = {
                        "id": book_id,
                        "name": name_rw,
                        "name_en": name_en,
                        "testament": testament,
                        "chapters": {}
                    }
                    book_order.append(book_id)
            continue

        # Check if it's a verse line
        if current_book_id and current_chapter:
            vm = VERSE_START_RE.match(line)
            if vm:
                save_verse()
                current_verse_num = int(vm.group(1))
                rest = vm.group(2).strip()
                current_verse_lines = [rest] if rest else []
                continue
            else:
                # Continuation of current verse (section headers or continuation text)
                # Only add if it looks like prose (not a section title in isolation)
                if current_verse_num is not None:
                    current_verse_lines.append(line)
                # else: section title before first verse - skip

    save_verse()

    # Build final structure preserving book order
    result = {
        "version": "Bibiliya Yera 2001",
        "language": "Kinyarwanda",
        "source": "Bible Society of Rwanda, 2001",
        "books": []
    }

    for book_id in book_order:
        bdata = books_data[book_id]
        chapters_list = []
        for ch_num in sorted(bdata["chapters"].keys()):
            verses_dict = bdata["chapters"][ch_num]
            verses_list = [
                {"verse": v, "text": verses_dict[v]}
                for v in sorted(verses_dict.keys())
            ]
            chapters_list.append({
                "chapter": ch_num,
                "verses": verses_list
            })
        result["books"].append({
            "id": bdata["id"],
            "name": bdata["name"],
            "name_en": bdata["name_en"],
            "testament": bdata["testament"],
            "chapters": chapters_list
        })

    return result


if __name__ == "__main__":
    text_path = "/tmp/bible_raw.txt"
    out_path = "/home/enock/lutheran/assets/data/kinyarwanda_bible.json"

    print("Parsing Bible text...", flush=True)
    data = parse_bible(text_path)

    total_books = len(data["books"])
    total_chapters = sum(len(b["chapters"]) for b in data["books"])
    total_verses = sum(
        len(ch["verses"])
        for b in data["books"]
        for ch in b["chapters"]
    )

    print(f"Books: {total_books}")
    print(f"Chapters: {total_chapters}")
    print(f"Verses: {total_verses}")

    # Show first few books
    for b in data["books"][:5]:
        ch_count = len(b["chapters"])
        v_count = sum(len(c["verses"]) for c in b["chapters"])
        print(f"  {b['id']} - {b['name']} ({b['name_en']}): {ch_count} chapters, {v_count} verses")

    print(f"\nWriting to {out_path}...")
    Path(out_path).parent.mkdir(parents=True, exist_ok=True)
    with open(out_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    size_mb = Path(out_path).stat().st_size / 1024 / 1024
    print(f"Done! File size: {size_mb:.2f} MB")

    # Also show a sample verse
    gen = next((b for b in data["books"] if b["id"] == "GEN"), None)
    if gen:
        v1 = gen["chapters"][0]["verses"][0]
        print(f"\nSample - Genesis 1:1: {v1['text'][:100]}")
