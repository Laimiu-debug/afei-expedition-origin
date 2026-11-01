"""Stage the final full-portrait rollback, preserving unrelated site metadata."""
from pathlib import Path
from zipfile import ZipFile
import hashlib
import json
import shutil

stage = Path(__file__).resolve().parent
root = stage.parents[1]
version = '0.28.14'
before = json.loads((stage/'website-before.json').read_text(encoding='utf-8'))
previous = json.loads((root/'build/publish-v0.28.13/website-release.json').read_text(encoding='utf-8'))
validation = json.loads((root/'build/gameplay-validation.json').read_text(encoding='utf-8'))
proof = json.loads((root/'build/helmet-fix-20261002/verification.json').read_text(encoding='utf-8'))
sha = lambda data: hashlib.sha256(data).hexdigest()
assert (root/'VERSION').read_text().strip() == version
assert all(validation[k] for k in ('syntax_passed', 'behavior_tests_passed', 'native_resource_paths_passed'))
assert validation['custom_art']['passed'] and validation['custom_art']['split_face_hair_atlas_absent']
for row in validation['scripts'] + validation['ui_scripts']:
    assert sha((root/row['path']).read_bytes()) == row['sha256'], row['path']
assertions = sum(row['assertions'] for row in validation['tests'])
assert assertions == proof['behavior_assertions'] == 33715
assert len(validation['scripts']) == proof['scripts_compiled'] == 125
source = {p.relative_to(root/'src').as_posix():p.read_bytes() for p in (root/'src').rglob('*') if p.is_file()}
package = root/f'dist/mod_afeix_expedition v{version}.zip'
assert sha(package.read_bytes()) == proof['sha256'] == '318d0b3100d5a10e73e57bd93eb2eb5e6866cda376e8815772856ff1a7824504'
assert package.stat().st_size == 4507594
with ZipFile(package) as archive:
    assert archive.testzip() is None
    assert len(archive.namelist()) == len(set(archive.namelist())) == len(source) == 288
    assert set(archive.namelist()) == set(source)
    assert all(archive.read(n) == data for n,data in source.items())
assert b'Version = 64' in source['scripts/!mods_preload/mod_afeix_expedition.nut']
assert b'hasSplitHairArt' not in source['scripts/mods/afeix/appearance.nut']
assert b'afeix_full_portrait_helmet_default' in source['scripts/mods/afeix/company_appearance_hooks.nut']
assert before['id'] == previous['expected_mod_id']
assert before['releases'][0]['version'] == '0.28.13'
assert before['releases'][0]['sha256'] == previous['sha256']
assert not any(r['version'] == version for r in before['releases'])
with ZipFile(root/'dist/mod_afeix_expedition v0.28.13.zip') as old:
    added = sorted(set(source)-set(old.namelist()))
    removed = sorted(set(old.namelist())-set(source))
    changed = sorted(n for n in set(source)&set(old.namelist()) if old.read(n) != source[n])
assert not added
assert removed == proof['removed_entries_from_0_28_13']
assert changed == proof['changed_entries_from_0_28_13']
mod = {k:before['metadata'].get(k,v) for k,v in previous['mod'].items()}
for key in ('mod_ids', 'requires', 'conflicts'):
    if isinstance(mod[key], list):
        mod[key] = '\n'.join(mod[key])
mod['summary'] = 'v0.28.14 撤回脸与头发拆层，恢复完整头像，默认隐藏全队头盔。旧档首次升级同步隐藏，之后手动选择随存档保留；头盔防护与装备效果正常生效。本次外观回退无需重开战役。'
intro = '''v0.28.14：人物原画的头像尺寸、朝向与原版头盔并非严格一致，本版撤回v0.28.13的脸与头发拆层，恢复完整脸与发型贴图，移除拆发图集。新战役默认隐藏全队头盔；旧档首次升级同步时也会开启隐藏，之后在F8 → 战团事务手动选择显示或隐藏，其选择随存档保留，不会被后续刷新或加载覆盖。隐藏仅影响外观，头盔仍然装备，防护、疲劳与技能效果正常生效。用户手动显示时，原画与原版头盔的贴合仍可能存在偏差。

本次头像与头盔显示回退无需重开战役。完全退出游戏后替换旧主包，不要解压，data中只保留一个主包ZIP。完整包包含此前全部更新。125份Squirrel脚本、33,715条离线断言、原版资源路径与JavaScript检查通过；288个包文件的CRC、完整文件集合和源码字节一致性校验通过。当前语音/皮肤整合包两种加载顺序各通过5,108条组合断言。人物显示与存读档仍待实机验收；开局首次移动停顿仍未定位。'''
description = before['metadata']['description']
assert description.startswith('v0.28.13：')
paragraphs = description.split('\n\n')
assert paragraphs[1].startswith('头盔遮挡：')
assert paragraphs[2].startswith('完整主包包含此前全部更新。')
turtle = paragraphs[0].replace('v0.28.13：', '保留v0.28.13的小龟更新：', 1)
tail = '\n\n'.join(paragraphs[3:])
old_final = tail[tail.rfind('本页面提供主包；'):]
assert old_final.startswith('本页面提供主包；')
tail = tail[:-len(old_final)] + '本页面提供主包；希文与里根儿为独立可选DLC，需另行下载。公开开发试玩版，此前起源与玩法更新仍按新建战役验收；本次v0.28.14外观回退可以沿用旧档。新增玩法与美术尚未完成实机战役验收；此前v0.27.6网后断头修复有独立战场实测记录，食尸鬼战斗闪退仍未确认修复。'
mod['description'] = intro + '\n\n' + turtle + '\n\n' + tail
compat = before['metadata']['compatibility_notes']
assert '\n\nv0.28.13：' in compat
compat = compat.split('\n\nv0.28.13：',1)[0]
compat = compat.replace('请新开战役，不承诺旧存档迁移。', '此前涉及起源与玩法的大版本更新仍按新建战役验收。', 1)
mod['compatibility_notes'] = 'v0.28.14：恢复完整头像，默认隐藏全队头盔。旧档首次升级自动开启隐藏；此后用户的显示/隐藏选择随存档保留。隐藏只影响外观，装备效果正常。本次外观回退无需重开战役。显示头盔时，原画与原版头盔贴合仍可能存在偏差。\n\n' + compat
notes = '撤回脸与头发拆层，恢复完整头像，移除拆发图集。默认隐藏全队头盔，旧档首次升级同步隐藏；之后用户手动显示/隐藏的选择随存档保留。隐藏仅影响外观，头盔防护、疲劳和技能效果正常生效。本次外观回退无需重开战役。完整主包包含此前小龟等全部更新。33,715条离线断言、125份脚本、288个包文件校验通过，语音/皮肤整合包两种加载顺序各通过5,108条组合断言；尚待实机验收，首次移动停顿仍未定位。'
proof.update(prior_version='0.28.13', added_package_entries=added, removed_package_entries=removed,
             changed_package_entries=changed, published=False, public_download_byte_comparison=False)
(stage/'release-proof.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
spec = {'owner':before['owner'], 'expected_mod_id':before['id'], 'expected_metadata':before['metadata'],
        'mod':mod, 'version':version, 'notes':notes, 'package_filename':package.name, 'sha256':sha(package.read_bytes()),
        'verification':{'source_root':'src', 'prior_version':'0.28.13', 'internal_version':64, 'entries':len(source),
                        'behavior_assertions':assertions, 'source_sha256':{n:sha(data) for n,data in sorted(source.items())}}}
(stage/'website-release.json').write_text(json.dumps(spec,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
shutil.copy2(package,stage/package.name)
shutil.copy2(root/'tools/publish_bbmod_release.py',stage/'publish_bbmod_release.py')
publisher = (root/'build/publish-v0.28.13/publish.py').read_text(encoding='utf-8').replace('afeix-02813','afeix-02814').replace('0.28.13',version)
(stage/'publish.py').write_text(publisher,encoding='utf-8')
confirmation = (root/'build/publish-v0.28.13/confirm_metadata.py').read_text(encoding='utf-8').replace('0.28.13',version)
old_words = next(line for line in confirmation.splitlines() if line.startswith('assert all(word in html'))
confirmation = confirmation.replace(old_words, "assert all(word in html for word in ('0.28.14', '33,715', '完整头像', '默认隐藏全队头盔', '无需重开战役', '缩头乌龟', 'F8', 'Esc'))")
(stage/'confirm_metadata.py').write_text(confirmation,encoding='utf-8')
print(f'Prepared v{version}: {assertions:,} assertions; {len(source)} source-matching files; final rollback hash confirmed.')
