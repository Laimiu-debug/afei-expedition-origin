from pathlib import Path
import re,html,json
root=Path(__file__).resolve().parent
path=Path(r'C:/Users/25647/OneDrive/Documents/Battle Brothers/log.html')
b=path.read_text(encoding='utf-8')
rows=re.findall(r'<div class="row ([^"]+)"[^>]*>(.*?)(?=<div class="row |\Z)',b,re.S)
errors=[html.unescape(re.sub('<[^>]+>',' ',s)) for c,s in rows if c in ['error','critical'] or 'Script Error' in html.unescape(re.sub('<[^>]+>',' ',s))]
plain=html.unescape(re.sub('<[^>]+>',' ',b))
assert not errors,errors[:5]
assert '(mod_afeix_expedition) version 72' in plain
assert 'AFEIX_OVERLAY_TEST READY boss_hp=4800 scale=1' in plain
(root/'final-scene-log.html').write_text(b,encoding='utf-8')
print('Final scene: internal version 72, full-size boss, zero runtime errors')
