// Fictional first-pass game writing; the photos establish appearance only.
local A = ::AfeixExpedition;
if ("xiwen" in A.Characters) throw "Xiwen is already registered by another content pack.";
A.CharacterOrder.push("xiwen");
A.Chapters.push({ id = 5, name = "DLC同行者", required = 1 });
A.Characters.xiwen <- {
    name = "希文", title = "远征团旅伴", isCaptain = false, hireCost = 280, wage = 9,
    background = "daytaler_background", role = "轻装剑盾，近攻与先攻成长",
    description = "希文把松开的浅蓝花饰别好，站在城门边看三位队长争论下一站。阿飞说走大路，抹茶先问路费，大谋已经替大家试过桥板。希文听完，指了指告示上写着的绕行日期：桥昨天就修好了。黑旗需要的也许不只是更响的主意，还得有人把眼前的小事看清。谈起同行，希文先问每天走多远、谁来守夜，再把自己的行囊放到长凳上。",
    attrs = [52, 97, 41, 111, 51, 36, 4, 3],
    stars = { MeleeSkill = 2, Initiative = 2, MeleeDefense = 1 },
    equipment = ["weapons/shortsword", "shields/buckler_shield", "armor/thick_tunic"],
    bag = [], chapter = 5,
    encounterTitle = "桥昨天就修好了",
    encounterText = "希文看了一眼阿飞脚边的狗。里根抬起头，尾巴在长凳边扫了两下。阿飞正想介绍黑旗的远大打算，希文先把水碗往阴凉里挪了挪：路可以慢慢讲，先让它喝口水。",
    encounterChoices = [
        { label = "把路程与工钱讲清楚", outcome = "希文听完安排，留下了同行的报价。", cost = 0, hireDiscount = 0 }
    ]
};
// Uses the base mod's FIFO and native hiring UI; does not bypass its three offers.
A.EncounterRequirements.xiwen <- { towns = 1 };
A.CharacterBackgrounds.xiwen <- {
    name = "细心的旅人",
    description = "希文靠短途护送和杂活攒下旅费，习惯把路上的细节记牢：井边有没有新脚印，桥板哪块松动，同行的人多久没喝水。浅蓝花饰是行囊里少有的不为赶路准备的东西。加入黑旗，是一次新的同行约定。"
};
A.MemberGrowth.xiwen <- {
    title = "这次由我开口",
    scene = "三次交锋后，希文发现自己总是等别人先说。今晚安排守夜，大谋和抹茶各执一词，阿飞正低头给里根理项圈。希文已经看清两条巡逻路线的漏洞。这回要怎样把自己的判断放到桌上？",
    choices = [
        { label = "把发现讲清楚，再一起定安排", outcome = "希文把两处漏点画在泥地上，等大家看完才继续说。阿飞挪过凳子，给地图让出了一块地方。", traitName = "看清再开口", bonuses = { Bravery = 3, MeleeDefense = 1 } },
        { label = "亲自走一遍，把路线试给大家看", outcome = "希文提灯绕营一周，回来把脚程和暗处一一讲明。下一班岗哨沿着重新划好的路线出发了。", traitName = "亲自走一程", bonuses = { Initiative = 3, Stamina = 2 } }
    ]
};
A.Endings.members.xiwen <- {
    good = "希文把走过的路绘成了一本小册子。有人来问黑旗如何闯过最难的关口，得到的回答却从一口井、一块桥板和一次认真听完的争论讲起。那朵浅蓝花饰仍别在发间，像许多个启程的早晨。",
    lean = "离开黑旗时，希文带走的行囊没有重多少，里面却多了几封能寄到熟人手里的信。偶尔有人相约走一段路，希文依然先问路程和守夜，再把自己的位置留给同行者。",
    memorial = "名册为希文留下一页。抹茶写下最后一笔工钱，大谋把那张标过桥板的草图折好；阿飞停了很久，才补上那句常听见的提醒：先看清眼前，再往前走。"
};
