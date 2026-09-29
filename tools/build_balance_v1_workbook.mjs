// Build from proposal/validation with @oai/artifact-tool. Run from repository cwd.
import fs from 'node:fs/promises';
import path from 'node:path';
import assert from 'node:assert/strict';
import {Workbook,SpreadsheetFile} from '@oai/artifact-tool';
const out=path.resolve('docs/design/balance-v1'), cache=path.resolve('.cache/balance-v1');
const p=JSON.parse(await fs.readFile(path.join(out,'proposal.json'),'utf8'));
const v=JSON.parse(await fs.readFile(path.join(out,'validation.json'),'utf8'));
const wb=Workbook.create();
const names=['总览','招募节奏','属性成长','成长总览','装备明细','技能选择','队长与事件','经济模型','伤害与概率','现行对照','来源说明'];
const ss=Object.fromEntries(names.map(n=>[n,wb.worksheets.add(n)]));
const navy='#19364B',teal='#086C70',amber='#FFF0CD',green='#E3F3EE',gray='#607483',pale='#EFF4F7';
const col=i=>{let s='';for(i++;i>0;i=Math.floor((i-1)/26))s=String.fromCharCode(65+(i-1)%26)+s;return s;};
const val=(s,cell,x)=>s.getRange(cell).values=[[x]];
const formula=(s,cell,x)=>s.getRange(cell).formulas=[[x]];
function setup(name,title,note,headers,rows,widths){
 const s=ss[name],last=col(headers.length-1),end=rows.length+5;
 s.showGridLines=false;s.tabColor=teal;
 s.getRange(`A1:${last}${end}`).format.font={name:'Arial',size:10,color:navy};
 s.getRange(`A1:${last}${end}`).format.verticalAlignment='center';
 s.getRange(`A1:${last}${end}`).format.rowHeight=25;
 s.getRange(`A1:${last}${end}`).format.wrapText=true;
 val(s,'A1',title);s.getRange('A1').format.font={name:'Arial',size:19,bold:true,color:navy};
 s.getRange('A1').format.wrapText=false;s.getRange('A1').format.rowHeight=36;
 val(s,'A3',note);s.getRange('A3').format.wrapText=false;s.getRange('A3').format.font.color=gray;
 s.getRange(`A5:${last}5`).values=[headers];s.getRange(`A5:${last}5`).format={fill:navy,font:{name:'Arial',size:10,bold:true,color:'#FFFFFF'},rowHeight:36,wrapText:true};
 if(rows.length)s.getRange(`A6:${last}${end}`).values=rows;
 for(let r=6;r<=end;r++)if(r%2===0)s.getRange(`A${r}:${last}${r}`).format.fill=pale;
 widths.forEach((w,i)=>s.getRange(`${col(i)}1:${col(i)}${end}`).format.columnWidth=w);
 s.freezePanes.freezeRows(5);s.freezePanes.freezeColumns(2);
 if(rows.length)s.tables.add(`A5:${last}${end}`,true,'T'+names.indexOf(name));
 return s;
}
const input=(s,r)=>s.getRange(r).format.fill=amber;
const num=(s,r,fmt='0')=>{s.getRange(r).setNumberFormat(fmt);s.getRange(r).format.horizontalAlignment='right';};
const output=(s,r)=>{s.getRange(r).format.fill=green;num(s,r,'0.0');};
const lookup=Object.fromEntries(p.people.map((q,i)=>[q.key,i]));
const itemnames=items=>items.map(x=>p.items[x].name).join('、');

// A source location is recorded once on 来源说明; derived cells reference live inputs.
const recruit=setup('招募节奏','34人招募与报价','黄色可编辑；所有门槛同时满足；历史最高等级输入用于实际补级与价格。价格为城镇修正前。',
 ['人物','ID','分组','定位','最低日','参战≥','履约≥','城镇≥','资格等级≥','阶段等级上限','候选生成时历史最高等级','实际入队级','服务费','一级日薪','装备原价','基准总价','是否队长'],
 p.people.map(q=>[q.name,q.key,q.group,q.role,q.day,q.battles,q.contracts,q.towns,q.highest_level,q.join_level,8,null,q.service_fee,q.wage,q.equipment_value,null,q.current.isCaptain?1:0]),
 [17,18,17,24,10,10,10,10,13,14,20,13,12,12,13,14,12]);
input(recruit,'E6:K39');input(recruit,'M6:N39');num(recruit,'E6:Q39');output(recruit,'L6:L39');output(recruit,'P6:P39');
recruit.getRange('L6:L39').formulas=p.people.map((q,i)=>[`=MAX(1,MIN(J${i+6},1+INT((K${i+6}-2)/3)))`]);
recruit.getRange('P6:P39').formulas=p.people.map((q,i)=>{let r=i+6;return [`=IF(Q${r}=1,0,ROUNDUP((M${r}+O${r}*'来源说明'!$B$6+'来源说明'!$B$7*(L${r}-1)^1.5)/10,0)*10)`];});

const ar=[];p.people.forEach(q=>p.fields.forEach((f,i)=>ar.push([q.name,q.key,p.labels[i],q.attrs[i],q.stars[f]||0,q.allocation[i],q.growth_choices[0].bonuses[f]||0,q.growth_choices[1].bonuses[f]||0,1,null,(p.growth_roll_min[i]+p.growth_roll_max[i])/2,null,null])));
const attr=setup('属性成长','属性、星数与30项培养预算','每个人8行；同一人物的成长分支列必须一致（1或2）；裸值不含路线/体质/装备/专长。',
 ['人物','ID','属性','一级基础','星数0～3','升级选取0～10','剧情分支1','剧情分支2','选择1或2','所选剧情值','0星每次均值','本星每次均值','11级属性均值'],ar,[17,18,15,12,12,15,13,13,13,14,16,17,18]);
input(attr,'D6:I277');num(attr,'D6:M277','0.0');output(attr,'J6:M277');
attr.getRange('J6:J277').formulas=ar.map((_,i)=>[`=IF(I${i+6}=1,G${i+6},H${i+6})`]);
attr.getRange('L6:L277').formulas=ar.map((_,i)=>[`=K${i+6}+E${i+6}*0.5`]);
attr.getRange('M6:M277').formulas=ar.map((_,i)=>[`=D${i+6}+J${i+6}+F${i+6}*L${i+6}`]);
attr.getRange('I6:I277').dataValidation={rule:{type:'list',values:['1','2']}};
attr.getRange('E6:E277').dataValidation={rule:{type:'list',values:['0','1','2','3']}};
attr.getRange('F6:F277').dataValidation={rule:{type:'list',values:Array.from({length:11},(_,i)=>String(i))}};
const grow=setup('成长总览','11级人物总览','绿色随属性成长输入重算；分支一致=1且培养合计=30才是合法方案。裸近防不含盾牌与小龟体质。',
 ['人物','角色'] .concat(p.labels,['分配合计','分支一致','日薪11级','培养提示']),
 p.people.map(q=>[q.name,q.role,...Array(11).fill(null),q.weakness]),[17,24,12,13,12,12,12,12,12,12,13,13,15,54]);
for(let i=0;i<p.people.length;i++){let r=i+6,a=i*8+6;
 grow.getRange(`C${r}:J${r}`).formulas=[p.fields.map((_,j)=>`='属性成长'!M${a+j}`)];
 formula(grow,`K${r}`,`=SUM('属性成长'!F${a}:F${a+7})`);
 formula(grow,`L${r}`,`=IF(MAX('属性成长'!I${a}:I${a+7})=MIN('属性成长'!I${a}:I${a+7}),1,0)`);
 formula(grow,`M${r}`,`='招募节奏'!N${r}*'来源说明'!$B$8^10`);
}
output(grow,'C6:M39');grow.getRange('N6:N39').format.rowHeight=54;
grow.getRange('K6:K39').conditionalFormats.add('cellIs',{operator:'notEqual',formula:30,format:{fill:'#FFCFCF'}});
grow.getRange('L6:L39').conditionalFormats.add('cellIs',{operator:'notEqual',formula:1,format:{fill:'#FFCFCF'}});

const equip=setup('装备明细','入队装备与实际负重','物品值来自本机原版；包内标枪半负重/小刀零负重仅适用此配置。小龟禁止头盔；阿飞另配电子烟。',
 ['人物','ID','装备栏','包内','身甲','头甲','装备疲劳','包内疲劳','一级可用疲劳','装备原价','终局换装方向'],
 p.people.map(q=>[q.name,q.key,itemnames(q.equipment),itemnames(q.bag),q.body_armor,q.head_armor,q.equipment_fatigue,q.bag_fatigue,null,q.equipment_value,q.endgame_weapon]),[17,18,62,23,11,11,13,13,17,14,60]);
equip.getRange('A6:K39').format.rowHeight=58;num(equip,'E6:J39','0.0');output(equip,'I6:I39');
equip.getRange('I6:I39').formulas=p.people.map((q,i)=>[`='属性成长'!D${i*8+7}-G${i+6}-H${i+6}`]);

const skills=setup('技能选择','99个成员技能 · 7级三选一','费用列可改用于比较，效果文字不会自动更新；全局命中/恢复/目标上限见总方案。当前文本与新定义并列留档。',
 ['人物','技能','主动1被动0','AP','疲劳','CD','距离','11级疲劳','新效果完整定义','11级其他变化','变更','当前原文','技能ID'],
 p.skills.map(s=>[s.owner_name,s.name,s.active?1:0,s.ap,s.fatigue,s.cd,s.range,null,s.text,s.mastery,s.change,s.current_text,s.key]),[17,23,14,9,10,9,9,13,94,56,24,80,24]);
skills.getRange('A6:M104').format.rowHeight=90;input(skills,'D6:G104');num(skills,'C6:H104');output(skills,'H6:H104');
skills.getRange('H6:H104').formulas=p.skills.map((s,i)=>{let r=i+6;return [`=IF(AND(C${r}=1,E${r}>0),MAX(0,E${r}-MAX(1,INT(E${r}*0.15))),E${r})`];});

const routeRows=p.routes.map(r=>[r.name,r.passive,r.ap,r.fatigue,r.cd,r.effect,r.economy,Ptext()]);
function Ptext(){return p.route_unlock;}
routeRows.push(['电子烟','仅阿飞装备；只发一次',4,10,2,p.accessories[0].text,p.accessories[0].current,'不享受普通成员11级精通']);
routeRows.push(['自行车·留下','生命+2、决心+4',0,0,0,'与告别分支互斥，一次性永久奖励','不产生收入','未计入成长总览，见角色手册6种情景']);
routeRows.push(['自行车·告别','疲劳上限+5、先攻+3',0,0,0,'与留下分支互斥，一次性永久奖励','不产生收入','旧车丢弃不重发']);
routeRows.push(['曹飞派事件','下一实际战斗决心补足+20',0,0,0,'持续两次自身回合结束；阿飞额外流血两次各5，绷带可处理','保留当前版本，一次事件票消耗','不与斗志+30叠加；不默认进入常规战力']);
const route=setup('队长与事件','阿飞总预算与事件边界','路线互斥；人物成长、路线、自行车分别记账。下表全部为提案口径或明确标出的现行保留项。',
 ['项目','常驻/限制','AP','疲劳','CD','效果','经济/现行对照','条件/说明'],routeRows,[20,39,9,9,9,86,69,78]);
route.getRange('A6:H12').format.rowHeight=100;num(route,'C6:E12');

const eco=setup('经济模型','队伍每日现金底线','黄色为可编辑预算；人数固定对应所列名单，工资引用成员日薪。收入按实际净入账；包括预备队。',
 ['情景','人数','等级','一级工资和','工资倍率','实际日薪','食物量/人日','食物单价','食品支出','维修','药品','弹药','维持费/日','再投资/日','需净入账/日','7日储备','具体名单'],
 v.economy.map(x=>[x.team,x.count,x.level,null,1,null,2,3,null,x.repair,x.medicine,x.ammo,null,x.reinvest,null,null,x.members.map(k=>p.people[lookup[k]].name).join('、')]),[22,10,10,16,13,15,15,13,14,12,12,12,16,16,18,17,95]);
for(let i=0;i<4;i++){let r=i+6,x=v.economy[i];formula(eco,`D${r}`,'='+x.members.map(k=>`'招募节奏'!N${lookup[k]+6}`).join('+'));
formula(eco,`F${r}`,`=D${r}*'来源说明'!$B$8^MIN(10,C${r}-1)*'来源说明'!$B$9^MAX(0,C${r}-11)*E${r}`);
formula(eco,`I${r}`,`=B${r}*G${r}*H${r}`);formula(eco,`M${r}`,`=F${r}+I${r}+J${r}+K${r}+L${r}`);formula(eco,`O${r}`,`=M${r}+N${r}`);formula(eco,`P${r}`,`=M${r}*7`);}
num(eco,'B6:P9','#,##0.00');['C6:C9','E6:E9','G6:H9','J6:L9','N6:N9'].forEach(r=>input(eco,r));['D6:D9','F6:F9','I6:I9','M6:M9','O6:P9'].forEach(r=>output(eco,r));eco.getRange('A6:Q9').format.rowHeight=115;

const damageRows=[['血伤原始掷点',90,'输入；独立于甲伤随机掷点'],['甲伤原始掷点×武器甲伤率',180,'输入；例如90×200%'],['穿透率',0.5,'0～1'],['命中部位当前护甲',300,'只填本次命中部位'],['血伤乘数',1,'例如轻装0.4'],['甲伤乘数',0.7,'例如满600总甲战铸0.7'],['总伤害乘数',1,'明确乘区'],['头部倍率',1,'躯干1；普通头部1.5'],['最低伤害参数',0,'普通武器通常0；依技能'],['调整后血伤',null,'原始血伤×血伤乘数×总乘数'],['调整后甲伤',null,'甲伤×甲伤乘数×总乘数'],['实际扣甲',null,'穿透1时不伤甲'],['剩余护甲',null,'穿透1走特殊全穿透路径'],['未取整血伤',null,'剩甲减免和破甲溢出分别结算'],['最终掉血',null,'先头部倍率，再原版四舍五入和最低值'],['补货单次出现概率',0.05,'合格实际补货，不是打开商店'],['尝试次数',20,'独立且没有库存抑制的模型'],['至少出现一次概率',null,'1-(1-p)^n'],['平均等待次数',null,'几何分布平均'],['中位等待次数',null,'几何分布50%分位'],['90%等待次数',null,'几何分布90%分位'],['两店各一次概率',null,'1-(1-p)^2'],['单次治疗',15,'提案电子烟'],['每战次数',2,'必须持久化到战斗状态'],['治疗量总上限',null,'缺血不足时实际收益更低']];
const dmg=setup('伤害与概率','伤害结算与概率试算','黄色输入、绿色公式；只计算单次命中及独立概率。48,000次练习靶原始结果见验证结果.md/validation.json。',
 ['参数/结果','数值','口径'],damageRows,[37,20,100]);input(dmg,'B6:B14');input(dmg,'B21:B22');input(dmg,'B28:B29');num(dmg,'B6:B30','0.00');output(dmg,'B15:B20');output(dmg,'B23:B27');output(dmg,'B30');
const df={15:'=B6*B10*B12',16:'=B7*B11*B12',17:'=IF(B8<1,MIN(B9,B16),0)',18:'=IF(B8<1,B9-B17,0)',19:'=MAX(0,B15*B8-B18*0.1)+IF(OR(B18<=0,B8>=1),MAX(0,B15*MAX(0,1-B8)-B17),0)',20:'=MAX(0,INT(B19*B13+0.5),MIN(INT(B14+0.5),INT(B14*B12+0.5)))',23:'=1-(1-B21)^B22',24:'=IF(B21>0,1/B21,"无出现")',25:'=IF(B21<=0,"无出现",IF(B21>=1,1,ROUNDUP(LN(0.5)/LN(1-B21),0)))',26:'=IF(B21<=0,"无出现",IF(B21>=1,1,ROUNDUP(LN(0.1)/LN(1-B21),0)))',27:'=1-(1-B21)^2',30:'=B28*B29'};
Object.entries(df).forEach(([r,f])=>formula(dmg,'B'+r,f));['B8','B21','B23','B27'].forEach(r=>dmg.getRange(r).setNumberFormat('0.0%'));

const old=setup('现行对照','当前运行数据快照','只读对照：源入口执行导出34人；内部Version31不等于发布版v0.31。不要把本页当建议值。',
 ['人物','ID','当前定位'].concat(p.labels,['当前报价','一级日薪','天赋','当前装备']),
 p.people.map(q=>[q.name,q.key,q.current.role,...q.current.attrs,q.current.hireCost,q.current.wage,p.fields.filter(f=>q.current.stars[f]).map(f=>p.labels[p.fields.indexOf(f)]+q.current.stars[f]+'星').join('、'),q.current.equipment.join('、')]),[17,18,45,...Array(8).fill(11),14,12,44,90]);old.getRange('A6:O39').format.rowHeight=70;num(old,'D6:M39');

const sourceRows=[['装备定价系数',0.6,'提案：全新装备基础值×0.60','tools/balance_v1_design.py'],['补级定价系数',120,'提案：120×(实际等级-1)^1.5','tools/balance_v1_design.py'],['2～11级工资倍率',1.1,'本机原版，不含起源/特性经济倍率','native-manifest.json / character_background.nut'],['12级起工资倍率',1.03,'本机原版，逐级复利','native-manifest.json / character_background.nut'],['肖勤《游戏数值设计》','书目与内容范围','未取得完整正文，不声称通读','https://lib.lynu.edu.cn/mspace/searchDetailLocal/m4c41b0253d8dca35061b1518c33bcff6'],['袁兆阳《游戏数值百宝书》','目录、简介、前言入口','未取得完整正文','https://wap.phei.com.cn/module/goods/wssd_content.jsp?bookid=58845'],['Game Mechanics','出版社目录与公开48页样章','样章含前言目录索引，非48页完整教学正文','https://www.informit.com/store/game-mechanics-advanced-game-design-9780132946728'],['公开样章','Pearson PDF','未取得整本书','https://ptgmedia.pearsoncmg.com/images/9780321820273/samplepages/0321820274.pdf'],['Game Balance','出版社可索引介绍','原页面403；未取得完整正文','https://www.routledge.com/link/link/p/book/9781032034003'],['Ian Schreiber公开课程','成本曲线','课程不等于该书全文','https://gamebalanceconcepts.wordpress.com/2010/07/21/level-3-transitive-mechanics-and-cost-curves/'],['Dormans开放论文','机制模拟与涌现','模拟不证明游戏整体平衡','https://ojs.aaai.org/index.php/AIIDE/article/download/12477/12336/16005'],['原版游戏','本机92份资源脚本','定量以本机实际脚本为准；哈希可追查','native-manifest.json'],['Mod当前','34角色、96当前技能定义','当前有眼子哥技能缺口；提案补至99','current-roster.json / source-manifest.json'],['设计输入','34人、99选项、3路线、电子烟','原创设计提案，未实装','proposal.json'],['离线验证','15项结构/来源检查、256伤害边界、48000练习靶','不等于实际胜率、AI与所有技能代码已测','validation.json / 验证结果.md'],['版本','2026-09-29 / 提案V1','编辑工作簿不自动同步JSON或Mod','总方案.md'],['输入校验','0～3星；0～10升级次数；每人合计30','改分支需同角色8行一致；先看成长总览红色警示','属性成长 / 成长总览'],['统计口径','均值不是整数实例','P10/P90见角色手册，为固定分配精确卷积','角色手册.md'],['队长例外','阿飞路线/自行车，小龟体质额外加算','这些未混入裸属性成长均值','队长与事件 / 角色手册.md'],['输入颜色','黄色=输入；绿色=计算；其他=来源/文字','效果说明不会因修改费用数字自动改写','技能总表.md']];
const source=setup('来源说明','参数来源与使用边界','本工作簿仅用于设计、比较和离线核验。完整研究范围、计算假设与实测缺口都有独立文档。',
 ['来源/参数','值或范围','解释','链接/路径'],sourceRows,[36,46,78,100]);source.getRange('A6:D25').format.rowHeight=58;input(source,'B6:B9');num(source,'B6:B9','0.00');

const over=setup('总览','阿飞远征团 · 全人物平衡 V1','先设计和验证，再决定实装。2026-09-29；共11张表。所有现行运行文件保持不变。',
 ['主题','结果/入口','说明'],[
 ['在册战斗人物',34,'刀一10、刀二8、0.5DFW猪团14、旅途来客2；不含剧情NPC或退役人物'],
 ['成员技能选项',99,'33人各三选一；眼子哥补齐3选项'],['队长路线',3,'蛤蟆人／嘉豪／飞碟互斥；电子烟与自行车单列'],
 ['34人成长预算','每人30项','属性成长可修改基础/天赋/选点/剧情分支；成长总览检查非法分配'],
 ['全员招募预算',null,'城镇倍率前，取招募节奏当前实际入队等级；不包括后期换装'],
 ['12+4轮换需日入账',null,'经济模型第三情景，含再投资；不是测得的固定收入'],
 ['34人收藏需日入账',null,'全收藏有持续运营成本；不是常规12人通关要求'],
 ['已通过原版公式边界',256,'独立执行本机伤害片段与Python模型对比'],['练习靶试验次数',48000,'4武器×3靶子×4000；靶子没有AI/反击/疲劳，不代表实际胜率'],
 ['实际游戏平衡','待实机验收','99分支、3路线、角色组合、敌军地图及经济难度尚需实测'],
 ['书籍阅读范围','公开材料','仅目录/简介/公开样章/作者课程与论文；未声称读完4本书'],
 ['完整设计','总方案.md','人物手册、技能契约、研究依据、验证报告与本表同目录'],
 ['修改方式','黄色输入','绿色自动重算；改动不自动回写JSON或游戏，请同步设计源后重新验证']
 ],[35,33,105]);over.getRange('A6:C18').format.rowHeight=58;
formula(over,'B10',"=SUM('招募节奏'!P6:P39)");formula(over,'B11',"='经济模型'!O8");formula(over,'B12',"='经济模型'!O9");output(over,'B10:B12');

wb.recalculate();
// Independent expectations verify representative and all formula rows.
const numberAt=(s,c)=>Number(s.getRange(c).values[0][0]);
for(let i=0;i<34;i++){assert.equal(numberAt(recruit,'P'+(i+6)),p.people[i].suggested_price);assert.equal(numberAt(grow,'K'+(i+6)),30);
for(let j=0;j<8;j++)assert.ok(Math.abs(numberAt(grow,col(j+2)+(i+6))-v.projection[i].base_means[j])<1e-8);}
for(let i=0;i<4;i++)assert.ok(Math.abs(numberAt(eco,'O'+(i+6))-v.economy[i].minimum_daily_gross)<1e-6);
assert.equal(numberAt(dmg,'B20'),28);assert.equal(numberAt(dmg,'B25'),14);assert.equal(numberAt(dmg,'B26'),45);
const baseline=numberAt(grow,'C6');val(attr,'D6',p.people[0].attrs[0]+1);wb.recalculate();assert.equal(numberAt(grow,'C6'),baseline+1);val(attr,'D6',p.people[0].attrs[0]);
val(attr,'I6',2);wb.recalculate();assert.equal(numberAt(grow,'L6'),0);val(attr,'I6',1);
val(source,'B6',0.7);wb.recalculate();assert.ok(numberAt(recruit,'P9')>p.people[3].suggested_price);val(source,'B6',0.6);wb.recalculate();
const inspection=await wb.inspect({kind:'match',searchTerm:'#REF!|#DIV/0!|#VALUE!|#NAME\\?|#N/A|#NUM!|#NULL!|#SPILL!|#CALC!',options:{useRegex:true,maxResults:300},maxChars:16000});
await fs.writeFile(path.join(cache,'workbook-error-scan.json'),JSON.stringify(inspection,null,2));
await fs.writeFile(path.join(cache,'workbook-error-scan.ndjson'),inspection.ndjson);
const summary=await wb.inspect({kind:'region',sheetId:'总览',range:'A5:C18',maxChars:6500,tableMaxRows:15,tableMaxCols:3});
await fs.writeFile(path.join(cache,'workbook-overview-inspect.json'),JSON.stringify(summary,null,2));
const exported=await SpreadsheetFile.exportXlsx(wb);await exported.save(path.join(out,'全人物数值与招募总表.xlsx'));
// Exporter diagnostics belong in the build cache, outside the user-facing design set.
const diagnostic=path.join(out,'全人物数值与招募总表.xlsx.inspect.ndjson');
await fs.copyFile(diagnostic,path.join(cache,'workbook-export-inspect.ndjson'));
await fs.unlink(diagnostic);
console.log('Workbook exported; independent checks: 34 prices, 272 growth cells, 4 economy scenarios, 3 edit/recalc tests.');
const previews={总览:'A1:C18',招募节奏:'A1:Q11',属性成长:'A1:M14',成长总览:'A1:N11',装备明细:'A1:K10',技能选择:'A1:M9',队长与事件:'A1:H12',经济模型:'A1:Q9',伤害与概率:'A1:C30',现行对照:'A1:O10',来源说明:'A1:D14'};
for(const [name,range] of Object.entries(previews)){
 const image=await wb.render({sheetName:name,range,scale:1,format:'png'});
 await fs.writeFile(path.join(cache,'preview-'+name+'.png'),new Uint8Array(await image.arrayBuffer()));console.log('Rendered '+name);
}
await fs.writeFile(path.join(out,'workbook-validation.json'),JSON.stringify({status:'公式与编辑重算检查通过；视觉预览另行检查',sheets:names.length,price_checks:34,growth_cells_checked:272,economy_checks:4,input_recalculation_checks:3,rendered_sheets:Object.keys(previews)},null,2));
