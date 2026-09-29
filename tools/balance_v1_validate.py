"""Deterministic growth, native damage oracle, combat probes and economy checks.

Combat probes are isolated repeated-attack models, not simulated campaign wins.
"""
from pathlib import Path
from collections import Counter
import hashlib, itertools, json, math, random, statistics, subprocess, sys
sys.stdout.reconfigure(encoding='utf-8')
ROOT=Path(__file__).resolve().parents[1]; OUT=ROOT/'docs/design/balance-v1'
CACHE=ROOT/'.cache/balance-v1'

def damage(regular, armor_roll, direct, armor, hp_mult=1.0, armor_mult=1.0, total_mult=1.0, head_mult=1.0, minimum=0):
    r=regular*hp_mult*total_mult; a=armor_roll*armor_mult*total_mult
    dealt=min(armor,a) if direct<1 else 0
    remaining=armor-dealt if direct<1 else 0
    hp=max(0,r*direct-remaining*.1)
    if remaining<=0 or direct>=1: hp+=max(0,r*max(0,1-direct)-dealt)
    hp=max(0,math.floor(hp*head_mult+.5),min(math.floor(minimum+.5),math.floor(minimum*total_mult+.5)))
    return hp,dealt

def native_oracle():
    source=(CACHE/'scripts__entity__tactical__actor.nut').read_text(encoding='utf-8')
    method=source[source.index('function onDamageReceived'):]
    start=method.index('local dmgMult =');end=method.index('_hitInfo.DamageInflictedHitpoints = damage;')+len('_hitInfo.DamageInflictedHitpoints = damage;')
    body=method[start:end]
    prefix='''::Math <- {max=function(a,b){return a>b?a:b;},min=function(a,b){return a<b?a:b;},maxf=function(a,b){return a>b?a:b;},round=function(x){return floor(x+0.5);}};
::Const <- {Combat={ArmorDirectDamageMitigationMult=0.1}};
::oracle <- {m={Fatigue=0,CurrentProperties={FatigueLossOnAnyAttackMult=1.0}},getFatigueMax=function(){return 100;},
run=function(_hitInfo,p){local _skill=null;
'''
    suffix='return [_hitInfo.DamageInflictedHitpoints,_hitInfo.DamageInflictedArmor];}};::oracle.setdelegate(getroottable());\n'
    cases=list(itertools.product([0,40,100,300],[0.0,.2,.5,1.0],[1.0,.4],[1.0,.7],[1.0,1.5],[1.0,.8]))
    # Also cover a weapon with a minimum damage rule.
    rows=[];commands=[]
    for i,(armor,direct,hpm,arm,head,total) in enumerate(cases):
        minimum=10 if i%7==0 else 0
        rows.append((damage(80,165,direct,armor,hpm,arm,total,head,minimum),[armor,direct,hpm,arm,head,total,minimum]))
        commands.append(f'''local h{i}={{DamageRegular=80.0,DamageArmor=165.0,DamageDirect={direct},DamageFatigue=0,BodyPart=0,BodyDamageMult={head},DamageMinimum={minimum},DamageInflictedArmor=0,DamageInflictedHitpoints=0}};
local p{i}={{DamageReceivedTotalMult={total},DamageRegularReduction=0,DamageArmorReduction=0,DamageReceivedRegularMult={hpm},DamageReceivedArmorMult={arm},Armor=[{float(armor)}],ArmorMult=[1.0],FatigueEffectMult=1,FatigueReceivedPerHitMult=1,DamageReceivedDirectMult=1.0}};
local r{i}=::oracle.run(h{i},p{i});print(r{i}[0]+","+r{i}[1]+"\\n");''')
    path=CACHE/'native_damage_oracle.nut';path.write_text(prefix+body+suffix+'\n'.join('{'+c+'}' for c in commands),encoding='utf-8')
    run=subprocess.run([str(ROOT/'.cache/afei-art/bbros-modkit-v9/bin/sq.exe'),str(path)],capture_output=True,text=True,check=True)
    outputs=[list(map(float,line.split(','))) for line in run.stdout.splitlines()]
    assert len(outputs)==len(rows)
    for (expected,args),actual in zip(rows,outputs):assert all(abs(a-b)<1e-5 for a,b in zip(expected,actual)),(args,expected,actual)
    return {'cases':len(rows),'passed':True,'reference':'本机原版 actor.onDamageReceived 伤害片段，Squirrel 独立执行','fragment_sha256':hashlib.sha256(body.encode()).hexdigest()}

def distribution(base,n,lo,hi):
    counts=Counter({base:1})
    for _ in range(n):
        next_counts=Counter()
        for v,c in counts.items():
            for roll in range(lo,hi+1):next_counts[v+roll]+=c
        counts=next_counts
    total=sum(counts.values())
    def quantile(q):
        c=0
        for v,n in sorted(counts.items()):
            c+=n
            if c/total>=q:return v
    return {'mean':sum(v*n for v,n in counts.items())/total,'p10':quantile(.1),'p50':quantile(.5),'p90':quantile(.9)}

def build_projection(data):
    result=[]
    for p in data['people']:
        d={'key':p['key'],'name':p['name'],'build':p['build'],'attrs':[],'wage11':p['wage']*1.1**10}
        for i,f in enumerate(data['fields']):
            s=p['stars'].get(f,0);lo=data['growth_roll_min'][i]+(2 if s==3 else s);hi=data['growth_roll_max'][i]+(1 if s==3 else 0)
            base=p['attrs'][i]+p['growth_bonus'][i]+10*p.get('level_bonus_per_level',[0]*8)[i]
            d['attrs'].append(distribution(base,p['allocation'][i],lo,hi))
        d['base_means']=[x['mean'] for x in d['attrs']]
        d['accessory_bonuses']=[sum(data['items'][k].get('bonuses',{}).get(f,0) for k in p['equipment'] if data['items'][k].get('slot')=='accessory' and data['items'][k].get('owner',p['key'])==p['key']) for f in data['fields']]
        d['with_accessory_means']=[a+b for a,b in zip(d['base_means'],d['accessory_bonuses'])]
        d['colossus_hp']=math.floor(d['base_means'][0]*1.25)
        d['join_usable_fatigue']=p['attrs'][1]-p['equipment_fatigue']-p['bag_fatigue']
        d['primary_attack']=d['base_means'][5] if p['build'] in ['ranged','throw','hybrid'] else d['base_means'][4]
        result.append(d)
    return result

def strike_probe(w,mode,n=4000):
    # Same seed sequence across options makes comparisons less noisy.
    rng=random.Random(9292026)
    target_hp,body0,head0,hpm,bf=mode
    attacks=[];hits=[];censored=0
    for _ in range(n):
        hp=target_hp;armor=[body0,head0];attempts=0;landed=0
        while hp>0 and attempts<200:
            attempts+=1
            if rng.random()>.65:continue
            landed+=1;part=1 if rng.random()<.25 else 0
            regular=rng.randint(w['low'],w['high']);ar=rng.randint(w['low'],w['high'])*w['armor']
            am=1-sum(armor)*.0005 if bf else 1
            hp_d,armor_d=damage(regular,ar,w['direct'],armor[part],hpm,am,1,1.5 if part else 1)
            hp-=hp_d;armor[part]-=armor_d
            if hp>0:armor[part]=max(0,armor[part]-w.get('extra',0))
        attacks.append(attempts);hits.append(landed);censored+=hp>0
    ordered=sorted(attacks)
    return {'mean_attempts':statistics.mean(attacks),'median_attempts':statistics.median(attacks),'p90_attempts':ordered[math.ceil(n*.9)-1],
            'mean_landed_hits':statistics.mean(hits),'mean_turns_ap_only':statistics.mean(math.ceil(a/w['attacks_per_turn']) for a in attacks),
            'censored':censored,'trials':n,'mean_se':statistics.stdev(attacks)/math.sqrt(n)}

def run(verify_runtime_snapshot=True):
    data=json.loads((OUT/'proposal.json').read_text(encoding='utf-8'))
    checks=[]
    def ck(ok,label):
        checks.append({'name':label,'passed':bool(ok)});assert ok,label
    people=data['people'];keys={p['key'] for p in people}
    ck(len(people)==len(keys),'在册人物不重复')
    ck(keys=={p['key'] for p in json.loads((OUT/'current-roster.json').read_text(encoding='utf-8'))['characters']},'与实时源码名单逐ID一致')
    ck(len(data['skills'])==3*(len(people)-1) and len(data['routes'])==3,'每位非阿飞成员各三技能，阿飞三条互斥路线')
    ck(all(len(p.get('skills',[]))==3 for p in people if p['key']!='afei'),'所有非阿飞成员具备三选一')
    ck(all(sum(p['allocation'])==30 and max(p['allocation'])<=10 for p in people),'每人10次升级恰选30项，单项≤10次')
    ck(all(len(p['growth_choices'])==2 for p in people),'全员个人成长二选一完整')
    ck(all(0<=s<=3 for p in people for s in p['stars'].values()),'天赋星数合法')
    ck(all(x in data['items'] for p in people for x in p['equipment']+p['bag']),'全部招募装备在物品目录中有定义，原创饰品另标设计来源')
    ck(all(p['attrs'][1]>p['equipment_fatigue']+p['bag_fatigue']+30 for p in people),'全部招募配装一级可用疲劳超过30')
    ck(all(not p['highest_level']>8 and not p['towns']>8 for p in people),'末批门槛不要求已满编或不可得等级')
    ck(all(p['body_armor']<=95 and p['head_armor']<=105 for p in people),'招募装备不会直接跳到终局防具')
    ck(all(0<=s['ap']<=9 and s['fatigue']>=0 for s in data['skills']),'所有技能基础行动成本合法')
    ck(data['accessories'][0]['heal']*data['accessories'][0]['uses_per_battle']==30,'电子烟治疗总量30，无无限回血')
    ck(all(len(x['bonus'])==8 for x in data['afei_event_choices']),'自行车两分支分别预算，不累加')
    manifest=json.loads((OUT/'source-manifest.json').read_text(encoding='utf-8'))
    if verify_runtime_snapshot:
        ck(all(hashlib.sha256((ROOT/x['path']).read_bytes()).hexdigest()==x['sha256'] for x in manifest['files']),'方案制作期间现行运行脚本未被改动')
    proj=build_projection(data)
    weapons={
     '原版双手锤单体锤击':{'low':80,'high':110,'armor':2.0,'direct':.5,'attacks_per_turn':1},
     '现行老马握把单体锤击':{'low':100,'high':120,'armor':2.25,'direct':.5,'extra':40,'attacks_per_turn':1},
     '提案老马握把单体锤击':{'low':90,'high':110,'armor':2.0,'direct':.5,'extra':25,'attacks_per_turn':1},
     '原版武装剑双手握持普砍':{'low':40,'high':45,'armor':.8,'direct':.2,'attacks_per_turn':2}
    }
    # Double Grip multiplies both damage rolls; include a dedicated multiplier below.
    # Keep the sword as a one-handed-with-shield reference, avoiding fractional random-roll shortcuts.
    weapons['原版武装剑持盾普砍']=weapons.pop('原版武装剑双手握持普砍')
    modes={'中甲练习靶':(80,150,105,1,False),'轻装练习靶':(90,95,105,.4,False),'战铸练习靶':(80,300,300,1,True)}
    probes=[{'weapon':name,'target':target,**strike_probe(w,m)} for name,w in weapons.items() for target,m in modes.items()]
    pacing=[]
    # Stress assumptions only. Real contract supply, map distances, and XP allocation vary.
    rates={'熟练推进':(.9,.35,.23,.2),'常规推进':(.55,.23,.16,1/9),'谨慎推进':(.35,.16,.10,1/14)}
    for name,(br,cr,tr,lr) in rates.items():
        times=[]
        for p in people:
            d=max(p['day'],math.ceil(p['battles']/br),math.ceil(p['contracts']/cr),math.ceil(max(0,p['towns']-1)/tr),math.ceil((p['highest_level']-1)/lr))
            times.append({'key':p['key'],'name':p['name'],'eligible_day':d})
        pacing.append({'profile':name,'rates':[br,cr,tr,lr],'all_eligible_day':max(t['eligible_day'] for t in times),'people':times,
          'eligible_counts':{str(day):sum(t['eligible_day']<=day for t in times) for day in [10,20,30,45,60,90,120]}})
    roster_by={p['key']:p for p in people}
    teams=[('起步6人',2,['afei','damou','mocha','shuaizi','lili','xiaoyueya'],24,8,4,150),
           ('成形12人',6,['afei','damou','mocha','bottle','shuaizi','lili','yuchujiu','xiaoyubeike','wangduidui','laocai','yanzi','tiantong'],55,18,10,250),
           ('终局12+4轮换',11,['afei','damou','mocha','bottle','lili','xiaoning','manyuemei','yuchujiu','keke','yuxiang','tutu','wanshe','yaoyaoya','xiaogui','xiaojie','suwa'],90,28,20,400),
           (f'{len(people)}人满级收藏',11,[p['key'] for p in people],120,40,30,500)]
    economy=[]
    for name,level,members,repair,med,ammo,reinvest in teams:
        wage=sum(roster_by[k]['wage']*1.1**min(10,level-1)*1.03**max(0,level-11) for k in members)
        extra_food=sum('gluttonous' in roster_by[k].get('fixed_traits',[]) for k in members)
        food=(len(members)*2+extra_food)*3 # Native gluttonous adds one unit/day; price is a planning input.
        upkeep=wage+food+repair+med+ammo
        economy.append({'team':name,'level':level,'members':members,'count':len(members),'wages':wage,'food':food,'repair':repair,'medicine':med,'ammo':ammo,'upkeep':upkeep,'reinvest':reinvest,'minimum_daily_gross':upkeep+reinvest,'seven_day_reserve':upkeep*7})
    skill_budgets={'temporary_hit_cap':10,'permanent_conditional_defense_cap':6,'guard_temp_defense_highest_only':8,'recipient_extra_fatigue_cap':8,'aoe_support_max_targets':3}
    afei=next(p for p in proj if p['key']=='afei')
    afei_scenarios=[{'route':r['name'],'event':e['name'],'attrs':[a+b+c for a,b,c in zip(afei['base_means'],r['growth'],e['bonus'])]} for r in data['routes'] for e in data['afei_event_choices']]
    report={'status':'离线结构和算式验证通过；实机平衡未验收','checks':checks,'native_damage_oracle':native_oracle(),'projection':proj,'afei_scenarios':afei_scenarios,
      'combat_probes':probes,'combat_assumptions':{'seed':9292026,'hitchance':.65,'head_chance':.25,'independent_damage_rolls':True,'native_smite_bonus':20,
       'limits':'靶子无AI、无反击、无伤势/士气/控制，攻击者不受疲劳限制；不包括技能三选一、全队协作与其他Mod；AP轮数只是理想下界'},
      'pacing':pacing,'economy':economy,'skill_budget_rules':skill_budgets,
      'probability':{'p':.05,'mean_rolls':20,'median_rolls':math.ceil(math.log(.5)/math.log(.95)),'p90_rolls':math.ceil(math.log(.1)/math.log(.95)),
       'p20':1-.95**20,'p40':1-.95**40,'p60':1-.95**60,'two_eligible_shops_one_round':1-.95**2},
      'required_playtests':['99个技能分支与3路线逐项实机验收','普通佣兵同等级同装备对照','12人阵容对不同敌军与地图的胜率、伤亡、回合数','至少3种经济难度各3地图种子120日','旧档候选报价、已选技能及成长迁移']}
    (OUT/'validation.json').write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding='utf-8')
    print(json.dumps({'checks':len(checks),'native_formula_cases':report['native_damage_oracle']['cases'],'attack_probe_trials':sum(x['trials'] for x in probes),
        'pacing_all_eligible':[(x['profile'],x['all_eligible_day']) for x in pacing],'economy_daily':[(x['team'],round(x['minimum_daily_gross'])) for x in economy]},ensure_ascii=False))

if __name__=='__main__':run()
