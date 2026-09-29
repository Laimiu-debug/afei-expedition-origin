// Native wardog owns combat AI, return, death, item persistence and armor use.
this.afeix_regen_item <- this.inherit("scripts/items/accessory/wardog_item", {
    m = {},
    function create() {
        this.wardog_item.create();
        this.m.ID = "accessory.afeix_regen";
        this.m.Name = "里根儿";
        this.m.Description = "阿飞的战犬里根儿。赶路时爱绕着队伍撒欢，歇脚时总要挨着阿飞的靴子趴下。平日里一块肉干就能哄得尾巴打转，真有人冲向阿飞，它却比谁都先露出牙。他很怀念在环世界动物园中与飞碟一起度过的日子，一步一步，不忘来时路。";
    },
    function getName() { return this.isUnleashed() ? this.m.Name + "的项圈" : this.m.Name; },
    function getDescription() {
        return this.isUnleashed() ? "里根儿已经冲进战场，留下这条磨得发亮的旧项圈。铜扣上还有几道牙印，前头正传来它熟悉的犬吠。阿飞把绳头攥在手里，等那个爱蹭裤脚的小家伙回来。" : this.m.Description;
    }
});
