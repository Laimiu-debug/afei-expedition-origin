// Temporary diagnostic only. No campaign flags, saves, random rolls or rules.
::AfeixFirstMove <- {
    Armed = false, Active = false, Disabled = false, WindowSeconds = 12.0,
    StartExact = 0, StartReal = 0.0, LastFrameReal = null, MaxFrameGap = 0.0,
    Frames = 0, Rows = {}, Serial = 0,
    function log(message) { ::logInfo("AFEIX_FIRST_MOVE " + message); },
    function reset(reason) {
        if (this.Active) this.finish("reset");
        this.Armed = true; this.Active = false; this.Disabled = false;
        this.Rows = {}; this.Frames = 0; this.LastFrameReal = null;
        this.MaxFrameGap = 0.0; this.Serial++;
        this.log("armed run=" + this.Serial + " reason=" + reason);
    },
    function begin(reason) {
        if (!this.Armed || this.Active || this.Disabled) return false;
        // getExactTime is present in the local 1.5.2.3 executable. Log raw
        // ticks and calibrate against the frame clock rather than assume units.
        try {
            this.StartExact = ::Time.getExactTime();
            if (typeof this.StartExact != "float" && typeof this.StartExact != "integer") throw "non-numeric exact clock";
        } catch (error) {
            this.Disabled = true; this.Armed = false;
            this.log("disabled reason=exact_clock_unavailable");
            return false;
        }
        this.StartReal = ::Time.getRealTimeF();
        this.LastFrameReal = this.StartReal;
        this.Armed = false; this.Active = true;
        this.log("begin run=" + this.Serial + " reason=" + reason);
        return true;
    },
    function record(name, ticks, failed = false) {
        if (!(name in this.Rows)) this.Rows[name] <- { calls = 0, total = 0.0, maximum = 0.0, errors = 0 };
        local row = this.Rows[name];
        row.calls++; row.total += ticks;
        if (ticks > row.maximum) row.maximum = ticks;
        if (failed) row.errors++;
    },
    function measure(name, original, environment, args) {
        if (!this.Active) return original.bindenv(environment).acall(args);
        // A begin with no matching end identifies a callback that never returned.
        local first = !(name in this.Rows), start = ::Time.getExactTime();
        if (first) this.log("scope_begin name=" + name);
        local result = null;
        try { result = original.bindenv(environment).acall(args); }
        catch (error) {
            this.record(name, ::Time.getExactTime() - start, true);
            if (this.Rows[name].errors <= 3) this.log("exception name=" + name + " message=" + error);
            throw error;
        }
        this.record(name, ::Time.getExactTime() - start);
        if (first) this.log("scope_end name=" + name);
        return result;
    },
    function moving(state) {
        local player = state.getPlayer();
        return player != null && (player.m.Destination != null || player.m.Path != null
            || state.m.AutoAttack != null || state.m.AutoEnterLocation != null);
    },
    function frame(state) {
        if (this.Armed && ::AfeixExpedition.isOrigin() && (this.moving(state) || !state.isPaused())) this.begin("first_unpause_or_move");
        if (!this.Active) return;
        local now = ::Time.getRealTimeF();
        if (this.LastFrameReal != null && now - this.LastFrameReal > this.MaxFrameGap) this.MaxFrameGap = now - this.LastFrameReal;
        this.LastFrameReal = now; this.Frames++;
        if (now - this.StartReal >= this.WindowSeconds) this.finish("window_complete");
    },
    function finish(reason) {
        if (!this.Active) return;
        this.Active = false;
        local exact = ::Time.getExactTime() - this.StartExact;
        local real = ::Time.getRealTimeF() - this.StartReal;
        foreach (name, row in this.Rows)
            this.log("metric run=" + this.Serial + " name=" + name + " calls=" + row.calls
                + " total_ticks=" + row.total + " max_ticks=" + row.maximum + " errors=" + row.errors);
        this.log("summary run=" + this.Serial + " reason=" + reason + " frames=" + this.Frames
            + " real_s=" + real + " exact_ticks=" + exact + " max_frame_gap_s=" + this.MaxFrameGap);
    }
};
