"""Render the shipped canvas code over a historical, frozen battle reference.

This is a Canvas preview, not a game recording or an acceptance of native
deaths/UI callbacks. No native game code or edited screenshot enters src.
"""
from pathlib import Path
import argparse
import hashlib
import json
import subprocess

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "build/dream-tide-preview.13"
SOURCE = ROOT / "src/ui/mods/afeix/dream_tide.js"
BACKGROUND = ROOT / "build/douyu-playtest/native-barrage-warning.png"


def create_preview():
    OUT.mkdir(parents=True, exist_ok=True)
    html = """<!doctype html><html lang="zh-CN"><meta charset="utf-8">
<title>黑潮演出预览</title><style>
html,body{margin:0;width:100%;height:100%;overflow:hidden;background:#000}
.scene{width:100%;height:100%;object-fit:cover;position:fixed}
.note{position:fixed;z-index:10;left:20px;top:18px;padding:12px 18px;background:#111cde;color:#ece6cf;border:1px solid #778077;font:15px/1.6 sans-serif}
.controls{position:fixed;z-index:10;right:24px;bottom:22px;background:#111cde;color:#ece6cf;padding:10px 16px;font:14px sans-serif}
button{background:#394844;border:1px solid #87988b;color:#f7f0dc;padding:8px 14px;cursor:pointer}input{width:240px;vertical-align:middle;margin:0 14px}
</style><img class="scene" src="battle-reference.png">
<div class="note">黑潮横扫预览 · 静止战场参考，非实机录像<br>游戏默认从右向左横扫；扫过后队员倒下，再淡黑梦醒。</div>
<div class="controls"><select id="direction"><option value="right-to-left">右 → 左</option><option value="left-to-right">左 → 右</option></select><button id="replay">重播</button><input id="time" type="range" min="0" max="4.6" step="0.01" value="0"><span id="label">0.00 / 4.60 秒</span></div>
<script>function TacticalScreen(){this.mSQHandle={};}TacticalScreen.prototype.onDisconnection=function(){};TacticalScreen.prototype.destroyDIV=function(){};</script>
<script>__PRODUCTION__</script><script>
var screen=new TacticalScreen(),token=0,animation=0,slider=document.getElementById('time');
function start(){screen.afeixStartDreamTide({Token:++token,SweepSeconds:2.4,Direction:document.getElementById('direction').value,FadeAt:3.4,Duration:4.6});}
function frame(time){screen.afeixDreamTideFrame({Token:token,Elapsed:time});slider.value=time;document.getElementById('label').textContent=time.toFixed(2)+' / 4.60 秒';}
function replay(){cancelAnimationFrame(animation);start();var begun=performance.now();function tick(now){var time=Math.min(4.6,(now-begun)/1000);frame(time);if(time<4.6)animation=requestAnimationFrame(tick);}animation=requestAnimationFrame(tick);}
document.getElementById('replay').onclick=replay;slider.oninput=function(){cancelAnimationFrame(animation);start();frame(Number(slider.value));};
document.getElementById('direction').onchange=replay;
var query=new URLSearchParams(location.search);document.querySelector('.scene').onload=function(){if(query.has('t')){start();frame(Number(query.get('t')));}else replay();};
if(document.querySelector('.scene').complete)document.querySelector('.scene').onload();
</script></html>"""
    target = OUT / "preview.html"
    target.write_text(html.replace("__PRODUCTION__", SOURCE.read_text(encoding="utf-8")), encoding="utf-8")
    import shutil
    shutil.copyfile(BACKGROUND, OUT / "battle-reference.png")
    return target


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--html-only", action="store_true")
    parser.add_argument("--canvas-module", default="@napi-rs/canvas", help="Installed Canvas package name or absolute module path")
    args = parser.parse_args()
    target = create_preview()
    if args.html_only:
        print(target)
        return
    subprocess.run(["node", str(ROOT / "tools/render_dream_tide_preview.cjs"), args.canvas_module], check=True)


if __name__ == "__main__":
    main()
