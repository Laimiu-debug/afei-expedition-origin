"""Select reviewed user-reference sources and per-person neck-layer landmarks."""
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / 'art/runtime/portraits-v05'
manifest_path = BASE / 'manifest.json'
m = json.loads(manifest_path.read_text(encoding='utf-8'))
calls = []
for filename in ('PROMPTS-user-v12.json', 'PROMPTS-meiya-v12.json'):
    for record in json.loads((BASE / filename).read_text(encoding='utf-8'))['records']:
        calls.append(dict(record, prompt_record=filename))
selected = {r['key']: r for r in calls}
# Shoulder-side and lower neck/collar coordinates in the 114x142 canvas.
# Reviewed against landmark-review.png; source pixels are never repainted.
profiles = {
    'afei': (107, 119), 'damou': (109, 121), 'mocha': (109, 122),
    'bottle': (107, 119), 'shuaizi': (107, 119), 'lili': (109, 123),
    'xiaoyueya': (108, 122), 'yuchujiu': (108, 120), 'xiaoyubeike': (109, 122),
    'wangduidui': (107, 123), 'laocai': (109, 120), 'tiantong': (110, 123),
    'xiaoning': (107, 120), 'xiaopangxu': (108, 122), 'dae': (108, 121),
    'manyuemei': (108, 120), 'xiaohani': (110, 122), 'keke': (109, 121),
    'yuxiang': (107, 120), 'tongzhu': (108, 121), 'meiya': (108, 122),
    'wanshe': (108, 122), 'tutu': (109, 122), 'songnuanyang': (109, 121),
    'xiaogui': (108, 123), 'naigai': (110, 123), 'xiaojie': (110, 123),
    'bula': (109, 122), 'suwa': (107, 120), 'qianhan': (109, 121),
    'wangdazhi': (107, 121), 'yaoyaoya': (107, 118), 'yangmiemie': (108, 121),
    'chenzhihan': (109, 122)
}
notes = {
    'xiaoyueya': '按用户照片重绘黑色长发、清秀椭圆脸与自然眉眼，替换旧蓝发造型；朝右，完整颈部。',
    'xiaogui': '按用户海报的大龟形象重绘圆脸、浅橄榄绿皮肤和头顶斑纹；去除老爬虫凶相，去除海报及球队元素。',
    'tiantong': '按用户照片中央人物重绘浅棕短波波头、圆润脸颊和眼睛；移除旧眼镜与深色长发。',
    'yaoyaoya': '按用户提供形象重绘黑长发、女性面部和健壮肩颈；短胸像保留力量感，移除旧红色马尾及武器。',
    'meiya': '按用户照片重绘长黑发、上挑眉、大眼睛与饱满唇形；不把帽子画入基础层，保留完整下巴和颈部。'
}
for p in m['characters']:
    key = p['key']
    s, c = profiles[key]
    for v in p['forms']:
        if key in selected:
            r = selected[key]
            v.setdefault('before_user_v12_source', v['source'])
            v.update(source=r['selected_source'], source_kind='generated_custom',
                     source_sha256=hashlib.sha256((ROOT / r['selected_source']).read_bytes()).hexdigest(),
                     source_box=None, approved_for_export=True, source_revision='user_v12',
                     prompt_record=r['prompt_record'], review_note=notes[key])
            p['likeness_status'] = 'user_supplied_mascot' if key == 'xiaogui' else 'user_supplied_reference'
        v['head_seam'] = [[0, s], [35, s], [48, s+5], [57, c], [73, c], [85, s+5], [95, s], [114, s]]
        v['neck_guard'] = [68, 110]
        v['neck_review'] = 'v0.12：分界下移至完整下巴以下，中央颈部延伸至衣领；保持原图像素和原版装备叠加。'
m.update(updated='2026-09-27', status='user_reference_and_neck_contours_v12')
m['appearance_policy']['head_partition'] = 'per_portrait_neck_contour'
manifest_path.write_text(json.dumps(m, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
print('Selected five user-reference portraits and 36 neck contours.')
