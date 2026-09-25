this.afei_cup_power <- this.inherit("scripts/skills/skill", {
 m={},
 function create() {this.m.ID="special.afei_cup_power";this.m.Name="调节看懂";this.m.Description="敲杯为号：在0至2层看懂之间切换，确认前不消耗。";this.m.Icon="skills/active_06.png";this.m.IconDisabled="skills/active_06_sw.png";this.m.Type=this.Const.SkillType.Active;this.m.IsActive=true;this.m.IsTargeted=false;this.m.IsAttack=false;this.m.IsSerialized=true;this.m.ActionPointCost=0;this.m.FatigueCost=0;},
 function isHidden() {local s=::AfeiExpedition.pendingSkill(this.getContainer().getActor());return s==null || s.m.AfeiKey!="cup_signal";},
 function isUsable() {return !this.isHidden();},
 function getTooltip() {return [{id=1,type="title",text=this.m.Name},{id=2,type="description",text=this.m.Description+"\n"+::AfeiExpedition.effectNames(this.getContainer().getActor())}];},
 function use(tile,free=false) {local A=::AfeiExpedition,a=this.getContainer().getActor();local s=A.pendingSkill(a);if(s==null || s.m.AfeiKey!="cup_signal")return false;s.m.Selection.extra=(s.m.Selection.extra+1)%(1+::Math.min(2,A.battleG(a,"understand")));a.setDirty(true);return true;}
});