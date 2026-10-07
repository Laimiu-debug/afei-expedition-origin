// Personal stories and finite rewards. All numbers are prototype values.
local A = ::AfeixExpedition;
// BEGIN GENERATED MEMBER GROWTH
A.MemberGrowth <- {
    afei = {
        title = "把名字写到旗底下",
        scene = "阿飞提笔想把旗上的“嘉豪”再描大一圈，墨却滴在了旗底那一排名字旁边。三仗打下来，这些名字谁站哪儿他已经记熟了，也记得自己哪一步又是大谋替他补的窟窿。\n\n他放下笔，拿起盾，看了看火堆边的人。今晚练什么，他得自己定。",
        choices = [
            {
                label = "先把自己站稳，别老让人补窟窿",
                outcome = "盾带重新系过，阿飞把最难看的那一步练了一遍又一遍。没人叫好，他也没停。第三遍总算稳了，他才腾出空问一句：刚才帅不帅？",
                traitName = "站稳的团长",
                bonuses = {
                    MeleeSkill = 2,
                    Bravery = 2
                }
            },
            {
                label = "先听兄弟们要什么，再开口带人",
                outcome = "他把凳子往后挪了挪，让别人先说。好几回想抢话，都硬咽了回去。等轮到他开口，嗓门还是那么大，交代的事倒比从前清楚多了。",
                traitName = "听得见伙伴",
                bonuses = {
                    Bravery = 4
                }
            }
        ]
    },
    damou = {
        title = "大哥这次借我来教",
        scene = "营火边，新来的请大谋把刚学来的握枪法再讲一遍。门口又有个高手冲他招手，想跟他过两招。大谋两头看看，想起阿飞头一回举盾，嘴上说会了，手还是握反的。\n\n盾在膝边，枪也在手边。今晚这身本事，先往哪边使？",
        choices = [
            {
                label = "留下来，把动作拆开教新人",
                outcome = "他把动作一截截拆开，教到新人自己能站住。讲着讲着才发现，自己收盾那一下也一直是糊弄过去的，干脆跟着一块儿重练了两遍。",
                traitName = "借招会教",
                bonuses = {
                    MeleeDefense = 2,
                    Stamina = 3
                }
            },
            {
                label = "先去跟高手过招，吃了亏再回来琢磨",
                outcome = "大谋回来就找了块空地，比划自己挨打的那一下，问来问去就一句：他怎么那么快？末了还补一句：“下回这位大哥，也得拉来咱们桌上坐坐。”",
                traitName = "借招求真",
                bonuses = {
                    MeleeSkill = 3,
                    Bravery = 2
                }
            }
        ]
    },
    mocha = {
        title = "这笔账写给谁",
        scene = "抹茶把结清的旧账摊开。赚得不多，饭钱和修补钱倒一文没少。他留出下一趟的余钱，笔尖又停在一笔他自己垫付的开销上。\n\n阿飞以为要挨骂，已经坐得笔直。算盘声忽然停了，抹茶把账本转过来对着火光。",
        choices = [
            {
                label = "把余钱留够，账尾那一行自己守着",
                outcome = "余钱算了两遍，最后一栏写上了抹茶自己的名字。他合上账本，顺手把明天哪段路归他守也定了下来。",
                traitName = "算盘留底",
                bonuses = {
                    Stamina = 4,
                    Bravery = 2
                }
            },
            {
                label = "垫付的那笔也写进正账",
                outcome = "那笔垫付挪回了正页，账本推到三个队长中间。阿飞这回没等算盘响，自己先把名字签了上去。",
                traitName = "幕后也署名",
                bonuses = {
                    RangedSkill = 2,
                    Bravery = 3
                }
            }
        ]
    },
    bottle = {
        title = "这一次球给谁",
        scene = "旧球靠在车轮边，小酒瓶用鞋尖轻轻一拨。阿飞记得自己头一回接漏球就是在那个位置，这会儿正好有个新人从那边伸出手来。\n\n前面有个好空当，旁边有只等球的手。瓶队这脚怎么踢，她自己说了算。",
        choices = [
            {
                label = "球收回来，自己往空当里冲",
                outcome = "她把球一收，一头扎进空当。阿飞刚要喊蛤妈，她先笑着把话截了：“这一个，记瓶队头上。”",
                traitName = "瓶队突破",
                bonuses = {
                    MeleeSkill = 3,
                    Initiative = 3
                }
            },
            {
                label = "看准那只手，把球传过去",
                outcome = "球稳稳落到那只手里，她等对方自己迈出下一步才跟上去。车铃响了一声，阿飞这回总算没上去抢球。",
                traitName = "递球的蛤妈",
                bonuses = {
                    Bravery = 4,
                    MeleeDefense = 2
                }
            }
        ]
    },
    shuaizi = {
        title = "鼓停的一拍",
        scene = "第三声鼓刚落，鼓槌从白小帅子手里滑了出去。营里什么事都没有，她自己倒先吓得抽了口气，眼眶一下就红了。有人已经迈出步子，又回过头来等那第四声。\n\n她捡起鼓槌，按了按胸口，看向门边那几个人。",
        choices = [
            {
                label = "重新敲四下，把拍子守完",
                outcome = "“刚才那下不算，重来。”她先认了自己吓着了，又一声声敲足四下。门边的人等齐了才动，这回没人抢她的拍子。",
                traitName = "小心脏守拍",
                bonuses = {
                    MeleeDefense = 3,
                    Hitpoints = 3
                }
            },
            {
                label = "直接喊出第四拍，把走出去的人叫回来",
                outcome = "“四！”她扯着嗓子先喊了出来，把已经迈步的人拽回了拍子上。等队伍走稳了，她才回头瞪人：“要笑也等我喊完行不行。”",
                traitName = "鼓停也能喊",
                bonuses = {
                    Bravery = 4,
                    Initiative = 4
                }
            }
        ]
    },
    lili = {
        title = "没有观众的高背椅",
        scene = "练靶场的灯灭了一半，李李还把高背椅搬到了靶子边上，说超巨还有最后一箭。阿飞想去叫几个人来看，她却指着旧靶纸：同一个地方，偏了可不止一回。\n\n弓已经拉了一晚上，地上全是她射完后挪步的脚印。今晚她还想换个练法。",
        choices = [
            {
                label = "接着校那一箭，别拿欧气当借口",
                outcome = "灯下没人喝彩，靶纸上的偏差倒是小了一点。李李收弓的时候照样要问一句这箭看着怎么样，然后亲手把那张纸卷了起来。",
                traitName = "超巨再一箭",
                bonuses = {
                    RangedSkill = 3,
                    Initiative = 3
                }
            },
            {
                label = "专练射完以后的收势和退步",
                outcome = "椅子挪到一边，射完往后退一步，重心不再拖在原地。她又绕到灯外头，冲阿飞挑挑眉：“这回，找着我没有？”",
                traitName = "灯外的收势",
                bonuses = {
                    MeleeDefense = 2,
                    RangedDefense = 3
                }
            }
        ]
    },
    xiaoyueya = {
        title = "超市今日换招牌",
        scene = "小月牙把三样没派上用场的零件摆成一排，宣布超市上新货。没人来问，她就自己演示：旧绳换个系法，松掉的铁环换个握法。\n\n抹茶指着摊子问哪样今天能用上。三件货，她总得先弄成一件。",
        choices = [
            {
                label = "挑一个怪点子反复试，练准出手的时机",
                outcome = "同一个系法试了好几遍，手总算跟上了她嘴里那个怪名字。阿飞刚想鼓掌，她先让他再试一回，好证明超市这回真有货。",
                traitName = "超市会变招",
                bonuses = {
                    RangedSkill = 2,
                    Initiative = 4
                }
            },
            {
                label = "先把现成的法子练熟，力气留着下回用",
                outcome = "现成的法子练熟了，她在招牌背面添了一行：先用明白。旧零件照样摆得整整齐齐，新点子等有余力了再开张。",
                traitName = "旧货也耐用",
                bonuses = {
                    Stamina = 5,
                    MeleeSkill = 2
                }
            }
        ]
    },
    yuchujiu = {
        title = "叫停之后还要回话",
        scene = "初九一嗓子“停！”，记战报的人差点从凳子上蹦起来。营外没敌人，她指的是昨天那份战报上漏画的一段后撤。\n\n阿飞总算看明白了哪里空着，问她接下来怎么办。初九把战报压平。喊停容易，后半截总得有人接上。",
        choices = [
            {
                label = "把险处说透，自己守住后手",
                outcome = "她在漏掉的地方写上自己的名字，怎么接应也一条条讲清楚。阿飞想插嘴，先被她撵去把那一段重新走了一遍。",
                traitName = "叫停也负责",
                bonuses = {
                    Bravery = 4,
                    MeleeDefense = 2
                }
            },
            {
                label = "把看到的缩成几个字，让兄弟们接得更快",
                outcome = "一长串报告缩成了最要紧的几个字：先喊位置，再喊危险。嗓门一点没小，可这回听见的人都知道该先往哪儿看。",
                traitName = "初九报得准",
                bonuses = {
                    Initiative = 4,
                    RangedSkill = 2
                }
            }
        ]
    },
    xiaoyubeike = {
        title = "大哥也要换一口气",
        scene = "小鱼举着盾讲昨天那一下顶得有多稳，讲到一半，自己先喘上了。有人又喊她“唯一的男人”，她斜眼一瞥：“来，你当一会儿。”\n\n旁边还真伸过来一只手。她松了松盾带，先掂量自己还剩几分力气。",
        choices = [
            {
                label = "让人接过盾，把这口气喘匀",
                outcome = "盾递了过去，“大哥”这名号也顺手递了。等气喘匀了，她再把盾接回来站好，嘴上还不忘问一句：刚才那会儿大哥当得怎么样？",
                traitName = "换气再顶",
                bonuses = {
                    Stamina = 5,
                    Hitpoints = 3
                }
            },
            {
                label = "说清自己还剩几分力，练短促的出手",
                outcome = "还能撑多久，她先说了个准数，又把出手缩成短短一下，练到收得住为止。等盾再举起来，旁边的人也知道什么时候该上来接了。",
                traitName = "顶上去的分寸",
                bonuses = {
                    MeleeSkill = 3,
                    Hitpoints = 3
                }
            }
        ]
    },
    wangduidui = {
        title = "太子先定一条",
        scene = "令牌背后的三个问题都答完了，偏有人起哄：“这回让太子自己定！”怼怼先被呛了一下，低头翻了翻令牌，没找到第四个问题。\n\n阿飞也没替她接话。人都在，事也问清了，就等她拿主意。",
        choices = [
            {
                label = "照说好的底线，自己拍板",
                outcome = "令牌翻回正面，她把安排说了一遍。末了照样怼了起哄的人一句，可自己定下的事，她没再推回团长手里。",
                traitName = "太子敢作主",
                bonuses = {
                    Bravery = 5
                }
            },
            {
                label = "先把最容易漏的地方补上一道防线",
                outcome = "最容易漏的地方先补上了，谁来接、在哪接，全说得明明白白。阿飞听完笑了：这回太子自己的问题，她也都答上了。",
                traitName = "怼到关键处",
                bonuses = {
                    MeleeDefense = 2,
                    RangedDefense = 2
                }
            }
        ]
    },
    laocai = {
        title = "给改图的人留名",
        scene = "老蔡把地图上空着的那一角摊开，请兄弟们把昨天走过的路标上去。两笔新线一落，正好穿过他原先没算到的地方。\n\n木旗还在桌上。他亲手抹掉了自己原来的判断，腾出地方重新摆。",
        choices = [
            {
                label = "把漏掉的接应揽到自己身上，练稳退步",
                outcome = "漏掉的那处接应，他写到了自己名下，又找了块空地把退步和收身重新练了一遍。纸上的箭头改了，脚下那一步也跟着改了。",
                traitName = "木旗守尾",
                bonuses = {
                    Bravery = 3,
                    MeleeDefense = 2
                }
            },
            {
                label = "重摆木旗，练着先看新冒出来的空当",
                outcome = "木旗重摆，空角上添了几个兄弟的名字。老蔡这回先问新消息，再画下一条线，图边还特意留了块能改的地方。",
                traitName = "地图留白",
                bonuses = {
                    Initiative = 5,
                    RangedDefense = 2
                }
            }
        ]
    },
    yanzi = {
        title = "把自己的话说完",
        scene = "明天谁守前排，又在火堆边吵起来了。眼子讲了个笑话，两人都笑了，可那一班还是推来推去没人接。\n\n他把盾往中间一放，先说自己的打算。是扛着盾把脚跟站稳，还是盯着两边帮人换位，今晚还能再练一轮。",
        choices = [
            {
                label = "说清自己守哪段，扛盾站稳",
                outcome = "他把自己肯守的那一段说完，没再替别人把剩下的班也揽了。第二天练盾，脚底下也更肯钉在那一步上。",
                traitName = "说清立场",
                bonuses = {
                    Bravery = 2,
                    MeleeDefense = 2
                }
            },
            {
                label = "先看清两边的动静，再帮人换位",
                outcome = "吵架变成了几轮换位练习。他先看清两边谁缺空当，再开口提醒。昨天嘴上没说通的事，今天在脚底下演了出来。",
                traitName = "看清再接话",
                bonuses = {
                    Initiative = 3,
                    RangedDefense = 2
                }
            }
        ]
    },
    tiantong = {
        title = "最后一张回执",
        scene = "小虎把旧信袋倒过来抖了抖，一张没用过的回执掉到桌角。这封信今天还送不到，她就让那一栏先空着，拿起弓往靶场走。\n\n瞄准目标、回头看队尾，都是她做惯了的事。今晚有空，她想把其中一样练得更熟。",
        choices = [
            {
                label = "先把目标看死，再松弦",
                outcome = "她等眼睛定住了才松弦，一箭一箭地校。回执还压在袋底，下回谁再说“到了”，她照样要再问一遍。",
                traitName = "小虎送得准",
                bonuses = {
                    RangedSkill = 3,
                    Bravery = 2
                }
            },
            {
                label = "把回头看队尾练成习惯",
                outcome = "先站稳脚，再回头看兄弟们在哪儿。练顺了以后，她回头不再慌慌张张，给队尾留的那一步也宽了些。",
                traitName = "回头有余地",
                bonuses = {
                    RangedDefense = 3,
                    Initiative = 3
                }
            }
        ]
    },
    xiaoning = {
        title = "外星图画给谁看",
        scene = "怪记号又画满了一页，嘴角的口水差点把一个圆点洇没了。看图的人说这图不是给地上的人看的，小宁马上反问：那你的近路怎么少了两个岔口？\n\n两人都笑了。她擦擦嘴，把图转正。今晚先补哪一处，还得她自己挑。",
        choices = [
            {
                label = "怪画法留着，但射线要标得别人看得懂",
                outcome = "圆点和射线各添了一句说明，别人终于能跟着她指到同一个地方。小宁看完又补了个怪符号，说这回总该懂了吧。",
                traitName = "外星图也能读",
                bonuses = {
                    RangedSkill = 3,
                    Initiative = 3
                }
            },
            {
                label = "把退路画宽一点，给自己留余地",
                outcome = "退路画宽了一格，她照着新位置重新试了几步。图还是怪，可至少这一回，她自己没挤到纸外头去。",
                traitName = "图外的一格",
                bonuses = {
                    RangedDefense = 2,
                    Stamina = 4
                }
            }
        ]
    },
    xiaopangxu = {
        title = "负重里的第四拍",
        scene = "第四拍没踩在粉线上，一身重甲把小胖的转身拖慢了半步。阿飞拿嘉豪步伐打趣她，她一把把人拽进空地：“那你来。”\n\n团长也踩歪了。两人低头看着脚印，小胖先定下了今晚要重练的那一步。",
        choices = [
            {
                label = "卡拍的狠劲留着，重练起步和收势",
                outcome = "起步和收势拆开重练，新的重心总算踩进了老拍子里。她跳完一轮，立马叫刚才打趣的人跟上，这回那只桶放得远远的。",
                traitName = "街舞卡拍",
                bonuses = {
                    Initiative = 5,
                    MeleeSkill = 2
                }
            },
            {
                label = "砍掉一段转身，先把负重站稳",
                outcome = "少转一圈，第四拍落得结结实实。她拍拍身上的甲片，说等卸了这身铁，花样还得跳回来。眼下先把脚站住。",
                traitName = "第四拍站稳",
                bonuses = {
                    MeleeDefense = 3,
                    Stamina = 3
                }
            }
        ]
    },
    dae = {
        title = "锅和人先数哪一个",
        scene = "公物单上少了一口旧锅，大鹅的嗓门立马高了半截。值守名单翻过来一看，该回来的人倒是一个不少。\n\n她挨个听完应声，才把锅的事写到一边。今晚还能练一轮：守住窝口，或者把叫人回来的号子喊清楚。",
        choices = [
            {
                label = "把盾边练稳，守住兄弟们回来的地方",
                outcome = "盾边收得更稳了，她让兄弟们从身后轮流穿过去。锅还得接着查，回来的那条路先给大家留好了。",
                traitName = "大鹅守窝",
                bonuses = {
                    MeleeDefense = 3,
                    Bravery = 2
                }
            },
            {
                label = "把叫人回来的号子喊清楚，自己站到边上接应",
                outcome = "号子短了，应得也齐了。她自己先站到接应的位置上，冲锋时照样嘎嘎地喊，这回大家都知道什么时候该往回跑。",
                traitName = "鹅势有后手",
                bonuses = {
                    Hitpoints = 4,
                    Bravery = 3
                }
            }
        ]
    },
    manyuemei = {
        title = "红线也能听见异议",
        scene = "蔓越莓刚把红线拉直，说了句别抢话，大谋就指着一枚漏摆的木片。她看了一眼，先改了，再让他把理由说完。\n\n新位置让出一道窄缝，她端起轻弩比了比。这一下怎么用好，今晚正好试试。",
        choices = [
            {
                label = "话照样短，但让人把反对的话说完",
                outcome = "每条安排都说得又短又清楚，反对的人也能把话说完。红线还是她来拉，可这回站上去的人都知道为什么。",
                traitName = "红线定节奏",
                bonuses = {
                    Bravery = 4,
                    Initiative = 3
                }
            },
            {
                label = "别抢拍，专练看清前排让出来的缝",
                outcome = "她等前排站稳了那么一下，才端弩去瞄那道缝。该等的那半拍总算等住了，出手反倒没那么急了。",
                traitName = "红线看得清",
                bonuses = {
                    RangedSkill = 3,
                    RangedDefense = 2
                }
            }
        ]
    },
    xiaohani = {
        title = "够用的一袋，自己的那份",
        scene = "行囊一抖，干饼、栗子、备用布条摊了一小片。阿飞笑她是不是把整个窝都背来了，罗一可刚要回嘴，肩带就勒得她一顿。\n\n她把粮分成两袋，摸了摸存路费的那根结绳。下一程带多少，自己那份放哪儿，她想先理清楚。",
        choices = [
            {
                label = "按路程分装，留够走下一段的力气",
                outcome = "重复的东西放回车上，肩上只背够用的一袋。再上路时栗子还在，她也不用再追着行囊的分量走了。",
                traitName = "小袋长路",
                bonuses = {
                    Stamina = 5,
                    Initiative = 2
                }
            },
            {
                label = "先说好哪份是自己的，守住该站的位置",
                outcome = "两根绳打了两种结，公用的一袋，自己的一袋。她把愿意分的摆出来，剩下的收回手边，阿飞这回没伸手抢。",
                traitName = "有主的小粮仓",
                bonuses = {
                    Bravery = 4,
                    MeleeDefense = 2
                }
            }
        ]
    },
    keke = {
        title = "自己人也要先问",
        scene = "可可把旧护带摊平，想起上回替阿飞系带的时候，竟忘了问他想站哪边。护带结上还挂着保可梦们送的红白小球，飞爹倒不在意，已经扛着练习用的靶子过来了。\n\n她摸摸弩，又看看自己的落脚。照应别人的法子多的是，今晚也该给自己挑一样练。",
        choices = [
            {
                label = "先听人家自己怎么想，再练准后排那一箭",
                outcome = "先问清兄弟们的打算，她才简短地提醒两句。随后端弩校准，箭落在哪，她要亲眼看到，不再光顾着替别人看位置。",
                traitName = "保可梦看准",
                bonuses = {
                    RangedSkill = 3,
                    Bravery = 2
                }
            },
            {
                label = "先把自己站稳，再伸手拉人",
                outcome = "自己的盾和脚步先摆稳了，她才伸手去接人。护带照旧系得妥妥帖帖，身侧那个空当也没再被她忘到最后。",
                traitName = "自己人先站稳",
                bonuses = {
                    MeleeDefense = 3,
                    Hitpoints = 3
                }
            }
        ]
    },
    yuxiang = {
        title = "五老这班怎么交",
        scene = "余想把值守钥匙往桌子中间一放：“下一班谁？”有人拿“五老压阵”起哄，她不搭腔，只等一个名字。\n\n名字和时辰终于写下来了。她拎起长矛，还够练一轮。久站的本事得磨，接班的人按时到，也一样不能含糊。",
        choices = [
            {
                label = "接着练守位，换班的时辰先说在前头",
                outcome = "她又站了一轮，时辰一到，接班的人真站到了跟前。长矛交出去，肩膀总算能松下来，下回守位也知道该留几分力。",
                traitName = "五老守得稳",
                bonuses = {
                    Stamina = 5,
                    MeleeDefense = 2
                }
            },
            {
                label = "把要求说死，接班的人到齐了才点头",
                outcome = "她把要求一条条说清，接班的人到齐了才点头。五老的名号照样响，可这张轮值表上总算不止她一个名字了。",
                traitName = "五老要替班",
                bonuses = {
                    Bravery = 4,
                    Hitpoints = 3
                }
            }
        ]
    },
    tongzhu = {
        title = "小熊也能改规矩",
        scene = "木熊摆上了桌，可老规矩让一个伤了胳膊的兄弟没法上场。阿飞想偷偷放水，童猪先把熊收了回去：“要改就当着大家的面改。”\n\n她看着桌上那盘旧局，嫌弃脸都摆好了。先讲新规矩，还是先查漏洞，她自己定。",
        choices = [
            {
                label = "当众讲清新规矩，愿意的再来",
                outcome = "新规矩念完，她头一个下场示范。有人又想抢答，她拿杯子一敲，桌边又等齐了，笑声也在同一拍响了起来。",
                traitName = "小熊讲规矩",
                bonuses = {
                    Bravery = 4,
                    Hitpoints = 3
                }
            },
            {
                label = "把旧局重摆一遍，找出真正的漏洞",
                outcome = "旧局重摆，卡住人的那一步总算找到了。木熊照旧坐在桌上，童猪也能把这条规矩为什么要改讲得更明白了。",
                traitName = "小熊看得细",
                bonuses = {
                    Initiative = 4,
                    MeleeDefense = 2
                }
            }
        ]
    },
    meiya = {
        title = "大王也要换一拍",
        scene = "大王舞的鼓点敲完，两个兄弟还是在同一拍上撞了肩。有人想把其中一个撵到后排去，美伢先让他俩各走一遍，自己蹲下来看落脚。\n\n起拍能改，撑完一整段的气也得练。上了就拼，菜了就练，她站起来准备亲自示范。",
        choices = [
            {
                label = "改起拍，让动作接得更利落",
                outcome = "起拍改了，两人总算接上了。她走完最后一步，夸张地冲看热闹的人让了个位，逗得鼓手差点又敲乱了拍子。",
                traitName = "大王起拍",
                bonuses = {
                    Initiative = 4,
                    MeleeSkill = 2
                }
            },
            {
                label = "收一收花样，把呼吸和落脚连起来",
                outcome = "花样收紧了，呼吸和落脚一段段接顺了。鼓再响起来，她照样跳得大大方方，这回整段跳完，气也没断。",
                traitName = "大王舞得久",
                bonuses = {
                    Stamina = 5,
                    MeleeDefense = 2
                }
            }
        ]
    },
    wanshe = {
        title = "神也把落脚看清",
        scene = "门边有人喊“秦国的神”，玩蛇还蹲在地上看昨天的脚印。那一下转身漂亮是漂亮，最后一脚差点踩出了场子。\n\n她划掉多余的那道弧，重新提起木剑。出招和收招，今晚总得先磨好一头。",
        choices = [
            {
                label = "把最管用的那一招练干净",
                outcome = "少了两下转腕，木剑反倒到得更快。她照样给这招起了个响亮的名字，只是这回演示快得看客还没喊完名字就结束了。",
                traitName = "秦国一招",
                bonuses = {
                    MeleeSkill = 3,
                    Initiative = 2
                }
            },
            {
                label = "先把退步练明白，再谈下回输赢",
                outcome = "退步一遍遍练过，收剑以后总算站稳了。有人急着叫好，她指指脚底下，让人先把最后那一步看清楚。",
                traitName = "蛇形收势",
                bonuses = {
                    MeleeDefense = 3,
                    Stamina = 2
                }
            }
        ]
    },
    tutu = {
        title = "再留一晚由谁说",
        scene = "歌唱完了，掌柜又说再留一晚吧。涂涂放下琴，问这一晚是想听下一首，还是有话还没说完。\n\n茶重新倒上，路票也摊在桌边。留多久、下一站去哪儿，她可以慢慢说，也想让自己走得从容些。",
        choices = [
            {
                label = "答应留一晚，但下一站她自己说了算",
                outcome = "她应下了这一晚，也把下一站的打算说完了。歌照样唱得温温和和，可告别的时辰一点没省，掌柜这回认真点了头。",
                traitName = "这一晚我决定",
                bonuses = {
                    Bravery = 5
                }
            },
            {
                label = "先把气息练匀，把路分成几段走",
                outcome = "气息重新分段练过，她收琴的时候不再急着赶路。路票按站折好，下一程也有了能歇脚、能接着聊的地方。",
                traitName = "回头路有余力",
                bonuses = {
                    Stamina = 5,
                    Initiative = 2
                }
            }
        ]
    },
    naigai = {
        title = "嘴强王者拆自己的台",
        scene = "昨晚的战报念到“本王一人包围敌阵”，奶盖自己先笑出了声。阿飞想替她圆过去，她赶紧摆手：“这句可别真记上。”\n\n盾就靠在凳子边，盾带已经修好了。嘴上的本事还能接着使，手上的本事也该练一轮了。",
        choices = [
            {
                label = "亲口说清哪句吹了，玩笑照样留着",
                outcome = "她亲口点出吹过头的那句，火堆边笑得更响了。下一段她照样讲得天花乱坠，只是大家都知道本王今天到底干了哪几件事。",
                traitName = "吹完也认账",
                bonuses = {
                    Bravery = 5
                }
            },
            {
                label = "战报收起来，先把盾举完这一轮",
                outcome = "这一轮盾举完了，中间奶盖往后缩过几回，手却再没松开盾带。阿飞要叫好，她先把气喘匀了，才补一句：本王早有安排。",
                traitName = "奶盖举得住",
                bonuses = {
                    MeleeDefense = 3,
                    Stamina = 3
                }
            }
        ]
    },
    xiaojie = {
        title = "备用钥匙交给谁",
        scene = "车边又有人等着借工具，小杰把备用钥匙攥在手心里。锁车的规矩讲了一遍又一遍，可要是她正好不在，总不能让所有人干等着。\n\n她看了看交接单，又把常用的工具摊开。今晚先理顺哪一样，她心里有两个打算。",
        choices = [
            {
                label = "挑个信得过的人一起管，交接说清楚",
                outcome = "钥匙交给了她挑的人，交接单当面写好。她出门转了一小圈，回来一核对，什么都没少，总算不用一直守在那把锁旁边了。",
                traitName = "钥匙有人接",
                bonuses = {
                    Bravery = 3,
                    Initiative = 3
                }
            },
            {
                label = "工具和手上的动作一样样练熟",
                outcome = "工具和动作一样样试熟了，常用的都摆在顺手的地方。再有人来借，除了听见锁响，还能看她当场示范该怎么用。",
                traitName = "锁得住也用得好",
                bonuses = {
                    MeleeSkill = 3,
                    Stamina = 3
                }
            }
        ]
    },
    bula = {
        title = "钱袋变成谁能用的东西",
        scene = "店家把贵货摆得很气派，bula却把采买单分给真正要用的人，请他们一人试一件。有人嫌便宜的卡手，有人觉得贵的不过是多了些花样。\n\n她听完，把钱袋放回桌上。这一笔花在哪儿，她得自己拿准。",
        choices = [
            {
                label = "听完各人要什么，再拍板",
                outcome = "该问的都问过了，她把选中的货一件件说清楚。钱袋没变厚，买回来的东西倒都有人接着用，抹茶核账时也少问了几句。",
                traitName = "钱袋问对人",
                bonuses = {
                    Bravery = 4,
                    MeleeDefense = 2
                }
            },
            {
                label = "把合手和不合手的差别一样样看清",
                outcome = "握带、分量、收放，她一样样比过去，指出了几处价目单上看不出来的差别。最后退回去的那件很漂亮，可确实不大合手。",
                traitName = "合用的那一件",
                bonuses = {
                    RangedDefense = 3,
                    Initiative = 3
                }
            }
        ]
    },
    suwa = {
        title = "快半步也能带别人走",
        scene = "最快的近路刚画好，镇上的向导就指出一个没标的岔口。苏袜伸脚比划了两下，才发现腿记得要拐，纸上却没写。\n\n她重新拿起炭笔，又往岔口跑了半截。急刹，还有等别人跟上的那一下，今晚都值得再练。",
        choices = [
            {
                label = "练急刹和再起步，快也得有个停的地方",
                outcome = "停下和再起步一块儿练过，图上也添了显眼的记号。她还是爱抢那半步，可这回在路口停住了，后头的人总算看明白了。",
                traitName = "快半步会急刹",
                bonuses = {
                    Initiative = 6
                }
            },
            {
                label = "把路分成几段，让别人跟得上",
                outcome = "路线拆成了几段，每段都留了个集合的地方。她回头看见兄弟们跟上来了才接着走，自己也多攒下一口往前冲的气。",
                traitName = "快路能同行",
                bonuses = {
                    Stamina = 5,
                    Bravery = 2
                }
            }
        ]
    },
    qianhan = {
        title = "003按自己的起跑线",
        scene = "有人把003介绍成“第三位传奇”，千涵马上把练习簿递过去，指着上面几格空白。机会她想争，可成绩不能提前填。\n\n她重新量了起跑线，站到短坡前头。起步和后半程，今晚还够练一样。",
        choices = [
            {
                label = "把起步练稳，别替自己吹满",
                outcome = "起步反复试稳了，她在003旁边记下了一个新成绩。空格还没填满，可这个新起点已经能拿给人看了。",
                traitName = "003起跑",
                bonuses = {
                    MeleeSkill = 3,
                    Initiative = 3
                }
            },
            {
                label = "按坡段调呼吸，把后半程认真跑完",
                outcome = "呼吸按坡段调好，最后一格总算填上了。千涵来回看了两遍，比听人喊她传奇还高兴，又把木牌仔细擦了擦。",
                traitName = "003分段呼吸",
                bonuses = {
                    Stamina = 6
                }
            }
        ]
    },
    wangdazhi = {
        title = "幕布前这回也有她",
        scene = "位置排好了，王大芷自己的名字又被挤到了页边上。她把笔递出去一半，忽然又收了回来，把那张纸转向了自己。\n\n芷芷想上台，也知道场子得有人守。今天站哪边，最好她自己先开口，再把要谁配合一并写进去。",
        choices = [
            {
                label = "把自己的节目写进安排，站出来说清楚",
                outcome = "她先念了自己的名字，把登场时辰写进了正栏。别的位置照样排得妥妥当当，这一回，幕布前头确实给她留了地方。",
                traitName = "芷芷也登场",
                bonuses = {
                    Bravery = 4,
                    Initiative = 3
                }
            },
            {
                label = "自己选定守场，把要的配合讲出来",
                outcome = "她选了守场，要谁搭手、什么时候换人都说清了。名字还在后排，旁边却有了她自己定的安排和来接班的人。",
                traitName = "站稳自己选的场",
                bonuses = {
                    MeleeDefense = 3,
                    Stamina = 3
                }
            }
        ]
    },
    yaoyaoya = {
        title = "吕布先把约定看一眼",
        scene = "挑战书上“奶团吕布”四个字写得老大，瑶瑶牙没急着拍桌子，先回头看了眼黑旗边上那张护送安排。答应下来的那趟活，时辰还在前头。\n\n比试可以改天，今晚先磨一磨出手，或者把收招以后的那口气留足。她把长斧扶到身边。",
        choices = [
            {
                label = "挑出最管用的一击，练到收得住",
                outcome = "最管用的那一击反复练过，收招时少露了一个破绽。名号照样有人喊，她倒先问旁边的人：这一下你跟得上吗？",
                traitName = "奶团吕布一击",
                bonuses = {
                    MeleeSkill = 4
                }
            },
            {
                label = "练好回头看旗以后的收步和换气",
                outcome = "回头看旗，收步，换气，几遍下来还留着余力。下一趟护送的安排收好了，她才回头去写那封挑战的回信。",
                traitName = "吕布留后力",
                bonuses = {
                    Stamina = 5,
                    MeleeDefense = 2
                }
            }
        ]
    },
    yangmiemie = {
        title = "铃响在哪一个弯",
        scene = "羊咩咩拿小铃比划着怎么过弯，驿差却咬定另一条线更快。两人吵完才看清，两辆车装的分量根本不一样。\n\n她把两车的分量分别记下，又在地上画出弯前和弯后的位置。今晚可以练反应，也可以试着把力气留到后半段。",
        choices = [
            {
                label = "先看准线，再决定什么时候抢",
                outcome = "线看准了，她才决定从哪一下开始追。铃声再响，急着往前迈的脚也能等她先看一眼弯后的空当。",
                traitName = "弯前听铃",
                bonuses = {
                    Initiative = 4,
                    RangedDefense = 2
                }
            },
            {
                label = "弯前省下的力气，留到下一段用",
                outcome = "弯前松一点，弯后再发力，她把这一段来回练了好几遍。车出了弯还推得动，下一段也不用再咬着牙硬撑了。",
                traitName = "弯后还有力",
                bonuses = {
                    Stamina = 5,
                    Hitpoints = 3
                }
            }
        ]
    },
    songnuanyang = {
        title = "鹌鹑探头那一句",
        scene = "战报结尾空着，有人催宋暖阳添两句凯歌。她先把兜帽缩了缩，又探出头问：“那段撤得乱七八糟的，也这么写？”\n\n桌边安静了一会儿。她把笔搁到一边。还没问清的事、刚才看见的细节，都值得留点地方。",
        choices = [
            {
                label = "把那句话问完，再决定怎么写",
                outcome = "问题问完了，她等到回答才落笔。兜帽听见响动还是会缩一下，可那句真正想问的话，这回没跟着缩回去。",
                traitName = "鹌鹑敢开口",
                bonuses = {
                    Bravery = 4,
                    Hitpoints = 3
                }
            },
            {
                label = "先看再记，没弄清的就空着",
                outcome = "她把细节重新查了一遍，没看清的就空着。战报短了几行，可读的人都能认出自己那天到底干了些什么。",
                traitName = "鹌鹑看得细",
                bonuses = {
                    RangedDefense = 3,
                    Initiative = 3
                }
            }
        ]
    },
    xiaogui = {
        title = "这场先听我复盘",
        scene = "小龟把三仗的记录叠好，准备拿给飞爹看，最上面那张却是她自己失手的那一下。她指着进退之间的空当，小声说：这儿我判断慢了。\n\n阿飞这回没抢着替她解释。小龟把战报摊平，自己挑下一步怎么练。",
        choices = [
            {
                label = "把看见空当后的那一步练快",
                outcome = "看见空当以后的那一步练快了，她把自己的思路从头讲到尾。战报末尾，她亲手添上了下回的打算，飞爹在旁边听得很认真。",
                traitName = "给飞爹看自己的路",
                bonuses = {
                    Initiative = 5,
                    RangedSkill = 2
                }
            },
            {
                label = "失手以后先守住站位，再找下一次机会",
                outcome = "失手了先守住脚下，再等下一次机会。她在纸上画出退路，把自己的名字写在末尾，这才肯把战报交给阿飞。",
                traitName = "壳后也能站稳",
                bonuses = {
                    MeleeDefense = 2,
                    RangedDefense = 3
                }
            }
        ]
    }
};
// END GENERATED MEMBER GROWTH

A.PersonalTraitID <- "trait.afeix_personal";
A.storyAlive <- function(bro) {
    return bro != null && bro.isAlive() && !this.get("dead_" + this.characterId(bro), false);
};
A.personalBattles <- function(bro) {
    if (bro == null) return 0;
    local stats = bro.getLifetimeStats();
    return stats != null && "Battles" in stats && stats.Battles >= 0 ? stats.Battles : 0;
};
A.growthStatus <- function(key) {
    if (!this.isOrigin() || typeof key != "string" || !(key in this.MemberGrowth) || !(key in this.Characters)) return "unavailable";
    if (this.get("growth_done_" + key, false)) return "done";
    local bro = this.findCharacter(key);
    if (!this.storyAlive(bro)) return "unavailable";
    return bro.getLevel() >= 3 && this.personalBattles(bro) >= 3 ? "ready" : "locked";
};
A.growthRequirementText <- function(key) {
    if (typeof key != "string" || !(key in this.MemberGrowth)) return "没有这位伙伴的成长记录。";
    local status = this.growthStatus(key), bro = this.findCharacter(key);
    if (status == "done") return "已完成个人成长；原选择保留，不能重复领取或改选。";
    if (!this.storyAlive(bro)) return "本人需存活且仍在队；阵亡、离队或尚未招募时不能办理个人成长。";
    return "条件：本人 3 级、实际参战 3 次。目前 " + bro.getLevel() + " 级，实际参战 " + this.personalBattles(bro) + " 次。请在友好城镇或安全扎营处交谈。";
};
A.personalBonuses <- function(bro) {
    local bonuses = {};
    if (!this.isOrigin() || bro == null) return bonuses;
    local key = this.characterId(bro);
    if (typeof key != "string") return bonuses;
    if (key in this.MemberGrowth && this.get("growth_done_" + key, false)) {
        local index = this.get("growth_choice_" + key, -1);
        if (index >= 0 && index < this.MemberGrowth[key].choices.len())
            foreach (field, value in this.MemberGrowth[key].choices[index].bonuses) bonuses[field] <- value;
    }
    if (key == "afei" && this.get("bicycle_reward_granted", false)) {
        local choice = this.get("bicycle_choice", -1);
        local extra = choice == 0 ? { Bravery = 4, Hitpoints = 2 } : (choice == 1 ? { Stamina = 5, Initiative = 3 } : {});
        foreach (field, value in extra) bonuses[field] <- (field in bonuses ? bonuses[field] : 0) + value;
    }
    return bonuses;
};
A.personalBonusText <- function(bonuses) {
    local names = { Hitpoints = "生命", Stamina = "耐力", Bravery = "决心", Initiative = "先攻", MeleeSkill = "近战命中", RangedSkill = "远程命中", MeleeDefense = "近战防御", RangedDefense = "远程防御" };
    local text = "";
    foreach (field in ["Hitpoints", "Stamina", "Bravery", "Initiative", "MeleeSkill", "RangedSkill", "MeleeDefense", "RangedDefense"]) {
        if (!(field in bonuses) || bonuses[field] == 0) continue;
        text += (text == "" ? "" : "；") + names[field] + " +" + bonuses[field];
    }
    return text == "" ? "尚未取得成长加成" : text;
};
A.syncPersonalGrowth <- function(bro) {
    if (!this.isOrigin() || bro == null) return false;
    local key = this.characterId(bro);
    if (typeof key != "string" || !(key in this.MemberGrowth) || !(key in this.Characters)) return false;
    local skills = bro.getSkills();
    if (skills.getSkillByID(this.PersonalTraitID) == null)
        skills.add(::new("scripts/skills/traits/afeix_personal_trait"));
    skills.update();
    return true;
};
A.resolveGrowth <- function(key, choice) {
    if (!this.isOrigin() || typeof key != "string" || !(key in this.MemberGrowth) || !(key in this.Characters)
        || typeof choice != "integer" || choice < 0 || choice >= 2) return this.result(false, "没有这项个人成长选择。");
    if (!this.canDiscussStory()) return this.result(false, "请到友好城镇或安全扎营处再作个人成长选择。");
    if (this.growthStatus(key) != "ready") return this.result(false, this.growthRequirementText(key));
    local bro = this.findCharacter(key), data = this.MemberGrowth[key].choices[choice];
    // World flags are the source of truth. No base attributes, XP or inventory are rewritten.
    this.set("growth_choice_" + key, choice);
    this.set("growth_done_" + key, true);
    try { this.syncPersonalGrowth(bro); if("syncMemberSkills" in this)this.syncMemberSkills(bro); }
    catch (error) {
        this.set("growth_done_" + key, false);
        this.set("growth_choice_" + key, -1);
        if("syncMemberSkills" in this)try{this.syncMemberSkills(bro);}catch(cleanupError){}
        ::logError("[AfeixExpedition] Personal growth refresh failed: " + error);
        return this.result(false, "成长特性未能更新，本次选择未完成；原有装备与经验保持。");
    }
    return this.result(true, data.outcome + "\n\n个性特长：" + data.traitName + "。 " + this.personalBonusText(data.bonuses) + "。");
};

A.RootOrder <- ["er_xiaoyuan", "er_haman", "er_sige", "er_keke", "er_xiaogui", "er_yuchujiu"];
A.RootStories <- {
    er_xiaoyuan = {
        name = "小原大人", required = 3, member = "", title = "飞爹先听我说完",
        opening = "酒馆里，小原大人朝阿飞招手，桌上还摆着一包专门给飞爹带的点心：‘飞爹，坐这儿。问你个事，队员说前面可能有埋伏，你怎么办？’\n\n‘那当然是我带头——’\n\n‘你看，我话还没说完。’\n\n阿飞端起酒杯，假装刚才只是口渴。小原把一张纸推过来：‘带队也得听劝。拿不准就说拿不准，别人有办法，也让人讲完。’\n\n阿飞把纸折好：‘行，这次你先说。’",
        followup = "小原临走前留了地址，让阿飞下次写信说说，队里有没有谁提过一个比团长更好的主意。阿飞摊开纸，想了想该怎么写。",
        choices = [
            { label = "‘我有时候没听完，就急着下令。这个得改。’", outcome = "小原回信：‘知道就好，下次可别又抢话。’信里还夹着一点旅费。阿飞把钱收好，没给自己找借口。", reward = { kind = "money", amount = 40 } },
            { label = "‘下回先让大家说说办法，再决定怎么做。’", outcome = "小原托人带来一包修理工具，附了张字条：‘听主意的时候，也听听谁的装备该修了。’阿飞把工具送去了辎重车。", reward = { kind = "tools", amount = 4 } }
        ]
    },
    er_haman = {
        name = "哈曼卡恩", required = 6, member = "", title = "先别说包赢",
        opening = "哈曼卡恩在酒馆拦住阿飞：‘听说你又跟人讲，跟着飞爹走，肯定没事？’\n\n阿飞拍了拍胸口：‘我这当团长的，总得让大家放心。’\n\n‘那碰上打不过的呢？药不够了呢？’\n\n阿飞的手停在胸口。哈曼把空酒杯推到一边：‘想让大家放心，就把准备说清楚。哪些仗能接，受伤了怎么办。光说包赢，伤口可不会自己好。’",
        followup = "回到住处，阿飞准备给哈曼写信。这回不写豪言壮语，先把自己能做的事说清楚。",
        choices = [
            { label = "‘打不过就撤，我不能保证每场都赢。’", outcome = "哈曼寄来一小包药，回信写着：‘这句比包赢管用。药带上，该撤的时候别逞强。’", reward = { kind = "medicine", amount = 3 } },
            { label = "‘出发前查好补给，有人受伤就先安排休息。’", outcome = "哈曼的信里夹着一点旅费：‘就照你说的办。买补给，别拿去换一面更大的旗。’阿飞看了一眼旗杆，默默收起了钱。", reward = { kind = "money", amount = 40 } }
        ]
    },
    er_sige = {
        name = "四哥", required = 9, member = "", title = "第四张凳子留给谁",
        opening = "四哥在酒馆订了一张桌子，旁边摆着四张凳子：‘你、大谋、抹茶，一人一张。’\n\n阿飞指着最后一张：‘这张等哪位大哥？’\n\n‘留给有话想说的队员。每回商量事情，总不能就你们三个讲。’\n\n‘那他们倒是说啊。’\n\n四哥笑了：‘你一坐下就开始吹，人家插得上嘴吗？’阿飞摸摸鼻子，把空凳往桌边拉近了一点。",
        followup = "四哥让阿飞以后写信，说说大家坐下来都聊了些什么。阿飞想了两个开头，决定先写一个。",
        choices = [
            { label = "‘下次先问新人，哪里没听懂，哪里想试试。’", outcome = "四哥托人送来一小包弹药：‘有人想练就给他练。你在旁边看着，别一上来就把活抢了。’", reward = { kind = "ammo", amount = 12 } },
            { label = "‘我先说说自己犯过的错，省得大家不敢开口。’", outcome = "四哥寄来一点旅费，信上写着：‘行，下次喝酒就听这个。你那几场大胜，我们都会背了。’", reward = { kind = "money", amount = 40 } }
        ]
    },
    er_keke = {
        name = "可可", required = 0, member = "keke", title = "有事就直说",
        opening = "整理名册时，阿飞翻到可可以前留下的一张便笺，边上画着一个小球。\n\n‘飞爹，你有事就直说，别每次都先拍胸口。累了就歇，不会就问。还有，喊我帮忙之前，先问问我手上的事忙完没有。’\n\n阿飞刚想嘀咕一句‘都是自己人’，往下一看，正好还有一行：‘自己人也得问。’\n\n他把话咽了回去，找了支笔。",
        followup = "便笺夹在可可留下的补给单里。阿飞准备在背面写几句话，把她的提醒记住。",
        choices = [
            { label = "‘我也有拿不准的时候，以后不硬装。’", outcome = "阿飞写完，在旁边加了一句‘真不装’。补给单里还夹着可可留下的零钱，他数好后收进了队伍的钱袋。", reward = { kind = "money", amount = 35 } },
            { label = "‘下回请你帮忙，先问你有没有空。’", outcome = "阿飞把这句话写在便笺背面，又按单子找出可可留下的药，放进队伍的药箱。", reward = { kind = "medicine", amount = 2 } }
        ]
    },
    er_xiaogui = {
        name = "溺水小龟", required = 0, member = "xiaogui", title = "飞爹，帮我看看这几步",
        opening = "小龟以前留了一份战报，纸角画着自己的圆脑袋。阿飞翻开，发现上面认真画了敌人站在哪儿、自己又走了哪几步。\n\n最后一行写着：‘飞爹，帮我看看。我这一下是不是冲早了？别光夸我壳硬。’\n\n阿飞提笔写了个‘猛’，看见那句提醒，又把字划掉。他把地图铺平，重新从第一步看起。",
        followup = "战报后面还有空白。阿飞准备留下自己的看法，再把小龟预留的补给收好。",
        choices = [
            { label = "‘先说说，你当时为什么往这边走？’", outcome = "阿飞圈出那一步，在旁边写了个问号。这次他没急着下结论。收起战报时，他把小龟预留的一包弹药放进了辎重车。", reward = { kind = "ammo", amount = 10 } },
            { label = "‘这里再等队友两步，就不用自己硬扛。’", outcome = "阿飞在图上补了两道箭头，把跟进的位置标清楚，又收好了小龟留下的修理工具。", reward = { kind = "tools", amount = 3 } }
        ]
    },
    er_yuchujiu = {
        name = "余初九", required = 0, member = "yuchujiu", title = "叫你飞爹，也能叫你停",
        opening = "初九留下的纸条上，一个‘停’字占了半页。阿飞展开时，仿佛又听见她在身后大喊。\n\n下面写着：‘飞爹，我喊你停的时候，你先停一下。前面可能有埋伏，也可能只是你跑太快，大家跟不上。等我把原因说完，你再决定追不追。’\n\n阿飞把纸翻过来，想写‘团长心里有数’，想了想，又把笔收住了。",
        followup = "阿飞把纸条压平，准备在背面写下以后该怎么办。旁边还放着初九以前留下的一点补给。",
        choices = [
            { label = "‘听见你喊，我先停下来。’", outcome = "阿飞写完，又补上一句：‘喊大声点，别让我装没听见。’他把纸条折好，连同初九留下的零钱一起收进队伍的钱袋。", reward = { kind = "money", amount = 35 } },
            { label = "‘先看清前面有什么，再商量追不追。’", outcome = "阿飞在纸上添了一条：‘追之前先点人数。’随后他把初九留下的药收好，放到了大家容易找到的地方。", reward = { kind = "medicine", amount = 2 } }
        ]
    }
};
A.rootStatus <- function(id) {
    if (!this.isOrigin() || typeof id != "string" || !(id in this.RootStories)) return "locked";
    if (this.get("root_done_" + id, false)) return "done";
    if (this.get("root_triggered_" + id, false)) return "opened";
    local data = this.RootStories[id];
    local available = data.member == "" ? this.progressCount() >= data.required : this.get("ever_" + data.member, false);
    return available ? "ready" : "locked";
};
A.rootsUnlocked <- function() {
    if (!this.isOrigin()) return false;
    foreach (id in this.RootOrder) if (!this.get("root_triggered_" + id, false)) return false;
    return true;
};
A.triggerRoot <- function(id) {
    if (!this.isOrigin() || typeof id != "string" || !(id in this.RootStories)) return this.result(false, "没有找到这段交谈记录。");
    if (!this.canDiscussStory()) return this.result(false, "请到友好城镇或安全扎营后再看。");
    local data = this.RootStories[id];
    if (data.member == "" && this.tavernStoryTown() == null && this.currentTown() == null) return this.result(false, "对方在城镇里，请到友好城镇见面。");
    if (this.rootStatus(id) == "locked") return this.result(false, "还没有收到对方的消息。");
    // Triggering the opening is deliberately independent of completing its follow-up.
    this.set("root_triggered_" + id, true);
    return this.result(true, data.opening + "\n\n已记入名册，可以稍后再回应。");
};
A.storyRewardText <- function(reward) {
    local labels = { money = "克朗", tools = "工具", medicine = "药品", ammo = "弹药" };
    return reward.amount + " " + labels[reward.kind];
};
A.grantStoryReward <- function(reward) {
    local assets = ::World.Assets;
    local get = { money = "getMoney", tools = "getArmorParts", medicine = "getMedicine", ammo = "getAmmo" };
    local add = { money = "addMoney", tools = "addArmorParts", medicine = "addMedicine", ammo = "addAmmo" };
    local set = { money = "setMoney", tools = "setArmorParts", medicine = "setMedicine", ammo = "setAmmo" };
    local old = assets[get[reward.kind]]();
    try {
        assets[add[reward.kind]](reward.amount);
        // Native supplies clamp to capacity. A partial grant must not consume a one-time reward.
        if (assets[get[reward.kind]]() - old != reward.amount) throw "Story reward did not fit in full";
    }
    catch (error) { assets[set[reward.kind]](old); throw error; }
};
A.resolveRoot <- function(id, choice) {
    if (!this.isOrigin() || typeof id != "string" || !(id in this.RootStories) || typeof choice != "integer" || choice < 0 || choice >= 2)
        return this.result(false, "没有这个选项，请返回后重新选择。");
    if (!this.canDiscussStory()) return this.result(false, "请到安全地点再回应。");
    if (this.rootStatus(id) != "opened") return this.result(false, "请先读完对方的话；已经领取的补给不能再领。");
    local data = this.RootStories[id].choices[choice];
    try { this.grantStoryReward(data.reward); }
    catch (error) { ::logError("[AfeixExpedition] Root reward failed: " + error); return this.result(false, "补给没能全部收下，可能是储备已满。这次还没领取，可以腾出空余后重试。"); }
    this.set("root_choice_" + id, choice);
    this.set("root_done_" + id, true);
    this.refreshAssets();
    return this.result(true, data.outcome + "\n获得 " + this.storyRewardText(data.reward) + "。");
};

A.bicycleStatus <- function() {
    if (!this.isOrigin()) return "locked";
    local state = this.get("bicycle_state");
    if (state == 1) return "kept";
    if (state == 2) return "memory";
    if (state == 3) return "choice";
    if (state == 4) return "done";
    local afei = this.findCharacter("afei"), bottle = this.findCharacter("bottle");
    if (!this.storyAlive(afei) || !this.storyAlive(bottle)) return "unavailable";
    return afei.getLevel() >= 7 && this.get("growth_done_bottle", false) ? "ready" : "locked";
};
A.bicycleInventoryInfo <- function() {
    local bro = this.findCharacter("bottle");
    local count = bro == null ? 0 : bro.getItems().getAllItems().len();
    return { count = count, empty = ::World.Assets.getStash().getNumberOfEmptySlots() };
};
A.bicycleInventorySnapshot <- function(bro) {
    local records = [], slots = bro.getItems().getData();
    foreach (slot, items in slots) foreach (index, item in items)
        if (item != null && item != -1) records.push({ item = item, slot = slot, index = index });
    return records;
};
A.restoreBicycleEquipment <- function(bro, records) {
    local container = bro.getItems(), stash = ::World.Assets.getStash(), ok = true;
    // Remove stash copies before re-equipping; slot 0 is valid and never treated as false.
    foreach (record in records) {
        if (stash.getItems().find(record.item) != null) {
            try { stash.remove(record.item); } catch (error) { ok = false; }
        }
        if (container.getAllItems().find(record.item) != null) continue;
        try {
            local restored = record.slot == ::Const.ItemSlot.Bag
                ? container.addToBag(record.item, record.index) : container.equip(record.item);
            if (!restored) {
                ok = false;
                if (stash.getItems().find(record.item) == null && stash.add(record.item) == null)
                    throw "No place to preserve returned equipment";
            }
        } catch (error) {
            ok = false;
            // Never discard an item even if a third-party equip callback fails.
            if (container.getAllItems().find(record.item) == null && stash.getItems().find(record.item) == null)
                stash.add(record.item);
            ::logError("[AfeixExpedition] Equipment rollback: " + error);
        }
    }
    return ok;
};
A.releaseBottleWithEquipment <- function() {
    local bro = this.findCharacter("bottle");
    if (!this.storyAlive(bro)) return this.result(false, "小酒瓶目前不在队中，不能办理这次告别。");
    local stash = ::World.Assets.getStash(), container = bro.getItems();
    local records = this.bicycleInventorySnapshot(bro);
    if (stash.getNumberOfEmptySlots() < records.len()) return this.result(false, "公共行囊至少需要 " + records.len() + " 个空位回收她的全部装备；当前不足，没有移动装备，也没有离队。");
    local actorId = bro.getID(), level = bro.getLevel(), battles = this.personalBattles(bro);
    local xp = "getXP" in bro ? bro.getXP() : 0;
    try {
        foreach (record in records) {
            local removed = record.slot == ::Const.ItemSlot.Bag ? container.removeFromBag(record.item) : container.unequip(record.item);
            if (!removed || container.getAllItems().find(record.item) != null) throw "Could not detach an item";
            if (stash.add(record.item) == null) throw "Stash unexpectedly full";
        }
    } catch (error) {
        local restored = this.restoreBicycleEquipment(bro, records);
        ::logError("[AfeixExpedition] Bottle transfer cancelled: " + error);
        return this.result(false, restored ? "装备转移未完成，已恢复原物品与位置；小酒瓶仍在队。" : "离队已取消，装备保留在人物或公共行囊，请检查原位置。");
    }
    try { ::World.getPlayerRoster().remove(bro); }
    catch (error) { ::logError("[AfeixExpedition] Bottle removal: " + error); }
    if (this.findCharacter("bottle") != null) {
        this.restoreBicycleEquipment(bro, records);
        return this.result(false, "告别未能完成，小酒瓶仍在队，装备已尝试恢复原位。");
    }
    this.set("ever_bottle", true);
    this.set("departed_bottle", true);
    this.set("bicycle_bottle_actor_id", actorId);
    this.set("bicycle_bottle_level", level);
    this.set("bicycle_bottle_battles", battles);
    this.set("bicycle_bottle_xp", xp);
    this.set("bicycle_returned_items", records.len());
    this.set("bicycle_state", 2);
    this.set("bicycle_departure_choice", 1);
    this.set("bicycle_owned", true);
    if ("enforceFormation" in this) this.enforceFormation();
    this.refreshAssets();
    return this.result(true, "小酒瓶收下告别，离开了远征团。她的经历留在名册里，身上 " + records.len() + " 件装备都放回了公共行囊。她不会再回来应募。旧自行车还在营边，那段回忆随时可以翻出来看。");
};
A.resolveBicycleDeparture <- function(choice, confirmed = false) {
    if (!this.isOrigin() || typeof choice != "integer" || choice < 0 || choice > 1) return this.result(false, "没有这项告别选择。");
    if (!this.canManage() || this.currentTown() == null) return this.result(false, "这次夜话请在友好城镇办理。");
    if (this.bicycleStatus() != "ready") return this.result(false, "需阿飞 7 级、小酒瓶完成个人成长且两人存活在队；已作出的告别选择不能重来。");
    if (choice == 1 && !confirmed) return this.result(false, "请先查看离队与装备回收说明，再确认放手。");
    if (choice == 1) return this.releaseBottleWithEquipment();
    this.set("bicycle_departure_choice", 0);
    this.set("bicycle_state", 1);
    this.set("bicycle_owned", true);
    return this.result(true, "阿飞把想留她的理由一条条说了，小酒瓶也把自己的条件讲完。她点点头，留了下来，旧车就靠在营边。谁也没说谁欠谁，瓶队照样踢她的球。\n\n小酒瓶继续留在队中，装备和经验都不变。");
};
A.readBicycleMemory <- function() {
    if (!this.isOrigin() || !this.canManage()) return this.result(false, "请在安全地点回看这段往事。");
    if (this.get("bicycle_state") != 2) return this.result(false, "这段回忆已读过，或尚未走到这里。");
    this.set("bicycle_state", 3);
    return this.result(true, "阿飞记得的不是哪几场漂亮仗，是头一回没接住的球，是蛤妈替他拨回去的车链子，还有那句“你也得学着自己走”。他把旧车扶正：可以把它留在营边，也可以松开手，让这一段就到这儿。");
};
A.resolveBicycleMemory <- function(choice) {
    if (!this.isOrigin() || typeof choice != "integer" || choice < 0 || choice > 1) return this.result(false, "没有这项自行车选择。");
    if (!this.canManage()) return this.result(false, "请在安全地点决定如何安放这段回忆。");
    local afei = this.findCharacter("afei");
    if (this.get("bicycle_state") != 3 || this.get("bicycle_reward_granted", false) || !this.storyAlive(afei))
        return this.result(false, "需先读过回忆，且阿飞存活在队；这份奖励只结算一次。");
    this.set("bicycle_choice", choice);
    this.set("bicycle_reward_granted", true);
    this.set("bicycle_owned", choice == 0);
    this.set("bicycle_state", 4);
    try {
        this.syncPersonalGrowth(afei);
        if (choice == 1 && "discardBicycleItem" in this) this.discardBicycleItem();
    }
    catch (error) {
        this.set("bicycle_choice", -1); this.set("bicycle_reward_granted", false);
        this.set("bicycle_owned", true); this.set("bicycle_state", 3);
        try { this.syncPersonalGrowth(afei); } catch (restoreError) {}
        ::logError("[AfeixExpedition] Bicycle trait refresh: " + error);
        return this.result(false, "纪念特性未能更新，选择尚未结算，旧车保留。");
    }
    local text = choice == 0
        ? "阿飞把旧车停在营边，链条擦干净，车铃也拨了两下。往后每次拔营，他都会回头看它一眼。纪念特长：决心 +4、生命 +2。"
        : "阿飞松开手，看着旧车顺着山坡一路滑远，车铃叮叮当当一直响到看不见。他拍掉手上的灰，转身去收拾明天的行囊。告别特长：耐力 +5、先攻 +3。";
    return this.result(true, text + "\n加成以个人特性的形式生效，不会叠加。");
};
