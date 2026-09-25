from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
for key,name,desc,body in [
 ('confirm','确认选择','全部目标与落点合法后，统一支付原技能费用。','return A.confirmSelection(a);'),
 ('cancel','取消选择','清空当前选择，不支付资源或使用次数。','A.cancelSelections(a);a.setDirty(true);return true;'),
 ('cup_power','调节看懂','敲杯为号：在0至2层看懂之间切换，确认前不消耗。','local s=A.pendingSkill(a);if(s==null || s.m.AfeiKey!="cup_signal")return false;s.m.Selection.extra=(s.m.Selection.extra+1)%(1+::Math.min(2,A.battleG(a,"understand")));a.setDirty(true);return true;')]:
 p=ROOT/'src/scripts/skills/special'/f'afei_{key}.nut'
 p.write_text(f'''this.afei_{key} <- this.inherit("scripts/skills/skill", {{
 m={{}},
 function create() {{this.m.ID="special.afei_{key}";this.m.Name="{name}";this.m.Description="{desc}";this.m.Icon="skills/active_06.png";this.m.IconDisabled="skills/active_06_sw.png";this.m.Type=this.Const.SkillType.Active;this.m.IsActive=true;this.m.IsTargeted=false;this.m.IsAttack=false;this.m.IsSerialized=true;this.m.ActionPointCost=0;this.m.FatigueCost=0;}},
 function isHidden() {{local s=::AfeiExpedition.pendingSkill(this.getContainer().getActor());return s==null{(' || s.m.AfeiKey!="cup_signal"' if key=='cup_power' else '')};}},
 function isUsable() {{return !this.isHidden();}},
 function getTooltip() {{return [{{id=1,type="title",text=this.m.Name}},{{id=2,type="description",text=this.m.Description+"\\n"+::AfeiExpedition.effectNames(this.getContainer().getActor())}}];}},
 function use(tile,free=false) {{local A=::AfeiExpedition,a=this.getContainer().getActor();{body}}}
}});''',encoding='utf-8')
print('Generated selection controls')
