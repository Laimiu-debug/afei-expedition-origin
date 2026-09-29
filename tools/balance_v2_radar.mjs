// Native editable radar chart; also imported by the reproducible V2 builder.
import fs from 'node:fs/promises';
import path from 'node:path';
import {pathToFileURL} from 'node:url';
import assert from 'node:assert/strict';
import {FileBlob,SpreadsheetFile} from '@oai/artifact-tool';

export function addGrowthRadar(wb){
 const s=wb.worksheets.getItem('属性成长');
 const names=wb.worksheets.getItem('成长总览').getRange('A6:A39').values.map(x=>x[0]);
 assert.equal(new Set(names).size,34);
 assert.ok(names.join(',').length<255);
 // N is the spacer; only the new right-hand panel is formatted.
 s.getRange('N1:N30').format.columnWidth=3;
 s.getRange('O1:V30').format.font={name:'Arial',size:10,color:'#19364B'};
 s.getRange('O1:V30').format.verticalAlignment='center';
 s.getRange('O1:O30').format.columnWidth=17;
 s.getRange('P1:P30').format.columnWidth=21;
 s.getRange('Q1:R30').format.columnWidth=18;
 s.getRange('S1:V30').format.columnWidth=12;
 s.getRange('O1').values=[['六维成长图']];
 s.getRange('O1').format.font={name:'Arial',size:16,bold:true,color:'#19364B'};
 s.getRange('O2').values=[['选择人物']];
 s.getRange('P2').values=[[names[0]]];
 s.getRange('P2').format.fill='#FFF0CD';
 s.getRange('P2').dataValidation={rule:{type:'list',values:names}};
 s.getRange('O3').values=[['切换人物或修改左侧输入，图表随之更新。']];
 s.getRange('O3').format.font.color='#607483';
 s.getRange('O23:R23').values=[['属性','一级基础','11级均值','成长增量']];
 s.getRange('O23:R23').format.fill='#19364B';
 s.getRange('O23:R23').format.font={name:'Arial',size:10,bold:true,color:'#FFFFFF'};
 const dimensions=['生命','疲劳上限','决心','近攻','远攻','近防'];
 s.getRange('O24:O29').values=dimensions.map(x=>[x]);
 // Exact name plus attribute join remains valid if the source rows are sorted.
 for(let r=24;r<=29;r++){
  const found=`COUNTIFS($A$6:$A$277,$P$2,$C$6:$C$277,O${r})=1`;
  s.getRange(`P${r}`).formulas=[[`=IF(${found},SUMIFS($D$6:$D$277,$A$6:$A$277,$P$2,$C$6:$C$277,O${r}),NA())`]];
  s.getRange(`Q${r}`).formulas=[[`=IF(${found},SUMIFS($M$6:$M$277,$A$6:$A$277,$P$2,$C$6:$C$277,O${r}),NA())`]];
  s.getRange(`R${r}`).formulas=[[`=Q${r}-P${r}`]];
 }
 s.getRange('P24:R29').setNumberFormat('0.0');
 s.getRange('P24:R29').format.fill='#E3F3EE';
 s.getRange('P24:R29').format.horizontalAlignment='right';
 s.getRange('O30').values=[['原始属性值、自动刻度；不含装备、专长、体质和路线。']];
 s.getRange('O30').format.font.color='#607483';
 const chart=s.charts.add('radar',s.getRange('O23:Q29'));
 chart.title='六维成长对比';
 chart.titleTextStyle.typeface='Arial';chart.titleTextStyle.fontSize=14;
 chart.legend={position:'bottom',textStyle:{typeface:'Arial',fontSize:11}};
 chart.xAxis={axisType:'textAxis',textStyle:{typeface:'Arial',fontSize:12}};
 chart.yAxis={numberFormatCode:'0',numberFormatSourceLinked:false,textStyle:{typeface:'Arial',fontSize:10}};
 chart.setPosition('O5','W22');
 const colors=['#7F93A5','#086C70'];
 chart.series.items.forEach((series,i)=>{series.fill=colors[i];series.line={fill:colors[i],style:i===0?'dashed':'solid',width:2};});
 return {sheet:s,chart,names,dimensions};
}

// One chart per existing eight-row character block. No selector or row-height change.
export function addInlineGrowthRadars(wb, count=34){
 const s=wb.worksheets.getItem('属性成长');
 const end=5+count*8;
 s.charts.deleteAll();
 s.getRange(`O1:AA${end}`).clear({applyTo:'all'});
 s.getRange(`N1:N${end}`).format.columnWidth=s.getRange('N5').values[0][0]?16:3;
 s.getRange(`O1:R${end}`).format.columnWidth=13;
 s.getRange('O1:R5').format.font={name:'Arial',size:10,color:'#19364B'};
 s.getRange('O1').values=[['六维图']];
 s.getRange('O1').format.font={name:'Arial',size:14,bold:true,color:'#19364B'};
 s.getRange('O3').values=[['一级']];
 s.getRange('Q3').values=[['11级']];
 s.getRange('Q3').format.font.color='#086C70';
 s.getRange('O4').values=[['原值']];
 s.getRange('Q4').values=[['自动刻度']];
 s.getRange('O3').format.wrapText=false;
 s.getRange('O3').format.font.color='#607483';
 s.getRange('O5:R5').format.fill='#19364B';
 s.getRange('O5').values=[['每人一图']];
 s.getRange('O5').format.font={name:'Arial',size:10,bold:true,color:'#FFFFFF'};
 // Keep formula helpers to the far right, outside the visible chart column.
 s.getRange(`Y1:AA${end}`).format.font={name:'Arial',size:10,color:'#607483'};
 s.getRange(`Y1:AA${end}`).format.columnWidth=15;
 s.getRange('Y3').values=[['图表引用数据（自动计算）']];
 const offsets=[0,1,2,4,5,6],dimensions=['生命','疲劳上限','决心','近攻','远攻','近防'];
 const charts=[],blocks=[];
 for(let i=0;i<count;i++){
  const row=6+i*8,name=s.getRange(`A${row}`).values[0][0];
  assert.equal(new Set(s.getRange(`A${row}:A${row+7}`).values.flat()).size,1);
  s.getRange(`Y${row}:AA${row}`).values=[['属性','一级基础','11级均值']];
  for(let j=0;j<6;j++){
   const target=row+1+j,from=row+offsets[j];
   assert.equal(s.getRange(`C${from}`).values[0][0],dimensions[j]);
   s.getRange(`Y${target}:AA${target}`).formulas=[[`=C${from}`,`=D${from}`,`=M${from}`]];
  }
  s.getRange(`Z${row+1}:AA${row+6}`).setNumberFormat('0.0');
  const c=s.charts.add('radar',s.getRange(`Y${row}:AA${row+6}`));
  // Reserve room above the top axis label inside the compact chart.
  c.title='\u200b';
  c.titleTextStyle.fontSize=12;
  c.hasLegend=true;
  c.legend={position:'bottom',textStyle:{typeface:'Arial',fontSize:9}};
  c.xAxis={axisType:'textAxis',textStyle:{typeface:'Arial',fontSize:11}};
  c.yAxis={numberFormatCode:'0',numberFormatSourceLinked:false,textStyle:{typeface:'Arial',fontSize:9}};
  c.setPosition(`O${row}`,`R${row+7}`);
  c.series.items.forEach((series,j)=>{const color=['#7F93A5','#086C70'][j];series.fill=color;series.line={fill:color,style:j===0?'dashed':'solid',width:1.5};});
  charts.push(c);blocks.push({name,row,sourceRows:offsets.map(x=>row+x),dataStart:row+1,dataEnd:row+6});
 }
 return {sheet:s,charts,blocks,dimensions};
}

if(process.argv[1] && import.meta.url===pathToFileURL(path.resolve(process.argv[1])).href){
 const root=process.cwd(),cache=path.join(root,'.cache/balance-v2');
 const input=path.join(root,'docs/design/balance-v2/全人物数值与招募总表.xlsx');
 await fs.copyFile(input,path.join(cache,'inline-radar-before.xlsx'));
 const wb=await SpreadsheetFile.importXlsx(await FileBlob.load(input));
 const {sheet:s,charts,blocks,dimensions}=addInlineGrowthRadars(wb);
 wb.recalculate();
 assert.equal(charts.length,34);
 const source=s.getRange('A6:M277').values;
 for(const block of blocks){
  const result=s.getRange(`Z${block.dataStart}:AA${block.dataEnd}`).values;
  dimensions.forEach((dim,i)=>{
   const match=source.filter(x=>x[0]===block.name && x[2]===dim);assert.equal(match.length,1);
   assert.deepEqual(result[i],[match[0][3],match[0][12]]);
  });
 }
 const initial=s.getRange('D6').values[0][0];
 s.getRange('D6').values=[[initial+5]];wb.recalculate();
 assert.equal(s.getRange('Z7').values[0][0],initial+5);
 assert.equal(s.getRange('AA7').values[0][0],source[0][12]+5);
 s.getRange('D6').values=[[initial]];
 wb.recalculate();
 const scan=await wb.inspect({kind:'match',searchTerm:'#REF!|#DIV/0!|#VALUE!|#NAME\\?|#N/A|#NUM!|#NULL!|#SPILL!|#CALC!',options:{useRegex:true,maxResults:50},maxChars:2500});
 await fs.writeFile(path.join(cache,'inline-radar-error-scan.ndjson'),scan.ndjson);
 for(const [label,range] of [['top','K1:S30'],['middle','K126:S150'],['bottom','K254:S278']]){
  const preview=await wb.render({sheetName:'属性成长',range,scale:1,format:'png'});
  await fs.writeFile(path.join(cache,`inline-radar-${label}.png`),new Uint8Array(await preview.arrayBuffer()));
 }
 const output=await SpreadsheetFile.exportXlsx(wb);await output.save(path.join(cache,'inline-radar-candidate.xlsx'));
 await fs.writeFile(path.join(cache,'inline-radar-checks.json'),JSON.stringify({people_checked:blocks.length,attribute_values_checked:34*6*2,input_edit_check:true,blocks},null,2));
 console.log('34 inline radar charts exported; each spans exactly its character’s eight rows. 408 values checked.');
}
