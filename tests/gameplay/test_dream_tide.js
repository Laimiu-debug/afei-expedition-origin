const fs = require('node:fs');
const vm = require('node:vm');
const assert = require('node:assert/strict');
let checks=0;
function check(value){assert.ok(value);checks++;}
const draws=[],gradients=[],transforms=[];
function context2d(){return {clearRect(...args){draws.push(['clear',...args]);},
    fillRect(...args){draws.push(['fill',this.fillStyle,...args]);},
    beginPath(){},moveTo(){},lineTo(){},closePath(){},save(){},restore(){},clip(){},stroke(){},fill(){},translate(...v){transforms.push(['translate',...v]);},scale(...v){transforms.push(['scale',...v]);},
    createLinearGradient(...v){gradients.push(v);return {addColorStop(){}};}};}
const body={children:[],appendChild(canvas){this.children.push(canvas);canvas.parentNode=this;},
    removeChild(canvas){this.children.splice(this.children.indexOf(canvas),1);canvas.parentNode=null;}};
const root={...body,children:[],zoom:1};
function Screen(){this.mSQHandle={};this.disconnects=0;this.destroys=0;}
Screen.prototype.onDisconnection=function(){this.disconnects++;this.mSQHandle=null;return 'native-disconnect';};
Screen.prototype.destroyDIV=function(){this.destroys++;return 'native-destroy';};
const window={innerWidth:1920,innerHeight:1080,getComputedStyle(element){return {zoom:String(element.zoom)};}};
const context={TacticalScreen:Screen,window,document:{body,documentElement:root,createElement(){return {style:{},getContext(){return context2d();}};}}};
vm.runInNewContext(fs.readFileSync('src/ui/mods/afeix/dream_tide.js','utf8'),context);
function start(screen,token){screen.afeixStartDreamTide({Token:token,SweepSeconds:2.4,FadeAt:3.4,Duration:4.6});}
function frame(screen,token,time){screen.afeixDreamTideFrame({Token:token,Elapsed:time});}
const screen=new Screen();
start(screen,1);check(root.children.length===1);
const canvas=root.children[0];check(canvas.style.pointerEvents==='none'&&canvas.style.position==='fixed');
check(canvas.width===1280&&canvas.height===720);
check(canvas.parentNode===root&&body.children.length===0); // body zoom and hidden controls cannot shrink the layer
check(canvas.style.width==='1922px'&&canvas.style.height==='1082px');
root.zoom=0.5;frame(screen,1,0.1);check(Number(canvas.style.zoom)===2);
root.zoom=1.5;frame(screen,1,0.2);check(Math.abs(Number(canvas.style.zoom)*root.zoom-1)<1e-9);
root.zoom=1;
// Older embedded-browser layout can still scale explicit pixels. Exercise the
// reported quarter-screen area, then assert displayed coverage after sizing.
canvas.getBoundingClientRect=()=>({width:parseFloat(canvas.style.width)*0.5,height:parseFloat(canvas.style.height)*0.5});
frame(screen,1,0.3);check(canvas.getBoundingClientRect().width>=window.innerWidth&&canvas.getBoundingClientRect().height>=window.innerHeight);
delete canvas.getBoundingClientRect;frame(screen,1,0.4);check(canvas.style.width==='1922px'&&canvas.style.height==='1082px');
check(screen._afeixDreamTide.direction==='right-to-left');
check(gradients.every(v=>v[1]===0&&v[3]===0&&v[2]>v[0])); // horizontal crest-to-wake gradient
start(screen,1);check(root.children.length===1&&root.children[0]===canvas);
draws.length=0;frame(screen,1,1.2);check(draws.length>0&&screen._afeixDreamTide.elapsed===1.2);
check(!draws.some(d=>d[1]==='rgba(0,0,0,1)')); // no early full-black wipe
const count=draws.length;frame(screen,1,0.5);frame(screen,99,2.0);frame(screen,1,NaN);
check(draws.length===count&&screen._afeixDreamTide.elapsed===1.2);
window.innerWidth=2560;window.innerHeight=1080;frame(screen,1,2.4);
check(canvas.width===1280&&canvas.height===540); // viewport resize keeps bounded work
frame(screen,1,4.6);check(draws.some(d=>d[0]==='fill'&&d[1]==='rgba(0,0,0,1)'&&d[4]===1280&&d[5]===540));
screen.afeixStopDreamTide({Token:1});check(root.children.length===0&&screen._afeixDreamTide===null);
frame(screen,1,5);start(screen,1);check(root.children.length===0); // late frame/start rejected after cleanup
start(screen,3);check(root.children.length===1);
screen.afeixStopDreamTide({Token:2});check(root.children.length===1&&screen._afeixDreamTide.token===3);
start(screen,4);check(root.children.length===1&&screen._afeixDreamTide.token===4);
check(screen.onDisconnection()==='native-disconnect'&&screen.disconnects===1&&root.children.length===0);
start(screen,5);check(root.children.length===0); // queued start cannot survive a disconnected native UI
screen.mSQHandle={};start(screen,5);check(root.children.length===0); // fenced old connection message
start(screen,6);check(root.children.length===1);
check(screen.destroyDIV()==='native-destroy'&&screen.destroys===1&&root.children.length===0);
frame(screen,6,1);start(screen,6);check(root.children.length===0);
const next=new Screen();next.afeixStopDreamTide({Token:10});start(next,10);check(root.children.length===0);
start(next,11);check(root.children.length===1);next.afeixStopDreamTide(null);check(root.children.length===0);
transforms.length=0;
next.afeixStartDreamTide({Token:12,SweepSeconds:2.4,Direction:'left-to-right',FadeAt:3.4,Duration:4.6});
frame(next,12,0.6);check(next._afeixDreamTide.direction==='left-to-right');
check(transforms.some(v=>v[0]==='translate'&&v[1]===1280&&v[2]===0));
check(transforms.some(v=>v[0]==='scale'&&v[1]===-1&&v[2]===1));
next.afeixStopDreamTide(null);check(root.children.length===0);
console.log('TESTS_PASSED='+checks);
