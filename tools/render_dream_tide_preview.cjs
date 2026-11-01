// Actual Skia-backed 2D canvas pixels; native browser/bridge/deaths remain
// separate acceptance boundaries. The bitmap reference is never edited.
const fs=require('node:fs'),path=require('node:path'),vm=require('node:vm'),crypto=require('node:crypto');
const {createCanvas,loadImage}=require(process.argv[2]||'@napi-rs/canvas');
const root=path.resolve(__dirname,'..'),out=path.join(root,'build/dream-tide-preview.13');
const source=path.join(root,'src/ui/mods/afeix/dream_tide.js');
const background=path.join(root,'build/douyu-playtest/native-barrage-warning.png');
function hash(p){return crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex');}
function Screen(){this.mSQHandle={};}
Screen.prototype.onDisconnection=function(){};Screen.prototype.destroyDIV=function(){};
const body={appendChild(c){c.parentNode=this;},removeChild(c){c.parentNode=null;}};
const context={TacticalScreen:Screen,window:{innerWidth:1280,innerHeight:720},document:{body,documentElement:body,createElement(){
    const c=createCanvas(1,1);c.style={};return c;
}}};
vm.runInNewContext(fs.readFileSync(source,'utf8'),context);
(async function(){
    const reference=await loadImage(background),screen=new Screen(),frames=[];
    screen.afeixStartDreamTide({Token:1,SweepSeconds:2.4,Direction:'right-to-left',FadeAt:3.4,Duration:4.6});
    const snapshot=[0,0.6,1.2,1.8,2.4,3.4,4.6];
    for(let i=0;i<snapshot.length;i++){
        const elapsed=snapshot[i];screen.afeixDreamTideFrame({Token:1,Elapsed:elapsed});
        const overlay=screen._afeixDreamTide.canvas.getContext('2d');
        if(elapsed===0.6){
            if(overlay.getImageData(1230,360,1,1).data[3]<150||overlay.getImageData(50,360,1,1).data[3]!==0)
                throw Error('Right-to-left wave did not enter on right and leave left unobscured');
        }
        if(elapsed===2.4){
            const pixels=overlay.getImageData(0,0,1280,720).data;
            for(let n=3;n<pixels.length;n+=4)if(pixels[n])throw Error('Horizontal wave tail did not leave viewport');
        }
        const canvas=createCanvas(1280,720),ctx=canvas.getContext('2d');
        ctx.drawImage(reference,0,0,1280,720);ctx.drawImage(screen._afeixDreamTide.canvas,0,0);
        if(elapsed===4.6){const pixel=ctx.getImageData(640,360,1,1).data;if(pixel[0]||pixel[1]||pixel[2])throw Error('Final frame is not black');}
        ctx.fillStyle='rgba(9,18,21,0.9)';ctx.fillRect(20,18,465,58);
        ctx.fillStyle='#e0dac1';ctx.font='16px "Microsoft YaHei",sans-serif';
        ctx.fillText('黑潮横扫代码预览 · 右 → 左 · '+elapsed.toFixed(1)+' 秒',34,42);
        ctx.font='12px "Microsoft YaHei",sans-serif';ctx.fillText('静止的历史战场参考；非实机录像，未展示原生倒下过程',34,63);
        const file=path.join(out,'frame-'+i+'-'+elapsed.toFixed(1)+'s.png');fs.writeFileSync(file,canvas.toBuffer('image/png'));
        frames.push({elapsed,file:path.relative(root,file).replace(/\\/g,'/'),sha256:hash(file)});
    }
    const mirror=new Screen();mirror.afeixStartDreamTide({Token:2,SweepSeconds:2.4,Direction:'left-to-right',FadeAt:3.4,Duration:4.6});
    mirror.afeixDreamTideFrame({Token:2,Elapsed:0.6});
    const mirrored=mirror._afeixDreamTide.canvas.getContext('2d');
    if(mirrored.getImageData(50,360,1,1).data[3]<150||mirrored.getImageData(1230,360,1,1).data[3]!==0)
        throw Error('Left-to-right mirrored wave failed directional pixel check');
    const report={method:'Skia-backed @napi-rs/canvas executes shipped production JS with real Canvas 2D drawing',
        in_game_tested:false,browser_tested:false,production_js_sha256:hash(source),
        direction:'right-to-left',directional_pixels_passed:true,mirrored_direction_pixels_passed:true,wave_tail_clears_viewport:true,
        historical_static_background:'build/douyu-playtest/native-barrage-warning.png',
        preview:'build/dream-tide-preview.13/preview.html',frames,
        limits:['Browser preview runtime unavailable; Canvas pixel preview is not native CEF or game acceptance.','No native actor deaths or UI bridge exercised by this preview.']};
    fs.writeFileSync(path.join(out,'render-report.json'),JSON.stringify(report,null,2)+'\n');
    console.log('CANVAS_PREVIEW_RENDERED='+frames.length+'; final frame black; not in-game tested');
}()).catch(error=>{console.error(error);process.exit(1);});
