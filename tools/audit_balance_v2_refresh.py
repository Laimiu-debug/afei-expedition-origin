"""Audit saved V2 workbook and fill native chart display caches omitted by exporter.

All cells, formulas, images and charts are authored with Artifact Tool. The only
XML repair supplies display caches for that runtime's unsupported export feature;
live chart references remain unchanged, following the existing radar audit.
"""
from pathlib import Path
from zipfile import ZipFile
import hashlib
import json
import math
import posixpath
import re
import shutil
import sys
import xml.etree.ElementTree as E

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'docs/design/balance-v2'
CACHE=ROOT/'.cache/refresh-v2'
NS={'x':'http://schemas.openxmlformats.org/spreadsheetml/2006/main','d':'http://schemas.openxmlformats.org/drawingml/2006/spreadsheetDrawing','a':'http://schemas.openxmlformats.org/drawingml/2006/main','c':'http://schemas.openxmlformats.org/drawingml/2006/chart','r':'http://schemas.openxmlformats.org/officeDocument/2006/relationships'}


def values(z,sheet):
    strings=[''.join(e.itertext()) for e in E.fromstring(z.read('xl/sharedStrings.xml'))]
    data={}
    for c in E.fromstring(z.read(f'xl/worksheets/sheet{sheet}.xml')).findall('.//x:sheetData/x:row/x:c',NS):
        raw=c.findtext('x:v',namespaces=NS)
        if c.get('t')=='s': raw=strings[int(raw)]
        elif c.get('t')=='inlineStr': raw=''.join(c.find('x:is',NS).itertext())
        elif raw is not None and c.get('t') not in ('str','e','b'): raw=float(raw)
        data[c.get('r')]=(c.findtext('x:f',default='',namespaces=NS),raw)
    return data


def main():
    filename=OUT/'全人物数值与招募总表.xlsx'
    manifest=json.loads((OUT/'skill-icon-manifest.json').read_text(encoding='utf-8'))
    proposals=json.loads((OUT/'proposal.json').read_text(encoding='utf-8'))
    checks=json.loads((CACHE/'embedded-icons.json').read_text(encoding='utf-8'))
    by_key={r['key']:r for r in manifest['icons']}
    traits=json.loads((OUT/'trait-design.json').read_text(encoding='utf-8'))
    by_key.update({d['id']:{'sha256':d['icon_sha256']} for d in traits['definitions'].values()})
    fixed={}
    with ZipFile(filename) as z,ZipFile(CACHE/'before-v21.xlsx') as old:
        sheets=[n for n in z.namelist() if re.fullmatch(r'xl/worksheets/sheet\d+.xml',n)]
        assert len(sheets)==16
        assert all(not E.fromstring(z.read(n)).findall('.//x:c[@t="e"]',NS) for n in sheets)
        preserved=0
        # All original editable inputs, calculations and proposal definitions.
        for sid,last_row,last_col in [(2,39,'Q'),(3,277,'L'),(4,39,'N'),(5,39,'K'),(6,104,'K'),(9,30,'C'),(12,11,'K')]:
            a,b=values(old,sid),values(z,sid)
            for cell,left in a.items():
                m=re.fullmatch(r'([A-Z]+)(\d+)',cell)
                if not (6<=int(m[2])<=last_row and len(m[1])==1 and m[1]<=last_col):continue
                if sid==4 and cell=='D6':continue # approved +30 captain stamina
                right=b[cell];assert left[0]==right[0],(sid,cell,'formula')
                assert math.isclose(left[1],right[1],abs_tol=1e-8) if isinstance(left[1],float) and isinstance(right[1],float) else left[1]==right[1],(sid,cell,'value')
                preserved+=1
        skill_cells=values(z,6)
        pictures=0
        for number,sheet_name in [(2,'技能选择'),(3,'队长与事件'),(4,'人物特质')]:
            name=f'xl/drawings/drawing{number}.xml'
            rels={r.get('Id'):posixpath.normpath(posixpath.join('xl/drawings',r.get('Target'))).lstrip('/') for r in E.fromstring(z.read(f'xl/drawings/_rels/drawing{number}.xml.rels'))}
            anchors=E.fromstring(z.read(name))
            for anchor in anchors:
                row=int(anchor.findtext('d:from/d:row',namespaces=NS))+1
                column=int(anchor.findtext('d:from/d:col',namespaces=NS))
                expected=next(c for c in checks if c['sheet']==sheet_name and c['row']==row and c['col']==column)
                blob=anchor.find('.//a:blip',NS).get('{'+NS['r']+'}embed')
                assert hashlib.sha256(z.read(rels[blob])).hexdigest()==expected['sha256']==by_key[expected['key']]['sha256']
                assert int(anchor.find('d:ext',NS).get('cx'))==56*9525
                assert int(anchor.find('d:ext',NS).get('cy'))==56*9525
                assert column in ({2,3} if number==4 else {1 if number==2 else 0})
                if number==2:assert skill_cells[f'M{row}'][1]==expected['key']
                pictures+=1
        assert pictures==177
        cells=values(z,3)
        charts=[n for n in z.namelist() if re.fullmatch(r'xl/(?:drawings/)?charts/chart\d+.xml',n)]
        assert len(charts)==35
        starts=set()
        for file in charts:
            chart=E.fromstring(z.read(file));series=chart.findall('.//c:radarChart/c:ser',NS);assert len(series)==2
            for s,column,color in zip(series,['Z','AA'],['7F93A5','086C70']):
                ref=s.findtext('c:val/c:numRef/c:f',namespaces=NS)
                start=int(re.search(r'\$(\d+):',ref)[1]);starts.add(start)
                assert ref==f"'属性成长'!${column}${start}:${column}${start+5}"
                assert s.findtext('c:cat/c:strRef/c:f',namespaces=NS)==f"'属性成长'!$Y${start}:$Y${start+5}"
                assert s.find('.//a:ln/a:solidFill/a:srgbClr',NS).get('val')==color
                for kind,c in [('str','Y'),('num',column)]:
                    element=s.find(f'c:{"cat" if kind=="str" else "val"}/c:{kind}Ref/c:{kind}Cache',NS)
                    element.find('c:ptCount',NS).set('val','6')
                    for point in element.findall('c:pt',NS):element.remove(point)
                    for j in range(6):
                        point=E.SubElement(element,'{'+NS['c']+'}pt',{'idx':str(j)})
                        E.SubElement(point,'{'+NS['c']+'}v').text=str(cells[f'{c}{start+j}'][1])
            fixed[file]=E.tostring(chart,encoding='utf-8',xml_declaration=True)
        assert starts==set(range(7,280,8))
        anchors=list(E.fromstring(z.read('xl/drawings/drawing1.xml')))
        assert len(anchors)==35
        for i,anchor in enumerate(anchors):
            assert int(anchor.findtext('d:from/d:row',namespaces=NS))==5+8*i
            assert int(anchor.findtext('d:to/d:row',namespaces=NS))==13+8*i
        assert values(z,2)['P40'][1]==470 and values(z,1)['B6'][1]==35
        assert values(z,4)['D6'][1]==124 and values(z,4)['K40'][1]==30
        assert values(z,3)['D280'][1]==21 and values(z,3)['M280'][1]==24
        assert values(z,5)['M40'][1]==20 and values(z,5)['N40'][1]==41
        assert values(z,4)['E40'][1]==24 and values(z,4)['P40'][1]==44
        trait_cells=values(z,16)
        for i,q in enumerate(proposals['people']):
            r=i+6
            assert trait_cells[f'B{r}'][1]==q['key']
            assert [trait_cells[f'{c}{r}'][1] for c in ['U','V','W','X','Y','Z','AA','AB']]==q['runtime_base_before_traits']
        assert values(z,13)['H6'][1]==39 and values(z,13)['K6'][1]==57
        with ZipFile(CACHE/'verified.xlsx','w') as dest:
            for item in z.infolist():dest.writestr(item,fixed.get(item.filename,z.read(item.filename)))
    shutil.copyfile(CACHE/'verified.xlsx',filename)
    report=json.loads((OUT/'refresh-validation.json').read_text(encoding='utf-8'))
    report.update({'original_cells_verified':preserved,'embedded_image_bytes_and_rows_verified':177,'cached_formula_errors':0,'chart_cached_points':420,'chart_anchors_verified':35,'trait_base_reconciliation_checks':280,'afei_heavy_fatigue_without_brawny':39,'afei_heavy_fatigue_with_brawny':57,'desktop_excel_verification':'not repeated; previous COM server startup unavailable (80080005)','visual_verification':'Artifact Tool layout reviewed; its preview omits bitmap drawings. Saved XLSX image bytes, rows, sizes and chart bindings independently verified.'})
    (OUT/'refresh-validation.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(report,ensure_ascii=False))


if __name__=='__main__':
    sys.stdout.reconfigure(encoding='utf-8');main()
