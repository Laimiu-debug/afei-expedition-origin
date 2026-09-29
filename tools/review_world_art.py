"""Offline comparison at native world-layer anchors; reference art stays local."""
import xml.etree.ElementTree as ET
from pathlib import Path
from PIL import Image,ImageDraw,ImageFont,ImageOps
from build_world_art import ROOT,BASE,BRUSH,RECT


def main():
    native=ROOT/'.cache/world-afei-v22/native/unpacked'
    meta={row.get('id'):row.attrib for row in ET.parse(native/'metadata.xml').getroot()}
    out=ROOT/'build/playtest-world-afei';out.mkdir(parents=True,exist_ok=True)
    font=ImageFont.truetype('C:/Windows/Fonts/msyh.ttc',12)
    sheet=Image.new('RGBA',(480,160),'#565b45');draw=ImageDraw.Draw(sheet)
    def layer(stage,key,custom=False,flip=False):
        m=RECT if custom else meta[key]
        path=BASE/'sprites'/f'{BRUSH}.png' if custom else native/m['img'].replace('\\','/')
        image=Image.open(path).convert('RGBA')
        left=float(m.get('left',-image.width/2));bottom=float(m.get('bottom',image.height/2))
        if flip:
            image=ImageOps.mirror(image)
            left=-float(m.get('right',image.width/2))
        stage.alpha_composite(image,(60+round(left),96-round(bottom)))
    for i,label in enumerate(['原版行军','阿飞 · 向右','阿飞 · 向左','原版扎营']):
        stage=Image.new('RGBA',(120,150))
        if i<3:
            layer(stage,'banner_01');layer(stage,'world_base_01')
            layer(stage,BRUSH if i else 'figure_player_01',custom=i>0,flip=i==2)
        else: layer(stage,'world_player_camp_01')
        sheet.alpha_composite(stage,(i*120,6))
        draw.text((i*120+10,5),label,font=font,fill='white')
    sheet.convert('RGB').save(out/'comparison-1x.png')
    sheet.resize((1440,480),Image.Resampling.NEAREST).convert('RGB').save(out/'comparison-3x.png')
    print(out/'comparison-3x.png')


if __name__=='__main__':main()
