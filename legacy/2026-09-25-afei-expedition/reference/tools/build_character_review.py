"""Render one character's event portrait and tactical bust for visual review."""
import argparse
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser()
parser.add_argument("id")
args = parser.parse_args()
cid = args.id.upper()

event = Image.open(ROOT / f"src/gfx/ui/events/afei_{cid}.png").convert("RGBA")
sprite = Image.open(ROOT / f"art/tactical-sprites/icons/afei_head_{cid}.png").convert("RGBA")
canvas = Image.new("RGBA", (820, 510), (34, 28, 23, 255))
canvas.alpha_composite(event.resize((440, 440), Image.Resampling.NEAREST), (16, 48))
sprite_large = sprite.resize((312, 426), Image.Resampling.NEAREST)
canvas.alpha_composite(sprite_large, (486, 62))
draw = ImageDraw.Draw(canvas)
font = ImageFont.truetype(r"C:\Windows\Fonts\msyh.ttc", 25)
draw.text((16, 10), f"{cid} 事件立绘", font=font, fill=(235, 217, 179))
draw.text((486, 10), "战斗小人", font=font, fill=(235, 217, 179))
out = ROOT / "art" / "reviews" / f"{cid}.png"
out.parent.mkdir(parents=True, exist_ok=True)
canvas.save(out)
print(out)
