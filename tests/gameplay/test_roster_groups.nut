dofile("tests/gameplay/member_skill_fixture.nut");
local A=::AfeixExpedition,checks=0;
local check=function(ok,label){++checks;if(!ok)throw "FAIL roster groups: "+label;};
local groups=[
    {name="刀一黑队",keys=["afei","damou","mocha","bottle","shuaizi","lili","xiaoyueya","yuchujiu","xiaoyubeike","wangduidui"]},
    {name="刀二蓝队",keys=["laocai","yanzi","tiantong","xiaoning","xiaopangxu","dae","manyuemei","xiaohani"]},
    {name="0.5DFW猪团",keys=["keke","yuxiang","tongzhu","meiya","wanshe","tutu","naigai","xiaojie","bula","suwa","qianhan","wangdazhi","yaoyaoya","yangmiemie"]},
    {name="旅途来客",keys=["songnuanyang","xiaogui"]}
];
check(A.CharacterOrder.len()==34&&A.Characters.len()==34&&A.Chapters.len()==4,"34 active members in four groups");
local seen={},position=0;
foreach(i,group in groups){
    check(A.Chapters[i].name==group.name&&A.Chapters[i].id==i+1,"exact requested group name and id");
    foreach(key in group.keys){
        check(!(key in seen)&&A.CharacterOrder[position++]==key&&A.Characters[key].chapter==i+1,"membership and display order: "+key);
        seen[key]<-true;
    }
}
check(A.CharacterOrder.find("chenzhihan")==null&&!("chenzhihan" in A.Characters)&&!("chenzhihan" in A.EncounterRequirements),"deleted identity absent from active roster and recruitment");
check(!("chenzhihan" in A.RetiredCharacters)&&!("chenzhihan" in A.MemberGrowth)&&!("chenzhihan" in A.MemberSkills)&&!("chenzhihan" in A.CharacterBackgrounds),"deleted identity has no compatibility data");
check(A.makeCharacter("chenzhihan")==null&&!A.canMeetCharacter("chenzhihan"),"deleted member cannot be generated or unlocked");
check(A.RootStories.er_xiaogui.member=="xiaogui"&&A.RootOrder.find("er_xiaogui")!=null,"moving turtle keeps existing six-root relationship");
foreach(key in ["xiaogui","songnuanyang","naigai"])check(A.EncounterRequirements[key].days==A.BalanceV26.people[key].day&&!("companions" in A.EncounterRequirements[key]),"V2 independent gates "+key);
print("TESTS_PASSED="+checks+"\n");
