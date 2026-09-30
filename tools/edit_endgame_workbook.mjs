// Targeted edit of the established V2 workbook; preserve sheets and charts.
import fs from 'node:fs/promises';
import path from 'node:path';
import assert from 'node:assert/strict';
import {FileBlob, SpreadsheetFile} from '@oai/artifact-tool';
const root=process.cwd(), cache=path.join(root,'.cache/endgame-balance-20260930');
await fs.mkdir(cache,{recursive:true});
const workbookPath=path.join(root,'docs/design/balance-v2/全人物数值与招募总表.xlsx');
const backup=path.join(cache,'before-workbook.xlsx');
try{await fs.access(backup);}catch{await fs.copyFile(workbookPath,backup);}
const wb=await SpreadsheetFile.importXlsx(await FileBlob.load(process.argv.includes('--reopen')?workbookPath:backup));
const get=n=>wb.worksheets.getItem(n),val=(s,a,v)=>s.getRange(a).values=[[v]];
if(process.argv.includes('--reopen')){
 const projection=JSON.parse(await fs.readFile(path.join(cache,'projection.json'),'utf8'));
 assert.equal(wb.worksheets.items.length,16);
 assert.equal(get('属性成长').charts.items.length,35);
 for(let i=0;i<projection.length;i++)for(let j=0;j<8;j++)
  assert.ok(Math.abs(Number(get('成长总览').getRange(`${String.fromCharCode(67+j)}${i+6}`).values[0][0])-projection[i].base_means[j])<1e-8);
 console.log('Saved workbook reopened: 16 sheets, 35 native charts and 280 correct growth results.');
 process.exit(0);
}
if(process.argv.includes('--inspect')){
 console.log((await wb.inspect({kind:'sheet',include:'id,name',maxChars:3500})).ndjson);
 for(const [sheet,range] of [['招募节奏','A5:D8'],['成长总览','A5:S8'],['装备明细','A5:K8'],['人物特质','A5:H7'],['技能选择','A5:M7']])
  console.log((await wb.inspect({kind:'region',sheetId:sheet,range,maxChars:2300,tableMaxRows:4,tableMaxCols:19})).ndjson);
 const preview=await wb.render({sheetName:'属性成长',range:'A262:R269',scale:1,format:'png'});
 await fs.writeFile(path.join(cache,'before-song.png'),new Uint8Array(await preview.arrayBuffer()));
 console.log('Saved baseline view.');
 process.exit(0);
}
const p=JSON.parse(await fs.readFile(path.join(root,'docs/design/balance-v2/proposal.json'),'utf8'));
const projection=JSON.parse(await fs.readFile(path.join(cache,'projection.json'),'utf8'));
const col=i=>String.fromCharCode(65+i);
const attr=get('属性成长'),recruit=get('招募节奏'),grow=get('成长总览'),equipment=get('装备明细');
for(let i=0;i<p.people.length;i++){
 const q=p.people[i],r=i+6;
 val(recruit,`D${r}`,q.role);
 for(let j=0;j<8;j++){
  const a=6+i*8+j;
  val(attr,`D${a}`,q.attrs[j]);val(attr,`E${a}`,q.stars[p.fields[j]]??0);val(attr,`F${a}`,q.allocation[j]);
 }
 val(grow,`B${r}`,q.role);val(grow,`N${r}`,q.target);
 val(equipment,`K${r}`,q.endgame_weapon);
}
for(let i=0;i<p.skills.length;i++)val(get('技能选择'),`J${i+6}`,p.skills[i].mastery);
for(const sheet of ['总览','成长总览','属性成长'])val(get(sheet),'A3','2026-09-30终局岗位修订。一级含固定特质；11级按30项培养和所选剧情计算，装备、原版专长、阿飞路线与小龟特殊规则另计。实战待验收。');
wb.recalculate();
for(let i=0;i<p.people.length;i++){
 assert.equal(Number(grow.getRange(`K${i+6}`).values[0][0]),30);
 for(let j=0;j<8;j++)assert.ok(Math.abs(Number(grow.getRange(`${col(j+2)}${i+6}`).values[0][0])-projection[i].base_means[j])<1e-8,`${p.people[i].key}/${j}`);
}
const base=Number(grow.getRange('C6').values[0][0]);
val(attr,'D6',p.people[0].attrs[0]+1);wb.recalculate();
assert.equal(Number(grow.getRange('C6').values[0][0]),base+1);
val(attr,'D6',p.people[0].attrs[0]);wb.recalculate();
const errors=await wb.inspect({kind:'match',searchTerm:'#REF!|#DIV/0!|#VALUE!|#NAME\\?|#N/A|#NUM!|#NULL!|#SPILL!|#CALC!',options:{useRegex:true,maxResults:100},maxChars:4000});
await fs.writeFile(path.join(cache,'workbook-errors.ndjson'),errors.ndjson);
const exported=await SpreadsheetFile.exportXlsx(wb);
await exported.save(path.join(cache,'candidate-workbook.xlsx'));
for(const [sheet,range,name] of [['属性成长','A262:R269','song'],['属性成长','A222:R229','suwa'],['成长总览','A30:N33','roles'],['技能选择','A86:J90','mastery']]){
 const image=await wb.render({sheetName:sheet,range,scale:1,format:'png'});
 await fs.writeFile(path.join(cache,`after-${name}.png`),new Uint8Array(await image.arrayBuffer()));
}
console.log('Candidate exported. Verified 280 growth results, 35 allocations and input recalculation.');
