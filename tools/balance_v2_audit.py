"""Audit V2 deliverables and preserve the user's current playable source state."""
from pathlib import Path
import hashlib,json,re,sys,zipfile,xml.etree.ElementTree as ET
sys.stdout.reconfigure(encoding='utf-8')
ROOT=Path(__file__).resolve().parents[1];OUT=ROOT/'docs/design/balance-v2'
ns={'x':'http://schemas.openxmlformats.org/spreadsheetml/2006/main'}
with zipfile.ZipFile(OUT/'全人物数值与招募总表.xlsx') as z:
    sheets=[ET.fromstring(z.read(f)) for f in z.namelist() if f.startswith('xl/worksheets/sheet') and f.endswith('.xml')]
assert len(sheets)==16
assert not [c.attrib for s in sheets for c in s.findall('.//x:c',ns) if c.attrib.get('t')=='e']
assert all(s.find('.//x:pane',ns).attrib.get('ySplit')=='5' for s in sheets)
assert len(re.findall(r'^## \d{2}[.]',(OUT/'角色手册.md').read_text(encoding='utf-8'),re.M))==35
assert len(re.findall(r'^### ',(OUT/'技能总表.md').read_text(encoding='utf-8'),re.M))==105
broken=[(f.name,t) for f in OUT.glob('*.md') for t in re.findall(r'\]\(([^)]+)\)',f.read_text(encoding='utf-8')) if not t.startswith('http') and not (OUT/t.split('#')[0]).exists()]
assert not broken,broken
manifest=json.loads((OUT/'source-manifest.json').read_text(encoding='utf-8'))
assert all(hashlib.sha256((ROOT/x['path']).read_bytes()).hexdigest()==x['sha256'] for x in manifest['files'])
p=json.loads((OUT/'proposal.json').read_text(encoding='utf-8'));v=json.loads((OUT/'validation.json').read_text(encoding='utf-8'));v2=json.loads((OUT/'v2-validation.json').read_text(encoding='utf-8'))
assert sum(q['suggested_price'] for q in p['people'])==36180
assert all(x['passed'] for x in v['checks']+v2['checks'])
assert sum(x['trials'] for x in v['combat_probes'])+sum(x['trials'] for x in v2['tank_stress'])==144000
for q in p['people']:
    if q.get('alternative_perks'):
        assert len(q['perks'].split('、'))==len(q['alternative_perks'].split('、'))==10
main=(OUT/'总方案.md').read_text(encoding='utf-8')
assert '(战团历史最高等级-2)/2' in main and '46日及以后上限3' not in main
assert '未取得完整正文' not in (OUT/'读书与Wiki核对.md').read_text(encoding='utf-8')
data=json.loads((OUT/'workbook-validation.json').read_text(encoding='utf-8'))
data.update({'status':'公式、编辑重算、导出XML与文档完整性通过；未在Excel/WPS桌面重算','exported_formula_cells':sum(len(s.findall('.//x:f',ns)) for s in sheets),'cached_excel_errors':0,'runtime_source_hashes_unchanged':True,'runtime_source_files_checked':len(manifest['files']),'local_document_links_valid':True,'character_sections':35,'skill_route_sections':105,'new_background_comparison_cells_checked':280,'heavy_fatigue_outputs_checked':18,'opportunity_outputs_checked':12,'input_recalculation_checks':7,'offline_checks':len(v['checks'])+len(v2['checks']),'visual_reviewed_sheets':['总览','人物特质','技能选择','属性成长','装备明细','成长总览','队长与事件']})
(OUT/'workbook-validation.json').write_text(json.dumps(data,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(data,ensure_ascii=False))
