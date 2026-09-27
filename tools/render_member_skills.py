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


def render():
    data = json.loads((ROOT / 'build/characters.json').read_text(encoding='utf-8'))
    expansion = json.loads((ROOT / 'data/member-skill-expansion.json').read_text(encoding='utf-8'))
    groups, defs = data['memberSkills'], data['memberSkillDefs']
    assert len(groups) == 33 and len(defs) == 99
    lines = ['# 已接入成员技能｜v0.15', '',
             '33 名伙伴各三项，共 99 项成员技能；阿飞沿用独立转职技能。相较 v0.14 新接入 81 项。每人前两项入队即可使用，第三项完成该人的现有个人成长选择后解锁，两条成长选择都可解锁。当前数值由游戏预加载入口导出，不是旧稿待办。', '',
             '本表只供作者审阅，不会把未知成员、转职、六根或自行车条件放进游戏黑旗名册。', '',
             '|成员|入队技能一|入队技能二|个人成长后解锁|', '|---|---|---|---|']
    cards = []
    for person in data['characters']:
        if person['key'] not in groups:
            continue
        keys = groups[person['key']]
        lines.append('|' + '|'.join([person['name']] + [defs[k]['name'] for k in keys]) + '|')
        for key in keys:
            d = defs[key]
            stage = '个人成长后' if d.get('growth') else '入队时'
            label = person['name'] + ' · ' + stage
            cards.append(f'<article><img src="../../src/gfx/skills/afeix_member_{key}.png" alt=""><small>{html.escape(label)}</small><h2>{html.escape(d["name"])}</h2><p class="cost">{html.escape(cost(d))}</p><p>{html.escape(d["text"])}</p></article>')
    lines += ['', '## 具体效果', '']
    for person in data['characters']:
        if person['key'] not in groups:
            continue
        lines += [f"### {person['name']}", '']
        for key in groups[person['key']]:
            d = defs[key]
            stage = '个人成长后' if d.get('growth') else '入队时'
            lines += [f"**{d['name']}**（{stage}；{cost(d)}）：{d['text']}", '']
    lines += ['## 与旧稿的差异', '']
    lines += ['- ' + text for text in expansion['adaptations']]
    lines += ['', '## 通用规则与存档', '',
              '- 临时护卫的近防、远防、决心分别取最高值；人物条件被动、盾牌和原版专长另行计算。下一次武器技能疲劳减免取最高一份，最低消耗 0。新增额外回疲劳每人每轮合计最多 20。',
              '- 标记及下一次攻击加成在真实出手命中或落空后消耗。鼠标预览不消耗。范围攻击不使用这些单体加成；投掷武器正常扣弹药。',
              '- 原版普通步行与专属位移分开计数。换位和一步移动不能绕过定身、眩晕和地形高度限制。护卫被移动、失盾或失去行动能力后失效的效果不会因重新满足条件自动恢复。',
              '- 新招募、旧档已入队成员及城镇待雇佣候选共用补技能入口。重复载入不重复加技能；已完成个人成长的人会补齐第三项。不重置等级、经验、九星配置、加点、装备或剧情进度。',
              '- 冷却、每战次数、战斗计数及临时效果均可序列化；战斗结束清理临时状态。世界地图折扣以世界旗标记录，只有成功付款／招募才消耗次数。',
              '- 旧 34 人审阅档仍可使用，但未完成个人成长的人只有前两项技能；该档不会被强行改为全技能档。', '',
              '99 个技能图标文件逐字节复用旧 PNG，没有重新生图。少数新技能借用已有图案，来源逐项标注于[图标清单](../../art/runtime/member-skills-v15/report.json)。[按人物查看图册](../../build/member-skills/index.html)。', '',
              '离线测试不等于实机验收；验证范围与安装信息见[v0.15 说明](../playtest-0.15.md)。', '']
    (ROOT / 'docs/design/member-skills.md').write_text('\n'.join(lines), encoding='utf-8')
    output = ROOT / 'build/member-skills'
    output.mkdir(parents=True, exist_ok=True)
    page = '''<!doctype html><html lang="zh-CN"><meta charset="utf-8"><title>已接入成员技能 v0.15</title>
<style>body{max-width:1240px;margin:auto;padding:28px;background:#201c18;color:#ede1cb;font:16px/1.6 system-ui}h1{font-size:28px}main{display:grid;grid-template-columns:repeat(auto-fit,minmax(300px,1fr));gap:16px}article{padding:18px;background:#30271e;border:1px solid #776044}img{width:56px;height:56px;float:left;margin:0 16px 12px 0}h2{font-size:20px;margin:0;color:#e6bd72}small,.cost{color:#c3af8f}a{color:#e6bd72}</style>
<h1>已接入成员技能 · v0.15</h1><p>33 名伙伴 · 99 项技能 · 入队两项，个人成长再解锁一项。阿飞使用独立转职技能。</p><p><a href="../../docs/design/member-skills.md">完整规则、移植差异与存档说明</a></p><main>'''+''.join(cards)+'</main></html>'
    (output / 'index.html').write_text(page, encoding='utf-8')


if __name__ == '__main__':
    render()
