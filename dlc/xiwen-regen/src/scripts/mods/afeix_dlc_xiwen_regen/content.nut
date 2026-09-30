// Fictional first-pass game writing; the photos establish appearance only.
local A = ::AfeixExpedition;
if ("xiwen" in A.Characters) throw "Xiwen is already registered by another content pack.";
A.CharacterOrder.push("xiwen");
A.Chapters.push({ id = 5, name = "DLC同行者", required = 1 });
A.Characters.xiwen <- {
    name = "希文", title = "远征团旅伴", isCaptain = false, hireCost = 280, wage = 9,
    background = "daytaler_background", role = "轻装剑盾，近攻与先攻成长",
    description = "三位队长还在城门边争路，希文已经看完告示，指住角落的日期：“桥昨天修好了。”阿飞的大路、抹茶的路费和大谋试过的桥板，顿时都有了新说法。希文将浅蓝花饰别稳，问完每天走多远、谁来守夜，才把行囊放到凳上。路边的小事记得细，自己的安排也不肯漏；那面圆圆的化妆镜，出门前还得收好。",
    attrs = [52, 97, 41, 111, 51, 36, 4, 3],
    stars = { MeleeSkill = 2, Initiative = 2, MeleeDefense = 1 },
    equipment = ["weapons/shortsword", "shields/buckler_shield", "armor/thick_tunic"],
    bag = [], chapter = 5,
    encounterTitle = "桥昨天就修好了",
    encounterText = "驿站门前，三位队长对着旧告示各说各的路。希文认出黑旗，将沿途记下的桥梁和水源摆到桌上：“这座桥昨天就修好了，不用绕。”\n\n阿飞正要请人同行，希文先问工钱、守夜和下一站。安排说清，那面圆圆的化妆镜才收回行囊，浅蓝花饰也重新别稳。",
    encounterChoices = [
        { label = "说清路程、工钱与守夜安排", outcome = "希文逐项听完，将自己的同行报价留在桌边，又替地图添上那口沿途能用的井。阿飞再看旧告示，总算先找了找日期。", cost = 0, hireDiscount = 0 }
    ]
};
// Midgame unlock: all five table gates, then the base FIFO and native hiring UI.
A.EncounterRequirements.xiwen <- { days = 35, battles = 14, jobs = 5, towns = 6, level = 5 };
A.CharacterBackgrounds.xiwen <- {
    name = "细心的旅人",
    description = "短途护送和杂活攒出了希文的旅费。井边的新脚印、松动的桥板、同行者落下的一次饮水，都习惯记在小册里。浅蓝花饰也一直带着，启程前别稳它，再看一遍今天要走的路。"
};
A.MemberGrowth.xiwen <- {
    title = "这次由我开口",
    scene = "巡逻的两条路线摆在桌上，大谋和抹茶各执一词，希文却发现两边都漏了一处暗角。三次交锋过后，有些问题已经不能一直等别人先说。\n\n阿飞正低头给里根儿理项圈。希文将地图拉近，手边还放着可以提走的灯。",
    choices = [
        { label = "指出漏点，和大家一起重定路线", outcome = "希文将两处暗角画在泥地上，等队长们看清再接着讲。阿飞挪开凳子，把地图让到中间，这回先听完了希文的安排。", traitName = "看清再开口", bonuses = { Bravery = 3, MeleeDefense = 1 } },
        { label = "提灯走一遍，核清脚程和暗角", outcome = "希文提灯绕营一周，回来将脚程与暗处逐一标好。下一班岗哨沿着新线出发，转弯前也知道该往哪边再照一照。", traitName = "亲自走一程", bonuses = { Initiative = 3, Stamina = 2 } }
    ]
};
A.Endings.members.xiwen <- {
    good = "希文把沿途的路图编成小册，桥梁和水源逐页查过。有人来问黑旗最难的一仗，希文先讲那口差点错过的井，再讲几位队长如何争到天黑。浅蓝花饰仍别在发间，启程前，册子也总要翻一遍。",
    lean = "希文继续接短途护送，行囊没有添重多少，倒多了几封能寄给熟人的信。再有人相约同行，路程与守夜照旧先问清，出门前还要拿起圆镜，将花饰别回熟悉的位置。",
    memorial = "名册给希文留下一页，标过桥板的草图夹在里面。抹茶结好最后的工钱，大谋按记号折好纸角。阿飞翻到那口井的位置，才想起自己第一次肯低头查告示的日期，也是听见了希文那句话。"
};

// Base V2 implementation supplies fixed traits, books and mirror loadout.
A.applyBalanceDefinition("xiwen");
