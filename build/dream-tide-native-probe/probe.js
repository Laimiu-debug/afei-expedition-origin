(function () {
    var probe = null, token = 100000, zoomIndex = 0, viewport=null;
    var zooms = [null, 1, 1.5, 2];
    function report(label) {
        var c = probe._afeixDreamTide.canvas, r = c.getBoundingClientRect();
        var data = {label:label, video:viewport, ua:navigator.userAgent, inner:[innerWidth,innerHeight],
            outer:[outerWidth,outerHeight], screen:[screen.width,screen.height], dpr:window.devicePixelRatio,
            rootZoom:getComputedStyle(document.documentElement).zoom, bodyZoom:getComputedStyle(document.body).zoom,
            inline:[document.documentElement.style.zoom,document.body.style.zoom],
            client:[document.documentElement.clientWidth,document.documentElement.clientHeight,document.body.clientWidth,document.body.clientHeight],
            rootRect:[document.documentElement.getBoundingClientRect().width,document.documentElement.getBoundingClientRect().height],
            rect:[r.left,r.top,r.right,r.bottom,r.width,r.height],
            css:[c.style.width,c.style.height,c.style.zoom], raster:[c.width,c.height]};
        console.log('AFEIX_TIDE_PROBE ' + JSON.stringify(data));
        if (Screens.MainMenuScreen.mSQHandle !== null) SQ.call(Screens.MainMenuScreen.mSQHandle,'afeixTideProbe',JSON.stringify(data));
    }
    function run(next) {
        if (probe) probe.afeixStopDreamTide(null);
        if (next) {
            zoomIndex = (zoomIndex + 1) % zooms.length;
            SQ.call(Screens.MainMenuScreen.mSQHandle,'afeixTideResize',[viewport.Width,viewport.Height,zooms[zoomIndex]||1.4]);return;
        }
        probe=Object.create(TacticalScreen.prototype);probe.mSQHandle={};
        probe.afeixStartDreamTide({Token:++token,SweepSeconds:2.4,FadeAt:3.4,Duration:4.6,ViewportWidth:viewport.Width,ViewportHeight:viewport.Height});
        probe.afeixDreamTideFrame({Token:token,Elapsed:4.6});
        report('F9-final-zoom-'+zoomIndex);
    }
    MainMenuScreen.prototype.afeixSetTideViewport=function(data){viewport=data;run(false);};
    var wait=setInterval(function() {
        if (typeof Screens==='undefined' || !Screens.MainMenuScreen || Screens.MainMenuScreen.mSQHandle===null) return;
        clearInterval(wait);
        setTimeout(function() {
            SQ.call(Screens.MainMenuScreen.mSQHandle,'afeixTideViewport',null);
            var button=document.createElement('button');button.innerHTML='Next probe scale';
            button.style.cssText='position:fixed;left:20px;top:20px;z-index:20000;font:20px Arial;background:white;color:black;';
            button.onclick=function(){run(true);};document.documentElement.appendChild(button);
            var resize=button.cloneNode(true);resize.innerHTML='2560 x 1440';resize.style.top='65px';
            resize.onclick=function(){SQ.call(Screens.MainMenuScreen.mSQHandle,'afeixTideResize',[2560,1440]);};document.documentElement.appendChild(resize);
            var wave=button.cloneNode(true);wave.innerHTML='Wave at 0.6s';wave.style.top='110px';
            wave.onclick=function(){run(false);probe._afeixDreamTide.elapsed=0;probe.afeixDreamTideFrame({Token:token,Elapsed:0.6});report('wave-0.6');};document.documentElement.appendChild(wave);
        },2000);
    },500);
}());
