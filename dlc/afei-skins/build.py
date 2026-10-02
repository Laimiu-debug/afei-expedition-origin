"""Export, audit, test and package this add-on without writing to main src/dist."""
from pathlib import Path
from zipfile import ZipFile, ZipInfo, ZIP_DEFLATED
import argparse
import hashlib
import json
import re
import shutil
import subprocess
import sys
import tempfile
import xml.etree.ElementTree as ET
from PIL import Image, ImageDraw, ImageFont

DLC = Path(__file__).resolve().parent
ROOT = DLC.parents[1]
ATLAS = 'afeix_dlc_afei_skins_v01'
KIT = ROOT / '.cache/afei-art/bbros-modkit-v9/bin'
WORLD_RECT = {'left': -17, 'right': 23, 'top': -39, 'bottom': 7,
              'width': 68, 'height': 106, 'offsetY': 20}
sys.path.insert(0, str(ROOT / 'tools'))
import build_portrait_art as portrait
from build_afei_art import pack_and_verify
from build_corpse_injury_art import native_layers, wounded_head, SUFFIXES


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def save_json(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def files_hash(root):
    return {p.relative_to(root).as_posix(): sha(p) for p in sorted(root.rglob('*')) if p.is_file()}


def run(command):
    result = subprocess.run([str(v) for v in command], cwd=ROOT, capture_output=True)
    out = (result.stdout + result.stderr).decode('utf-8', errors='replace')
    if result.returncode or 'AN ERROR HAS OCCUR' in out or 'FAIL ' in out:
        raise RuntimeError(out)
    return out


def entries():
    manifest = json.loads((DLC / 'art/manifest.json').read_text(encoding='utf-8'))
    if manifest['atlas_name'] != ATLAS or manifest['schema_version'] != 1:
        raise ValueError('Unsupported skins manifest')
    expected = ['captain', 'wanderer', 'veteran', 'bare', 'huxueer', 'toad']
    if [s['key'] for s in manifest['styles']] != expected:
        raise ValueError('Expected six reviewed skins in runtime ordering')
    return [dict(s, brush='afeix_dlc_skins_' + s['key'], form=s['key'],
                 source=f'dlc/afei-skins/art/sources/{s["key"]}.png', source_kind='generated_custom',
                 review_note='Generated custom skin; reviewed at native sprite size; game acceptance pending.')
            for s in manifest['styles']]


def fit_source(entry):
    image = Image.open(ROOT / entry['source']).convert('RGBA')
    if image.getchannel('A').getextrema() != (0, 255):
        raise ValueError('Real transparency required: ' + entry['key'])
    box = image.getchannel('A').point(lambda a: 255 if a >= 20 else 0).getbbox()
    image = image.crop(box)
    image.thumbnail((88, 100), Image.Resampling.LANCZOS)
    out = Image.new('RGBA', (114, 142))
    out.alpha_composite(image, ((114-image.width)//2, 142-image.height))
    return out


def source_review(records):
    font = ImageFont.truetype('C:/Windows/Fonts/msyh.ttc', 17)
    small = ImageFont.truetype('C:/Windows/Fonts/msyh.ttc', 12)
    sheet = Image.new('RGB', (1080, 490), '#302b24')
    draw = ImageDraw.Draw(sheet)
    draw.text((20, 12), '阿飞衣橱 · 六套 DLC 外观', font=font, fill='#f4e8d0')
    draw.text((20, 38), '114×142 原尺寸与 3× 像素预览；美术资源预览，不是游戏截图。', font=small, fill='#cfbfa1')
    for i, entry in enumerate(records):
        x = 180*i
        full = fit_source(entry)
        sheet.paste(full, (x+33, 70), full)
        bigger = full.resize((342,426), Image.Resampling.NEAREST).crop((36,111,306,426))
        bigger.thumbnail((172, 230), Image.Resampling.NEAREST)
        sheet.paste(bigger, (x+4, 228), bigger)
        draw.text((x+35, 464), entry['name'], font=small, fill='#f4e8d0')
    sheet.save(DLC / 'art/preview.png')
    # Enlarged geometric inspection grid; not included in the install package.
    grid = Image.new('RGB', (684, 852), '#302b24')
    for i, entry in enumerate(records):
        im = fit_source(entry).resize((228,284), Image.Resampling.NEAREST)
        grid.paste(im, (i%3*228, i//3*426), im)
        d = ImageDraw.Draw(grid)
        d.text((i%3*228+8, i//3*426+288), entry['key'], font=font, fill='#f4e8d0')
        points = [(i%3*228+x*2, i//3*426+y*2) for x,y in entry['head_seam']]
        d.line(points, fill='#ff6688', width=2)
    grid.save(DLC / 'art/neck-review.png')


def build_art(records, stage):
    portrait.ROOT = ROOT
    portrait.ALLOWED_SOURCE_ROOTS = (DLC / 'art/sources',)
    sprites = stage / 'sprites'
    sprites.mkdir()
    (stage / 'build').mkdir()
    overlays, native_sources = native_layers()
    attrs, exported = [], []
    for entry in records:
        metadata, record = portrait.export_portrait(entry, sprites)
        attrs += metadata
        exported.append(record)
        head = Image.open(sprites / (entry['brush'] + '_head.png')).convert('RGBA')
        for level, suffix in enumerate(SUFFIXES):
            identity = entry['brush'] + suffix
            portrait.prone_head(wounded_head(head, overlays, level), entry).save(sprites / (identity + '.png'))
            attrs.append(dict(id=identity, img='sprites\\'+identity+'.png',
                              **{k:str(v) for k,v in portrait.CORPSE_RECT.items()}))
        full = Image.open(sprites / (entry['brush'] + '_dead.png')).convert('RGBA')
        world = full.crop(full.getchannel('A').point(lambda a: 255 if a >= 20 else 0).getbbox())
        world.thumbnail((40,46), Image.Resampling.LANCZOS)
        canvas = Image.new('RGBA', (40,46))
        canvas.alpha_composite(world, ((40-world.width)//2,46-world.height))
        identity = entry['brush'] + '_world'
        canvas.save(sprites / (identity+'.png'))
        attrs.append(dict(id=identity, img='sprites\\'+identity+'.png', **{k:str(v) for k,v in WORLD_RECT.items()}))
        ui = DLC / 'src/gfx/ui/afeix_dlc_afei_skins'
        ui.mkdir(parents=True, exist_ok=True)
        full.save(ui / (entry['key'] + '.png'))
    shutil.copy2(ROOT/'art/runtime/portraits-v05/sprites/afeix_p04_afei_normal_dead.png', ui/'native.png')
    cg = Image.open(DLC/'art/sources/huxueer-defeat-v2.png').convert('RGB')
    cg.thumbnail((450,300), Image.Resampling.LANCZOS)
    cg_path = DLC/'src/gfx/ui/events/afeix_dlc_skins_huxueer_defeat.png'
    cg_path.parent.mkdir(parents=True, exist_ok=True)
    cg.save(cg_path)
    pack_input = stage/'pack'
    shutil.copytree(sprites, pack_input/'sprites')
    packed = pack_and_verify(stage, ATLAS, pack_input, attrs, KIT/'bbrusher.exe')
    packed.pop('roundtrip_directory', None)
    for relative in [f'brushes/{ATLAS}.brush', f'gfx/{ATLAS}.png']:
        target = DLC/'src'/relative
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(stage/'package'/relative, target)
    shutil.copytree(sprites, DLC/'art/sprites', dirs_exist_ok=True)
    return dict(exports=exported, roundtrip=packed, wound_sources=native_sources,
                native_equipment_packaged=False, sprite_count=len(attrs), cg_packaged=True, cg_size=list(cg.size))


def equipment_review(records):
    refs_dir = ROOT/'art/runtime/afei/v1/build/preview'
    refs = json.loads((refs_dir/'native-reference-sources.json').read_text(encoding='utf-8'))
    font = ImageFont.truetype('C:/Windows/Fonts/msyh.ttc',14)
    sheet = Image.new('RGB',(1000,6*236+60),'#302b24')
    draw=ImageDraw.Draw(sheet)
    draw.text((18,12),'DLC 装备分层与倒地头部 · 按画刷坐标离线合成，尚未实机验收',font=font,fill='#f4e8d0')
    def native(canvas,key):
        meta=refs[key]
        im=Image.open(refs_dir/meta['url']).convert('RGBA')
        size=(round(float(meta['right'])-float(meta['left'])),round(float(meta['bottom'])-float(meta['top'])))
        im=im.resize(size,Image.Resampling.LANCZOS)
        canvas.alpha_composite(im,(57+round(float(meta['left'])),91-round(float(meta['bottom']))))
    for row,entry in enumerate(records):
        y=60+236*row
        draw.text((12,y),entry['name'],font=font,fill='#f4e8d0')
        for col,label in enumerate(['素装','护甲','开面盔','闭面盔','倒地头部']):
            canvas=Image.new('RGBA',(160,150))
            if col==4:
                canvas=Image.open(DLC/'art/sprites'/(entry['brush']+'_corpse_head.png')).convert('RGBA')
            else:
                canvas.alpha_composite(Image.open(DLC/'art/sprites'/(entry['brush']+'.png')).convert('RGBA'),(0,0))
                if col>0: native(canvas,'bust_body_14')
                canvas.alpha_composite(Image.open(DLC/'art/sprites'/(entry['brush']+'_head.png')).convert('RGBA'),(0,0))
                if col>1: native(canvas,'bust_helmet_03' if col==2 else 'bust_helmet_18')
                if col==3:
                    # Closed helmets hide the head through the native appearance state.
                    canvas=Image.new('RGBA',(160,150))
                    canvas.alpha_composite(Image.open(DLC/'art/sprites'/(entry['brush']+'.png')).convert('RGBA'),(0,0))
                    native(canvas,'bust_body_14');native(canvas,'bust_helmet_18')
            canvas=canvas.resize((192,180),Image.Resampling.NEAREST)
            sheet.paste(canvas,(200*col,y+22),canvas)
            draw.text((200*col+12,y+208),label,font=font,fill='#cfbfa1')
    sheet.save(DLC/'art/equipment-preview.png')


def compatibility():
    own=files_hash(DLC/'src')
    collisions=[]
    bases=[ROOT/'src']+[p for p in (ROOT/'dlc').glob('*/src') if p.parent!=DLC]
    for base in bases:
        for rel in own:
            if (base/rel).exists(): collisions.append(str(base.relative_to(ROOT)/rel))
    if collisions: raise ValueError('DLC path collisions: '+repr(collisions))
    # Unpack all other atlases for identifier comparison, without changing them.
    own_ids={e.get('id') for e in ET.parse(DLC/'art/sprites/metadata.xml').getroot()}
    duplicate_ids=[]
    with tempfile.TemporaryDirectory(prefix='skins-collision-',dir=ROOT/'.cache') as temporary:
        for index,brush in enumerate(p for base in bases for p in base.glob('brushes/*.brush')):
            target=Path(temporary)/str(index)
            run([KIT/'bbrusher.exe','unpack','--gfxPath',brush.parent.parent,brush,target])
            others={e.get('id') for e in ET.parse(target/'metadata.xml').getroot()}
            duplicate_ids.extend(sorted(own_ids & others))
    if duplicate_ids: raise ValueError('Brush ID collisions: '+repr(duplicate_ids))
    sources='\n'.join(p.read_text(encoding='utf-8') for p in (DLC/'src').rglob('*.nut'))
    if sources.count('::mods_registerMod(')!=1 or sources.count('::mods_queue(')!=1:
        raise ValueError('Unexpected preload registration graph')
    if 'mod_afeix_expedition(>=62), >mod_afeix_expedition' not in sources:
        raise ValueError('Expected one-way main -> DLC dependency')
    reused=[]
    for base in bases:
        for p in base.rglob('*.nut'):
            text=p.read_text(encoding='utf-8')
            if 'mod_afeix_dlc_afei_skins' in text or 'afeix_dlc_afei_skins_style' in text:
                reused.append(p.relative_to(ROOT).as_posix())
    if reused: raise ValueError('Mod ID/flag reuse or reverse dependency: '+repr(reused))
    return dict(path_collisions=collisions, brush_collisions=duplicate_ids,
                other_src_roots=[p.relative_to(ROOT).as_posix() for p in bases],
                dependencies=['mod_afeix_expedition'], cycles=False, mod_id_and_flag_reuse=reused)


def verify(stage):
    scripts=sorted((DLC/'src').rglob('*.nut'))
    for source in scripts: run([KIT/'sq.exe','-c','-o',stage/'compile.cnut',source])
    fixture = (ROOT/'tests/gameplay/test_appearance.nut').read_text(encoding='utf-8')
    marker = '    print("ALL_APPEARANCE_BEHAVIOR_CHECKS_PASS'
    if fixture.count(marker) != 1: raise ValueError('Portrait test fixture changed; review DLC adapter')
    fixture = fixture.replace(marker, (DLC/'tests/runtime.nut').read_text(encoding='utf-8')+'\n'+marker, 1)
    combined = stage/'runtime.nut'
    combined.write_text(fixture, encoding='utf-8')
    tests=[]
    for path in [combined,ROOT/'tests/gameplay/test_company_appearance.nut']:
        out=run([KIT/'sq.exe',path])
        match=re.search(r'TESTS_PASSED=(\d+)',out)
        if not match: raise ValueError(out)
        tests.append(dict(test='base_portraits_plus_dlc_runtime' if path == combined else path.relative_to(ROOT).as_posix(),assertions=int(match[1])))
    return dict(scripts_compiled=len(scripts),tests=tests,compatibility=compatibility(),in_game_tested=False)


def package():
    paths=sorted(p for p in (DLC/'src').rglob('*') if p.is_file())
    if any(p.suffix not in {'.nut','.brush','.png'} for p in paths):
        raise ValueError('Unexpected install package file type')
    target=DLC/'dist/mod_afeix_dlc_afei_skins v0.1.0.zip'
    target.parent.mkdir(exist_ok=True)
    with ZipFile(target,'w',compression=ZIP_DEFLATED) as archive:
        for p in paths:
            info=ZipInfo(p.relative_to(DLC/'src').as_posix(),(2026,10,2,0,0,0))
            info.compress_type=ZIP_DEFLATED
            archive.writestr(info,p.read_bytes())
    with ZipFile(target) as archive:
        if archive.testzip() or set(archive.namelist())!={p.relative_to(DLC/'src').as_posix() for p in paths}:
            raise ValueError('ZIP CRC or entry-set mismatch')
        for p in paths:
            if archive.read(p.relative_to(DLC/'src').as_posix())!=p.read_bytes():
                raise ValueError('ZIP bytes differ: '+str(p))
    return dict(path=target.relative_to(ROOT).as_posix(),sha256=sha(target),bytes=target.stat().st_size,
                entries=[p.relative_to(DLC/'src').as_posix() for p in paths],crc_and_source_match=True)


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--review-only',action='store_true')
    args=parser.parse_args()
    records=entries()
    source_review(records)
    if args.review_only: return
    before=files_hash(ROOT/'src')
    (ROOT/'.cache').mkdir(exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='afei-skins-',dir=ROOT/'.cache') as temp:
        stage=Path(temp)
        art=build_art(records,stage)
        equipment_review(records)
        validation=verify(stage)
    if before!=files_hash(ROOT/'src'): raise ValueError('Main src changed during DLC build')
    result=package()
    save_json(DLC/'report.json',dict(version='0.1.0',minimum_base='0.28.12 / internal 62',
        art=art,validation=validation,package=result,main_src_unchanged=True,
        main_src_fingerprints=before,source_fingerprints=files_hash(DLC/'art/sources'),
        installed=False,published=False))
    print(json.dumps(dict(package=result['path'],bytes=result['bytes'],sprites=art['sprite_count'],
        assertions=sum(t['assertions'] for t in validation['tests']),main_src_unchanged=True),ensure_ascii=False))


if __name__=='__main__': main()
