this.afeix_endurance <- this.inherit("scripts/skills/skill",{
    m={},
    function create(){this.m.ID="trait.afeix_endurance";this.m.Name="远征耐力";this.m.Description="2～11级每级疲劳上限+3，最多+30；不占升级选点，装备负重另扣。";this.m.Icon="ui/icons/fatigue.png";this.m.IconMini=this.m.Icon;this.m.Type=this.Const.SkillType.Trait;this.m.IsActive=false;this.m.IsStacking=false;this.m.IsSerialized=true;},
    function getTooltip(){return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()}];},
    function onUpdate(p){
        local A=::AfeixExpedition,a=this.getContainer().getActor(),key=A.characterId(a);
        if(A.isOrigin()&&key in A.BalanceV26.people)
            p.Stamina+=A.BalanceV26.people[key].level_bonus_per_level[1]*::Math.max(0,::Math.min(10,a.getLevel()-1));
    }
});
