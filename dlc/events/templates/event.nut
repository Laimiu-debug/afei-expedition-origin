// Development template ONLY. This directory is excluded from the runtime ZIP.
// Copy to src/scripts/mods/afeix_dlc_events/<id>.nut, author the scene, then add
// <id> to content.nut's include list. Never reuse an ID for a different story.
// Follow AGENTS.md. condition/canChoose must be read-only and must never call
// pool/resolve, fire another event, schedule a retry, or mutate shared Mod state.
::AfeixEventsDLC.register({
    id = "replace_with_unique_id",
    place = "road", // road: travelling; tavern: inside the tavern; either: both
    title = "填写事件标题",
    text = "填写相遇的起因、人物和现场。",
    minDay = 3,
    members = [], // Stable character keys, e.g. ["afei", "xiaogui"]
    weight = 5, // Relative event weight; never an absolute road probability
    cooldownDays = 8.0,
    once = false,
    // condition = function() { return ::AfeixExpedition.get("your_story_flag", false); },
    choices = [
        { text = "填写第一个选项", outcome = "填写第一个选项的结果。",
            // canChoose = function(event) { return ::World.Assets.getMoney() >= 20; },
            // apply = function(event) { ::World.Assets.addMoney(-20); }
        },
        { text = "填写第二个选项", outcome = "填写第二个选项的结果。" }
    ]
});
