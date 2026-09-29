"""Record the visually reviewed Naigai source without changing other selections."""
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
BASE = ROOT / 'art/runtime/portraits-v05'
OUT = Path(__file__).resolve().parent

def read(p):
    return json.loads(p.read_text(encoding='utf-8'))

def write(p, value):
    p.write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()

manifest = read(BASE / 'manifest.json')
before = read(OUT / 'manifest-before.json')
person = next(p for p in manifest['characters'] if p['key'] == 'naigai')
old = next(p for p in before['characters'] if p['key'] == 'naigai')
assert person == old, 'Naigai changed since snapshot; review the concurrent change before selecting'
write(OUT / 'sprite-hashes-before.json', {p.name: sha(p) for p in (BASE / 'sprites').glob('*.png')})
entry = person['forms'][0]
entry.update(
    before_user_v18_source=entry['source'],
    source='art/runtime/portraits-v05/sources/user-v18/naigai.png',
    source_kind='generated_custom',
    approved_for_export=True,
    source_revision='user_v18',
    source_box=None,
    prompt_record='PROMPTS-naigai-v18.json',
    review_note='按四张用户照片校正奶盖的齐下巴黑色短发、柔和脸型与眉眼唇形；保留棕色短披肩。透明朝右胸像，已检查原尺寸及原版装备叠加，未实机验收。',
    neck_review='沿用逐人颈部折线；本轮已在新图原尺寸检查完整下颌、短颈与护甲衔接。头身合成逐像素还原完整图。',
)
entry['source_sha256'] = sha(ROOT / entry['source'])
person['likeness_status'] = 'user_provided_photo_reference'
write(BASE / 'manifest.json', manifest)
prompt_path = BASE / 'PROMPTS-naigai-v18.json'
record = read(prompt_path)
record['status'] = 'selected_after_offline_visual_review'
record['records'][0]['source_sha256'] = entry['source_sha256']
record['records'][0]['review'] = {
    'comparison': 'build/playtest-naigai/comparison.png',
    'transparent_rgba': True,
    'source_pixels_edited_after_generation': False,
    'game_size_reviewed': True,
    'game_canvas': [114, 142],
    'visible_size': read(OUT / 'export.json')['resized_size'],
    'user_photos': 4,
    'short_black_bob_reviewed': True,
    'equipment_reviewed': ['armor', 'open_helmet', 'closed_helmet'],
    'equipment_limitations': ['Native helmets cover the crown; short black hair remains visible at the sides.'],
    'in_game_tested': False,
}
write(prompt_path, record)
print('Selected only naigai; original source and prior sprite snapshots retained.')
