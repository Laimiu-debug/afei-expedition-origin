"""Verify targeted edit before replacing the current workbook."""
from pathlib import Path
from zipfile import ZipFile
import xml.etree.ElementTree as E
import json,math,shutil,sys,re
sys.stdout.reconfigure(encoding='utf-8')
ROOT=Path(__file__).resolve().parents[1];CACHE=ROOT/'.cache/balance-v2'
N={'x':'http://schemas.openxmlformats.org/spreadsheetml/2006/main','c':'http://schemas.openxmlformats.org/drawingml/2006/chart','a':'http://schemas.openxmlformats.org/drawingml/2006/main'}
def canon(e):
    if e is None:return None
    return (e.tag,tuple(sorted(e.attrib.items())),(e.text or '').strip(),tuple(canon(x)for x in e))
def read(file):
    with ZipFile(file) as z:
        strings=[]
        if 'xl/sharedStrings.xml' in z.namelist():strings=[''.join(s.itertext()) for s in E.fromstring(z.read('xl/sharedStrings.xml'))]
        sheets={f:E.fromstring(z.read(f)) for f in z.namelist() if f.startswith('xl/worksheets/sheet') and f.endswith('.xml')}
        tables={f:canon(E.fromstring(z.read(f))) for f in z.namelist() if f.startswith('xl/tables/') and f.endswith('.xml')}
        styles=E.fromstring(z.read('xl/styles.xml'))
        def value(c):
            val=c.find('x:v',N)
            raw=val.text if val is not None else None
            if c.get('t')=='s':raw=strings[int(raw)]
            elif c.get('t')=='inlineStr':raw=''.join(c.find('x:is',N).itertext())
            elif raw is not None and c.get('t') not in ('str','e','b'):
                try:raw=float(raw)
                except ValueError:pass
            return (c.findtext('x:f',default='',namespaces=N),raw)
        return {'sheets':sheets,'tables':tables,'styles':styles,'value':value,'chart_files':{f:z.read(f) for f in z.namelist() if '/charts/chart' in f and f.endswith('.xml')}}
before=read(CACHE/'inline-radar-before.xlsx');after=read(CACHE/'inline-radar-candidate.xlsx')
assert len(before['sheets'])==len(after['sheets'])==15
assert before['tables']==after['tables'],'Existing tables changed'
count=0
for name,old in before['sheets'].items():
    new=after['sheets'][name];nc={c.get('r'):c for c in new.findall('.//x:sheetData/x:row/x:c',N)}
    for c in old.findall('.//x:sheetData/x:row/x:c',N):
        addr=c.get('r')
        # The former selector panel to the right was explicitly replaced.
        if name.endswith('/sheet3.xml') and re.match(r'[A-Z]+',addr)[0] not in list('ABCDEFGHIJKLM'):continue
        assert addr in nc,(name,addr,'missing')
        a,b=before['value'](c),after['value'](nc[addr])
        assert a[0]==b[0],(name,addr,'formula',a,b)
        assert (math.isclose(a[1],b[1],abs_tol=1e-8) if isinstance(a[1],float)and isinstance(b[1],float) else a[1]==b[1]),(name,addr,'value',a,b)
        count+=1
    assert canon(old.find('x:sheetViews',N))==canon(new.find('x:sheetViews',N)),(name,'panes/view')
    for feature in ['conditionalFormatting','mergeCells']:
        assert [canon(e)for e in old.findall('x:'+feature,N)]==[canon(e)for e in new.findall('x:'+feature,N)],(name,feature)
    ov=old.findall('x:dataValidations/x:dataValidation',N);nv=new.findall('x:dataValidations/x:dataValidation',N)
    assert all(canon(x) in [canon(y) for y in nv] for x in ov if not (name.endswith('/sheet3.xml') and x.get('sqref')=='P2')),(name,'data validations')
    assert not new.findall('.//x:c[@t="e"]',N),(name,'cached formula error')
assert len(after['chart_files'])==34
# Artifact Tool writes the native radar and its live references, but this runtime
# leaves chart caches empty. Populate only display caches from already-calculated
# worksheet cells; retain every formula/reference so Excel keeps the chart live.
cells={c.get('r'):c for c in after['sheets']['xl/worksheets/sheet3.xml'].findall('.//x:sheetData/x:row/x:c',N)}
tag=lambda x:'{'+N['c']+'}'+x
patched_charts={};starts=set()
for chart_path,chart_bytes in after['chart_files'].items():
    chart=E.fromstring(chart_bytes)
    assert chart.find('.//c:radarChart',N) is not None
    series=chart.findall('.//c:radarChart/c:ser',N);assert len(series)==2
    ref=series[0].findtext('c:val/c:numRef/c:f',namespaces=N)
    start=int(re.search(r'\$Z\$(\d+)',ref)[1]);starts.add(start)
    for s,col,color in zip(series,['Z','AA'],['7F93A5','086C70']):
        assert s.findtext('c:val/c:numRef/c:f',namespaces=N)==f"'属性成长'!${col}${start}:${col}${start+5}"
        assert s.findtext('c:cat/c:strRef/c:f',namespaces=N)==f"'属性成长'!$Y${start}:$Y${start+5}"
        assert s.find('.//a:ln/a:solidFill/a:srgbClr',N).get('val')==color
        for kind,column in [('str','Y'),('num',col)]:
            cache=s.find(f'c:{"cat" if kind=="str" else "val"}/c:{kind}Ref/c:{kind}Cache',N)
            cache.find('c:ptCount',N).set('val','6')
            for oldpoint in cache.findall('c:pt',N):cache.remove(oldpoint)
            for i in range(6):
                val=after['value'](cells[f'{column}{start+i}'])[1]
                node=E.SubElement(cache,tag('pt'),{'idx':str(i)});E.SubElement(node,tag('v')).text=str(val)
        assert len(s.findall('c:val/c:numRef/c:numCache/c:pt',N))==6
    patched_charts[chart_path]=E.tostring(chart,encoding='utf-8',xml_declaration=True)
assert starts==set(range(7,272,8))
# clear(all) does not remove data validation in this runtime. Remove only the obsolete selector.
attribute_sheet=after['sheets']['xl/worksheets/sheet3.xml'];dv=attribute_sheet.find('x:dataValidations',N)
for d in list(dv):
    if d.get('sqref')=='P2':dv.remove(d)
dv.set('count',str(len(dv)))
assert not any(x.get('sqref')=='P2' for x in dv)
patched=CACHE/'inline-radar-verified.xlsx'
with ZipFile(CACHE/'inline-radar-candidate.xlsx') as zin,ZipFile(patched,'w') as zout:
    drawing=E.fromstring(zin.read('xl/drawings/drawing1.xml'))
    dn={'d':'http://schemas.openxmlformats.org/drawingml/2006/spreadsheetDrawing'}
    anchors=list(drawing);assert len(anchors)==34
    for i,anchor in enumerate(anchors):
        assert int(anchor.findtext('d:from/d:row',namespaces=dn))==5+8*i
        assert int(anchor.findtext('d:to/d:row',namespaces=dn))==13+8*i
        assert anchor.findtext('d:from/d:col',namespaces=dn)=='14'
        assert anchor.findtext('d:to/d:col',namespaces=dn)=='18'
    for item in zin.infolist():
        content=patched_charts.get(item.filename,zin.read(item.filename))
        if item.filename=='xl/worksheets/sheet3.xml':content=E.tostring(attribute_sheet,encoding='utf-8',xml_declaration=True)
        zout.writestr(item,content)
destination=ROOT/'docs/design/balance-v2/全人物数值与招募总表.xlsx'
shutil.copyfile(patched,destination)
report={'existing_cells_preserved':count,'sheets_preserved':15,'tables_preserved':15,'original_formulas_preserved':True,'original_attribute_validations_preserved':True,'obsolete_selector_removed':True,'radar_charts':34,'rows_per_chart':8,'series_per_chart':2,'points_per_series':6,'source_bindings_verified':True,'line_colors_verified':True,'chart_anchors_nonoverlapping':True,'engine':'artifact_tool重算及XLSX导出检查，未操作桌面Excel'}
(CACHE/'inline-radar-final-audit.json').write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(report,ensure_ascii=False))
