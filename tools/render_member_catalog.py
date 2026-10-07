"""Render the member review catalog from the validated runtime data export."""
from pathlib import Path
import json

ROOT = Path(__file__).resolve().parents[1]


def render_catalog(roster):
    version = (ROOT / 'VERSION').read_text(encoding='utf-8').strip()
    characters = roster['characters']
    total = len(characters)
    captains = sum(c['isCaptain'] for c in characters)
    recruits = total - captains
    direct_invites = 0
    personal_encounters = recruits - direct_invites
    lines = [
        f'# 阿飞远征团｜{total} 人配置与相遇清单 v{version}', '',
        '本文件由 `tools/render_member_catalog.py` 从真实入口导出的数据生成。人物文案编辑 `data/character-stories.json`；V2 数值以 `balance-v2/全人物数值与招募总表.xlsx` 及其 `proposal.json` 为基准，经 `tools/render_balance_v26.py` 核对后生成运行覆盖层。运行 `tools/build_gameplay.py` 同步文档和游戏源码。表列一级八维已经包含固定原版特质，不再重复加减。', '',
        f'**完成范围：**{total}人起步属性、天赋、原版装备和介绍；{captains}名初始队长、{recruits}名可招募成员。常规成员满足条件后排队；宋暖阳与溺水小龟满足条件后在独立位置随机出现，均通过原版城镇招募界面雇佣。此表供开发查阅，不在游戏内预告。', '',
        '**当前范围：**每人一段双选项成长事件及对应被动；33 名现行伙伴各有三个专属技能候选，7 级三选一、11 级自动精通；阿飞保留独立转职；眼子已补齐三项专属研习。自行车、电子烟与隐藏支线已接入。装备正常叠加，名册只记录已知人物与已触发事件。敌军缩放最多计算等级最高的十二人；长线剧情与长期平衡仍待完善。以下身世与场景为虚构改编，数值与独立条件为试玩参数，均不是对真人的事实认定。具体验证范围见版本记录。', '',
        f'[本版说明](../releases/v0.26.0.md) · [成员技能](member-skills.md) · [{total}人制作名单](character-roster.md) · [人物故事梗概](character-stories.md) · [个人成长数据](../../data/member-growth.json) · [完整运行数据](../../build/characters.json)', '',
        f"名册容量 {roster['rosterMax']}，最多 {roster['combatMax']} 人上场。新候选按天数与历史最高等级补级至1～5级，升级点与Perk保持未分配，可自行换装；起步方向不会锁定职业。日薪还受原版等级与特性影响。", '',
        '| 编号 | 人物 | 起步方向 | 人物解锁条件（开发资料） | 规划招募费 | 基础日薪 |', '| --- | --- | --- | --- | ---: | ---: |'
    ]
    labels = {'days':'天数','jobs':'非送信付费契约', 'battles':'参战', 'level':'最高等级', 'towns':'不同非敌对聚落', 'types':'非送信契约种类', 'companions':'曾同行的主题成员'}
    random_visitors = roster.get('recruitment', {}).get('randomVisitors', {})
    def condition(c):
        if c['isCaptain']:
            return '开局同行'
        text = '、'.join(f'{labels[k]} ≥ {v}' for k,v in roster['encounterRequirements'][c['key']].items())
        if c['key'] in random_visitors:
            r = random_visitors[c['key']]
            text += f"；独立随机 {r['chance']}%／有效抽取日，第 {r['pity_attempts']} 次保底"
        return text
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
        lines.extend(['', f"**开放：**{condition(c)}，通过合格聚落招募界面雇佣。规划招募费 {c['hireCost']} 克朗，基础日薪 {c['wage']}。", '',
                      f"### 旧相遇剧本存稿（不再作为雇佣前置）：{c['encounterTitle']}", '', c['encounterText'], ''])
        for choice in c['encounterChoices']:
            lines.extend([f"- **{choice['label']}**：当场 {choice['cost']} 克朗，招募减免 {choice['hireDiscount']}，之后正式邀请需 {c['hireCost'] - choice['hireDiscount']} 克朗。{choice['outcome']}", ''])
    unlocks = [
        f'# 全成员解锁条件｜v{version}', '',
        '供作者审核的完整表格。游戏内不展示未认识的人物名单、解锁门槛或未触发的支线。数值是本轮试玩参数，可逐人调整。', '',
        '## 出现和雇佣', '',
        '- 三队长开局同行。刀一其余七人按第2、3、4、5、6、8、10日分批开放；刀二第12～26日，飞团第28～54日。常规成员满足全部条件后进入持久队列，未曾展示者优先，同类再按排队顺序。达标时不提前在 F8 揭晓名字。',
        '- 进入非敌对、非军事聚落时准备候选人，再打开原版招募界面雇佣，与普通佣兵并列；同次达标先按规划解锁日期排序，同日再按制作名单顺序；已保存的排队顺序保留。普通中立村庄也可以，不要求提升好感；城堡和要塞等军事据点不算。白天点击聚落里的人群／招募，买卖装备和粮食的集市不是招募入口。',
        '- 全世界同时最多3名常规候选，另有宋暖阳、溺水小龟各1个独立来客位置，最多共5名主题候选。换城查看招募时，候选人一起转到当前聚落，保留各自的实体、价格、装备和有效期，不重新抽人。',
        '- 三个常规招募位置独立计时：每雇佣一位，该位置间隔1个游戏日后，在首次打开合格聚落招募界面时补人。其余候选人仍可立即雇佣；从未占用的位置达标即能出现。两位来客成功雇佣后，其独立位置不再生成同名人物。',
        '- 常规候选首次展示保留4个游戏日，之后重逢保留2日；未雇佣则排到回流队尾，资格不消失。优先新面孔，但回流等待满6日后，每连续展示2位新面孔就安排1位等待较久的回流者；没有新人时全部位置正常轮换。有候选可用就补位，不为某一类人留空位。已在展示的人不被提前赶走，雇佣后仍需等该位置1日冷却。',
        '- 回流等待从上次展示到期时开始计算，换城、读档和反复查看不会重置或推进排队；天数不能代替各人的其他解锁条件。单个人物生成失败保留原队次，当前查看继续尝试其他候选；不会消耗该人的首次展示时间。',
        '- 宋暖阳从第16日起，参战6次、非送信付费契约2份、不同合格聚落4座、历史最高3级后参与35%抽取；小龟从第1日起，进入1座合格聚落即可参与25%抽取，无战斗、契约或升级前置。两人各自保留2日，未雇佣则重新参加抽取，直到成功雇佣。',
        '- 每名来客仅在自己的位置空闲、满足资格、查看合格聚落时，每游戏日最多抽取一次；换城与反复打开界面共用结果。连续4次有效抽取失败，第5次保底；出现后重置。未到城查看、位置仍被占用时不累计次数，也不补抽过去的天数。抽取结果与保底计数随存档保存。',
        '- 更新版本以新战役为验收口径；同一战役的候选、剩余期限与冷却正常保存，读档不重置。',
        '- 缺钱或名册已满时不扣款、不消耗资格。已雇佣、阵亡或永久离队的人不会再次生成。最终费用受原版雇佣倍率及旧档保留的折扣影响，以城镇报价为准。', '',
        '- 新候选首次生成时，入队等级为 `max(1, min(角色补级上限, 1 + floor((历史最高等级 - 2) / 2)))`。常规成员保留各自原有补级上限，不因日期提前而降级；宋暖阳、小龟上限改为5，随初次相遇时的队伍历史最高等级补级。首次生成后保存，不随刷新重新计算。补级的属性点和普通专长点保持未分配，不赠参战次数。',
        '- 本表报价按各角色的阶段补级上限计算，未含城镇倍率和折扣。实际基础总价为 `进十位(折扣后服务费 + 装备基础价值 × 0.60 + 120 × (入队等级 - 1)^1.5)`，原版城镇倍率只乘一次。“偷大哥”仅折服务费，成功雇佣才消耗每 7 日一次的机会。补级点保持未分配，个人参战仍从实际经历累计。',
        '- 刀一七名收费成员一级基准合计3860克朗。宋暖阳一级1000、五级1960；小龟一级870、五级1830。先后日期和资格表示可遇见，并不自动提供招募资金。',
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
