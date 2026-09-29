"""Index supplied EPUBs and read public Wiki pages. Text stays in ignored cache."""
from pathlib import Path,PurePosixPath
from html.parser import HTMLParser
from zipfile import ZipFile
import xml.etree.ElementTree as ET
import json,hashlib,urllib.request,sys
sys.stdout.reconfigure(encoding='utf-8')
ROOT=Path(__file__).resolve().parents[1];CACHE=ROOT/'.cache/balance-v2';CACHE.mkdir(exist_ok=True,parents=True)
class Text(HTMLParser):
    def __init__(self):super().__init__();self.parts=[];self.skip=0;self.links=[];self.href=None;self.label=[]
    def handle_starttag(self,tag,attrs):
        a=dict(attrs)
        if tag in ('script','style'):self.skip+=1
        if tag in ('p','div','h1','h2','h3','h4','li','tr','br'):self.parts.append('\n')
        if tag=='a':self.href=a.get('href');self.label=[]
        if tag=='img':self.parts.append('[图:'+a.get('src','')+']')
    def handle_endtag(self,tag):
        if tag in ('script','style'):self.skip=max(0,self.skip-1)
        if tag in ('p','div','h1','h2','h3','h4','li','tr','br'):self.parts.append('\n')
        if tag=='a' and self.href is not None:self.links.append({'href':self.href,'label':''.join(self.label).strip()});self.href=None
    def handle_data(self,data):
        if not self.skip:self.parts.append(data)
        if self.href is not None:self.label.append(data)
    def text(self):return '\n'.join(t.strip() for t in ''.join(self.parts).splitlines() if t.strip())
def books():
    result=[]
    for slug,start in [('treasury','游戏数值百宝书'),('balance','平衡掌控者')]:
        source=next(x for x in Path('C:/Users/25647/OneDrive/Desktop').glob('*.epub') if x.name.startswith(start));folder=CACHE/slug;folder.mkdir(exist_ok=True)
        with ZipFile(source) as z:
            opf=ET.fromstring(z.read('META-INF/container.xml')).find('.//{*}rootfile').attrib['full-path'];doc=ET.fromstring(z.read(opf));base=PurePosixPath(opf).parent
            manifest={x.attrib['id']:x.attrib for x in doc.find('{*}manifest')};rows=[]
            for i,x in enumerate(doc.find('{*}spine')):
                href=manifest[x.attrib['idref']]['href'];name=str(base/href);parser=Text();parser.feed(z.read(name).decode('utf-8-sig'));txt=parser.text();dest=folder/f'{i:02d}.txt';dest.write_text(txt,encoding='utf-8');rows.append({'index':i,'epub_path':name,'text_path':str(dest),'chars':len(txt),'opening':txt[:150]})
            ncx=next((str(base/x['href'])for x in manifest.values()if x.get('media-type')=='application/x-dtbncx+xml'),None)
            toc=[]
            if ncx:
                for a in ET.fromstring(z.read(ncx)).iter('{http://www.daisy.org/z3986/2005/ncx/}navPoint'):
                    toc.append({'title':a.find('.//{*}text').text,'src':a.find('{*}content').attrib['src']})
            data={'slug':slug,'source':str(source),'sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'spine':rows,'toc':toc};result.append(data)
            print(slug,'characters',sum(x['chars']for x in rows));print(json.dumps(rows,ensure_ascii=False));print('TOC',json.dumps(toc,ensure_ascii=False))
    (CACHE/'books-index.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
def page(url,slug):
    b=urllib.request.urlopen(urllib.request.Request(url,headers={'User-Agent':'Mozilla/5.0'}),timeout=35).read();parser=Text();parser.feed(b.decode('utf-8-sig'))
    (CACHE/(slug+'.html')).write_bytes(b);(CACHE/(slug+'.txt')).write_text(parser.text(),encoding='utf-8')
    data={'url':url,'sha256':hashlib.sha256(b).hexdigest(),'links':parser.links};(CACHE/(slug+'.json')).write_text(json.dumps(data,ensure_ascii=False,indent=2),encoding='utf-8');return parser.text(),parser.links
if __name__=='__main__':
    if len(sys.argv)>1:
        t,l=page(sys.argv[1],sys.argv[2]);print(t[:22000]);print(json.dumps(l,ensure_ascii=False))
    else:books()
