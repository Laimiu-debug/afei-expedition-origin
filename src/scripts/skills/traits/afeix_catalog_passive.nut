this.afeix_catalog_passive <- this.inherit("scripts/skills/skill",{
    m={Key=""},
    function create(){this.m.ID="trait.afeix_catalog_pending";this.m.Type=this.Const.SkillType.Trait;this.m.IsActive=false;this.m.IsStacking=false;this.m.IsSerialized=true;},
    function configure(key){local d=::AfeixExpedition.MemberSkillDefs[key];this.m.Key=key;this.m.ID="trait.afeix_member_"+key;this.m.Name=d.name;this.m.Description=d.text;this.m.Icon="skills/afeix_member_"+key+".png"; this.m.IconMini = this.m.Icon;},
    function getDescription(){return ::AfeixExpedition.trainingDescription(this.getContainer()==null?null:this.getContainer().getActor(),this.m.Key);},
    function getTooltip(){return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()}];},
    function enabled(){local A=::AfeixExpedition;return A.isOrigin()&&::Tactical.isActive()&&A.memberPlayer(this.getContainer().getActor())&&A.catalogLearned(this.getContainer().getActor(),this.m.Key);},
    function onUpdate(p){if(!this.enabled())return;local A=::AfeixExpedition,a=this.getContainer().getActor();A.catalogPassiveStats(a,this.m.Key,p);},
    function onBeingAttacked(a,s,p){if(this.enabled())::AfeixExpedition.catalogPassiveDefense(this.getContainer().getActor(),this.m.Key,a,s,p);},
    function onSerialize(out){this.skill.onSerialize(out);out.writeString(this.m.Key);},
    function onDeserialize(input){this.skill.onDeserialize(input);this.configure(input.readString());}
});
