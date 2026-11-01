    ::Const.Sound <- {ActorEvent={DamageReceived=0,Death=1,NoDamageReceived=2,COUNT=3}};
    ::Const.HumanSounds <- [{Volume=1.25}];
    ::Math.rand <- function(low, high) {return low;};
    local played = [], resources = [];
    ::Tactical.addResource <- function(path) {resources.push(path);};
    local addVoice = function(bro) {
        bro.m.VoiceSet <- 0;
        bro.m.Sound <- [["native_hurt"],["native_death"],["native_armor"]];
        bro.m.SoundPitch <- 0.95;
        bro.m.Skills <- {addResources=function(){resources.push("native_skill");}};
        bro.Sound <- {play=function(sound,volume,pos,pitch){played.push([sound,volume,pos,pitch]);}};
        bro.Const <- ::Const; bro.Math <- ::Math; bro.Tactical <- ::Tactical;
        bro.getPos <- function(){return "tile";};
        bro.sprites.body.getBrush = function(){return {Name=this.brush,TextureName="portrait_atlas"};};
        bro.human.playSound <- ::bundleNativeVoice.playSound;
        bro.human.actor.loadResources <- ::bundleNativeVoice.loadResources;
        voiceHook(bro);
        return bro;
    };
    local voiced = addVoice(makeBrother("afei")), companion = addVoice(makeBrother("keke"));
    roster = [voiced,companion]; voiced.onInit(); companion.onInit();
    local voice = ::AfeixVoiceDLC;
    check(voice.HurtSounds.len()==5 && voice.VolumeMult==1.0,"bundle retains five loudness-enhanced original clips");
    foreach(style in D.Styles) {
        check(D.choose(style.key).ok,"combined skin selectable: "+style.key);
        local expected = style.brush==null?nativeBody:style.brush;
        resources.clear(); voiced.loadResources();
        check(resources.len()==10 && resources[3]=="portrait_atlas" && resources[4]=="native_skill",
            "skin, native sound, skill and five voice resources coexist: "+style.key);
        played.clear(); voiced.playSound(0,0.5); voiced.playSound(0,0.5);
        check(played.len()==2 && voice.HurtSounds.find(played[0][0])!=null && played[1][0]!=played[0][0],
            "each skin plays one original clip per hit without adjacent repeats: "+style.key);
        check(played[0][1]==0.5 && played[0][3]==1.0 && voiced.sprites.body.brush==expected,
            "voice retains volume and pitch while preserving selected skin: "+style.key);
        voiced.playSound(1,0.5,0.95); voiced.playSound(2,0.5,0.95);
        check(played[2][0]=="native_death" && played[3][0]=="native_armor",
            "each skin keeps native death and armor sounds: "+style.key);
        companion.playSound(0,0.5,0.95);
        check(played[4][0]=="native_hurt" && companion.sprites.body.brush==otherBody,
            "other companions retain native sound and original appearance: "+style.key);
        voiced.onSerialize({}); voiced.onDeserialize({}); voiced.playSound(0,0.5);
        check(voice.HurtSounds.find(played.top()[0])!=null && voiced.sprites.body.brush==expected
            && D.selected().key==style.key,"voice and skin coexist after native save/load: "+style.key);
        currentOrigin=false; voiced.playSound(0,0.5,0.95);
        check(played.top()[0]=="native_hurt","other origins retain native voice with both modules loaded");
        currentOrigin=true;
    }
    local combinedCompany=A.ledgerPage(event,"company"), count=0;
    foreach(option in combinedCompany.Options) if(option.Text=="阿飞外观") count++;
    check(count==1 && combinedCompany.Options.len()==6,"combined bundle adds one appearance menu entry");
    foreach(index in [0,1]) {
        local gallery=A.ledgerPage(event,D.Page+":cg:"+index);
        check(gallery.Text.find(D.CGs[index].image)!=null && gallery.Options.len()==3,
            "both supplied CGs remain accessible with voice loaded");
    }
    print("BUNDLE_COMBINED_CHECKS_PASS\n");
