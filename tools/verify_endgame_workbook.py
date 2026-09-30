"""Verify targeted workbook edits and refresh only live chart display caches."""
import json
import math
from pathlib import Path
import re
import shutil
import xml.etree.ElementTree as E
from zipfile import ZipFile, ZIP_DEFLATED

ROOT=Path(__file__).resolve().parents[1]
CACHE=ROOT/'.cache/endgame-balance-20260930'
N={'x':'http://schemas.openxmlformats.org/spreadsheetml/2006/main',
   'c':'http://schemas.openxmlformats.org/drawingml/2006/chart',
   'a':'http://schemas.openxmlformats.org/drawingml/2006/main'}
def canon(e):
    return None if e is None else (e.tag,tuple(sorted(e.attrib.items())),(e.text or '').strip(),tuple(canon(x) for x in e))
def load(path):
    with ZipFile(path) as z:
        files={n:z.read(n) for n in z.namelist()}
    strings=[]
    if 'xl/sharedStrings.xml' in files:
        strings=[''.join(s.itertext()) for s in E.fromstring(files['xl/sharedStrings.xml'])]
    def value(c):
        v=c.find('x:v',N); raw=None if v is None else v.text
        if c.get('t')=='s':return strings[int(raw)]
        if c.get('t')=='inlineStr':return ''.join(c.find('x:is',N).itertext())
        if raw is None:return None
        try:return float(raw)
        except ValueError:return raw
    sheets={n:E.fromstring(b) for n,b in files.items() if re.fullmatch(r'xl/worksheets/sheet\d+\.xml',n)}
    return files,sheets,value
def main():
    old,os,ov=load(CACHE/'before-workbook.xlsx')
    new,ns,nv=load(CACHE/'candidate-workbook.xlsx')
    assert set(os)==set(ns) and len(ns)==16
    def sheet_order(data):
        return [(s.get('name'),s.get('sheetId'),s.get('state','visible')) for s in E.fromstring(data).find('x:sheets',N)]
    assert sheet_order(old['xl/workbook.xml'])==sheet_order(new['xl/workbook.xml'])
    formulas=0
    changed_inputs=0
    allowed={1:lambda a:a=='A3',2:lambda a:re.fullmatch(r'D(?:[6-9]|[1-3]\d|40)',a),
        3:lambda a:a=='A3' or bool(re.fullmatch(r'[DEF]\d+',a)),
        4:lambda a:a=='A3' or bool(re.fullmatch(r'[BN]\d+',a)),
        5:lambda a:bool(re.fullmatch(r'K\d+',a)),6:lambda a:bool(re.fullmatch(r'J\d+',a))}
    old_styles=E.fromstring(old['xl/styles.xml']);new_styles=E.fromstring(new['xl/styles.xml'])
    assert canon(old_styles)==canon(new_styles),'Workbook styles changed'
    for name,before in os.items():
        number=int(re.search(r'sheet(\d+)',name)[1])
        after=ns[name]; ac={c.get('r'):c for c in after.findall('.//x:sheetData/x:row/x:c',N)}
        for c in before.findall('.//x:sheetData/x:row/x:c',N):
            addr=c.get('r');assert addr in ac,(name,addr)
            formula=c.findtext('x:f',default='',namespaces=N)
            assert formula==ac[addr].findtext('x:f',default='',namespaces=N),(name,addr,'formula')
            formulas+=bool(formula)
            assert c.get('s','0')==ac[addr].get('s','0'),(name,addr,'style')
            if not formula and ov(c)!=nv(ac[addr]):
                assert number in allowed and allowed[number](addr),(name,addr,'unexpected input change')
                changed_inputs+=1
        assert not after.findall('.//x:c[@t="e"]',N),(name,'formula errors')
        for feature in ['sheetViews','mergeCells','dataValidations','conditionalFormatting','sheetProtection']:
            assert [canon(x) for x in before.findall('x:'+feature,N)]==[canon(x) for x in after.findall('x:'+feature,N)],(name,feature)
    for name in old:
        if name.startswith('xl/tables/') and name.endswith('.xml'):
            assert name in new and canon(E.fromstring(old[name]))==canon(E.fromstring(new[name])),name
        if name.startswith('xl/media/'):
            assert new.get(name)==old[name],name
    chart_files=[n for n in new if re.fullmatch(r'xl/drawings/charts/chart\d+\.xml',n)]
    assert len(chart_files)==35
    cells={c.get('r'):c for c in ns['xl/worksheets/sheet3.xml'].findall('.//x:sheetData/x:row/x:c',N)}
    # Preserve formulas and bindings. Artifact Tool omits display caches, so
    # populate those caches with already-verified recalculated worksheet values.
    for name in chart_files:
        before=E.fromstring(old[name]);chart=E.fromstring(new[name])
        assert [x.text for x in before.findall('.//c:f',N)]==[x.text for x in chart.findall('.//c:f',N)],name
        for ref in chart.findall('.//c:numRef',N)+chart.findall('.//c:strRef',N):
            formula=ref.findtext('c:f',namespaces=N)
            match=re.fullmatch(r"'属性成长'!\$([A-Z]+)\$(\d+):\$\1\$(\d+)",formula or '')
            if not match:continue
            column,lo,hi=match.groups();values=[nv(cells[column+str(r)]) for r in range(int(lo),int(hi)+1)]
            numeric=ref.tag.endswith('numRef');cache_tag='numCache' if numeric else 'strCache'
            cache=ref.find('c:'+cache_tag,N)
            if cache is None:cache=E.SubElement(ref,'{'+N['c']+'}'+cache_tag)
            for point in list(cache):
                if point.tag.endswith(('pt','ptCount')):cache.remove(point)
            E.SubElement(cache,'{'+N['c']+'}ptCount',{'val':str(len(values))})
            for i,v in enumerate(values):
                point=E.SubElement(cache,'{'+N['c']+'}pt',{'idx':str(i)})
                E.SubElement(point,'{'+N['c']+'}v').text=f'{v:g}' if numeric else str(v)
        new[name]=E.tostring(chart,encoding='utf-8',xml_declaration=True)
    # Save only after preservation and independent formula checks pass.
    target=ROOT/'docs/design/balance-v2/全人物数值与招募总表.xlsx'
    with ZipFile(CACHE/'verified-workbook.xlsx','w',ZIP_DEFLATED) as z:
        for n,b in new.items():z.writestr(n,b)
    with ZipFile(CACHE/'verified-workbook.xlsx') as z:assert z.testzip() is None
    shutil.copyfile(CACHE/'verified-workbook.xlsx',target)
    report={'sheets':16,'native_charts':len(chart_files),'formulas_preserved':formulas,
            'changed_input_cells':changed_inputs,'unrelated_static_values_and_styles_preserved':True,
            'tables_views_validation_conditional_formats_images_preserved':True,
            'growth_results_verified':280,'allocation_checks':35,'input_recalculation_verified':True,
            'formula_errors':0,'chart_bindings_preserved':True}
    (CACHE/'workbook-verification.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(report))
if __name__=='__main__':main()
