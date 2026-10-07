// Real DOM/layout regression for the full-screen tide. Local native CSS is
// read from the installed game; none of its source is copied into the Mod.
const fs=require('node:fs'),path=require('node:path'),cp=require('node:child_process'),crypto=require('node:crypto');
const {chromium}=require(process.argv[2]||'playwright');
const {createCanvas,loadImage}=require(process.argv[3]||'@napi-rs/canvas');
const root=path.resolve(__dirname,'..'),version=fs.readFileSync(path.join(root,'VERSION'),'utf8').trim();
const out=path.join(root,'build/dream-tide-preview.'+version.split('.').at(-1));
const source=fs.readFileSync(path.join(root,'src/ui/mods/afeix/dream_tide.js'),'utf8');
const native=cp.execFileSync(process.env.AFEIX_PYTHON||'python',['-X','utf8','-c',
    'import sys; from zipfile import ZipFile; z=ZipFile(sys.argv[1]); sys.stdout.buffer.write(z.read("ui/main.css"))',
    'F:/SteamLibrary/steamapps/common/Battle Brothers/data/data_001.dat'],{encoding:'utf8'});
const hash=value=>crypto.createHash('sha256').update(value).digest('hex');
const snapshots=[];
(async()=>{
    fs.mkdirSync(out,{recursive:true});
    const executablePath=fs.existsSync(chromium.executablePath())?chromium.executablePath():
        'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe';
    const browser=await chromium.launch({executablePath,headless:true,timeout:15000});
    try {
        const page=await browser.newPage(),cases=[];
        for(const backingOnly of [false,true]) {
        for(const [width,height] of [[1280,720],[1920,1080],[2560,1080],[3840,2160]]) {
            await page.setViewportSize({width,height});
            for(const zoom of [0.5,0.7071068,1,1.5,2]) {
                await page.setContent('<style>'+native+(backingOnly?'canvas{width:auto!important;height:auto!important}':'')+'</style>');
                await page.evaluate(z=>{document.documentElement.style.zoom=z;document.body.style.zoom=z;
                    document.documentElement.style.backgroundColor='rgb(211,169,97)';},zoom);
                await page.addScriptTag({content:'function TacticalScreen(){this.mSQHandle={};}'+
                    'TacticalScreen.prototype.onDisconnection=function(){};TacticalScreen.prototype.destroyDIV=function(){};'+source});
                const bounds=await page.evaluate(({width,height,backingOnly})=>{
                    if(backingOnly) {
                        window.afeixOriginalViewportDescriptors=[Object.getOwnPropertyDescriptor(window,'innerWidth'),Object.getOwnPropertyDescriptor(window,'innerHeight')];
                        Object.defineProperty(window,'innerWidth',{configurable:true,value:Math.round(width/2)});
                        Object.defineProperty(window,'innerHeight',{configurable:true,value:Math.round(height/2)});
                    }
                    window.tide=new TacticalScreen();tide.afeixStartDreamTide({Token:1,SweepSeconds:2.4,Direction:'right-to-left',FadeAt:3.4,Duration:4.6,ViewportWidth:width,ViewportHeight:height});
                    tide.afeixDreamTideFrame({Token:1,Elapsed:0.6});
                    const c=tide._afeixDreamTide.canvas,r=c.getBoundingClientRect();
                    return {left:r.left,top:r.top,right:r.right,bottom:r.bottom,rootParent:c.parentNode===document.documentElement};
                },{width,height,backingOnly});
                if(!bounds.rootParent||bounds.left>0.01||bounds.top>0.01||bounds.right<width||bounds.bottom<height)
                    throw Error('Tide does not cover viewport: '+JSON.stringify({width,height,zoom,bounds}));
                await page.evaluate(()=>tide.afeixDreamTideFrame({Token:1,Elapsed:4.6}));
                const buffer=await page.screenshot(),image=await loadImage(buffer),canvas=createCanvas(width,height),ctx=canvas.getContext('2d');
                ctx.drawImage(image,0,0);
                for(const x of [0,Math.floor(width/2),width-1])for(const y of [0,Math.floor(height/2),height-1]){
                    const p=ctx.getImageData(x,y,1,1).data;
                    if(p[0]||p[1]||p[2]||p[3]!==255)throw Error('Uncovered final-frame pixel: '+JSON.stringify({width,height,zoom,x,y,p:[...p]}));
                }
                cases.push({width,height,zoom,backingOnly,bounds,all_four_edges_and_corners_black:true});
                if(width===1920&&(zoom===0.5||zoom===1.5)) {
                    const file=path.join(out,'viewport-1920x1080-zoom-'+zoom+'.png');fs.writeFileSync(file,buffer);snapshots.push(path.relative(root,file).replace(/\\/g,'/'));
                }
                await page.setViewportSize({width:width+160,height:height+80});
                const resized=await page.evaluate(({width,height,backingOnly})=>{
                    if(backingOnly){Object.defineProperty(window,'innerWidth',{configurable:true,value:Math.round(width/2)});Object.defineProperty(window,'innerHeight',{configurable:true,value:Math.round(height/2)});}
                    tide.afeixDreamTideFrame({Token:1,Elapsed:4.6,ViewportWidth:width,ViewportHeight:height});const r=tide._afeixDreamTide.canvas.getBoundingClientRect();return {right:r.right,bottom:r.bottom};
                },{width:width+160,height:height+80,backingOnly});
                if(resized.right<width+160||resized.bottom<height+80)throw Error('Viewport resize left an uncovered edge');
                await page.setViewportSize({width,height});
                if(backingOnly) await page.evaluate(()=>{
                    for(const [i,key] of ['innerWidth','innerHeight'].entries()) {
                        const descriptor=window.afeixOriginalViewportDescriptors[i];
                        if(descriptor)Object.defineProperty(window,key,descriptor);else delete window[key];
                    }
                    delete window.afeixOriginalViewportDescriptors;
                });
            }
        }
        }
        const report={browser_tested:true,in_game_tested:false,browser_version:browser.version(),production_js_sha256:hash(source),
            native_main_css_sha256:hash(native),cases,snapshots,resize_passed:true,
            scope:'Real browser DOM layout and screenshot pixels; game native CEF and death-to-wake acceptance remain separate.'};
        fs.writeFileSync(path.join(out,'viewport-report.json'),JSON.stringify(report,null,2)+'\n');
        console.log('VIEWPORT_BROWSER_PASSED='+cases.length+'; all viewport edges/corners and live resizes covered; not in-game tested');
    } finally {await browser.close();}
})().catch(e=>{console.error(e);process.exit(1);});
