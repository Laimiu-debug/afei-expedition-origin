this.afei_confirm <- this.inherit("scripts/skills/skill", {
 m={},
 function create() {this.m.ID="special.afei_confirm";this.m.Name="确认选择";this.m.Description="全部目标与落点合法后，统一支付原技能费用。";this.m.Icon="skills/active_06.png";this.m.IconDisabled="skills/active_06_sw.png";this.m.Type=this.Const.SkillType.Active;this.m.IsActive=true;this.m.IsTargeted=false;this.m.IsAttack=false;this.m.IsSerialized=true;this.m.ActionPointCost=0;this.m.FatigueCost=0;},
 function isHidden() {local s=::AfeiExpedition.pendingSkill(this.getContainer().getActor());return s==null;},
 function isUsable() {return !this.isHidden();},
 function getTooltip() {return [{id=1,type="title",text=this.m.Name},{id=2,type="description",text=this.m.Description+"\n"+::AfeiExpedition.effectNames(this.getContainer().getActor())}];},
 function use(tile,free=false) {local A=::AfeiExpedition,a=this.getContainer().getActor();return A.confirmSelection(a);}
});