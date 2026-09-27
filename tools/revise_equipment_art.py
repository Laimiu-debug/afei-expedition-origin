"""Apply the v0.7 equipment-compatible export settings; keep the old manifest archived."""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
p = ROOT / 'art/runtime/portraits-v05/manifest.json'
m = json.loads(p.read_text(encoding='utf-8'))
m['geometry']['fit'] = [88, 100]
m['geometry']['live'].update(top=-51, bottom=91)
m['status'] = 'equipment_overlay_revision_v07'
normal, toad, jiahao = m['characters'][0]['forms']
if toad.get('source_revision') != 'retired_alias':
    toad['retired_source'] = toad['source']
toad.update(source=normal['source'], source_sha256=normal['source_sha256'],
            source_revision='retired_alias', alias_of=normal['brush'],
            review_note='蛤蟆立绘已停用；旧画刷只作为正常阿飞外观的兼容别名，转职玩法保留。')
m['appearance_policy'] = {'fit': [88, 100], 'equipment': 'native_overlays',
                          'toad': 'normal_human', 'feidie_decoration': False}
p.write_text(json.dumps(m, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')

p = ROOT / 'src/scripts/scenarios/world/afeix_expedition_scenario.nut'
s = p.read_text(encoding='utf-8').replace('阿飞远征团：完整胸像试玩', '阿飞远征团')
start = s.index('        this.m.Description = ')
end = s.index('\n', start)
s = s[:start] + '        this.m.Description = "[p=c][img]gfx/ui/events/event_80.png[/img][/p][p]阿飞、王大谋、午夜抹抹茶带着一面黑旗上路。大谋扛住前阵，抹茶照应后排；眼下还不成气候的阿飞，要在一次次战斗中学会带人。[/p][p][color=#bcad8c]三人启程：[/color]完成委托，结识并招募各有本领的伙伴。[/p][p][color=#bcad8c]十人出战：[/color]从队伍中自由挑选阵容。世界地图按 F8 打开黑旗名册。[/p][p][color=#bcad8c]成长与羁绊：[/color]阿飞可选择蛤蟆人或嘉豪路线；六根支线还藏着另一条道路。[/p]";' + s[end:]
p.write_text(s, encoding='utf-8')

p = ROOT / 'tools/build_portrait_art.py'
s = p.read_text(encoding='utf-8').replace('"top": -55, "bottom": 87', '"top": -51, "bottom": 91')
s = s.replace('"fit": [108, 124]', '"fit": [88, 100]')
s = s.replace('min(108 / crop.width, 124 / crop.height)', 'min(88 / crop.width, 100 / crop.height)')
s = s.replace('min(108, round(crop.width * scale))', 'min(88, round(crop.width * scale))')
s = s.replace('min(124, round(crop.height * scale))', 'min(100, round(crop.height * scale))')
s = s.replace('内容最多 108×124', '内容最多 88×100')
a = s.index('def make_afei_review()')
b = s.index('\n\ndef make_review(', a)
s = s[:a] + '''def make_afei_review() -> dict:
    return {'toad_appearance': 'normal human alias', 'feidie_decoration': 'removed',
            'promotion_gameplay': 'unchanged', 'in_game_tested': False}
''' + s[b:]
s = s.replace('Complete-bust costume is fixed; equipment changes remain gameplay data, not baked image edits.',
              'Custom busts fit 88x100; native armor, helmets, weapon and shield sprites overlay the base.')
p.write_text(s, encoding='utf-8')

p = ROOT / 'tools/build_gameplay_art.py'
s = p.read_text(encoding='utf-8').replace('"jiahao_body_injured", "feidie",', '"jiahao_body_injured",')
s = s.replace('"Jiahao + disc"', '"Jiahao (legacy)"').replace('                if column == 3:\n                    draw_piece(frame, "afeix_g03_feidie")\n', '')
s = s.replace('"independent flying saucer", ', '').replace('"all v1 toad layers",', '"all v1 toad layers", "retired flying saucer",')
p.write_text(s, encoding='utf-8')

p = ROOT / 'tools/check_gameplay.py'
s = p.read_text(encoding='utf-8')
a = s.index("    if 'afeix_g03_feidie' not in layer_ids")
b = s.index("    icons = gameplay.get('icons'", a)
s = s[:a] + '''    if 'afeix_g03_feidie' in layer_ids or len(layer_records) != len(layer_ids):
        raise ValueError('Retired flying saucer must not enter the gameplay atlas')
    small = verify_custom_atlas(base, 'afeix_gameplay_v03', gameplay, layer_ids)
''' + s[b:]
s = s.replace("'independent_disc_verified': True", "'retired_disc_absent': True")
p.write_text(s, encoding='utf-8')

p = ROOT / 'src/scripts/!mods_preload/mod_afeix_expedition.nut'
s = p.read_text(encoding='utf-8').replace('Version = 6', 'Version = 7').replace('expedition", 6,', 'expedition", 7,').replace('阿飞远征团·右向胸像试玩','阿飞远征团')
p.write_text(s, encoding='utf-8')

p = ROOT / 'tools/render_portrait_prompts.py'
s = p.read_text(encoding='utf-8').replace('阿飞蛤蟆形态保留既有原创设计。', '蛤蟆立绘与头顶飞碟已于 v0.7 停用，转职玩法保留。')
s = s.replace("            if form.get('source_revision') == 'v05_facing':", "            if form.get('source_revision') == 'retired_alias':\n                lines += ['不再使用蛤蟆原图；复用上面的正常阿飞源图，旧画刷 ID 仅用于存档兼容。', '']\n                continue\n            if form.get('source_revision') == 'v05_facing':")
p.write_text(s, encoding='utf-8')
print('Applied v0.7 art policy, origin prose and export contracts.')
