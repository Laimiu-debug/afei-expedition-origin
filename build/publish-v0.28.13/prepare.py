"""Prepare the reviewed turtle and helmet release from verified source bytes."""
from pathlib import Path
from zipfile import ZipFile
import hashlib
import json
import shutil

stage = Path(__file__).resolve().parent
root = stage.parents[1]
version = '0.28.13'
before = json.loads((stage/'website-before.json').read_text(encoding='utf-8'))
previous = json.loads((root/'build/publish-v0.28.12/website-release.json').read_text(encoding='utf-8'))
validation = json.loads((root/'build/gameplay-validation.json').read_text(encoding='utf-8'))
assert (root/'VERSION').read_text().strip() == version
assert all(validation[k] for k in ('syntax_passed','behavior_tests_passed','native_resource_paths_passed'))
assert validation['custom_art']['passed'] and validation['custom_art']['helmet_layers']['portraits'] == 33
sha = lambda data: hashlib.sha256(data).hexdigest()
for row in validation['scripts'] + validation['ui_scripts']:
    assert sha((root/row['path']).read_bytes()) == row['sha256'], row['path']
source = {p.relative_to(root/'src').as_posix():p.read_bytes() for p in (root/'src').rglob('*') if p.is_file()}
package = root/f'dist/mod_afeix_expedition v{version}.zip'
assert sha(package.read_bytes()) == 'c9227c64ef612af3cff3c085e8ffcd1215c1a60dd3ebb755544d589fe20e1b09'
with ZipFile(package) as archive:
    assert archive.testzip() is None
    assert len(archive.namelist()) == len(set(archive.namelist())) == len(source) == 290
    assert set(archive.namelist()) == set(source)
    assert all(archive.read(n) == data for n,data in source.items())
assert b'Version = 63' in source['scripts/!mods_preload/mod_afeix_expedition.nut']
assert before['id'] == previous['expected_mod_id']
assert before['releases'][0]['version'] == '0.28.12'
assert not any(r['version'] == version for r in before['releases'])
mod = {k:before['metadata'].get(k,v) for k,v in previous['mod'].items()}
for key in ('mod_ids','requires','conflicts'):
    if isinstance(mod[key],list):mod[key]='\n'.join(mod[key])
assertions = sum(r['assertions'] for r in validation['tests'])
assert assertions == 35249
count = f'{assertions:,}'
mod['summary'] = 'v0.28.13 小龟基础生命54→69，取消赠送钢头；缩头乌龟25%免疫头部伤害，其余转为身体结算。33名可戴盔角色保留原画并拆出头发，按原版头盔规则隐藏。完整主包，请新开战役验收。'
intro = '''v0.28.13：小龟1级基础生命由54提高到69，最终增加15点；该数值已包含固定肥胖特质。取消入队赠送钢头，新增常驻特性“缩头乌龟”：有效头部命中有25%概率免疫本次生命、护甲与受击疲劳伤害；其余75%转移为身体命中，按身甲、攻击的身体伤害倍率与身体伤势计算，避免割耳朵等头部伤势。保留禁戴头盔、近防与远防各+5及躯干直接武器伤害减少20%，转移后的武器伤害同样受厚壳保护；撤下此前头部50%减伤。身体命中、流血和中毒沿用既有规则。已有赠送钢头在首次同步时移除一次，之后玩家自行学习的钢头不会反复删除。

头盔遮挡：主包33名可戴盔角色保留原画像素，按脸、颈部与头发轮廓拆层，接入原版已有头发图层。开面盔隐藏头发，全罩盔隐藏头部与发型；不戴盔时合成与原画一致。原隐藏头盔按钮保留，隐藏时恢复完整发型。戴盔尸体和伤口同步使用去发版头部，未戴盔尸体保留发型；断头、复活与保存继续走原版流程。可选美术DLC的独立外观仍使用原有完整贴图，未纳入此次33人的轮廓拆层。

完整主包包含此前全部更新。125份Squirrel脚本、35,249条离线断言、原版资源路径与JavaScript检查通过，290个包文件及231个新增画刷像素/锚点校验通过。头盔、存读档与新特性仍待实机验收，请新开战役。开局首次移动停顿仍未定位，不将本版记为该问题已经修复。'''
description = before['metadata']['description']
assert description.startswith('v0.28.12：')
mod['description'] = intro + '\n\n' + description.replace('v0.28.12：','保留v0.28.12更新：',1)
mod['compatibility_notes'] += '\n\nv0.28.13：小龟基础生命69，取消赠送钢头；缩头乌龟25%免疫头部伤害，其余转为身体结算。主包33人的原画拆层接入原版头盔遮挡；可选美术DLC独立外观仍使用原有完整贴图。首次移动停顿仍待计时定位。请新开战役验收。'
notes = '小龟基础生命54→69（最终+15），取消赠送钢头，新增“缩头乌龟”：头部命中25%免伤，其余按身体、身甲与身体伤势结算。保留厚壳的双防+5和身体武器减伤20%。主包33名可戴盔角色保留原画，脚本按轮廓拆出头发，使用原版头盔遮挡规则，隐藏头盔时恢复完整发型。完整主包包含此前全部更新。' + count + '条离线断言、125份脚本、290个包文件校验通过，尚待实机验收。首次移动停顿仍未定位。请新开战役。'
with ZipFile(root/'dist/mod_afeix_expedition v0.28.12.zip') as old:
    added = sorted(set(source)-set(old.namelist()))
    changed = sorted(n for n in set(source)&set(old.namelist()) if old.read(n)!=source[n])
proof = {'version':version,'prior_version':'0.28.12','added_package_entries':added,'changed_package_entries':changed,
         'turtle_start_hp':69,'turtle_head_immunity_percent':25,'helmet_portraits':33,'helmet_brushes':231,
         'behavior_assertions':assertions,'in_game_tested':False}
(stage/'release-proof.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
spec = {'owner':before['owner'],'expected_mod_id':before['id'],'expected_metadata':before['metadata'],
        'mod':mod,'version':version,'notes':notes,'package_filename':package.name,'sha256':sha(package.read_bytes()),
        'verification':{'source_root':'src','prior_version':'0.28.12','internal_version':63,'entries':len(source),
                        'behavior_assertions':assertions,'source_sha256':{n:sha(data) for n,data in sorted(source.items())}}}
(stage/'website-release.json').write_text(json.dumps(spec,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
shutil.copy2(package,stage/package.name)
shutil.copy2(root/'tools/publish_bbmod_release.py',stage/'publish_bbmod_release.py')
publisher = (root/'build/publish-v0.28.12/publish.py').read_text(encoding='utf-8').replace('afeix-02812','afeix-02813').replace('0.28.12',version)
(stage/'publish.py').write_text(publisher,encoding='utf-8')
confirmation = (root/'build/publish-v0.28.12/confirm_metadata.py').read_text(encoding='utf-8').replace('0.28.12',version).replace('33,484',count)
confirmation = confirmation.replace("'删除旧存档说明'", "'删除旧存档说明', '缩头乌龟', '54提高到69', '25%', '原版头盔'")
(stage/'confirm_metadata.py').write_text(confirmation,encoding='utf-8')
verifier = (root/'build/publish-v0.28.12/verify_public_archive.py').read_text(encoding='utf-8').replace('afeix-02812','afeix-02813')
verifier = verifier.replace("    text = z.read('scripts/skills/traits/afeix_turtle_body.nut').decode('utf-8')\n    assert '旧档头盔' not in text and '头部减伤暂不生效' not in text", "    text = z.read('scripts/skills/traits/afeix_turtle_retract.nut').decode('utf-8')\n    assert 'trait.afeix_turtle_retract' in text and '25' in text\n    assert 'brushes/afeix_helmet_layers_v01.brush' in z.namelist()")
verifier = verifier.replace('tooltip_old_save_text_removed','turtle_and_helmet_resources_present')
(stage/'verify_public_archive.py').write_text(verifier,encoding='utf-8')
print(f'Prepared v{version}: {count} assertions; {len(source)} source-matching files; hash unchanged.')
