// Procedural water over the frozen tactical scene. The backend owns elapsed
// time and deaths; no frontend timer can continue into the next battle.
(function () {
    "use strict";
    var proto = TacticalScreen.prototype;
    function clamp(v) { return Math.max(0, Math.min(1, v)); }
    function ease(v) { v = clamp(v); return v * v * (3 - 2 * v); }
    function front(y, w, h, sweep, time) {
        return w * (1.07 - 1.82 * ease(sweep))
            + w * (0.018 * Math.sin(y / h * 13 + time * 2.2)
            + 0.009 * Math.sin(y / h * 31 - time * 1.6)
            + 0.025 * (y / h - 0.5));
    }
    function sweepPath(ctx, w, h, sweep, time) {
        ctx.beginPath();
        ctx.moveTo(front(-8, w, h, sweep, time), -8);
        for (var y = -8; y <= h + 16; y += 12) ctx.lineTo(front(y, w, h, sweep, time), y);
        for (var back = h + 16; back >= -8; back -= 12)
            ctx.lineTo(front(back, w, h, sweep, time) + w * 0.60, back);
        ctx.closePath();
    }
    function paintSweep(ctx, w, h, sweep, time, direction) {
        ctx.save();
        // Canonical wave travels right to left. Mirror the entire drawing for
        // the other direction; both crest and horizontal wake move together.
        if (direction === "left-to-right") { ctx.translate(w, 0); ctx.scale(-1, 1); }
        ctx.save();
        sweepPath(ctx, w, h, sweep, time); ctx.clip();
        var lead = front(h * 0.5, w, h, sweep, time);
        var color = ctx.createLinearGradient(lead, 0, lead + w * 0.60, 0);
        color.addColorStop(0, "rgba(3,10,12,0.88)");
        color.addColorStop(0.12, "rgba(2,8,11,0.96)");
        color.addColorStop(0.46, "rgba(9,21,24,0.87)");
        color.addColorStop(0.78, "rgba(27,45,43,0.38)");
        color.addColorStop(1, "rgba(27,45,43,0)");
        ctx.fillStyle = color; ctx.fillRect(0, 0, w, h);
        // Long horizontal streamers behind the ragged black wavefront. Its
        // tail also leaves the viewport: no rising waterline remains behind.
        for (var row = 0; row < 36; row++) {
            var baseY = h * row / 35;
            for (var col = 0; col < 4; col++) {
                var phase = ((row * 0.137 + col * 0.231 - time * 0.35) % 1 + 1) % 1;
                var left = front(baseY, w, h, sweep, time) + w * (0.02 + phase * 0.55);
                var length = w * (0.04 + ((row * 7 + col * 3) % 6) * 0.013);
                ctx.beginPath();
                for (var p = 0; p <= 6; p++) {
                    var px = left + length * p / 6;
                    var py = baseY + Math.sin(p * 0.55 + row * 1.7 + time * 2.0) * h * 0.004;
                    if (p === 0) ctx.moveTo(px, py); else ctx.lineTo(px, py);
                }
                ctx.lineWidth = row % 4 === 0 ? 2.0 : 0.9;
                ctx.strokeStyle = row % 4 === 0 ? "rgba(115,143,135,0.21)" : "rgba(61,91,95,0.26)";
                ctx.stroke();
            }
        }
        ctx.restore();
        // Broken vertical foam crests and short sideways sprays define the
        // leading edge, keeping the motion legible against a dark battlefield.
        for (var band = 0; band < 3; band++) {
            ctx.beginPath();
            for (var y = 0; y <= h + 12; y += 12) {
                var x = front(y, w, h, sweep, time) + band * 8;
                if (y === 0) ctx.moveTo(x, y); else ctx.lineTo(x, y);
            }
            ctx.lineWidth = band === 0 ? 2.4 : 1.0;
            ctx.strokeStyle = band === 0 ? "rgba(74,105,104,0.52)" : "rgba(151,164,143,0.19)";
            ctx.stroke();
        }
        for (var spray = 0; spray < 17; spray++) {
            var sy = h * (spray + 0.5) / 17;
            var sx = front(sy, w, h, sweep, time);
            ctx.beginPath(); ctx.moveTo(sx - w * 0.014, sy + h * 0.003);
            ctx.lineTo(sx + w * 0.045, sy - h * 0.006); ctx.lineTo(sx + w * 0.10, sy);
            ctx.strokeStyle = "rgba(101,134,125,0.23)"; ctx.lineWidth = 1.1; ctx.stroke();
        }
        ctx.restore();
    }
    function paint(self, elapsed) {
        var tide = self._afeixDreamTide;
        if (!tide) return;
        var vw = Math.max(1, window.innerWidth), vh = Math.max(1, window.innerHeight);
        var width = Math.min(1280, vw), height = Math.round(width * vh / vw);
        if (tide.canvas.width !== width || tide.canvas.height !== height) {
            tide.canvas.width = width; tide.canvas.height = height;
        }
        var ctx = tide.ctx;
        ctx.clearRect(0, 0, width, height);
        var sweep = clamp(elapsed / tide.sweepSeconds);
        paintSweep(ctx, width, height, sweep, elapsed, tide.direction);
        var black = ease((elapsed - tide.fadeAt) / (tide.duration - tide.fadeAt));
        if (black > 0) { ctx.fillStyle = "rgba(0,0,0," + black + ")"; ctx.fillRect(0, 0, width, height); }
    }
    proto.afeixStopDreamTide = function (data) {
        var token = data && data.Token;
        if (typeof token === "number") this._afeixDreamTideFence = Math.max(this._afeixDreamTideFence || 0, token);
        var tide = this._afeixDreamTide;
        // A delayed stop from an older battle must not clear a newer tableau.
        if (!tide || (typeof token === "number" && token < tide.token)) return;
        this._afeixDreamTideFence = Math.max(this._afeixDreamTideFence || 0, tide.token);
        if (tide.canvas.parentNode) tide.canvas.parentNode.removeChild(tide.canvas);
        this._afeixDreamTide = null;
    };
    proto.afeixStartDreamTide = function (data) {
        if (!data || typeof data.Token !== "number" || data.Token <= (this._afeixDreamTideFence || 0)) return;
        if (this._afeixDreamTide && data.Token <= this._afeixDreamTide.token) return;
        this.afeixStopDreamTide(null);
        // Native disconnect may beat an already queued start message.
        if (this.mSQHandle === null) { this._afeixDreamTideFence = data.Token; return; }
        var canvas = document.createElement("canvas"), ctx = canvas.getContext("2d");
        if (!ctx) { this._afeixDreamTideFence = data.Token; return; }
        canvas.id = "afeix-dream-black-tide";
        canvas.style.position = "fixed"; canvas.style.left = "0"; canvas.style.top = "0";
        canvas.style.width = "100%"; canvas.style.height = "100%";
        canvas.style.zIndex = "5"; canvas.style.pointerEvents = "none";
        // Keep it outside the hidden tactical controls container.
        document.body.appendChild(canvas);
        this._afeixDreamTide = { token: data.Token, canvas: canvas, ctx: ctx, elapsed: -1,
            sweepSeconds: data.SweepSeconds, direction: data.Direction === "left-to-right" ? "left-to-right" : "right-to-left", fadeAt: data.FadeAt, duration: data.Duration };
        paint(this, 0);
    };
    proto.afeixDreamTideFrame = function (data) {
        var tide = this._afeixDreamTide;
        if (!tide || !data || data.Token !== tide.token || typeof data.Elapsed !== "number"
            || !isFinite(data.Elapsed) || data.Elapsed < tide.elapsed) return;
        tide.elapsed = Math.max(0, data.Elapsed);
        paint(this, tide.elapsed);
    };
    var disconnect = proto.onDisconnection;
    proto.onDisconnection = function () {
        this.afeixStopDreamTide(null);
        return disconnect.apply(this, arguments);
    };
    var destroy = proto.destroyDIV;
    proto.destroyDIV = function () {
        this.afeixStopDreamTide(null);
        return destroy.apply(this, arguments);
    };
}());
