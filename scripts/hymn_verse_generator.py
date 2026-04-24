#!/usr/bin/env python3
"""
Hymn Verse Generator - Helper tool to extract and add hymn verses to hymns_data.dart

This script helps populate missing hymn verses in the Lutheran Church app.
It provides utilities to:
1. Extract hymn verses from IGITABO 3 PDF
2. Format verses as Dart code
3. Update hymns_data.dart with new verses

Usage:
    python3 scripts/hymn_verse_generator.py extract-from-pdf
    python3 scripts/hymn_verse_generator.py add-verses <hymn_number> <verses_text>
    python3 scripts/hymn_verse_generator.py list-missing
"""

import re
import sys
import json
from pathlib import Path
from typing import Dict, List, Tuple

class HymnDataHelper:
    def __init__(self, hymns_data_path: str = "lib/core/data/hymns_data.dart"):
        self.hymns_data_path = Path(hymns_data_path)
        self.content = self.hymns_data_path.read_text(encoding='utf-8')
    
    def get_all_hymn_numbers(self) -> List[int]:
        """Extract all hymn numbers from hymns_data.dart"""
        matches = re.findall(r'number:\s*(\d+)', self.content)
        return sorted(set(int(m) for m in matches))
    
    def get_hymns_with_verses(self) -> List[int]:
        """Return hymn numbers that have verse content"""
        hymns_with_verses = []
        # Find Hymn definitions with verses
        pattern = r'Hymn\(\s*number:\s*(\d+),.*?verses:\s*\['
        for match in re.finditer(pattern, self.content, re.DOTALL):
            hymns_with_verses.append(int(match.group(1)))
        return sorted(hymns_with_verses)
    
    def get_hymns_without_verses(self) -> List[int]:
        """Return hymn numbers that are missing verse content"""
        all_hymns = set(self.get_all_hymn_numbers())
        with_verses = set(self.get_hymns_with_verses())
        return sorted(all_hymns - with_verses)
    
    def format_verse(self, verse_num: int, text: str) -> str:
        """Format a single verse as Dart code"""
        # Escape quotes and format multi-line text
        escaped = text.replace('"', '\\"').replace('\n', '\\n"\n            "')
        return f'''      HymnVerse(
        number: {verse_num},
        text:
            "{escaped}",
      ),'''
    
    def format_verses(self, verses: List[str]) -> str:
        """Format multiple verses as Dart code"""
        formatted = []
        for i, verse_text in enumerate(verses, 1):
            formatted.append(self.format_verse(i, verse_text.strip()))
        return '\n'.join(formatted)
    
    def find_hymn_definition(self, hymn_num: int) -> Tuple[int, int, str]:
        """Find the start and end line of a hymn definition"""
        pattern = rf'Hymn\(\s*number:\s*{hymn_num}\b'
        match = re.search(pattern, self.content)
        if not match:
            return None
        
        start_pos = match.start()
        # Find matching closing paren
        paren_count = 0
        in_string = False
        escaped = False
        
        pos = self.content.find('(', start_pos)
        start = pos
        paren_count = 1
        pos += 1
        
        while pos < len(self.content) and paren_count > 0:
            char = self.content[pos]
            
            if escaped:
                escaped = False
            elif char == '\\':
                escaped = True
            elif char == '"':
                in_string = not in_string
            elif not in_string:
                if char == '(':
                    paren_count += 1
                elif char == ')':
                    paren_count -= 1
            
            pos += 1
        
        end = pos
        hymn_def = self.content[start:end]
        
        # Get line numbers
        line_num_start = self.content[:start].count('\n')
        line_num_end = self.content[:end].count('\n')
        
        return line_num_start, line_num_end, hymn_def
    
    def list_missing_hymns(self):
        """Print hymns without verses"""
        missing = self.get_hymns_without_verses()
        print(f"Hymns without verses: {len(missing)}")
        print(f"First 20: {missing[:20]}")
        return missing
    
    def extract_hymn_info(self, hymn_num: int) -> Dict:
        """Extract information about a specific hymn"""
        pattern = rf'Hymn\(\s*number:\s*{hymn_num}\b,\s*title:\s*["\']([^"\']+)["\']'
        match = re.search(pattern, self.content)
        
        if not match:
            return None
        
        title = match.group(1)
        has_verses = f'Hymn(\n    number: {hymn_num},' in self.content and 'verses:' in self.content[match.start():match.start()+500]
        
        return {
            'number': hymn_num,
            'title': title,
            'has_verses': has_verses
        }


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)
    
    command = sys.argv[1]
    helper = HymnDataHelper()
    
    if command == 'list-missing':
        missing = helper.list_missing_hymns()
        print(f"\nTotal missing verses: {len(missing)}")
    
    elif command == 'list-with-verses':
        with_verses = helper.get_hymns_with_verses()
        print(f"Hymns with verses: {len(with_verses)}")
        print(f"Numbers: {with_verses}")
    
    elif command == 'check':
        if len(sys.argv) < 3:
            print("Usage: check <hymn_number>")
            sys.exit(1)
        hymn_num = int(sys.argv[2])
        info = helper.extract_hymn_info(hymn_num)
        if info:
            print(f"Hymn {hymn_num}: {info['title']}")
            print(f"Has verses: {info['has_verses']}")
        else:
            print(f"Hymn {hymn_num} not found")
    
    elif command == 'stats':
        all_hymns = helper.get_all_hymn_numbers()
        with_verses = helper.get_hymns_with_verses()
        missing = len(all_hymns) - len(with_verses)
        
        print(f"Total hymns defined: {len(all_hymns)}")
        print(f"With verse content: {len(with_verses)} ({100*len(with_verses)/len(all_hymns):.1f}%)")
        print(f"Without verses: {missing} ({100*missing/len(all_hymns):.1f}%)")
        print(f"\nFirst 10 missing: {helper.get_hymns_without_verses()[:10]}")
    
    else:
        print(f"Unknown command: {command}")
        print(__doc__)
        sys.exit(1)


if __name__ == '__main__':
    main()
