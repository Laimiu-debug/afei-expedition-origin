"""V2 offline budgets and sensitivity probes. Never reports simulated campaign wins."""
from pathlib import Path
import json,math,random,statistics,sys,subprocess,hashlib
import balance_v1_validate as base
sys.stdout.reconfigure(encoding='utf-8')
ROOT=Path(__file__).resolve().parents[1];OUT=ROOT/'docs/design/balance-v2'
base.OUT=OUT
# V2 is implemented; the original source manifest remains a historical snapshot.
# The package audit independently checks current source bytes and approved amendments.
base.run(verify_runtime_snapshot=False)
p=json.loads((OUT/'proposal.json').read_text(encoding='utf-8'));v=json.loads((OUT/'validation.json').read_text(encoding='utf-8'))
bg=json.loads((OUT/'vanilla-backgrounds.json').read_text(encoding='utf-8'))
people={q['key']:q for q in p['people']};pr={q['key']:q for q in v['projection']}
checks=[]
def ck(condition,name):
    assert condition,name
    checks.append({'name':name,'passed':True})
ck(sum(q['range_endpoints_matched'] for q in bg)==128,'8背景128个属性端点与Wiki一致')
ck(len({s['key'] for s in p['skills']})==3*(len(p['people'])-1),'全部成员技能ID不重复且各有3项')
ck(pr['afei']['base_means'][1]>=120,'阿飞11级裸疲劳上限120以上，尚未扣装备')
xi_resolve=33 if p.get('endgame_revision')==1 else 24
ck(people['xiwen']['attrs'][2]==21 and pr['xiwen']['accessory_bonuses'][2]==20 and pr['xiwen']['base_means'][2]==xi_resolve and pr['xiwen']['with_accessory_means'][2]==xi_resolve+20,'希文决心区分本体、普通决心培养与镜子20；饰品未混入裸值')
td=json.loads((OUT/'trait-design.json').read_text(encoding='utf-8'))
ck(len(td['people'])==len(p['people']) and all(len(x['traits'])==2 for x in td['people']),'全员固定两特质')
ck(all(all(b not in td['definitions'][a]['excluded'] for b in q['traits'] if b!=a) for q in td['people'] for a in q['traits']),'固定特质无原版互斥冲突')
ck(all([a+b for a,b in zip(q['runtime_base_before_traits'],q['trait_delta'])]==q['attrs'] for q in p['people']),'特质反推基础加回后严格等于V2八维，无重复加算')
ck(all(s['mastery_fatigue']==max(0,s['fatigue']-max(1,int(s['fatigue']*.15))) for s in p['skills'] if s['active'] and s['fatigue']>0),'修订技能精通费用同步')
ck(all(q['join_level']==max(1,min(q['join_level'],1+(11-2)//2)) for q in p['people']),'11级历史最高可达到所有规划补级上限')
ck(all(q['join_level']<7 for q in p['people']),'补级不越过7级技能解锁')

# Same selected stars and allocation; this is not a random hiring expectation.
bench=[];bgby={x['key']:x for x in bg}
mapping={'tank':'hedge_knight','front':'militia','heavy':'farmhand','agile':'militia','ranged':'hunter','throw':'hunter','pole':'militia','banner':'squire','hybrid':'militia'}
for q in p['people']:
    b=bgby['hedge_knight' if q['key']=='bottle' else mapping[q['build']]]
    midpoint=[sum(a)/2 for a in b['attrs']]
    mean=[midpoint[i]+q['allocation'][i]*(p['growth_roll_min'][i]+(2 if q['stars'].get(f,0)==3 else q['stars'].get(f,0))+p['growth_roll_max'][i]+(1 if q['stars'].get(f,0)==3 else 0))/2 for i,f in enumerate(p['fields'])]
    bench.append({'key':q['key'],'name':q['name'],'background':b['key'],'background_name':b['name'],'native_midpoint':midpoint,'native_level11_same_selected_stars':mean,'mod_level11_with_story':pr[q['key']]['base_means'],'delta':[a-b for a,b in zip(pr[q['key']]['base_means'],mean)]})

# Exhaustive elementary action budgets, with expected hits expressed in one normal hit units.
op=[]
for hit in [.35,.65,.90]:
    for weapon_ap in [4,6]:
        before=math.floor(9/weapon_ap)*hit
        old=math.floor((9-3)/weapon_ap)*min(.95,hit+.08)*.85
        new=math.floor((9-1)/weapon_ap)*min(.95,hit+.08)
        op.append({'skill':'哇哇叫','base_hit':hit,'weapon_ap':weapon_ap,'baseline':before,'v1':old,'v2':new,'v2_gain':new/before-1,'limits':'本回合站定、无击杀返AP、无疲劳限制；未折算近防-5风险；每战2次'})
ck(all(x['v2']>x['baseline'] for x in op),'站定可支付费用时哇哇叫六种AP/命中情景均有进攻收益')
sequences=[{'skill':'账房标记','sequence':'弩射击3+装填4+标记','v1_ap':10,'v2_ap':9},
           {'skill':'莓果标记','sequence':'两次投掷4+4+标记','v1_ap':10,'v2_ap':9},
           {'skill':'哇哇叫','sequence':'单手攻击4+4+号令','v1_ap':11,'v2_ap':9},
           {'skill':'豪气冲天/飞爹在此','sequence':'双手攻击6+号令','v1_ap':10,'v2_ap':9}]
ck(all(x['v1_ap']>9 and x['v2_ap']==9 for x in sequences),'四条同回合攻击序列恢复可执行性')
breach={'base_hit':.65,'v1_armor_per_attempt':.60*1.20,'passive_armor_per_attempt':.65*1.10,'v2_armor_per_attempt':.65*1.35,'v2_over_passive_single':1.35/1.1-1,'v2_4_attacks_average_multiplier':(2*1.35+2)/4,'v2_8_attacks_average_multiplier':(2*1.35+6)/8,'passive_average_multiplier':1.1,'note':'普通武器甲伤作为1，尚未扣疲劳、剩甲上限和击杀收益；两次主动之间必须满足CD3'}
ck(breach['v2_8_attacks_average_multiplier']<1.1 and breach['v2_4_attacks_average_multiplier']>1.1,'破甲爆发与常驻在长短窗口保留交换关系')

# Exact current native fatigue rounding: body floor(negative*.7), helm ceil(negative*.7), bag half.
fat=[]
for q in p['people']:
    if q['build'] not in ('front','heavy'):continue
    raw=pr[q['key']]['base_means'][1]
    without=math.floor(raw-42-20-18-10/2)
    with_brawny=math.floor(raw+math.floor(-42*.7)+math.ceil(-20*.7)-18-10/2)
    target=p['assumptions']['heavy_fatigue_buffer']
    fat.append({'key':q['key'],'name':q['name'],'raw_fatigue':raw,'body_fatigue':42,'head_fatigue':20,'weapon_fatigue':18,'bag_fatigue':5,'without_brawny':without,'with_brawny':with_brawny,'recommended_buffer':target,'passes_buffer':with_brawny>=target})
ck(all(x['passes_buffer'] for x in fat),f'{len(fat)}位可走双手重甲者在普通320/300压力装下带壮实均留55以上可用疲劳')
jack=pr['xiaojie']
ck(people['xiaojie']['allocation']==[10,0,0,0,10,0,10,0] and jack['colossus_hp']==150 and jack['base_means'][4]==90 and jack['base_means'][6]==37,'小杰不点疲劳，普通生命近攻近防培养达150巨像生命、90近攻和37裸近防')
yanzi=people['yanzi']
ck(yanzi['attrs']==[60,110,48,90,55,50,6,4] and yanzi['stars']=={'MeleeSkill':2,'RangedSkill':2} and yanzi['fixed_traits']==['loyal','teamplayer'] and pr['yanzi']['base_means'][4:6]==[85,90],'眼子双攻2星，后排柄投培养达85近攻/90远攻；忠诚和团队协作，无跛足')
song=people['songnuanyang']
song_allocation=[6,0,0,4,10,0,10,0] if p.get('endgame_revision')==1 else [0,4,0,6,10,0,10,0]
song_means=[84,104,54,130,85,36,36,5] if p.get('endgame_revision')==1 else [66,116,54,141,85,36,36,5]
ck(song['attrs']==[63,104,50,108,55,36,6,5] and song['stars']=={'Initiative':3,'MeleeSkill':2,'MeleeDefense':2} and song['allocation']==song_allocation and song['fixed_traits']==['quick','ailing'] and song['runtime_base_before_traits'][3]==98 and pr['songnuanyang']['base_means']==song_means,'宋暖阳先攻3星双近2星；快速只算一次，30次培养严格匹配当前批准修订')
native=ROOT/'.cache/balance-v2/native'
armor=(native/'scripts__items__armor__armor.nut').read_text(encoding='utf-8');helm=(native/'scripts__items__helmets__helmet.nut').read_text(encoding='utf-8');bag=(native/'scripts__skills__special__bag_fatigue.nut').read_text(encoding='utf-8')
ck('this.Math.floor(this.m.StaminaModifier * staminaMult)' in armor and 'this.Math.ceil(this.m.StaminaModifier * staminaMult)' in helm and 'item.getStaminaModifier() / 2' in bag,'负重取整及包内半负重有本机脚本依据')
# Fatigue recurrence; not AI or combat. Incoming fatigue is a sensitivity parameter.
cycles=[]
for capacity in [9,14,25,40,p['assumptions']['heavy_fatigue_buffer']]:
    for attack_cost in [12,20]:
        for incoming in [0,5,10]:
            used=0;actions=0;trace=[]
            for turn in range(1,9):
                used=max(0,used-15)
                succeeds=used+attack_cost<=capacity
                if succeeds:used+=attack_cost;actions+=1
                used=min(capacity,used+incoming);trace.append({'turn':turn,'attacks':int(succeeds),'fatigue_after_enemy':used})
            cycles.append({'capacity':capacity,'attack_cost':attack_cost,'incoming_per_round':incoming,'attacks_in_8_rounds':actions,'trace':trace})
ck(next(x for x in cycles if x['capacity']==9 and x['attack_cost']==12 and x['incoming_per_round']==0)['attacks_in_8_rounds']==0,'低于招式费用的可用疲劳不能由每轮恢复弥补')
ck(next(x for x in cycles if x['capacity']==25 and x['attack_cost']==12 and x['incoming_per_round']==0)['attacks_in_8_rounds']==8,'标准12疲劳低耗攻击静止时可持续')

# Eight shield builds, three artificial hostile weapon profiles; no pass/fail balance assertion.
# Sword uses Slash +10 accuracy, hammer Smite; ranged hits omit distance, cover and shieldwall.
weapons=[('武装剑普砍',40,45,.8,.2,10,False),('双手锤单体',80,110,2.,.5,0,False),('远程高穿透压力',50,70,1.,.7,0,True)]
tanks=[];seed=9292026;trials=4000
for q in p['people']:
    if q['build']!='tank':continue
    for wi,(name,lo,hi,am,direct,accuracy,ranged) in enumerate(weapons):
        turtle=q['key']=='xiaogui';means=pr[q['key']]['base_means'];defense=means[7 if ranged else 6]+18.75+(5 if turtle else 0)
        defense=defense if defense<=50 else 50+(defense-50)/2
        hit=min(.95,max(.05,(85+accuracy-defense)/100))
        rng=random.Random(seed+wi);attempts=[];censored=0
        for _ in range(trials):
            hp=math.floor(means[0]*1.25);ar=[95.,0. if turtle else 105.];n=0
            while hp>0 and n<300:
                n+=1
                if rng.random()>hit:continue
                part=1 if rng.random()<.25 else 0
                total=(.5 if part else .8) if turtle else 1.
                dh,da=base.damage(rng.randint(lo,hi),rng.randint(lo,hi)*am,direct,ar[part],.4,1.,total,1.)
                hp-=dh;ar[part]-=da
            attempts.append(n);censored+=int(hp>0)
        mean=statistics.mean(attempts);se=statistics.stdev(attempts)/math.sqrt(trials)
        tanks.append({'key':q['key'],'name':q['name'],'weapon':name,'hit_chance':hit,'hp_with_colossus':math.floor(means[0]*1.25),'mean_attempts':mean,'se':se,'ci95':[mean-1.96*se,mean+1.96*se],'median':statistics.median(attempts),'p90':sorted(attempts)[math.ceil(trials*.9)-1],'trials':trials,'censored':censored})
ck(len(tanks)==24 and not any(t['censored'] for t in tanks),'24组承伤模型均未达到300次截断')
xp=[0,200,500,1000,2000,3500,5000,7000,9000,12000,15000]
catchup=[{'key':q['key'],'name':q['name'],'v1_level':q['v1_join_level'],'v2_level':q['join_level'],'v1_xp_to_7':xp[6]-xp[q['v1_join_level']-1],'v2_xp_to_7':xp[6]-xp[q['join_level']-1],'v1_price':q['v1_price'],'v2_price':q['suggested_price']} for q in p['people'] if q['v1_join_level']!=q['join_level']]
report={'checks':checks,'baseline_comparison':bench,'action_opportunity':op,'ap_sequences':sequences,'breach_window':breach,'heavy_fatigue':fat,'fatigue_cycles':cycles,'tank_stress':tanks,'tank_assumptions':{'seed':seed,'trials_each':trials,'enemy_attack':85,'armor':[95,105],'turtle_helmet':0,'nimble':.4,'shield_defense':18.75,'all_steel_brow':True,'limits':'被动木盾+盾专，未开盾墙；全部有钢头（小龟免费，其余占专长但未补偿）；不含任何技能三选一、士气伤势、攻击者疲劳、反击、破盾、地形和DOT。高穿透为人工压力参数，非某敌人实际技能。伤害尝试数不是存活率或回合数。'},'catchup':catchup,'economy_delta':[{'team':x['team'],'v2_daily':x['minimum_daily_gross'],'reserve7':x['seven_day_reserve']} for x in v['economy']]}
(OUT/'v2-validation.json').write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps({'v2_checks':len(checks),'new_tank_trials':len(tanks)*trials,'heavy_min_without':min(x['without_brawny'] for x in fat),'heavy_min_with':min(x['with_brawny'] for x in fat),'catchup_members':len(catchup)},ensure_ascii=False))
