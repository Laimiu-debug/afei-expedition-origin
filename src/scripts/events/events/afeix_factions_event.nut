this.afeix_factions_event <- this.inherit("scripts/events/event", {
    m={Idea="",Token=0,Outcome=""},
    function create(){this.m.ID="event.afeix_factions";this.m.Title="路上的消息";this.m.Cooldown=60.0;},
    function onUpdateScore(){this.m.Score=::AfeixExpedition.hasIdea()?35:0;},
    function onPrepare(){
        local A=::AfeixExpedition;this.m.Idea=A.chooseIdea();this.m.Outcome="这次没有新的消息。";
        this.m.Token=A.get("ideas_serial")+1;A.set("ideas_serial",this.m.Token);A.set("ideas_active_token",this.m.Token);
        if(this.m.Idea!="")this.m.Title=this.m.Idea in A.IdeaScenes?A.IdeaScenes[this.m.Idea].title:A.chronicleScene(this.m.Idea).title;
    },
    function onDetermineStartScreen(){return this.m.Idea==""?"result":"opening";},
    function getScreen(id){
        if(id=="retry") {
            local A=::AfeixExpedition,s=A.ideaScreen(this,"opening");s.ID=id;s.Text=this.m.Outcome+"\n\n"+s.Text;
            s.Options.push(A.ledgerOption("先结束谈话。",function(e){return 0;}));return s;
        }
        return ::AfeixExpedition.ideaScreen(this,id);
    },
    function buildText(text){return text;},
    function onClear(){this.m.Idea="";this.m.Outcome="";},
    function onPrepareVariables(vars){}
});
