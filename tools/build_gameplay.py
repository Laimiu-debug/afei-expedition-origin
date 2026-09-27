"""Validate and package the gameplay prototype without bundling native artwork."""
from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED, ZipInfo
import argparse
import hashlib
import json
import subprocess
import sys
from check_gameplay import validate
from render_member_catalog import render_catalog
from apply_character_stories import apply_stories
from build_gameplay_art import build_art
from build_portrait_art import build_art as build_portrait_art
from render_portrait_prompts import render_prompts
from build_keepsake_art import build_art as build_keepsake_art
from build_member_skill_art import build_art as build_member_skill_art
from render_member_skills import render as render_member_skills
from render_skill_expansion import render as render_skill_expansion

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--sq', type=Path, default=ROOT / '.cache/afei-art/bbros-modkit-v9/bin/sq.exe')
    parser.add_argument('--game', type=Path, default=Path('F:/SteamLibrary/steamapps/common/Battle Brothers'))
    args = parser.parse_args()
    render_skill_expansion()
    apply_stories()
    subprocess.run([sys.executable, str(ROOT / 'tools/render_member_growth.py')], check=True)
    art_files, art_report = build_art()
    portrait_files, portrait_report = build_portrait_art()
    render_prompts()
    art_files.extend(portrait_files)
    art_files.extend(build_keepsake_art())
    art_files.extend(build_member_skill_art())
    validation = validate(args.sq.resolve(), args.game.resolve())
    render_member_skills()
    render_catalog(json.loads((ROOT / 'build/characters.json').read_text(encoding='utf-8')))
    subprocess.run([sys.executable, str(ROOT / 'tools/render_character_stats.py')], check=True, stdout=subprocess.DEVNULL)
    files = sorted(p for p in (ROOT / 'src').rglob('*') if p.is_file())
    if any(p.suffix not in {'.nut', '.js', '.css', '.png', '.brush'} for p in files):
        raise ValueError('Unexpected file type in gameplay package')
    if any(p.suffix in {'.png', '.brush'} and p not in art_files for p in files):
        raise ValueError('Only reviewed custom art may enter the gameplay package')
    destination = ROOT / 'dist/mod_afeix_expedition.zip'
    destination.parent.mkdir(exist_ok=True)
    with ZipFile(destination, 'w', compression=ZIP_DEFLATED) as z:
        for path in files:
            info = ZipInfo(path.relative_to(ROOT / 'src').as_posix(), (2026, 9, 26, 0, 0, 0))
            info.compress_type = ZIP_DEFLATED
            z.writestr(info, path.read_bytes())
    with ZipFile(destination) as z:
        if z.testzip() is not None:
            raise ValueError('ZIP CRC failed')
        for path in files:
            if z.read(path.relative_to(ROOT / 'src').as_posix()) != path.read_bytes():
                raise ValueError(f'ZIP/source mismatch: {path}')
    report = {
        'package': destination.relative_to(ROOT).as_posix(), 'sha256': hashlib.sha256(destination.read_bytes()).hexdigest(),
        'entries': [p.relative_to(ROOT / 'src').as_posix() for p in files],
        'crc_passed': True, 'source_bytes_match': True, 'contains_custom_art': True,
        'custom_art_files': [p.relative_to(ROOT / 'src').as_posix() for p in art_files],
        'art_report': 'art/runtime/gameplay-v03/build/report.json',
        'portrait_report': 'art/runtime/portraits-v05/build/report.json',
        'portrait_characters': portrait_report['named_characters'],
        'portrait_forms': portrait_report['exported_forms'],
        'member_skill_art_report': 'art/runtime/member-skills-v15/report.json',
        'version': '0.16.1', 'members_with_skills': 33, 'member_skills': 99,
        'new_member_skills_this_version': 0,
        'behavior_assertions': sum(t['assertions'] for t in validation['tests']), 'in_game_tested': False,
        'named_characters': validation['named_characters'], 'roster_capacity': validation['roster_capacity'],
        'combat_capacity': validation['combat_capacity'],
    }
    (ROOT / 'build/gameplay-package.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(f'Built {destination} ({len(files)} files). Static and isolated behavior checks passed; no in-game validation.')


if __name__ == '__main__':
    main()
