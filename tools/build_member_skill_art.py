"""Reuse legacy 56px icons without editing; record every source and SHA-256."""
from pathlib import Path
import hashlib
import json
import shutil
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
LEGACY = ROOT / 'legacy/2026-09-25-afei-expedition/reference/src/gfx/skills'
KEYS = ('bottle_breakthrough', 'finals_moment', 'dog_bark', 'loyalty',
        'nicotine', 'only_man', 'breach_strike', 'lvbu_weapon',
        'borrow_strike', 'together_lift', 'steady_hand', 'blue_form',
        'guard_nest', 'goose_bully', 'pokemon', 'breathe_easy',
        'turtle_shell', 'turtle_bond')
# Xiaogui had no old skill group. These are explicitly borrowed shield motifs.
BORROWED = {'turtle_shell': 'shrink_cover', 'turtle_bond': 'guard_self'}


def pairs():
    expansion = json.loads((ROOT / 'data/member-skill-expansion.json').read_text(encoding='utf-8'))['skills']
    icons = {key: BORROWED.get(key, key) for key in KEYS}
    icons.update({key: d['icon'] for key, d in expansion.items()})
    for key, icon in icons.items():
        source = LEGACY / f'afei_{icon}.png'
        yield key, source, ROOT / f'src/gfx/skills/afeix_member_{key}.png'


def validate_icons():
    records = []
    for key, source, target in pairs():
        if target.read_bytes() != source.read_bytes():
            raise ValueError(f'Legacy skill image changed: {target}')
        with Image.open(target) as image:
            if image.mode != 'RGBA' or image.size != (56, 56) or image.getchannel('A').getextrema()[1] == 0:
                raise ValueError(f'Invalid skill image: {target}')
        records.append({'key': key, 'source': source.relative_to(ROOT).as_posix(),
                        'output': target.relative_to(ROOT).as_posix(), 'borrowed': source.stem != 'afei_' + key,
                        'sha256': hashlib.sha256(target.read_bytes()).hexdigest()})
    return records


def build_art():
    for _, source, target in pairs():
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(source, target)
    records = validate_icons()
    output = ROOT / 'art/runtime/member-skills-v15'
    output.mkdir(parents=True, exist_ok=True)
    (output / 'report.json').write_text(json.dumps(records, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    return [target for _, _, target in pairs()]


if __name__ == '__main__':
    build_art()
