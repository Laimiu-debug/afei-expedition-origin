"""Scale the reviewed C04-C06 painted masters into game-sized bust slots."""
from pathlib import Path

from PIL import Image


ROOT = Path(__file__).resolve().parents[1]
ART = ROOT / "art/tactical-sprites/battle-style-v6"


def main() -> None:
    for cid in ("C04", "C05", "C06"):
        source = Image.open(ART / f"{cid}-master.png").convert("RGBA")
        if source.getchannel("A").getextrema()[0] != 0:
            raise ValueError(f"{cid} must have a transparent background")
        visible = source.getchannel("A").point(lambda alpha: 255 if alpha >= 20 else 0)
        box = visible.getbbox()
        if box is None:
            raise ValueError(f"{cid} is empty")
        figure = source.crop(box)
        figure.thumbnail((108, 124), Image.Resampling.LANCZOS)
        canvas = Image.new("RGBA", (114, 142))
        canvas.alpha_composite(figure, ((114 - figure.width) // 2, 142 - figure.height))
        target = ART / f"afei_figure_{cid}.png"
        canvas.save(target)
        print(f"{cid}: {target.name}, figure {figure.size}")


if __name__ == "__main__":
    main()
