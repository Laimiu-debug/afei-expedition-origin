"""Check all gfx/script references in src/ against game data + own files.

Catches two classes of runtime-only bugs that compilation cannot find:
  * icon paths pointing at pngs that don't exist (red X in game, log spam)
  * this.new("scripts/...") paths that don't exist (new-campaign aborts)
"""
from __future__ import annotations

import glob
import re
import sys
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "src"
GAME_CANDIDATES = [
    Path(r"E:\SteamLibrary\steamapps\common\Battle Brothers\data"),
    Path(r"C:\Program Files (x86)\Steam\steamapps\common\Battle Brothers\data"),
]


def collect_available() -> set[str] | None:
    for d in GAME_CANDIDATES:
        if not d.is_dir():
            continue
        avail: set[str] = set()
        for dat in sorted(d.glob("data_*.dat")):
            try:
                with zipfile.ZipFile(dat) as z:
                    avail.update(z.namelist())
            except (zipfile.BadZipFile, OSError):
                pass
        for zp in sorted(d.glob("*.zip")):
            try:
                with zipfile.ZipFile(zp) as z:
                    avail.update(z.namelist())
            except (zipfile.BadZipFile, OSError):
                pass
        return avail
    return None


def main() -> int:
    avail = collect_available()
    if avail is None:
        print("SKIP: 未找到游戏 data 目录（资源存在性无法核对）")
        return 0

    ours = {p.relative_to(SRC).as_posix() for p in SRC.rglob("*.nut")}
    png_refs: dict[str, str] = {}
    script_refs: dict[str, str] = {}
    for f in sorted(SRC.rglob("*.nut")):
        src = f.read_text(encoding="utf-8")
        rel = f.relative_to(SRC).as_posix()
        for m in re.findall(r'"([a-z0-9_/]+\.png)"', src):
            png_refs.setdefault(m, rel)
        for m in re.findall(r'"(scripts/[a-z0-9_/]+)"', src):
            if not m.endswith(("/", "_")):  # 拼接前缀不是完整路径
                script_refs.setdefault(m, rel)

    def png_exists(ref: str) -> bool:
        if (SRC / "gfx" / ref).exists():
            return True
        if (SRC / "gfx" / "ui" / "items" / ref).exists():
            return True
        return any(c in avail for c in ("gfx/" + ref, "gfx/ui/items/" + ref, "gfx/ui/" + ref))

    def script_exists(ref: str) -> bool:
        nut = ref + ".nut"
        return nut in ours or (SRC / nut).exists() or ref + ".cnut" in avail or nut in avail

    bad = [(r, f) for r, f in png_refs.items() if not png_exists(r)]
    bad += [(r, f) for r, f in script_refs.items() if not script_exists(r)]

    print(f"png 引用 {len(png_refs)} / 脚本引用 {len(script_refs)}")
    if bad:
        for ref, where in bad:
            print(f"MISSING {ref}  ({where})")
        print(f"REF_FAILURES={len(bad)}")
        return 1
    print("ALL_REFS_OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
