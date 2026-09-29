"""Authoritative proposal inputs. Does not modify the playable Mod."""
from pathlib import Path
import json, math, re

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT/'docs/design/balance-v1'
FIELDS = ['Hitpoints','Stamina','Bravery','Initiative','MeleeSkill','RangedSkill','MeleeDefense','RangedDefense']
LABELS = ['生命','疲劳上限','决心','先攻','近攻','远攻','近防','远防']
# key | role | build | day | battles | contracts | towns | highest level | service fee | wage | attrs | stars
ROWS = '''
afei|成长型队长|front|0|0|0|0|1|0|8|52,94,38,100,48,32,3,2|MA2 MD2 BR2
damou|单点护卫盾师|tank|0|0|0|0|1|0|15|59,100,48,96,56,32,6,2|MD3 BR2 FAT1
mocha|弩手兼军需账房|ranged|0|0|0|0|1|0|10|53,98,43,100,50,54,3,5|RA2 BR1 FAT1
bottle|高成长决战剑士|front|12|6|3|3|3|900|16|56,97,44,102,53,34,3,2|MA3 MD3 BR3
shuaizi|低成本守线盾卫|tank|2|0|0|2|1|140|9|62,102,45,96,54,30,7,3|MD2 BR1 HP1
lili|远距弓手|ranged|5|2|1|2|2|200|11|52,95,38,116,46,55,1,5|RA2 INI1 BR1
xiaoyueya|近距投掷兼补给|throw|7|2|1|3|2|130|9|54,99,36,115,49,51,3,5|RA2 INI2 HP1
yuchujiu|轻装救援近战|agile|10|4|1|3|2|230|11|56,99,45,117,55,36,5,5|MA2 MD1 INI2
xiaoyubeike|高生命双手前锋|heavy|14|6|2|3|3|300|12|65,106,40,87,55,30,5,0|MA2 HP2 MD1
wangduidui|副旗手与接班指挥|banner|16|6|3|4|3|240|12|55,98,55,106,52,35,4,3|BR2 INI1 HP1
laocai|中期重甲盾锚|tank|20|8|3|4|4|400|16|59,104,51,92,58,32,7,3|MD3 BR2 HP1
yanzi|剑盾反制游击|front|18|7|3|4|3|250|12|60,104,48,104,60,38,6,4|MA1 MD1 BR1
tiantong|稳健游猎弓手|ranged|22|8|4|5|4|320|12|54,98,44,107,47,57,2,5|RA2 BR1 INI1
xiaoning|定点穿甲弩手|ranged|26|10|4|5|4|430|14|52,95,40,101,45,59,2,6|RA2 RD1 HP1
xiaopangxu|耐力盾斧与破盾|tank|28|11|4|5|4|380|14|66,112,42,88,55,30,7,1|MD2 FAT2 HP1
dae|侧翼防远程盾卫|tank|24|10|4|5|4|320|13|64,102,48,90,54,31,8,2|MD3 HP1 BR2
manyuemei|集火投掷手|throw|32|13|5|6|5|400|14|52,98,44,117,46,58,2,6|RA2 INI2 BR1
xiaohani|轻装贴身辅助|agile|30|12|4|6|5|220|11|55,101,43,121,58,38,5,4|MA1 INI2 MD1
keke|贴身保护盾卫|tank|34|14|5|6|5|360|14|57,104,52,100,51,44,6,5|MD3 FAT1 BR2
yuxiang|长柄持续输出|pole|36|15|5|6|5|380|14|62,108,46,94,59,31,5,2|MA2 FAT1 BR1
tongzhu|士气旗手与软控|banner|38|16|6|6|5|300|12|60,98,54,102,53,35,4,3|BR2 HP1 MA1
meiya|轻装位移决斗|agile|40|16|6|7|6|400|14|58,105,43,119,59,33,6,3|MA1 FAT1 INI2
wanshe|单手反制决斗|front|42|18|6|7|6|480|15|57,100,42,115,59,31,5,3|MA2 INI1 MD1
tutu|救援旗手|banner|44|18|7|7|6|240|12|57,104,56,100,51,36,4,3|BR2 FAT1 HP1
naigai|嘲讽盾卫兼副投掷|hybrid|45|19|7|7|6|200|11|61,102,38,104,51,49,6,3|MD2 RA1 HP1
xiaojie|解网与近战工具位|heavy|48|20|7|7|6|260|12|64,110,44,96,56,32,5,2|FAT2 HP1 MA1
bula|投掷与军需补位|throw|50|21|8|8|7|250|11|57,103,45,102,48,53,3,5|RA2 HP1 BR1
suwa|先攻牵制决斗|agile|52|22|8|8|7|450|14|54,102,41,126,56,42,4,5|INI3 FAT1 MA1
qianhan|突进矛兵|front|54|23|8|8|7|420|14|60,106,44,113,59,32,6,3|MA2 MD1 FAT1
wangdazhi|站位防线盾卫|tank|56|24|9|8|7|380|14|63,108,48,94,55,30,8,3|MD2 FAT1 BR1
yaoyaoya|低先攻破甲双手斧|heavy|60|26|9|8|8|550|16|64,113,42,84,60,28,4,0|MA2 FAT2 MD1
yangmiemie|救援长柄与侧翼补位|pole|58|25|9|8|7|280|12|66,105,45,101,56,35,5,3|HP2 BR1 MA1
songnuanyang|中期通用救火队员|front|28|11|4|5|4|230|12|61,104,49,110,59,36,6,5|MA1 HP1 BR1
xiaogui|无头盔特化盾卫|tank|46|20|7|7|6|500|16|54,108,45,88,49,38,3,5|MD3 FAT1 BR2
'''
ABBR = dict(zip(['HP','FAT','BR','INI','MA','RA','MD','RD'],FIELDS))
ALLOCATION = {
    'tank':[8,5,7,0,0,0,10,0], 'front':[6,0,4,0,10,0,10,0],
    'heavy':[4,4,2,0,10,0,10,0], 'agile':[5,0,3,2,10,0,10,0],
    'ranged':[7,4,5,0,0,10,0,4], 'throw':[7,3,4,0,0,10,6,0],
    'pole':[8,4,6,0,10,0,2,0], 'banner':[8,4,10,0,8,0,0,0],
    'hybrid':[7,3,4,0,0,6,10,0]
}
BUILD_NOTES = {
 'tank':('生命≥85、决心≥65、裸近防30～43；枪盾过渡，重甲到位才点战铸','钢铁身躯、九命或天赋异禀、盾牌专家、嘲讽、轮换、钢头、以一敌众、战铸或轻装、坚定不移、恢复','输出低；破盾、疲劳压制、围攻与控制会使其失效'),
 'front':('主近攻≥80、裸近防≥25、生命≥75；单手可转决斗，双手可转低耗','钢铁身躯、天赋异禀、适应或背刺、武器专精、轮换、以一敌众、轻装或战铸、狂战士、杀戮狂怒、决斗者或钢头','不要把近防、生命、决心同时让位给输出；破甲弱时换武器'),
 'heavy':('生命≥75、决心≥45、裸近防≥25；15恢复支持低耗单击，不承诺双击常驻','钢铁身躯、天赋异禀、探路者、武器专精、钢头、以一敌众、战铸或轻装、坚定不移、快速换手、恢复','高穿透与包围危险；狂战爆发需另投疲劳并替换天赋'),
 'agile':('当前先攻驱动闪避；主近攻≥80、生命≥70，轻装甲盔疲劳尽量≤15','钢铁身躯、天赋异禀、闪避、迅捷、武器专精、以一敌众、轻装、狂战士、杀戮狂怒、决斗者或脱离','长战疲劳降低先攻和闪避；不能按裸先攻算永久近防'),
 'ranged':('远攻≥90、生命≥70；安全后排，射程与遮挡先于面板伤害','钢铁身躯、天赋异禀、快速换手、弓或弩专精、鹰眼、脚步或预判、轻装、狂战士、杀戮狂怒、压制或恐惧打击','古代亡灵和重盾克制弓；被贴身后应撤离或用备用近战'),
 'throw':('远攻≥85、生命≥75；投掷距离2格最强，弹药与副武器要留槽','钢铁身躯、天赋异禀、快速换手、投掷专精、腰带口袋、脚步、轻装、狂战士、杀戮狂怒、决斗者','弹药和近距离暴露是代价；决斗者必须副手空且实际投掷'),
 'pole':('近攻≥80、生命≥75、决心≥55；二格长柄，轮换补位','钢铁身躯、天赋异禀、快速换手、长柄专精、背刺、轮换、轻装、狂战士、杀戮狂怒、恐惧打击','狭路站位受限，被突进后低近防；别当全天候前排'),
 'banner':('裸决心≥90、生命≥75；有旗才算旗手，招募不白送公司战旗','钢铁身躯、振奋军心、天赋异禀、坚定、长柄专精、轮换、轻装、恐惧打击、恢复、腰带口袋','不靠纯输出比强弱；亡灵不吃恐惧，旗手倒下会失去士气支撑'),
 'hybrid':('主盾副投掷；优先生命决心近防，远攻目标70以上只打近距离','钢铁身躯、天赋异禀、盾牌专家、嘲讽、投掷专精、轮换、轻装、坚定不移、恢复、脚步','拿盾时没有双手握持和决斗收益；不能把坦克与纯投手峰值同时算上')
}
ITEM_NAMES={
 'militia_spear':'民兵矛','shortsword':'短剑','falchion':'弯刀','bludgeon':'钉头棒','woodcutters_axe':'伐木斧','hand_axe':'手斧','pickaxe':'镐',
 'pitchfork':'草叉','warfork':'战叉','pike':'长枪','light_crossbow':'轻弩','short_bow':'短弓','hunting_bow':'猎弓','javelin':'标枪','throwing_axe':'投斧','knife':'小刀','dagger':'匕首',
 'wooden_shield':'木盾','buckler_shield':'小圆盾','kite_shield':'鸢盾','padded_surcoat':'填充罩袍','ragged_dark_surcoat':'破旧深色罩袍','padded_leather':'填充皮甲','leather_lamellar':'皮札甲','mail_shirt':'链甲衫','mail_hauberk':'链甲长袍','thick_tunic':'厚布衣',
 'hood':'兜帽','headscarf':'头巾','aketon_cap':'填充帽','nasal_helmet':'鼻盔','sallet_helmet':'萨莱特盔','quiver_of_arrows':'箭袋','quiver_of_bolts':'弩矢袋',
 'two_handed_hammer':'双手锤','arming_sword':'武装剑','greatsword':'双手大剑','billhook':'钩镰枪','flail':'链枷','boar_spear':'猎猪矛','wooden_flail':'木链枷','wooden_stick':'木棒','lute':'鲁特琴'}

def item_path(x):
    if x in ['wooden_shield','buckler_shield','kite_shield']: return 'shields/'+x
    if x in ['padded_surcoat','ragged_dark_surcoat','padded_leather','leather_lamellar','mail_shirt','mail_hauberk','thick_tunic']:return 'armor/'+x
    if x in ['hood','headscarf','aketon_cap','nasal_helmet','sallet_helmet']: return 'helmets/'+x
    if x.startswith('quiver'):return 'ammo/'+x
    return 'weapons/'+x

def equipment(p):
    key=p['key']; b=p['build'];day=p['day']
    if key=='afei': return ['militia_spear','padded_surcoat','hood','wooden_shield'],['knife']
    if key=='damou': return ['militia_spear','padded_leather','aketon_cap','wooden_shield'],['knife']
    armor='padded_surcoat' if day<12 else ('padded_leather' if day<26 else 'leather_lamellar')
    helmet='hood' if day<12 else ('aketon_cap' if day<26 else 'nasal_helmet')
    if key=='qianhan':return ['boar_spear',armor,helmet,'wooden_shield'],['knife']
    if b=='tank':w='hand_axe' if key=='xiaopangxu' else 'militia_spear'; return [w,armor,*([] if key=='xiaogui' else [helmet]),'wooden_shield'],['knife']
    if b=='ranged':
        w='light_crossbow' if key in ['mocha','xiaoning'] else ('short_bow' if day<20 else 'hunting_bow')
        return [w,'quiver_of_bolts' if w=='light_crossbow' else 'quiver_of_arrows',armor,helmet],['knife']
    if b in ['throw','hybrid']:
        return ['javelin',armor,helmet]+(['wooden_shield'] if b=='hybrid' else []),['javelin','knife']
    if b in ['pole','banner']:return ['pitchfork' if day<26 else 'warfork',armor,helmet],['knife']
    if b=='heavy':return ['woodcutters_axe' if key=='yaoyaoya' else 'pickaxe',armor,helmet]+([] if key=='yaoyaoya' else ['wooden_shield']),['knife']
    return ['shortsword' if day<26 else 'falchion',armor,helmet]+(['wooden_shield'] if b=='front' else []),['knife']

def main():
    current=json.loads((OUT/'current-roster.json').read_text(encoding='utf-8'))
    old={p['key']:p for p in current['characters']}
    growth=json.loads((ROOT/'data/member-growth.json').read_text(encoding='utf-8'))
    growth_by={p['key']:p for p in growth['characters']}
    items={}
    attrs=['Value','StaminaModifier','Condition','RegularDamage','RegularDamageMax','ArmorDamageMult','DirectDamageMult','MeleeDefense','RangedDefense']
    for p in sorted((ROOT/'.cache/balance-v1').glob('scripts__items__*.nut')):
        key=p.stem.removeprefix('scripts__items__').replace('__','/')
        if key=='item':continue
        t=p.read_text(encoding='utf-8');data={}
        for f in attrs:
            m=re.search(r'this\.m\.'+f+r'\s*=\s*(-?\d+(?:\.\d+)?)\s*;',t)
            if m:data[f]=float(m[1])
        data['name']=ITEM_NAMES.get(key.split('/')[-1],key)
        # Daggers/knives/ammo inherit zero equipment fatigue.
        data.setdefault('StaminaModifier',0)
        items[key]=data
    people=[]
    for line in ROWS.strip().splitlines():
        key,role,build,day,battles,contracts,towns,level,fee,wage,raw,star=line.split('|')
        p={'key':key,'name':old[key]['name'],'group':current['chapters'][old[key]['chapter']-1]['name'], 'role':role,'build':build,
           'day':int(day),'battles':int(battles),'contracts':int(contracts),'towns':int(towns),'highest_level':int(level),'service_fee':int(fee),'wage':int(wage),
           'attrs':[int(x) for x in raw.split(',')],'stars':{ABBR[x[:-1]]:int(x[-1]) for x in star.split()},'allocation':ALLOCATION[build], 'current':old[key]}
        p['join_level']=1 if p['day']<26 else (2 if p['day']<46 else 3)
        p['equipment'],p['bag']=[list(map(item_path,a)) for a in equipment(p)]
        p['equipment_value']=sum(items[a]['Value'] for a in p['equipment']+p['bag'])
        p['equipment_fatigue']=-sum(items[a]['StaminaModifier'] for a in p['equipment'])
        # Only non-two-handed bag weapons count half weight; proposed bags contain javelins/knife.
        p['bag_fatigue']=-sum(items[a]['StaminaModifier']*0.5 for a in p['bag'])
        p['body_armor']=sum(items[a].get('Condition',0) for a in p['equipment'] if a.startswith('armor/'))
        p['head_armor']=sum(items[a].get('Condition',0) for a in p['equipment'] if a.startswith('helmets/'))
        p['suggested_price']=0 if old[key]['isCaptain'] else 10*math.ceil((p['service_fee']+0.6*p['equipment_value']+120*(p['join_level']-1)**1.5)/10)
        p['growth_choices']=growth_by.get(key,{}).get('choices',[])
        p['growth_pick']=0
        p['growth_bonus']=[p['growth_choices'][0]['bonuses'].get(f,0) if p['growth_choices'] else 0 for f in FIELDS]
        p['target'],p['perks'],p['weakness']=BUILD_NOTES[build]
        p['trait_note']='保留个人剧情二选一；不再额外随机抽取改变八维的原版正负特性'
        if key=='bottle':p['trait_note']+='；保留近攻/近防/决心九星，以较低基础近防和更高招募费支付成长成本'
        if key=='afei':p['trait_note']+='；三路线互斥，转职不改天赋、不返还升级次数'
        if key=='xiaogui':p['trait_note']+='；保留禁戴头盔、免费钢头、双防+5、头部武器伤害×0.5/躯干×0.8'
        p['endgame_weapon']={'tank':'矛/单手锤+圆盾；远程压力换鸢盾','front':'单手剑/锤决斗，或双手锤低耗','heavy':'双手锤/斧+包内二格武器','agile':'单手剑/刺剑或匕首；刺剑须另投先攻','ranged':'战弓/重弩+投掷或匕首','throw':'重标枪/重投斧+匕首，空副手','pole':'钩镰枪/长柄锤+副武器','banner':'公司战旗+鞭/网；全队只有一面旗也可轮换','hybrid':'单手矛+盾，包内标枪'}[build]
        people.append(p)
    proposal={'schema':1,'status':'设计提案，未实装，未完成实机平衡验收','date':'2026-09-29','fields':FIELDS,'labels':LABELS,
       'source_internal_version':current['version'],'people':people,'items':items,
       'growth_roll_min':[2,2,2,3,1,2,1,2],'growth_roll_max':[4,4,4,5,3,4,3,4],
       'assumptions':{'equipment_price_coefficient':0.6,'catchup_price_coefficient':120,'wage_level_rate':1.1,'late_wage_rate':1.03,
        'offer_slots':3,'slot_cooldown_days':1,'offer_expiry_days':4,'flat_fatigue_recovery':15,'max_battle':12,'roster_max':40}}
    (OUT/'proposal.json').write_text(json.dumps(proposal,ensure_ascii=False,indent=2),encoding='utf-8')
    print('proposal:',len(people),'characters;',len(items),'native items;',sum(p['suggested_price'] for p in people),'estimated total recruitment crowns')

if __name__=='__main__':main()
