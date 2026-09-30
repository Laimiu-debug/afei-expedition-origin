"""Export reviewed art; render legendary blue backing only on inventory icons."""
from pathlib import Path
from PIL import Image
import hashlib
import json
import shutil
from build_afei_art import pack_and_verify

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / 'art/runtime/ideas-v19'
ATLAS = 'afeix_ideas_v19'
# Enlarge the equipped quad by 1.5 around the handle at (0, -35), keeping
# offsetY=35 so that point stays at the native weapon attachment. Source pixels
# and inventory exports remain unchanged; both native weapon states share it.
GRIP_META = {'left': -97.5, 'right': 37.5, 'top': -71, 'bottom': 88,
             'width': 195, 'height': 213, 'offsetY': 35}

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def source(key):
    manifest = json.loads((BASE / 'manifest.json').read_text(encoding='utf-8'))
    entry = manifest[key]
    path = BASE / entry['source']
    assert entry['reviewed'] and sha(path) == entry['sha256']
    image = Image.open(path).convert('RGBA')
    assert image.getchannel('A').getextrema()[0] == 0
    # Generated files can contain irrelevant RGB behind zero-alpha pixels.
    # Crop by alpha, never color-key or repaint the artwork.
    box = image.getchannel('A').point(lambda a: 255 if a >= 20 else 0).getbbox()
    return image.crop(box)

def fit(image, size, padding=3):
    out = Image.new('RGBA', size)
    image = image.copy()
    image.thumbnail((size[0]-padding*2, size[1]-padding*2), Image.Resampling.LANCZOS)
    out.alpha_composite(image, ((size[0]-image.width)//2, (size[1]-image.height)//2))
    return out

def legendary_inventory(image):
    # Native legendary icons bake their blue backing into the PNG; ItemType
    # controls gameplay classification but the UI does not render a halo.
    # Match the native sword's blue (69,108,160), fading to transparent edges.
    # Draw behind the reviewed item, never repaint the weapon or held sprites.
    glow = Image.new('RGBA', image.size)
    pixels = glow.load()
    width, height = image.size
    for y in range(height):
        for x in range(width):
            dx = (x - (width-1)/2) / (width/2)
            dy = (y - (height-1)/2) / (height/2)
            strength = max(0, 1 - dx*dx) * max(0, 1 - dy*dy)
            pixels[x,y] = (69,108,160,round(175*strength))
    glow.alpha_composite(image)
    return glow

def exports():
    grip = source('grip')
    for folder in ('gfx/ui/items/weapons', 'gfx/items/weapons'):
        yield folder+'/afeix_laoma_grip.png', legendary_inventory(fit(grip, (70, 140)))
        yield folder+'/afeix_laoma_grip_70x70.png', legendary_inventory(fit(grip.rotate(35, expand=True, resample=Image.Resampling.BICUBIC), (70, 70)))
    yield 'gfx/ui/events/afeix_liu_qingsong.png', fit(source('liu'), (210, 210), 2)

def build_art():
    BASE.mkdir(parents=True, exist_ok=True)
    records=[]
    for relative, image in exports():
        path=ROOT/'src'/relative; path.parent.mkdir(parents=True, exist_ok=True); image.save(path)
        records.append({'path':relative,'sha256':sha(path),'size':list(image.size)})
    pack=BASE/'pack'; (pack/'sprites').mkdir(parents=True, exist_ok=True)
    (BASE/'sprites').mkdir(exist_ok=True)
    (BASE/'build').mkdir(exist_ok=True)
    grip=fit(source('grip').rotate(42,expand=True,resample=Image.Resampling.BICUBIC),(90,106),2)
    attrs=[]
    for suffix in ('','_bloodied'):
        # No invented blood overlay: same reviewed weapon art in both native states.
        identity='icon_afeix_laoma_grip'+suffix
        grip.save(pack/'sprites'/(identity+'.png'))
        grip.save(BASE/'sprites'/(identity+'.png'))
        attrs.append({'id':identity,'img':'sprites\\'+identity+'.png',
                      **{key: str(value) for key, value in GRIP_META.items()}})
    report={'manifest_sha256':sha(BASE/'manifest.json'),'exports':records,
            'inventory_quality':'Legendary','inventory_glow_rgb':[69,108,160],
            'equipped_scale':1.5,'equipped_pivot':{'x':0,'y':-35},'equipped_metadata':GRIP_META,
            'roundtrip':pack_and_verify(BASE,ATLAS,pack,attrs,ROOT/'.cache/afei-art/bbros-modkit-v9/bin/bbrusher.exe')}
    files=[ROOT/'src'/r['path'] for r in records]
    for relative in ('brushes/'+ATLAS+'.brush','gfx/'+ATLAS+'.png'):
        path=ROOT/'src'/relative;path.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(BASE/'package'/relative,path);files.append(path)
    (BASE/'report.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    # Neutral checkerboard contact sheet is a review aid, not shipped art.
    preview=Image.new('RGBA',(630,230),'#b7ae98')
    for i,im in enumerate([fit(source('liu'),(210,210)),fit(source('grip'),(150,210)),grip]):preview.alpha_composite(im,(i*210,10))
    preview.convert('RGB').save(BASE/'preview.png')
    return files

def validate_art():
    from check_gameplay import verify_custom_atlas, verify_sprite
    report=json.loads((BASE/'report.json').read_text(encoding='utf-8'))
    assert report['manifest_sha256']==sha(BASE/'manifest.json')
    expected=dict(exports())
    assert set(expected)=={r['path'] for r in report['exports']}
    for record in report['exports']:
        path=ROOT/'src'/record['path']
        assert sha(path)==record['sha256']
        with Image.open(path) as image:
            assert image.size==expected[record['path']].size and image.tobytes()==expected[record['path']].tobytes()
    ids={'icon_afeix_laoma_grip','icon_afeix_laoma_grip_bloodied'}
    atlas=verify_custom_atlas(BASE,ATLAS,report,ids)
    for identity in ids:
        verify_sprite(atlas['sprites'][identity],BASE/'pack/sprites'/(identity+'.png'),
                      GRIP_META)
    return {'passed':True,'files':len(expected)+2,'brushes':2,'npc_only':True}

if __name__=='__main__':
    build_art()
    print(validate_art())
