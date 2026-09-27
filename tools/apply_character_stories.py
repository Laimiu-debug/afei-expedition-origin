"""Apply reviewed story prose without changing gameplay fields, and render its review document."""
from pathlib import Path
import json
import os
import re

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'data/character-stories.json'
RUNTIME = ROOT / 'src/scripts/mods/afeix/characters.nut'
DOCUMENT = ROOT / 'docs/design/character-stories.md'
KINDS = {
    'user_confirmed': '用户确认',
    'legacy_motif': '旧稿母题',
    'archive_clip_title': '页面／切片标题线索，未核对白',
    'draft_proposal': '本轮原创提案',
}
STRING = r'"(?:\\.|[^"\\])*"'


def quote(value):
    if not isinstance(value, str) or not value.strip():
        raise ValueError('Story text must be a nonempty string')
    return json.dumps(value, ensure_ascii=False)


def replace_field(block, field, value):
    pattern = rf'(\b{field}\s*=\s*){STRING}'
    block, count = re.subn(pattern, lambda m: m[1] + quote(value), block)
    if count != 1:
        raise ValueError(f'Expected one {field}, got {count}')
    return block


def source_link(source):
    if source.startswith(('https://', 'http://')):
        return f'[来源]({source})'
    candidate = ROOT / source
    if candidate.is_file():
        relative = Path(os.path.relpath(candidate, DOCUMENT.parent)).as_posix()
        return f'[{candidate.name}]({relative})'
    return source


def render(stories):
    lines = [
        '# 阿飞远征团｜34 人故事梗概修订', '',
        '更新：2026-09-26。依据最新人物补充重写，替代旧版 35 人侧写作为当前故事工作稿。眼子已移出制作名单；不改写真实活动历史，也不从旧存档中抹掉已招募的角色。', '',
        '**这一版写什么：**用人物的熟悉称呼、说话方式、个人欲望与行动建立差异。有人好面子，有人爱抢拍，有人就想赢自己的比赛；并非每个人都来教阿飞同一堂课。人物之间也应有搭档、争执和笑点。', '',
        '**依据怎么读：**“用户确认”是你提供的特点；“旧稿母题”来自旧项目，未经真人事实核验；“标题线索”只表示页面可查；“原创提案”是为 Mod 新写的情节。所有身世、场景、对白和成长安排均为游戏改编，台词不是主播原话。小哈尼的个人特点仍待补充，现有动机可替换；老蔡的推演习惯等也不是已确认的真人梗。', '',
        '**落地范围：**34 人介绍与招募相遇文本已同步到试玩源码。3 名队长开局；31 人后续招募，其中小酒瓶、白小帅子仍在首份任务后直接开放，其余29人有双选项相遇。v0.3 新增每人的首段双选项成长及被动、阿飞转职、六根入口与自行车事件，详见[试玩说明](../playtest-0.3.md)。下列“后续故事方向”仍是完整长线提案，不等于所有情节都已实现。v0.4 已接入全员完整胸像；小龟采用小龟化身，宋暖阳采用人类鹌鹑纹兜帽。见[美术试玩说明](../playtest-0.4.md)。', '',
        '[制作名单](character-roster.md) · [当前配置与相遇全文](member-implementation.md) · [小龟与阿飞的取材记录](../research/xiaogui-afei-bond.md) · [灵感手记](idea-journal.md)', '',
        '本文件由 [故事数据](../../data/character-stories.json) 生成；编辑数据后运行 `tools/build_gameplay.py` 会同步故事文档及游戏内文案，不修改装备、属性或经济数值。', '',
        '| 人物 | 故事题目 | 识别重点 |', '| --- | --- | --- |',
    ]
    for i, c in enumerate(stories, 1):
        lines.append(f"| [{i:02} {c['name']}](#member-{c['key']}) | {c['storyTitle']} | {'；'.join(c['features'])} |")
    for i, c in enumerate(stories, 1):
        lines.extend(['', f'<a id="member-{c["key"]}"></a>', '', f"## {i:02}｜{c['name']}：{c['storyTitle']}", '',
                      '**保留的特点：**' + '；'.join(c['features']) + '。', '',
                      c['synopsis'], '', '**后续故事方向（未实现）：**' + c['arc'], '',
                      '**原创台词：**', '', '> ' + c['voice'], '', '**取材与创作边界：**', ''])
        for basis in c['basis']:
            lines.append(f"- **{KINDS[basis['kind']]}：**{basis['note']}（{source_link(basis['source'])}）")
        if c['key'] in {'bottle', 'shuaizi'}:
            lines.extend(['', '当前仍为首份任务后直接邀请；个人相遇文案只作为候选背景收录，不新增前置收费或解锁条件。'])
    DOCUMENT.write_text('\n'.join(lines).rstrip() + '\n', encoding='utf-8')


def apply_stories():
    stories = json.loads(SOURCE.read_text(encoding='utf-8'))['characters']
    text = RUNTIME.read_text(encoding='utf-8-sig')
    order = json.loads(re.search(r'A\.CharacterOrder <- (\[[^\n]+\]);', text)[1])
    if [c['key'] for c in stories] != order or len(set(order)) != len(order):
        raise ValueError('Story identities must match the current runtime order exactly')
    by_key = {c['key']: c for c in stories}
    prefix, active = text.split('A.Characters <- {', 1)
    active, suffix = active.split('\n};', 1)
    pattern = re.compile(r'^    ([a-z0-9_]+) = \{.*?^    \}(,?)', re.M | re.S)
    seen = []

    def rewrite(match):
        key = match[1]
        c = by_key[key]
        block = match[0]
        name = json.loads(re.search(r'\bname\s*=\s*(' + STRING + ')', block)[1])
        if c['name'] != name or not c['features'] or not c['basis']:
            raise ValueError(f'Missing story grounding or mismatched name: {key}')
        for b in c['basis']:
            if b['kind'] not in KINDS or not b['note'] or not b['source']:
                raise ValueError(f'Invalid story basis: {key}')
        for field in ['storyTitle', 'synopsis', 'arc', 'voice']:
            quote(c[field])
        block = replace_field(block, 'description', c['description'])
        captain = re.search(r'\bisCaptain\s*=\s*true', block) is not None
        encounter = c['encounter']
        if captain:
            if encounter is not None:
                raise ValueError(f'Starting captain cannot gain a recruitment encounter: {key}')
        else:
            if not encounter or len(encounter['labels']) != 2 or len(encounter['outcomes']) != 2:
                raise ValueError(f'Two recruitment choices are required: {key}')
            block = replace_field(block, 'encounterTitle', encounter['title'])
            block = replace_field(block, 'encounterText', encounter['text'])
            for field, values in [('label', encounter['labels']), ('outcome', encounter['outcomes'])]:
                values = iter(values)
                block, count = re.subn(rf'(\b{field}\s*=\s*){STRING}', lambda m: m[1] + quote(next(values)), block)
                if count != 2:
                    raise ValueError(f'Expected two choice {field}s: {key}')
        seen.append(key)
        return block

    active = pattern.sub(rewrite, active)
    if seen != order:
        raise ValueError('Not every active character block was updated')
    RUNTIME.write_text(prefix + 'A.Characters <- {' + active + '\n};' + suffix, encoding='utf-8')
    render(stories)
    return len(stories)


if __name__ == '__main__':
    print(f'Applied story prose for {apply_stories()} members.')
