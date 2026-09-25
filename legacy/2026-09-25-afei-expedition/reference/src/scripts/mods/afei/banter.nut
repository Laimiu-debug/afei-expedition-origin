// 营地闲聊：取材设定稿「在队伍中的关系」，每段只演一次。
// opts 里 c 为点击时的小幅磨合奖励（受每日上限约束）。
local A = ::AfeiExpedition;

A.Banters <- {
 b01 = {who = ["C01","C02"], text = "%terrainImage%营地里，阿飞又在告示上添字。热汤管够，战死有抚恤。抹茶把账本翻开，用指头敲了敲那一页。%SPEECH_ON%按这张告示招人，三天后连墨水都吃掉。%SPEECH_OFF%阿飞愣了愣。%SPEECH_ON%那写什么？%SPEECH_OFF%抹茶头也不抬。%SPEECH_ON%真话。真话便宜。%SPEECH_OFF%",
   opts = [
     {t = "把告示改了。", r = "%terrainImage%阿飞划掉那些大话，只留下跟着黑旗，学点真本事。抹茶点了点头。%SPEECH_ON%这句不花钱。%SPEECH_OFF%", c = 1},
     {t = "先数米。", r = "%terrainImage%两个人蹲在米缸前数到半夜。第二天阿飞自己把热汤管够划掉了。", c = 1}
   ]},
 b02 = {who = ["C03","C04"], text = "%terrainImage%空地上，大谋和瓶队比划谁先撞进去。谁也没动。%SPEECH_ON%你先动，我就动。%SPEECH_OFF%%SPEECH_ON%你先动，我就顶。%SPEECH_OFF%",
   opts = [
     {t = "大谋先顶。", r = "%terrainImage%大谋把盾往地上一顿。瓶队绕着他跑了一圈，找了个最顺的切入角。", c = 1},
     {t = "这次你先，下次我先。", r = "%terrainImage%两人点了点头。谁也没再争。", c = 1}
   ]},
 b03 = {who = ["C01","C02","C03"], text = "%terrainImage%夜里没人睡。黑旗挂在车辕上，三行名字被风吹得贴在一起。阿飞说以后要写满。抹茶说先写下个月的口粮。大谋把旗角压好。%SPEECH_ON%都会有的。只是顺序不同。%SPEECH_OFF%",
   opts = [
     {t = "守到天亮。", r = "%terrainImage%三个队长谁也没回去睡。天亮时旗子还在。", c = 1},
     {t = "去睡。", r = "%terrainImage%大谋守了下半夜。第二天谁也没提，旗扎得比平时更牢。", c = 1}
   ]},
 b04 = {who = ["C05","C07"], text = "%terrainImage%李李这一箭又擦着靶边过去了。她盯着靶子看了半天。%SPEECH_ON%这算失误，还是算新招式？%SPEECH_OFF%月牙凑过来。%SPEECH_ON%能再来一次吗？%SPEECH_OFF%",
   opts = [
     {t = "再射一支。", r = "%terrainImage%两个人蹲到熄灯。月牙在本子上画了个歪箭道，李李签了名。%SPEECH_ON%就叫我的招。%SPEECH_OFF%", c = 1},
     {t = "明天再练。", r = "%terrainImage%李李收弓收得很快。%SPEECH_ON%那明天再歪给你看。%SPEECH_OFF%月牙把本子揣好。", c = 0}
   ]},
 b05 = {who = ["C06","C08"], text = "%terrainImage%余九又在数人，数到两遍不一样。小鱼走过去，把最外面的两个人对调了，再数一遍。%SPEECH_ON%这样你数得清。%SPEECH_OFF%余九看了她一眼。%SPEECH_ON%我又不是专门替你数的。%SPEECH_OFF%小鱼把盾往肩上一挪。%SPEECH_ON%知道。你替所有人都数了。%SPEECH_OFF%余九把名册往怀里收了收。",
   opts = [
     {t = "把队尾排好。", r = "%terrainImage%夜里谁看队尾写成了表。余九的名册上，小鱼那一格只画了一个圈。", c = 1},
     {t = "让她们自己商量。", r = "%terrainImage%连谁负责喊停都写了。比你想的细。", c = 0}
   ]},
 b06 = {who = ["C04","C09"], text = "%terrainImage%瓶队冲完木桩阵。帅子在终点等他，手里攥着鼓槌。%SPEECH_ON%你每次冲完都背对着出口。%SPEECH_OFF%瓶队喘着气。%SPEECH_ON%冲的时候谁想这个。%SPEECH_OFF%帅子敲了一下鼓。%SPEECH_ON%我想。我数到四就得知道你在哪。%SPEECH_OFF%",
   opts = [
     {t = "鼓在哪，退路就在哪。", r = "%terrainImage%瓶队冲出去之前，会先找那面鼓。", c = 1},
     {t = "让他自己记。", r = "%terrainImage%瓶队嘴里应着，冲起来还是忘。帅子把鼓点敲得更响。", c = 0}
   ]},
 b07 = {who = ["C10","C01"], text = "%terrainImage%阿飞突然喊了一嗓子布置夜哨。怼怼手里的碗差点扣地上。%SPEECH_ON%你能不能先把话说一半，再喊后半？%SPEECH_OFF%阿飞摊手。%SPEECH_ON%战场上谁等你分两次？%SPEECH_OFF%怼怼把碗放稳。%SPEECH_ON%那你喊之前，先看我一眼。%SPEECH_OFF%",
   opts = [
     {t = "喊之前先竖根手指。", r = "%terrainImage%阿飞竖一根手指，全营都知道要喊了。怼怼的碗还是端得很紧。", c = 1},
     {t = "让她先复述一遍。", r = "%terrainImage%怼怼问了最后一遍。%SPEECH_ON%换哨，还是查车？%SPEECH_OFF%阿飞清了清嗓子。%SPEECH_ON%换哨。%SPEECH_OFF%%SPEECH_ON%好，我去传。%SPEECH_OFF%", c = 1}
   ]},
 b08 = {who = ["C32","C10"], text = "%terrainImage%怼怼拿着写好的传令来问小宁。小宁没接那张纸，朝火堆边抬了抬下巴。%SPEECH_ON%去问明天站前排的人。%SPEECH_OFF%怼怼愣了。%SPEECH_ON%他们又不懂传令。%SPEECH_OFF%小宁已经把图折好了。%SPEECH_ON%他们懂那句话落到身上是什么。%SPEECH_OFF%",
   opts = [
     {t = "去问前排。", r = "%terrainImage%盾手七嘴八舌。第二天那句口令短了一半，营里都听懂了。", c = 1},
     {t = "让小宁改。", r = "%terrainImage%小宁把纸还给她。%SPEECH_ON%我改的只是词。%SPEECH_OFF%怼怼抱着纸去前排了。", c = 0}
   ]},
 b09 = {who = ["C12","C13"], text = "%terrainImage%装车。大鹅把最重的箱子都摞在一起。%SPEECH_ON%压住车轴。%SPEECH_OFF%小虎看不下去了。%SPEECH_ON%重的东西要摊开，桥才过得去。%SPEECH_OFF%大鹅把箱子抱得更紧。%SPEECH_ON%摊开了容易掉。%SPEECH_OFF%%SPEECH_ON%掉了捡得回来。桥断了捡不回来。%SPEECH_OFF%",
   opts = [
     {t = "摊开。", r = "%terrainImage%大鹅一边搬一边嘟囔。过桥的时候车是稳的。她在桥那头等着，什么也没说。", c = 1},
     {t = "她压轴，他带路。", r = "%terrainImage%一个管车，一个管路。车走快了。", c = 1}
   ]},
 b10 = {who = ["C14","C02"], text = "%terrainImage%小杰把钥匙按大小排好，挂回腰上。抹茶看着那串叮当响的铁。%SPEECH_ON%每把都记在账上吗？%SPEECH_OFF%小杰拍拍脑袋。%SPEECH_ON%记在这儿。%SPEECH_OFF%抹茶摇头。%SPEECH_ON%脑袋会忘。%SPEECH_OFF%%SPEECH_ON%我的不会。%SPEECH_OFF%",
   opts = [
     {t = "给一本钥匙账。", r = "%terrainImage%账归小杰，墨水归抹茶。两个人都觉得对方多事，都没停下。", c = 1},
     {t = "让他自己管。", r = "%terrainImage%抹茶盯了半天，在自己账上写了一行：钥匙，小杰，勿问。", c = 0}
   ]},
 b11 = {who = ["C15","C16"], text = "%terrainImage%苏袜绕着营地跑第三圈了。涂涂坐在路口看她。%SPEECH_ON%你跑这么快，在看路吗？%SPEECH_OFF%%SPEECH_ON%路我闭着眼都认得。%SPEECH_OFF%%SPEECH_ON%那你回头看什么？%SPEECH_OFF%苏袜慢了下来。",
   opts = [
     {t = "问她在等谁。", r = "%terrainImage%涂涂拍了拍身边的位子。%SPEECH_ON%等跑最后的人。%SPEECH_OFF%苏袜坐下了。", c = 1},
     {t = "跑一圈慢的。", r = "%terrainImage%两个人用一半的速度跑完。苏袜没再回头。", c = 1}
   ]},
 b12 = {who = ["C17","C05"], text = "%terrainImage%李李在火堆边擦弓。可可坐在对面，眼睛不在火上。%SPEECH_ON%你在看什么？%SPEECH_OFF%%SPEECH_ON%看暗处。%SPEECH_OFF%%SPEECH_ON%盯得住吗？%SPEECH_OFF%可可把弩搁在膝上。%SPEECH_ON%你只管站在光里。%SPEECH_OFF%",
   opts = [
     {t = "让她守上半夜。", r = "%terrainImage%上半夜什么也没发生。可可说这就好。", c = 1},
     {t = "让她歇着。", r = "%terrainImage%她还是看了一眼暗处，才去睡。", c = 0}
   ]},
 b13 = {who = ["C18","C01"], text = "%terrainImage%阿飞布置完明天的行军。童猪举手。%SPEECH_ON%我再讲一次。听完再举手。%SPEECH_OFF%阿飞已经讲完了。%SPEECH_ON%我听见的是走山北。大谋说他听见的是走山南。%SPEECH_OFF%全营静了一下。阿飞把话又讲了一遍，这次没喊。",
   opts = [
     {t = "写在木熊底下。", r = "%terrainImage%行军令刻在木熊肚子下面。谁没听清，自己去看。", c = 1},
     {t = "找人复述。", r = "%terrainImage%阿飞指了童猪、怼怼和月牙。%SPEECH_ON%我说，他们仨复述。听岔了算我的。%SPEECH_OFF%", c = 1}
   ]},
 b14 = {who = ["C19","C09"], text = "%terrainImage%奶盖跟帅子学打拍子。%SPEECH_ON%这有什么难的。一二三四。%SPEECH_OFF%她数到三就抢了拍。帅子没笑，把鼓递过去。%SPEECH_ON%你数你的，我跟。%SPEECH_OFF%第三遍，合上了。",
   opts = [
     {t = "给她一面鼓。", r = "%terrainImage%营里有两种鼓点。混在一起不难听。", c = 1},
     {t = "让她小声数。", r = "%terrainImage%奶盖数拍子的声音小了一半。拍子还在。", c = 1}
   ]},
 b15 = {who = ["C20","C03"], text = "%terrainImage%余想把换防表钉在车板上。大谋凑过去看，自己的名字排在最重的一班。%SPEECH_ON%这班该轮我。%SPEECH_OFF%%SPEECH_ON%你排的班，你自己排的。%SPEECH_OFF%大谋点了点头。%SPEECH_ON%排得好。%SPEECH_OFF%",
   opts = [
     {t = "添一栏：顶不住就说。", r = "%terrainImage%余想盯着那行字看了很久，添了一笔。", c = 1},
     {t = "换给年轻人。", r = "%terrainImage%余想问换给谁。大谋想了想，没换。", c = 0}
   ]},
 b16 = {who = ["C21","C22"], text = "%terrainImage%分干粮。陈知含把自己那份留到最后。美伢把饼掰了一半过去。%SPEECH_ON%你先吃。%SPEECH_OFF%%SPEECH_ON%我的那份先放好。%SPEECH_OFF%%SPEECH_ON%谢幕之前，也得吃饭。%SPEECH_OFF%",
   opts = [
     {t = "按她的规矩分。", r = "%terrainImage%每个人都先放好自己的一份。抹茶说这算好规矩。", c = 1},
     {t = "让她先咬一口。", r = "%terrainImage%美伢把饼按回她手里。陈知含咬了一口，很小的一口。", c = 1}
   ]},
 b17 = {who = ["C23","C15"], text = "%terrainImage%千涵绕着明天的路线跑了个来回。%SPEECH_ON%我能再跑三趟。%SPEECH_OFF%苏袜递水过去。%SPEECH_ON%第一段跑成最后一段，后面谁带路？%SPEECH_OFF%%SPEECH_ON%可我快啊。%SPEECH_OFF%苏袜把水壶塞进她手里。%SPEECH_ON%快是本事。省着也是。%SPEECH_OFF%",
   opts = [
     {t = "头一段给她。", r = "%terrainImage%每天出发的头一里地，都是她先跑出去探的。", c = 1},
     {t = "让苏袜教她省力气。", r = "%terrainImage%苏袜在地上画了条弯线。千涵把这条线记了一路。", c = 1}
   ]},
 b18 = {who = ["C25","C03"], text = "%terrainImage%大谋缠着玩蛇要学变招。玩蛇递给他一根木棍。%SPEECH_ON%你先打我十下。%SPEECH_OFF%打到第七下他就喘了。玩蛇收了棍。%SPEECH_ON%气不够，什么招都是直的。%SPEECH_OFF%",
   opts = [
     {t = "先学省气。", r = "%terrainImage%大谋出招前会先沉一口气。玩蛇说这算入门。", c = 1},
     {t = "先练力气。", r = "%terrainImage%大谋加练了半个月。玩蛇看了，摇头，又点头。%SPEECH_ON%笨办法也是办法。%SPEECH_OFF%", c = 0}
   ]},
 b19 = {who = ["C26","C14"], text = "%terrainImage%芷芷在营门口搭了个遮雨的木架。小杰蹲在底下，伸手晃了晃柱子。%SPEECH_ON%销钉松了。%SPEECH_OFF%%SPEECH_ON%能用就行。%SPEECH_OFF%%SPEECH_ON%风大了就不是能用的事。%SPEECH_OFF%他修好了销钉，顺手又加固了两根柱子。芷芷在旁边递工具，递得比他还快。",
   opts = [
     {t = "让他检查全营的架子。", r = "%terrainImage%会晃的东西都被拧了一遍。芷芷跟在后面记哪根是谁修的。", c = 1},
     {t = "先用着。", r = "%terrainImage%架子还立着。小杰走之前还是把销钉敲紧了。", c = 0}
   ]},
 b20 = {who = ["C27","C04","C20"], text = "%terrainImage%瑶瑶牙和瓶队隔着火堆争上次的缺口是谁开的。%SPEECH_ON%我从正面撕开的。%SPEECH_OFF%%SPEECH_ON%你那是墙。我开的是门。%SPEECH_OFF%余想在旁边翻了个身。%SPEECH_ON%墙倒了砸自己。门开了走人。%SPEECH_OFF%两人同时闭嘴了。",
   opts = [
     {t = "下场合练一次。", r = "%terrainImage%瑶瑶牙撕墙，瓶队开门。一次过。余想看了一眼，没再说话。", c = 1},
     {t = "记在名册边上。", r = "%terrainImage%名册边角多了一行：墙倒了砸自己，门开了走人。", c = 1}
   ]},
 b21 = {who = ["C28","C23"], text = "%terrainImage%千涵跟着羊咩咩跑山路，第一个弯就被甩开了。她冲上去问。%SPEECH_ON%弯前松一点。%SPEECH_OFF%%SPEECH_ON%松了不就慢了？%SPEECH_OFF%%SPEECH_ON%出弯才有力气追。%SPEECH_OFF%千涵又跑了一圈，比上一圈快了半步。",
   opts = [
     {t = "再跑几个弯。", r = "%terrainImage%千涵过弯不再刹车了。脚比耳朵先学会。", c = 1},
     {t = "问铃铛干什么。", r = "%terrainImage%羊咩咩拍了拍车轴。%SPEECH_ON%铃铛一变调，轮子就快松了。%SPEECH_OFF%", c = 0}
   ]},
 b22 = {who = ["C29","C30"], text = "%terrainImage%一凹瑶把一根短棒递给罗一可。%SPEECH_ON%接力。三人。拆成几轮？%SPEECH_OFF%%SPEECH_ON%两轮。我卡位那轮算一轮。%SPEECH_OFF%%SPEECH_ON%卡位不算跑？%SPEECH_OFF%罗一可把棒又递回去。%SPEECH_ON%我脚下两步，够别人跑二十步。%SPEECH_OFF%",
   opts = [
     {t = "全营传一次。", r = "%terrainImage%那天下午全营都在传那根短棒。阿飞输了三轮。", c = 1},
     {t = "先练接稳。", r = "%terrainImage%棒传到最后一个人手里，没掉。一凹瑶点了点头。", c = 1}
   ]},
 b23 = {who = ["C30","C15"], text = "%terrainImage%罗一可和苏袜为了一个藤球争了半个营地。%SPEECH_ON%球到脚下两步之内是我的。%SPEECH_OFF%%SPEECH_ON%两步之外全是我的。%SPEECH_OFF%两人在地上画了条线。谁也没越过去，谁也没拿到球。",
   opts = [
     {t = "分队打一场。", r = "%terrainImage%打了两个时辰。千涵从中间把球带走了。两人同时说下次先盯她。", c = 1},
     {t = "布阵就按这条线。", r = "%terrainImage%罗一可管两步之内，苏袜管两步之外。线没人再提。", c = 1}
   ]},
 b24 = {who = ["C31","C02"], text = "%terrainImage%采买归来。bula和抹茶对着账本。%SPEECH_ON%价格我算过了，不亏。%SPEECH_OFF%%SPEECH_ON%我没问亏不亏。我问谁用。%SPEECH_OFF%bula顿了顿。%SPEECH_ON%针线。雨布底下那包。给谁都行。%SPEECH_OFF%抹茶把账合上。%SPEECH_ON%那就不该买最贵的。%SPEECH_OFF%",
   opts = [
     {t = "一栏价格，一栏用途。", r = "%terrainImage%采买账多了一栏。阿飞问那栏什么意思。两人没回答。", c = 1},
     {t = "买之前先说给谁用。", r = "%terrainImage%bula只说了三句：给谁用，用多久，不买会怎样。说不出来，就不买。", c = 1}
   ]},
 b25 = {who = ["C16","C12"], text = "%terrainImage%夜里换哨。涂涂把路线图交给小虎，一个岔口一个岔口地讲。%SPEECH_ON%这条路我说过要走。现在交给你。%SPEECH_OFF%小虎把图捏紧了。%SPEECH_ON%你不去别处了吧？%SPEECH_OFF%%SPEECH_ON%不去了。把话说清楚。%SPEECH_OFF%小虎把图收进信袋最里层。",
   opts = [
     {t = "把走过的路都画下来。", r = "%terrainImage%车板底下压着一张越画越长的图。", c = 1},
     {t = "图收好就行。", r = "%terrainImage%信袋最里层多了一张图。两个名字挨着。", c = 1}
   ]}
};

// 行军路上弹出的名场面：战团在世界地图走动时触发，每段只演一次。
A.RoadTales <- {
 r01 = {who = ["C01","C02"], text = "%terrainImage%行路途中，你们经过一座村子。墙根贴着半张被雨打湿的告示。上沿两个大字还在，底下什么也没写。抹茶蹲下去看了看。%SPEECH_ON%这是你写的。%SPEECH_OFF%阿飞清了清嗓子。%SPEECH_ON%我写过一张。%SPEECH_OFF%抹茶把告示揭下来，空白那头对着他。%SPEECH_ON%连空白都抄下来了。%SPEECH_OFF%",
   opts = [
     {t = "把空白补上。", r = "%terrainImage%阿飞用炭笔补了三行：日薪、歇脚、出事了去哪找。抹茶看了一眼。%SPEECH_ON%这三行比那两个字贵。%SPEECH_OFF%阿飞没吭声。", c = 1},
     {t = "收进名册。", r = "%terrainImage%半张告示夹进名册最前面。阿飞拍了拍灰。%SPEECH_ON%留着。%SPEECH_OFF%", c = 1}
   ]},
 r02 = {who = ["C01","C03"], text = "%terrainImage%行路途中，你们刚打完一小股强盗。阿飞那一声还挂在喉咙里。后排有个雇来的矛手学他吸气。%SPEECH_ON%嘶——哇。%SPEECH_OFF%有人笑。大谋把那人的矛杆按下去。%SPEECH_ON%下次听见这声，往前站。%SPEECH_OFF%阿飞耳根红了。%SPEECH_ON%我那是喊给自己听的。%SPEECH_OFF%大谋点了点头。%SPEECH_ON%现在全营都听见了。%SPEECH_OFF%",
   opts = [
     {t = "这声算号令。", r = "%terrainImage%阿飞把腰板挺了挺。%SPEECH_ON%听见就过来。%SPEECH_OFF%矛手把学来的吸气咽了回去。", c = 1},
     {t = "先别学。", r = "%terrainImage%阿飞摆了摆手。%SPEECH_ON%先别学。%SPEECH_OFF%大谋没再说什么。", c = 1}
   ]},
 r03 = {who = ["C01","C10"], text = "%terrainImage%行路途中，你们歇脚。两拨雇工吵起来，一拨说团长喊了就跟，另一拨说越喊越别信。怼怼听了三遍，把传令牌往车辕上一搁。%SPEECH_ON%争的不是他喊不喊。是喊完了谁去传后半句。%SPEECH_OFF%阿飞张了张嘴，没出声。",
   opts = [
     {t = "让怼怼去问。", r = "%terrainImage%怼怼问了最后一遍。%SPEECH_ON%跟的人要听哪半句？不信的人怕哪半句？%SPEECH_OFF%两边都说完了。阿飞补了一句。%SPEECH_ON%后半句我自己说。%SPEECH_OFF%", c = 1},
     {t = "自己把话说完。", r = "%terrainImage%阿飞清了清嗓子。%SPEECH_ON%跟旗。嗓门会哑。%SPEECH_OFF%两拨人暂时不吵了。", c = 1}
   ]},
 r04 = {who = ["C01","C02"], text = "%terrainImage%行路途中，阿飞盯上货摊上一把看起来很气派的旧剑。抹茶翻开账本。%SPEECH_ON%那是几天的口粮。%SPEECH_OFF%阿飞把剑放回去。%SPEECH_ON%我就是问问。%SPEECH_OFF%",
   opts = [
     {t = "按口粮算。", r = "%terrainImage%抹茶在账上划了一笔。阿飞后来又看了那把剑一眼，没再问价。", c = 1},
     {t = "让他自己看着办。", r = "%terrainImage%阿飞摸了摸口袋，还是走了。抹茶把账本合上。%SPEECH_ON%问过就算数过。%SPEECH_OFF%", c = 1}
   ]},
 r05 = {who = ["C02","C03"], text = "%terrainImage%行路途中，大谋指着远处一个扛矛的汉子。%SPEECH_ON%这人能当大哥。%SPEECH_OFF%抹茶翻开本子，头也不抬。%SPEECH_ON%日薪多少。%SPEECH_OFF%大谋愣了一下。%SPEECH_ON%……我还没问。%SPEECH_OFF%",
   opts = [
     {t = "先问清楚再谈。", r = "%terrainImage%大谋过去问了。回来时声音小了点。抹茶把那个数字记上，没再说话。", c = 1},
     {t = "让大谋自己去问。", r = "%terrainImage%大谋过去转了一圈。抹茶等在车边，笔已经搁在本子上。", c = 1}
   ]},
 r06 = {who = ["C02"], text = "%terrainImage%行路途中，雇来的修理工要把一把裂了柄的锤子扔掉。抹茶伸手拦住。%SPEECH_ON%还能钉。%SPEECH_OFF%修理工看了看那道裂。%SPEECH_ON%钉不久。%SPEECH_OFF%抹茶已经蹲下去缠绳子。",
   opts = [
     {t = "让他修。", r = "%terrainImage%锤子又能用了。修理工后来把裂了的东西先放到抹茶面前，不再直接扔。", c = 1},
     {t = "扔了再买。", r = "%terrainImage%锤子还是扔了。抹茶在账上记了一笔新工具。他没拦第二次。", c = 0}
   ]},
 r07 = {who = ["C01","C03"], text = "%terrainImage%行路途中，车轮陷进泥里。路边有个农夫喊人帮忙。大谋扬了扬下巴。%SPEECH_ON%这事好办，我认识一个大哥。%SPEECH_OFF%阿飞四处看。大谋已经把车辕抬起来了。",
   opts = [
     {t = "让他抬。", r = "%terrainImage%车出来了。农夫要道谢，大谋已经在拍手上的泥。%SPEECH_ON%下次还找这个大哥。%SPEECH_OFF%", c = 1},
     {t = "一起抬。", r = "%terrainImage%阿飞也上去了。车还是大谋那一头沉。他没换边。", c = 1}
   ]},
 r08 = {who = ["C01","C02","C03"], text = "%terrainImage%行路途中，补给箱滑进沟里。三个队长下去抬。大谋把最沉的那头留给自己。阿飞要换边。大谋摇头。%SPEECH_ON%你喊就行。%SPEECH_OFF%抹茶在旁边数。%SPEECH_ON%一，二。%SPEECH_OFF%",
   opts = [
     {t = "按他的来。", r = "%terrainImage%箱子抬上来了。阿飞喊得比箱子还响。大谋把最沉的那头放回车上，没再说话。", c = 1},
     {t = "换边再抬。", r = "%terrainImage%换了边，箱子还是歪。最后还是大谋把沉的那头拿回去了。", c = 1}
   ]},
 r09 = {who = ["C03"], text = "%terrainImage%行路途中，雇来的矛手问今晚谁守前哨。大谋已经把盾靠在车辕上。%SPEECH_ON%我。%SPEECH_OFF%矛手还想让。大谋摇头。%SPEECH_ON%你们睡觉。%SPEECH_OFF%",
   opts = [
     {t = "让他守。", r = "%terrainImage%夜里没出事。天亮时盾还靠在原处，大谋在打盹，没倒。", c = 1},
     {t = "派人轮换。", r = "%terrainImage%大谋把盾让出去半个时辰，又要了回来。%SPEECH_ON%轮也行。我先顶着。%SPEECH_OFF%", c = 1}
   ]},
 r10 = {who = ["C01","C04"], text = "%terrainImage%行路途中，前方一道栅栏挡路。瓶队已经冲出去了。阿飞在后面喊。%SPEECH_ON%慢半拍！%SPEECH_OFF%瓶队跑出去又折回来。栅栏还关着。大谋已经把肩膀顶上去了。",
   opts = [
     {t = "让大谋顶，他从侧面进。", r = "%terrainImage%栅栏开了。瓶队从侧面挤出来，这一回三个人还站在一起。", c = 1},
     {t = "让他自己撞。", r = "%terrainImage%瓶队还是先撞了。栅栏开了，护具又裂了一道。抹茶在后面记账。", c = 0}
   ]},
 r11 = {who = ["C05"], text = "%terrainImage%行路途中，货车上的高背椅卡住了车门。李李看了看出口，先绕开人群，再回来把椅子拖到路边。雇工要帮她抬。她摇头。%SPEECH_ON%灯先别撤。%SPEECH_OFF%",
   opts = [
     {t = "让她搬。", r = "%terrainImage%椅子放到干处。李李拍了拍灰，问下一箭什么时候。", c = 1},
     {t = "派人抬。", r = "%terrainImage%两个人把椅子抬下去。李李还是把位置看了一眼，才肯走。", c = 1}
   ]},
 r12 = {who = ["C01","C06"], text = "%terrainImage%行路途中，阿飞指着一条近路。余九数完车上的人，把矛横在车前。%SPEECH_ON%有人落下。%SPEECH_OFF%后面两个人小跑着赶上来。阿飞把地图折好。余九这才把矛收回来。",
   opts = [
     {t = "听她的。", r = "%terrainImage%人齐了。余九点了点头。%SPEECH_ON%下回我喊停，还听不听？%SPEECH_OFF%阿飞说听。她这才把矛尖转向前路。", c = 1},
     {t = "先走这段。", r = "%terrainImage%车还是停了。落下的人赶上时，阿飞没再争。", c = 1}
   ]},
 r13 = {who = ["C07"], text = "%terrainImage%行路途中，雇工要把一根断绳扔掉。月牙伸手拦住。%SPEECH_ON%先别扔。%SPEECH_OFF%她拿断绳把歪了的棚架绑住。风过的时候，架子没倒。",
   opts = [
     {t = "让她用。", r = "%terrainImage%绳子又派上了用场。月牙把剩下的也分好了。", c = 1},
     {t = "扔了再买。", r = "%terrainImage%绳子还是扔了。月牙在摊子上另找了一截。%SPEECH_ON%这个也能用。%SPEECH_OFF%", c = 0}
   ]},
 r14 = {who = ["C08"], text = "%terrainImage%行路途中，最重的那箱没人肯抬。小鱼等了一会儿，自己上了肩。有人在旁边笑。她把空车推回去。%SPEECH_ON%第二箱也抬来。%SPEECH_OFF%",
   opts = [
     {t = "让她抬。", r = "%terrainImage%两箱都上了车。小鱼把盾立在车外侧，没再说话。", c = 1},
     {t = "派人一起抬。", r = "%terrainImage%两个人抬上去了。小鱼还是把盾立在没人守的那一侧。", c = 1}
   ]},
 r15 = {who = ["C04","C09"], text = "%terrainImage%行路途中，两辆车抢着过窄门。帅子被挤在门柱边，嘴里说慢一点，手上的横杆没松。瓶队在门里探头。%SPEECH_ON%四下以后再走。%SPEECH_OFF%",
   opts = [
     {t = "听鼓点。", r = "%terrainImage%数到四，车才过。帅子腿还在抖。门还在。", c = 1},
     {t = "让瓶队先冲。", r = "%terrainImage%瓶队还是先动了。帅子把横杆咬住，直到第二辆车倒回去。", c = 0}
   ]},
 r16 = {who = ["C01","C10"], text = "%terrainImage%行路途中，阿飞把集合点说了两遍，两遍不一样。怼怼站在原处，没有跑。%SPEECH_ON%我问最后一遍。%SPEECH_OFF%阿飞指着地图重说。她这才走。",
   opts = [
     {t = "说清楚再传。", r = "%terrainImage%人齐了。怼怼把传令牌拍回腰上。王冠还挂在车上。", c = 1},
     {t = "先按第一遍去。", r = "%terrainImage%怼怼还是没跑。直到地点改对，她才把话送出去。", c = 1}
   ]},
 r17 = {who = ["C32"], text = "%terrainImage%行路途中，小宁把队形图展开。纸中央留着一道空白。前头的路和画的不一样。她把图折了一下。%SPEECH_ON%先看脚下。%SPEECH_OFF%",
   opts = [
     {t = "按实地走。", r = "%terrainImage%车绕过了坑。小宁在空白处记了一笔。", c = 1},
     {t = "仍按图走。", r = "%terrainImage%车陷了一下。小宁没说我早知道，只把图又折了一道。", c = 0}
   ]},
 r18 = {who = ["C12"], text = "%terrainImage%行路途中，前面能走。小虎却停下来，回头看了一眼。远处有人追着车辙。他把弓取下，直到认出是送包裹的村民才放松。%SPEECH_ON%袋底还有一封。%SPEECH_OFF%",
   opts = [
     {t = "等他送完。", r = "%terrainImage%信送到了。小虎把空信袋重新系好，这才上车。", c = 1},
     {t = "先赶路。", r = "%terrainImage%车走了两步又停了。大谋在岔口等他。小虎跑回来时没人催。", c = 1}
   ]},
 r19 = {who = ["C13"], text = "%terrainImage%行路途中，有人去碰那口贴着黑旗封条的箱子。大鹅一嗓子把人钉在原地。%SPEECH_ON%谁也别碰。%SPEECH_OFF%她把箱子挪到自己脚边，站到队列最外侧。",
   opts = [
     {t = "让她护。", r = "%terrainImage%箱子没再被碰。大鹅把箱单攥在手里，嗓门小了一点。", c = 1},
     {t = "把箱子抬上车。", r = "%terrainImage%箱子上了车。大鹅还是走在最外侧。%SPEECH_ON%都靠过来。%SPEECH_OFF%", c = 1}
   ]},
 r20 = {who = ["C01","C14"], text = "%terrainImage%行路途中下雨，大家都等着拿油布。小杰忙着解释钥匙分好了类。阿飞站在车外淋着。%SPEECH_ON%锁得这么牢，先保护谁？%SPEECH_OFF%小杰把一串钥匙都拿出来，连自己也愣住了。",
   opts = [
     {t = "把备用钥匙交给旁边的人。", r = "%terrainImage%油布铺开了。车门边多挂了一把钥匙。%SPEECH_ON%要用就先开。%SPEECH_OFF%", c = 1},
     {t = "让他开。", r = "%terrainImage%他打开了。雨已经下进来一点。抹茶后来给每把钥匙写了木牌。", c = 1}
   ]},
 r21 = {who = ["C01","C15"], text = "%terrainImage%行路途中到了岔口。苏袜已经站在那儿。阿飞还在问哪边。她在石头上画了个很大的箭头。%SPEECH_ON%这个看记号。下个我也画了。%SPEECH_OFF%",
   opts = [
     {t = "跟记号走。", r = "%terrainImage%车没走偏。苏袜比自己单跑时累，记号却都还在。", c = 1},
     {t = "让她先探。", r = "%terrainImage%她跑了一趟回来，箭头画得更大。阿飞这回没再问。", c = 1}
   ]},
 r22 = {who = ["C16"], text = "%terrainImage%行路途中，涂涂走到营门口，又折回来取落在火边的手套。她坐下缝了几针。%SPEECH_ON%我今天走到哪儿，先说清楚。%SPEECH_OFF%",
   opts = [
     {t = "听她说完。", r = "%terrainImage%岗分清了。她把手套收好，下一程的话也说清楚了。", c = 1},
     {t = "让她先走。", r = "%terrainImage%她还是把话说完才走。手套没落下。", c = 1}
   ]},
 r23 = {who = ["C01","C17"], text = "%terrainImage%行路途中歇脚，行李堆在一起。阿飞说自己记得全部名字，随后把两只包拿反。可可递回去，给同一拨人的东西系上布条。%SPEECH_ON%你往前走。我看着朝你抬弓的那个。%SPEECH_OFF%",
   opts = [
     {t = "让她认人。", r = "%terrainImage%包和人对上了。可可把布条系在最先认识的那面盾上。", c = 1},
     {t = "自己再认一遍。", r = "%terrainImage%阿飞又拿反了一次。可可没笑，只把布条系紧。", c = 1}
   ]},
 r24 = {who = ["C01","C02","C18"], text = "%terrainImage%行路途中，童猪把木熊放在车上。阿飞和抹茶各有一套解释，轮流猜错。童猪让他们停一下。%SPEECH_ON%听完再举手。%SPEECH_OFF%大谋照着做了一遍，这才答对。",
   opts = [
     {t = "先听规则。", r = "%terrainImage%杯子敲响。这一回没人抢着猜。", c = 1},
     {t = "让他们再猜。", r = "%terrainImage%又错了。童猪把木熊翻过来，底下刻着规则。", c = 0}
   ]},
 r25 = {who = ["C19"], text = "%terrainImage%行路途中遇到一伙拦路的。奶盖先把话递了过去，人不得不看她。对手一动手，她退了半步，手却把盾摆到脸前。%SPEECH_ON%等我把盾拿好。刚才那句话，还算数。%SPEECH_OFF%",
   opts = [
     {t = "让她顶住。", r = "%terrainImage%盾挨了一下。她还在解释差点就能反击，投枪已经握在手里。", c = 1},
     {t = "让别人先上。", r = "%terrainImage%她把盾让开半步，话还是先到。盾很快又回到脸前。", c = 1}
   ]},
 r26 = {who = ["C20"], text = "%terrainImage%行路途中，雇工问今晚谁守最后一班。余想已经把矛抵在车边。%SPEECH_ON%这班我守。下一班你得真的派人来。%SPEECH_OFF%",
   opts = [
     {t = "把替班写清楚。", r = "%terrainImage%名册上写下了换岗时间。余想这才点头。", c = 1},
     {t = "让她再守一班。", r = "%terrainImage%她守了。天亮时她问的还是那句：下一班谁来。", c = 0}
   ]},
 r27 = {who = ["C01","C21"], text = "%terrainImage%行路途中，美伢把两把椅子摆成出口。她让阿飞举着盾走过去，第三次仍撞上同伴。%SPEECH_ON%你站这里，我才有地方把这一拍做完。%SPEECH_OFF%",
   opts = [
     {t = "按她的位置走。", r = "%terrainImage%第四次没撞。美伢点了点头，鼓手抬手前那一下吸气她也听见了。", c = 1},
     {t = "自己找路。", r = "%terrainImage%又撞了。她把椅子挪开一点，没再让他一个人过。", c = 1}
   ]},
 r28 = {who = ["C22"], text = "%terrainImage%行路途中分口粮。别人争整块的，陈知含把碎的分成差不多的几份，自己那份留到最后。旁边有人把那一份先推回去。%SPEECH_ON%你的先放好。%SPEECH_OFF%",
   opts = [
     {t = "让她先拿。", r = "%terrainImage%她的那份放好了，才轮到别人。饼没有缺角。", c = 1},
     {t = "按她的分法。", r = "%terrainImage%每份都差不多。她自己那份仍是最后拿走的。", c = 1}
   ]},
 r29 = {who = ["C01","C23"], text = "%terrainImage%行路途中一段短坡。阿飞说这能一天跑完北境。千涵站住了。%SPEECH_ON%只是那段坡。%SPEECH_OFF%她把力气留给最后一段，木牌还擦得很亮。",
   opts = [
     {t = "让她跑这一段。", r = "%terrainImage%坡顶她还在。阿飞没再把故事讲大。", c = 1},
     {t = "全队一起走。", r = "%terrainImage%她没抢第一个弯。到了坡顶，她问下一处能停的地方在哪。", c = 1}
   ]},
 r30 = {who = ["C01","C25"], text = "%terrainImage%行路途中，玩蛇递给他一把木剑。%SPEECH_ON%讲也行。先把刚才那步站出来。%SPEECH_OFF%阿飞没站稳。她蹲下去数脚印，没有把新招讲得神秘。",
   opts = [
     {t = "听完复盘。", r = "%terrainImage%他把那步又站了一次。玩蛇在旧痕旁又添了一条。", c = 1},
     {t = "让她先打。", r = "%terrainImage%她把三招删成一招。省下来的气力用来看他站哪儿。", c = 1}
   ]},
 r31 = {who = ["C26"], text = "%terrainImage%行路途中，渡口跳板上挤成一团。芷芷没跟着喊，只把两只木箱横着摆开。%SPEECH_ON%先别挤。分两列。%SPEECH_OFF%",
   opts = [
     {t = "按她摆的走。", r = "%terrainImage%人分两列过了。船夫说她站在那里，比敲半天锣还管用。", c = 1},
     {t = "让大家自己过。", r = "%terrainImage%还是挤。她把箱子又往前挪了半步，通道这才出来。", c = 1}
   ]},
 r32 = {who = ["C03","C27"], text = "%terrainImage%行路途中，瑶瑶牙已经往前走了半步。大谋把地图按住。%SPEECH_ON%回来走哪条路？%SPEECH_OFF%她把斧柄放到图上，先问撤回的位置。",
   opts = [
     {t = "先定撤回点。", r = "%terrainImage%位置说好了。她这才往前。回头看了一眼旗。", c = 1},
     {t = "让她先冲。", r = "%terrainImage%缺口开了。她还是先回头看了旗，才把斧抬起来。", c = 1}
   ]},
 r33 = {who = ["C01","C28"], text = "%terrainImage%行路途中进了连续弯道。阿飞问为什么还不冲。羊咩咩把车轴上的铃铛递给他。%SPEECH_ON%先听。%SPEECH_OFF%有一阵响声不对。她绕开碎石，晚到半步，货没散。",
   opts = [
     {t = "听铃铛。", r = "%terrainImage%封蜡没震开。阿飞把铃铛还回去，没再催。", c = 1},
     {t = "抄近路。", r = "%terrainImage%近路有碎石。她还是绕了。铃铛这回没响。", c = 1}
   ]},
 r34 = {who = ["C29"], text = "%terrainImage%行路途中传一只短棒。有人抢先伸手，挡住了后面要接的人。一凹瑶把棒收回来。%SPEECH_ON%先别抢。看看下一棒准备好了没有。%SPEECH_OFF%",
   opts = [
     {t = "改成接力。", r = "%terrainImage%最后那个人接稳了。她说谁先拿到不重要。", c = 1},
     {t = "让快的先拿。", r = "%terrainImage%快的拿到了，后面没人接。她把棒又放回桌上。", c = 0}
   ]},
 r35 = {who = ["C30"], text = "%terrainImage%行路途中巷口堆满了桶。正面推不动。罗一可蹲下去，把最碍事的那只转开。%SPEECH_ON%先让我把这个角度转过来。%SPEECH_OFF%",
   opts = [
     {t = "让她转。", r = "%terrainImage%路出来了。她说门前那几步是她的，长街靠大家轮换。", c = 1},
     {t = "从正面推。", r = "%terrainImage%还是推不动。她把桶转开以后，没人再从正面试。", c = 1}
   ]},
 r36 = {who = ["C01","C02","C03","C31"], text = "%terrainImage%行路途中经过货摊。阿飞夸自己有大格局。bula先问明天的粮钱。抹茶翻开账本，大谋把看中的新斧放回架子。%SPEECH_ON%要买可以。先告诉我这次能帮到谁。%SPEECH_OFF%",
   opts = [
     {t = "先报粮钱。", r = "%terrainImage%三个人重新算完。她才点头。雨布比披风先上了车。", c = 1},
     {t = "先买了再说。", r = "%terrainImage%斧还是没买。bula把账合上。%SPEECH_ON%晚上再算。%SPEECH_OFF%", c = 1}
   ]}
};

A.Banters.b26 <- {who=["C33","C34"], text="%terrainImage%小胖在车尾试着举盾，蔓越莓在木板上画下一条红线。%SPEECH_ON%你守这里，箭就不会越过自己人。%SPEECH_OFF%小胖把盾往旁边挪了半寸。%SPEECH_ON%那你先说，我再站。%SPEECH_OFF%",
 opts=[{t="照着红线再练一次。",r="%terrainImage%她们练到火快熄了，射出的箭没碰到盾沿。",c=1},{t="明早再练。",r="%terrainImage%小胖记住了那条线，蔓越莓把弓收好。",c=0}]};
A.RoadTales.r37 <- {who=["C33"], text="%terrainImage%一辆空车在坡上滑了一下。小胖追上去压住车辕，等后面的人都绕过去，才把手松开。",
 opts=[{t="等她喘匀再走。",r="%terrainImage%小胖拍了拍袖子上的灰。%SPEECH_ON%这回车也等我。%SPEECH_OFF%",c=1},{t="把绳索重新系紧。",r="%terrainImage%车轮稳了，小胖走回队尾。",c=0}]};
A.RoadTales.r38 <- {who=["C34"], text="%terrainImage%夜里巡路，蔓越莓在树皮上系了根红线。她说不是给敌人看的，是给走散的人留路。",
 opts=[{t="沿线记下回程。",r="%terrainImage%第二天大雾，队伍顺着红线回到驿站。",c=1},{t="记住位置就好。",r="%terrainImage%她没争辩，还是把线系牢了。",c=0}]};

A.talePage <- function(e, page, table, prefix) {
 local p = split(page, ":");
 local id = p.len() > 1 ? p[1] : "";
 local d = id in table ? table[id] : null;
 local s = {ID = page, Text = "", Image = "", List = [], Characters = [], Options = [], function start(e) {}};
 if (d == null) {
   s.Text = "这件事已经过去了。";
   s.Options.push(this.option("好", function(e2) { return 0; }));
   return this.seal(s);
 }
 local portraits = [];
 foreach (cid in d.who) {
   local b = this.named(cid);
   if (b != null && portraits.len() < 2) portraits.push(b.getImagePath());
 }
 s.start = function(e) { foreach (img in portraits) this.Characters.push(img); };
 if (p.len() == 2) {
   s.Text = d.text;
   foreach (i, o in d.opts) {
     local pick = i;
     s.Options.push(this.option(o.t, function(e2) {
       local pack = prefix == "road" ? ::AfeiExpedition.RoadTales : ::AfeiExpedition.Banters;
       local oo = pack[id].opts[pick];
       if (oo.c > 0) ::AfeiExpedition.bumpCohesion(oo.c);
       return prefix + ":" + id + ":" + pick;
     }));
   }
 }
 else {
   local o = d.opts[p[2].tointeger()];
   s.Text = o.r;
   s.Options.push(this.option("好", function(e2) { return 0; }));
 }
 return this.seal(s);
};

A.banterPage <- function(e, page) { return this.talePage(e, page, this.Banters, "banter"); };
A.roadPage <- function(e, page) { return this.talePage(e, page, this.RoadTales, "road"); };
