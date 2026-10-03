"""Export the current executable character definitions as an author-facing table."""
import hashlib
import json
from pathlib import Path
import subprocess
import sys

sys.stdout.reconfigure(encoding='utf-8')

ROOT = Path(__file__).resolve().parents[1]
sq = ROOT / '.cache/afei-art/bbros-modkit-v9/bin/sq.exe'
result = subprocess.run([str(sq), 'tools/export_gameplay_roster.nut'], cwd=ROOT,
                        capture_output=True, text=True, encoding='utf-8', check=True)
data = json.loads(result.stdout.split('ROSTER_JSON_BEGIN\n',1)[1].split('\nROSTER_JSON_END',1)[0])
people = data['characters']
if len(people) != 34 or len({p['key'] for p in people}) != 34 or any(len(p['attrs']) != 8 for p in people):
    raise ValueError('The current roster must contain 34 distinct eight-attribute records')
fields = ['Hitpoints','Stamina','Bravery','Initiative','MeleeSkill','RangedSkill','MeleeDefense','RangedDefense']
source = ROOT / 'src/scripts/mods/afeix/balance_v26_data.nut'
lines = ['# 34 人基础属性表｜当前代码', '',
         f"当前版本：v{(ROOT / 'VERSION').read_text().strip()}。此表从实际 Squirrel 预加载入口执行导出，依据[全人物数值与招募总表](balance-v2/全人物数值与招募总表.xlsx)及[终局岗位修订](endgame-balance-20260930.md)。希文在可选 DLC 中另行注册。", '',
         '**口径：**1级表列属性已包含固定原版特质的八维增减，实际创建时反推基础，避免重复加算。不含装备负重、盾牌、个人成长、阿飞转职、临时效果和原版专长。更新以新建战役验收。', '',
         '**★ 表示该项升级天赋星数，不是已经增加的属性点。**无星表示 0 星；疲劳列表示基础疲劳上限（代码字段 Stamina）。', '',
         '|成员|生命|疲劳上限|决心|先攻|近战命中|远程命中|近战防御|远程防御|',
         '|---|---:|---:|---:|---:|---:|---:|---:|---:|']
for p in people:
    values = [str(v)+'★'*p['stars'].get(f,0) for f,v in zip(fields,p['attrs'])]
    lines.append('|'+p['name']+'|'+'|'.join(values)+'|')
names = dict(zip(fields, ['生命', '疲劳上限', '决心', '先攻', '近战命中', '远程命中', '近战防御', '远程防御']))
promotion = '、'.join(names[f]+'★'*data['promotionTalents'][f] for f in fields if f in data['promotionTalents'])
lines += ['', '## 天赋与成长', '',
          '- 全员星位按总表设置；7级专属技能三选一、11级精通，与原版技能点独立。',
          '- 阿飞近攻、近防、决心各二星。转职不改变星数或重掷升级队列；取消额外逐级耐力；基础疲劳106，按表选6次普通疲劳升级，11级均值124（装备负重另扣）。',
          '- 小酒瓶无专属等级加成：基础疲劳109，近攻/近防/疲劳各三星，疲劳4次，11级均值127。生命5次、疲劳4次、决心1次、近攻近防各10次，总计30项；装备负重另扣。',
          '- 新人物固定两项原版特质；剧情成长仍为3级且本人实际参战3次后二选一。',
          '- 每次版本更新按新建战役验收，游戏内升级属性由玩家分配；表中30项只是培养方案。',
          '- 天赋修订号4：苏袜总5星重排，只重算改变星位的未使用普通升级队列；已分配属性和老兵+1保留，重复加载不会重掷。',
          '- 终局属性修订号1：旧档仅按基础八维差额同步一次，保留已赚属性、技能选择和当前生命。新培养分配不自动重置旧档已花点数。', '',]
lines += ['', '## 当前定位与费用', '',
          '定位是现有设计备注，不是职业锁定。基础招募价不等于城镇界面的最终报价，后者会经过原版费用逻辑与折扣。日薪也可能受到特性和经济效果影响。', '',
          '|成员|定位|基础招募价|基础日薪|', '|---|---|---:|---:|']
for p in people:
    lines.append(f"|{p['name']}|{p['role']}|{'开局队长' if p['isCaptain'] else p['hireCost']}|{p['wage']}|")
lines += ['', '## 配置来源', '',
          '- [人物定义](../../src/scripts/mods/afeix/balance_v26_data.nut)',
          '- [创建角色时的属性写入](../../src/scripts/mods/afeix/roster.nut)',
          '- [天赋同步与升级队列](../../src/scripts/mods/afeix/talents.nut)',
          '- [可重复导出脚本](../../tools/render_character_stats.py)',
          '- 定义 SHA256：`'+hashlib.sha256(source.read_bytes()).hexdigest()+'`', '',
          '这张表用于核对起点。阿飞两条常规转职和隐藏转职、个人成长选项需要另外按最终加成评估，不能只看起始八维判断后期强弱。', '']
target = ROOT / 'docs/design/character-stats.md'
target.write_text('\n'.join(lines), encoding='utf-8')
print('\n'.join(lines[:lines.index('## 当前定位与费用')]))
print('Saved '+str(target))
