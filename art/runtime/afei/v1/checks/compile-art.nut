local failed=0;
try { loadfile("G:/CODE/afei-xcpedition/art/runtime/afei/v1/package/scripts/!mods_preload/mod_afei_art_v1.nut", true); print("PASS mod_afei_art_v1.nut\n"); } catch(e) {print("FAIL mod_afei_art_v1.nut: "+e+"\n");failed++;}
try { loadfile("G:/CODE/afei-xcpedition/art/runtime/afei/v1/package/scripts/mods/afei_art_v1/appearance.nut", true); print("PASS appearance.nut\n"); } catch(e) {print("FAIL appearance.nut: "+e+"\n");failed++;}
try { loadfile("G:/CODE/afei-xcpedition/art/runtime/afei/v1/package/scripts/mods/afei_art_v1/hooks.nut", true); print("PASS hooks.nut\n"); } catch(e) {print("FAIL hooks.nut: "+e+"\n");failed++;}
try { loadfile("G:/CODE/afei-xcpedition/art/runtime/afei/v1/package/scripts/scenarios/world/afeix_art_preview_scenario.nut", true); print("PASS afeix_art_preview_scenario.nut\n"); } catch(e) {print("FAIL afeix_art_preview_scenario.nut: "+e+"\n");failed++;}
print("FAILURES="+failed+"\n");
