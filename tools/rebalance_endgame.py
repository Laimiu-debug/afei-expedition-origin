"""Apply the 2026-09-30 role revision to the existing design inputs.

No installation or publication. The first baseline is preserved for migration
and comparison; subsequent runs reapply the same revision, never compound it.
"""
import copy
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DESIGN = ROOT / 'docs/design/balance-v2'
CACHE = ROOT / '.cache/endgame-balance-20260930'

def read(path):
    return json.loads(path.read_text(encoding='utf-8'))

def write(path, data):
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

def apply():
    CACHE.mkdir(parents=True, exist_ok=True)
    source = DESIGN / 'proposal.json'
    baseline = CACHE / 'before-proposal.json'
    if not baseline.exists():
        baseline.write_bytes(source.read_bytes())
    old = read(baseline)
    p = copy.deepcopy(old)
    by = {q['key']: q for q in p['people']}
    def change(key, *, attrs=None, allocation=None, stars=None, **notes):
        q = by[key]
        if attrs is not None:
            assert sum(attrs) == sum(q['attrs']), key
            q['attrs'] = attrs
            q['runtime_base_before_traits'] = [a-b for a,b in zip(attrs,q['trait_delta'])]
        if allocation is not None:
            assert sum(allocation) == 30 and all(0 <= n <= 10 for n in allocation), key
            q['allocation'] = allocation
        if stars is not None:
            assert sum(stars.values()) == sum(q['stars'].values()), key
            q['stars'] = stars
        q.update(notes)

    change('afei', attrs=[69,106,46,79,51,19,3,2],
           role='可换路线的队长前排', target='近攻近防各10次，生命3、疲劳6、决心1；裸78血/124疲劳/52决心/83近攻/33近防。蛤蟆89近攻36近防，嘉豪62决心；另计支线，支援路线不代替主旗手。')
    change('bottle', attrs=[67,109,51,86,60,24,3,2], allocation=[5,4,1,0,10,0,10,0],
           role='高命中单手决斗主力', target='近攻近防各10次、生命5、疲劳4、决心1；82血/127疲劳/54决心/98近攻/38近防。单手空副手；重甲与轻甲分开点，双击需回气。',
           endgame_weapon='武装剑/单手锤，空副手；决斗者与双手握持对应单手武器。轻甲连续攻击或重甲决斗分别规划，不能按双手武器低耗循环计算。')
    change('damou', allocation=[9,5,6,0,0,0,10,0], role='相邻核心的单点护卫盾坦', target='86血/72决心/43近防；大哥借我保护关键一人，低近攻不兼任破甲主力。')
    change('shuaizi', role='局部疲劳支援与卡口盾卫', target='93血/69.5决心/40近防；打鼓最多3人，4AP会挤掉攻击，盾墙与支援分轮使用。')
    change('laocai', role='中央阵线盾锚', target='87血/82决心/44近防；稳一手保护中央阵线，区别单人护卫；临时双防取高。')
    change('keke', allocation=[10,5,5,0,0,0,10,0], role='伤员附近的贴身护卫盾卫', target='87血/74决心/41近防；生命优先于额外决心，保可梦掩护伤员；巨大不等于输出岗位。')
    change('dae', allocation=[8,4,6,0,0,0,10,2], role='侧翼与远程掩护盾卫', target='92血/74决心/46近防/6远防；保留基础近防优势，守窝配鸢盾掩护远程火力。54近攻不承担可靠破甲输出。')
    change('xiaopangxu', attrs=[66,112,45,85,55,30,7,1], role='受击维持续航的耐久盾卫', target='94血/132疲劳/66决心/37近防；挨过这一拍在受击后恢复，低近攻不培养成主输出。')
    change('naigai', allocation=[8,1,5,0,0,6,10,0], role='盾卫兼近距投掷补刀', target='89血/105疲劳/58决心/36近防/70远攻；主盾副投，生命与决心优先，70远攻不与纯投手同档。')
    change('yuchujiu', attrs=[61,99,45,117,55,31,5,5], allocation=[7,0,3,0,10,0,10,0],
           role='贴前排的换位救场接应', target='82血/58决心/85近攻/32近防；2次先攻改生命，近身救援需换位后的容错。',
           endgame_weapon='轻甲单手剑/锤或低耗双手；护团换位只救相邻队员，不赠攻击；不按刺剑专用培养。')
    change('xiaohani', attrs=[60,101,43,119,60,33,5,4], allocation=[7,0,3,0,10,0,10,0],
           role='贴队友的轻甲续战接应', target='81血/85近攻/30近防/123先攻；2次先攻改生命，留口气用于脱战轮换，持续攻击时不触发休息恢复。')
    change('meiya', attrs=[62,105,43,115,59,29,10,3], allocation=[7,0,3,0,10,0,10,0],
           role='攻击后让位的轻甲机动输出', target='83血/86近攻/30近防；减少裸先攻并补基础近防，先算谢幕后的AP，不靠闪避承担主坦。')
    change('suwa', attrs=[60,102,41,123,56,38,5,5], allocation=[7,0,3,0,10,0,10,0],
           stars={'Initiative':1,'Stamina':1,'MeleeSkill':2,'MeleeDefense':1},
           role='先手抢位与轻甲侧击', target='81血/86近攻/30近防/129先攻；总5星不变，先攻3星降1，近攻1升2、近防0升1。抢安全目标，先攻仍扣装备与疲劳。')
    change('songnuanyang', allocation=[6,0,0,4,10,0,10,0],
           role='轻甲刺剑与先手补杀', target='84血/104疲劳/54决心/130先攻/85近攻/36近防；6次生命替代4疲劳与2先攻，仍保留先攻3星双近2星。巨像105血，持续突进必须回气。',
           weakness='130裸先攻需扣装备与累积疲劳；不再给疲劳升级，突进更要控制连续消耗。体弱多病使中毒多持续1回合。')
    change('wanshe', attrs=[61,110,46,100,59,28,5,3], allocation=[7,1,2,0,10,0,10,0], build='agile',
           role='单手压制与续击输出', target='82血/113疲劳/52决心/92近攻/30近防；轻甲单手，3次疲劳改生命，下一招换个路按命中和AP兑现。',
           endgame_weapon='轻甲单手剑/锤，空副手；蛇形试招压敌近攻或连续单体减耗，不默认重甲55缓冲。')
    change('qianhan', attrs=[69,108,48,101,59,29,6,3], role='持矛控线与追击补位',
           target='81血/122疲劳/54决心/92近攻/31近防；保留矛手高命中与矛墙方向，持盾须额外计盾重，后期另备破甲武器。',
           perks='钢铁身躯、天赋异禀、探路者、矛术专精、盾牌专精、轮换、以一敌众、轻装、恢复、快速换手',
           endgame_weapon='矛+盾控线，包内单手锤/投斧应付重甲；专精不自动覆盖备用武器；矛墙不是通用破甲输出。')
    change('xiaoyubeike', attrs=[65,108,48,77,55,30,5,0], allocation=[5,3,2,0,10,0,10,0],
           role='稳健重甲双手低耗前排', target='88血/122疲劳/54决心/85近攻/30近防；普通320/300壮实、18主手和5包内负重后55。双手斧单击专精12疲劳+探路者平地一步2，受击仍可破坏循环。',
           endgame_weapon='双手斧低耗单击；双手锤控制另核对实际招式与专精。持盾顶上去属于替代培养，与双手装备互斥。')
    change('yaoyaoya', attrs=[64,113,49,76,60,28,5,0], allocation=[6,3,1,0,10,0,10,0],
           role='重甲双手破甲主力', target='82血/125疲劳/52决心/94近攻/30近防；普通重甲壮实后58缓冲。生命6、疲劳3、决心1，不给范围爆发无限续航。')
    change('yangmiemie', attrs=[62,105,45,101,60,35,5,3], role='移动长柄与相邻疲劳接应',
           target='94血/85近攻/9近防；4点一级生命换近攻，保留后排掩护；铃铛带路回疲劳不返AP。')
    change('xiaojie', role='血牛轻甲前排与解网工具位', target='120裸血/150巨像/90近攻/37近防，疲劳88不升级；替代长柄与贴线双手分别配武器，独狼会与相邻支援冲突。')
    change('yanzi', role='后排长柄投掷多面手')
    change('xiaogui', role='无头盔特殊盾坦与阿飞近侧护卫', target='保留78裸血/73决心/38近防；头部、觉醒和龟壳规则独立，禁止套300头盔普通重甲模板。')
    for key in ['mocha','lili','tiantong','xiaoning']:
        change(key, allocation=[8,5,5,0,0,10,0,2], target='远攻仍每级投入；原4次远防缩为2次，改给生命与疲劳各1次。配装、掩护与撤离优先，远防不是全员固定4次。')
    change('mocha', role='远程支援队长与军需账房')
    change('lili', role='弓手连续点杀')
    change('tiantong', role='移动射击与后排接应')
    change('xiaoning', role='高命中单体弩手', endgame_weapon='重弩单体点杀+备用近战；专属单体远程加成不自动适用于火铳范围攻击。')
    change('manyuemei', attrs=[55,98,44,114,46,56,2,6], role='贴线集火投掷手', target='76血/96远攻/14近防；3点先攻换生命，红线集火区别转火玩法，投斧应对骷髅。')
    change('xiaoyueya', role='近距投掷转火手')
    change('bula', role='续航投掷与补给支持')
    change('yuxiang', role='重型后排长柄支点')
    for key in ['wangduidui','tongzhu','tutu']:
        change(key, allocation=[8,6,10,0,6,0,0,0], target='决心10次、生命8、疲劳6、近攻6；2次补刀培养改号令缓冲。号令5AP25疲劳，与个人主动技能竞争行动点；恢复耗9AP。')
    change('xiwen', allocation=[6,1,3,0,10,0,10,0], target='可选DLC轻甲恢复补位；70血/100疲劳/33本体决心、圆镜后53。1次生命和2次疲劳转决心，脱镜仍弱；恢复不免疫即时爆发。')

    # Specialize six existing passive masteries; replace their generic self +1.
    masteries = {
        'half_step':'11级：符合原先有效先攻与首次攻击条件时，命中加成由5增至7；不再额外恢复自身1疲劳。次数、目标与条件不变。',
        'lvbu_weapon':'11级：双手近战护甲伤害加成由10%增至12%；不再额外恢复自身1疲劳。不提高生命伤害或握把追加破甲。',
        'pang_breath':'11级：每轮首次受敌方直接武器命中并存活后，恢复由3增至4；不再额外恢复自身1疲劳。仍受每人每轮Mod额外恢复上限8约束。',
        'bell_lead':'11级：回合结束为一名相邻队员恢复由3增至4；不再额外恢复自身1疲劳。选人、每轮一次和受益者恢复上限8不变。',
        'breathe_easy':'11级：相邻队员躲过敌方单体武器攻击后恢复由4增至5；不再额外恢复自身1疲劳。仍每轮一次、每战累计最多20、恢复上限8。',
        'next_path':'11级：连续普通单体近战的下一次减耗由4增至5；不再额外恢复自身1疲劳。仍需前次命中，每轮一次，最终费用不低于原费用一半。',
    }
    for s in p['skills']:
        if s['key'] in masteries:
            s['mastery'] = masteries[s['key']]
            s['specialized_mastery'] = True
    p['endgame_revision'] = 1
    p['status'] = '2026-09-30终局岗位平衡修订；已实装至v0.28.4；离线检查另见endgame-balance，实战待验收。'
    numeric_changes = []
    for before, after in zip(old['people'], p['people']):
        assert before['key'] == after['key']
        assert sum(before['attrs']) == sum(after['attrs'])
        assert sum(before['stars'].values()) == sum(after['stars'].values())
        assert sum(after['allocation']) == 30
        for field in ['fixed_traits','growth_choices','growth_pick','growth_bonus','equipment','bag','wage','service_fee','suggested_price','day','battles','contracts','towns','highest_level','join_level','level_bonus_per_level']:
            assert before[field] == after[field], (after['key'], field)
        after['endgame_previous_attrs'] = before['attrs']
        fields = {f:{'before':before[f], 'after':after[f]} for f in ['attrs','stars','allocation','build','role','target','endgame_weapon','weakness','perks'] if before[f]!=after[f]}
        if fields:
            numeric_changes.append({'key':after['key'],'name':after['name'],'changes':fields})
    write(source,p)
    write(DESIGN / 'endgame-amendment-20260930.json', {
        'date':'2026-09-30','revision':1,'basis':'../endgame-role-plan-20260930.md',
        'before_proposal_sha256':hashlib.sha256(baseline.read_bytes()).hexdigest(),
        'after_proposal_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),
        'people':numeric_changes,'specialized_masteries':masteries,
        'constraints':'Each member keeps base attribute sum, total talent stars, 30 selections, fixed traits, story growth, recruitment, equipment and economy.'})
    print(f'Updated {len(numeric_changes)} role profiles and {len(masteries)} existing passive masteries; no base-sum or star-budget inflation.')

if __name__ == '__main__':
    apply()
