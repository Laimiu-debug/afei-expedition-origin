"""Author-facing skill table and icon gallery from the real preload export."""
from pathlib import Path
import html
import json

ROOT = Path(__file__).resolve().parents[1]


def cost(d):
    if not d['active']:
        return '被动，按条件生效'
    timing = f"冷却 {d['cd']} 轮" if d['cd'] else '每战一次'
    if d.get('limit'):
        timing += f"，每战至多 {d['limit']} 次"
    return f"{d['ap']} AP／{d['fatigue']} 疲劳／{timing}"


def upgrade(key, d):
    if key == 'nicotine': return '11 级：立即恢复疲劳由 15 增至 18。'
    if not d['active']: return '11 级：自身每回合疲劳恢复额外 +1。'
    fatigue = max(0, d['fatigue'] - max(1, int(d['fatigue'] * .15)))
    return f"11 级：基础疲劳消耗由 {d['fatigue']} 降至 {fatigue}，行动点、冷却与次数不变。"


def render():
    data = json.loads((ROOT / 'build/characters.json').read_text(encoding='utf-8'))
    expansion = json.loads((ROOT / 'data/member-skill-expansion.json').read_text(encoding='utf-8'))
    groups, defs = data['memberSkills'], data['memberSkillDefs']
    assert len(groups) == 33 and len(defs) == 99
    current = {p['key'] for p in data['characters']}
    groups = {key: value for key, value in groups.items() if key in current}
    assert len(groups) == 33 and sum(map(len, groups.values())) == 99
    lines = ['# 已接入成员技能｜v0.26', '',
             '33 名现行伙伴各三项，共 99 项成员技能；阿飞沿用独立转职技能，眼子已接入三项专属技能。表内每人达到 7 级从三项中选择一项，达到 11 级自动精通这一项。F8 → 研习专属技能；不消耗原版技能点，选定后不能改选。当前数值由游戏预加载入口导出。', '',
             '本表只供作者审阅，不会把未知成员、转职、六根或自行车条件放进游戏黑旗名册。', '',
             '|成员|候选一|候选二|候选三|', '|---|---|---|---|']
    cards = []
    for person in data['characters']:
        if person['key'] not in groups:
            continue
        keys = groups[person['key']]
        lines.append('|' + '|'.join([person['name']] + [defs[k]['name'] for k in keys]) + '|')
        for key in keys:
            d = defs[key]
            stage = '7 级三选一，11 级精通'
            label = person['name'] + ' · ' + stage
            cards.append(f'<article><img src="../../src/gfx/skills/afeix_member_{key}.png" alt=""><small>{html.escape(label)}</small><h2>{html.escape(d["name"])}</h2><p class="cost">{html.escape(cost(d))}</p><p>{html.escape(d["text"])}</p><p>{html.escape(upgrade(key,d))}</p></article>')
    lines += ['', '## 具体效果', '']
    for person in data['characters']:
        if person['key'] not in groups:
            continue
        lines += [f"### {person['name']}", '']
        for key in groups[person['key']]:
            d = defs[key]
            stage = '7 级三选一，11 级精通'
            lines += [f"**{d['name']}**（{stage}；{cost(d)}）：{d['text']} {upgrade(key,d)}", '']
    lines += ['## 与旧稿的差异', '']
    lines += ['- ' + text for text in expansion['adaptations']]
    lines += ['', '## 通用规则与存档', '',
              '- 临时护卫的近防、远防、决心分别取最高值；人物条件被动、盾牌和原版专长另行计算。下一次武器技能疲劳减免取最高一份，最低消耗 0。新增额外回疲劳每人每轮合计最多 20。',
              '- 标记及下一次攻击加成在真实出手命中或落空后消耗。鼠标预览不消耗。范围攻击不使用这些单体加成；投掷武器正常扣弹药。',
              '- 原版普通步行与专属位移分开计数。换位和一步移动不能绕过定身、眩晕和地形高度限制。护卫被移动、失盾或失去行动能力后失效的效果不会因重新满足条件自动恢复。',
              '- 新招募、旧档已入队成员及城镇待雇佣候选共用补技能入口。重复载入不重复加技能；旧档未选择的旧技能撤下，达到 7 级后重新三选一。个人成长继续保留故事与属性奖励，不再额外送技能。不重置等级、经验、已分配属性、装备或剧情进度；天赋按现行人物平衡方案另行同步。',
              '- 冷却、每战次数、战斗计数及临时效果均可序列化；战斗结束清理临时状态。世界地图折扣以世界旗标记录，只有成功付款／招募才消耗次数。',
              '- 旧 34 人审阅档仍可使用；1 级成员暂无专属技能，达到 7 级后选择。11 级才选择的成员直接精通。', '',
              '99 个现行技能均已绑定主图与状态小图；96 张保留已审阅图案，眼子3张采用V2设计图。来源逐项标注于[图标清单](../../art/runtime/member-skills-v15/report.json)。[按人物查看图册](../../build/member-skills/index.html)。', '',
              '离线测试不等于实机验收；验证范围与安装信息见[v0.17 说明](../playtest-0.17.md)。', '']
    (ROOT / 'docs/design/member-skills.md').write_text('\n'.join(lines), encoding='utf-8')
    output = ROOT / 'build/member-skills'
    output.mkdir(parents=True, exist_ok=True)
    page = '''<!doctype html><html lang="zh-CN"><meta charset="utf-8"><title>已接入成员技能 v0.17</title>
<style>body{max-width:1240px;margin:auto;padding:28px;background:#201c18;color:#ede1cb;font:16px/1.6 system-ui}h1{font-size:28px}main{display:grid;grid-template-columns:repeat(auto-fit,minmax(300px,1fr));gap:16px}article{padding:18px;background:#30271e;border:1px solid #776044}img{width:56px;height:56px;float:left;margin:0 16px 12px 0}h2{font-size:20px;margin:0;color:#e6bd72}small,.cost{color:#c3af8f}a{color:#e6bd72}</style>
<h1>已接入成员技能 · v0.26</h1><p>33 名现行伙伴 · 99 项技能 · 7 级三选一，11 级精通。阿飞使用独立转职技能。</p><p><a href="../../docs/design/member-skills.md">完整规则、移植差异与存档说明</a></p><main>'''+''.join(cards)+'</main></html>'
    (output / 'index.html').write_text(page, encoding='utf-8')


if __name__ == '__main__':
    render()
