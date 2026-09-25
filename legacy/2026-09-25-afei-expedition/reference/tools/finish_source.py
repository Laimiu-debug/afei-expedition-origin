"""Generate document backgrounds, scenario and narrow native calculation adapters."""
from pathlib import Path
import json
import re
ROOT=Path(__file__).resolve().parents[1]
SRC=ROOT/'src'
NATIVE=ROOT.parents[1]/'app/build/full-l10n/decompiled'
D=json.loads((ROOT/'data/document-v0.6.2.json').read_text(encoding='utf-8'))
def put(path,text):
 p=SRC/path;p.parent.mkdir(parents=True,exist_ok=True);p.write_text(text,encoding='utf-8')
def q(s):return json.dumps(s,ensure_ascii=False)

# Work only on the extracted development copy. The supplied ZIP remains untouched.
for folder,keep in [('scripts/events/events',{'afei_ledger_event.nut'}),('scripts/contracts/contracts',{'afei_journey_contract.nut'}),('scripts/skills/effects',set())]:
 for p in (SRC/folder).rglob('*.nut'):
  if p.name not in keep and p.resolve().is_relative_to(SRC.resolve()):p.unlink()
for rel in ['scripts/skills/actives/afei_cohesion_rule.nut','scripts/skills/actives/afei_ecig_puff.nut','scripts/items/accessory/afei_ecig_item.nut','scripts/items/accessory/afei_bicycle_item.nut','scripts/entity/world/locations/afei_blue_ambush_location.nut','scripts/entity/tactical/humans/afei_blue_guard.nut']:
 (SRC/rel).unlink(missing_ok=True)

weapons={
'C01':'bludgeon','C02':'hunting_bow','C03':'boar_spear','C04':'shortsword','C05':'hunting_bow','C06':'boar_spear','C07':'javelin','C08':'boar_spear','C09':'bludgeon','C10':'boar_spear','C11':'pitchfork','C12':'hunting_bow','C13':'hatchet','C14':'boar_spear','C15':'javelin','C16':'shortsword','C17':'light_crossbow','C18':'pitchfork','C19':'javelin','C20':'fighting_spear','C21':'shortsword','C22':'bludgeon','C23':'boar_spear','C25':'arming_sword','C26':'boar_spear','C27':'billhook','C28':'shortsword','C29':'shortsword','C30':'boar_spear','C31':'javelin'}
armor={35:'thick_tunic',40:'thick_tunic',45:'padded_surcoat',50:'padded_surcoat',55:'ragged_surcoat',60:'ragged_dark_surcoat',65:'gambeson',70:'blotched_gambeson',75:'padded_leather',80:'padded_leather'}
helm={20:'headscarf',25:'hood',30:'hood',35:'aketon_cap',40:'aketon_cap',45:'full_leather_cap'}
equipment={}
for cid,d in D.items():
 body,head=map(int,re.search(r'身甲(\d+)、头盔(\d+)',d['equipment_text']).groups())
 equip=['weapons/'+weapons[cid],'armor/'+armor[body],'helmets/'+helm[head]]
 bag=[]
 if '盾' in d['equipment_text']:equip.append('shields/buckler_shield' if '小' in d['equipment_text'].split('盾')[0][-3:] else 'shields/wooden_shield')
 if '备用短刀' in d['equipment_text']:bag.append('weapons/knife')
 if '备用短矛' in d['equipment_text']:bag.append('weapons/boar_spear')
 if weapons[cid]=='hunting_bow':equip.append('ammo/quiver_of_arrows')
 if weapons[cid]=='light_crossbow':equip.append('ammo/quiver_of_bolts')
 if cid=='C09':equip.append('accessory/afei_drum_item')
 if cid=='C18':equip.append('accessory/afei_bear_item')
 equipment[cid]={'equipped':equip,'bag':bag,'document_armor':[body,head]}
 existing=SRC/'scripts/skills/backgrounds'/f"{d['background']}.nut"
 old=existing.read_text(encoding='utf-8')
 faces='AllFemale' if 'AllFemale' in old else 'AllMale'
 for item in equip+bag:
  assert item.startswith('accessory/afei_') or (NATIVE/'scripts/items'/f'{item}.nut').exists(),item
 lines='\n'.join(f'        items.equip(this.new("scripts/items/{item}"));' for item in equip)
 lines+='\n'+'\n'.join(f'        items.addToBag(this.new("scripts/items/{item}"));' for item in bag)
 put(existing.relative_to(SRC),f'''this.{d['background']} <- this.inherit("scripts/skills/backgrounds/character_background", {{
 m={{}},
 function create() {{
   this.character_background.create();this.m.ID="background.{d['background'].removesuffix('_background')}";this.m.Name={q(d['name']+' · 黑旗伙伴')};
   this.m.Icon="ui/backgrounds/background_15.png";this.m.BackgroundDescription={q(d['story'])};this.m.GoodEnding="把名字留在下一封信里。";this.m.BadEnding="黑旗名册留下了这一行。";
   this.m.HiringCost=0;this.m.DailyCost={d['wage']};this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.{faces};this.m.Hairs=this.Const.Hair.{faces};this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.{"Female" if faces=="AllFemale" else "Muscular"};
 }},
 function onBuildDescription() {{return this.m.BackgroundDescription;}},
 function onChangeAttributes() {{return {{Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}};}},
 function onAddEquipment() {{local items=this.getContainer().getActor().getItems();
{lines}
 }}
}});
''')
(ROOT/'data/equipment.json').write_text(json.dumps(equipment,ensure_ascii=False,indent=2),encoding='utf-8')
for key,name in [('drum','腰鼓饰物'),('bear','木熊饰物')]:
 put(f'scripts/items/accessory/afei_{key}_item.nut',f'''this.afei_{key}_item <- this.inherit("scripts/items/accessory/accessory", {{function create() {{this.accessory.create();this.m.ID="accessory.afei_{key}";this.m.Name="{name}";this.m.Description="伙伴随身的纪念物；技能来自本人，不随饰物转交。";this.m.Icon="loot/inventory_loot_09.png";this.m.Value=0;this.m.SlotType=this.Const.ItemSlot.Accessory;}}}});''')

original=(ROOT.parents[1]/'output/research/afei-implementation-audit-20260920/mod_source/scripts/scenarios/world/afei_expedition_scenario.nut').read_text(encoding='utf-8')
spawn=original[original.index('\tfunction onSpawnPlayer()'):original.index('\tfunction onInit()')]
spawn=spawn.replace('event.afei_expedition_scenario_intro','event.afei_ledger')
put('scripts/scenarios/world/afei_expedition_scenario.nut','''this.afei_expedition_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
 m={},
 function create() {this.m.ID="scenario.afei_expedition";this.m.Name="大飞午远征团";this.m.Description="[p]阿飞、抹茶、王大谋从烟港上路。按黑旗名册的试训与邀请结识30名伙伴，完成各自成长。[/p][p]世界地图 F8 打开名册：招募、主线、营地与战前代理。每战12人；团队号令共用2次，每轮1次。阿飞身故后仍可继续残旗故事。[/p]";this.m.Difficulty=2;this.m.Order=86;this.m.IsFixedLook=true;},
 function isValid() {return true;},
 function onSpawnAssets() {
   local A=::AfeiExpedition;A.makeBrother("C01",12);A.makeBrother("C02",13);A.makeBrother("C03",3);A.sw("selected_proxy","C03");
   this.World.Assets.m.BusinessReputation=0;this.World.Assets.m.Money=1800;this.World.Assets.m.ArmorParts=30;this.World.Assets.m.Medicine=15;this.World.Assets.m.Ammo=25;
   local stash=this.World.Assets.getStash();stash.resize(stash.getCapacity()+9);
   foreach(i in this.World.Assets.getFoodItems())stash.remove(i);
   local food=this.new("scripts/items/supplies/ground_grains_item");food.setAmount(25);stash.add(food);food=this.new("scripts/items/supplies/ground_grains_item");food.setAmount(30);stash.add(food);
   stash.add(this.new("scripts/items/weapons/legendary/banner"));this.World.Assets.updateFood();A.sw("cohesion",25);A.sw("cohesion_peak",25);A.sw("schema",A.Schema);
 },
'''+spawn+'''
 function onInit() {this.World.Assets.m.BrothersMax=::AfeiExpedition.w("camp_enabled")?39:20;this.World.Assets.m.BrothersMaxInCombat=12;},
 function onCombatFinished() {if(::AfeiExpedition.named("C01")==null)::AfeiExpedition.sw("captain_dead",true);return true;},
 function onUpdateLevel(b) {::AfeiExpedition.tryAwakenAfei();}
});
''')
put('scripts/entity/tactical/enemies/afei_frost_unhold.nut','''this.afei_frost_unhold <- this.inherit("scripts/entity/tactical/enemies/unhold_frost", {
 function create() {this.unhold_frost.create();this.m.Name="北境白影";},
 function onInit() {this.unhold_frost.onInit();this.getFlags().set("afei_frost_unhold",true);}
});''')
put('scripts/entity/world/locations/afei_frost_shadow_location.nut','''this.afei_frost_shadow_location <- this.inherit("scripts/entity/world/locations/bandit_camp_location", {
 function create() {this.bandit_camp_location.create();this.m.TypeID="location.afei_frost_shadow";this.m.Name="北境白影巢穴";this.m.IsDespawningDefenders=false;this.m.CombatLocation.Fortification=this.Const.Tactical.FortificationType.None;this.m.CombatLocation.Template[0]="tactical.enemies";},
 function getDescription() {return "白色巨兽留下的脚印通向这里。可以侦察后离开，再带准备充分的队伍回来。";},
 function onSpawned() {this.location.onSpawned();this.m.Name="北境白影巢穴";this.createDefenders();},
 function createDefenders() {
   if(this.getFlags().get("afei_fixed_roster"))return;this.getFlags().set("afei_fixed_roster",true);this.m.Troops.clear();
   local target=clone this.Const.World.Spawn.Troops.UnholdFrost;target.Script="scripts/entity/tactical/enemies/afei_frost_unhold";this.Const.World.Common.addTroop(this,{Type=target});
   local levels=0,n=0;foreach(b in ::AfeiExpedition.roster())if(!::AfeiExpedition.g(b,"camped")){levels+=b.getLevel();n++;}
   local guards=n>0 && levels.tofloat()/n>=10?2:1;for(local i=0;i<guards;i++)this.Const.World.Common.addTroop(this,{Type=this.Const.World.Spawn.Troops.Unhold});
 },
 function onDropLootForPlayer(loot) {this.location.onDropLootForPlayer(loot);}
});''')

def extract_method(text,name):
 start=text.index('\tfunction '+name+'(') if '\tfunction '+name+'(' in text else text.index('\tfunction '+name+' (')
 opening=text.index('{',start);depth=0;quote=False;escape=False
 for i in range(opening,len(text)):
  c=text[i]
  if quote:
   if escape:escape=False
   elif c=='\\':escape=True
   elif c=='"':quote=False
  elif c=='"':quote=True
  elif c=='{':depth+=1
  elif c=='}':
   depth-=1
   if depth==0:return text[start:i+1]
 raise ValueError(name)
actor=(NATIVE/'scripts/entity/tactical/actor.nut').read_text(encoding='utf-8')
methods=[]
for name in ['onDamageReceived','checkMorale']:
 code=extract_method(actor,name)
 if name=='onDamageReceived':
  needle='\t\t_hitInfo.DamageInflictedHitpoints = damage;'
  assert needle in code
  code=code.replace(needle,'\t\tif (::AfeiExpedition.isAfeiOrigin()) damage = ::AfeiExpedition.lifeDamage(this, _attacker, _skill, damage);\n'+needle)
 else:
  code=code.replace('local numOpponentsAdjacent = 0;','if (::AfeiExpedition.isAfeiOrigin() && _type == this.Const.MoraleCheckType.MentalAttack && ::AfeiExpedition.has(this, "not_tricked")) bravery += 15;\n\t\tlocal numOpponentsAdjacent = 0;')
  code=code.replace('local oldMoraleState = this.m.MoraleState;','if (_change < 0 && ::AfeiExpedition.isAfeiOrigin() && ::AfeiExpedition.ignoreMoraleFailure(this)) return false;\n\t\tlocal oldMoraleState = this.m.MoraleState;')
 methods.append(code.replace('function '+name+'(', 'o.'+name+' = function(',1)+';')
put('scripts/mods/afei/native_adapters.nut','// Original 1.5.2.3 calculation order, with isolated post-armor and failed-check extension points.\n::mods_hookExactClass("entity/tactical/actor", function(o) {\n'+'\n'.join(methods)+'\n});\n')
print('Generated 30 backgrounds, fixed scenario, frost target and native adapters')
