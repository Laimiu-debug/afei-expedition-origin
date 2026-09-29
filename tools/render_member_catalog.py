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
        f'# 阿飞远征团｜{total} 人配置与相遇清单 v0.26.0', '',
        '本文件由 `tools/render_member_catalog.py` 从真实入口导出的数据生成。人物文案编辑 `data/character-stories.json`；V2 数值以 `balance-v2/全人物数值与招募总表.xlsx` 及其 `proposal.json` 为基准，经 `tools/render_balance_v26.py` 核对后生成运行覆盖层。运行 `tools/build_gameplay.py` 同步文档和游戏源码。表列一级八维已经包含固定原版特质，不再重复加减。', '',
        f'**完成范围：**{total}人起步属性、天赋、原版装备和介绍；{captains}名初始队长、{recruits}名可招募成员。所有 {personal_encounters} 人各自满足隐藏条件后进入持久队列，在原版城镇招募界面出现。此表供开发查阅，不在游戏内预告。', '',
        '**当前范围：**每人一段双选项成长事件及对应被动；33 名现行伙伴各有三个专属技能候选，7 级三选一、11 级自动精通；阿飞保留独立转职；眼子已补齐三项专属研习。自行车、电子烟与隐藏支线已接入。装备正常叠加，名册只记录已知人物与已触发事件。敌军缩放最多计算等级最高的十二人；罗一可与眼子的两段后续、分支结局已接入，见[个人剧情全文](blue-team-stories.md)；其余长线剧情与长期平衡仍待完善。以下身世与场景为虚构改编，数值与独立条件为试玩参数，均不是对真人的事实认定。具体验证范围见版本记录。', '',
        f'[本版说明](../releases/v0.26.0.md) · [成员技能](member-skills.md) · [{total}人制作名单](character-roster.md) · [人物故事梗概](character-stories.md) · [个人成长数据](../../data/member-growth.json) · [完整运行数据](../../build/characters.json)', '',
        f"名册容量 {roster['rosterMax']}，最多 {roster['combatMax']} 人上场。新候选按天数与历史最高等级补级至1～5级，升级点与Perk保持未分配，可自行换装；起步方向不会锁定职业。日薪还受原版等级与特性影响。", '',
        '| 编号 | 人物 | 起步方向 | 人物解锁条件（开发资料） | 规划招募费 | 基础日薪 |', '| --- | --- | --- | --- | ---: | ---: |'
    ]
    labels = {'days':'天数','jobs':'非送信付费契约', 'battles':'参战', 'level':'最高等级', 'towns':'不同非敌对聚落', 'types':'非送信契约种类', 'companions':'曾同行的主题成员'}
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
        lines.extend(['', f"**开放：**{condition(c)}，随后排队在友好城镇招募界面出现。规划招募费 {c['hireCost']} 克朗，基础日薪 {c['wage']}。", '',
                      f"### 旧相遇剧本存稿（不再作为雇佣前置）：{c['encounterTitle']}", '', c['encounterText'], ''])
        for choice in c['encounterChoices']:
            lines.extend([f"- **{choice['label']}**：当场 {choice['cost']} 克朗，招募减免 {choice['hireDiscount']}，之后正式邀请需 {c['hireCost'] - choice['hireDiscount']} 克朗。{choice['outcome']}", ''])
    unlocks = [
        '# 全成员解锁条件｜v0.26.0', '',
        '供作者审核的完整表格。游戏内不展示未认识的人物名单、解锁门槛或未触发的支线。数值是本轮试玩参数，可逐人调整。', '',
        '## 出现和雇佣', '',
        '- 三队长开局同行，其余人物满足本表全部条件后进入持久队列。达标时不提前在 F8 揭晓名字。',
        '- 进入非敌对、非军事聚落时准备候选人，再打开原版招募界面雇佣，与普通佣兵并列；同次达标按制作名单顺序排队。普通中立村庄也可以，不要求提升好感；城堡和要塞等军事据点不算。白天点击聚落里的人群／招募，买卖装备和粮食的集市不是招募入口。',
        '- 全世界最多同时有 3 位待选主题成员；达标人数不足时按实际人数出现。换城查看招募时，候选人一起转到当前聚落，保留各自的实体、价格、装备和有效期，不重新抽人。',
        '- 三个招募位置独立计时：每雇佣一位，该位置间隔 1 个游戏日后，在首次打开合格聚落招募界面时补人。其余候选人仍可立即雇佣；从未占用的位置达标即能出现。',
        '- 每位候选人保留 4 个游戏日；未雇佣则排到队尾，资格不消失。持续旅行和查看招募可依次遇到。单纯等待天数不会代替各人的解锁条件。',
        '- 更新版本以新战役为验收口径；同一战役的候选、剩余期限与冷却正常保存，读档不重置。',
        '- 缺钱或名册已满时不扣款、不消耗资格。已雇佣、阵亡或永久离队的人不会再次生成。最终费用受原版雇佣倍率及旧档保留的折扣影响，以城镇报价为准。', '',
        '- 新候选首次生成时，入队等级为 `max(1, min(角色阶段上限, 1 + floor((历史最高等级 - 2) / 2)))`。按角色最低出现日分段（晚招不提高上限）：第 1～25 日上限 1，第 26～45 日上限 2，第 46～55 日上限 4，第 56 日起上限 5；生成后保存，不随刷新重新计算。补级的属性点和普通专长点保持未分配，不赠参战次数。',
        '- 本表报价是一级基础价。实际基础总价为 `进十位(折扣后服务费 + 装备基础价值 × 0.60 + 120 × (入队等级 - 1)^1.5)`，原版城镇倍率只乘一次。“偷大哥”仅折服务费，成功雇佣才消耗每 7 日一次的机会。补级点保持未分配，个人参战仍从实际经历累计。',
        '- 本页列主包 34 人；可选 DLC 的希文按第 35 日、参战 14 次、有效履约 5 次、不同城镇 6 座、历史最高等级 5 的全部条件入池，2 级基础价 590，详见 [DLC 说明](../../dlc/xiwen-regen/README.md)。', '',
        '## 统计口径', '',
        '- 表中“、”表示同时满足。非送信付费契约：原版成功完成且实际收到报酬的契约；原版送信和本 Mod 送信均排除。取消、失败、零收入和重复结算均不计。',
        '- 契约种类按不同原版契约类型计数，例如护送商队、清剿营地、追击盗贼；同类做多次只增加份数。',
        '- 参战：队中单个人物累计参战次数的历史最高值，不把十个人的一战算成十战，也不是必须打赢的场次。最高等级同样取历史最高值，普通佣兵也算。',
        '- 聚落：实际进入过的不同非敌对、非军事聚落，含村庄；同地重复进入只算一次。代码中的 isAlliedWithPlayer 表示非敌对关系，并不要求界面好感达到“友好”。同行人数：曾经招募的不同主题人物总数，含开局三队长，普通佣兵不算。',
        '- 达标资格和队列保存在存档中。旧版已经认识的成员保留资格；旧档没有契约类型记录，无法可靠重建非送信次数与种类，这两项从升级后累计，其他历史记录保留。', '',
        '| 编号 | 人物 | 全部解锁条件 | 基础招募费（克朗） |',
        '| --- | --- | --- | ---: |'
    ]
    for number, c in enumerate(characters, 1):
        unlocks.append(f"| {number:02} | {c['name']} | {condition(c)} | {'开局同行' if c['isCaptain'] else c['hireCost']} |")
    unlocks.extend(['', '## 送信规则', '',
        '取消 30 格硬上限，按实际道路选择距离最近的合格城镇，保留目标提示。报酬按道路长度计算：120 + 3 × 道路格数，最低 180、最高 450 克朗。', '',
        '本 Mod 世界中最多同时保留一份未接送信委托。首次可以直接领取；再次补充需要比上次接信时多完成至少一份非送信付费契约，并满足接信后全局 2 天、发信城镇 5 天、同一对城镇双向共用 7 天的冷却。取消和失败也不会返还本次供给。等待、存读档或 A↔B 往返均不能单独补信。', '',
        '这些限制只管理本 Mod 新增的送信契约；原版送信也不能刷人物解锁次数。v0.23 修正了额外送信挤占普通契约名额并重置供给计时的问题：本 Mod 送信不计入普通契约容量，生成时保留原有供给时间；其他原版契约继续遵循原版容量与冷却。旧档已经发生的供给计时变化无法可靠回推，可能需要自然等待当前冷却结束一次。', '',
        '来源：`src/scripts/mods/afeix/discovery.nut`、`recruitment.nut`、`quests.nut`。由实际运行数据导出，与游戏包同次构建。'])
    (ROOT / 'docs/design/recruit-unlocks.md').write_text('\n'.join(unlocks) + '\n', encoding='utf-8')
    destination = ROOT / 'docs/design/member-implementation.md'
    destination.write_text('\n'.join(lines).rstrip() + '\n', encoding='utf-8')
    return destination


if __name__ == '__main__':
    render_catalog(json.loads((ROOT / 'build/characters.json').read_text(encoding='utf-8')))
