// Art-only runtime. Requires Legacy Modding Script Hooks; no campaign is selected.
::include("scripts/mods/afei_art_v1/appearance");

if (!("mods_registerMod" in getroottable()) || !("mods_queue" in getroottable()))
{
    ::logError("[AfeiArtV1] Legacy Modding Script Hooks is required.");
}
else
{
    ::mods_registerMod("mod_afei_art_v1", 1, "Afei Art V1 - Visual Test");
    ::mods_queue("mod_afei_art_v1", null, function()
    {
        ::include("scripts/mods/afei_art_v1/hooks");
    });
}
