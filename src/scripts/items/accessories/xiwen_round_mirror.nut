this.xiwen_round_mirror <- this.inherit("scripts/items/accessory/accessory",{
    m={},
    function create(){
        this.accessory.create();this.m.ID="accessory.xiwen_round_mirror";this.m.Name="希文的圆圆化妆镜";
        this.m.Description="一面圆圆的小镜子。希文出发前总要照一照，把没说出口的忐忑收好。只有希文装备在饰品栏时，决心+20。";
        this.m.Icon="accessory/xiwen_round_mirror.png";this.m.IconLarge="";this.m.AddGenericSkill=false;this.m.ShowOnCharacter=false;this.m.IsSellable=false;this.m.IsDroppedAsLoot=true;this.m.Value=0;
    },
    function getTooltip(){return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="image",image=this.getIcon()},{id=10,type="text",icon="ui/icons/bravery.png",text="希文专属：饰品栏装备时决心+20，无负重；背包、仓库与其他人物均无加成。"}];},
    function onUpdateProperties(p){
        this.accessory.onUpdateProperties(p);
        local c=this.getContainer();if(c==null)return;local a=c.getActor();
        if(a!=null&&::AfeixExpedition.isOrigin()&&::AfeixExpedition.characterId(a)=="xiwen"&&c.getItemAtSlot(this.Const.ItemSlot.Accessory)==this)p.Bravery+=20;
    },
    function playInventorySound(eventType){this.Sound.play("sounds/cloth_01.wav",this.Const.Sound.Volume.Inventory);}
});
