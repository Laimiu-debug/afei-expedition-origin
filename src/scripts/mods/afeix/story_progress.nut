// Personal stories and finite rewards. All numbers are prototype values.
local A = ::AfeixExpedition;
// BEGIN GENERATED MEMBER GROWTH
A.MemberGrowth <- {
    afei = {
        title = "把名字写到旗底下",
        scene = "阿飞又想把嘉豪二字描大，笔尖却停在伙伴们的名字上。三场交锋之后，他已知道有人会听着自己的话往前走。他反复问自己，想先把自己站稳，还是先学会把别人叫稳？这回没人替他回答。",
        choices = [
            {
                label = "先把自己站稳，少让伙伴补洞",
                outcome = "旗面没再加宽。他把口头的威风缩成眼前肯多练的一步。",
                traitName = "站稳的团长",
                bonuses = {
                    MeleeSkill = 2,
                    Bravery = 2
                }
            },
            {
                label = "先问伙伴需要什么，再开口带人",
                outcome = "阿飞仍然爱叫，但开始等伙伴把话说完。这不是一次转职，而是第一次认真选自己的起点。",
                traitName = "听得见伙伴",
                bonuses = {
                    Bravery = 4
                }
            }
        ]
    },
    damou = {
        title = "大哥这次借我来教",
        scene = "营火旁有人请大谋再讲一遍刚学来的握枪法。另一个高手正招呼他去较量，学招与教人恰好撞在一起。他想起阿飞初学时抱着盾，嘴上说会了，手却握反的样子。大哥的本事，今晚该先往哪边用？",
        choices = [
            {
                label = "留下拆开动作，让新人再试一次",
                outcome = "他把招式拆成能学会的几步，自己也看清了哪些防守曾只靠熟练硬撑。",
                traitName = "借招会教",
                bonuses = {
                    MeleeDefense = 2,
                    Stamina = 3
                }
            },
            {
                label = "先去较量，再把吃亏的一招带回来",
                outcome = "大谋回来时没说自己无敌，只认真比划了那一下为什么快。大哥的凳子又往桌里挪了些。",
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
        scene = "抹茶摊开一份已结清的旧账：纸上收益不多，欠的承诺却一项没少。他能继续把余量都算成下一次的保险，也能把自己承担过的那一笔明明白白写出来。他想起开局时阿飞等着挨骂的样子，算盘却先停了。",
        choices = [
            {
                label = "留清余量，自己守住账末那一行",
                outcome = "抹茶没有变得阔绰。他只是把能承担的底线算得更稳，也准备亲自站在后面。",
                traitName = "算盘留底",
                bonuses = {
                    Stamina = 4,
                    Bravery = 2
                }
            },
            {
                label = "把自己那份担当也写进账里",
                outcome = "他写下自己的名字，再把账推到伙伴面前。那些冷话开始有了更直截了当的分量。",
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
        scene = "瓶队把一只旧球放在车轮边，想起阿飞第一次接漏时的样子。如今她能自己冲开一条路，也能把球递到刚刚敢伸手的人面前。蛤妈不是永远替人接住；想明白这一点以后，她也想按自己的心气再选一回。",
        choices = [
            {
                label = "把球收回来，先争属于自己的突破",
                outcome = "小酒瓶把那一步踏得干脆。她记得怎样照应别人，也愿意认真争一场属于自己的表现。",
                traitName = "瓶队突破",
                bonuses = {
                    MeleeSkill = 3,
                    Initiative = 3
                }
            },
            {
                label = "看准伸来的手，再把球传出去",
                outcome = "她不再替别人保证结果，而是把球递到愿意伸出的手里。蛤妈这回也给自己留了一次选择。",
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
        scene = "白小帅子的四下鼓点刚敲到第三下，鼓槌突然从手里滑落。营地没有危险，她却先吓得吸了一口气。所有人都在等第四声，小心脏还跳得厉害的她得决定，是重新打完整，还是自己把人叫回拍子里。",
        choices = [
            {
                label = "重新敲四下，把自己的节拍守完整",
                outcome = "她承认刚才吓到了，手里的节奏却没有再让给别人。",
                traitName = "小心脏守拍",
                bonuses = {
                    MeleeDefense = 3,
                    Hitpoints = 3
                }
            },
            {
                label = "直接喊出第四拍，接住已经动的人",
                outcome = "鼓可以停一下，开口的人不能一直等。她叫出了那一拍，随后才抱怨旁边的笑声来得太早。",
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
        scene = "练习场的灯已熄了一半，李李把高背椅搬到靶边，说超巨还有最后一箭。有人想替她再喊些观众，她却看见自己的旧靶纸上，有一处偏差总在重复。今晚可以把它练准，也可以专门练失手之后怎么收住。",
        choices = [
            {
                label = "继续校准那一箭，不靠欧气找借口",
                outcome = "这回没有喝彩，靶纸却替她记下了变化。超巨仍爱露脸，只是多了一件能自己拿稳的本事。",
                traitName = "超巨再一箭",
                bonuses = {
                    RangedSkill = 3,
                    Initiative = 3
                }
            },
            {
                label = "专练出手后的收势和退步",
                outcome = "李李把椅子往旁边让开，给自己留出收回重心的位置。所谓无法选中，先从别把破绽留在那里练起。",
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
        scene = "小月牙把三样没派上用场的小物件摆开，硬说这是超市新货。招牌立了许久也没人问，她只好先说明到底怎么用：旧绳能改用法，松脱的扣环能练手。怪点子不能同时试完，今晚总得先做成一样。",
        choices = [
            {
                label = "挑一个怪点子反复试，找准出手时机",
                outcome = "她给试成的办法起了一个特别夸张的名字，这回演示总算跟得上招牌。",
                traitName = "超市会变招",
                bonuses = {
                    RangedSkill = 2,
                    Initiative = 4
                }
            },
            {
                label = "先把现成办法练熟，留力气下次再想",
                outcome = "小月牙没有收走招牌，只在背面多写一句先用明白。旧东西仍有下一种可能。",
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
        scene = "初九又喊了一声停，声音响得让记战报的人差点从凳子上站起来。她指出的是昨日漏记的一段后撤，并非眼前真有敌人。想起自己总愿意先替阿飞喊那一句，她也问自己：等情况讲清，下一步由谁承担？",
        choices = [
            {
                label = "继续把危险说透，自己守住后手",
                outcome = "忠诚不只是跟着喊。她把该守的那一段明明白白接到自己手里。",
                traitName = "叫停也负责",
                bonuses = {
                    Bravery = 4,
                    MeleeDefense = 2
                }
            },
            {
                label = "把观察缩成短句，让伙伴更快接上",
                outcome = "她没把嗓门变小，只学会了先喊最关键的那几个字。",
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
        scene = "小鱼举着盾讲昨日那一步顶得有多稳，说到一半自己先喘了。唯一的男人这个玩笑又被提起，她没有顺势把每一段都揽下来。旁边伸来一只手，她可以让别人接一下，也可以先说明自己还能撑多少。",
        choices = [
            {
                label = "让同伴接盾，把这一口气缓完整",
                outcome = "她笑着把大哥的外号也递过去，缓匀以后再站回来。敢交出去，并没有少掉她的干脆。",
                traitName = "换气再顶",
                bonuses = {
                    Stamina = 5,
                    Hitpoints = 3
                }
            },
            {
                label = "说清自己的余力，再练短促有力的出手",
                outcome = "她不再把一直顶着当成唯一答案，短短一步也能做得结实。",
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
        scene = "怼怼把令牌翻来覆去，背面的三个问题都问完了，偏有人起哄说这次让太子自己定。她先被这个称呼呛了一下，随后发现真正难的是没有第四个问题可拿来拖延。营里的人正等她选出一个可执行的安排。",
        choices = [
            {
                label = "按讲好的底线先作决定",
                outcome = "令牌交回时她照样怼了一句，却没有把自己作过的决定再推给别人。",
                traitName = "太子敢作主",
                bonuses = {
                    Bravery = 5
                }
            },
            {
                label = "先给最容易漏掉的位置补一道防线",
                outcome = "她把安排说得很具体，谁来接、接哪里，第一次不只是追问别人。",
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
        scene = "老蔡摊开那张留着空角的地图，请各人把昨日真正走过的位置标上。两笔新线划掉了他原来的判断。木旗仍在桌上，这回他可以亲自练被漏掉的接应，也可以让自己的推演先容下新的消息。",
        choices = [
            {
                label = "把漏掉的接应留给自己，练稳退步",
                outcome = "他没有只在图上认错，连退一步时盾边怎样收都重新比划了一遍。",
                traitName = "木旗守尾",
                bonuses = {
                    Bravery = 3,
                    MeleeDefense = 2
                }
            },
            {
                label = "重排木旗，练习先看新出现的空位",
                outcome = "空角上多了几个伙伴的名字。老蔡的计划少了一点死板，却没少掉认真。",
                traitName = "地图留白",
                bonuses = {
                    Initiative = 5,
                    RangedDefense = 2
                }
            }
        ]
    },
    tiantong = {
        title = "最后一张回执",
        scene = "小虎把旧信袋倒过来，一张没用上的回执落在桌边。它提醒她，承诺也会遇到今天确实送不到的时候。她可以把核对目标练得更仔细，也能把回头确认队尾的那一步练得更稳，信袋不必替她决定。",
        choices = [
            {
                label = "先确认看准的目标，再松开弦",
                outcome = "她把回执收起，每次说到字时，目光比过去更笃定。",
                traitName = "小虎送得准",
                bonuses = {
                    RangedSkill = 3,
                    Bravery = 2
                }
            },
            {
                label = "把回头看队尾的动作练成习惯",
                outcome = "她先让自己站稳，再回头确认伙伴的位置。停一下，也可以是可靠的一部分。",
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
        scene = "小宁的新图上又画满了怪记号，嘴角一点口水险些把其中一颗圆点晕掉。看图的人说这根本不是给地上人看的，她反问对方的捷径为何少画了两个岔口。两人都笑了，小宁得先选自己最想改好的那一处。",
        choices = [
            {
                label = "保留怪画法，但把射线标给别人看懂",
                outcome = "她没有变成一本正经的军师，只肯多解释那颗别人看不懂的圆点。",
                traitName = "外星图也能读",
                bonuses = {
                    RangedSkill = 3,
                    Initiative = 3
                }
            },
            {
                label = "把退路画宽，让自己的动作留有余地",
                outcome = "她擦好嘴，给地图多留了一个空格。奇怪依旧，拥挤却少了。",
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
        scene = "小胖徐按四拍转身，重一点的甲让最后一步没落在粉线上。旁边有人拿嘉豪步伐打趣，她把笑得最响的那个也拉进空地：那就别只会说。她能重新找更快的落脚点，也能收掉花样，把第四拍站稳。",
        choices = [
            {
                label = "保留卡拍的锋利，重练第一步和收势",
                outcome = "她终于把新的重心踩进原来的节拍里，跳完仍然要刚才打趣的人再跟一遍。",
                traitName = "街舞卡拍",
                bonuses = {
                    Initiative = 5,
                    MeleeSkill = 2
                }
            },
            {
                label = "去掉一段转身，练稳负重后的站位",
                outcome = "第四拍不再最漂亮，却更结实。她说等卸下这身甲，花样还会跳回来。",
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
        scene = "大鹅列公物时发现少了一口旧锅，嗓门立刻高了半截。她翻到值守名单，才发现该回来的人倒是一个不少。锅可以再查，她也可以把这回守窝的底气练成更稳的盾边，或练成叫得清楚、自己先接住的那一步。",
        choices = [
            {
                label = "把盾边练稳，守住大家能回来的位置",
                outcome = "她依然会追问锅在哪，但守窝不再只剩追出去那一下。",
                traitName = "大鹅守窝",
                bonuses = {
                    MeleeDefense = 3,
                    Bravery = 2
                }
            },
            {
                label = "把叫人回来的口令喊清，自己站到边上",
                outcome = "嘎嘎冲的劲头没有消失，只是多了一个朝自己人回来的方向。",
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
        scene = "蔓越莓拉直红线，刚说别抢话，就有人指着她漏掉的一枚木片。她看了一眼，先改，再让对方把理由说完整。谁掌节奏并不等于谁永远正确；她要继续练短促明确的判断，还是把观察缝隙练得更细？",
        choices = [
            {
                label = "短句说到底，也给异议留位置",
                outcome = "她没有把气场让掉，只把每一道决定说得更能让人听明白。",
                traitName = "红线定节奏",
                bonuses = {
                    Bravery = 4,
                    Initiative = 3
                }
            },
            {
                label = "收住抢拍，专练看清前排留下的缝",
                outcome = "这回她等了一瞬才动。等待也成了她掌握节奏的方式。",
                traitName = "红线看得清",
                bonuses = {
                    RangedSkill = 3,
                    RangedDefense = 2
                }
            }
        ]
    },
    xiaohani = {
        title = "地图上的自己的路",
        scene = "【原创看海支线】小哈尼把旧海图摊在营火旁，第一次给自己写下一段具体的路程。她不想再把目标留在别人的以后，也知道眼前本事还得练。今晚可以练赶路仍保留的余力，也可以练遇到岔口时敢于说清自己的选择。",
        choices = [
            {
                label = "把想走的路分成几段，先练持久的脚力",
                outcome = "她把图折回去，愿望还在，但不再需要一口气走完才能算开始。",
                traitName = "向海的余力",
                bonuses = {
                    Stamina = 5,
                    Initiative = 2
                }
            },
            {
                label = "把自己的条件说完整，不拿含糊换位置",
                outcome = "这份原创旅途约定里，她终于给自己的目的地留了名字。",
                traitName = "下一站我来说",
                bonuses = {
                    Bravery = 4,
                    MeleeDefense = 2
                }
            }
        ]
    },
    keke = {
        title = "自己人也要先问",
        scene = "可可把一条旧护带展平，想起自己曾怎样直接替阿飞系好，又怎样忘了问他想站在哪里。保可梦这个玩笑还留在护带的结上。照看自己人有不止一种办法，轮到自己练本事，她也该挑一种更合心意的做法。",
        choices = [
            {
                label = "先听本人判断，练准后排的那一箭",
                outcome = "她把提醒缩成伙伴愿意回应的短句，随后才认真看向箭的去处。",
                traitName = "保可梦看准",
                bonuses = {
                    RangedSkill = 3,
                    Bravery = 2
                }
            },
            {
                label = "把自己的位置站稳，再接同伴的手",
                outcome = "可可没有放弃照应别人，只是不再把自己的破绽忘在最后。",
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
        scene = "余想把值守用的钥匙放在桌中央，问下一班谁来。听见有人拿五老压阵打趣，她只等一个明确的名字。交接说清以后，她还能选择把站得久的本事再磨稳，或把叫人来替班的底气练足。",
        choices = [
            {
                label = "继续练守位，但把换班时间说在前面",
                outcome = "她冷着脸又站了一轮，这次有人按约来接，肩膀也不必一直绷着。",
                traitName = "五老守得稳",
                bonuses = {
                    Stamina = 5,
                    MeleeDefense = 2
                }
            },
            {
                label = "把要求讲明，接班的人到齐才点头",
                outcome = "五老的称呼还在，承诺却终于不再只压在她一个人的身上。",
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
        scene = "童猪把木熊摆上桌，旧规则却让一位手臂受伤的伙伴连试一回都做不到。有人想悄悄放水，她立刻把熊收回：改就当众改。是先守住公平说话的底气，还是练自己观察规则缝隙的敏锐？",
        choices = [
            {
                label = "公开讲清新规则，让愿意的人再来",
                outcome = "她一本正经地宣布第一位示范者就是自己，营火边的笑声又有了共同的起点。",
                traitName = "小熊讲规矩",
                bonuses = {
                    Bravery = 4,
                    Hitpoints = 3
                }
            },
            {
                label = "先把旧局重新摆一遍，找出真正的漏洞",
                outcome = "木熊没长出新本领，是拿着它的人多看清了一步。",
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
        scene = "美伢照着大王舞的节拍排位置，两个伙伴却始终在同一拍撞肩。有人建议让其中一个退到后面，她先问两人各自哪一步做不到。她可以改成更利落的起拍，也可以把支撑整段动作的呼吸练好。",
        choices = [
            {
                label = "改起拍，让动作衔接更干脆",
                outcome = "美伢自己先示范那一步，谢幕时才夸张地请看热闹的人让出位置。",
                traitName = "大王起拍",
                bonuses = {
                    Initiative = 4,
                    MeleeSkill = 2
                }
            },
            {
                label = "收紧花样，把呼吸和落脚连起来",
                outcome = "她没有把舞跳小，只把要支撑它的那口气找准了。",
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
        scene = "玩蛇被叫作秦国的神时，还在检查昨日试招留下的脚印。一个转身看着漂亮，落脚却太近边缘。她愿意保留争胜的锋芒，也愿意自己挑出那一处没站稳：继续磨出手，还是先磨收回来的位置？",
        choices = [
            {
                label = "把最有效的一招练得干净",
                outcome = "名号照样响，演示却比过去少了两段多余的转腕。",
                traitName = "秦国一招",
                bonuses = {
                    MeleeSkill = 3,
                    Initiative = 2
                }
            },
            {
                label = "把退步练明白，再谈下一次胜负",
                outcome = "她收剑后站得更稳，也终于愿意让看热闹的人先把脚下看完再喝彩。",
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
        scene = "涂涂唱完最后一段，酒馆掌柜又说再留一晚。她把琴放下，反问这一晚是想听歌，还是有件事真想一起说完。双方把约定讲清，她也能选择把自己的声音说得更坚定，或把长路走得更从容。",
        choices = [
            {
                label = "答应这一晚，但由自己说清下一站",
                outcome = "她仍能唱得温和，说起自己的去处时却不再把尾音收掉。",
                traitName = "这一晚我决定",
                bonuses = {
                    Bravery = 5
                }
            },
            {
                label = "先练好呼吸，把同行的路分段走",
                outcome = "弦声停了，步子没有仓促起来。她给自己和同伴都留了换气的空当。",
                traitName = "回头路有余力",
                bonuses = {
                    Stamina = 5,
                    Initiative = 2
                }
            }
        ]
    },
    songnuanyang = {
        title = "鹌鹑探头那一句",
        scene = "宋暖阳把战报结尾留空，有人说这里总得来两句凯歌。她先缩了一下脖子，又探头问对方是否真想替所有人写答案。这个小动作让营地笑起来，也让她得决定，是把问题问到底，还是先把自己看见的细处记准。",
        choices = [
            {
                label = "把那句问题问完整，再决定落笔",
                outcome = "鹌鹑还是会缩一下，却没再把真正想说的话一起缩回去。",
                traitName = "鹌鹑敢开口",
                bonuses = {
                    Bravery = 4,
                    Hitpoints = 3
                }
            },
            {
                label = "先观察再记，把空白留给还不知道的事",
                outcome = "纸上的字少了些，细节反而更清楚。她不必替别人补一个漂亮结尾。",
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
        scene = "小龟把记下的三次交锋叠成一份想给飞爹看的战报，先挑出的竟是没打好的那一下。他从皮套化身后面小声念出自己判断慢了，没有等别人替他找借口。如今他可以练快一步看见空位，也可以练出错之后不急着乱动。",
        choices = [
            {
                label = "把看见空位后的那一步练快",
                outcome = "小龟终于把自己的思路讲完，战报末尾写上了由他自己决定的下一步。",
                traitName = "给飞爹看自己的路",
                bonuses = {
                    Initiative = 5,
                    RangedSkill = 2
                }
            },
            {
                label = "把失手后的站位守住，再找下一次机会",
                outcome = "他没有把一场失误说成全完了，复盘纸上也多了一条由自己画出的后路。",
                traitName = "壳后也能站稳",
                bonuses = {
                    MeleeDefense = 2,
                    RangedDefense = 3
                }
            }
        ]
    },
    naigai = {
        title = "嘴强王者拆自己的台",
        scene = "奶盖把昨晚吹过的战报又念了一遍，念到最夸张的那句，自己先笑出声。听众想替她圆，她摆手说这个可不能让别人真信。大话仍能逗人，往后可以练敢认账的底气，也可以把那面实际举着的盾练得更牢。",
        choices = [
            {
                label = "亲口说明夸张在哪，保留大家都懂的玩笑",
                outcome = "嘴强王者照样整活，这次听众也知道哪句只是营火边的热闹。",
                traitName = "吹完也认账",
                bonuses = {
                    Bravery = 5
                }
            },
            {
                label = "收好战报，先把盾举完这一轮",
                outcome = "她还是会往奶盖里缩一下，手却没有再偷偷松开盾带。",
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
        scene = "小杰把备用钥匙放在掌心，车边正有人等着借一件工具。锁车的规矩已经说过很多遍，真正难的是本人不在时谁能开箱。她可以练清楚交接与判断，也可以先把自己负责的那部分做得更稳。",
        choices = [
            {
                label = "选可信的人共管，把交接说清",
                outcome = "钥匙多了一位保管者，谨慎却没少，只是终于能被别人接手。",
                traitName = "钥匙有人接",
                bonuses = {
                    Bravery = 3,
                    Initiative = 3
                }
            },
            {
                label = "把工具与动作逐项练熟，先守住手上本事",
                outcome = "她不再靠一句都锁好了结束话题，真需要时能拿出一项扎实的办法。",
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
        scene = "bula把一次采购分成两堆：一堆好看，一堆用得上。店家把贵的摆得很有排场，她却请真正要用的人各拿一件试试。答案不一定只有便宜，她想练的是听完需要后敢作决定，还是把细处逐项看明白。",
        choices = [
            {
                label = "听完各人的需要，再明确作选择",
                outcome = "钱袋没有凭空变厚，bula的判断却不再只靠总价撑着。",
                traitName = "钱袋问对人",
                bonuses = {
                    Bravery = 4,
                    MeleeDefense = 2
                }
            },
            {
                label = "把合用与不合用的差别逐项看清",
                outcome = "漂亮与实用可以商量，细处看过一遍，她更知道该在哪一步停手。",
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
        scene = "苏袜把最快的那条路画完，拿给镇上的向导看，对方却指着一个没标出的岔口。她才发现自己腿上记得的转向，纸上一个也没写。她可以继续把急起急停练得更利落，也能留一口气，让后来的人有机会跟上。",
        choices = [
            {
                label = "把急刹和再起步练清，快也有停点",
                outcome = "她照样爱抢半步，只是停在哪里也终于说得明白。",
                traitName = "快半步会急刹",
                bonuses = {
                    Initiative = 6
                }
            },
            {
                label = "把路分成别人能跟上的几段",
                outcome = "她回头时没有嫌后面的人慢，自己也多留了一段能继续走的余力。",
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
        scene = "听见有人把003介绍得像第三位传奇，千涵直接把练习簿递过去，空着的格子还有不少。她并不想放弃那次机会，只希望先讲清自己能做到哪一步。是把起步练得更快，还是把后半程的呼吸练完整？",
        choices = [
            {
                label = "把第一步反复练稳，别替自己吹满",
                outcome = "她没有划掉003，只在旁边记下一个自己愿意拿来比较的新起点。",
                traitName = "003起跑",
                bonuses = {
                    MeleeSkill = 3,
                    Initiative = 3
                }
            },
            {
                label = "按段调整呼吸，认真把后半程走完",
                outcome = "最后一格填上时，她比听见传奇两个字更高兴。",
                traitName = "003分段呼吸",
                bonuses = {
                    Stamina = 6
                }
            }
        ]
    },
    wangdazhi = {
        title = "幕布前这回也有她",
        scene = "王大芷把场地位置都排好，自己的名字却又挤到了页边。笔都递出去了，她忽然伸手拿回来，问自己今天到底想站在哪里。芷芷不必靠放弃护场来证明有主意，也不能永远让别人替她决定：该上前，还是主动选留下？",
        choices = [
            {
                label = "把自己的登场写进安排，站出来说清",
                outcome = "她第一次先念自己的名字，再把剩下的位置讲完。场子依旧有人照看。",
                traitName = "芷芷也登场",
                bonuses = {
                    Bravery = 4,
                    Initiative = 3
                }
            },
            {
                label = "明确选择守场，把需要的配合讲出来",
                outcome = "留下不再是默认落到她头上的杂事，而是她说清条件后的决定。",
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
        scene = "瑶瑶牙收到一张指名较量的纸，奶团吕布几个字写得格外大。她没有立刻把它拍到议事桌上，而是回看了一眼黑旗，想起这段路已答应的分工。较量仍可谈，今晚先练得更利落，或把收招留力练扎实。",
        choices = [
            {
                label = "挑出最有用的一击，练到收得住",
                outcome = "她没把名号藏起来，只让那一击少了些专为喝彩留下的空当。",
                traitName = "奶团吕布一击",
                bonuses = {
                    MeleeSkill = 4
                }
            },
            {
                label = "练好回看旗子之后的收步和呼吸",
                outcome = "她仍敢站到正面，也更清楚下一口气要留给哪一段约定。",
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
        scene = "羊咩咩用小铃演示一个转弯：弯前响，弯后还能追。路过的驿差偏要把最快那条线指出来，两人争完，发现争的是不同的负重。她可以继续练看准线路的反应，也可以把留力与站稳练成自己的习惯。",
        choices = [
            {
                label = "先看准那条线，再决定什么时候抢",
                outcome = "铃声没有替她作决定，却提醒她每一次快都有一个起点。",
                traitName = "弯前听铃",
                bonuses = {
                    Initiative = 4,
                    RangedDefense = 2
                }
            },
            {
                label = "把弯前留下的力气用到下一段",
                outcome = "她不把稳等同于慢，只是不再在还没拐完时用光所有力气。",
                traitName = "弯后还有力",
                bonuses = {
                    Stamina = 5,
                    Hitpoints = 3
                }
            }
        ]
    },
    chenzhihan = {
        title = "月饼帮这面盾归自己",
        scene = "陈知含把月饼分完，这次先留下了自己的那份。轮到说想练什么，她指向那面曾替自己挡过一下的盾，没再只说都可以。她可以专门练把自己护住，也可以练开口告诉伙伴自己正要做什么。",
        choices = [
            {
                label = "先护稳自己，再去接下一面盾",
                outcome = "她把这一盾写进练习簿，记的是自己看清后作出的判断。",
                traitName = "自己的这一盾",
                bonuses = {
                    MeleeDefense = 3,
                    Hitpoints = 3
                }
            },
            {
                label = "把想学与需要的配合明确说出来",
                outcome = "月饼帮仍很热闹，这回她的声音也在里面，不用总等别人来问。",
                traitName = "月饼先留自己",
                bonuses = {
                    Bravery = 4,
                    Stamina = 3
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
        opening = "城镇酒馆里，小原大人把一页写满问题的纸放在阿飞面前。纸上没有请团长表演威风，只问队员想自己试一次时，他能不能把话听完。阿飞才要说我当然会带，小原就敲了敲第二行：不是问你会什么，是问你愿意让谁试。小原把纸留在了黑旗名册里。",
        followup = "开篇已经听过。小原留下两种回信办法：写一件团长肯亲自承认的不足，或写一个愿意交给伙伴自己试的安排。它们都不能替别人保证结果。",
        choices = [
            { label = "回信谈自己的不足", outcome = "小原回信说，愿意把话说实已经是一次开始，随信附上少量旅费。", reward = { kind = "money", amount = 40 } },
            { label = "回信谈交给伙伴的决定", outcome = "小原送来几件维护器材，希望下一次尝试有足够准备。", reward = { kind = "tools", amount = 4 } }
        ]
    },
    er_haman = {
        name = "哈曼卡恩", required = 6, member = "", title = "旗号大，承诺也得落地",
        opening = "哈曼卡恩在城镇约见阿飞，指着那面过分气派的旗，问名字写大之后，做不到的话还算不算数。阿飞笑说飞爹当然撑得住，对方却让他把最不敢打包票的一件事说出来。谈话没有分胜负，只把一句承诺从排场里抽出来，留给阿飞自己掂量。",
        followup = "哈曼留下的问题还在：承诺遇到变化时，是先明确哪里不能做，还是先提出仍能做到的替案？两封不同的回信都值得认真写。",
        choices = [
            { label = "明确写出承诺的边界", outcome = "哈曼认可这份清楚的说明，寄来一小包医疗补给。", reward = { kind = "medicine", amount = 3 } },
            { label = "写出自己愿承担的替案", outcome = "哈曼的回信很短：那就按说清的去试。随信附了少量旅费。", reward = { kind = "money", amount = 40 } }
        ]
    },
    er_sige = {
        name = "四哥", required = 9, member = "", title = "第四张凳子留给谁",
        opening = "四哥在酒馆留了四张凳子，三张给开局的队长，第四张先空着。阿飞问是不是该让大哥来坐，他说也可以留给那个还没敢开口的人。儿飞派的称呼被他说得像一句寻常玩笑：飞爹，不就是愿意等下一句的人吗？阿飞没有立刻坐下，把空凳往桌边拉近了些。",
        followup = "四哥请阿飞回信讲讲那张空凳：让新人先说，还是由老队员先把难处讲出来？无需真有某个人同场，也不规定谁必须跟队。",
        choices = [
            { label = "让新人先讲自己想试什么", outcome = "四哥让人带来一小批弹药，信上写着先准备，再让本人试。", reward = { kind = "ammo", amount = 12 } },
            { label = "由队长先说出自己的难处", outcome = "四哥回信附上少量旅费，笑说这回桌边总算不只有好听的话。", reward = { kind = "money", amount = 40 } }
        ]
    },
    er_keke = {
        name = "可可", required = 0, member = "keke", title = "保可梦也要听见一句实话",
        opening = "可可留给黑旗一张便笺：自己人三个字，不该意味着谁永远替谁挡下所有事。她在下面写了个问题，阿飞若真想做飞爹，能不能先承认也有拿不准的时候？纸上没有要他变弱，只给彼此留了说不的一小块空白。她即使已经不在队，这段留过的话也仍能被读到。",
        followup = "这张便笺已经读过。回信可以认真回应那句拿不准，也可以写下今后询问同伴意见的方式；她的真实去留不会因此被改变。",
        choices = [
            { label = "承认一次拿不准的判断", outcome = "便笺的后页留有一份早已备好的小额旅费，这是伙伴留下的一次支持。", reward = { kind = "money", amount = 35 } },
            { label = "约定先问本人愿意承担什么", outcome = "名册里附着的医疗补给记入公共储备，只领这一次。", reward = { kind = "medicine", amount = 2 } }
        ]
    },
    er_xiaogui = {
        name = "溺水小龟", required = 0, member = "xiaogui", title = "这份战报想给飞爹看",
        opening = "小龟在留给阿飞的纸上画了自己的小龟化身，旁边写着想拿一场给飞爹看。他没有要求包赢，只想等自己作过判断以后，有个人肯听他从第一步讲起。阿飞读到最后才发现，那句想被看见的愿望，比一句厉害更难回答。纸可以留下，开篇不需要小龟此刻同场。",
        followup = "把战报读完之后，阿飞可以回信先问他的判断，也可以写明愿意认真复盘失手的地方。这里不安排真实比赛或凭空改动任何战绩。",
        choices = [
            { label = "先问你当时为什么这样选", outcome = "这段回应记进名册，随战报预留的一小批弹药转入公共储备。", reward = { kind = "ammo", amount = 10 } },
            { label = "约定失手那一段也一起看", outcome = "预留的修整器材记入公共储备，留给以后真实走过的路。", reward = { kind = "tools", amount = 3 } }
        ]
    },
    er_yuchujiu = {
        name = "余初九", required = 0, member = "yuchujiu", title = "叫你飞爹，也能叫你停",
        opening = "初九留下的纸条开头就写了一个停，阿飞仿佛又听见那声响亮的提醒。下一行却很认真：认你这面旗，不代表每句话都只能点头。她愿意在讲清理由后跟他再走一步，也希望他愿意被自己叫停。忠诚和反问同时留在这张纸上，阿飞把它折好，放回贴身的口袋。",
        followup = "阿飞可以回应那声停，或写下双方讲清风险后怎样再一起作决定。回信不要求她重返队伍，也不修改阵亡或离队记录。",
        choices = [
            { label = "答应先听清叫停的理由", outcome = "纸条夹着的小额旅费记入公共钱袋，这份支持只收一次。", reward = { kind = "money", amount = 35 } },
            { label = "约定说清风险后一起承担", outcome = "名册附记的一点医疗补给记入公共储备，后续仍按各人的真实状态继续。", reward = { kind = "medicine", amount = 2 } }
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
    if (!this.isOrigin() || typeof id != "string" || !(id in this.RootStories)) return this.result(false, "没有这条六根线索。");
    if (!this.canManage()) return this.result(false, "请在友好城镇或安全扎营处阅读线索。");
    local data = this.RootStories[id];
    if (data.member == "" && this.currentTown() == null) return this.result(false, "这位水友代表是城镇联系人，请到友好城镇会面。");
    if (this.rootStatus(id) == "locked") return this.result(false, "这条开篇线索尚未出现。");
    // Triggering the opening is deliberately independent of completing its follow-up.
    this.set("root_triggered_" + id, true);
    return this.result(true, data.opening + "\n\n这段话已收进名册，可以稍后再回信。");
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
        return this.result(false, "没有这项六根后续选择。");
    if (!this.canManage()) return this.result(false, "请到安全地点再回信。");
    if (this.rootStatus(id) != "opened") return this.result(false, "请先触发这条开篇；已结算的回信不能重复领奖。");
    local data = this.RootStories[id].choices[choice];
    try { this.grantStoryReward(data.reward); }
    catch (error) { ::logError("[AfeixExpedition] Root reward failed: " + error); return this.result(false, "公共储备容量不足或补给未能完整登记，本次回信未结算。请腾出容量后再领取。"); }
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
