"""Final artifact audit: exported XLSX, links, roster completeness and source hashes."""
from pathlib import Path
import hashlib,json,re,sys,zipfile,xml.etree.ElementTree as ET
sys.stdout.reconfigure(encoding='utf-8')
ROOT=Path(__file__).resolve().parents[1];OUT=ROOT/'docs/design/balance-v1'
ns={'x':'http://schemas.openxmlformats.org/spreadsheetml/2006/main'}
with zipfile.ZipFile(OUT/'全人物数值与招募总表.xlsx') as z:
    sheets=[ET.fromstring(z.read(f)) for f in z.namelist() if f.startswith('xl/worksheets/sheet') and f.endswith('.xml')]
assert len(sheets)==11
errors=[c.attrib for s in sheets for c in s.findall('.//x:c',ns) if c.attrib.get('t')=='e']
assert not errors,errors
assert all(s.find('.//x:pane',ns).attrib.get('ySplit')=='5' for s in sheets)
assert len(re.findall(r'^## \d{2}[.]',(OUT/'角色手册.md').read_text(encoding='utf-8'),re.M))==34
assert len(re.findall(r'^### ',(OUT/'技能总表.md').read_text(encoding='utf-8'),re.M))==102
broken=[(f.name,t) for f in OUT.glob('*.md') for t in re.findall(r'\]\(([^)]+)\)',f.read_text(encoding='utf-8')) if not t.startswith('http') and not (OUT/t.split('#')[0]).exists()]
assert not broken,broken
manifest=json.loads((OUT/'source-manifest.json').read_text(encoding='utf-8'))
assert all(hashlib.sha256((ROOT/x['path']).read_bytes()).hexdigest()==x['sha256'] for x in manifest['files'])
data=json.loads((OUT/'workbook-validation.json').read_text(encoding='utf-8'))
data.update({'status':'公式、输入重算、导出XML及文档完整性检查通过','exported_formula_cells':sum(len(s.findall('.//x:f',ns)) for s in sheets),'cached_excel_errors':0,'runtime_source_hashes_unchanged':True,'local_document_links_valid':True,'character_sections':34,'skill_route_sections':102})
(OUT/'workbook-validation.json').write_text(json.dumps(data,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(data,ensure_ascii=False))
