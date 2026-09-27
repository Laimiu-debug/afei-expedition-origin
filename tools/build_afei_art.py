"""Mechanically export Afei's generated source art to Battle Brothers brushes.

No drawing, recolouring, warping, rotation, or automatic background removal is
performed here. Each source is cropped, uniformly downsampled, and placed on a
transparent canvas. The manifest owns all crop and anchor decisions.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile
import xml.etree.ElementTree as ET
import zipfile

from PIL import Image, ImageDraw, ImageFont


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_BASE = ROOT / "art/runtime/afei/v1"
CACHE = ROOT / ".cache/afei-art"
DEFAULT_BBRUSHER = CACHE / "bbros-modkit-v9/bin/bbrusher.exe"
if not DEFAULT_BBRUSHER.is_file():
    DEFAULT_BBRUSHER = Path("I:/afei-expedition/test-output/bbros-modkit-v9/bin/bbrusher.exe")
DEFAULT_NATIVE = CACHE / "vanilla-layer-audit"
if not DEFAULT_NATIVE.is_dir():
    DEFAULT_NATIVE = Path("I:/afei-expedition/test-output/vanilla-layer-audit")
COORDINATES = ("left", "right", "top", "bottom", "width", "height", "offsetX", "offsetY")
FLAGS = ("f", "f1", "f2", "b6", "b7", "rotSpeed", "ic")


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def relative_under(path: Path, root: Path) -> Path:
    resolved = path.resolve()
    resolved.relative_to(root.resolve())
    return resolved


def save_json(path: Path, value: object) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def read_manifest(base: Path) -> dict:
    data = json.loads((base / "manifest.json").read_text(encoding="utf-8-sig"))
    if data.get("schema_version") != 1 or not isinstance(data.get("sprites"), list):
        raise ValueError("manifest requires schema_version: 1 and a sprites array")
    if not re.fullmatch(r"[a-z][a-z0-9_]*", data.get("atlas_name", "")):
        raise ValueError("atlas_name must be a lower-case ASCII identifier")
    seen = set()
    if not data["sprites"]:
        raise ValueError("manifest contains no sprites")
    for entry in data["sprites"]:
        identity = entry["id"]
        if not re.fullmatch(r"afeix_v1_[a-z0-9_]+", identity) or identity in seen:
            raise ValueError(f"invalid or duplicate sprite identifier: {identity}")
        seen.add(identity)
        source = relative_under(base / entry["source"], base / "sources")
        if not source.is_file():
            raise FileNotFoundError(f"missing source: {source}")
        rect = entry["rect"]
        if any(not isinstance(rect[k], int) for k in ("left", "right", "top", "bottom")):
            raise ValueError(f"{identity}: coordinates must be integers")
        if rect["right"] <= rect["left"] or rect["bottom"] <= rect["top"]:
            raise ValueError(f"{identity}: empty coordinate rectangle")
    return data


def export_sprite(base: Path, entry: dict, pack_input: Path) -> tuple[dict, dict]:
    source_path = (base / entry["source"]).resolve()
    with Image.open(source_path) as original:
        if original.mode != "RGBA":
            raise ValueError(f"{entry['id']}: original must be RGBA, found {original.mode}")
        image = original.copy()
    original_size = list(image.size)
    if image.getchannel("A").getextrema()[0] != 0:
        raise ValueError(f"{entry['id']}: source has no transparent pixels")
    box = entry.get("source_box")
    if box:
        if len(box) != 4 or not (0 <= box[0] < box[2] <= image.width and 0 <= box[1] < box[3] <= image.height):
            raise ValueError(f"{entry['id']}: invalid source_box")
        image = image.crop(tuple(box))
    fit = entry.get("fit", {})
    threshold = int(fit.get("alpha_threshold", 1))
    if not 1 <= threshold <= 255:
        raise ValueError("alpha_threshold must be 1..255")
    crop_mode = fit.get("crop", "alpha")
    if crop_mode == "alpha":
        crop_box = image.getchannel("A").point(lambda a: 255 if a >= threshold else 0).getbbox()
        if crop_box is None:
            raise ValueError(f"{entry['id']}: no visible pixels")
        image = image.crop(crop_box)
    elif crop_mode == "none":
        crop_box = (0, 0, image.width, image.height)
    else:
        raise ValueError(f"{entry['id']}: unknown crop mode")
    rect = entry["rect"]
    target_size = (rect["right"] - rect["left"], rect["bottom"] - rect["top"])
    padding = fit.get("padding", 0)
    if isinstance(padding, int):
        pads = (padding,) * 4
    elif isinstance(padding, list) and len(padding) == 4:
        pads = tuple(padding)
    else:
        raise ValueError("padding must be integer or [left,top,right,bottom]")
    if any(not isinstance(x, int) or x < 0 for x in pads):
        raise ValueError("padding must be nonnegative integers")
    room = (target_size[0] - pads[0] - pads[2], target_size[1] - pads[1] - pads[3])
    if min(room) <= 0:
        raise ValueError(f"{entry['id']}: padding leaves no drawable area")
    scale = min(room[0] / image.width, room[1] / image.height)
    resized_size = (max(1, min(room[0], round(image.width * scale))), max(1, min(room[1], round(image.height * scale))))
    resized = image.resize(resized_size, Image.Resampling.LANCZOS)
    ax = fit.get("align_x", "center")
    ay = fit.get("align_y", "center")
    if ax not in ("left", "center", "right") or ay not in ("top", "center", "bottom"):
        raise ValueError(f"{entry['id']}: invalid alignment")
    px = pads[0] + {"left": 0, "center": (room[0] - resized.width) // 2, "right": room[0] - resized.width}[ax]
    py = pads[1] + {"top": 0, "center": (room[1] - resized.height) // 2, "bottom": room[1] - resized.height}[ay]
    canvas = Image.new("RGBA", target_size)
    canvas.alpha_composite(resized, (px, py))
    target = base / "sprites" / f"{entry['id']}.png"
    target.parent.mkdir(parents=True, exist_ok=True)
    canvas.save(target)
    pack_copy = pack_input / "sprites" / target.name
    pack_copy.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(target, pack_copy)
    attrs = {"id": entry["id"], "img": f"sprites\\{target.name}"}
    attrs.update({key: str(value) for key, value in rect.items() if key in COORDINATES})
    attrs.update({key: str(value) for key, value in entry.get("canvas", {"width": 104, "height": 142, "offsetY": 35}).items() if key in (*COORDINATES, *FLAGS)})
    attrs.update({key: str(value) for key, value in entry.get("flags", {}).items() if key in FLAGS})
    report = {
        "id": entry["id"], "source": entry["source"], "source_sha256": sha(source_path),
        "source_size": original_size, "source_box": box, "alpha_crop_box": list(crop_box),
        "alpha_threshold": threshold, "cropped_size": list(image.size), "uniform_scale": scale,
        "resized_size": list(resized_size), "placement": [px, py], "output_size": list(target_size),
        "output": str(target.relative_to(base)).replace("\\", "/"), "sha256": sha(target),
        "alpha_extrema": list(canvas.getchannel("A").getextrema()), "metadata": attrs,
        "overlay": bool(entry.get("overlay", False)),
    }
    return attrs, report


def run(command: list[str]) -> str:
    result = subprocess.run(command, capture_output=True, text=True, errors="replace")
    if result.returncode:
        raise RuntimeError(f"command failed ({result.returncode}): {command!r}\n{result.stdout}\n{result.stderr}")
    return result.stdout + result.stderr


def pack_and_verify(base: Path, atlas: str, pack_input: Path, attrs_list: list[dict], bbrusher: Path) -> dict:
    if not bbrusher.is_file():
        raise FileNotFoundError(f"bbrusher not found: {bbrusher}")
    package = base / "package"
    (package / "brushes").mkdir(parents=True, exist_ok=True)
    (package / "gfx").mkdir(parents=True, exist_ok=True)
    brush_path = package / "brushes" / f"{atlas}.brush"
    tree = ET.Element("brush", name=f"gfx/{atlas}.png", version="17")
    for attrs in attrs_list:
        ET.SubElement(tree, "sprite", attrs)
    ET.indent(tree, space="  ")
    ET.ElementTree(tree).write(pack_input / "metadata.xml", encoding="utf-8", xml_declaration=False)
    source_tree = ET.fromstring(ET.tostring(tree))
    for sprite in source_tree:
        sprite.set("img", sprite.get("img").replace("\\", "/").rsplit("/", 1)[-1])
    ET.ElementTree(source_tree).write(base / "sprites" / "metadata.xml", encoding="utf-8", xml_declaration=False)
    pack_log = run([str(bbrusher), "pack", "--gfxPath", str(package), str(brush_path), str(pack_input)])
    roundtrip = Path(tempfile.mkdtemp(prefix="roundtrip-", dir=base / "build"))
    unpack_log = run([str(bbrusher), "unpack", "--gfxPath", str(package), str(brush_path), str(roundtrip)])
    round_meta = ET.parse(roundtrip / "metadata.xml").getroot()
    actual = {entry.get("id"): entry.attrib for entry in round_meta}
    expected = {entry["id"]: entry for entry in attrs_list}
    if set(actual) != set(expected):
        raise ValueError(f"roundtrip sprite identifiers differ: {set(actual) ^ set(expected)}")
    checks = []
    for identity, attrs in expected.items():
        rt = actual[identity]
        before = Image.open(base / "sprites" / f"{identity}.png").convert("RGBA")
        after = Image.open(roundtrip / rt["img"].replace("\\", "/")).convert("RGBA")
        defaults = {"left": -after.width / 2, "right": after.width / 2,
                    "top": -after.height / 2, "bottom": after.height / 2,
                    "width": after.width, "height": after.height, "offsetX": 0, "offsetY": 0}
        for key in (*COORDINATES, *FLAGS):
            actual_value = rt.get(key, defaults.get(key, "0"))
            same = float(actual_value) == float(attrs[key]) if key in attrs and key in COORDINATES else actual_value == attrs.get(key)
            if key in attrs and not same:
                raise ValueError(f"{identity}: roundtrip {key} differs ({attrs[key]} vs {rt.get(key)})")
        if before.size != after.size or before.tobytes() != after.tobytes():
            raise ValueError(f"{identity}: roundtrip pixel mismatch")
        checks.append({"id": identity, "coordinates_identical": True, "pixels_identical": True})
    atlas_file = package / "gfx" / f"{atlas}.png"
    return {"passed": True, "sprite_count": len(checks), "sprites": checks,
            "brush": str(brush_path.relative_to(base)).replace("\\", "/"),
            "brush_sha256": sha(brush_path), "atlas": str(atlas_file.relative_to(base)).replace("\\", "/"),
            "atlas_sha256": sha(atlas_file), "pack_log": pack_log, "unpack_log": unpack_log,
            "roundtrip_directory": str(roundtrip.relative_to(base)).replace("\\", "/")}


def native_refs(native: Path, output: Path) -> dict:
    wanted = {"bust_head_01", "hair_black_02", "hair_black_02_dead", "bust_body_01", "bust_body_14", "bust_helmet_03", "bust_helmet_18", "icon_sword_01", "shield_round_00", "bust_head_injured_01", "bust_head_injured_02", "bust_body_01_damaged", "bust_head_01_dead", "bust_body_01_dead"}
    refs = {}
    for folder in ("entity_0", "entity_1", "entity_icons"):
        metadata = native / folder / "metadata.xml"
        if not metadata.exists():
            continue
        for entry in ET.parse(metadata).getroot():
            identity = entry.get("id")
            if identity not in wanted:
                continue
            source = native / folder / entry.get("img").replace("\\", "/")
            target = output / "native" / f"{identity}.png"
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(source, target)
            attrs = dict(entry.attrib)
            with Image.open(source) as image:
                frame_w, frame_h = image.size
            for key, default in {"left": -frame_w // 2, "right": frame_w // 2, "top": -frame_h // 2, "bottom": frame_h // 2}.items():
                attrs.setdefault(key, str(default))
            refs[identity] = {**attrs, "url": f"native/{identity}.png", "source": str(source), "sha256": sha(source)}
    save_json(output / "native-reference-sources.json", refs)
    return refs


def make_preview(base: Path, sprites: list[dict], native: Path) -> str:
    output = base / "build/preview"
    output.mkdir(parents=True, exist_ok=True)
    refs = native_refs(native, output)
    for item in sprites:
        refs[item["id"]] = {**item["metadata"], "url": "../../" + item["output"], "overlay": item["overlay"]}
    data = json.dumps(refs, ensure_ascii=False).replace("</", "<\\/")
    document = '''<!doctype html>
<html lang="zh-CN"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>阿飞 v1 游戏分层资源检查</title>
<style>
:root{color-scheme:dark;font:15px/1.55 system-ui,"Microsoft YaHei",sans-serif;background:#201e19;color:#ece3ce}body{max-width:1280px;margin:28px auto;padding:0 22px}h1{font-size:26px;margin:0 0 10px}p{color:#cabd9f}.toolbar{display:flex;flex-wrap:wrap;gap:18px;padding:16px;background:#302a23;border:1px solid #625440;border-radius:8px;margin:18px 0}label{white-space:nowrap}input{accent-color:#d9b677}.grid{display:grid;grid-template-columns:repeat(5,minmax(0,1fr));gap:14px}.card{background:#28241e;border:1px solid #564a39;padding:14px;border-radius:9px;text-align:center}.card h2{font-size:17px;margin:0 0 5px}.stage{position:relative;width:180px;height:190px;margin:0 auto;background:linear-gradient(45deg,#39372f 25%,transparent 25%,transparent 75%,#39372f 75%),linear-gradient(45deg,#39372f 25%,#444137 25%,#444137 75%,#39372f 75%);background-size:16px 16px;background-position:0 0,8px 8px;overflow:hidden}.stage img{position:absolute;max-width:none;image-rendering:auto}.stage.large{transform:scale(2);transform-origin:top center;margin-bottom:190px}.wrap-large{overflow:hidden}.caption{font-size:12px;color:#b4a68c}.divider{margin:26px 0 14px;border-top:1px solid #554a3b;padding-top:16px}code{font-size:12px;word-break:break-all}.warning{padding:12px;background:#423324;border-left:3px solid #c79a55}.light .stage{background:linear-gradient(45deg,#d5cdbd 25%,transparent 25%,transparent 75%,#d5cdbd 75%),linear-gradient(45deg,#d5cdbd 25%,#eee7da 25%,#eee7da 75%,#d5cdbd 75%);background-size:16px 16px;background-position:0 0,8px 8px}@media(max-width:1050px){.grid{grid-template-columns:repeat(3,1fr)}}@media(max-width:700px){.grid{grid-template-columns:repeat(2,1fr)}}
</style>
<h1>阿飞 · 游戏分层资源 v1</h1>
<p>实际导出尺寸与原版坐标摆放。正常、受伤与倒地状态分别检查；画面由独立 PNG 图层组成。此页用于美术与锚点检查，不代表已完成游戏实测。</p>
<div class="toolbar"><label><input id="armor" type="checkbox"> 原版皮甲</label><label><input id="helmet" type="checkbox"> 原版头盔</label><label><input id="weapons" type="checkbox" checked> 原版剑盾</label><label><input id="injury" type="checkbox"> 受伤状态</label><label><input id="light" type="checkbox"> 浅色棋盘</label></div>
<div id="grid" class="grid"></div>
<h2 class="divider">倒地资源与原版对照</h2><div id="dead" class="grid"></div>
<p class="warning">原版素材仅在本地预览中展示，未写入可分发 ZIP。飞碟为独立覆盖层；蛤蟆宽脸在全罩头盔下仍需实际游戏检查遮挡。受伤主体与普通主体共用坐标，但生成绘画可能有轮廓差异。</p>
<p>工程验收图：<a href="layer-review-1x.png">1× 原尺寸</a> · <a href="layer-review-2x.png">2× 像素观察</a>（非实机截图）</p>
<p>图层与打包检验：<a href="../report.json">report.json</a> · <a href="../../manifest.json">manifest.json</a></p>
<script>
const refs=__DATA__;
const forms=[{name:'原版对照',body:'bust_body_01',head:'bust_head_01',hair:'hair_black_02',deadHair:'hair_black_02_dead',deadBody:'bust_body_01_dead',deadHead:'bust_head_01_dead',injuryBody:'bust_body_01_damaged',injuryHead:'bust_head_injured_01'}, {name:'正常形态',body:'afeix_v1_normal_body',head:'afeix_v1_human_head',hair:'hair_black_02',deadHair:'hair_black_02_dead',deadBody:'afeix_v1_normal_body_dead',deadHead:'afeix_v1_human_head_dead',injuryBody:'afeix_v1_normal_body_injured',injuryHead:'bust_head_injured_01'}, {name:'蛤蟆人',body:'afeix_v1_toad_body',head:'afeix_v1_toad_head',deadBody:'afeix_v1_toad_body_dead',deadHead:'afeix_v1_toad_head_dead',injuryBody:'afeix_v1_toad_body_injured',injuryHead:'afeix_v1_toad_head_injured_01'}, {name:'嘉豪',body:'afeix_v1_jiahao_body',head:'afeix_v1_human_head',hair:'hair_black_02',deadHair:'hair_black_02_dead',deadBody:'afeix_v1_jiahao_body_dead',deadHead:'afeix_v1_human_head_dead',injuryBody:'afeix_v1_jiahao_body_injured',injuryHead:'bust_head_injured_01'}, {name:'飞碟',body:'afeix_v1_jiahao_body',head:'afeix_v1_human_head',hair:'hair_black_02',deadHair:'hair_black_02_dead',deadBody:'afeix_v1_jiahao_body_dead',deadHead:'afeix_v1_human_head_dead',injuryBody:'afeix_v1_jiahao_body_injured',injuryHead:'bust_head_injured_01',extra:'afeix_v1_feidie'}];
function add(stage,id){const ref=refs[id];if(!ref)return;const img=document.createElement('img');img.src=ref.url;img.alt=id;img.title=id;img.style.left=(88+Number(ref.left))+'px';img.style.top=(91-Number(ref.bottom))+'px';img.width=Number(ref.right)-Number(ref.left);img.height=Number(ref.bottom)-Number(ref.top);stage.append(img);}
function stage(form,corpse=false,large=false){const el=document.createElement('div');el.className='stage'+(large?' large':'');const wounded=document.getElementById('injury').checked;if(corpse){add(el,form.deadBody);add(el,form.deadHead);if(form.deadHair)add(el,form.deadHair);}else{if(wounded&&refs[form.injuryBody]&&!refs[form.injuryBody].overlay)add(el,form.injuryBody);else{add(el,form.body);if(wounded&&refs[form.injuryBody]?.overlay)add(el,form.injuryBody);}if(document.getElementById('armor').checked)add(el,'bust_body_14');add(el,form.head);if(form.hair&&!document.getElementById('helmet').checked)add(el,form.hair);if(wounded)add(el,form.injuryHead);if(document.getElementById('helmet').checked)add(el,'bust_helmet_03');if(document.getElementById('weapons').checked){add(el,'shield_round_00');add(el,'icon_sword_01');}if(form.extra)add(el,form.extra);}return el;}
function render(){document.body.classList.toggle('light',document.getElementById('light').checked);for(const [id,dead]of [['grid',false],['dead',true]]){const grid=document.getElementById(id);grid.replaceChildren();for(const form of forms){const card=document.createElement('article');card.className='card';const title=document.createElement('h2');title.textContent=form.name;card.append(title);card.append(stage(form,dead));if(!dead){const desc=document.createElement('p');desc.className='caption';desc.textContent='1× 实际素材尺寸';card.append(desc);const wrap=document.createElement('div');wrap.className='wrap-large';wrap.append(stage(form,false,true));card.append(wrap);const cap=document.createElement('p');cap.className='caption';cap.textContent='2× 细节检查';card.append(cap);}grid.append(card);}}}
document.querySelectorAll('input').forEach(input=>input.addEventListener('change',render));render();
</script></html>'''
    path = output / "index.html"
    path.write_text(document.replace("__DATA__", data), encoding="utf-8")
    return str(path.relative_to(base)).replace("\\", "/")


def make_zip(base: Path, atlas: str, expected_ids: set[str]) -> dict:
    package = base / "package"
    files = [package / "brushes" / f"{atlas}.brush", package / "gfx" / f"{atlas}.png"]
    scripts = package / "scripts"
    if scripts.is_dir():
        files += sorted(path for path in scripts.rglob("*") if path.is_file() and path.suffix in (".nut", ".cnut"))
    if not all(path.is_file() for path in files):
        raise FileNotFoundError("package lacks compiled brushes or atlas")
    code = "\n".join(path.read_text(encoding="utf-8-sig") for path in files if path.suffix == ".nut")
    referenced = set(re.findall(r'(?:setBrush|doesBrushExist)\(\s*"(afeix_v1_[a-z0-9_]+)"', code))
    # State flags, sprite-layer names and dynamic name prefixes share the same
    # namespace, so an unrestricted string search is not a brush-reference test.
    dynamic_contract = {f"afeix_v1_{form}_body{suffix}" for form in ("normal", "toad", "jiahao") for suffix in ("", "_dead", "_injured")}
    dynamic_contract.update(f"afeix_v1_{species}_head{suffix}" for species in ("human", "toad") for suffix in ("", "_dead"))
    dynamic_contract.update(("afeix_v1_feidie", "afeix_v1_toad_head_injured_01", "afeix_v1_toad_head_injured_02"))
    if code:
        referenced.update(dynamic_contract)
    unresolved = sorted(referenced - expected_ids)
    if unresolved:
        raise ValueError(f"package scripts reference missing sprites: {unresolved}")
    destination = base / "dist" / "mod_afeix_art_v1.zip"
    destination.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(destination, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
        for path in files:
            archive.write(path, str(path.relative_to(package)).replace("\\", "/"))
    with zipfile.ZipFile(destination) as archive:
        bad = archive.testzip()
        if bad:
            raise ValueError(f"ZIP CRC failed: {bad}")
        names = archive.namelist()
        if any(name.split("/")[0] not in ("brushes", "gfx", "scripts") for name in names):
            raise ValueError("unexpected package root")
    return {"path": str(destination.relative_to(base)).replace("\\", "/"), "sha256": sha(destination),
            "bytes": destination.stat().st_size, "entries": names, "crc_passed": True,
            "scripts_included": len([path for path in files if path.suffix in (".nut", ".cnut")]),
            "brush_interface_contract_resolved": sorted(referenced), "contains_native_game_art": False}


def make_engineering_review(base: Path, sprites: list[dict]) -> dict:
    """Render real sprite coordinates for QA; never modify any source artwork."""
    preview = base / "build/preview"
    refs = json.loads((preview / "native-reference-sources.json").read_text(encoding="utf-8"))
    for item in sprites:
        refs[item["id"]] = {**item["metadata"], "url": "../../" + item["output"], "overlay": item["overlay"]}
    font_file = Path("C:/Windows/Fonts/msyh.ttc")
    font = ImageFont.truetype(str(font_file), 16)
    small = ImageFont.truetype(str(font_file), 12)
    heading = ImageFont.truetype(str(font_file), 22)
    forms = [
        ("原版", "bust_body_01", "bust_head_01", "bust_body_01_dead", "bust_head_01_dead", "bust_body_01_damaged", "bust_head_injured_02", True, False),
        ("正常", "afeix_v1_normal_body", "afeix_v1_human_head", "afeix_v1_normal_body_dead", "afeix_v1_human_head_dead", "afeix_v1_normal_body_injured", "bust_head_injured_02", True, False),
        ("蛤蟆人", "afeix_v1_toad_body", "afeix_v1_toad_head", "afeix_v1_toad_body_dead", "afeix_v1_toad_head_dead", "afeix_v1_toad_body_injured", "afeix_v1_toad_head_injured_02", False, False),
        ("嘉豪", "afeix_v1_jiahao_body", "afeix_v1_human_head", "afeix_v1_jiahao_body_dead", "afeix_v1_human_head_dead", "afeix_v1_jiahao_body_injured", "bust_head_injured_02", True, False),
        ("飞碟", "afeix_v1_jiahao_body", "afeix_v1_human_head", "afeix_v1_jiahao_body_dead", "afeix_v1_human_head_dead", "afeix_v1_jiahao_body_injured", "bust_head_injured_02", True, True),
    ]
    rows = [("基础", "裸头 / 无外加甲"), ("开面盔 + 甲", "原版盔03 / 甲14 / 剑盾"), ("全罩盔", "原版盔18 / 甲14 / 剑盾"), ("重伤", "身体血污 + 头部伤层02"), ("尸体", "独立倒地身体 / 头 / 发")]
    clipping = []

    def render(form: tuple, row: int) -> Image.Image:
        tile = Image.new("RGBA", (140, 180), (48, 46, 40, 255))
        draw = ImageDraw.Draw(tile)
        for y in range(0, 180, 10):
            for x in range(0, 140, 10):
                if (x // 10 + y // 10) % 2:
                    draw.rectangle((x, y, x + 9, y + 9), fill=(56, 53, 46, 255))
        _, body, head, dead_body, dead_head, injury_body, injury_head, hair, saucer = form
        sequence = []
        if row == 4:
            sequence = [dead_body, dead_head]
            if hair:
                sequence.append("hair_black_02_dead")
        else:
            sequence.append(injury_body if row == 3 and not refs[injury_body].get("overlay") else body)
            if row == 3 and refs[injury_body].get("overlay"):
                sequence.append(injury_body)
            if row in (1, 2):
                sequence.append("bust_body_14")
            sequence.append(head)
            if hair and row not in (1, 2):
                sequence.append("hair_black_02")
            if row == 3:
                sequence.append(injury_head)
            if row in (1, 2):
                sequence += ["bust_helmet_03" if row == 1 else "bust_helmet_18", "shield_round_00", "icon_sword_01"]
            if saucer:
                sequence.append("afeix_v1_feidie")
        for identity in sequence:
            ref = refs[identity]
            path = (preview / ref["url"]).resolve()
            with Image.open(path) as image:
                layer = image.convert("RGBA")
            x, y = 70 + int(ref["left"]), 94 - int(ref["bottom"])
            if x < 0 or y < 0 or x + layer.width > tile.width or y + layer.height > tile.height:
                clipping.append({"form": form[0], "row": row, "sprite": identity})
            tile.alpha_composite(layer, (x, y))
        return tile

    outputs = []
    tiles = {(r, c): render(form, r) for r in range(5) for c, form in enumerate(forms)}
    for zoom in (1, 2):
        label_width, cell_width = 170, max(190, 140 * zoom + 16)
        row_height, top = 180 * zoom + 20, 112
        sheet = Image.new("RGB", (label_width + 5 * cell_width + 20, top + 5 * row_height + 42), (29, 27, 23))
        draw = ImageDraw.Draw(sheet)
        draw.text((20, 14), f"阿飞 v1 · {zoom}× 图层工程验收（非实机截图）", font=heading, fill=(235, 223, 196))
        draw.text((20, 48), "按真实 brush 的 left / bottom 坐标叠放；2× 使用最近邻，仅放大观察，不改变游戏素材。", font=small, fill=(179, 167, 143))
        for col, form in enumerate(forms):
            draw.text((label_width + col * cell_width + 12, 82), form[0], font=font, fill=(231, 220, 194))
        for row, (name, description) in enumerate(rows):
            y = top + row * row_height
            draw.text((16, y + 18), name, font=font, fill=(227, 213, 182))
            for index, piece in enumerate(description.split(" / ")):
                draw.text((16, y + 49 + index * 20), piece, font=small, fill=(163, 151, 128))
            for col in range(5):
                tile = tiles[row, col]
                if zoom == 2:
                    tile = tile.resize((280, 360), Image.Resampling.NEAREST)
                sheet.paste(tile.convert("RGB"), (label_width + col * cell_width + (cell_width - tile.width) // 2, y))
        draw.text((20, sheet.height - 28), "原版素材只用于本地检查，不进入发布 ZIP；未模拟游戏染色、光照、状态偏移与名册裁切。", font=small, fill=(179, 167, 143))
        path = preview / f"layer-review-{zoom}x.png"
        sheet.save(path)
        outputs.append({"path": str(path.relative_to(base)).replace("\\", "/"), "size": list(sheet.size), "sha256": sha(path)})
    return {"files": outputs, "in_game_screenshot": False, "clipped_layer_rectangles": clipping,
            "coordinates": "x=70+left; y=94-bottom; same baseline for every alive or dead layer"}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--base", type=Path, default=DEFAULT_BASE)
    parser.add_argument("--bbrusher", type=Path, default=DEFAULT_BBRUSHER)
    parser.add_argument("--native", type=Path, default=DEFAULT_NATIVE)
    parser.add_argument("--no-package", action="store_true", help="export, pack, verify, preview, but do not build distributable ZIP")
    args = parser.parse_args()
    base = args.base.resolve()
    relative_under(base, ROOT / "art/runtime/afei")
    data = read_manifest(base)
    build = base / "build"
    build.mkdir(parents=True, exist_ok=True)
    pack_input = Path(tempfile.mkdtemp(prefix="pack-input-", dir=build))
    attrs, exports = [], []
    for entry in data["sprites"]:
        meta, report = export_sprite(base, entry, pack_input)
        attrs.append(meta)
        exports.append(report)
    roundtrip = pack_and_verify(base, data["atlas_name"], pack_input, attrs, args.bbrusher)
    preview = make_preview(base, exports, args.native)
    engineering_review = make_engineering_review(base, exports)
    report = {"schema_version": 1, "manifest_sha256": sha(base / "manifest.json"),
              "method": "alpha crop, uniform Lanczos resize, transparent placement only",
              "sprites": exports, "roundtrip": roundtrip, "preview": preview, "engineering_review": engineering_review,
              "in_game_tested": False, "official_assets_distributable": False}
    if not args.no_package:
        report["package"] = make_zip(base, data["atlas_name"], {entry["id"] for entry in attrs})
    save_json(build / "report.json", report)
    print(json.dumps({"sprites": len(exports), "roundtrip_passed": True, "report": str(build / "report.json"), "preview": str(base / preview), "package": report.get("package", {}).get("path")}, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as error:
        print(f"Build failed: {error}", file=sys.stderr)
        raise SystemExit(1)
