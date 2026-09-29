"""Pack the reviewed generated map bust at native player-figure dimensions."""
import hashlib
import json
import shutil
import tempfile
from pathlib import Path
from PIL import Image
from build_afei_art import pack_and_verify

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / 'art/runtime/world-v22'
ATLAS = 'afeix_world_v22'
BRUSH = 'afeix_world_afei'
# Native figure_player_01: ground pivot, world zoom and banner overlap.
RECT = {'left': -17, 'right': 23, 'top': -39, 'bottom': 7,
        'width': 68, 'height': 106, 'offsetY': 20}


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def exported_image():
    manifest = json.loads((BASE / 'manifest.json').read_text(encoding='utf-8'))
    source = BASE / manifest['source']
    if not manifest['reviewed'] or sha(source) != manifest['source_sha256']:
        raise ValueError('World-map source needs review')
    with Image.open(source) as original:
        if original.mode != 'RGBA' or original.getchannel('A').getextrema() != (0,255):
            raise ValueError('Generated map sprite must have native transparent alpha')
        box = original.getchannel('A').point(lambda a: 255 if a >= 20 else 0).getbbox()
        image = original.crop(box)
    image.thumbnail((40,46), Image.Resampling.LANCZOS)
    out = Image.new('RGBA',(40,46))
    out.alpha_composite(image,((40-image.width)//2,46-image.height))
    return out


def build_art():
    cache=ROOT/'.cache/world-afei-v22';cache.mkdir(parents=True,exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='pack-',dir=cache) as temp:
        stage=Path(temp);(stage/'sprites').mkdir();(stage/'build').mkdir();(stage/'pack/sprites').mkdir(parents=True)
        image=exported_image();image.save(stage/'sprites'/f'{BRUSH}.png')
        shutil.copyfile(stage/'sprites'/f'{BRUSH}.png',stage/'pack/sprites'/f'{BRUSH}.png')
        attrs={'id':BRUSH,'img':f'sprites\\{BRUSH}.png',**{k:str(v) for k,v in RECT.items()}}
        roundtrip=pack_and_verify(stage,ATLAS,stage/'pack',[attrs],ROOT/'.cache/afei-art/bbros-modkit-v9/bin/bbrusher.exe')
        roundtrip.pop('roundtrip_directory',None)
        for folder in ['sprites','package']:
            shutil.copytree(stage/folder,BASE/folder,dirs_exist_ok=True)
    files=[]
    for relative in [f'brushes/{ATLAS}.brush',f'gfx/{ATLAS}.png']:
        target=ROOT/'src'/relative;shutil.copyfile(BASE/'package'/relative,target);files.append(target)
    report={'manifest_sha256':sha(BASE/'manifest.json'),'sprite_sha256':sha(BASE/'sprites'/f'{BRUSH}.png'),
            'geometry':RECT,'roundtrip':roundtrip,'native_art_packaged':False,'in_game_tested':False}
    (BASE/'report.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    return files


def validate_art():
    from check_gameplay import verify_custom_atlas,verify_sprite
    report=json.loads((BASE/'report.json').read_text(encoding='utf-8'))
    if report['manifest_sha256'] != sha(BASE/'manifest.json'): raise ValueError('Stale world-art manifest')
    sprite=BASE/'sprites'/f'{BRUSH}.png'
    with Image.open(sprite) as image:
        if image.tobytes()!=exported_image().tobytes() or sha(sprite)!=report['sprite_sha256']:
            raise ValueError('World figure differs from reviewed export')
    atlas=verify_custom_atlas(BASE,ATLAS,report,{BRUSH})
    verify_sprite(atlas['sprites'][BRUSH],sprite,RECT)
    return {'passed':True,'brushes':1,'native_anchor_preserved':True,'files':atlas['files']}


if __name__=='__main__':
    build_art()
    print(validate_art())
