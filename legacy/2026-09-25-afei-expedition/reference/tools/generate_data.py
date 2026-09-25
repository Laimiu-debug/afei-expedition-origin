from pathlib import Path
import json
ROOT=Path(__file__).resolve().parents[1]
SRC=ROOT/'src'
DATA=json.loads((ROOT/'data/document-v0.6.2.json').read_text(encoding='utf-8'))
def sq(v):
    if isinstance(v,dict):return '{'+','.join('['+sq(k)+']='+sq(x) for k,x in v.items())+'}'
    if isinstance(v,list):return '['+','.join(map(sq,v))+']'
    return json.dumps(v,ensure_ascii=False)
def write(path,text):
    p=SRC/path;p.parent.mkdir(parents=True,exist_ok=True);p.write_text(text,encoding='utf-8')
world={'steal_bro','supermarket','scout_path','one_more_night','moon_cake','budget_share'}
specs={
'wawa_call':(4,16,'self',0,0,0),'toad_escape':(3,10,'empty',1,0,1),'full_circle':(4,30,'self',0,0,1),
'abacus_mark':(3,10,'enemy',4,2,0),'shadow_captain':(4,15,'ally',4,0,0),'borrow_strike':(2,8,'ally',3,3,0),
'bottle_breakthrough':(4,18,'enemy',1,2,0),'unselectable':(4,20,'self',0,0,1),'dog_bark':(3,12,'enemy',3,2,0),
'guard_swap':(3,15,'ally',1,0,1),'nicotine':(2,0,'self',0,0,1),'cover_up':(4,20,'ally',1,3,0),
'drum':(4,16,'self',0,0,0),'guard_gate':(3,12,'self',0,2,0),'prince_order':(4,15,'self',0,0,0),
'dui_sentence':(3,10,'ally',3,2,0),'steady_hand':(4,18,'ally',4,0,0),'catch_rear':(4,18,'enemy',4,3,0),
'gaga_charge':(6,22,'empty',1,3,0),'guard_nest':(3,15,'self',0,2,0),'lock_wagon':(4,15,'empty',1,0,2),
'spare_key':(3,10,'ally_self',1,2,0),'foot_point':(4,12,'empty',2,2,0),'hard_brake':(3,14,'self',0,3,0),
'return_road':(4,18,'ally',1,0,1),'pokemon':(4,16,'ally',4,3,0),'bear_strike':(3,12,'enemy',3,2,2),
'cup_signal':(4,15,'ally',3,0,0),'mouth_strong':(2,8,'enemy',1,3,0),'shrink_cover':(4,18,'self',0,3,0),
'long_watch':(4,18,'self',0,2,0),'king_dance':(4,16,'empty',1,2,0),'curtain_yield':(2,8,'empty',1,1,0),
'guard_self':(4,16,'self',0,2,0),'short_sprint':(3,14,'empty',2,3,0),'snake_trial':(4,16,'enemy',1,0,0),
'hold_curtain':(4,18,'self',0,2,0),'breach_strike':(6,24,'enemy',2,2,0),'line_detour':(3,12,'empty',1,2,0),
'catch_baton':(2,10,'ally',2,1,0),'door_block':(4,15,'enemy',1,2,0)}
orders={'wawa_call','shadow_captain','drum','prince_order','steady_hand','cup_signal','full_circle'}
weapons={'bottle_breakthrough','catch_rear','gaga_charge','snake_trial','breach_strike'}
skills={}
for cid,d in DATA.items():
    for a in d['skills']:
        s=dict(a);sid=s['id'];s.update(owner=cid,active=sid in specs,world=sid in world,order=sid in orders,weapon=sid in weapons)
        s.update(dict(zip(['ap','fatigue','target','range','cooldown','limit'],specs.get(sid,(0,0,'self',0,0,0)))))
        skills[sid]=s
        write('scripts/skills/actives/afei_'+sid+'.nut',f'this.afei_{sid} <- this.inherit("scripts/skills/afei_skill", {{ function create() {{ this.configure("{sid}"); }} }});\n')
write('scripts/mods/afei/definitions.nut','// Generated document definitions.\n::AfeiExpedition.Characters <- '+sq(DATA)+';\n::AfeiExpedition.SkillDefs <- '+sq(skills)+';\n')
print('Generated',len(DATA),'characters and',len(skills),'skills')
