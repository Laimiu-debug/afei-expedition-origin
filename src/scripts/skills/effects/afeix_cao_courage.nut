this.afeix_cao_courage <- this.inherit("scripts/skills/skill",{
    m={Turns=2},
    function create(){this.m.ID="effects.afeix_cao_courage";this.m.Name="气氛到这儿了";this.m.Description="曹飞派的鼓舞：决心 +20，持续两个自己的回合。与已有临时决心增益只补差额；等待不缩短持续时间。";this.m.Icon="skills/afeix_haoqi.png";this.m.IconMini=this.m.Icon;this.m.Type=this.Const.SkillType.StatusEffect;this.m.IsActive=false;this.m.IsStacking=false;this.m.IsSerialized=true;this.m.IsRemovedAfterBattle=true;},
    function getTooltip(){return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()+" 剩余回合："+this.m.Turns}];},
    function onUpdate(p){if(::AfeixExpedition.isOrigin()&&::Tactical.isActive()&&this.m.Turns>0)p.Bravery+=::AfeixExpedition.ideaCourageContribution(this.getContainer().getActor());},
    function onTurnEnd(){if(--this.m.Turns<=0)this.removeSelf();},
    function onSerialize(out){this.skill.onSerialize(out);out.writeU8(this.m.Turns);},
    function onDeserialize(input){this.skill.onDeserialize(input);this.m.Turns=input.readU8();}
});
