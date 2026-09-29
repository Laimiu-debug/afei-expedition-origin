"""Export reviewed V2 skill icons and the generated round mirror at native sizes."""
from pathlib import Path
import hashlib
import json
from PIL import Image

ROOT=Path(__file__).resolve().parents[1]
ART=ROOT/'art/runtime/balance-v26'


def records():
    for key in ['yanzi_watch','yanzi_cover','yanzi_reply','xiwen_read','xiwen_cover','xiwen_travel']:
        yield ROOT/f'docs/design/balance-v2/icons/{key}.png',ROOT/f'src/gfx/skills/afeix_member_{key}.png',(56,56)
    for folder in ['items/accessory','ui/items/accessory']:
        yield ART/'sources/xiwen-round-mirror.png',ROOT/f'src/gfx/{folder}/xiwen_round_mirror.png',(70,70)


def validate_art():
    manifest=json.loads((ART/'manifest.json').read_text(encoding='utf-8'))
    result=[]
    for source,target,size in records():
        source_hash=hashlib.sha256(source.read_bytes()).hexdigest()
        assert manifest['reviewed_sources'][source.relative_to(ROOT).as_posix()]==source_hash
        with Image.open(source) as im, Image.open(target) as out:
            assert out.mode=='RGBA' and out.size==size
            assert im.convert('RGBA').resize(size,Image.Resampling.LANCZOS).tobytes()==out.tobytes()
        result.append({'source':source.relative_to(ROOT).as_posix(),'source_sha256':source_hash,'output':target.relative_to(ROOT).as_posix(),'sha256':hashlib.sha256(target.read_bytes()).hexdigest()})
    return result


def build_art():
    for source,target,size in records():
        target.parent.mkdir(parents=True,exist_ok=True)
        with Image.open(source) as im:im.convert('RGBA').resize(size,Image.Resampling.LANCZOS).save(target)
    report=validate_art()
    (ART/'report.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    return [target for _,target,_ in records()]


if __name__=='__main__':build_art()
