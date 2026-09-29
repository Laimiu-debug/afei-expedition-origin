// Shared V2 workbook enrichment. Called by the existing workbook builder.
import fs from 'node:fs/promises';
import path from 'node:path';
import assert from 'node:assert/strict';
import {addInlineGrowthRadars} from './balance_v2_radar.mjs';
const root=process.cwd(),out=path.join(root,'docs/design/balance-v2'),cache=path.join(root,'.cache/refresh-v2');
const read=async n=>JSON.parse(await fs.readFile(path.join(out,n),'utf8'));
const val=(s,a,x)=>s.getRange(a).values=[[x]],formula=(s,a,x)=>s.getRange(a).formulas=[[x]];
const col=i=>{let s='';for(i++;i>0;i=Math.floor((i-1)/26))s=String.fromCharCode(65+(i-1)%26)+s;return s;};
const navy='#19364B',green='#E3F3EE',pale='#EFF4F7';
function body(s,range,height=90){s.getRange(range).format={font:{name:'Arial',size:10,color:navy},rowHeight:height,wrapText:true,verticalAlignment:'center'};}
function headers(s,range,values){s.getRange(range).values=[values];s.getRange(range).format={fill:navy,font:{name:'Arial',size:10,bold:true,color:'#FFFFFF'},rowHeight:45,wrapText:true};}
export async function refreshV2Workbook(wb){
 const [p,live,art,traits,evidence]=await Promise.all(['proposal.json','current-roster.json','skill-icon-manifest.json','trait-design.json','feedback-evidence.json'].map(read));
 const get=n=>wb.worksheets.getItem(n),last=p.people.length+5,skillLast=p.skills.length+5;
 const iconChecks=[];
 async function imageAt(s,key,file,sha,row,column,offsetX,offsetY){
  s.images.add({dataUrl:'data:image/png;base64,'+(await fs.readFile(path.join(root,file))).toString('base64'),anchor:{from:{row:row-1,col:column,rowOffsetPx:offsetY,colOffsetPx:offsetX},extent:{widthPx:56,heightPx:56}}});
  iconChecks.push({sheet:s.name,row,col:column,key,path:file,sha256:sha});
 }
 const current=get('现行对照'),liveBy=Object.fromEntries(live.characters.map(x=>[x.key,x]));
 const ordered=p.people.map(q=>liveBy[q.key]);assert.ok(ordered.every(Boolean));
 const condition=c=>c.isCaptain?'开局同行':Object.entries(live.encounterRequirements[c.key]).map(([k,v])=>`${({jobs:'非送信付费契约',battles:'参战历史最高',level:'历史最高等级',towns:'不同非敌对非军事聚落',types:'非送信契约种类',companions:'曾同行主题人物'})[k]??k} ≥ ${v}`).join('；');
 current.getRange(`A6:O${last}`).values=ordered.map(c=>[c.name,c.key,c.role,...c.attrs,c.hireCost,c.wage,p.fields.filter(f=>c.stars[f]).map(f=>p.labels[p.fields.indexOf(f)]+c.stars[f]+'星').join('、'),c.equipment.join('、')]);
 headers(current,'P5:Q5',['当前全部招募条件','内容来源']);current.getRange(`P6:Q${last}`).values=ordered.map(c=>[condition(c),c.key==='xiwen'?'可选DLC 0.1.0':'主包 v0.25.2']);
 body(current,`A6:Q${last}`,70);current.getRange(`P1:P${last}`).format.columnWidth=72;current.getRange(`Q1:Q${last}`).format.columnWidth=21;
 const ct=current.tables.items[0],ctn=ct.name,cts=ct.style;ct.delete();current.tables.add(`A5:Q${last}`,true,ctn).style=cts;
 val(current,'A3',`2026-09-29入口导出，内部版本${live.version}。希文当前总价280、走过1城可遇见；V2设计报价与门槛见“招募节奏”。`);
 const t=wb.worksheets.add('人物特质');t.showGridLines=false;t.tabColor='#086C70';body(t,`A1:AF${last}`,108);t.getRange('A2:AF4').format.rowHeight=25;
 val(t,'A1','35人固定特质与队长耐力');t.getRange('A1').format={font:{name:'Arial',size:19,bold:true,color:navy},rowHeight:36,wrapText:false};
 val(t,'A3','每人固定2项，剧情二选一另列。特质八维已含在原表；右侧反推实装基础。反馈仅供设计，未实装。');t.getRange('A3').format={font:{name:'Arial',size:10,color:'#607483'},wrapText:false,rowHeight:25};
 headers(t,'A5:AB5',['人物','ID','固定特质一','固定特质二','完整效果','所选特质票数 / 样本','票数前三（含并列）','采用依据',...p.labels.map(x=>'原版特质Δ'+x),'每级额外疲劳','目标等级','计入成长次数','额外疲劳合计',...p.labels.map(x=>'实装基础 '+x)]);
 t.getRange(`A6:AB${last}`).values=traits.people.map(q=>[q.name,q.key,...q.traits.map(k=>traits.definitions[k].name),q.effects,
  q.trait_respondents?`${q.traits.map((k,i)=>traits.definitions[k].name+' '+q.selected_votes[i]+'票').join('；')}\n${q.trait_respondents}份含特质反馈 / ${q.responses}份人物反馈`:'暂无特质票，按V2定位补全',
  q.top3_including_ties.map(x=>x.name+' '+x.votes+'票').join('；')||'无',q.reason,...q.delta,q.level_fatigue_per_level,11,null,null,...Array(8).fill(null)]);
 [17,18,20,20,68,43,45,47,...Array(8).fill(15),15,12,16,17,...Array(8).fill(16)].forEach((w,i)=>t.getRange(`${col(i)}1:${col(i)}${last}`).format.columnWidth=w);
 t.getRange(`C6:D${last}`).format.verticalAlignment='top';t.getRange(`C6:D${last}`).format.horizontalAlignment='center';t.getRange(`I6:AB${last}`).setNumberFormat('0.0');t.getRange(`Q6:Q${last}`).format.fill='#FFF0CD';t.getRange(`S6:AB${last}`).format.fill=green;
 for(let i=0;i<p.people.length;i++){
  const r=i+6,q=traits.people[i];assert.equal(q.key,p.people[i].key);if(r%2===0)t.getRange(`A${r}:P${r}`).format.fill=pale;
  formula(t,`S${r}`,`=MAX(0,MIN(10,R${r}-1))`);formula(t,`T${r}`,`=Q${r}*S${r}`);
  for(let j=0;j<8;j++)formula(t,`${col(20+j)}${r}`,`='属性成长'!D${i*8+j+6}-${col(8+j)}${r}`);
  for(let j=0;j<2;j++){const d=traits.definitions[q.traits[j]];await imageAt(t,d.id,d.icon,d.icon_sha256,r,j+2,32,42);}
 }
 headers(t,'AC5:AF5',['剧情特质一','分支一效果','剧情特质二','分支二效果']);
 const bonus=b=>p.fields.map((f,i)=>b[f]?p.labels[i]+'+'+b[f]:null).filter(Boolean).join('、')||'无八维加成';
 t.getRange(`AC6:AF${last}`).values=p.people.map(q=>q.growth_choices.flatMap(g=>[g.traitName,bonus(g.bonuses)]));
 t.getRange(`AC1:AF${last}`).format.columnWidth=28;
 t.tables.add(`A5:AF${last}`,true,'FixedTraits');t.freezePanes.freezeRows(5);t.freezePanes.freezeColumns(2);
 const attr=get('属性成长');headers(attr,'N5:N5',['专属等级加成']);attr.getRange('N1:N285').format.columnWidth=16;
 for(let i=0;i<p.people.length;i++)for(let j=0;j<8;j++){
  const r=6+i*8+j;formula(attr,`N${r}`,j===1?`='人物特质'!T${i+6}`:'=0');formula(attr,`M${r}`,`=D${r}+J${r}+F${r}*L${r}+N${r}`);
 }
 body(attr,'N6:N285',25);attr.getRange('N6:N285').format.fill=green;attr.getRange('N6:N285').setNumberFormat('0.0');
 val(attr,'A3','一级值已含固定原版特质；11级=一级+剧情+30项升级+专属等级加成。路线、装备、专长与小龟体质另计。');
 val(get('成长总览'),'A3','每人分配30项、分支一致=1。含固定特质预算与队长等级加成；不含路线、装备、专长及小龟体质。');
 val(get('招募节奏'),'A3','所有门槛同时满足；希文第6日起、3战、1履约、2城、历史最高2级可招，规划1级。报价含装备，城镇修正前。');
 const equip=get('装备明细'),grow=get('成长总览');
 headers(equip,'L5:N5',['随身饰品','饰品决心加成','一级含饰品决心']);
 equip.getRange(`L6:N${last}`).values=p.people.map(q=>[q.equipment.filter(k=>p.items[k].slot==='accessory').map(k=>p.items[k].name).join('、')||'无决心饰品',q.equipment.reduce((n,k)=>n+(p.items[k].owner===q.key?p.items[k].bonuses?.Bravery??0:0),0),null]);
 body(equip,`L6:N${last}`,58);equip.getRange(`L1:L${last}`).format.columnWidth=32;equip.getRange(`M1:N${last}`).format.columnWidth=20;
 equip.getRange(`M6:M${last}`).format.fill='#FFF0CD';equip.getRange(`N6:N${last}`).format.fill=green;
 headers(grow,'O5:P5',['饰品决心加成','11级含饰品决心']);body(grow,`O6:P${last}`,54);grow.getRange(`O1:P${last}`).format.columnWidth=22;grow.getRange(`O6:P${last}`).format.fill=green;
 for(let i=0;i<p.people.length;i++){const r=i+6;formula(equip,`N${r}`,`='属性成长'!D${8*i+8}+M${r}`);formula(grow,`O${r}`,`='装备明细'!M${r}`);formula(grow,`P${r}`,`=E${r}+O${r}`);}
 for(const [s,range] of [[equip,`A5:N${last}`],[grow,`A5:P${last}`]]){const table=s.tables.items[0],name=table.name,style=table.style;table.delete();s.tables.add(range,true,name).style=style;}
 val(equip,'A3','希文的圆圆化妆镜随招募赠送，无负重、不可出售；仅希文装备在饰品栏时+20决心，换下或放背包时加成改为0。');
 val(grow,'A3','C:J为11级本体值，不含装备。希文决心本体24，戴镜44另列于P列；每人30项，分支一致=1。');
 const skills=get('技能选择');skills.deleteAllDrawings();skills.getRange(`B6:B${skillLast}`).format.columnWidth=33;skills.getRange(`B6:B${skillLast}`).format.horizontalAlignment='right';
 for(let i=0;i<p.skills.length;i++){
  const d=p.skills[i],r=i+6,icon=art.icons.find(x=>x.key===d.key);assert.ok(icon,d.key);val(skills,`L${r}`,live.memberSkillDefs[d.key]?.text??'V2设计新增；当前游戏未实装。');assert.equal(skills.getRange(`M${r}`).values[0][0],d.key);
  await imageAt(skills,icon.key,icon.path,icon.sha256,r,1,6,r>=105?72:32);
 }
 skills.getRange(`A105:M${skillLast}`).format.rowHeight=150;val(skills,'A3','102项三选一：96项现行图标，眼子哥3项提案图、希文3项暂用原版图。7级选择1项，11级仅强化已选分支。');
 const route=get('队长与事件');route.deleteAllDrawings();
 route.tables.items[0].rows.add(null,[['里根（DLC）','阿飞饰品栏；不占佣兵名额',3,15,0,'原版释放战犬：放到相邻空地，随后由AI行动；存活时战后返回。会阵亡，失去后不补发。','新战役开局免费配发；无佣兵日薪。与电子烟共用一个饰品槽。','须加载DLC；旧战役不自动补发；沿用原版战犬规则。']]);body(route,'A13:H13',110);
 const mirror=p.accessories.find(x=>x.key==='xiwen_round_mirror');
 route.tables.items[0].rows.add(null,[[mirror.name,'正圆镜面、细铜边、短圆柄；占饰品栏',0,0,0,mirror.text,'随希文招募赠送一件；计价0、负重0，不改变470报价。','一级本体21+镜20=41；默认剧情后本体24+镜20=44。尚未实装。']]);body(route,'A14:H14',110);
 for(const [key,r] of [['wawa',6],['haoqi',7],['feidie',8],['ecig_puff',9],['unleash_wardog',13]]){const icon=art.icons.find(x=>x.key===key);route.getRange(`A${r}`).format.verticalAlignment='top';await imageAt(route,key,icon.path,icon.sha256,r,0,18,43);}
 const over=get('总览');val(over,'B6',p.people.length);val(over,'B7',p.skills.length);val(over,'C6','35名人物纳入V2；里根另作宠物，不占佣兵名额。');val(over,'C7','34名非阿飞成员各3选1；阿飞3条互斥路线另列。');
 val(over,'A3','2026-09-29 V2.1；16张表。新增固定特质、希文招募/技能、阿飞11级裸疲劳124。设计尚未实装。');
 over.tables.items[0].rows.add(null,[['固定特质','35人 / 每人2项','“人物特质”列出效果、票数、互斥校验和反推基础；八维不重复叠加。'],['阿飞远征耐力','2～11级每级+3','11级累计+30，裸疲劳124；装备负重另扣，不占用30项培养。'],['希文培养','第6日起；470克朗；日薪9','3战/1履约/2城/最高2级；1级入队，7级三选一，11级精通。'],['线上反馈','65人物反馈 / 4玩法建议','只读全量快照；39个Cookie参与标识，非实名人数。小样本不等于全体共识。'],['DLC及图标','独立可选包；107技能图标','分支已合并；96现行成员+6设计技能+5队长/物品图标，另有70个特质图标。']]);body(over,'A19:C23',58);
 over.tables.items[0].rows.add(null,[['希文的圆圆化妆镜','本体决心21 + 饰品20 = 41','默认剧情成长后本体24、戴镜44；占饰品栏，无负重。换下失去加成。']]);body(over,'A24:C24',58);
 const source=get('来源说明');source.tables.items[0].rows.add(null,[['网站特质与玩法反馈',evidence.fetched_at,'65人物、4建议，全量只读；使用特质和玩法线索，不采用评分数值。','https://sdhaohan.cn/#member=afei'],['固定特质记账','表列八维已含效果','实装基础=表列一级值-原版固定特质增减；条件机制另按原版执行。','trait-design.json / 人物特质'],['技能图标','107技能图 + 70特质图','希文暂用反击/盾墙/探路者原版图；图片嵌入单元格对应行。','skill-icon-manifest.json / trait-design.json'],['当前DLC','希文+里根 0.1.0','当前仍独立可选包；本次V2设计不改变游戏脚本。','current-roster.json']]);body(source,`A6:D${source.tables.items[0].getDataRows().values.length+5}`,58);
 addInlineGrowthRadars(wb,p.people.length);wb.recalculate();assert.equal(get('成长总览').getRange('D6').values[0][0],124);assert.equal(get('招募节奏').getRange('P40').values[0][0],470);assert.equal(get('成长总览').getRange('K40').values[0][0],30);
 val(t,'Q6',4);wb.recalculate();assert.equal(get('成长总览').getRange('D6').values[0][0],134);val(t,'Q6',3);wb.recalculate();
 assert.equal(equip.getRange('N40').values[0][0],41);assert.equal(grow.getRange('E40').values[0][0],24);assert.equal(grow.getRange('P40').values[0][0],44);
 val(equip,'M40',0);wb.recalculate();assert.equal(grow.getRange('P40').values[0][0],24);assert.equal(grow.getRange('E40').values[0][0],24);val(equip,'M40',20);wb.recalculate();
 await fs.writeFile(path.join(cache,'embedded-icons.json'),JSON.stringify(iconChecks,null,2));
 const report={characters:p.people.length,skills:p.skills.length,fixed_traits:70,radar_charts:p.people.length,embedded_icons:iconChecks.length,afei_fatigue11:124,xiwen_price:470,xiwen_allocation:30,xiwen_resolve:{base:21,mirror:20,level1_equipped:41,level11_bare:24,level11_equipped:44,unequip_recalculation_passed:true},current_skills:96,website_numeric_scores_used:false};
 await fs.writeFile(path.join(out,'refresh-validation.json'),JSON.stringify(report,null,2)+'\n');return report;
}
