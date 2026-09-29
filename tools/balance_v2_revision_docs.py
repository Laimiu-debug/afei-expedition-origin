"""Render the authorized V2.1 changes and anonymized feedback interpretation."""
from pathlib import Path
import json
ROOT=Path(__file__).resolve().parents[1];OUT=ROOT/'docs/design/balance-v2'
def read(n):return json.loads((OUT/n).read_text(encoding='utf-8'))
def table(head,rows):return '\n'.join(['|'+'|'.join(head)+'|','|'+'|'.join(['---']*len(head))+'|']+['|'+'|'.join(str(x).replace('|','／').replace('\n','；') for x in r)+'|' for r in rows])
def render_revision():
 p=read('proposal.json');t=read('trait-design.json');e=read('feedback-evidence.json');v=read('validation.json');v2=read('v2-validation.json')
 definitions=t['definitions'];q=next(q for q in p['people'] if q['key']=='xiwen');a=next(x for x in v['projection'] if x['key']=='afei')
 parts=['# V2.1：希文、阿飞耐力与人物特质','2026-09-29。仅设计，未改游戏运行脚本。此前希文/里根分支已合并，DLC仍是独立可选包。',
 '## 数值口径',p['trait_accounting'],'本次不使用网站属性均值、星数或强度评分。除阿飞新增队长等级耐力外，原34人的基础八维、星数、30项升级分配、剧情奖励保持原表。希文按用户新增要求将决心拆为本体21、化妆镜20，戴镜后的一级41与原表一致；其他一级八维保留。',
 '## 阿飞：远征耐力','2～11级每升一级，固定增加3点疲劳上限；11级累计30，之后不再增加。独立于30项选点、剧情二选一、三路线、自行车和原版固定特质。读档、补级和重复升级回调按当前等级计算总额，不逐次叠写，避免重复领取。',
 table(['等级','1','3','5','7','9','11'],[['裸疲劳上限',94,100,106,112,118,124]]),
 f"11级基础与培养疲劳94 + 专属成长30 = **{a['base_means'][1]:g}**。现有入队配装负重20，11级同配装可用104；普通320/-42身甲、300/-20头盔、锤-18、包内-5时可用39，带壮实按原版取整后可用57。以上未计自行车分支+5、临时技能和药物。",
 '## 希文：从短途同行到稳定支援',p['xiwen_recruitment'],
 table(['节点','行为','预算与限制'],[
 ['第6日起','门槛同时满足后进入正常候选池','不是第6天强制出现。现行DLC仍是1城、280克朗；设计门槛未实装。'],
 ['入队','1级；短剑、圆盾、厚布衣、圆圆化妆镜','服务费180+计价装备470×0.6=462，进十位为470；一级日薪9；镜子随身赠送，不另收费。'],
 ['3级且本人参战3次','看清再开口 / 亲自走一程，永久二选一','分支一决心+3、近防+1；分支二先攻+3、疲劳上限+2，不能累计。'],
 ['7级技能书','看清破绽 / 同行照应 / 行路留力，三选一','视为专属技能选择凭据，绑定希文，不出售、不交易、不占普通10点专长；选后锁定。'],
 ['11级精通','只强化已选分支','不解锁第二本；现有角色达到节点但未选择时补发选择机会，不能重复领。']]),
 '技能书名称分别为《识隙札记》《同行守则》《长路笔记》。三本是同一个7级选择节点的表现形式，不是能全收集的消耗品。',
 table(['技能书','7级技能','效果','11级'],[[book,s['name'],s['text'],s['mastery']] for book,s in zip(['《识隙札记》','《同行守则》','《长路笔记》'],[x for x in p['skills'] if x['owner']=='xiwen'])]),
 '看清破绽检验未命中触发次数与目标失效；同行照应检验失盾、距离、倒地提前终止及临时护卫取最高；行路留力检验首回合、强制位移、甲盔15负重边界与恢复封顶。现阶段为技能契约，尚无可运行实现。三个图标暂用原版反击、盾墙和探路者，并在图标来源表标注。',
 '## 希文的圆圆化妆镜',
 p['items']['accessories/xiwen_round_mirror']['appearance']+'。'+p['items']['accessories/xiwen_round_mirror']['flavor'],
 next(x['text'] for x in p['accessories'] if x['key']=='xiwen_round_mirror'),
 table(['状态','一级本体','饰品加成','一级戴镜','默认剧情后本体（11级）','默认剧情后戴镜（11级）'],[['决心',21,20,41,24,44]]),
 '镜子提供的是装备属性，不是永久特质或一次性使用奖励。卸下立即少20，重新装备恢复20，不叠加；不提升士气等级、不额外增加决心成长或占用升级选点。若选第二条剧情，则本体仍21、戴镜41。当前30项分配没有投入决心，后续若自行加点则照常增长。',
 '饰品栏由镜子占用，换成项链、战犬等饰品时要承担低本体决心。招募总价仍470，镜子计价与出售价值为0，避免通过重复获取刷钱。首次随人物生成一件，存读档、重新雇佣同一人物或换装不能复制。工作簿“属性成长/成长总览”主表显示本体，“装备明细/成长总览”右侧另列饰品与戴镜值；把饰品加成设为0可查看换下结果。',
 '## 全人物固定特质',
 '每人2项固定原版特质，保留原来的剧情二选一；不额外随机抽取。阿飞远征耐力、小龟无头盔体质另算。特质有真实效果，固定八维采用反推基础避免改变原表；经验、士气、伤害倍率、恢复、事件等条件机制仍生效，尚未纳入所有离线战斗模型。',
 '例如阿飞“自负”为决心+5、近防-5、远防-5，表列一级38/3/2已经包含这些效果，实装初始字段应为33/8/7，再由特质加回到38/3/2。小龟“肥胖”的生命+10、疲劳-10同理，不把原表数值再加减一次。',
 table(['人物','固定特质','效果','含特质反馈数','选中票数','依据'],[[x['name'],'、'.join(definitions[k]['name'] for k in x['traits']),x['effects'],x['trait_respondents'],' / '.join(map(str,x['selected_votes'])),x['reason']] for x in t['people']]),
 '## 线上玩法反馈的采用范围',
 f"来源：[sdhaohan.cn](https://sdhaohan.cn/#member=afei)。快照时间：{e['fetched_at']}；当前基线`{e['baseline']}`。通过已验证SSH连接对线上数据库做只读一致性查询，全量取得65条人物反馈、4条建议，排除旧版/退役条目{e['excluded_old_or_retired']}条，无分页截断。39个Cookie参与标识不等于39名已核验真人。4条建议的完整正文规范化后无完全重复，但3条同属组合/阵营互动主题；不把主题相近当成独立确认同一机制。",
 e['limits'],
 table(['主题','反馈覆盖','本次处理','阶段'],[[x['topic'],x['evidence'],x['decision'],x['priority']] for x in e['themes']]),
 '阿飞自负16票/25份含特质反馈（29份人物反馈），可作为相对清楚的角色线索；鹰眼与近视同为5票且原版互斥，不打包加入。其余人物尤其1～2票样本不能称为稳定共识。无票人物按已有V2定位补全；“设计补全”不会被写成玩家共识。',
 '原版互斥表逐对检查：35组均无冲突。网站允许填写的候选不必天然兼容；这里只检查本稿选定的两项，不抹掉原始前三中的并列或分歧。罗一可站点ID luoyike 对应Mod ID xiaohani，希文不在当前投票名单。',
 '## 验证与待实装',
 f"重算35人×8维、35份招募报价、35份30项培养；结构与离线公式约束共{len(v['checks'])+len(v2['checks'])}项通过。原版伤害片段256组，独立练习靶48,000次、盾卫压力96,000次；这些旧模型只验证所描述的属性/伤害机制，未覆盖新增特质的全部条件效果或希文技能，不能等同于真实战斗胜率。",
 '所有特质脚本和图标来源保留文件路径、SHA256与原版互斥字段。工作簿新增“人物特质”，固定八维增减、反推实装基础、剧情特质和队长等级疲劳都可追溯。',
 '重建顺序：`refresh_balance_v2_sources.py` → `balance_v2_revision.py` → `balance_v2_validate.py` → `balance_v2_render.py` → `build_balance_v2_icon_manifest.py` → `build_balance_v2_workbook.mjs` → `audit_balance_v2_refresh.py`。完整从V1种子重建时，`balance_v2_design.py`末尾也会自动执行V2.1修订。工作簿编辑不会自动回写JSON或游戏。']
 (OUT/'V2.1人物与特质.md').write_text('\n\n'.join(parts)+'\n',encoding='utf-8')
 # Correct inherited fixed roster labels in V2-only rendered documents.
 for name in ['总方案.md','README.md','技能总表.md','验证结果.md','V2改动清单.md']:
  path=OUT/name;s=path.read_text(encoding='utf-8').replace('34人','35人').replace('99个','102个').replace('99技能','102技能').replace('99项','102项').replace('99分支','102分支').replace('33位非阿飞','34位非阿飞').replace('33名普通成员','34名普通成员')
  s=s.replace('35,710','36,180').replace('2,035','2,065').replace('合计28项',f"合计{len(v['checks'])+len(v2['checks'])}项")
  s=s.replace('旅途来客2人。','旅途来客2人，另含希文DLC 1人。')
  s=s.replace('一级基础值不含装备','一级基础值已经包含固定原版特质八维效果，不得重复加减；不含装备')
  s=s.replace('新招募主题成员建议取消额外随机改变战斗八维的原版正负特性，保留独立背景、个人剧情成长、故事标签与专属选择。','新招募主题成员固定两项原版特质，八维增减计入表列数值，实装基础按差额反推；不再随机追加特质。保留独立背景、个人剧情成长、故事标签与专属选择。')
  s=s.replace('固定分配只是便于比较；','阿飞另有远征耐力：2～11级每级疲劳上限+3，累计30，11级裸疲劳124；此项不占选点。固定分配只是便于比较；')
  path.write_text(s,encoding='utf-8')
 for name in ['README.md','总方案.md']:
  path=OUT/name;s=path.read_text(encoding='utf-8');heading,rest=s.split('\n',1)
  path.write_text(heading+'\n\n**最新修订：[希文、阿飞耐力与35人特质](V2.1人物与特质.md)。阿飞11级裸疲劳124；希文第6日起470克朗，7级技能书三选一，本体决心21、圆圆化妆镜+20；人物特质已补全。仍为设计，未实装。**\n'+rest,encoding='utf-8')
 path=OUT/'技能总表.md';s=path.read_text(encoding='utf-8');s+='\n## 希文：圆圆化妆镜（被动饰品）\n\n'+next(x['text'] for x in p['accessories'] if x['key']=='xiwen_round_mirror')+'一级本体决心21、戴镜41；默认剧情成长后本体24、戴镜44。饰品不占7级三选一名额，不享受11级精通。\n';path.write_text(s,encoding='utf-8')
 print('V2.1 documents updated; anonymized source coverage and trait accounting included.')
