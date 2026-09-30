"""Prepare the turtle tooltip release from fully validated source bytes."""
from pathlib import Path
from zipfile import ZipFile
import hashlib
import json
import shutil

stage = Path(__file__).resolve().parent
root = stage.parents[1]
version = '0.28.12'
before = json.loads((stage / 'website-before.json').read_text(encoding='utf-8'))
previous = json.loads((root / 'build/publish-v0.28.11/website-release.json').read_text(encoding='utf-8'))
validation = json.loads((root / 'build/gameplay-validation.json').read_text(encoding='utf-8'))
assert (root / 'VERSION').read_text().strip() == version
assert all(validation[k] for k in ('syntax_passed', 'behavior_tests_passed', 'native_resource_paths_passed'))
sha = lambda data: hashlib.sha256(data).hexdigest()
for row in validation['scripts'] + validation['ui_scripts']:
    assert sha((root / row['path']).read_bytes()) == row['sha256'], row['path']
source = {p.relative_to(root / 'src').as_posix(): p.read_bytes()
          for p in (root / 'src').rglob('*') if p.is_file()}
package = root / f'dist/mod_afeix_expedition v{version}.zip'
with ZipFile(package) as archive:
    assert archive.testzip() is None
    assert len(archive.namelist()) == len(set(archive.namelist())) == len(source) == 287
    assert set(archive.namelist()) == set(source)
    assert all(archive.read(n) == data for n, data in source.items())
with ZipFile(root / 'dist/mod_afeix_expedition v0.28.11.zip') as old:
    assert set(old.namelist()) == set(source)
    changed = sorted(n for n, data in source.items() if old.read(n) != data)
    assert changed == ['scripts/!mods_preload/mod_afeix_expedition.nut',
                       'scripts/skills/traits/afeix_turtle_body.nut'], changed
    trait = 'scripts/skills/traits/afeix_turtle_body.nut'
    removed = '\\n旧档头盔在行囊有空位时自动收回；仍戴着旧头盔时，头部减伤暂不生效。'
    assert source[trait].decode('utf-8').replace('\r\n', '\n') == old.read(trait).decode('utf-8').replace('\r\n', '\n').replace(removed, '')
assert before['id'] == previous['expected_mod_id']
assert before['releases'][0]['version'] == '0.28.11'
assert not any(r['version'] == version for r in before['releases'])
mod = {k: before['metadata'].get(k, v) for k, v in previous['mod'].items()}
for key in ('mod_ids', 'requires', 'conflicts'):
    if isinstance(mod[key], list):
        mod[key] = '\n'.join(mod[key])
assertions = sum(r['assertions'] for r in validation['tests'])
count = f'{assertions:,}'
mod['summary'] = 'v0.28.12 精简小龟体质提示，删除旧存档说明。保留头盔限制、天生钢头、厚壳防御和此前全部主包更新。请新开战役验收。'
intro = 'v0.28.12：精简小龟“头盔戴不下，龟壳扛得住”特质提示，删除旧存档说明，保留体质效果介绍和铁匠台词。实际装备限制、天生钢头与厚壳防御规则沿用此前设置。'
description = before['metadata']['description']
assert description.startswith('v0.28.11：')
mod['description'] = intro + '\n\n' + description.replace('v0.28.11：', '保留v0.28.11更新：', 1)
notes = '精简小龟“头盔戴不下，龟壳扛得住”特质提示，删除旧存档说明，保留体质效果介绍与铁匠台词。完整主包包含此前契约种类统计、觉醒文案、传奇蓝光握把和酒馆交互修复。' + count + '条离线断言、124份脚本和287个包文件校验通过。请按新建战役验收。'
proof = {'version': version, 'prior_version': '0.28.11', 'changed_package_entries': changed,
         'only_requested_tooltip_and_version_changed': True, 'tooltip_old_save_text_removed': True,
         'behavior_assertions': assertions, 'in_game_tested': False}
(stage / 'turtle-tooltip-proof.json').write_text(json.dumps(proof, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
spec = {'owner': before['owner'], 'expected_mod_id': before['id'], 'expected_metadata': before['metadata'],
        'mod': mod, 'version': version, 'notes': notes, 'package_filename': package.name,
        'sha256': sha(package.read_bytes()),
        'verification': {'source_root': 'src', 'prior_version': '0.28.11', 'internal_version': 62,
                         'entries': len(source), 'behavior_assertions': assertions,
                         'source_sha256': {n: sha(data) for n, data in sorted(source.items())}}}
(stage / 'website-release.json').write_text(json.dumps(spec, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
shutil.copy2(package, stage / package.name)
shutil.copy2(root / 'tools/publish_bbmod_release.py', stage / 'publish_bbmod_release.py')
publisher = (root / 'build/publish-v0.28.11/publish.py').read_text(encoding='utf-8').replace('afeix-02811', 'afeix-02812').replace('0.28.11', version)
(stage / 'publish.py').write_text(publisher, encoding='utf-8')
confirm = (root / 'build/publish-v0.28.11/confirm_metadata.py').read_text(encoding='utf-8').replace('0.28.11', version)
confirm = confirm.replace("'旧记录未保存种类'", "'旧记录未保存种类', '头盔戴不下，龟壳扛得住', '删除旧存档说明'")
confirm = confirm.replace('Version, metadata and download-link confirmation only, as requested by the user.', 'Public version, release notes and download-link confirmation; archive integrity is verified separately.')
(stage / 'confirm_metadata.py').write_text(confirm, encoding='utf-8')
print(f'Prepared v{version}: {count} assertions; only tooltip and version entry changed.')
