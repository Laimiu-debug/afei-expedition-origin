this.afeix_cao_bleeding <- this.inherit("scripts/skills/effects/bleeding_effect",{
    m={},
    function create(){this.bleeding_effect.create();this.m.Name="热血的代价";this.m.IsSerialized=true;this.m.TurnsLeft=2;this.m.Damage=5;this.m.LastRoundApplied=-1;},
    function getDescription(){return "曹飞派把气氛带起来了，阿飞把手拍破了。自己的回合结束时受到 5 点基础流血伤害，共两次；可用原版包扎移除，等待不结算。剩余次数："+this.m.TurnsLeft;},
    function onAdded(){},
    function onWaitTurn(){},
    function onSerialize(out){this.skill.onSerialize(out);out.writeU8(this.m.TurnsLeft);out.writeI32(this.m.LastRoundApplied);},
    function onDeserialize(input){this.skill.onDeserialize(input);this.m.TurnsLeft=input.readU8();this.m.LastRoundApplied=input.readI32();}
});
