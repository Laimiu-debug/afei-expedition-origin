"""V2 proposal: evidence-based revisions; V1 and playable Mod stay untouched."""
from pathlib import Path
from copy import deepcopy
from bs4 import BeautifulSoup
import json,re,math,hashlib,sys
sys.stdout.reconfigure(encoding='utf-8')
ROOT=Path(__file__).resolve().parents[1];OLD=ROOT/'docs/design/balance-v1';OUT=ROOT/'docs/design/balance-v2';CACHE=ROOT/'.cache/balance-v2';OUT.mkdir(exist_ok=True,parents=True)
def save(name,data):(OUT/name).write_text(json.dumps(data,ensure_ascii=False,indent=2),encoding='utf-8')
p=json.loads((OLD/'proposal.json').read_text(encoding='utf-8'));p['schema']=2;p['revision']='V2';p['status']='阅读用户提供书籍与Wiki后的设计优化；未实装，实机平衡仍待验收'
for n in ['current-roster.json','source-manifest.json','native-manifest.json']:
    save(n,json.loads((OLD/n).read_text(encoding='utf-8')))
changes=[]
def change(kind,key,name,field,old,new,why):changes.append(dict(kind=kind,key=key,name=name,field=field,old=old,new=new,reason=why))
special={'mocha':(52,0,10),'lili':(53,220,12),'tiantong':(55,380,14),'xiaoning':(56,550,18),'manyuemei':(56,450,15)}
for q in p['people']:
    q['v1_attrs']=q['attrs'][:];q['v1_price']=q['suggested_price'];q['v1_join_level']=q['join_level'];q['v1_wage']=q['wage']
    if q['key'] in special:
        ra,fee,wage=special[q['key']]
        for field,old,new in [('远攻',q['attrs'][5],ra),('服务费',q['service_fee'],fee),('一级日薪',q['wage'],wage)]:
            if old!=new:change('人物',q['key'],q['name'],field,old,new,'与原版猎人/偷猎者范围比较，给固定天赋和剧情成长留下预算；不改射程和操作特色')
        q['attrs'][5]=ra;q['service_fee']=fee;q['wage']=wage
    cap=1 if q['day']<26 else (2 if q['day']<46 else (4 if q['day']<56 else 5))
    if cap!=q['join_level']:change('招募',q['key'],q['name'],'阶段补级上限',q['join_level'],cap,'后期新人成长至7级所需经验过多；只给未分配升级，不赠送7级技能或终局甲')
    q['join_level']=cap
    q['suggested_price']=0 if q['current']['isCaptain'] else 10*math.ceil((q['service_fee']+.6*q['equipment_value']+120*(cap-1)**1.5)/10)
    if q['build'] in ('front','heavy'):
        q['v1_perks']=q['perks']
        heavy='钢铁身躯、天赋异禀、探路者、对应武器专精、钢头、以一敌众、战铸、壮实(Brawny)、快速换手、坚定(Fortified Mind)'
        light='钢铁身躯、天赋异禀、适应或背刺、对应武器专精、轮换、以一敌众、轻装、狂战士、杀戮狂怒、决斗者'
        q['perks']=heavy if q['build']=='heavy' else light
        q['alternative_perks']=heavy if q['build']=='front' else light
        q['endgame_weapon']+='；轻装决斗与重甲低耗分开点；重甲低耗按320身甲/300头甲压力装核算，壮实减轻甲盔负重，包内武器仍计负重'
        change('构筑',q['key'],q['name'],'10点专长',q['v1_perks'],q['perks'],'重甲低耗预留壮实和实际可用疲劳；不把狂战、恢复、不屈与低耗默认混在同一构筑')
p['assumptions']['catchup_history_divisor']=2
p['assumptions']['planning_highest_level']=11
p['catchup_formula']='max(1,min(阶段上限,1+floor((历史最高等级-2)/2)))；阶段上限：<26日1、26～45日2、46～55日4、56日及以后5；首次生成冻结'
SK={s['key']:s for s in p['skills']}
updates={
 'abacus_mark':{'ap':2,'fatigue':8,'text':'标记一个可见敌人，下一次己方单体武器攻击命中+10，尝试后耗尽，两次施术者回合开始后到期。一人仅一个标记；与全部Mod命中加成合计≤10。'},
 'shadow_captain':{'ap':2,'fatigue':8},
 'berry_mark':{'ap':1,'fatigue':8,'uses_per_battle':3,'text':'标记一个4格内可见敌人，下一次己方单体远程命中+8，尝试消耗，最多持续两轮；每战3次，每位施术者只保留一个。命中加成总上限+10，95%封顶仍有效。'},
 'cup_signal':{'ap':3,'fatigue':10},
 'fear_afei':{'text':'每战首次在3格内看到阿飞施放豪气冲天/飞爹在此，自己恢复8疲劳、下一次单体武器命中-5。若本战阿飞未上场，则在首次自身回合开始的基础恢复结算后、剩余疲劳仍至少4时恢复4；本战仅一次，两种触发互斥。'},
 'dui_sentence':{'ap':2,'fatigue':10,'text':'一名其他队员近防+4、决心+6至其下次回合结束。临时近防取高。此分支不再承诺清除互斥分支“恐飞派”的自身惩罚。'},
 'breach_strike':{'ap':6,'fatigue':20,'cd':3,'uses_per_battle':2,'text':'每战2次，以当前双手近战武器的普通单体招式攻击，护甲伤害×1.35，不降低命中；沿用武器实际射程（长柄允许2格）与血伤。不附带击退、不触发握把追加破甲、不加免费攻击。属于破甲爆发，长战持续收益仍与“奶团吕布”竞争。'},
 'gaga_charge':{'fatigue':16,'text':'单手近战普通单体招式，命中-5、护甲伤害×1.30；不移动不击退、不额外攻击。血伤不提高，伤害沿用所持武器，不能模拟双手技能。'},
}
reasons={
 'abacus_mark':'2AP能与弩的3AP射击+4AP装填组成9AP；原3AP会打断这个循环',
 'shadow_captain':'降低疲劳转移税；仍受50%最低费用约束，不能凭文字把8点全额算收益',
 'berry_mark':'1AP可与两次4AP投掷组成9AP；新增每战3次限制，避免无脑常驻',
 'cup_signal':'群体最多节约12疲劳，旧费用18还占4AP；改为10疲劳/3AP，保留机会成本',
 'fear_afei':'阿飞缺席时开场满体力导致4点恢复全部浪费，改成首次有可恢复疲劳时触发',
 'dui_sentence':'三选一技能不能同时具有“恐飞派”；删除不可达联动并降低单体支援AP',
 'breach_strike':'旧-5命中×1.20甲伤在65%命中时几乎等于被动+10%甲伤，却付双倍疲劳；改成有限爆发',
 'gaga_charge':'补足落空风险与疲劳成本，保留对无甲敌人不划算的弱点'}
for key,d in updates.items():
    s=SK[key];s['v1_text']=s['text'];s['v1_ap']=s['ap'];s['v1_fatigue']=s['fatigue'];s['v1_cd']=s['cd']
    for f,val in d.items():
        if s.get(f)!=val:change('技能',key,s['name'],f,s.get(f),val,reasons[key])
    s.update(d);s['change']='V2修订：'+reasons[key]
    s['mastery_fatigue']=max(0,s['fatigue']-max(1,int(s['fatigue']*.15))) if s['active'] and s['fatigue']>0 else s['fatigue']
for r in p['routes']:
    old=deepcopy(r)
    if r['id']=='toad':r.update(ap=1,effect='哇哇叫：自己近攻+8、近防-5，至下次自己回合开始；每战2次。不再降低武器伤害。',fatigue=18)
    elif r['id']=='jiahao':r.update(ap=3,effect='豪气冲天：花25克朗，2格内最多3名队员（含自己）双攻+6、决心+8，至各自下次回合结束；每战2次')
    else:r.update(ap=3,effect='飞爹在此：花20克朗，2格内自己与最多2名其他队员双攻+5、决心+5至各自下次回合结束；自己近防-3至下次自己回合开始；每战2次。不降低自身伤害。')
    r['v1']=old;change('路线',r['id'],r['name'],'主动契约',old['effect'],r['effect'],'按9AP攻击序列扣除施放机会成本；攻防取舍替代吞掉输出的伤害惩罚')
save('proposal.json',p);save('changes.json',changes)

# Extract native min/max attributes and compare every endpoint with observed Wiki rows.
base_text=(ROOT/'.cache/balance-v1/scripts__skills__backgrounds__character_background.nut').read_text(encoding='utf-8')
def ranges(t):return {f:[int(a),int(b)] for f,a,b in re.findall(r'(Hitpoints|Stamina|Bravery|Initiative|MeleeSkill|RangedSkill|MeleeDefense|RangedDefense)\s*=\s*\[\s*(-?\d+)\s*,\s*(-?\d+)\s*\]',t)}
base=ranges(base_text[base_text.index('function buildAttributes'):base_text.index('function onUpdate')])
soup=BeautifulSoup((CACHE/'wiki-Character_Backgrounds.html').read_text(encoding='utf-8'),'html.parser')
wiki={}
for table in soup.find_all('table'):
    for row in table.find_all('tr'):
        cells=row.find_all(['th','td'],recursive=False)
        if len(cells)==29:
            vals=[x.get_text(' ',strip=True)for x in cells]
            if vals[0].startswith(('Brawler ','Farmhand ','Hedge Knight ','Hunter ','Militia ','Poacher ','Sellsword ','Squire ')):
                name=next(x for x in ['Brawler','Farmhand','Hedge Knight','Hunter','Militia','Poacher','Sellsword','Squire']if vals[0].startswith(x+' '));wiki[name]={'name':vals[0],'attrs':[[int(vals[1+i*3]),int(vals[3+i*3])]for i in range(8)],'nominal_wage':int(vals[-1])}
backgrounds=[]
for name,w in wiki.items():
    key=name.lower().replace(' ','_');file=CACHE/'native'/('scripts__skills__backgrounds__'+key+'_background.nut');txt=file.read_text(encoding='utf-8');t=txt[txt.index('function onChangeAttributes'):];adj=ranges(t);native=[[base[f][i]+adj[f][i] for i in range(2)]for f in p['fields']]
    assert native==w['attrs'],(name,native,w['attrs'])
    wage=int(re.search(r'this.m.DailyCost\s*=\s*(\d+)',txt)[1]);backgrounds.append({'key':key,**w,'native_attrs':native,'native_constructor_wage':wage,'range_endpoints_matched':16})
assert len(backgrounds)==8
save('vanilla-backgrounds.json',backgrounds)
books=json.loads((CACHE/'books-index.json').read_text(encoding='utf-8'))
book_record=[{'slug':b['slug'],'title':'游戏数值百宝书：成为优秀的数值策划' if b['slug']=='treasury' else '平衡掌控者——游戏数值战斗设计','source':b['source'],'sha256':b['sha256'],'spine_count':len(b['spine']),'extracted_chars':sum(x['chars']for x in b['spine']),'scope':'全文可解析，按章节定位阅读重点内容；不把文本提取等同于逐字通读。图表未全部逐图复核。'}for b in books]
pages=[]
for file in sorted(CACHE.glob('wiki-*.json')):
    q=json.loads(file.read_text(encoding='utf-8'));raw=(CACHE/(file.stem+'.txt')).read_text(encoding='utf-8');rev=re.search(r'原文版本\s*(\d+)',raw)
    pages.append({'url':q['url'],'sha256':q['sha256'],'revision':rev[1]if rev else None,'snapshot':'2026-09-18'})
save('research-sources.json',{'books':book_record,'wiki':pages,'wiki_native_attribute_endpoint_checks':128,'extra_native':json.loads((CACHE/'native-manifest.json').read_text(encoding='utf-8'))})
print(json.dumps({'people':len(p['people']),'skill_contracts_changed':len(updates),'change_rows':len(changes),'plan_total_cost':sum(x['suggested_price']for x in p['people']),'backgrounds':len(backgrounds),'wiki_pages_fetched':len(pages)},ensure_ascii=False))

# Approved V2.1 revision: restore actual sources after the historical V1 seed.
import subprocess,sys
subprocess.run([sys.executable,str(ROOT/'tools/refresh_balance_v2_sources.py')],check=True)
subprocess.run([sys.executable,str(ROOT/'tools/balance_v2_revision.py')],check=True)
