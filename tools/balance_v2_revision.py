"""Apply the approved V2 design revision; never edit runtime scripts or the site.

Public aggregate evidence is pinned in feedback-evidence.json. Private submissions
are read once from the ignored cache, then only aggregates enter the design set.
"""
from pathlib import Path
from collections import Counter
from zipfile import ZipFile
import copy,hashlib,json,math,re,shutil,subprocess,sys

ROOT=Path(__file__).resolve().parents[1]; OUT=ROOT/'docs/design/balance-v2'; CACHE=ROOT/'.cache/refresh-v2'
def read(path):return json.loads(path.read_text(encoding='utf-8'))
def write(path,value):path.write_text(json.dumps(value,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')

SELECTION={
 'afei':'cocky bright','damou':'strong tough','mocha':'bright ailing','bottle':'sure_footing determined',
 'shuaizi':'bright insecure','lili':'lucky optimist','xiaoyueya':'gluttonous optimist','yuchujiu':'loyal hesitant',
 'xiaoyubeike':'determined loyal','wangduidui':'brave loyal','laocai':'cocky drunkard','yanzi':'loyal teamplayer',
 'tiantong':'eagle_eyes optimist','xiaoning':'eagle_eyes determined','xiaopangxu':'strong iron_jaw','dae':'swift eagle_eyes',
 'manyuemei':'eagle_eyes teamplayer','xiaohani':'athletic teamplayer','keke':'fat huge','yuxiang':'determined iron_lungs',
 'tongzhu':'bright loyal','meiya':'fearless teamplayer','wanshe':'dexterous cocky','tutu':'brave teamplayer',
 'naigai':'cocky night_owl','xiaojie':'tough pessimist','bula':'teamplayer lucky','suwa':'swift athletic',
 'qianhan':'determined athletic','wangdazhi':'sure_footing loyal','yaoyaoya':'strong brute','yangmiemie':'teamplayer survivor',
 'songnuanyang':'quick ailing','xiaogui':'fat loyal','xiwen':'bright athletic',
}
EFFECTS={
 'huge':'近战伤害×1.10；近防-5、远防-5','gluttonous':'每天额外消耗1单位食物；断粮时更容易离队（原版判定）',
 'brave':'决心+5','tough':'生命+10','bright':'经验获取×1.10','determined':'心情至少中立时，以自信士气开战；不永久增加八维',
 'loyal':'较不容易因缺钱、缺粮离队；沿用原版忠诚事件判定，不编造固定概率',
 'eagle_eyes':'视野+1','quick':'先攻+10','athletic':'每格移动疲劳成本-2；仍受实际技能最低成本约束',
 'strong':'疲劳上限+10','optimist':'正向士气检查决心+5；坏心情消退更快',
 'sure_footing':'近防+5','dexterous':'近攻+5','fat':'生命+10、疲劳上限-10','iron_lungs':'每回合疲劳恢复+3',
 'teamplayer':'攻击同阵营目标时近攻/远攻倍率×0.5，减少误伤；不是全队增伤',
 'survivor':'可存活的倒地判定倍率×2.72；斩首等必死情况不因此复活',
 'lucky':'10%机会要求攻击者连续通过两次命中判定；不是固定10%闪避',
 'iron_jaw':'受伤阈值×1.25','cocky':'决心+5、近防-5、远防-5','ailing':'中毒效果多持续1回合',
 'insecure':'无法获得自信士气','hesitant':'先攻-10','drunkard':'伤害×1.10；决心+5、近攻-5、远攻-10；保留原版相关事件风险',
 'swift':'远防+5（Swift；与Quick先攻+10区分）','fearless':'决心+10','night_owl':'夜间视野+1',
 'pessimist':'负向士气检查决心-5；好心情消退更快','brute':'近攻-5；近战命中头部的伤害倍率额外+0.15',
}

def collect_evidence():
 path=OUT/'feedback-evidence.json'
 if path.exists():return read(path)
 d=read(CACHE/'feedback-private.json');c=d['catalog'];active={x['key'] for x in c['characters']}
 rr=[x for x in d['responses'] if x.get('baseline')==c['baseline'] and x.get('member') in active]
 names={t['id']:t['name'] for t in c['traits']}; rows=[]
 for person in c['characters']:
  records=[x for x in rr if x['member']==person['key']];counts=Counter(t for r in records for t in r.get('traits',[]))
  ranked=sorted(counts.items(),key=lambda x:(-x[1],x[0]));cut=ranked[min(2,len(ranked)-1)][1] if ranked else 0
  rows.append({'key':'xiaohani' if person['key']=='luoyike' else person['key'],'site_key':person['key'],'name':person['name'],
    'responses':len(records),'trait_respondents':sum(bool(x.get('traits')) for x in records),
    'votes':dict(ranked),'top3_including_ties':[{'id':t,'name':names[t],'votes':n} for t,n in ranked if n>=cut]})
 normalized=[re.sub(r'\s+','',x.get('detail','')) for x in d['suggestions'] if x.get('detail')]
 out={'source':'https://sdhaohan.cn/#member=afei','fetched_at':d['fetched_at'],'baseline':c['baseline'],
  'collection':'SSH读取线上SQLite一致性只读事务，全部记录，无LIMIT；覆盖等价于人物3页、建议1页；未读取管理员备注与凭据',
  'total_responses':len(d['responses']),'current_responses':len(rr),'suggestions':len(d['suggestions']),
  'cookie_participants':d['participant_count'],'excluded_old_or_retired':len(d['responses'])-len(rr),
  'exact_duplicate_suggestion_texts':len(normalized)-len(set(normalized)),
  'limits':'Cookie标识不等于实名人数；仅阿飞样本较多，其余最多6条。投票只作为特质/玩法线索，不作为数值输入。并列第三全部保留。',
  'trait_catalog':c['traits'],'people':rows,
  'themes':[
   {'topic':'阿飞队长定位','evidence':'29条人物反馈；自负16票。旗手/鼓舞、双手近战、投掷等路线有分歧。','decision':'保留既有三路线与30项培养；采用自负、聪慧；不照搬评分八维。','priority':'本次'},
   {'topic':'小龟盾卫与体型','evidence':'6条人物反馈；肥胖和忠诚各5票。','decision':'选肥胖+忠诚；已有龟壳体质仍单列，禁止把生命/疲劳再加减一次。','priority':'本次'},
   {'topic':'队伍组合互动','evidence':'4条玩法建议中3条提到特定组合或阵营互动；具体触发与奖励各为单条提案。','decision':'保留为待评审玩法池；不自动增加可刷永久八维、免晕饰品或周期奖励。','priority':'后续设计'},
   {'topic':'余初九相关战犬事件','evidence':'1条玩法建议。','decision':'与已有里根区分：若以后采用，须限一次且控制犬只经济；本次只记录候选，不新增犬。','priority':'后续设计'},
   {'topic':'小杰轻甲高血玩法','evidence':'1条完整构筑建议，另有灵活近战定位。','decision':'记录为替代玩法方向；不将提出的高生命数字写进V2。','priority':'后续实测'},
  ]}
 write(path,out);return out

def trait_catalog(p,evidence):
 meta={t['id'].split('.',1)[1]:t for t in evidence['trait_catalog']};keys=sorted({k for v in SELECTION.values() for k in v.split()})
 kit=ROOT/'.cache/afei-art/bbros-modkit-v9/bin';native=[];definitions={}
 folder=OUT/'icons/traits';folder.mkdir(parents=True,exist_ok=True)
 with ZipFile('F:/SteamLibrary/steamapps/common/Battle Brothers/data/data_001.dat') as z:
  for key in keys:
   source_name=f'scripts/skills/traits/{key}_trait.cnut';raw=z.read(source_name);temp=CACHE/'traits'/f'{key}.cnut';temp.parent.mkdir(exist_ok=True)
   temp.write_bytes(raw);subprocess.run([str(kit/'bbsq.exe'),'-d',str(temp)],capture_output=True,check=True)
   result=subprocess.run([str(kit/'nutcracker.exe'),str(temp)],capture_output=True,check=True);source=result.stdout.decode('utf-8')
   icon=re.search(r'this.m.Icon\s*=\s*"([^"]+)"',source)[1];image=folder/f'{key}.png';image.write_bytes(z.read('gfx/'+icon))
   delta=[sum(int(n)*(1 if op=='+' else -1) for op,n in re.findall(r'_properties\.'+f+r'\s*([+-])=\s*(-?\d+);',source)) for f in p['fields']]
   excluded=re.search(r'this.m.Excluded\s*=\s*\[([\s\S]*?)\]',source)
   definitions[key]={'id':'trait.'+key,'name':meta[key]['name'],'effect':EFFECTS[key],'delta':delta,
     'excluded':re.findall(r'"trait\.([^"]+)"',excluded[1]) if excluded else [],
     'icon':image.relative_to(ROOT).as_posix(),'icon_sha256':hashlib.sha256(image.read_bytes()).hexdigest(),
     'native_path':source_name,'native_sha256':hashlib.sha256(raw).hexdigest()}
  # Native icons are intentionally reused as design placeholders; they are not new runtime skills.
  for key,nativepath in [('xiwen_read','scripts/skills/actives/riposte.cnut'),('xiwen_cover','scripts/skills/actives/shieldwall.cnut'),('xiwen_travel','scripts/skills/perks/perk_pathfinder.cnut')]:
   temp=CACHE/(key+'.cnut');raw=z.read(nativepath);temp.write_bytes(raw)
   subprocess.run([str(kit/'bbsq.exe'),'-d',str(temp)],capture_output=True,check=True)
   s=subprocess.run([str(kit/'nutcracker.exe'),str(temp)],capture_output=True,check=True).stdout.decode('utf-8')
   icon=re.search(r'this.m.Icon\s*=\s*"([^"]+)"',s)[1];(OUT/'icons'/f'{key}.png').write_bytes(z.read('gfx/'+icon))
   native.append({'key':key,'source':nativepath,'icon':icon,'sha256':hashlib.sha256(raw).hexdigest(),'status':'原版图标暂用；V2技能未实装'})
 return definitions,native

def main():
 p=read(OUT/'proposal.json');live=read(OUT/'current-roster.json');evidence=collect_evidence()
 bykey={q['key']:q for q in p['people']}
 if 'xiwen' not in bykey:
  c=next(c for c in live['characters'] if c['key']=='xiwen');q=copy.deepcopy(bykey['yuchujiu'])
  q.update(key='xiwen',name='希文',group='旅途同行者（可选DLC）',role='早期轻装剑盾与走位支援',build='agile',
   day=6,battles=3,contracts=1,towns=2,highest_level=2,join_level=1,service_fee=180,wage=9,
   attrs=c['attrs'],stars=c['stars'],allocation=[7,3,0,0,10,0,10,0],current=c,
   equipment=c['equipment'],bag=[],growth_choices=live['memberGrowth']['xiwen']['choices'],growth_pick=0,
   target='保留DLC八维起点；近攻、近防各10次，生命7次、疲劳3次，轻装补位，不承担重甲主坦',
   perks='钢铁身躯、天赋异禀、探路者、剑术专精、盾牌专精、轮换、以一敌众、轻装、脚步/脱离、迅捷',
   alternative_perks='',weakness='无远程输出与破甲爆发；需要近身和走位触发技能；小盾被破后失去护卫路线',
   endgame_weapon='武装剑+轻盾；轻装身甲/头盔原始负重合计≤15；按敌人换钉锤，不默认高甲重盾',
   skills=['xiwen_read','xiwen_cover','xiwen_travel'],v1_attrs=c['attrs'],v1_price=c['hireCost'],v1_join_level=1,v1_wage=9)
  its=[p['items'][k] for k in q['equipment']]
  q.update(equipment_value=sum(x['Value'] for x in its),equipment_fatigue=-sum(x['StaminaModifier'] for x in its),bag_fatigue=0,
   body_armor=p['items']['armor/thick_tunic']['Condition'],head_armor=0)
  q['growth_bonus']=[q['growth_choices'][0]['bonuses'].get(f,0) for f in p['fields']]
  q['suggested_price']=math.ceil((q['service_fee']+.6*q['equipment_value'])/10)*10
  p['people'].append(q)
 # The mirror carries part of Xiwen's resolve budget; unequipped values stay honest.
 xi=next(q for q in p['people'] if q['key']=='xiwen')
 xi['attrs']=list(xi['attrs']);xi['attrs'][2]=21
 mirror_key='accessories/xiwen_round_mirror'
 p['items'][mirror_key]={'name':'希文的圆圆化妆镜','Value':0,'StaminaModifier':0,'Condition':0,
  'owner':'xiwen','slot':'accessory','bonuses':{'Bravery':20},'source':'V2原创设计，未实装',
  'appearance':'掌心大小的正圆镜面，细铜边、短圆柄；随身化妆用的小镜子',
  'flavor':'出门前总要照一眼。镜子里的自己站稳了，他也就敢往前一步。'}
 xi['equipment']=[k for k in xi['equipment'] if k!=mirror_key]+[mirror_key]
 xi['target']='本体决心21，镜子+20维持原表装备后41；近攻、近防各10次，生命7次、疲劳3次，轻装补位'
 xi['weakness']='卸下化妆镜后决心明显偏低，易受士气压力；无远程输出与破甲爆发，小盾被破后失去护卫路线'
 p['accessories']=[x for x in p['accessories'] if x['key']!='xiwen_round_mirror']
 p['accessories'].append({'key':'xiwen_round_mirror','item_key':mirror_key,'name':'希文的圆圆化妆镜','owner':'xiwen',
  'ap':0,'fatigue':0,'cd':0,'bonuses':{'Bravery':20},'text':'仅希文装备在饰品栏时决心+20；被动常驻，不消耗AP或疲劳。放入背包/仓库、卸下或转给其他人均不提供加成。入队随身赠送一件，无负重，不可出售；换装、读档不重复发放。','current':'V2新增设计；现行DLC尚无此物品。'})
 specs=[
  ('xiwen_read','看清破绽',False,0,0,0,1,'enemy',False,
   '持单手近战武器时，被相邻敌人的直接近战攻击打空，记住该攻击者；下次对该敌人的单体近战攻击命中+8，攻击判定后消耗。最多记住1人，后续未命中不刷新；到希文下个自身回合结束失效。每轮最多触发一次，不追加免费攻击，不对远程、反击或范围攻击触发。',
   '11级：该次命中加成+10，其余次数、目标和时限不变。'),
  ('xiwen_cover','同行照应',True,2,12,2,1,'ally',True,
   '持盾选择1名相邻且可行动的队员：该队员近防+8、远防+5，希文自身近防-3，持续至希文下次自身回合开始。不能选自己；同一目标临时护卫双防分别取最高不叠加，近防上限+8。希文失盾、倒地或与目标距离超过1格时立即终止；不增加攻击次数或代受伤害。',
   '11级：疲劳11；受护者近防仍+8、远防改为+8，希文近防代价减为-2；AP/CD不变。'),
  ('xiwen_travel','行路留力',False,0,0,0,0,'self',False,
   '身甲与头盔原始负重合计≤15，且上一自身回合主动移动至少1格时，本回合开始额外恢复2疲劳；第一回合不触发。被推拉、轮换和强制位移不算主动移动；重甲、超限负重不触发。该恢复计入每人每轮Mod额外恢复总上限8，不提高疲劳上限。',
   '11级：满足条件时额外恢复3疲劳；其他条件及全局上限不变。')]
 p['skills']=[s for s in p['skills'] if s['owner']!='xiwen']
 for key,name,active,ap,fat,cd,rng,target,shield,text,mastery in specs:
  p['skills'].append(dict(key=key,name=name,owner='xiwen',owner_name='希文',active=active,ap=ap,fatigue=fat,cd=cd,range=rng,target=target,shield=shield,uses_per_battle=None,text=text,mastery=mastery,mastery_fatigue=fat-max(1,int(fat*.15)) if fat else 0,current_text='DLC当前没有此专属技能；原版技能树仍照常使用。',change='V2新增；原版图标暂用'))
 for s,book in zip(p['skills'][-3:],['识隙札记','同行守则','长路笔记']):
  s['book_title']=book;s['change']='7级技能书《'+book+'》；V2新增，原版图标暂用'
 defs,nativeicons=trait_catalog(p,evidence);evby={x['key']:x for x in evidence['people']};assignments=[]
 for q in p['people']:
  q['current']=copy.deepcopy(next(c for c in live['characters'] if c['key']==q['key']))
  keys=SELECTION[q['key']].split();assert not any(b in defs[a]['excluded'] or a in defs[b]['excluded'] for a in keys for b in keys if a!=b),(q['key'],keys)
  ev=evby.get(q['key'],{'responses':0,'trait_respondents':0,'votes':{},'top3_including_ties':[]})
  delta=[sum(defs[k]['delta'][i] for k in keys) for i in range(8)]
  q['fixed_traits']=keys;q['trait_delta']=delta;q['runtime_base_before_traits']=[a-b for a,b in zip(q['attrs'],delta)]
  q['level_bonus_per_level']=[0,3 if q['key'] in ('afei','bottle') else 0,0,0,0,0,0,0]
  q['trait_note']='固定：'+'、'.join(defs[k]['name'] for k in keys)+'；原版八维效果已计入表列一级值，实装基础按特质增减反推，禁止再次加算；剧情二选一另计'
  if q['key']=='afei':q['trait_note']+='；队长专属“远征耐力”：2～11级每级疲劳上限+3，11级累计+30；不占30项升级预算，11级后封顶'
  if q['key']=='xiwen':q['trait_note']+='；化妆镜是饰品而非特质，本体决心21，装备镜子另加20'
  reason='设计补全，暂无投票支持' if not ev['trait_respondents'] else f"参考{ev['trait_respondents']}份含特质反馈；按角色定位选取，非票数自动采纳"
  assignments.append({'key':q['key'],'name':q['name'],'traits':keys,'delta':delta,'responses':ev['responses'],'trait_respondents':ev['trait_respondents'],
   'selected_votes':[ev['votes'].get(defs[k]['id'],0) for k in keys],'top3_including_ties':ev['top3_including_ties'],'reason':reason,
   'effects':'；'.join(defs[k]['name']+'：'+defs[k]['effect'] for k in keys),'level_fatigue_per_level':q['level_bonus_per_level'][1]})
 p['revision']='V2.1 · 希文、队长耐力与固定特质';p['source_internal_version']=live['version'];p['trait_accounting']='表列一级八维已含固定原版特质；实装基础=表列值-固定特质加减；剧情、队长逐级耐力另算；非八维机制真实生效但不伪造折算属性。'
 p['xiwen_recruitment']='第6日起，同时满足参战历史≥3、非送信有效履约≥1、合格不同城镇≥2、历史最高等级≥2；1级入队，服务费180+计价装备470×0.6，进十位报价470，日薪9。额外随身赠送圆圆化妆镜，占饰品栏，无负重，仅希文装备时决心+20；本体决心21。仍走3候选槽/1日冷却/4日过期，不强塞候选、不绕过门槛。成长需本人3级且个人参战3次；7级三选一永久锁定，11级所选技能精通。'
 write(OUT/'proposal.json',p)
 write(OUT/'trait-design.json',{'status':'仅V2设计，未实装','accounting':p['trait_accounting'],'definitions':defs,'people':assignments,'xiwen_icon_sources':nativeicons})
 changes=read(OUT/'changes.json');changes=[x for x in changes if x.get('revision')!='V2.1']
 for name,field,old,new,reason in [('阿飞','11级疲劳上限',94,124,'队长远征耐力每级+3，上限累计30；不挤占既有生命/攻击/防御选点'),('希文','V2招募/技能','仅DLC当前值','第6日、470克朗；7级三选一、11级精通','补齐早期可招的轻装剑盾支援位'),('全体35人','固定特质','仅剧情二选一','每人2个固定原版特质；剧情成长独立保留','按网站玩法/特质反馈和既有定位补全；表列八维不重复叠加'),('希文','决心与随身饰品','本体41，无镜子','本体21；圆圆化妆镜+20；装备后41','按用户要求降低本体决心，用随身饰品补回原预算；卸下后失去加成')]:
  changes.append(dict(kind='设计补全',name=name,field=field,old=old,new=new,reason=reason,revision='V2.1'))
 write(OUT/'changes.json',changes)
 print('V2.1: 35 people / 102 skills / 70 fixed traits; site stats excluded from numeric inputs.')

if __name__=='__main__':sys.stdout.reconfigure(encoding='utf-8');main()
