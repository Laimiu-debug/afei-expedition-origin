this.afei_ledger_event <- this.inherit("scripts/events/event", {
 m={Notice="",Selected=[],PickMode="",PickBack="camp",AutoPage="home"},
 function create() {this.m.ID="event.afei_ledger";this.m.Title="黑旗名册";this.m.Cooldown=0.0;this.m.IsSpecial=true;},
 function onUpdateScore() {
   // 名册只通过世界地图 F8 手动打开；主动剧情由 event.afei_talk 的伙伴对话承接
   this.m.Score=0;
   this.m.AutoPage="home";
 },
 function onPrepare() {
   this.m.Notice="世界地图按 F8 可随时重新打开，线索与试训进度保留。";
 },
 function onDetermineStartScreen() {return this.m.AutoPage;},
 function getScreen(id) {return ::AfeiExpedition.bookPage(this,id);},
 function buildText(text) {return text;},
 function onClear() {this.m.Selected=[];this.m.PickBack="camp";},
 function onPrepareVariables(vars) {}
});
