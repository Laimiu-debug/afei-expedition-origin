"""Create the editable baseline once, and derive document-backed character data."""
from pathlib import Path
import hashlib
import json
import re
import shutil

ROOT = Path(__file__).resolve().parents[1]
REPO = ROOT.parents[1]
AUDIT = REPO / 'output/research/afei-implementation-audit-20260920'
SRC = ROOT / 'src'
if not SRC.exists():
    shutil.copytree(AUDIT / 'mod_source', SRC)
(ROOT / 'data').mkdir(exist_ok=True)
req = json.loads((AUDIT/'character-requirements.json').read_text(encoding='utf-8'))
inv = json.loads((AUDIT/'audit-inventory.json').read_text(encoding='utf-8'))
full = (AUDIT/'requirements.txt').read_text(encoding='utf-8').splitlines()
skill_ids = {
'C01':'wawa_call,jiahao,toad_escape,full_circle',
'C02':'scrap_parts,abacus_mark,shadow_captain',
'C03':'steal_bro,borrow_strike,together_lift',
'C04':'bottle_breakthrough,finals_moment,teammate_ball',
'C05':'unselectable,chaoju,ouqi',
'C06':'dog_bark,loyalty,guard_swap',
'C07':'supermarket,biantai,optimist',
'C08':'only_man,nicotine,cover_up',
'C09':'small_heart,drum,guard_gate',
'C10':'fear_afei,prince_order,dui_sentence',
'C11':'blue_form,steady_hand,good_card',
'C12':'scout_path,return_arrow,catch_rear',
'C13':'goose_bully,gaga_charge,guard_nest',
'C14':'lock_wagon,not_fooled,spare_key',
'C15':'foot_point,half_step,hard_brake',
'C16':'return_road,leave_not_gone,one_more_night',
'C17':'own_people,pokemon,breathe_easy',
'C18':'bear_strike,know_rules,cup_signal',
'C19':'mouth_strong,shrink_cover,abs_comeback',
'C20':'five_elder,long_watch,shift_arrive',
'C21':'king_dance,read_beat,curtain_yield',
'C22':'moon_cake,remember_shield,guard_self',
'C23':'start_run,short_sprint,segment_breath',
'C25':'snake_read,snake_trial,next_path',
'C26':'hold_ground,hold_curtain,door_mine',
'C27':'lvbu_weapon,breach_strike,look_flag',
'C28':'curve_force,line_detour,bell_lead',
'C29':'half_react,catch_baton,duck_turn',
'C30':'two_steps,door_block,long_run_breath',
'C31':'purse_clear,budget_share,no_last_throw',
}
data={}
for cid, rows in req.items():
    d=inv['characters'][cid]
    eqidx=next(i for i,r in enumerate(rows) if '初始装备：' in r)
    pairs=rows[eqidx+1:-2]
    assert len(pairs)//2==len(skill_ids[cid].split(',')),cid
    abilities=[]
    for j,sid in enumerate(skill_ids[cid].split(',')):
        header=pairs[2*j].split(' | ',1)[1]
        desc=pairs[2*j+1].split(' | ',1)[1]
        abilities.append({'id':sid,'name':header.split(' ')[0],'kind':' '.join(header.split(' ')[1:]),'text':desc,'source':pairs[2*j+1].split(' | ')[0]})
    start=next(i for i,r in enumerate(full) if r==rows[0])
    stop=next(i for i in range(start+1,len(full)) if '初始能力与专属技能' in full[i])
    story='\n\n'.join(r.split(' | ',1)[1] for r in full[start+1:stop] if r.startswith('P'))
    source=(AUDIT/'mod_source'/d['source']['path']).read_text(encoding='utf-8')
    def first(pattern,default=0):
        m=re.search(pattern,source)
        return int(m.group(1)) if m else default
    bg=re.search(r'Background = "([^"]+)"',source)
    if not bg and cid=='C04': background='afei_bottle_background'
    elif not bg: background={'C01':'afei_captain_background','C02':'afei_mocha_background','C03':'afei_damou_background'}[cid]
    else: background=bg.group(1)
    rn=0 if int(cid[1:])<=3 else int(cid[1:])-3
    data[cid]={'id':cid,'name':d['name'],'attrs':d['doc_attrs'],'stars':d['doc_stars'],'wage':d['doc_wage'],
        'equipment_text':d['doc_equipment'].split(' | ')[1], 'background':background,'story':story,'skills':abilities,
        'growth_text':rows[-1].split(' | ',1)[1], 'recruit_id':f'R{rn:02d}' if rn else '',
        'day':first(r'getTime\(\).Days < (\d+)'), 'contracts':first(r'getPaidContracts\(\) < (\d+)'),
        'fee':first(r'tryChargeHire\("C\d+", (\d+)\)'),
        'requires_m':re.findall(r'!this.World.Flags.get\(::AfeiExpedition.Flags.(M\d+Done)\)',source),
        'cohesion':45 if cid in ['C17','C19'] else 0}
(ROOT/'data/document-v0.6.2.json').write_text(json.dumps(data,ensure_ascii=False,indent=2),encoding='utf-8')
assert sum(x['wage'] for x in data.values())==431
print(f'Prepared {len(data)} characters, {sum(len(d["skills"]) for d in data.values())} skills at {ROOT}')
