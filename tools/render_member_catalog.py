"""Render the member review catalog from the validated runtime data export."""
from pathlib import Path
import json

ROOT = Path(__file__).resolve().parents[1]


def render_catalog(roster):
    characters = roster['characters']
    total = len(characters)
    captains = sum(c['isCaptain'] for c in characters)
    recruits = total - captains
    direct_invites = 0
    personal_encounters = recruits - direct_invites
    lines = [
        f'# 阿飞远征团｜{total} 人配置与相遇清单 v0.16', '',
        '本文件由 `tools/render_member_catalog.py` 从真实入口导出的数据生成。人物文案编辑 `data/character-stories.json`，玩法数值编辑 `src/scripts/mods/afeix/characters.nut`；运行 `tools/build_gameplay.py` 后同步文档和游戏源码。', '',
        f'**完成范围：**{total}人起步属性、天赋、原版装备和介绍；{captains}名初始队长、{recruits}名可招募成员。所有 {personal_encounters} 人各自满足隐藏条件后进入持久队列，在原版城镇招募界面出现。此表供开发查阅，不在游戏内预告。', '',
        '**当前范围：**每人一段双选项成长事件及对应被动；33 名伙伴各三项成员技能，入队开放两项，完成个人成长开放第三项；阿飞保留独立转职。自行车、电子烟与隐藏支线已接入。装备正常叠加，名册只记录已知人物与已触发事件。敌军缩放最多计算等级最高的十人；完整长线个人剧情与长期平衡仍待完善。以下身世与场景为虚构改编，数值与独立条件为试玩参数，均不是对真人的事实认定。具体验证范围见版本记录。', '',
        f'[本版说明](../playtest-0.16.md) · [成员技能](member-skills.md) · [{total}人制作名单](character-roster.md) · [人物故事梗概](character-stories.md) · [个人成长数据](../../data/member-growth.json) · [完整运行数据](../../build/characters.json)', '',
        f"名册容量 {roster['rosterMax']}，最多 {roster['combatMax']} 人上场。所有角色入队为1级，可自行换装和选择Perk；起步方向不会锁定职业。日薪还受原版等级与特性影响。", '',
        '| 编号 | 人物 | 起步方向 | 人物解锁条件（开发资料） | 原招募费 | 基础日薪 |', '| --- | --- | --- | --- | ---: | ---: |'
    ]
    labels = {'jobs':'非送信付费契约', 'battles':'参战', 'level':'最高等级', 'towns':'不同友好城镇', 'types':'非送信契约种类', 'companions':'曾同行的主题成员'}
    def condition(c):
        return '开局同行' if c['isCaptain'] else '、'.join(f'{labels[k]} ≥ {v}' for k,v in roster['encounterRequirements'][c['key']].items())
    for number, character in enumerate(roster['characters'], 1):
        c = character
        lines.append(f"| {number:02} | {c['name']} | {c['role']} | {condition(c)} | {'开局' if c['isCaptain'] else c['hireCost']} | {c['wage']} |")
    attr_names = ['生命', '疲劳上限', '决心', '先攻', '近战', '远程', '近防', '远防']
    star_names = dict(zip(['Hitpoints', 'Stamina', 'Bravery', 'Initiative', 'MeleeSkill', 'RangedSkill', 'MeleeDefense', 'RangedDefense'], attr_names))
    for number, c in enumerate(roster['characters'], 1):
        lines.extend(['', f"## {number:02}｜{c['name']}", '', c['description'], '',
                      '**基础属性：**' + '；'.join(f'{name} {n}' for name, n in zip(attr_names, c['attrs'])) + '。', '',
                      '**天赋：**' + '；'.join(f'{star_names[key]} {stars} 星' for key, stars in c['stars'].items()) + '。', '',
                      '**原版装备路径（接入核对）：**' + '、'.join(f'`{path}`' for path in c['equipment']) + '。'])
        if c['bag']:
            lines.extend(['', '**备用物品：**' + '、'.join(f'`{path}`' for path in c['bag']) + '。'])
        if c['isCaptain']:
            lines.extend(['', '三队长之一，开局入队，不通过任务重复生成。'])
            continue
        lines.extend(['', f"**开放：**{condition(c)}，随后排队在友好城镇招募界面出现。原招募费 {c['hireCost']} 克朗，基础日薪 {c['wage']}。", '',
                      f"### 旧相遇剧本存稿（不再作为雇佣前置）：{c['encounterTitle']}", '', c['encounterText'], ''])
        for choice in c['encounterChoices']:
            lines.extend([f"- **{choice['label']}**：当场 {choice['cost']} 克朗，招募减免 {choice['hireDiscount']}，之后正式邀请需 {c['hireCost'] - choice['hireDiscount']} 克朗。{choice['outcome']}", ''])
    unlocks = [
        '# 全成员解锁条件｜v0.10', '',
        '供作者审核的完整表格。游戏内不展示未认识的人物名单、解锁门槛或未触发的支线。数值是本轮试玩参数，可逐人调整。', '',
        '## 出现和雇佣', '',
        '- 三队长开局同行，其余人物满足本表全部条件后进入持久队列。达标时不提前在 F8 揭晓名字。',
        '- 在友好、非军事城镇打开原版招募界面，最早达标的待选人物必定加入招募列表，与普通佣兵并列；同次达标按制作名单顺序排队。',
        '- 全世界同时只有一位待选主题成员。换城查看招募时，该人会转到当前城镇，保留同一个实体、价格、装备和有效期，不重新抽人。',
        '- 雇佣后至少间隔 3 个游戏日，下一位在之后首次打开合格城镇招募界面时出现。第一位达标即能出现。',
        '- 一轮相遇保留 4 个游戏日；未雇佣则排到队尾，资格不消失。多个成员同时达标时逐个出现，持续旅行和查看招募可依次遇到。',
        '- 缺钱或名册已满时不扣款、不消耗资格。已雇佣、阵亡或永久离队的人不会再次生成。最终费用受原版雇佣倍率及旧档保留的折扣影响，以城镇报价为准。', '',
        '## 统计口径', '',
        '- 表中“、”表示同时满足。非送信付费契约：原版成功完成且实际收到报酬的契约；原版送信和本 Mod 送信均排除。取消、失败、零收入和重复结算均不计。',
        '- 契约种类按不同原版契约类型计数，例如护送商队、清剿营地、追击盗贼；同类做多次只增加份数。',
        '- 参战：队中单个人物累计参战次数的历史最高值，不把十个人的一战算成十战，也不是必须打赢的场次。最高等级同样取历史最高值，普通佣兵也算。',
        '- 城镇：实际进入过的不同友好、非军事城镇；同城重复进入只算一次。同行人数：曾经招募的不同主题人物总数，含开局三队长，普通佣兵不算。',
        '- 达标资格和队列保存在存档中。旧版已经认识的成员保留资格；旧档没有契约类型记录，无法可靠重建非送信次数与种类，这两项从升级后累计，其他历史记录保留。', '',
        '| 编号 | 人物 | 全部解锁条件 | 基础招募费（克朗） |',
        '| --- | --- | --- | ---: |'
    ]
    for number, c in enumerate(characters, 1):
        unlocks.append(f"| {number:02} | {c['name']} | {condition(c)} | {'开局同行' if c['isCaptain'] else c['hireCost']} |")
    unlocks.extend(['', '## 送信规则', '',
        '取消 30 格硬上限，按实际道路选择距离最近的合格城镇，保留目标提示。报酬按道路长度计算：120 + 3 × 道路格数，最低 180、最高 450 克朗。', '',
        '本 Mod 世界中最多同时保留一份未接送信委托。首次可以直接领取；再次补充需要比上次接信时多完成至少一份非送信付费契约，并满足接信后全局 2 天、发信城镇 5 天、同一对城镇双向共用 7 天的冷却。取消和失败也不会返还本次供给。等待、存读档或 A↔B 往返均不能单独补信。', '',
        '这些限制只管理本 Mod 新增的送信契约，不改写原版契约的供给；原版送信也不能刷人物解锁次数。', '',
        '来源：`src/scripts/mods/afeix/discovery.nut`、`recruitment.nut`、`quests.nut`。由实际运行数据导出，与游戏包同次构建。'])
    (ROOT / 'docs/design/recruit-unlocks.md').write_text('\n'.join(unlocks) + '\n', encoding='utf-8')
    destination = ROOT / 'docs/design/member-implementation.md'
    destination.write_text('\n'.join(lines).rstrip() + '\n', encoding='utf-8')
    return destination


if __name__ == '__main__':
    render_catalog(json.loads((ROOT / 'build/characters.json').read_text(encoding='utf-8')))
