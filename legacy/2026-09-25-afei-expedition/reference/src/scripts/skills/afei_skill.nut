this.afei_skill <- this.inherit("scripts/skills/skill", {
    m={AfeiKey="",Selection=null},
    function configure(key) {
        local d=::AfeiExpedition.SkillDefs[key];this.m.AfeiKey=key;this.m.ID="actives.afei_"+key;this.m.Name=d.name;
        this.m.Description=("description" in d && d.description!="")?d.description:(("flavor" in d && d.flavor!="")?d.flavor:d.text);
        // 有自定义图标（src/gfx/skills/afei_<key>.png）则优先，否则用原版兜底
        local hasArt=("Art" in ::AfeiExpedition) && ("skills" in ::AfeiExpedition.Art) && (key in ::AfeiExpedition.Art.skills);
        this.m.Icon=hasArt?("skills/afei_"+key+".png"):(d.active?"skills/active_06.png":"ui/perks/perk_01.png");this.m.IconDisabled=hasArt?this.m.Icon:"skills/active_06_sw.png";
        this.m.Type=d.active?this.Const.SkillType.Active:this.Const.SkillType.Special;this.m.Order=this.Const.SkillOrder.Any;
        this.m.IsActive=d.active;this.m.IsTargeted=d.target!="self";this.m.IsAttack=false;this.m.IsStacking=false;this.m.IsSerialized=true;
        this.m.IsUsingHitchance=false;this.m.IsIgnoredAsAOO=true;this.m.IsVisibleTileNeeded=true;
        this.m.ActionPointCost=d.ap;this.m.FatigueCost=d.fatigue;this.m.MinRange=0;this.m.MaxRange=d.range;this.m.MaxLevelDifference=0;
    },
    function getTooltip() {
        local d=::AfeiExpedition.SkillDefs[this.m.AfeiKey];
        local ret=[{id=1,type="title",text=this.m.Name},{id=2,type="description",text=this.m.Description}];
        if(this.m.IsActive) {
            ret.push({id=3,type="text",text=this.getCostString()});
            local hint=::AfeiExpedition.selectionHint(this);
            if(hint!="" && hint!="合法目标与成本全部确认后才扣费。")ret.push({id=4,type="text",icon="ui/icons/special.png",text=hint});
        }
        else if(d.world)ret.push({id=3,type="text",icon="ui/icons/special.png",text="世界地图按 F8 打开黑旗名册办理。"});
        if("effects" in d) {
            local id=10;
            foreach(line in d.effects) {
                ret.push({id=id,type="text",icon="ui/icons/special.png",text=line});
                id++;
            }
        }
        if(d.order)ret.push({id=90,type="text",icon="ui/icons/special.png",text="消耗 1 次团队号令"});
        if(d.cooldown>0)ret.push({id=91,type="text",icon="ui/icons/special.png",text="冷却 "+d.cooldown+" 轮"});
        if(d.limit>0)ret.push({id=92,type="text",icon="ui/icons/special.png",text="每战限 "+d.limit+" 次"});
        return ret;
    },
    function getActionPointCost() {if(this.m.AfeiKey=="unselectable" && ::AfeiExpedition.grown(this.getContainer().getActor()))return 3;return this.m.ActionPointCost;},
    function getFatigueCost() {return ::AfeiExpedition.actionFatigue(this.getContainer().getActor(),this.m.AfeiKey);},
    function getMaxRange() {if(this.m.AfeiKey=="breach_strike") {local s=::AfeiExpedition.basicAttack(this.getContainer().getActor());if(s!=null)return s.getMaxRange();}
return this.m.AfeiKey=="catch_baton" && ::AfeiExpedition.grown(this.getContainer().getActor())?3:this.m.MaxRange;},
    function isUsable() {return this.skill.isUsable() && ::AfeiExpedition.actionUsable(this.getContainer().getActor(),this.m.AfeiKey);},
    function onVerifyTarget(origin,tile) {return ::AfeiExpedition.actionTarget(this,this.getContainer().getActor(),tile);},
    function use(tile,forFree=false) {return ::AfeiExpedition.selectAction(this,this.getContainer().getActor(),tile);},
    function onCombatStarted() {this.m.Selection=null;},
    function onCombatFinished() {this.m.Selection=null;}
});
