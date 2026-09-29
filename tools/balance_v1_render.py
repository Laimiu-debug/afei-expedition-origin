"""Render proposal and measured offline results; no playable files are changed."""
from pathlib import Path
import json,sys
sys.stdout.reconfigure(encoding='utf-8')
ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'docs/design/balance-v1'
P=json.loads((OUT/'proposal.json').read_text(encoding='utf-8'))
V=json.loads((OUT/'validation.json').read_text(encoding='utf-8'))
F=P['fields'];L=P['labels'];S={s['key']:s for s in P['skills']};PR={p['key']:p for p in V['projection']}
def n(x):return f'{x:g}' if isinstance(x,(float,int)) else str(x)
def table(head,rows):return '\n'.join(['|'+'|'.join(head)+'|','|'+'|'.join(['---']*len(head))+'|']+['|'+'|'.join(n(v).replace('|','／').replace('\n','；') for v in row)+'|' for row in rows])+'\n'
def write(name,lines):(OUT/name).write_text('\n\n'.join(lines)+'\n',encoding='utf-8')
def gear(items):return '、'.join(P['items'][x]['name']+' `'+x+'`' for x in items)
def bonuses(d):return '、'.join(L[i]+'+'+n(d[f]) for i,f in enumerate(F) if f in d) or '无八维加成'

lines=['# 34人角色手册 · 新平衡提案',
'本稿未实装。所有八维按顺序：生命／疲劳上限／决心／先攻／近攻／远攻／近防／远防。一级值不含装备、剧情、转职、体质与原版专长。11级列使用本页明确的30项升级分配与第一个个人成长选项；不含天赋异禀、士气、临时技能。小龟固定体质双防+5另列；阿飞支线及路线另给情景。小数为数学期望，不是能出现半点属性的游戏角色。',
'招募条件全部同时满足；天数只代表最早资格，不保证候选马上出现。规划等级/价格按阶段补级上限列出，实际入队等级与价格按[总方案](总方案.md)公式。三个队长开局免费。一级可用疲劳只扣所列装备，不加剧情成长。',
table(['人物','分组','战术位置','最低日','规划等级','总价预算','一级日薪'],[[p['name'],p['group'],p['role'],p['day'],p['join_level'],p['suggested_price'],p['wage']] for p in P['people']])]
for idx,p in enumerate(P['people'],1):
    q=PR[p['key']]
    lines += [f"## {idx:02d}. {p['name']} · {p['role']}",f"分组：{p['group']}；存档ID：`{p['key']}`。现行定位：{p['current']['role']}。",
      table(['属性','现行一级','建议一级','天赋星','升级选取次数','成长选项一','11级均值','11级P10～P90'],[[L[i],p['current']['attrs'][i],p['attrs'][i],p['stars'].get(f,0),p['allocation'][i],p['growth_bonus'][i],q['base_means'][i],f"{q['attrs'][i]['p10']}～{q['attrs'][i]['p90']}"] for i,f in enumerate(F)]),
      f"**招募**：{'开局队长，不经过候选队列' if p['current']['isCaptain'] else f'最低第{p["day"]}日；个人参战历史最高≥{p["battles"]}、有效履约≥{p["contracts"]}、不同合格城镇≥{p["towns"]}、历史最高等级≥{p["highest_level"]}'}。规划入队{p['join_level']}级，服务费{p['service_fee']}，装备原价合计{n(p['equipment_value'])}，招募总价预算**{p['suggested_price']}克朗**；一级日薪{p['wage']}，11级日薪期望预算{q['wage11']:.2f}（实际逐人取整和倍率以游戏UI为准）。",
      f"**随身装备**：{gear(p['equipment'])}。包内：{gear(p['bag'])}。身甲{n(p['body_armor'])}／头甲{n(p['head_armor'])}；装备疲劳{n(p['equipment_fatigue'])}、包内疲劳{n(p['bag_fatigue'])}；一级可用疲劳{n(q['join_usable_fatigue'])}。",
      '**特性与成长**：'+p['trait_note']+'。',
      table(['互斥分支','故事特性','八维效果'],[[str(i+1)+'．'+g['label'],g['traitName'],bonuses(g['bonuses'])] for i,g in enumerate(p['growth_choices'])]),
      '**培养目标**：'+p['target']+'。目标是构筑方向，需结合上面的实际均值与技能收益评估；不能把目标下限当作已经满足。',
      '**原版10点构筑参考**：'+p['perks']+'。这是最终槽位建议，不是按列表顺序点；7级优先取得轻装或战铸，同一“或”只选其一。天赋异禀如选用，其额外三项增量另加，未写入上表。',
      '**终局装备方向**：'+p['endgame_weapon']+'。',
      '**短板与换人理由**：'+p['weakness']+'。']
    if p['key']=='afei':
        lines += ['**专属路线**：'+P['route_unlock'],
                  '**饰品**：起始另配电子烟，不计收费装备价值；'+P['accessories'][0]['text'],
                  table(['路线','自行车分支']+L,[[x['route'],x['event']]+x['attrs'] for x in V['afei_scenarios']]),
                  '以上6行互斥，只能取其中一行；未计钢铁身躯、士气、临时号令和电子烟治疗。默认个人成长仍是选项一。']
    else:
        lines += [table(['7级三选一','费用','冷却／距离','完整效果'],[[S[k]['name'],f"{S[k]['ap']}AP / {S[k]['fatigue']}疲劳" if S[k]['active'] else '被动',f"CD{S[k]['cd']} / {S[k]['range']}格",S[k]['text']] for k in p['skills']]),
                  '11级变化与当前版本差异见[技能总表](技能总表.md)。先按战场需求选分支：承压选防护/解控，短战选即时收益，长战再评恢复与累积；没有触发条件的技能其贡献按0算。']
    if p['key']=='xiaogui':lines+=['**体质必须单独计价**：不能戴头盔，免费钢头、固定近防/远防+5，头部武器伤害×0.5、躯干×0.8；与轻装等按各自乘区处理。上表11级裸近防未含固定+5。需另测穿透、持续伤害及破盾，不能用“无头甲”推断其必弱，也不能凭减伤就认定免疫。']
lines += ['## 专长名称与顺序说明','译名可能随汉化变化：钢铁身躯 Colossus；天赋异禀 Gifted；钢头 Steel Brow；以一敌众 Underdog；轻装 Nimble；战铸 Battle Forged；坚定不移 Indomitable；坚定 Fortified Mind；振奋军心 Rally the Troops；脚步/脱离 Footwork；轮换 Rotation；迅捷 Relentless；恐惧打击 Fearsome。以英文ID及游戏实际层级为准。盾卫9命与天赋异禀是同一个槽位的替换项。双手低耗路线不应同时照抄狂战/决斗的单手输出方案。',
'34人全部可以独立构筑，剧情人际关系不等于必须一起占用战场位置。技能、基础数值与装备共同决定贡献；同角色改成另一定位时，应重新分配30项升级点，不能直接把两个构筑峰值合并。']
write('角色手册.md',lines)

lines=['# 全技能契约 · 99个成员选项＋3条队长路线＋电子烟',
'提案状态：未实装。33名普通成员各三选一；阿飞单独选择路线。7级选定、11级精通。每战次数、触发条件、结束时点属于规则本体，必须和AP、疲劳、CD一起实现。[全局叠加规则](总方案.md#3-全局技能预算)优先；以下每项只影响明确写出的对象。',
'被动写AP0不表示存在一个零AP可点击按钮。主动范围0表示仅自身。若动作借用武器招式，需正常命中、弹药、射程、遮挡与目标合法性，不能把文字里的“攻击”实现成必中的直接扣血。费用为总费用，不再额外扣一次被借用攻击AP；必要弹药与武器条件仍消耗。']
for p in P['people']:
    if p['key']=='afei':continue
    lines += [f"## {p['name']} · {p['role']}"]
    for k in p['skills']:
        s=S[k]
        lines += [f"### {s['name']} `{k}`",f"{'主动' if s['active'] else '被动'}；{s['ap']}AP；{s['fatigue']}疲劳；CD{s['cd']}；距离{s['range']}格；变更类型：{s['change']}。",'**建议效果**：'+s['text'],
                  '**11级**：'+s['mastery']+(f"；最终疲劳费用{s['mastery_fatigue']}。" if s['active'] and s['fatigue'] else '。'),
                  '**当前原文**：'+s['current_text']]
lines += ['## 阿飞：互斥路线',P['route_unlock']]
for r in P['routes']:lines += [f"### {r['name']} `{r['id']}`",'常驻：'+r['passive'],f"主动：{r['ap']}AP／{r['fatigue']}疲劳／CD{r['cd']}。{r['effect']}。",'经济：'+r['economy']+'。','路线不采用普通成员11级精通；号令命中加成计入Mod+10上限。实际合同额外收入必须先扣除号令施放花费后评价净收益。']
lines += ['## 阿飞：电子烟',P['accessories'][0]['current'],f"**新提案**：4AP／10疲劳／CD2。{P['accessories'][0]['text']}",
'## 技能验收的公共边界','每项至少验证：条件成立和不成立、95%与5%命中封顶、地形与遮挡、被定身、死亡/逃跑、回合开始/结束、同名覆盖、不同技能叠加、主动等待、战斗存读档、换装、结算取消。经济技能另外核验交易失败、部分购买、退款和真实结算ID。以上是待实装后的验收清单，当前文本完整不代表脚本已通过这些用例。']
write('技能总表.md',lines)

lines=['# 离线验证结果与验收边界',
'本报告由 `tools/balance_v1_validate.py` 与 `tools/balance_v1_render.py` 自动生成。输入是 `proposal.json`，现行对照是 `current-roster.json`。**下列已通过均指离线检查，不是实机胜率或已证明整体平衡。**',
'## 1. 结构与来源检查',table(['检查','结果'],[[x['name'],'通过' if x['passed'] else '失败'] for x in V['checks']]),
f"原版伤害独立核对 **{V['native_damage_oracle']['cases']}组通过**。测试直接运行本机原版 `actor.onDamageReceived` 的伤害结算片段，再与Python模型结果比较；原片段SHA256：`{V['native_damage_oracle']['fragment_sha256']}`。覆盖护甲0/40/100/300、穿透0/20%/50%/100%、轻装血伤乘数、战铸甲伤乘数、头部倍率、伤害总乘数和最小伤害。未执行完整AI、场景和所有技能钩子。",
'## 2. 成长分布',
'34人每人严格30项升级选择；每项最多10次。对固定分配，以每次原版离散掷点的精确卷积计算P10/P50/P90，不是蒙特卡洛估计。不模拟玩家每级看点后择优，因此不能当成最优培养上界。以下含个人成长选项一，不含路线、小龟体质、装备及专长。',
table(['人物','生命均值','决心均值','主攻均值','近防均值','一级可用疲劳'],[[p['name'],PR[p['key']]['base_means'][0],PR[p['key']]['base_means'][2],PR[p['key']]['primary_attack'],PR[p['key']]['base_means'][6],PR[p['key']]['join_usable_fatigue']] for p in P['people']]),
'## 3. 练习靶试验',
'固定随机种子9292026；4种武器×3种靶子×4000次，共48,000次。统一最终命中65%、头部命中25%；正常头部伤害1.5倍、独立血伤/甲伤随机掷点。中甲靶80生命/150身甲/105头甲；轻装靶90生命/95/105，血伤乘0.4；战铸靶80生命/300/300，甲伤倍率随剩余总甲变化。挥空也计一次攻击。武装剑持盾，不加空副手25%伤害。',
table(['武器','靶子','平均攻击尝试','均值标准误','中位','P90','AP理想轮数','未击杀截断'],[[x['weapon'],x['target'],f"{x['mean_attempts']:.3f}",f"{x['mean_se']:.3f}",x['median_attempts'],x['p90_attempts'],f"{x['mean_turns_ap_only']:.3f}",x['censored']] for x in V['combat_probes']]),
'**局限**：'+V['combat_assumptions']['limits']+'。两手锤与持盾剑的AP节奏不同；这里不能得出通用强弱或实战胜率。均值标准误只描述抽样波动，不包括模型遗漏。单体锤击+20伤害来自原版招式；额外破甲在普通命中结算后扣同部位剩甲，无血伤溢出。',
'提案握把在这三种靶子上均保留优势，但重甲优势最大。实装验收仍需测具备技能的角色、横扫排除、临时伤害倍率、地形、敌人反击、断盾与真实疲劳；这些不能从本表推断。',
'电子烟8轮理论回血总量：现行最多160，提案最多30；前提是每次使用都缺足够生命且可支付费用，不是30点必定有效生命，也不是存活率。',
'## 4. 招募节奏压力测试',
'这是把门槛除以假定推进速率的静态压力测试，不是跑了120日的游戏。忽略路程分布、失利、伤亡、候选排队、钱不够与XP分摊。第60日/63日/98日意味着全部有资格，不表示全部已招到。',
table(['假设玩家','参战/日','履约/日','新城镇/日','最高等级增长/日','全部资格日','10/20/30/45/60/90/120日资格人数'],[[x['profile']]+[f'{a:.3f}' for a in x['rates']]+[x['all_eligible_day'],'／'.join(str(x['eligible_counts'][str(d)]) for d in [10,20,30,45,60,90,120])] for x in V['pacing']]),
'## 5. 经济账与概率',
'工资按成员独立一级日薪及等级倍率计算，表中保留小数后汇总，游戏逐人取整可能造成小额差异。食品每人每日2单位、3克朗/单位；维修/药品/弹药均为假设预算。日收入指已扣卖出折损、契约交易相关费用后的入账款，不是商品基础价值。',
table(['队伍','人数','级别','工资/日','食品/日','修/药/弹','日维持费','再投资/日','需日入账','7日维持储备'],[[x['team'],x['count'],x['level'],round(x['wages'],2),x['food'],f"{x['repair']}/{x['medicine']}/{x['ammo']}",round(x['upkeep'],2),x['reinvest'],round(x['minimum_daily_gross'],2),round(x['seven_day_reserve'],2)] for x in V['economy']]),
f"全31位收费成员按规划补级上限全部购买，基准合计 **{sum(p['suggested_price'] for p in P['people']):,}克朗**，还不包括城镇修正、终局装备、训练与运营支出。该总价不是最低初期所需资本。",
'独立5%补货：平均20次、中位14次、P90为45次；20/40/60次至少出现一次分别64.15%/87.15%/95.39%。两店各一次至少出现一次9.75%。概率依据是现行商店入口，独立模型忽略库存抑制；不存在第20次必出的保证。',
'## 6. 尚未完成的验证',
'\n'.join('- '+x for x in V['required_playtests']),
'额外高风险组合：阿飞路线＋电子烟＋轻装；小龟体质＋轻装/坚定不移；恢复/减耗三人循环；多辅助保护同一盾卫；群体号令＋单体命中被动；复制/借用招式触发老马握把；交易优惠与契约收入同时开。每组要保存技能消耗、每轮收益及最终现金轨迹。',
'实机记录表字段：游戏/Mod版本、种子、难度、日期、敌军、地形、阵容/等级/完整装备/技能、战斗轮数、伤亡、技能施放次数、有效伤害/治疗/疲劳恢复、修药弹消耗、现金前后值、异常日志。空白表示未采集，不能填0伪装为实测。',
'## 7. 重算与审计',
'在项目根目录运行（只生成设计与缓存，不修改游戏包）：\n\n```powershell\npython tools/balance_v1_snapshot.py\npython tools/balance_v1_design.py\npython tools/balance_v1_skills.py\npython tools/balance_v1_validate.py\npython tools/balance_v1_render.py\n```',
'快照工具依赖本机合法安装的游戏资源与已有Squirrel工具链；路径见脚本。调设计参数优先修改 `balance_v1_design.py` / `balance_v1_skills.py`，再运行后四步；否则重生成会覆盖对JSON的手改。工作簿可独立做假设分析，但其编辑不会自动回写JSON或Mod，需要手动同步后重新验算。工作簿生成器另见 `tools/build_balance_v1_workbook.mjs`。',
'可验收的结论：名单完整、成本和成长口径一致、本模型伤害计算与原版片段匹配、静态预算没有明显无穷供能。不可验收的结论：每个人在所有敌军中等强、全部技能代码正确、三种难度已完成通关、玩家喜欢每一分支。']
write('验证结果.md',lines)
write('README.md',['# 阿飞远征团全人物平衡设计 V1','先读[总方案](总方案.md)，修改数值使用[可编辑工作簿](全人物数值与招募总表.xlsx)。','完整内容：[角色手册](角色手册.md) · [技能总表](技能总表.md) · [研究依据](研究与设计依据.md) · [验证结果](验证结果.md)。','2026-09-29；设计和离线核验已完成，未实装；实机平衡待验收。书籍取得范围为公开简介、目录、样章及作者课程，未声称读完四本全文。'])
print('Rendered 34 profiles, 99 skills, 3 routes, accessory, validation report and index.')
