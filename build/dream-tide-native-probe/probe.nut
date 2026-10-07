::mods_registerMod("mod_afeix_tide_probe", 1, "Temporary tide viewport probe");
::mods_queue("mod_afeix_tide_probe", ">mod_afeix_expedition", function() {
    ::mods_hookExactClass("ui/screens/menu/main_menu_screen", function(o) {
        o.afeixTideProbe <- function(data) { ::logInfo("AFEIX_TIDE_PROBE " + data); };
        o.afeixTideViewport <- function() { local v=::Settings.getVideoMode();this.m.JSHandle.asyncCall("afeixSetTideViewport", { Width = v.Width, Height = v.Height, UIScale = v.UIScale }); };
        o.afeixTideResize <- function(data) { local v=::Settings.getVideoMode();v.Width=data[0];v.Height=data[1];if(data.len()>2)v.UIScale=data[2];::Settings.setVideoMode(v);this.afeixTideViewport(); };
    });
    ::mods_registerJS("afeix/tide_probe.js");
});
