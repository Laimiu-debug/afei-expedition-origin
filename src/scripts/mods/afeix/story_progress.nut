// Personal stories and finite rewards. All numbers are prototype values.
local A = ::AfeixExpedition;
// BEGIN GENERATED MEMBER GROWTH
A.MemberGrowth <- {
    afei = {
        title = "把名字写到旗底下",
        scene = "阿飞提笔要把“嘉豪”描大，墨却落在旗底的名字旁。三场交锋打完，他认得这些名字各自在队伍里的位置，也记得自己哪一步又让大谋补了洞。\n\n他将笔放下，拿起盾，又看看围在营火边的伙伴。今晚先练哪一件，得自己定。",
        choices = [
            {
                label = "先把自己站稳，少让伙伴补洞",
                outcome = "盾带重新系过，阿飞把最难看的那一步又练了一遍。没人喝彩，他也没停；第二遍稳了些，第三遍才有空问一句帅不帅。",
                traitName = "站稳的团长",
                bonuses = {
                    MeleeSkill = 2,
                    Bravery = 2
                }
            },
            {
                label = "先问伙伴需要什么，再开口带人",
                outcome = "他把凳子往后挪，让伙伴先把话说完。几次想抢答，最后都咽回去了。轮到开口时，那声喊仍很响，安排却比从前清楚。",
                traitName = "听得见伙伴",
                bonuses = {
                    Bravery = 4
                }
            }
        ]
    },
    damou = {
        title = "大哥这次借我来教",
        scene = "营火旁，新人请大谋再讲一遍刚借来的握枪法。门边的高手又招手，邀他去试一场。大谋看看两边，想起阿飞初学举盾时，嘴说会了，手却还握反。\n\n木盾在膝边，长枪也在手边，今晚的本事先往哪边用？",
        choices = [
            {
                label = "留下拆开动作，让新人再试一次",
                outcome = "他拆开动作，教到新人能自己站稳。讲着讲着，连自己凭习惯带过的收盾也重试了两遍。借来的招，这回留给了两个人。",
                traitName = "借招会教",
                bonuses = {
                    MeleeDefense = 2,
                    Stamina = 3
                }
            },
            {
                label = "先去较量，再把吃亏的一招带回来",
                outcome = "大谋回来便找块空地，比划自己吃亏的那一下。问得最多的是为什么快，最后才补一句：“下次这位大哥，也得来咱们桌坐坐。”",
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
        scene = "抹茶将结清的旧账展开，收益不厚，伙食和修补倒一笔没少。他拨出下次要留的余量，笔又停在那项自己垫过的开支上。\n\n阿飞以为要挨骂，已经坐得很端正。算盘声忽然停下，抹茶将账转向火光。",
        choices = [
            {
                label = "留清余量，自己守住账末那一行",
                outcome = "余量算了两遍，最后一栏写上抹茶自己的名字。他合起账本，明天哪一段由自己守着，也一并说定了。",
                traitName = "算盘留底",
                bonuses = {
                    Stamina = 4,
                    Bravery = 2
                }
            },
            {
                label = "把自己那份担当也写进账里",
                outcome = "垫过的那笔写回正页，账本推到三位队长中间。阿飞这回没等珠声催，就把自己的名字也添了上去。",
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
        scene = "旧球靠在车轮边，小酒瓶用鞋尖轻轻一拨。阿飞记得自己第一次接漏的位置，新人却刚好从那边伸来手。\n\n她看见前面一个好空当，也看见那只愿意接球的手。瓶队这一回怎么打，她想自己选。",
        choices = [
            {
                label = "把球收回来，先争属于自己的突破",
                outcome = "她把球收回，干脆踏进空当。阿飞刚要喊蛤妈，先被她笑着打断：“这一球，记瓶队。”",
                traitName = "瓶队突破",
                bonuses = {
                    MeleeSkill = 3,
                    Initiative = 3
                }
            },
            {
                label = "看准伸来的手，再把球传出去",
                outcome = "球稳稳传到那只手里，她等对方自己迈出下一步，才跟上接应。车铃响了一声，阿飞总算没忙着抢球。",
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
        scene = "第三声鼓刚落，鼓槌从白小帅子手里滑了下去。营地没出事，她自己倒先吓得吸了口气。有人正要迈步，又回头等那声第四拍。\n\n她捡起鼓槌，摸了摸胸口，望向已经站到门边的人。",
        choices = [
            {
                label = "重新敲四下，把自己的节拍守完整",
                outcome = "“刚才不算，再来。”她自己先承认吓到了，重新敲足四下。门边的人等齐了才动，这次没人抢她的拍子。",
                traitName = "小心脏守拍",
                bonuses = {
                    MeleeDefense = 3,
                    Hitpoints = 3
                }
            },
            {
                label = "直接喊出第四拍，接住已经动的人",
                outcome = "“四！”她先喊出了那一声，把已经迈步的人叫回节奏。等队伍走稳，才回头抱怨：“笑也得等我喊完吧。”",
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
        scene = "练习场的灯熄了一半，李李还将高背椅搬到靶边，说超巨有最后一箭。阿飞想去喊观众，她却指住旧靶纸：同一个地方，偏了不止一回。\n\n弓弦已拉过许多次，出手后的脚步也留在地上。今晚她还想再试一种练法。",
        choices = [
            {
                label = "继续校准那一箭，不靠欧气找借口",
                outcome = "灯下没有喝彩，靶纸上的偏差却缩小了一点。李李收弓时仍要问这箭看着如何，随后把那张纸亲手卷好。",
                traitName = "超巨再一箭",
                bonuses = {
                    RangedSkill = 3,
                    Initiative = 3
                }
            },
            {
                label = "专练出手后的收势和退步",
                outcome = "椅子往旁边搬，射完再收一步，重心终于不拖在原处。她绕回灯外，朝阿飞挑眉：“这回，找到我没有？”",
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
        scene = "小月牙将三样没派上用场的零件排开，宣布超市上新。无人来问，她只好自己演示，旧绳换个扣法，松环也能改个握法。\n\n抹茶指着摊子问哪样今天能用。她看看三件货，总得先做成一件。",
        choices = [
            {
                label = "挑一个怪点子反复试，找准出手时机",
                outcome = "同一个扣法试了几遍，终于跟得上她喊出的怪名字。阿飞刚想鼓掌，她先请他再试一次，证明超市这回真有货。",
                traitName = "超市会变招",
                bonuses = {
                    RangedSkill = 2,
                    Initiative = 4
                }
            },
            {
                label = "先把现成办法练熟，留力气下次再想",
                outcome = "现成办法练熟，她在招牌背面添上“先用明白”。旧零件仍排得整齐，下一种点子等有余力时再开张。",
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
        scene = "初九喊了声停，记战报的人差点从凳子上站起。她指着的是昨日漏画的后撤，并非营外真有敌人。\n\n阿飞终于看懂那处空缺，问接下来怎么办。初九将战报压平，这声停之后，还得有人把后半段接上。",
        choices = [
            {
                label = "继续把危险说透，自己守住后手",
                outcome = "她在漏掉的位置写下自己的名字，连怎样接应也逐项讲明。阿飞想插话，先被她叫去把那段重新走一遍。",
                traitName = "叫停也负责",
                bonuses = {
                    Bravery = 4,
                    MeleeDefense = 2
                }
            },
            {
                label = "把观察缩成短句，让伙伴更快接上",
                outcome = "报告缩成了最要紧的几句，先喊位置，再说危险。嗓门一点没小，这回听见的人却都知道先往哪看。",
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
        scene = "小鱼举盾讲昨日那步顶得多稳，讲到一半，自己先喘了。有人又喊“唯一的男人”，她斜眼看过去：“来，给你当一会儿。”\n\n旁边真伸来一只手。她松了松盾带，先估了估自己还剩多少力气。",
        choices = [
            {
                label = "让同伴接盾，把这一口气缓完整",
                outcome = "盾递过去，她也把大哥的外号顺手递了。等呼吸缓匀，再接回来站好，嘴上还不忘问一句刚才那位大哥好不好当。",
                traitName = "换气再顶",
                bonuses = {
                    Stamina = 5,
                    Hitpoints = 3
                }
            },
            {
                label = "说清自己的余力，再练短促有力的出手",
                outcome = "还能撑多久先说清，她将出手缩成短短一步，练到收得住。盾再抬起来时，旁边的人也知道什么时候该接手。",
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
        scene = "令牌背面的三个问题都答完了，偏有人起哄：“这次太子自己定。”怼怼先呛了一下，低头看看牌子，没找到第四个问题。\n\n阿飞也没替她接话。人都在，安排也问清了，就等她拿定主意。",
        choices = [
            {
                label = "按讲好的底线先作决定",
                outcome = "令牌翻回正面，她将安排说了一遍。最后照样怼了起哄的人一句，却没把刚才自己定的事推回团长手里。",
                traitName = "太子敢作主",
                bonuses = {
                    Bravery = 5
                }
            },
            {
                label = "先给最容易漏掉的位置补一道防线",
                outcome = "最容易漏掉的位置先补上，谁来接、接哪里，全都说得明白。阿飞听完才笑，这回太子问的也都答上了。",
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
        scene = "老蔡将地图空角展开，请伙伴标出昨日走过的路。两笔新线落下，正穿过他原来没算到的位置。\n\n木旗还在桌上，他亲手擦去旧判断，留出了重新摆放的地方。",
        choices = [
            {
                label = "把漏掉的接应留给自己，练稳退步",
                outcome = "漏掉的接应被他写到自己名下，空地上也重新练过退步和收身。纸上的箭头改了，脚下那一步也跟着改了。",
                traitName = "木旗守尾",
                bonuses = {
                    Bravery = 3,
                    MeleeDefense = 2
                }
            },
            {
                label = "重排木旗，练习先看新出现的空位",
                outcome = "木旗重排，空角添了几位伙伴的名字。老蔡这次先问新消息，再画下一条线，图边还留着一块能改的地方。",
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
        scene = "明天谁守前排，又吵到了营火旁。眼子讲完笑话，两人笑过，却仍将那一班推来推去。\n\n他把盾放到中间，先说自己的安排。是持盾把立场站稳，还是看清两侧再帮人换位，今晚还能练上一轮。",
        choices = [
            {
                label = "把自己的立场说清，持盾站稳",
                outcome = "他将自己愿意负责的那一段说完，没替别人包下余下的班。第二天练盾，脚下也更肯守住那一步。",
                traitName = "说清立场",
                bonuses = {
                    Bravery = 2,
                    MeleeDefense = 2
                }
            },
            {
                label = "先辨两侧动静，再协调换位",
                outcome = "争论换成了几轮换位练习。他看清两侧谁需要空隙，再开口提醒，昨日没说通的话，终于能在脚下演示出来。",
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
        scene = "小虎倒出旧信袋，一张未用的回执落到桌角。今天还送不到，她便把空白留着，又拿起弓看向靶场。\n\n看准目标和回头确认队尾，都是她惯做的事。今晚有空，她想把其中一项再练熟些。",
        choices = [
            {
                label = "先确认看准的目标，再松开弦",
                outcome = "她等目光定住才松弦，一箭一箭校过。回执仍收在袋底，下一次说到“到了”，她会再确认一遍。",
                traitName = "小虎送得准",
                bonuses = {
                    RangedSkill = 3,
                    Bravery = 2
                }
            },
            {
                label = "把回头看队尾的动作练成习惯",
                outcome = "脚下先站稳，再回看伙伴的位置。动作练顺以后，她回头不再匆忙，留给队尾的那一步也更宽。",
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
        scene = "怪记号又画满一页，嘴角的口水险些洇掉圆点。看图的人说这不是给地上人看的，小宁立刻反问，他的捷径怎么少了两个岔口。\n\n两人都笑了。她擦擦嘴，将图转正，今晚先补哪一处，还得自己挑。",
        choices = [
            {
                label = "保留怪画法，但把射线标给别人看懂",
                outcome = "圆点和射线各添一句图例，别人终于能跟着指到同一个地方。小宁看完又加了个怪符号，说这回总该看得懂了吧。",
                traitName = "外星图也能读",
                bonuses = {
                    RangedSkill = 3,
                    Initiative = 3
                }
            },
            {
                label = "把退路画宽，让自己的动作留有余地",
                outcome = "退路画宽一格，她照着新位置重新试步。图还是怪，至少这一回，自己也没挤到纸外面去。",
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
        scene = "第四拍没落在粉线上，重甲将小胖的转身拖慢半步。阿飞拿嘉豪步伐打趣，她便把他拉进空地：“那你来。”\n\n团长也踩歪了。两人看着脚印，小胖先定了今晚要重练的那一步。",
        choices = [
            {
                label = "保留卡拍的锋利，重练第一步和收势",
                outcome = "第一步和收势拆开再练，新的重心终于踩进旧节拍。她跳完一轮，马上叫刚才打趣的人跟上，桶这次摆得很远。",
                traitName = "街舞卡拍",
                bonuses = {
                    Initiative = 5,
                    MeleeSkill = 2
                }
            },
            {
                label = "去掉一段转身，练稳负重后的站位",
                outcome = "少转一段，第四拍落得结实。她拍拍甲片，笑着说卸了这身重量，花样还得跳回来；眼下先把脚站稳。",
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
        scene = "公物单上少了一口旧锅，大鹅嗓门立刻高了半截。值守名单翻过来，该回的人倒是一个不少。\n\n她挨个听过应声，才将锅的事写到旁边。今夜还能练一轮，守住窝口，或把叫人回来的信号喊清。",
        choices = [
            {
                label = "把盾边练稳，守住大家能回来的位置",
                outcome = "盾边收得更稳，她让伙伴从身后轮流穿过。锅还要查，回来那条路却先给大家留好了。",
                traitName = "大鹅守窝",
                bonuses = {
                    MeleeDefense = 3,
                    Bravery = 2
                }
            },
            {
                label = "把叫人回来的口令喊清，自己站到边上",
                outcome = "口令短了些，回应更齐。她自己先站到接应处，嘎嘎冲仍喊得响，这回所有人也都知道什么时候该回来。",
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
        scene = "蔓越莓刚拉直红线，说别抢话，大谋就指住一枚漏摆的木片。她看过，先改，再让他把理由讲完。\n\n新位置让出一道窄缝，她拿起轻弩比了比。怎么把这一拍用好，今晚正可以试。",
        choices = [
            {
                label = "短句说到底，也给异议留位置",
                outcome = "每道安排都说得短而清楚，异议也留了说完的位置。红线仍由她来拉，这回站上去的人都知道缘由。",
                traitName = "红线定节奏",
                bonuses = {
                    Bravery = 4,
                    Initiative = 3
                }
            },
            {
                label = "收住抢拍，专练看清前排留下的缝",
                outcome = "她等前排站稳一瞬，才举弩看那道空隙。该等的半拍终于留住，出手反而不再那么急。",
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
        scene = "行囊一抖，干饼、栗子和备用布条铺了一小片。阿飞笑问仓鼠是不是把家背来了，罗一可刚要回嘴，肩带就勒得她停下。\n\n她重新分开两只粮袋，摸摸存路费的结绳。下一程要带多少，自己的那份放在哪，她想先理清。",
        choices = [
            {
                label = "按路程分装，留下够走下一段的体力",
                outcome = "重复的东西放回车上，肩头只留够用的一袋。再出发时栗子仍在，脚步却终于不用追着行囊的重量走。",
                traitName = "小袋长路",
                bonuses = {
                    Stamina = 5,
                    Initiative = 2
                }
            },
            {
                label = "先说清自己的份额，稳稳守住该站的位置",
                outcome = "两根绳系成不同的结，公用和私用各有一袋。她将愿意分的摆出来，余下的收回自己手边，阿飞这次没伸手抢。",
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
        scene = "可可将旧护带展平，记起自己替阿飞系带时，竟忘了问他想站哪边。保可梦的玩笑还缠在结上，团长倒已经搬来练习用的靶子。\n\n她摸摸弩，再看看自己的落脚。照应人的办法很多，今晚也该替自己挑一项练。",
        choices = [
            {
                label = "先听本人判断，练准后排的那一箭",
                outcome = "先问清伙伴的打算，她才给出简短提醒。随后举弩校准，箭落在哪，她亲眼确认，不再只顾替别人看位置。",
                traitName = "保可梦看准",
                bonuses = {
                    RangedSkill = 3,
                    Bravery = 2
                }
            },
            {
                label = "把自己的位置站稳，再接同伴的手",
                outcome = "自己的盾和脚步先摆稳，她再伸手接同伴。护带依旧系得妥帖，侧边那个空缺却不再被忘到最后。",
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
        scene = "余想将值守钥匙放到桌中央：“下一班谁？”有人拿五老压阵起哄，她只等一个名字。\n\n名字和时辰终于写下，她拎起长矛，还有空练一轮。站久的本事要磨，叫替班的人按时到场，也不能含糊。",
        choices = [
            {
                label = "继续练守位，但把换班时间说在前面",
                outcome = "她又站了一轮，时辰到了，接班的人真走到面前。长矛交过去，肩膀终于能松下，下一回守位也知道该留多少力气。",
                traitName = "五老守得稳",
                bonuses = {
                    Stamina = 5,
                    MeleeDefense = 2
                }
            },
            {
                label = "把要求讲明，接班的人到齐才点头",
                outcome = "她把要求逐项说清，接班的人到齐才点头。五老的名号仍响，这张轮值表上却总算不只有她一个名字。",
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
        scene = "木熊摆上桌，旧规则却让一位伤了手臂的伙伴没法开局。阿飞想偷偷放水，童猪先将熊收回：“改就当众改。”\n\n她看着桌上的旧局，已经准备好了再讲一遍。先从规则还是从漏洞查起，她想自己定。",
        choices = [
            {
                label = "公开讲清新规则，让愿意的人再来",
                outcome = "新规则念清，她第一个下场示范。有人又想抢答，杯子一敲，桌边便重新等齐了，笑声也在同一拍响起来。",
                traitName = "小熊讲规矩",
                bonuses = {
                    Bravery = 4,
                    Hitpoints = 3
                }
            },
            {
                label = "先把旧局重新摆一遍，找出真正的漏洞",
                outcome = "旧局重摆，那一步卡住人的地方终于找出。木熊照旧坐着，童猪却能把这条规则为何要改说得更明白。",
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
        scene = "大王舞的鼓点敲完，两位伙伴仍在同一拍撞肩。有人想把其中一个赶到后排，美伢先让他们各走一遍，自己蹲下看落脚。\n\n起拍能换，撑完整段的呼吸也得练。她直起身，准备亲自示范。",
        choices = [
            {
                label = "改起拍，让动作衔接更干脆",
                outcome = "起拍改过，两人终于接得上。她走完最后一步，才夸张地朝看热闹的人让位，逗得鼓手又差点敲乱拍。",
                traitName = "大王起拍",
                bonuses = {
                    Initiative = 4,
                    MeleeSkill = 2
                }
            },
            {
                label = "收紧花样，把呼吸和落脚连起来",
                outcome = "花样收紧，呼吸和落脚一段段接顺。鼓再响，她仍跳得大方，只是这一回，整段走完也留得住气。",
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
        scene = "有人在门边喊秦国的神，玩蛇还蹲着看昨日脚印。那次转身很好看，最后一脚却几乎踩出边缘。\n\n她划掉多余的弧线，重新提起木剑。出招和收招，今晚总得先磨好一头。",
        choices = [
            {
                label = "把最有效的一招练得干净",
                outcome = "少了两段转腕，木剑反而到得更干脆。她照样给这招起了个大名字，这回演示却短到看客来不及喊完。",
                traitName = "秦国一招",
                bonuses = {
                    MeleeSkill = 3,
                    Initiative = 2
                }
            },
            {
                label = "把退步练明白，再谈下一次胜负",
                outcome = "退步逐次练过，收剑后终于站稳。有人急着喝彩，她指指脚下，让对方先把最后那一步看全。",
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
        scene = "歌唱完，掌柜又说再留一晚。涂涂放下琴，问这一晚是想听下一首，还是还有话没谈完。\n\n茶重新倒上，路票也摊在桌边。留下多久、下一站去哪，她可以慢慢说，也想让自己走得更从容些。",
        choices = [
            {
                label = "答应这一晚，但由自己说清下一站",
                outcome = "她应下这一晚，将下一站的打算也说完。唱歌仍温和，告别的时辰却没有省掉，掌柜这次认真点了头。",
                traitName = "这一晚我决定",
                bonuses = {
                    Bravery = 5
                }
            },
            {
                label = "先练好呼吸，把同行的路分段走",
                outcome = "呼吸重新分段练过，她收琴时不再急着赶步。路票按站点折好，下一程还有能歇脚、再接上话的地方。",
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
        scene = "昨晚的战报念到“本王一人包围”，奶盖自己先笑了。阿飞想替她圆，她赶紧摆手：“这个可别真记。”\n\n盾就在凳边，带子已经修好。话还可以说，手上的本事也该练上一轮。",
        choices = [
            {
                label = "亲口说明夸张在哪，保留大家都懂的玩笑",
                outcome = "她亲口指出夸大的那句，营火边笑得更响。下一段仍讲得夸张，只是大家都知道本王今天究竟干了哪几件事。",
                traitName = "吹完也认账",
                bonuses = {
                    Bravery = 5
                }
            },
            {
                label = "收好战报，先把盾举完这一轮",
                outcome = "盾举完一轮，奶盖还往后缩过，手却没再松带。阿飞要叫好，她先喘匀了气，才补一句本王早有安排。",
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
        scene = "车边又有人等着借工具，小杰将备用钥匙放在掌心。锁车的规矩讲过多次，她若正好不在，总不能让所有人一直等。\n\n她看了看交接单，又将常用的工具摊开。今夜先把哪一件理顺，她已有两种打算。",
        choices = [
            {
                label = "选可信的人共管，把交接说清",
                outcome = "钥匙交给选定的人，交接单也当面写好。她出门走了一小圈，回来核对没漏，终于不必随时守在那把锁旁。",
                traitName = "钥匙有人接",
                bonuses = {
                    Bravery = 3,
                    Initiative = 3
                }
            },
            {
                label = "把工具与动作逐项练熟，先守住手上本事",
                outcome = "工具和动作逐项试熟，她将常用的摆到顺手处。有人再来借，除了听见锁响，也能看见她当场示范该怎样用。",
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
        scene = "店家把贵货排得很气派，bula却将采买单分到真正要用的人手里，请他们各试一件。有人嫌便宜的卡手，有人觉得贵的只是多了装饰。\n\n她听完，将钱袋放回桌面。这一笔花在哪，还得自己拿准。",
        choices = [
            {
                label = "听完各人的需要，再明确作选择",
                outcome = "需要问过，她将选定的货逐件说清。钱袋没变厚，买回去的东西却都有人接着试用，抹茶核账时也少问了几句。",
                traitName = "钱袋问对人",
                bonuses = {
                    Bravery = 4,
                    MeleeDefense = 2
                }
            },
            {
                label = "把合用与不合用的差别逐项看清",
                outcome = "握带、重量和收放逐项比过，她指出几处总价表里没有的差别。最后放回去的那件很漂亮，却确实不大合手。",
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
        scene = "最快的近路刚画好，镇上向导就指住没标出的岔口。苏袜伸脚比划两次，才发现腿记得转，纸上却没写。\n\n她重新拿起炭笔，又往岔口跑了半段。急刹和等人跟上的空当，今晚都值得再试。",
        choices = [
            {
                label = "把急刹和再起步练清，快也有停点",
                outcome = "停点和再起步一并练过，图上也添了醒目的记号。她还是爱抢半步，这回在路口停下，后面的人总算看得明白。",
                traitName = "快半步会急刹",
                bonuses = {
                    Initiative = 6
                }
            },
            {
                label = "把路分成别人能跟上的几段",
                outcome = "路线拆成几段，每段留个能集合的位置。她回头看见伙伴跟上，才继续走，自己也多留住了一口往前的气。",
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
        scene = "有人把003介绍成第三位传奇，千涵立即递上练习簿，指住几格空白。机会她想争，成绩却还不能提前填。\n\n她重新量过起跑线，站到短坡前。第一步和后半程，今晚还够练其中一项。",
        choices = [
            {
                label = "把第一步反复练稳，别替自己吹满",
                outcome = "起步反复试稳，她在003旁记下一次新的成绩。空格没有全填满，这个新起点却已能拿给别人看。",
                traitName = "003起跑",
                bonuses = {
                    MeleeSkill = 3,
                    Initiative = 3
                }
            },
            {
                label = "按段调整呼吸，认真把后半程走完",
                outcome = "呼吸按坡段调整，最后一格终于填上。千涵来回看了两遍，比听到那声传奇还高兴，又将木牌认真擦好。",
                traitName = "003分段呼吸",
                bonuses = {
                    Stamina = 6
                }
            }
        ]
    },
    wangdazhi = {
        title = "幕布前这回也有她",
        scene = "位置排好，王大芷自己的名字又挤到页边。笔递出去一半，她忽然收回，将那张纸转向自己。\n\n芷芷想上前，也知道场子还需要有人守。今天站哪边，最好先由她开口，再把配合一起写进去。",
        choices = [
            {
                label = "把自己的登场写进安排，站出来说清",
                outcome = "她先念自己的名字，将登场时辰写进正栏。其他位置照样排好，这一次，幕布前也确实留出了她的地方。",
                traitName = "芷芷也登场",
                bonuses = {
                    Bravery = 4,
                    Initiative = 3
                }
            },
            {
                label = "明确选择守场，把需要的配合讲出来",
                outcome = "她选定守场，将要谁配合、何时换手说清。名字仍在后排，旁边却有了她自己定下的安排和来接班的人。",
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
        scene = "挑战纸上“奶团吕布”写得醒目，瑶瑶牙没有马上拍桌，先回看黑旗旁的护送安排。已应下的那趟路，时辰还在前面。\n\n较量可以再约，今晚先磨一轮出手，或把收招后的气留足。她将长柄兵器扶到身侧。",
        choices = [
            {
                label = "挑出最有用的一击，练到收得住",
                outcome = "最有用的一击反复练过，收招时少露了一处空当。名号照样喊，她倒先问旁边的人这一下能不能接着跟上。",
                traitName = "奶团吕布一击",
                bonuses = {
                    MeleeSkill = 4
                }
            },
            {
                label = "练好回看旗子之后的收步和呼吸",
                outcome = "回看旗子，再收步换气，几次练完还能留住余力。下一趟护送的安排收好，她才回头去写那张挑战的答复。",
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
        scene = "羊咩咩用小铃比划转弯，驿差却坚持另一条线更快。两人争完才看清，车里装的重量根本不同。\n\n她将负重分别记下，又在地上画了弯前和弯后的位置。今晚可以磨准反应，也可以试着把力留到后半段。",
        choices = [
            {
                label = "先看准那条线，再决定什么时候抢",
                outcome = "线路看准，她才决定从哪一刻追上去。铃声再响，急着迈出的脚也能等她先确认弯后的空位。",
                traitName = "弯前听铃",
                bonuses = {
                    Initiative = 4,
                    RangedDefense = 2
                }
            },
            {
                label = "把弯前留下的力气用到下一段",
                outcome = "弯前松一点，弯后再接力，她将这段来回练了几遍。车出了弯仍推得动，下一段也终于不用靠咬牙硬撑。",
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
        scene = "战报结尾空着，有人催宋暖阳补两句凯歌。她先缩下兜帽，又探头问：“那段撤得乱七八糟的，也这么写？”\n\n桌边安静了一会儿，她将笔放到旁边。还没问清的事、刚才看见的细节，都值得留点位置。",
        choices = [
            {
                label = "把那句问题问完整，再决定落笔",
                outcome = "问题问完，她等到答复才落笔。兜帽仍会随响声缩一下，那句真正想问的话，这回没跟着缩回去。",
                traitName = "鹌鹑敢开口",
                bonuses = {
                    Bravery = 4,
                    Hitpoints = 3
                }
            },
            {
                label = "先观察再记，把空白留给还不知道的事",
                outcome = "她重新查过细处，将没看清的留白。战报短了几行，读的人却能认出自己究竟在那天做过什么。",
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
        scene = "小龟将三次交锋的记录叠好，准备拿给飞爹看，最上面却先放了自己失手的那一下。她指着进退的空当，小声说这里判断慢了。\n\n阿飞这回没有抢着替她解释。小龟摊平战报，自己选好下一步要怎么练。",
        choices = [
            {
                label = "把看见空位后的那一步练快",
                outcome = "空位出现后的那一步练快，她将思路从头讲完。战报末尾亲手添上下一次的打算，飞爹坐在旁边认真听着。",
                traitName = "给飞爹看自己的路",
                bonuses = {
                    Initiative = 5,
                    RangedSkill = 2
                }
            },
            {
                label = "把失手后的站位守住，再找下一次机会",
                outcome = "失手后先守住落脚，再找下一次机会。她在纸上画出后路，将自己的名字写到末尾，终于肯把这份战报交给阿飞看。",
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
    if (!this.canManage()) return this.result(false, "请到友好城镇或安全扎营处再作个人成长选择。");
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
        opening = "酒馆里，小原大人朝阿飞招手：‘飞爹，坐这儿。问你个事，队员说前面可能有埋伏，你怎么办？’\n\n‘那当然是我带头——’\n\n‘你看，我话还没说完。’\n\n阿飞端起酒杯，假装刚才只是口渴。小原把一张纸推过来：‘带队也得听劝。拿不准就说拿不准，别人有办法，也让人讲完。’\n\n阿飞把纸折好：‘行，这次你先说。’",
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
    if (!this.canManage()) return this.result(false, "请到友好城镇或安全扎营后再看。");
    local data = this.RootStories[id];
    if (data.member == "" && this.currentTown() == null) return this.result(false, "对方在城镇里，请到友好城镇见面。");
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
    if (!this.canManage()) return this.result(false, "请到安全地点再回应。");
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
    return this.result(true, "小酒瓶收下告别，离开了远征团。原人物的经历已记入名册，全部 " + records.len() + " 件装备原物归入公共行囊；不会再招募一个替身。旧自行车还在，回忆可以慢慢读。");
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
    return this.result(true, "阿飞把想留她的理由说清，小酒瓶也把自己的条件讲完。她愿意继续同行，旧车靠在营边；没有离队、转移装备或改变经验。两人把这段约定记下，不把留下说成亏欠。");
};
A.readBicycleMemory <- function() {
    if (!this.isOrigin() || !this.canManage()) return this.result(false, "请在安全地点回看这段往事。");
    if (this.get("bicycle_state") != 2) return this.result(false, "这段回忆已读过，或尚未走到这里。");
    this.set("bicycle_state", 3);
    return this.result(true, "记得的不是一串漂亮胜场：是第一次没接住的球，是蛤妈替他拨回的链条，是那一句你也得学着自己走。阿飞把旧车扶正，既可以留它记住这一程，也可以放开手结束这一段；哪条路都不抹掉同行过的日子。");
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
        ? "阿飞把旧车留在营边。记住帮助过自己的人，不妨碍继续往前走。纪念特长：决心 +4、生命 +2。"
        : "阿飞松开手，看旧车沿山坡滑远。他没有说忘了谁，只决定以后亲自把下一段路走稳。告别特长：耐力 +5、先攻 +3。";
    return this.result(true, text + "\n奖励只通过个人特性生效，不叠加、不改基础属性，也不启用旧版经验倍率。");
};
