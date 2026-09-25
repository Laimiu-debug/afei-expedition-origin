this.afei_rules <- this.inherit("scripts/skills/skill", {
    m={},
    function create() {this.m.ID="special.afei_rules";this.m.Name="黑旗协作";this.m.Description="本起源的号令、磨合与协作效果。";this.m.Icon="skills/status_effect_34.png";this.m.Type=this.Const.SkillType.Special;this.m.Order=this.Const.SkillOrder.Last;this.m.IsActive=false;this.m.IsHidden=false;this.m.IsSerialized=true;},
    function isHidden() {return !::Tactical.isActive();},
    function getTooltip() {return [{id=1,type="title",text=this.m.Name},{id=2,type="description",text=::AfeiExpedition.effectNames(this.getContainer().getActor())}];},
    function onUpdate(p) {::AfeiExpedition.properties(this.getContainer().getActor(),p);},
    function onTurnStart() {::AfeiExpedition.turnStart(this.getContainer().getActor());},
    function onTurnEnd() {::AfeiExpedition.turnEnd(this.getContainer().getActor());}
});
