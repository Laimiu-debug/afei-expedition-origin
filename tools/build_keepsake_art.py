"""Reuse reviewed legacy icons byte-for-byte; no new image generation or editing."""
from pathlib import Path
import hashlib
import json
import shutil
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
LEGACY = ROOT / 'legacy/2026-09-25-afei-expedition/reference/src/gfx'


def icon_pairs():
    for name in ('bicycle', 'ecig'):
        for folder in ('items/accessory', 'ui/items/accessory'):
            yield LEGACY / folder / f'afei_{name}.png', ROOT / 'src/gfx' / folder / f'afeix_{name}.png', (70, 70)
    for suffix in ('', '_sw'):
        yield LEGACY / 'skills' / f'afei_ecig_puff{suffix}.png', ROOT / 'src/gfx/skills' / f'afeix_ecig_puff{suffix}.png', (56, 56)


def validate_icons():
    records = []
    for source, output, _ in icon_pairs():
        if source.read_bytes() != output.read_bytes():
            raise ValueError(f'Legacy icon changed: {output}')
        with Image.open(output) as img:
            if img.mode != 'RGBA' or img.getchannel('A').getextrema() != (0, 255):
                raise ValueError(f'Invalid transparent item icon: {output}')
            size = list(img.size)
        records.append({'source': source.relative_to(ROOT).as_posix(), 'output': output.relative_to(ROOT).as_posix(),
                        'size': size, 'sha256': hashlib.sha256(output.read_bytes()).hexdigest()})
    return records


def build_art():
    files = []
    for source, output, _ in icon_pairs():
        output.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(source, output)
        files.append(output)
    records = validate_icons()
    target = ROOT / 'art/runtime/keepsakes-v11'
    target.mkdir(parents=True, exist_ok=True)
    (target / 'report.json').write_text(json.dumps(records, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    return files


if __name__ == '__main__':
    build_art()
