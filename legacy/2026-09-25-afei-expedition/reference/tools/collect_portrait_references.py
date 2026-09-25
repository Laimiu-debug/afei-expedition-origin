"""Collect public Bilibili cover frames cited by the design document."""
from __future__ import annotations

import json
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "art" / "references" / "bilibili"

SOURCES = {
    "S06_C04_C09": "BV1cWU4BaECW",
    "S13_C18": "BV1aMes6CEzW",
    "S14_C14": "BV1fGeG6HEKc",
    "S19_C11_C12": "BV1cJoyBqE67",
    "S20_C13": "BV1und5BhEsB",
    "S21_C16": "BV1Mde16wEkt",
    "S22_C15_C17": "BV1454R6iEVa",
    "S25_C19": "BV1ThtN6vEa7",
    "S27_C19": "BV1Wwt86hEhD",
    "S35_C28": "BV1nKeg6UE7V",
    "S36_C25": "BV1HBY16SEAV",
    "S37_C26": "BV1tcbM61EyS",
    "S38_C27": "BV1w1b36VEW6",
    "S39_C20": "BV1Qntq6hEwL",
    "S40_C20": "BV16ath6fEzW",
    "S41_C21_C22": "BV1wcud6pE9h",
    "S42_C23": "BV1tQ4R6gELW",
    "S44_C29": "BV1s5tm6jEsZ",
    "S45_C30": "BV15itB6gEpY",
    "S49_C31": "BV1AobM6ME4c",
    "S59_C21": "BV1hobT6EEzP",
    "S60_C22": "BV1fJ8Z6zEQh",
}


def fetch(url: str) -> bytes:
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0", "Referer": "https://www.bilibili.com/"})
    with urllib.request.urlopen(req, timeout=30) as response:
        return response.read()


def main() -> int:
    OUT.mkdir(parents=True, exist_ok=True)
    manifest = {}
    for label, bvid in SOURCES.items():
        meta = json.loads(fetch(f"https://api.bilibili.com/x/web-interface/view?bvid={bvid}"))["data"]
        suffix = Path(meta["pic"].split("?")[0]).suffix or ".jpg"
        target = OUT / f"{label}_{bvid}{suffix}"
        target.write_bytes(fetch(meta["pic"]))
        manifest[label] = {"bvid": bvid, "title": meta["title"], "page": f"https://www.bilibili.com/video/{bvid}/", "image": target.name}
        print(label, meta["title"])
    (OUT / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
