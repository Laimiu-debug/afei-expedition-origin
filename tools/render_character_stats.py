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
source = ROOT / 'src/scripts/mods/afeix/characters.nut'
lines = ['# 34 人基础属性表｜当前代码', '',
         '导出日期：2026-09-27，v0.13。此表从实际 Squirrel 入口执行导出，不从故事梗概推测。已按用户确认调整四位九星核心、五位盾卫与阿飞转职天赋；基础属性点保持 v0.12 配置。', '',
         '**口径：**创建角色时写入的 1 级基础属性。未计装备对可用疲劳／先攻的扣减、盾牌防御、原版背景及随机特性效果、个人成长、羁绊与阿飞转职加成。实机人物面板可能因此不同。', '',
         '**★ 表示该项升级天赋星数，不是已经增加的属性点。**无星表示 0 星；疲劳列表示基础疲劳上限（代码字段 Stamina）。', '',
         '|成员|生命|疲劳上限|决心|先攻|近战命中|远程命中|近战防御|远程防御|',
         '|---|---:|---:|---:|---:|---:|---:|---:|---:|']
for p in people:
    values = [str(v)+'★'*p['stars'].get(f,0) for f,v in zip(fields,p['attrs'])]
    lines.append('|'+p['name']+'|'+'|'.join(values)+'|')
names = dict(zip(fields, ['生命', '疲劳上限', '决心', '先攻', '近战命中', '远程命中', '近战防御', '远程防御']))
promotion = '、'.join(names[f]+'★'*data['promotionTalents'][f] for f in fields if f in data['promotionTalents'])
lines += ['', '## 九星与盾卫规则', '',
          '- 九星核心：小酒瓶、余初九、小鱼贝壳、瑶瑶牙。均为近攻／近防三星，第三项按各人特点分别为决心、先攻、生命、疲劳。',
          '- 盾卫：王大谋、老蔡、大鹅、可可、溺水小龟，均为近防三星、决心二星，另有生命或疲劳一星，共六星。可以自由更换武器，不锁定职业。',
          '- 阿飞起步仍为五颗星；蛤蟆人、嘉豪、飞碟三条路线共用九星配置：'+promotion+'。重修不会累加星数。',
          '- 本轮其余成员的星位、全员基础属性点、招募费与日薪不变。老蔡、可可、小龟的新招募默认装备改为矛盾配置，旧档已有装备不替换。',
          '- 旧档读档后同步受影响人物的星位，并更新受影响属性尚未使用的普通升级数值；已分配的属性点、经验、专长、伤势和装备保留。11 级后的老兵升级仍为固定 +1。', '',]
lines += ['', '## 当前定位与费用', '',
          '定位是现有设计备注，不是职业锁定。基础招募价不等于城镇界面的最终报价，后者会经过原版费用逻辑与折扣。日薪也可能受到特性和经济效果影响。', '',
          '|成员|定位|基础招募价|基础日薪|', '|---|---|---:|---:|']
for p in people:
    lines.append(f"|{p['name']}|{p['role']}|{'开局队长' if p['isCaptain'] else p['hireCost']}|{p['wage']}|")
lines += ['', '## 配置来源', '',
          '- [人物定义](../../src/scripts/mods/afeix/characters.nut)',
          '- [创建角色时的属性写入](../../src/scripts/mods/afeix/roster.nut)',
          '- [天赋同步与升级队列](../../src/scripts/mods/afeix/talents.nut)',
          '- [可重复导出脚本](../../tools/render_character_stats.py)',
          '- 定义 SHA256：`'+hashlib.sha256(source.read_bytes()).hexdigest()+'`', '',
          '这张表用于核对起点。阿飞两条常规转职和隐藏转职、个人成长选项需要另外按最终加成评估，不能只看起始八维判断后期强弱。', '']
target = ROOT / 'docs/design/character-stats.md'
target.write_text('\n'.join(lines), encoding='utf-8')
print('\n'.join(lines[:lines.index('## 当前定位与费用')]))
print('Saved '+str(target))
