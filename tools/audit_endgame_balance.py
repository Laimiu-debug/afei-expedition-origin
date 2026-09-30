"""Audit live role revision, native costs, and bounded 3/6-round budgets.

These are resource traces, never simulated victories or game acceptance.
"""
import copy
import hashlib
import json
import math
from pathlib import Path
import re
import subprocess
from zipfile import ZipFile
from balance_v1_validate import build_projection

ROOT=Path(__file__).resolve().parents[1]
DESIGN=ROOT/'docs/design/balance-v2'
CACHE=ROOT/'.cache/endgame-balance-20260930'
KIT=ROOT/'.cache/afei-art/bbros-modkit-v9/bin'
def read(path):return json.loads(path.read_text(encoding='utf-8'))
def write(path,data):path.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
def table(headers,rows):
    return '\n'.join(['|'+'|'.join(headers)+'|','|'+'|'.join(['---']*len(headers))+'|']+['|'+'|'.join(str(x).replace('|','／').replace('\n','；') for x in row)+'|' for row in rows])
def native_costs():
    required=['scripts/skills/actives/'+n+'.cnut' for n in ['slash','split_man','shieldwall','rally_the_troops','throw_javelin','lunge_skill','shoot_bolt','reload_bolt','quick_shot','impale']]
    found={}
    for path in sorted(Path('F:/SteamLibrary/steamapps/common/Battle Brothers/data').glob('data_*.dat')):
        with ZipFile(path) as z:
            for n in required:
                if n in z.namelist():found[n]=(path.name,z.read(n))
    assert set(found)==set(required),set(required)-set(found)
    result={}
    for n,(archive,raw) in found.items():
        path=CACHE/n.replace('/','__');path.write_bytes(raw)
        subprocess.run([str(KIT/'bbsq.exe'),'-d',str(path)],capture_output=True,check=True)
        source=subprocess.run([str(KIT/'nutcracker.exe'),str(path)],capture_output=True,check=True).stdout.decode('utf-8-sig')
        path.with_suffix('.nut').write_text(source,encoding='utf-8')
        key=Path(n).stem
        result[key]={'entry':n,'archive':archive,'sha256':hashlib.sha256(raw).hexdigest(),
            'ap':int(re.search(r'this.m.ActionPointCost\s*=\s*(\d+)',source)[1]),
            'fatigue':int(re.search(r'this.m.FatigueCost\s*=\s*(\d+)',source)[1])}
    return result
def trace(capacity,cost,ap,recovery,incoming,initiative,weight):
    used=0;rows=[]
    for turn in range(1,7):
        used=max(0,used-recovery)
        if used+cost<=capacity:
            used+=cost;action='planned';spent_ap=ap
        else:
            used=math.floor(used/2);action='recover';spent_ap=9
        used=min(capacity,used+incoming)
        effective=max(0,initiative-weight-used)
        rows.append({'round':turn,'action':action,'ap':spent_ap,'fatigue_end':used,
            'remaining':capacity-used,'effective_initiative_no_relentless':effective,
            'dodge_bonus_no_relentless':math.floor(effective*.15),
            'effective_initiative_with_relentless':max(0,initiative-weight-used*.5)})
    return rows
def main():
    CACHE.mkdir(parents=True,exist_ok=True)
    p=read(DESIGN/'proposal.json');am=read(DESIGN/'endgame-amendment-20260930.json')
    before=copy.deepcopy(p)
    old_by={q['key']:q for q in before['people']}
    for row in am['people']:
        for field,change in row['changes'].items():old_by[row['key']][field]=change['before']
    old_projection={q['key']:q for q in build_projection(before)}
    projection=build_projection(p);pr={q['key']:q for q in projection}
    exporter=(ROOT/'tools/export_gameplay_roster.nut').read_text(encoding='utf-8').replace('local A=::AfeixExpedition, characters=[];',
        'dofile("dlc/xiwen-regen/src/scripts/mods/afeix_dlc_xiwen_regen/content.nut");\nlocal A=::AfeixExpedition, characters=[];')
    temporary=CACHE/'export.nut';temporary.write_text(exporter,encoding='utf-8')
    run=subprocess.run([str(KIT/'sq.exe'),str(temporary)],cwd=ROOT,capture_output=True,text=True,encoding='utf-8',check=True)
    live=json.loads(run.stdout.split('ROSTER_JSON_BEGIN\n')[1].split('\nROSTER_JSON_END')[0])
    live_by={q['key']:q for q in live['characters']}
    assert len(live_by)==len(p['people'])==35
    for q in p['people']:
        for field in ['attrs','stars','role','equipment','bag','wage']:
            assert q[field]==live_by[q['key']][field],(q['key'],field)
        old=old_by[q['key']]
        assert sum(q['attrs'])==sum(old['attrs'])
        assert sum(q['stars'].values())==sum(old['stars'].values())
        assert sum(q['allocation'])==30 and all(0<=n<=10 for n in q['allocation'])
    costs=native_costs()
    specialized=lambda name:math.ceil(costs[name]['fatigue']*.75)
    budgets=[]
    for q in p['people']:
        b=q['build'];key=q['key'];raw=pr[key]['base_means'];weight=30;recover=15
        if key=='xiaogui':
            # No helmet. Head mitigation/awakening remain outside this resource model.
            weight=45;cost=specialized('shieldwall');ap=4;mode='无头盔盾墙；假设身甲+武器+盾+包合计45'
        elif b=='tank' or key=='naigai':
            weight=66;cost=specialized('shieldwall');ap=4;mode='盾墙；壮实甲盔44+单手7+盾10+包5'
        elif b=='banner':
            weight=30;cost=costs['rally_the_troops']['fatigue'];ap=5;mode='每轮号令；轻甲15+战旗10+包5'
        elif key=='songnuanyang':
            weight=27;cost=specialized('lunge_skill');ap=costs['lunge_skill']['ap'];mode='每轮一次刺剑突进；轻甲15+主手7+包5'
        elif b=='throw':
            cost=2*specialized('throw_javelin');ap=8;mode='站定双投；轻甲与武器包合计30'
        elif b=='ranged':
            if key=='lili':cost=2*specialized('quick_shot');ap=8;mode='站定弓双射'
            else:cost=specialized('shoot_bolt')+specialized('reload_bolt');ap=costs['shoot_bolt']['ap']+costs['reload_bolt']['ap'];mode='弩射击与装填'
        elif b=='heavy' or key in ['afei','qianhan']:
            weight=67;cost=specialized('split_man')+2;ap=8;mode='双手斧单击+探路者平地一步；重甲压力负重67'
            if key=='qianhan':weight=66;cost=specialized('slash')+2;ap=6;mode='单手备用武器单击+平地一步；盾矛另按矛墙招式预算'
        elif b in ['pole','hybrid']:
            cost=specialized('impale')+2;ap=costs['impale']['ap']+2;mode='长柄单击+平地一步；未减长柄专精AP，保守预算'
            if key=='yuxiang':recover=18
        else:
            if key=='bottle':weight=67
            cost=2*specialized('slash');ap=8;mode='站定单手剑双击'
        assert ap<=9 and cost>0,(key,ap,cost)
        capacity=max(0,raw[1]-weight)
        for incoming in [0,5]:
            rows=trace(capacity,cost,ap,recover,incoming,raw[3],weight)
            budgets.append({'key':key,'name':q['name'],'mode':mode,'weight':weight,'capacity':capacity,
                'cost_per_planned_turn':cost,'ap_per_planned_turn':ap,'recovery':recover,
                'incoming_per_round':incoming,'trace':rows,'r3':rows[2],'r6':rows[5]})
    paths=['src/scripts/mods/afeix/balance_v26_data.nut','src/scripts/mods/afeix/balance_v26.nut','src/scripts/mods/afeix/roster.nut',
           'src/scripts/mods/afeix/balance_v26_combat.nut','src/scripts/mods/afeix/member_catalog_combat.nut',
           'src/scripts/mods/afeix/member_catalog_hooks.nut','src/scripts/skills/traits/afeix_member_passive.nut',
           'docs/design/balance-v2/proposal.json','docs/design/balance-v2/全人物数值与招募总表.xlsx']
    report={'date':'2026-09-30','version':(ROOT/'VERSION').read_text().strip(),'in_game_tested':False,
            'runtime_people_verified':35,'projection':projection,'before_projection':list(old_projection.values()),
            'native_costs':costs,'fatigue_budgets':budgets,
            'source_hashes':{path:hashlib.sha256((ROOT/path).read_bytes()).hexdigest() for path in paths},
            'limits':'Resource budgets only. Standard gear weights are explicit assumptions, not every actual loadout. No hits, damage, terrain, injuries, control, berserk, morale or multi-branch stacking simulated. Recover replaces the whole planned turn when capacity is insufficient. No victories or survival rates inferred.'}
    write(ROOT/'docs/design/endgame-balance-audit-20260930.json',report)
    write(CACHE/'projection.json',projection)
    lines=['# 终局岗位数值平衡：2026-09-30',
        '按[定位方案](endgame-role-plan-20260930.md)落实至主包v0.28.4。34名主包成员和可选DLC希文全部复核。原方案保留为调整前记录。当前完成源码实装、原版费用核对、数学预算和隔离行为检查，游戏内战斗与长期战役尚未验收。',
        '## 调整原则',
        '每人一级八维总和与天赋总星数不增加，培养固定30项、单项最多10次。招募门槛/排队、日薪、初始装备、固定原版特质、剧情成长和三选一规则沿用原值。八维总和只是本轮抑制整体膨胀的约束，不代表各属性价值相等。生命/决心换走先攻或远攻，会让部分角色更适合终局近战；初期表现也要另测。',
        '## 主要培养变化',
        table(['成员','调整前11级裸值','调整后11级裸值','职责'],[[q['name'],'／'.join(f'{n:g}' for n in old_projection[q['key']]['base_means']),'／'.join(f'{n:g}' for n in pr[q['key']]['base_means']),q['role']] for q in p['people'] if old_projection[q['key']]['base_means']!=pr[q['key']]['base_means']]),
        '顺序为生命／疲劳上限／决心／先攻／近攻／远攻／近防／远防。均值含固定特质和所选剧情，未含装备、原版专长、阿飞路线、小龟体质及临时效果。随机升级不会保证这些均值。',
        '阿飞裸近攻83，蛤蟆后89、近防36；嘉豪裸决心加10为62，仍不能代替90～110决心的旗手。飞碟本轮保留现有费用与效果；新站位协同玩法留待独立设计和实机比较，未伪称已实现。',
        '宋暖阳保留先攻3星、双近2星；6次生命替代4次疲劳及2次先攻，裸84血、巨像105。苏袜总5星不增加，用2点先攻星换近攻/近防星。小杰仍120裸血、巨像150，疲劳88不升级，保留血牛差异。',
        '希文只重排培养：本体决心21+3次普通升级9+剧情3=33，戴镜53。脱镜仍是明确弱点；生命73降70、疲劳106降100。希文保持可选DLC，没有并入主包名单。',
        '## 六项按岗位分化的精通',
        table(['技能','11级效果'],[[next(s['name'] for s in p['skills'] if s['key']==key),text] for key,text in am['specialized_masteries'].items()]),
        '这些精通替换原通用自身恢复+1，未与其叠加。原有每轮/每战次数、攻击命中要求、单体限制、相邻条件和全Mod恢复上限8保留。其余技能与阿飞三条路线费用不变。',
        '## 全员30项培养与职责',
        table(['成员','职责','培养次数（八维顺序）','培养与换装说明'],[[q['name'],q['role'],'／'.join(map(str,q['allocation'])),q['target']] for q in p['people']]),
        '## 3轮与6轮行动预算',
        '以下是明确配装假设下的资源轨迹，不是战斗仿真。原版专精费用×0.75向上取整；回合开始先恢复，支付计划动作后增加受击压力。不够支付整套动作时，用9AP恢复替代整轮，累计疲劳减半取整。表列压力为每轮额外5疲劳；无额外受击版本与完整轨迹见JSON。第一轮从0累积疲劳开始，不给技能三分支同时发奖励。',
        table(['成员','动作与负重假设','可用池','计划AP/疲劳','第3轮剩余','第6轮剩余','6轮回气次数'],[[b['name'],b['mode'],f"{b['capacity']:g}",f"{b['ap_per_planned_turn']}/{b['cost_per_planned_turn']}",f"{b['r3']['remaining']:g}",f"{b['r6']['remaining']:g}",sum(t['action']=='recover' for t in b['trace'])] for b in budgets if b['incoming_per_round']==5]),
        '负重67只是320/300壮实后的44+主手18+包5压力模板；持盾角色改用盾牌负重，不能照抄。小龟无头盔独立列假设，觉醒和头部减伤未计入资源表。奶盖、旗手、机动、远程也采用各自明确的负重假设，不是全员穿神装。',
        '原版先攻还扣装备与累计疲劳。JSON对每轮列未点无情与已点无情的有效先攻，闪避值按未点无情时15%取整；武器、地形与负重改变后必须重算，不能将裸先攻换算为永久近防。主动突进、换位、号令与范围攻击的额外组合不在本表内。',
        '## 实机验收与旧档',
        '旧档基础八维按调整前后差额同步一次，保留已分配属性、剧情和技能选择，不治疗当前伤势；当前生命超过降低后的新上限时，仅下调至上限。苏袜改星只重算尚未使用的普通升级队列，老兵+1与已花点数不动。新培养方案是玩家加点建议，不自动洗点；已走旧方案的11级角色不会凭读档获得新方案均值。',
        '建议先用新战役检查3/7/11级的招募和配装，再测重装近战、古代亡灵、远程控制、高数量敌群与恐惧/魅惑场景。记录实际命中、破甲/击杀、承伤伤势、士气、3/6轮疲劳、回气空窗与救场成功；不以离线模型宣称所有敌人等强或通关保证。',
        '复算：`python tools/audit_endgame_balance.py`；完整行为检查：`python tools/check_gameplay.py`。数据与源哈希见[endgame-balance-audit-20260930.json](endgame-balance-audit-20260930.json)。']
    (ROOT/'docs/design/endgame-balance-20260930.md').write_text('\n\n'.join(lines)+'\n',encoding='utf-8')
    print('Verified 35 runtime profiles; 70 resource traces; native costs; wrote comparison and playtest limits.')
if __name__=='__main__':main()
