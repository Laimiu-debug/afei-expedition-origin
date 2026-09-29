"""Package legacy icons and reviewed generated replacements at native 56px size."""
from pathlib import Path
import hashlib
import json
import shutil
from io import BytesIO
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
OVERRIDES = ROOT / 'art/runtime/member-skills-v17/manifest.json'


def generated_icons():
    if not OVERRIDES.is_file():
        return {}
    result = {}
    for record in json.loads(OVERRIDES.read_text(encoding='utf-8'))['icons']:
        path = (ROOT / record['source']).resolve()
        if not path.is_relative_to(OVERRIDES.parent.resolve()) or record.get('approved_for_export') is not True:
            raise ValueError('Unreviewed icon source: ' + record['key'])
        if hashlib.sha256(path.read_bytes()).hexdigest() != record['source_sha256']:
            raise ValueError('Generated icon source changed: ' + record['key'])
        result[record['key']] = path
    return result


def export_pixels(source):
    # Deterministic runtime sizing only; artwork is created by image_gen.
    with Image.open(source) as image:
        return image.convert('RGBA').resize((56, 56), Image.Resampling.LANCZOS)


def pairs():
    expansion = json.loads((ROOT / 'data/member-skill-expansion.json').read_text(encoding='utf-8'))['skills']
    icons = {key: BORROWED.get(key, key) for key in KEYS}
    icons.update({key: d['icon'] for key, d in expansion.items()})
    replacements = generated_icons()
    if not replacements.keys() <= icons.keys():
        raise ValueError('Unknown replacement skill icon')
    for key, icon in icons.items():
        source = replacements.get(key, LEGACY / f'afei_{icon}.png')
        yield key, source, ROOT / f'src/gfx/skills/afeix_member_{key}.png'


def validate_icons():
    records = []
    for key, source, target in pairs():
        generated = source.is_relative_to(OVERRIDES.parent)
        if not generated and target.read_bytes() != source.read_bytes():
            raise ValueError(f'Legacy skill image changed: {target}')
        with Image.open(target) as image:
            if image.mode != 'RGBA' or image.size != (56, 56) or image.getchannel('A').getextrema()[1] == 0:
                raise ValueError(f'Invalid skill image: {target}')
            if generated and image.tobytes() != export_pixels(source).tobytes():
                raise ValueError(f'Generated skill export differs: {target}')
        records.append({'key': key, 'source': source.relative_to(ROOT).as_posix(),
                        'output': target.relative_to(ROOT).as_posix(), 'borrowed': not generated and source.stem != 'afei_' + key,
                        'generated': generated,
                        'sha256': hashlib.sha256(target.read_bytes()).hexdigest()})
    return records


def build_art():
    for _, source, target in pairs():
        target.parent.mkdir(parents=True, exist_ok=True)
        if source.is_relative_to(OVERRIDES.parent):
            output = BytesIO()
            export_pixels(source).save(output, format='PNG')
            content = output.getvalue()
            if not target.is_file() or target.read_bytes() != content:
                target.write_bytes(content)
        else:
            shutil.copyfile(source, target)
    records = validate_icons()
    output = ROOT / 'art/runtime/member-skills-v15'
    output.mkdir(parents=True, exist_ok=True)
    (output / 'report.json').write_text(json.dumps(records, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    return [target for _, _, target in pairs()]


if __name__ == '__main__':
    build_art()
