"""Read-only legacy inventory; publish an author-facing skill/icon reuse review."""
from pathlib import Path
from collections import Counter
import hashlib
import html
import json
import os
import re
import subprocess
import sys
from PIL import Image

sys.stdout.reconfigure(encoding='utf-8')
ROOT = Path(__file__).resolve().parents[1]
LEGACY = ROOT / 'legacy/2026-09-25-afei-expedition/reference'
OUT = ROOT / 'build/legacy-skills-review'
DOC = ROOT / 'docs/design/legacy-skills-reuse.md'
OUT.mkdir(parents=True, exist_ok=True)

def read(path):
    return json.loads(path.read_text(encoding='utf-8'))

def link(path, base):
    return Path(os.path.relpath(path, base)).as_posix()

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

old = read(LEGACY / 'data/document-v0.6.2.json')
current = read(ROOT / 'build/characters.json')['characters']
review = read(ROOT / 'data/legacy-skill-review.json')
decisions = {p['key']: p for p in review['characters']}
if set(decisions) != {p['key'] for p in current}:
    raise ValueError('Review must cover the current 34-member roster exactly')

# Evaluate definitions only. No archived hooks, install scripts or gameplay run.
cache = ROOT / '.cache/legacy-skill-audit'
cache.mkdir(parents=True, exist_ok=True)
runner = cache / 'export.nut'
runner.write_text('''::AfeiExpedition <- {};
dofile("legacy/2026-09-25-afei-expedition/reference/src/scripts/mods/afei/definitions.nut");
function q(s) {
 local out="\\\"";
 for(local i=0;i<s.len();i++) {
  local c=s.slice(i,i+1);
  if(c=="\\\"")out+="\\\\\\\"";else if(c=="\\\\")out+="\\\\\\\\";
  else if(c=="\\n")out+="\\\\n";else if(c=="\\r")out+="\\\\r";else if(c=="\\t")out+="\\\\t";else out+=c;
 }
 return out+"\\\"";
}
function j(v) {
 local t=typeof v;if(t=="null")return "null";if(t=="string")return q(v);
 if(t=="bool")return v?"true":"false";if(t=="integer"||t=="float")return v.tostring();
 local out=t=="array"?"[":"{",first=true;
 foreach(k,x in v){if(!first)out+=",";first=false;if(t=="table")out+=q(k)+":";out+=j(x);}
 return out+(t=="array"?"]":"}");
}
print("LEGACY_BEGIN\\n"+j(::AfeiExpedition.SkillDefs)+"\\nLEGACY_END\\n");
''', encoding='utf-8')
result = subprocess.run([str(ROOT / '.cache/afei-art/bbros-modkit-v9/bin/sq.exe'), str(runner)],
                        cwd=ROOT, capture_output=True, encoding='utf-8', check=True)
runtime = json.loads(result.stdout.split('LEGACY_BEGIN\n')[1].split('\nLEGACY_END')[0])
skills = [dict(s, owner=key, owner_name=c['name']) for key,c in old.items() for s in c['skills']]
if len(skills)!=97 or len(runtime)!=97 or {s['id'] for s in skills}!=set(runtime):
    raise ValueError('Legacy document/runtime skill IDs differ')
sources = [(p, p.read_text(encoding='utf-8').splitlines()) for p in (LEGACY/'src/scripts/mods/afei').glob('*.nut') if p.name!='definitions.nut']
for s in skills:
    if s['name'] != runtime[s['id']]['name'] or s['owner'] != runtime[s['id']]['owner']:
        raise ValueError('Legacy owner/name mismatch: '+s['id'])
    s['runtime'] = {f:runtime[s['id']][f] for f in ['active','world','order','weapon','ap','fatigue','target','range','cooldown','limit']}
    p = LEGACY / ('src/gfx/skills/afei_'+s['id']+'.png')
    s['icon'] = None
    if p.is_file():
        with Image.open(p) as im:
            im.load()
            if im.size != (56,56) or im.mode != 'RGBA':
                raise ValueError('Unexpected legacy icon specification: '+str(p))
        s['icon'] = {'path':p.relative_to(ROOT).as_posix(), 'sha256':sha(p), 'size':[56,56], 'mode':'RGBA'}
    s['code_references'] = [{'path':p.relative_to(ROOT).as_posix(),'line':i+1} for p,lines in sources for i,line in enumerate(lines) if '"'+s['id']+'"' in line]
by_id = {s['id']:s for s in skills}
matched = {r['legacy_id'] for r in decisions.values() if r['legacy_id'] is not None}
for p in current:
    d=decisions[p['key']]
    ids=[s['id'] for s in old[d['legacy_id']]['skills']] if d['legacy_id'] else d.get('candidate_skill_ids',[])
    d['name']=p['name']; d['skill_ids']=ids
    d['existing_icon_count']=sum(by_id[i]['icon'] is not None for i in ids)
extras=[]
for name in ['afei_ecig_puff.png','afei_ecig_puff_sw.png']:
    p=LEGACY/'src/gfx/skills'/name
    extras.append({'path':p.relative_to(ROOT).as_posix(),'sha256':sha(p)})
stats={'old_members':len(old),'skills':len(skills),'skill_icons':sum(s['icon'] is not None for s in skills),
       'extra_ecig_icons':len(extras),'current_members':len(current),'directly_mapped_members':len(matched),
       'directly_mapped_skills':sum(len(old[k]['skills']) for k in matched),
       'directly_mapped_icons':sum(s['icon'] is not None for s in skills if s['owner'] in matched),
       'missing_icons':[s['id'] for s in skills if s['icon'] is None]}
inventory={'date':review['date'],'baseline':review['baseline'],'status':'review_only_not_implemented',
           'stats':stats,'characters':[decisions[p['key']] for p in current], 'skills':skills,'extra_icons':extras,
           'source_hashes':{str(p.relative_to(ROOT).as_posix()):sha(p) for p in [LEGACY/'data/document-v0.6.2.json',LEGACY/'src/scripts/mods/afei/definitions.nut',ROOT/'data/legacy-skill-review.json']}}
(OUT/'inventory.json').write_text(json.dumps(inventory,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')

lines=['# 旧技能与图标沿用审阅｜v0.13 历史评估', '',
       '> 后续进度：v0.15 已覆盖 33 名伙伴、99 项成员技能，阿飞沿用独立转职。现行效果与移植调整见[已接入技能表](member-skills.md)；以下保留迁移前的评估、旧数值和当时待办，不作为当前生效清单。', '',
       '日期：2026-09-27。依据已保存的旧工程快照、当前 34 人配置，以及本轮确认的九星核心／盾卫定位。本文是作者审阅与移植建议，不向游戏中的玩家公开未知人物或支线。', '',
       '**结论：大部分图标可以原样保留，许多技能主题也值得沿用；现有代码需要逐项接入当前系统。此次没有改动游戏技能、安装包或存档，也没有生图。**', '',
       f'旧数据和可执行定义一致：{stats["old_members"]} 人、{stats["skills"]} 项技能。目录有 {stats["skill_icons"]} 张专属图标，另有两张电子烟可用／禁用图，均为 56×56 RGBA。', '',
       f'其中 {stats["directly_mapped_members"]} 位能直接对应当前人物，共 {stats["directly_mapped_skills"]} 项旧设计、{stats["directly_mapped_icons"]} 张现成图标。另有一凹瑶、罗一可的六项技能及图标继续存档，不将她们当成现有成员。', '',
       '[按人物搜索和看图](../../build/legacy-skills-review/index.html) · [97 项机器可读清单与指纹](../../build/legacy-skills-review/inventory.json) · [逐人决策数据](../../data/legacy-skill-review.json)', '',
       '## 图标能否直接用', '',
       '- 已逐文件读取：所有 93 张 PNG 都符合现用技能栏的 56×56 RGBA 规格，技能路径应使用 `skills/…png`。旧图的暗红底、旧金符号、粗边框风格统一；按原尺寸总览检查后，大多数符号仍可辨认。这里只确认像素文件可复用，不代表每张图的语义和实机显示已经验收。',
       '- 旧图无需为迁移而重画；沿用前核对名称与效果。例如旧全力圈是发光圆环，表达号令，不能拿它证明现版“圈钱”已对应。',
       '- 审阅时电子烟两张技能状态图已在 v0.11 沿用。现版阿飞仍使用独立转职图标；v0.15 成员技能另已接入，当前规则以新版成员技能表为准。',
       '- 小胖的站得住／借你半面盾／挨过这一口，蔓越莓的看清缝隙／红线记号／留一支给后面，这六项没有旧自定义图标。',
       '- 老蔡、小哈尼、宋暖阳、溺水小龟在旧最终名册中没有自己的技能组。老蔡的旧技能已转给小宁，需要重新决定归属；其余三人不能宣称已有本人专属技能。',
       '- 91 张普通专属图未各配一张禁用版；旧通用技能脚本直接把原色图用于禁用状态。若接入后不易辨认，另处理禁用显示，不必重画整套。', '',
       '## 当前 34 人逐人建议', '',
       '|成员|旧技能或候选|结论|当前适配意见|', '|---|---|---|---|']
for p in current:
    d=decisions[p['key']]
    lines.append('|'+ '|'.join([p['name'],d['focus'],d['verdict'],d['note']])+'|')
lines += ['', '## 需要先解决的代码和玩法冲突', '',
          '1. **阿飞定义已变化。**旧哇哇叫是群体决心号令，现版是蛤蟆人的自身强化；旧嘉豪是累计伙伴成长的永久加点，现版嘉豪是带队路线；旧全力圈回疲劳，现版全力圈是战斗契约收入。名称、图标和有效机制分开选，不能覆盖新设定。',
          '2. **九星后重评叠加。**旧技能常见命中 +10、近防 +6、伤害 +10% 与疲劳优惠，旧阿飞嘉豪奖励最多可累计决心 +64／疲劳 +32。保留条件、代价与次数限制，但不能将所有旧数值直接叠在新天赋上。',
          '3. **旧共享号令在现版没有。**旧代码每战 2 次、觉醒后 3 次，且每轮最多 1 次；新阿飞技能按自身每战次数和克朗收费。必须先决定统一共享额度还是各技能独立冷却，不能只复制写着“耗一次号令”的技能说明。',
          '4. **旧存档和身份键不同。**旧 `AfeiExpedition`、`afei_named_id`、`Cxx`、`scenario.afei_expedition` 应接到现版 `AfeixExpedition`、`afeix_character`、稳定英文键和新起源。不要带回旧 12 人出战、20／39 名册、驻营、章节与磨合门槛。',
          '5. **攻击与位移不能整块覆盖。**旧 `attack_adapter.nut` 重写原生 `skills/skill.attackEntity`，拦截、误伤、武器技依赖这条链。建议优先按原版回调和当前边界接入，重点检验命中、盾牌、伤害、武器射程、网缚、地形、受控状态、失败不扣费以及读档。',
          '6. **武器定位有具体不匹配。**瑶瑶牙当前伐木斧不是双手长柄，旧破口一击会无法使用；可可当前为矛盾，旧远程误伤减伤与远程追击几乎无用；小宁弩手与旧近战“一张好牌”也不对应。',
          '7. **发现式流程继续保留。**人物技能可随招募与成长展示，未知成员、六根和转职不在 F8 预告。所有职业／技能清单仅供作者本地审阅。', '',
          '## 当时建议的接入顺序（当前进度见页首）', '',
          '- 第一批：小酒瓶的突破／接球、余初九的狗叫／忠诚、小鱼的站位被动／尼古丁、瑶瑶牙的吕布／破口；配合新九星配置形成不同近战玩法。武器技仍需走真实原生攻击并验证费用。',
          '- 第二批：大鹅守窝、改造后的可可保可梦、老蔡布阵或稳一手、大谋的持盾协作，以及小龟的新盾卫机制。先让五名盾卫各有用途。老蔡回收小宁技能属于待讨论归属。',
          '- 第三批：其他成员的经济、观察、步法和配合循环。小鱼拦截、强制换位、无法选中、陷阱、检定重掷等影响底层结算的机制独立验证后加入。',
          '- 每人先选一个代表主动和一个特色被动，再把第三项放入成长阶段；这是节奏建议，尚未改现有成长选择。', '',
          '## 全部 97 项旧设计与原图', '',
          '以下数值原样摘录旧项目，用于比对，**不是当前已生效效果**。代码引用仅证明有文本／处理入口，不证明行为正确或实机通过。', '']
for c in old.values():
    lines += ['### '+c['id']+'｜'+c['name'], '']
    for original in c['skills']:
        s=by_id[original['id']]; lines += ['**'+s['name']+'**（`'+s['id']+'`，'+s['kind']+'）', '', s['text'], '']
        if s['icon']:
            lines += ['!['+s['name']+']('+link(ROOT/s['icon']['path'],DOC.parent)+')', '']
        else: lines += ['旧自定义图标缺失。', '']
lines += ['## 来源与本轮检查范围', '',
          '- [旧设计数据](../../legacy/2026-09-25-afei-expedition/reference/data/document-v0.6.2.json)',
          '- [旧实际技能定义](../../legacy/2026-09-25-afei-expedition/reference/src/scripts/mods/afei/definitions.nut)',
          '- [旧技能通用入口](../../legacy/2026-09-25-afei-expedition/reference/src/scripts/skills/afei_skill.nut)',
          '- [旧技能支付和目标检查](../../legacy/2026-09-25-afei-expedition/reference/src/scripts/mods/afei/actions.nut)',
          '- [旧战斗被动与号令](../../legacy/2026-09-25-afei-expedition/reference/src/scripts/mods/afei/combat.nut)',
          '- [旧原生攻击覆盖](../../legacy/2026-09-25-afei-expedition/reference/src/scripts/mods/afei/attack_adapter.nut)',
          '- [现版个人成长](../../data/member-growth.json)、[转职](../../src/scripts/mods/afeix/promotions.nut)、[九星属性表](character-stats.md)', '',
          '执行旧数据定义导出并核对 97 项 ID／姓名／归属；读取 PNG 的尺寸、模式和 SHA256；阅读代表技能的支付、目标、战斗和攻击适配代码。没有执行旧安装脚本，没有对 97 项技能逐一做行为测试，也没有启动游戏。', '']
DOC.write_text('\n'.join(lines),encoding='utf-8')

esc=html.escape
cards=[]
owners={k:[d['name'] for d in decisions.values() if d['legacy_id']==k] for k in old}
for s in skills:
    people='、'.join(owners[s['owner']]) or '旧角色归档'
    decisions_for=[d for d in decisions.values() if s['id'] in d['skill_ids']]
    note=' '.join(d['name']+'：'+d['note'] for d in decisions_for) or '不对应当前成员，保留为机制和图标素材，不自动接入。'
    src=link(ROOT/s['icon']['path'],OUT) if s['icon'] else None
    art=f'<img loading="lazy" src="{esc(src)}" alt="{esc(s["name"])}">' if src else '<span class="missing">缺图</span>'
    search=' '.join([people,s['owner_name'],s['name'],s['id'],s['kind'],note])
    cards.append(f'<article data-search="{esc(search)}" data-missing="{str(src is None).lower()}"><header>{art}<div><span>{esc(people)}</span><h2>{esc(s["name"])}</h2><small>{esc(s["id"])}</small></div></header><p class="kind">{esc(s["kind"])} · 旧归属 {s["owner"]} {esc(s["owner_name"])}</p><p>{esc(note)}</p><details><summary>旧效果与费用（历史设计）</summary><p>{esc(s["text"])}</p></details></article>')
page='''<!doctype html><html lang="zh-CN"><meta charset="utf-8"><title>旧技能与图标审阅</title>
<style>:root{color-scheme:dark}body{background:#201c18;color:#efe4cf;font:16px/1.65 system-ui;margin:0;padding:28px;max-width:1550px;margin:auto}h1{font-size:28px;margin:0}p{max-width:1050px}.controls{position:sticky;top:0;background:#201c18ee;padding:12px 0;display:flex;gap:14px;align-items:center;flex-wrap:wrap;z-index:2}input[type=search]{padding:10px;width:min(500px,85vw);border:1px solid #9d7e4a;background:#31271f;color:white;font:inherit}.grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(335px,1fr));gap:16px}article{border:1px solid #68543c;padding:18px;background:#2e251f}header{display:flex;gap:16px;align-items:center}header img{width:56px;height:56px;image-rendering:auto;flex-shrink:0}body.zoom header img{width:112px;height:112px;image-rendering:pixelated}h2{font-size:21px;margin:0;color:#e5bd73}small,.kind{color:#bfae91}article p{font-size:14px}summary{cursor:pointer;color:#e5bd73}.missing{display:grid;place-items:center;border:1px dashed #b88b61;width:56px;height:56px}a{color:#e5bd73}[hidden]{display:none!important}</style>
<h1>旧技能与图标 · 沿用审阅</h1><p>97 项旧技能，91 张专属图标。另有两张电子烟状态图已沿用。本页是作者审阅，不是当前游戏技能列表。默认按 56×56 原尺寸显示；名称、机制和图标分别评估。本轮没有生图或修改游戏包。</p>
<p><a href="../../docs/design/legacy-skills-reuse.md">完整审阅与 34 人建议</a> · <a href="inventory.json">原图指纹和代码引用</a></p>
<div class="controls"><input type="search" id="query" aria-label="按人物或技能搜索" placeholder="搜索：小酒瓶、盾、瑶瑶牙、保可梦…"><label><input id="missing" type="checkbox">只看缺图</label><label><input id="zoom" type="checkbox">放大 2 倍</label><span id="count"></span></div><main class="grid">'''+''.join(cards)+'''</main><script>
const cards=[...document.querySelectorAll('article')], q=document.querySelector('#query'), missing=document.querySelector('#missing');
function filter(){let n=0;for(const card of cards){card.hidden=!(card.dataset.search.toLowerCase().includes(q.value.trim().toLowerCase())&&(!missing.checked||card.dataset.missing==='true'));if(!card.hidden)n++;}document.querySelector('#count').textContent=n+' / '+cards.length+' 项';}
q.addEventListener('input',filter);missing.addEventListener('change',filter);document.querySelector('#zoom').addEventListener('change',e=>document.body.classList.toggle('zoom',e.target.checked));filter();
</script></html>'''
(OUT/'index.html').write_text(page,encoding='utf-8')
print(json.dumps(stats,ensure_ascii=False))
print(DOC)
print(OUT/'index.html')
