::AfeixEventsDLC.register({
    id = "mocha_river_song",
    place = "road",
    title = "一条大河",
    text = "午夜抹抹茶曾经说话很聪明，但是他自从得了阿尔兹海默症后，经常说一些别人听不懂的话，除了那句歌词：一条大河～波浪宽～，大伙知道，这是他最爱唱的歌。",
    minDay = 3,
    members = ["mocha"],
    weight = 5,
    cooldownDays = 8.0,
    once = false,
    condition = function() { return ::AfeixEventsDLC.nearEnemyCamp(); },
    choices = [
        { text = "听抹茶唱歌。（全队心情 +0.1）",
            outcome = "你们听抹茶唱完了这首他最爱唱的歌。全队心情 +0.1。",
            apply = function(event) {
                ::AfeixEventsDLC.changeMood(::AfeixExpedition.roster(), 0.1, "听午夜抹抹茶唱歌");
            }
        }
    ]
});
