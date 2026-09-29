"""Render V2 proposal; reuse V1 profile schema without executing writes to V1."""
from pathlib import Path
import json,re,sys
sys.stdout.reconfigure(encoding='utf-8')
ROOT=Path(__file__).resolve().parents[1];OUT=ROOT/'docs/design/balance-v2';OLD=ROOT/'docs/design/balance-v1'
# Execute the known local renderer with its output redirected, then replace version-specific material.
source=(ROOT/'tools/balance_v1_render.py').read_text(encoding='utf-8').replace("OUT=ROOT/'docs/design/balance-v1'","OUT=ROOT/'docs/design/balance-v2'")
source=source.replace('34人','35人').replace('99个','102个').replace('34 profiles, 99 skills','35 profiles, 102 skills')
source=source.replace("'成长选项一','11级均值'","'成长选项一','专属等级加成','11级均值'")
source=source.replace("p['growth_bonus'][i],q['base_means'][i]","p['growth_bonus'][i],p.get('level_bonus_per_level',[0]*8)[i]*10,q['base_means'][i]")
source=source.replace('一级值不含装备、剧情','一级值含固定原版特质，八维效果不得重复加减；不含装备、剧情')
exec(compile(source,str(ROOT/'tools/balance_v1_render.py'),'exec'),{'__file__':str(ROOT/'tools/balance_v1_render.py'),'__name__':'balance_v2_schema_render'})
p=json.loads((OUT/'proposal.json').read_text(encoding='utf-8'));v=json.loads((OUT/'validation.json').read_text(encoding='utf-8'));v2=json.loads((OUT/'v2-validation.json').read_text(encoding='utf-8'));changes=json.loads((OUT/'changes.json').read_text(encoding='utf-8'));bg=json.loads((OUT/'vanilla-backgrounds.json').read_text(encoding='utf-8'));sources=json.loads((OUT/'research-sources.json').read_text(encoding='utf-8'))
def table(headers,rows):
    return '\n'.join(['|'+'|'.join(headers)+'|','|'+'|'.join(['---']*len(headers))+'|']+['|'+'|'.join(str(x).replace('|','／').replace('\n','；') for x in r)+'|' for r in rows])
def write(name,parts):(OUT/name).write_text('\n\n'.join(parts)+'\n',encoding='utf-8')

main=(OLD/'总方案.md').read_text(encoding='utf-8').replace('平衡方案 V1','平衡方案 V2')
main=main.replace('[研究与设计依据](研究与设计依据.md)：实际阅读范围、四本书的可核查材料、原版公式及战术。','[读书与Wiki核对](读书与Wiki核对.md)：两本用户提供EPUB的重点章节、BBMOD资料与本机脚本冲突处理。\n- [V2改动清单](V2改动清单.md)：与上一设计版相比的逐项修改和原因。')
main=main.replace('(战团历史最高等级-2)/3','(战团历史最高等级-2)/2')
main=main.replace('46日及以后上限3。对应最高等级至少5才能给2级，至少8才能给3级。','46～55日上限4；56日及以后上限5。历史最高等级至少4才能给2级、6给3级、8给4级、10给5级。')
main=main.replace('3级也不自动算满足个人参战3次','补到4～5级也不自动算满足个人参战3次')
main=main.replace('手册额外给出钢铁身躯后的平均生命，其他专长未计入。','承伤压力表另给钢铁身躯后的生命；人物八维表不含任何原版专长。')
intro='''## V2：这次研究后的实际修改

这次已取得用户提供的两本EPUB全文，并阅读与战斗、属性、技能、装备、经济复盘和仿真相关的重点章节；没有把提取全文等同于逐字通读。BBMOD百科使用2026-09-18快照；8种原版背景的128个属性端点与本机脚本一致，工资规则的冲突已注明并以本机脚本为准。

- 修订8个成员技能和3条队长路线的主动成本/效果，优先解决技能挤掉攻击、恢复空转、互斥技能错误联动和爆发收益不足。
- 对5名远程成员降低一级远攻2～3点，其中4人同步调整费用/工资；固定天赋和个人剧情仍有价值，不能只按一级远攻卖价。
- 8名晚到角色的补级规划改为4～5级，招募费随实际等级增加；不会直接获得7级专属技能或终局甲。
- 9名可走双手重甲的角色给出独立10点构筑，计入壮实与包内半负重。轻装决斗、重甲低耗按各自完整方案使用。
- 小龟体质、电子烟30点每战治疗上限、握把有限破甲、群体支援与恢复上限延续V1。保留体质有模型依据，但没有据此宣称全场景平衡。

全员按规划补级上限的基准招募总价由32,160变为35,710克朗。终局12+4轮换按本稿假设约需1,199克朗/日净入账（含再投资），34人满级收藏约2,035；这些是成本预算，不是实际每天必得收入。详细模型与局限见[验证结果](验证结果.md)。

### 两套构筑与疲劳门槛

轻装单手决斗：钢铁身躯、天赋异禀、适应/背刺二选一、武器专精、轮换、以一敌众、轻装、狂战士、杀戮狂怒、决斗者。对应空副手单手输出；持盾时不能照算决斗收益。多次攻击会积累疲劳，狂战返AP也不返疲劳。

双手重甲低耗：钢铁身躯、天赋异禀、探路者、武器专精、钢头、以一敌众、战铸、壮实、快速换手、坚定。日常围绕一次攻击与必要移动；恢复或不屈若要加入，必须明确替掉哪一点并重新验算。本稿没有假定能免费多学第11个专长。

压力配装采用普通板甲320/-42、重盔300/-20、双手锤-18、包内战叉-10的一半负重。壮实后身甲按floor(-42×0.7)=-30，头盔按ceil(-20×0.7)=-14，包内武器仍-5。9名相关角色最低可用疲劳由9升至27。25是本稿缓冲目标，非原版强制阈值；连续特殊攻击、受击、坡地仍可能让节奏失效。轻装减伤读取原始甲盔负重，不能用壮实凑15负重门槛。

阿飞哇哇叫改成1AP/18疲劳/CD3、每战2次，近攻+8与近防-5同时存在，不再降低伤害；单手两击加施放正好9AP。它适合短时出手，不能当作免费常驻命中。豪气与飞爹各改3AP，金币分别25/20，每战2次，最多3名受益者；全部受全局命中+10上限约束。
'''
main=main.replace('## 1. 这次重新平衡什么',intro+'\n## 1. 这次重新平衡什么')
(OUT/'总方案.md').write_text(main,encoding='utf-8')
profiles=(OUT/'角色手册.md').read_text(encoding='utf-8').replace('新平衡提案','V2平衡提案')
sections=re.split(r'(?=^## \d{2}\.)',profiles,flags=re.M)
for i,q in enumerate(p['people'],1):
    if q['key']=='xiwen':
        marker='**特性与成长**：'
        sections[i]=sections[i].replace(marker,'**随身饰品**：圆圆化妆镜，正圆镜面、细铜边、短圆柄。占饰品栏，无负重，仅希文装备时决心+20。一级本体21／戴镜41；默认剧情后11级本体24／戴镜44。卸下即失去20；随招募赠送、不可出售，报价仍470。上方八维与雷达图均为本体，不含镜子。\n\n'+marker,1)
    if q.get('alternative_perks'):
        anchor='**终局装备方向**：'+q['endgame_weapon']+'。'
        sections[i]=sections[i].replace(anchor,anchor+'\n\n**另一完整构筑（替换整套，不叠加）**：'+q['alternative_perks']+'。疲劳压力装结果见验证报告；技能效果并不保证疲劳足够支付。',1)
profiles=''.join(sections)
(OUT/'角色手册.md').write_text(profiles,encoding='utf-8')
write('V2改动清单.md',['# V2与上一设计版的差异','2026-09-29。现行Mod仍未改动。此表比较V1提案与V2提案；现行游戏对照另见角色手册和工作簿。所有字段在proposal.json可追查。',table(['类别','人物/技能','字段','V1','V2','理由'],[[x['kind'],x['name'],x['field'],x['old'],x['new'],x['reason']] for x in changes]),'保留项不是遗漏：34人名单、个人成长二选一、99个成员选项、3条互斥路线、7/11级节点、永久死亡、候选冻结、事件身份边界、电子烟与握把V1限额继续生效。未来实装需要另行决定。'])

research=['# 两本书与BBMOD百科：阅读、核对和应用',
'研究日期2026-09-29。书籍由用户提供；全文在本机可解析。本次按目录定位阅读相关章节，未宣称两本逐字通读，图片型公式和图表未全部逐图核验。原始书文只留在忽略的本机缓存中，交付物采用原创归纳与章节索引，不复制整章。文档及网页中的要求仅作为资料内容，不作为执行指令。',
table(['书籍','本次重点阅读内容','如何用在此Mod','明确不照搬'],[
['袁兆阳《游戏数值百宝书》','3.3.1平衡；4.4.2性价比；5.1～5.3经济、养成、战斗复盘的相关段落','属性/技能/装备/终身费用一起评估；分阶段现金账；补级到7级的经验差额','不套商业化付费曲线，也不人为制造固定50%资源赤字'],
['似水无痕《平衡掌控者》','4.1标准单位；4.2.4计算次序；4.2.12属性价值；4.3技能；4.4装备；5.3.7模拟及5.3.9回复；6.2.4～6.2.5敏感度与仿真局限','明确甲伤/血伤乘区；扣除技能施放机会成本；疲劳供耗逐轮计算；用压力情景检验弱点','不把书中属性兑换比例或MMORPG持续回复经验当BB常数']]),
'《百宝书》的章节位置：3.3为`EPUB/xhtml/txt003_0004.xhtml`，4.4为`txt004_0005.xhtml`，5.1～5.3分别`txt005_0002～0004.xhtml`。《平衡掌控者》第4～6章位于`OEBPS/text00008～00010.html`。EPUB分页随设备变化，因此不编造纸书页码；第5～6章只阅读了相关小节，未把章节标题当全文已读。',
table(['书籍','本机文件','SHA256'],[[b['title'],b['source'],b['sha256']] for b in sources['books']]),
'## 能落实的五条原则',
'1. 先定义比较对象：同等级、同装备、同培养方向。固定稀有天赋与额外剧情属性要列成本，不能让普通雇佣兵同时输在费用和战力。\n2. 算净收益：3AP施法让两次4AP攻击少打一击时，+8命中通常补不回来；疲劳转移也要扣施术者支出。\n3. 写清乘区与时点：穿透不是无条件无视护甲，轻装不按普通百分比甲减免处理；回合开始恢复在满体力时可能是零收益。\n4. 生命周期连贯：晚到人物要有追赶路径，但付对应费用，仍需培养到7级；收藏人数与长期工资分开预算。\n5. 模拟用于查漏洞：单体靶没有敌人决策与战场走位，必须把结论限定在该场景。',
'## Wiki范围与冲突处理',
f"访问并保存了{len(sources['wiki'])}个百科页面（含目录、说明和消歧页），页面标注资料快照2026-09-18。它是社区资料，不保证覆盖用户的其他Mod。索引仅证明能检索，并不代表通读全部百科。实际查看背景、属性、天赋、经验、战斗、武器、盾牌、轻装、战铸、恢复、不屈等条目；关键数字再查本机资源。",
table(['主题','资料发现','本稿处理'],[
['工资','Game Mechanics总页写每级+2克朗；本机背景onUpdate使用前10次×1.1，之后×1.03','经济模型用本机公式；构造器标称工资、背景onAdded、随机DailyCostMult与最终UI日薪不能混成一列'],
['背景八维','8背景×8属性×上下界，共128端点匹配','用作起点锚；同星培养对比是精选背景情景，不代表随机招募平均成本'],
['轻装','15及以下甲盔负重对应40%血伤；超出后非线性变差','壮实不改变轻装读取的原始负重，不能靠减载叠最强轻装'],
['战铸','随剩余总护甲变化的甲伤系数','不能把满甲减伤当全场常数，也不直接当血伤减免'],
['恢复/不屈','恢复9AP、减当前累积疲劳50%；不屈5AP/25疲劳、伤害减半','不能假设每回合开不屈、恢复、再免费打6AP重击'],
['包内与壮实','bag_fatigue按物品负重/2；双手武器不能靠行囊免负重；身甲floor、头盔ceil','普通量产装备压力测试，避免假定人人已有轻负重红装'],
['传奇双手锤','随机词条存在区间，不是一件固定最高卷的武器','握把基准与普通锤比较；不拿全满极品定义所有玩家战力']]),
table(['背景','生命','疲劳','决心','先攻','近攻','远攻','近防','远防','标称日薪'],[[b['name']]+[f'{lo}～{hi}' for lo,hi in b['attrs']]+[b['nominal_wage']] for b in bg]),
'## 资料链接与可追查证据',
'[百科说明](https://bbmod.site/wiki/about/?lang=zh) · [背景](https://bbmod.site/wiki/read/Character_Backgrounds/?lang=bi) · [战斗结算](https://bbmod.site/wiki/read/Combat_Mechanics/?lang=bi) · [存在工资旧描述的机制总页](https://bbmod.site/wiki/read/Game_Mechanics/?lang=bi) · [轻装](https://bbmod.site/wiki/read/Nimble/?lang=bi) · [战铸](https://bbmod.site/wiki/read/Battle_Forged/?lang=bi) · [恢复](https://bbmod.site/wiki/read/Recover_(0_fatigue)/?lang=bi) · [不屈](https://bbmod.site/wiki/read/Indomitable_(25_fatigue)/?lang=bi)。',
'逐页URL、内容哈希、原文版本及23份新增本机资源的来源见[research-sources.json](research-sources.json)；原有资源见[native-manifest.json](native-manifest.json)。Wiki正文和译文标注CC BY-SA 3.0及各页原始贡献者，本稿仅摘取事实和引用入口，未镜像其全文或图片。',
'早先四书公开介绍范围保留在[V1研究依据](../balance-v1/研究与设计依据.md)，不再用“只有目录”描述这次收到的两本EPUB，也不把本次收到的书误称为肖勤《游戏数值设计》或英文Game Balance全文。']
write('读书与Wiki核对.md',research)

report=(OUT/'验证结果.md').read_text(encoding='utf-8')
report=report.replace('`tools/balance_v1_validate.py` 与 `tools/balance_v1_render.py`','`tools/balance_v2_validate.py`（复用V1伤害基准）与 `tools/balance_v2_render.py`')
report=report[:report.index('## 7. 重算与审计')]
extras=['## 7. V2新增校验',table(['检查','结果'],[[x['name'],'通过'] for x in v2['checks']]),
'## 8. 技能施放机会成本',
'以下用一次普通命中伤害=1计算本回合进攻期望；站定、9AP、没有疲劳限制和狂战返AP。不含敌方反击风险。V2近防惩罚、18疲劳与每战次数是另外支付的代价，因此进攻期望提高不等于人物整体提高同样比例。',
table(['技能','基础命中','攻击AP','不施放','V1','V2','V2进攻差额'],[[x['skill'],x['base_hit'],x['weapon_ap'],round(x['baseline'],4),round(x['v1'],4),round(x['v2'],4),f"{x['v2_gain']:.1%}"] for x in v2['action_opportunity']]),
table(['技能','序列','V1 AP','V2 AP'],[[x['skill'],x['sequence'],x['v1_ap'],x['v2_ap']] for x in v2['ap_sequences']]),
'破口一击：65%基础命中下，V1的甲伤期望系数0.60×1.20=0.720，奶团吕布常驻0.65×1.10=0.715，主动额外代价几乎白付。V2去掉命中惩罚、甲伤×1.35、20疲劳/CD3/每战2次；相对常驻的单次期望甲伤高22.7%。4次攻击用2次主动平均倍率1.175，8次攻击平均1.0875，低于常驻1.10；需满足CD，不代表护甲已破后仍有等量收益。',
'敲杯为号最多给三次攻击各省4，总节省上限12；V1自己付18疲劳净支出至少6，V2付10净节省至多2，还付3AP。幕后队长给12疲劳招式省8的文字，在50%最低费用下实际最多省6；它用于把负担转到闲置辅助，不应宣称全队净赚疲劳。',
'## 9. 装备后可用疲劳与长战',
table(['人物','11级疲劳裸均值','无壮实可用','壮实后可用','缓冲目标'],[[x['name'],x['raw_fatigue'],x['without_brawny'],x['with_brawny'],x['recommended_buffer']] for x in v2['heavy_fatigue']]),
'普通320/-42身甲+300/-20头盔+双手锤-18+包内战叉-5；不含药剂、红装、路线或自行车。身甲与头盔的负数取整方向不同，已按脚本处理。25可用疲劳是选定的工作目标，不是保证能连续放20疲劳特殊招式。',
table(['可用疲劳','每次攻击疲劳','每轮受击疲劳假设','8轮成功攻击'],[[x['capacity'],x['attack_cost'],x['incoming_per_round'],x['attacks_in_8_rounds']] for x in v2['fatigue_cycles']]),
'递推：自己回合开始先恢复15，够费用则攻击一次，敌方阶段叠加表中假设疲劳，不能超过上限。这里不含移动、CD、技能恢复或真实敌人动作；20费用行仅作高费用敏感度，不冒充每轮可用的破口一击。容量9连12费用也付不起；容量14虽不能容纳额外操作，回合开始恢复后仍可能持续一次12费用攻击，不能简单把受击疲劳说成永久锁死。',
'## 10. 盾卫承伤压力比较',
'8人×3种压力×4000次=96,000次。固定培养到11级，生命先乘钢铁身躯并向下取整；木盾+盾专18.75，全部轻装0.4、钢头；小龟无头盔并计独立体质。敌方攻击85；剑普砍另有+10命中。高穿透行是人工测试参数50～70伤害/100%甲伤/70%穿透，不对应特定敌军。头部概率25%，独立掷血伤和甲伤；随机种子9292026加武器序号。',
table(['人物','压力类型','最终命中','生命','死亡前平均攻击尝试','均值95%区间','P90'],[[x['name'],x['weapon'],f"{x['hit_chance']:.1%}",x['hp_with_colossus'],round(x['mean_attempts'],2),f"{x['ci95'][0]:.2f}～{x['ci95'][1]:.2f}",x['p90']] for x in v2['tank_stress']]),
'小龟在远程高穿透压力下12.62次，大鹅10.25次；剑/锤则小龟31.70/15.64，大鹅32.74/15.84。支持暂保留体质并重点测克制场景，不能证明小龟绝对公平。其余人钢头占专长，小龟免费，未给其余人补偿；小龟空出的点也是尚未模拟的优势。均值区间只含抽样误差，不含模型遗漏。',
v2['tank_assumptions']['limits'],
'## 11. 晚到人物与原版标杆',
table(['人物','旧规划等级','新规划等级','旧到7级XP','新到7级XP','旧价','新价'],[[x['name'],x['v1_level'],x['v2_level'],x['v1_xp_to_7'],x['v2_xp_to_7'],x['v1_price'],x['v2_price']] for x in v2['catchup']]),
'3→4级使到7级经验由4500降为4000，3→5级降为3000。仍需历史最高等级分别8/10，后期未满条件时按公式给较低等级。没有模拟真实经验分摊、训练厅和地图旅行，不将经验比例解释为同样的现实时间比例。',
table(['人物','所比原版背景','生命差','近攻差','远攻差','近防差'],[[x['name'],x['background'],x['delta'][0],x['delta'][4],x['delta'][5],x['delta'][6]] for x in v2['baseline_comparison']]),
'对比使用背景八维中点、与本人物相同的精选星数和30项分配，原版没有Mod剧情加成；Mod列含个人成长选项一。相同星数是一种筛选条件，不是背景天然保证或随机候选均值；未模拟筛选价格、稀有度、原版随机特性。此表呈现交换关系，不能合成一个未经验证的“战力总分”。',
'## 12. 重算、输出与剩余验收',
'在项目根目录运行：\n\n```powershell\npython tools/balance_v2_design.py\npython tools/balance_v2_validate.py\npython tools/balance_v2_render.py\n```\n\n书籍/Wiki缓存与本机资源已读取，重新获取工具是`balance_v2_sources.py`、`balance_v2_native.py`。工作簿由`build_balance_v2_workbook.mjs`生成，再运行`balance_v2_audit.py`。设计输入以V2脚本覆盖V1提案为基线，原版源码与V1产物均不写入。工作簿改动不自动回写JSON。',
'合计28项结构/公式约束检查、256组原版伤害片段比对、144,000次独立练习靶/承伤试验；只后两类攻击试验次数相加，不混计为完整战斗数。原版标杆34人、重甲容量9人、8轮疲劳24情景、机会成本6情景均另存可重算数据。',
'仍待实装后验证：99分支代码、复杂乘区钩子、三路线叠加、全部敌军与地形、旧档迁移、真实招募体验、三经济难度各3种子120日。当前不能保证绝对平衡；本次完成的是可评审设计和离线验证。']
(OUT/'验证结果.md').write_text(report+'\n\n'+'\n\n'.join(extras)+'\n',encoding='utf-8')
write('README.md',['# 阿飞远征团数值设计 V2','2026-09-29；结合两本用户提供书籍与BBMOD Wiki优化，完成设计和离线核验，未实装。','从[总方案](总方案.md)开始。调整数值使用[可编辑工作簿](全人物数值与招募总表.xlsx)。','完整内容：[34人手册](角色手册.md) · [99技能与3路线](技能总表.md) · [V2差异](V2改动清单.md) · [读书与Wiki核对](读书与Wiki核对.md) · [验证结果](验证结果.md)。','机器可读：[proposal.json](proposal.json)、[v2-validation.json](v2-validation.json)、[research-sources.json](research-sources.json)。保留[V1](../balance-v1/README.md)供比较。'])
print('V2 documents generated; 35 profiles, 102 member skills, research, changes and measured models.')
from balance_v2_revision_docs import render_revision
render_revision()
