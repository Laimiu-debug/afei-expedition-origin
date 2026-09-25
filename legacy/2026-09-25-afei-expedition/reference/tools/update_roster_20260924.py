"""Retire 川神 from new campaigns and add three playable women.

The old C11 background and its three skill scripts stay packaged for existing saves.
Run before apply_flavor.py when rebuilding the generated definitions.
"""
from pathlib import Path
import json
import sys

root = Path(__file__).resolve().parents[1]
doc_path = root / "data/document-v0.6.2.json"
flavor_path = root / "data/flavor-v0.6.2.json"
equipment_path = root / "data/equipment.json"
doc = json.loads(doc_path.read_text(encoding="utf-8"))
flavor = json.loads(flavor_path.read_text(encoding="utf-8"))
equipment = json.loads(equipment_path.read_text(encoding="utf-8"))

if "C11" not in doc:
    if {"C32", "C33", "C34"}.issubset(doc):
        print("Roster update already applied")
        sys.exit(0)
    raise SystemExit("C11 is absent but the new roster is incomplete")

old = doc.pop("C11")
flavor.pop("C11")
equipment.pop("C11")

def skill(sid, name, kind, rules, short, effects):
    return {"id": sid, "name": name, "kind": kind, "text": rules,
            "source": "NEW20260924", "flavor": short, "effects": effects}

def character(cid, name, attrs, stars, wage, equipment_text, background,
              skills, growth, recruit, day, contracts, fee, requires,
              title, blurb, story, ending):
    doc[cid] = {"id": cid, "name": name, "attrs": attrs, "stars": stars,
        "wage": wage, "equipment_text": equipment_text, "background": background,
        "story": story, "skills": skills, "growth_text": growth,
        "recruit_id": recruit, "day": day, "contracts": contracts,
        "fee": fee, "requires_m": requires, "cohesion": 0,
        "title": title, "blurb": blurb, "good_ending": ending,
        "bad_ending": "黑旗名册在这一行留下了空白。"}
    flavor[cid] = {"title": title, "blurb": blurb, "story": story,
        "good_ending": ending, "bad_ending": doc[cid]["bad_ending"],
        "skills": {s["id"]: {"flavor": s["flavor"], "effects": s["effects"]} for s in skills}}

# 小宁接下蓝旗护送后的阵线位置。沿用原 C11 三项技能的脚本，使旧存档仍能加载。
ning_skills = []
for s in old["skills"]:
    item = dict(s)
    item["source"] = "NEW20260924"
    item["text"] = item["text"].replace("川神", "持有者")
    ning_skills.append(item)
character("C32", "小宁", [53, 98, 54, 103, 54, 37, 5, 4],
    {"Fatigue": 2, "Bravery": 2, "MeleeSkill": 3}, 18,
    "初始装备：草叉；身甲65、头盔30。", "afei_c32_background", ning_skills,
    "G32 阵线留给后来人：5级，以代理身份赢得3场战斗，其中2场使用稳一手；再完成2次营地复盘。稳一手目标上限增至5人。",
    "R08", 25, 8, 800, ["M04Done"], "蓝旗的排阵人",
    "她先数车轮，再数人。队形图上总留一条能让后来人跟上的路。",
    "小宁曾替蓝旗商团排路。一次护送中，前车陷进沟里，后队却照着旧图继续走，差点把伤员落在雪地。她从此把空白留在图上，遇到坏路就让脚下的人先说话。黑旗与蓝旗同行时，她没有急着发令，只问大谋谁还没跟上。仗后她把图摊在火边，让每个站过前排的人补上一笔。阿飞问她要不要把名字写进黑旗，她把图卷起，说先等这趟车平安到站。",
    "小宁把旧队形图留在驿站，背面写着每个帮她改过路线的名字。")
equipment["C32"] = {"equipped": ["weapons/pitchfork", "armor/gambeson", "helmets/hood"], "bag": [], "document_armor": [65, 30]}

pang_skills = [
    skill("pang_anchor", "站得住", "持盾被动",
        "持盾且邻接至少一名可行动友军时，自身近防＋4。离开队友身边立即失效；不增加护甲或生命。",
        "有人在身旁，她就把盾边再压稳一点。", ["持盾且贴近队友：自身近防＋4"]),
    skill("pang_share", "借你半面盾", "主动护卫",
        "3行动点、12疲劳、冷却两轮。指定相邻一名可行动友军，使其近防＋4、决心＋4，持续至下轮结束；重复施放刷新持续时间，不叠加。成长后近防提升至＋6。",
        "盾不是借走，是两个人一起顶。", ["邻接友军获得近防与决心加成", "成长后近防由＋4升至＋6"]),
    skill("pang_breath", "挨过这一口", "受击被动",
        "每轮首次被单体武器攻击命中后，若仍可行动，恢复3点已积累疲劳。受黑旗每人每轮20点恢复上限约束；未命中或持续伤害不触发。",
        "她把那一口气缓过来，才肯让身后的人换位。", ["每轮首次被武器命中且仍可行动：恢复3疲劳"]),
]
character("C33", "小胖", [67, 109, 47, 82, 52, 28, 5, 0],
    {"Hitpoints": 2, "Fatigue": 2, "MeleeDefense": 2}, 16,
    "初始装备：短斧与木盾；身甲75、头盔35。", "afei_c33_background", pang_skills,
    "G33 盾后还有人：5级，亲自参与5场胜利，其中3场用借你半面盾护住受攻击的伙伴。成长后借你半面盾的近防加成升至＋6。",
    "R29", 32, 10, 600, ["M04Done"], "守车的盾手",
    "卸车时她总留到最后，盾举起来时也一样。",
    "小胖在驿站守过粮车。比起抢头功，她更记得哪辆车的绳索松了、谁在夜里咳得厉害。有回一队护卫追着贼跑远，她留在车旁挡住了从侧路摸来的第二拨人。清点时少了一袋麦子，她承认自己没看住；同伴却说，没有她，整辆车都回不来。黑旗帮蓝旗卸完货，她看见大鹅忙着数箱、小虎忙着点人，便把盾靠在门边，问还缺不缺一个肯守到最后的人。",
    "小胖把磨旧的木盾挂在驿站门口，后来的人都知道那里有人肯等他们回来。")
equipment["C33"] = {"equipped": ["weapons/hatchet", "armor/padded_leather", "helmets/aketon_cap", "shields/wooden_shield"], "bag": [], "document_armor": [75, 35]}

berry_skills = [
    skill("berry_eye", "看清缝隙", "远攻被动",
        "对邻接至少一名友军的敌人进行普通单体远程武器攻击时，每轮首次命中检定获得远攻＋5。攻击尝试即耗掉本轮机会；不作用于范围攻击。",
        "前排挡住刀口，她看见盾沿露出的那一点空隙。", ["队友贴住目标时，每轮首次普通远程攻击远攻＋5"]),
    skill("berry_mark", "红线记号", "主动标记",
        "3行动点、10疲劳、冷却两轮。标记四格内一名可见敌人，持续两轮；下一次友军单体远程武器攻击对其远攻＋8，尝试后无论命中与否清除。蔓越莓同时只能保留一个记号。",
        "她在木板上画一条红线，提醒后排往哪儿看。", ["标记可见敌人：下一次友军远程攻击远攻＋8"]),
    skill("berry_reserve", "留一支给后面", "协作被动",
        "本人每轮首次普通远程武器攻击命中邻接友军的敌人后，恢复2点已积累疲劳。受黑旗每人每轮20点恢复上限约束；未命中不触发。",
        "最后一支箭留在弦边，下一步才不会慌。", ["配合前排命中时，每轮一次恢复2疲劳"]),
]
character("C34", "蔓越莓", [50, 91, 43, 108, 42, 54, 1, 5],
    {"Initiative": 2, "RangedSkill": 3, "RangedDefense": 1}, 17,
    "初始装备：猎弓、备用短刀；身甲45、头盔20。", "afei_c34_background", berry_skills,
    "G34 箭留在队伍里：5级，亲自参与5场胜利，其中3场由队友射击她的红线记号。成长后红线记号持续时间增至3轮。",
    "R30", 45, 14, 720, ["M05Done"], "驿路上的弓手",
    "箭囊扎着一段红线；她总等前排站稳才拉弓。",
    "蔓越莓替商队望过路，也给守夜的人留过箭。她不爱争谁先射中，常在车板上画一道红线，让后排知道前面哪处不能误伤。一次山路遇袭，护卫抢着追敌，她却守住回程的窄口，等最后一辆车拐过弯才收弓。黑旗在旧驿站遇见她时，箭囊只剩几支，她仍把其中一支递给没有备用箭的陌生弓手。抹茶问她要多少薪水，她先问队伍会不会等掉队的人。",
    "蔓越莓把那段红线系在新的路牌上，后来的人顺着它找到了归队的方向。")
equipment["C34"] = {"equipped": ["weapons/hunting_bow", "armor/padded_surcoat", "helmets/headscarf", "ammo/quiver_of_arrows"], "bag": ["weapons/knife"], "document_armor": [45, 20]}

for cid in ("C12", "C13"):
    doc[cid]["story"] = doc[cid]["story"].replace("川神", "小宁")
    flavor[cid]["story"] = flavor[cid]["story"].replace("川神", "小宁")

# Keep roster order by character number for summaries and generated definitions.
doc = dict(sorted(doc.items()))
flavor = dict(sorted(flavor.items()))
equipment = dict(sorted(equipment.items()))
assert len(doc) == 32 and all(k in flavor and k in equipment for k in doc)
for path, value in ((doc_path, doc), (flavor_path, flavor), (equipment_path, equipment)):
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print("Roster now:", len(doc), "characters; retired C11; added C32-C34")
