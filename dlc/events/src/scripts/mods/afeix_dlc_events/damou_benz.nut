::AfeixEventsDLC.register({
    id = "damou_benz",
    place = "road",
    title = "谁要奔驰",
    text = "王大谋本是率真的男儿，只因一段尘封的往事，引发了他渴望给别人送奔驰车的欲望。\n\n在路上偶遇一位妙龄女子，吸引了王大谋的注意，他渴望与这个女孩交往。",
    minDay = 31,
    members = ["damou"],
    weight = 5,
    cooldownDays = 8.0,
    once = false,
    condition = function() { return ::AfeixEventsDLC.onDeliveryJourney(); },
    choices = [
        { text = "放任不管。（战团金币 -119；王大谋心情 +0.2）",
            outcome = "你放任王大谋追求这位女孩。战团失去 119 金币，王大谋心情 +0.2。",
            canChoose = function(event) {
                return ::World.Assets.getMoney() >= 119 && ::AfeixEventsDLC.onDeliveryJourney();
            },
            apply = function(event) {
                ::AfeixEventsDLC.changeMood([::AfeixExpedition.findCharacter("damou")], 0.2, "获准追求路上偶遇的女孩", 119);
            }
        },
        { text = "制止他。（王大谋心情 -0.2）",
            outcome = "你制止了王大谋。王大谋心情 -0.2。",
            canChoose = function(event) { return ::AfeixEventsDLC.onDeliveryJourney(); },
            apply = function(event) {
                ::AfeixEventsDLC.changeMood([::AfeixExpedition.findCharacter("damou")], -0.2, "被制止追求路上偶遇的女孩");
            }
        }
    ]
});
