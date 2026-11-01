"""Lossless face/hair partitions from existing portraits and authored contours.

No repaint, resizing or replacement of source pixels. Native HideHair controls
the generated hair layer; unchanged portraits remain the fallback.
"""
import hashlib,json,shutil
from pathlib import Path
from PIL import Image,ImageDraw,ImageFont
from build_portrait_art import BASE as PORTRAITS,LIVE_RECT,CORPSE_RECT,read_manifest,prone_head,BBRUSHER
from build_afei_art import pack_and_verify
from build_corpse_injury_art import native_layers,wounded_head
ROOT=Path(__file__).resolve().parents[1]
BASE=ROOT/'art/runtime/helmet-layers-v01';ATLAS='afeix_helmet_layers_v01'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def split_layers(entry,contours):
    prefix=entry['brush'];folder=PORTRAITS/'sprites'
    body=Image.open(folder/(prefix+'.png')).convert('RGBA')
    head=Image.open(folder/(prefix+'_head.png')).convert('RGBA')
    keep=Image.new('1',(114,142));draw=ImageDraw.Draw(keep)
    draw.polygon(contours['faces'][entry['key']],fill=1)
    # Garments outside the neck remain below equipment. Long hair crossing the
    # neck is explicitly assigned to hair, instead of being baked into clothing.
    if entry['key'] in contours['long_hair']:draw.polygon(contours['cloth_polygon'],fill=1)
    else:keep.paste(1,(0,108,114,142))
    plainBody=body.copy();plainHead=head.copy();hair=Image.new('RGBA',(114,142))
    full=Image.alpha_composite(body,head)
    for y in range(142):
        for x in range(114):
            if not keep.getpixel((x,y)):
                plainBody.putpixel((x,y),(0,0,0,0));plainHead.putpixel((x,y),(0,0,0,0))
                hair.putpixel((x,y),full.getpixel((x,y)))
    assert Image.alpha_composite(Image.alpha_composite(plainBody,plainHead),hair).tobytes()==full.tobytes(),prefix
    return plainBody,plainHead,hair
def build():
    contours=json.loads((BASE/'contours.json').read_text(encoding='utf-8'))
    _,entries,_=read_manifest();entries=[e for e in entries if e['key'] in contours['faces'] and e['form'] not in ('toad','jiahao')]
    assert len(entries)==len(contours['faces'])==33
    (BASE/'build').mkdir(exist_ok=True);(BASE/'sprites').mkdir(exist_ok=True);(BASE/'pack/sprites').mkdir(parents=True,exist_ok=True)
    overlays,_=native_layers();attrs=[];records=[]
    for e in entries:
        body,head,hair=split_layers(e,contours);prefix=e['brush']
        sprites={'_bare_body':body,'_bare_head':head,'_hair':hair,'_bare_corpse_head':prone_head(head,e)}
        for level,suffix in enumerate(['_bare_corpse_head_bloodied','_bare_corpse_head_injured_01','_bare_corpse_head_injured_02']):
            sprites[suffix]=prone_head(wounded_head(head,overlays,level),e)
        for suffix,im in sprites.items():
            identity=prefix+suffix;path=BASE/'sprites'/(identity+'.png');im.save(path)
            shutil.copyfile(path,BASE/'pack/sprites'/path.name)
            geometry=CORPSE_RECT if 'corpse' in suffix else LIVE_RECT
            attrs.append({'id':identity,'img':'sprites\\'+identity+'.png',**{k:str(v) for k,v in geometry.items()}})
        records.append({'key':e['key'],'brush':prefix,'body_sha256':sha(PORTRAITS/'sprites'/(prefix+'.png')),
            'head_sha256':sha(PORTRAITS/'sprites'/(prefix+'_head.png')),'reconstruction_identical':True})
    roundtrip=pack_and_verify(BASE,ATLAS,BASE/'pack',attrs,BBRUSHER)
    for relative in [f'brushes/{ATLAS}.brush',f'gfx/{ATLAS}.png']:shutil.copyfile(BASE/'package'/relative,ROOT/'src'/relative)
    report={'atlas_name':ATLAS,'contours_sha256':sha(BASE/'contours.json'),'portraits':records,'roundtrip':roundtrip,'in_game_tested':False}
    (BASE/'build/report.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    review(entries,contours)
    print(f'Built {len(entries)} lossless partitions / {len(attrs)} brushes.')
    return [ROOT/'src/brushes'/f'{ATLAS}.brush', ROOT/'src/gfx'/f'{ATLAS}.png']
def review(entries,contours):
    native=ROOT/'art/runtime/afei/v1/build/preview';refs=json.loads((native/'native-reference-sources.json').read_text(encoding='utf-8'))
    def piece(canvas,key):
        meta=refs[key];im=Image.open(native/meta['url']).convert('RGBA')
        size=(round(float(meta['right'])-float(meta['left'])),round(float(meta['bottom'])-float(meta['top'])))
        im=im.resize(size,Image.Resampling.LANCZOS)
        canvas.alpha_composite(im,(57+round(float(meta['left'])),125-round(float(meta['bottom']))))
    font=ImageFont.truetype('C:/Windows/Fonts/msyh.ttc',13)
    for page in range(5):
        selected=entries[page*7:(page+1)*7];canvas=Image.new('RGB',(4*238,len(selected)*265),'#35322c');draw=ImageDraw.Draw(canvas)
        for i,e in enumerate(selected):
            body,head,hair=split_layers(e,contours)
            for col,(helmet,old,showHair) in enumerate([('bust_helmet_03',True,True),('bust_helmet_03',False,False),('bust_helmet_18',False,False),(None,False,True)]):
                frame=Image.new('RGBA',(114,170));b=Image.open(PORTRAITS/'sprites'/(e['brush']+'.png')).convert('RGBA') if old else body
                h=Image.open(PORTRAITS/'sprites'/(e['brush']+'_head.png')).convert('RGBA') if old else head
                frame.alpha_composite(b,(0,34));piece(frame,'bust_body_14');frame.alpha_composite(h,(0,34))
                if showHair and not old:frame.alpha_composite(hair,(0,34))
                if helmet:piece(frame,helmet)
                frame=frame.resize((228,340),Image.Resampling.NEAREST)
                # Crop unused floor; do not change the game-sized source assets.
                frame=frame.crop((0,90,228,340))
                canvas.paste(frame,(col*238,i*265+15),frame)
            draw.text((0,i*265),e['key']+'   old / open / closed / hair restored',font=font,fill='white')
        out=ROOT/'build/helmet-layers-20261002';out.mkdir(exist_ok=True);canvas.save(out/f'review-{page+1}.png')
def validate_art():
    from check_gameplay import verify_custom_atlas,verify_sprite
    contours=json.loads((BASE/'contours.json').read_text(encoding='utf-8'));report=json.loads((BASE/'build/report.json').read_text(encoding='utf-8'))
    assert report['contours_sha256']==sha(BASE/'contours.json')
    expected={p['brush']+suffix for p in report['portraits'] for suffix in ['_bare_body','_bare_head','_hair','_bare_corpse_head','_bare_corpse_head_bloodied','_bare_corpse_head_injured_01','_bare_corpse_head_injured_02']}
    packed=verify_custom_atlas(BASE,ATLAS,report,expected)
    _,entries,_=read_manifest();by={e['brush']:e for e in entries}
    overlays,_=native_layers()
    for row in report['portraits']:
        prefix=row['brush'];e=by[prefix]
        assert row['body_sha256']==sha(PORTRAITS/'sprites'/(prefix+'.png')) and row['head_sha256']==sha(PORTRAITS/'sprites'/(prefix+'_head.png'))
        body,head,hair=split_layers(e,contours)
        expectedImages={'_bare_body':body,'_bare_head':head,'_hair':hair,'_bare_corpse_head':prone_head(head,e)}
        for level,suffix in enumerate(['_bare_corpse_head_bloodied','_bare_corpse_head_injured_01','_bare_corpse_head_injured_02']):expectedImages[suffix]=prone_head(wounded_head(head,overlays,level),e)
        for suffix,im in expectedImages.items():
            path=BASE/'sprites'/(prefix+suffix+'.png')
            assert Image.open(path).convert('RGBA').tobytes()==im.tobytes(),path.name
            verify_sprite(packed['sprites'][prefix+suffix],path,CORPSE_RECT if 'corpse' in suffix else LIVE_RECT)
    return {'portraits':len(report['portraits']),'brushes':len(expected),'reconstruction_identical':True,'files':packed['files']}
if __name__=='__main__':build()
