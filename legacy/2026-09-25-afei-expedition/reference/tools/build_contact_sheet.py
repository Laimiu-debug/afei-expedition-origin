from pathlib import Path
import json

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
DOC = json.loads((ROOT / "data" / "document-v0.6.2.json").read_text(encoding="utf-8"))
IDS = [f"C{i:02d}" for i in range(1, 24)] + [f"C{i:02d}" for i in range(25, 32)]
FONT = ImageFont.truetype(r"C:\Windows\Fonts\msyh.ttc", 20)

sheet = Image.new("RGB", (5 * 220, 6 * 250), (31, 25, 20))
draw = ImageDraw.Draw(sheet)
for index, cid in enumerate(IDS):
    x, y = index % 5 * 220, index // 5 * 250
    portrait = Image.open(ROOT / f"src/gfx/ui/events/afei_{cid}.png").convert("RGB")
    sheet.paste(portrait, (x, y))
    draw.text((x + 8, y + 223), f"{cid} {DOC[cid]['name']}", font=FONT, fill=(238, 220, 178))

target = ROOT / "art" / "final-character-contact-sheet.jpg"
sheet.save(target, quality=94)
print(target)

tactical = Image.new("RGB", (5 * 208, 6 * 310), (31, 25, 20))
tdraw = ImageDraw.Draw(tactical)
for index, cid in enumerate(IDS):
    x, y = index % 5 * 208, index // 5 * 310
    sprite = Image.open(ROOT / f"art/tactical-sprites/icons/afei_head_{cid}.png").convert("RGBA")
    sprite = sprite.resize((208, 284), Image.Resampling.NEAREST)
    tactical.paste(sprite, (x, y), sprite)
    tdraw.text((x + 6, y + 286), f"{cid} {DOC[cid]['name']}", font=FONT, fill=(238, 220, 178))

tactical_target = ROOT / "art" / "final-tactical-contact-sheet.jpg"
tactical.save(tactical_target, quality=94)
print(tactical_target)
