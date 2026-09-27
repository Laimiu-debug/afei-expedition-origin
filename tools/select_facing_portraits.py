"""Select reviewed right-facing revisions while preserving the previous manifest."""
from pathlib import Path
import hashlib
import json

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / 'art/runtime/portraits-v05'


def main():
    path = BASE / 'manifest.json'
    before = BASE / 'manifest-before-facing.json'
    if not before.exists():
        before.write_bytes(path.read_bytes())
    # Do not resurrect retired artwork or overwrite later geometry decisions.
    manifest = json.loads(path.read_text(encoding='utf-8'))
    edits = {}
    for filename in ['PROMPTS-facing-a.json', 'PROMPTS-facing-b.json']:
        source = BASE / filename
        if not source.exists():
            continue
        record = json.loads(source.read_text(encoding='utf-8'))
        for entry in record.get('entries', record.get('records', [])):
            if entry.get('status') not in ('generated_reviewed', 'accepted_for_technical_export_pending_engine'):
                continue
            new_source = entry.get('new_source')
            digest = entry.get('new_source_sha256', entry.get('sha256'))
            if not new_source or not digest:
                continue
            image = (ROOT / new_source).resolve()
            if not image.is_relative_to((BASE / 'sources/facing').resolve()):
                raise ValueError('Unexpected facing source path')
            if hashlib.sha256(image.read_bytes()).hexdigest() != digest:
                raise ValueError('Facing source fingerprint differs: ' + new_source)
            if entry['brush'] in edits:
                raise ValueError('Duplicate facing source')
            edits[entry['brush']] = (entry, filename)
    selected = []
    for person in manifest['characters']:
        for form in person['forms']:
            if form.get('source_revision') == 'retired_alias':
                continue
            if form['brush'] not in edits:
                continue
            edit, filename = edits[form['brush']]
            form.setdefault('before_facing_source', form['source'])
            form.setdefault('before_facing_revision', form.get('source_revision'))
            form['source'] = edit['new_source']
            form['source_sha256'] = edit.get('new_source_sha256', edit.get('sha256'))
            form['source_box'] = None
            form['source_revision'] = 'v05_facing'
            form['pose_record'] = filename
            form['review_note'] = '保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。'
            selected.append(form['brush'])
    forms = [f for person in manifest['characters'] for f in person['forms']]
    by_brush = {f['brush']: f for f in forms}
    for form in forms:
        if form.get('source_revision') == 'retired_alias':
            target = by_brush[form['alias_of']]
            for field in ('source', 'source_sha256', 'source_box'):
                form[field] = target.get(field)
    active_count = sum(f.get('source_revision') != 'retired_alias' for f in forms)
    manifest['facing'] = {'source_direction': 'screen_right', 'runtime_flip': 'not allied with player',
                          'selected_forms': len(selected), 'complete': len(selected) == active_count}
    path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(f'Selected {len(selected)}/{active_count} active right-facing forms; retired aliases preserved')


if __name__ == '__main__':
    main()
