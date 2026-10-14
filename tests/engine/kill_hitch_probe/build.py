"""Build a local death-callback profiler; uses only an unsaved campaign copy."""
from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED
import argparse

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[2]
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--campaign-copy',required=True)
a=p.parse_args()
assert a.campaign_copy.replace('-', '').replace('_', '').isalnum()
campaign=(HERE.parent/'turnbar_probe/campaign.nut').read_text(encoding='utf-8')
campaign=campaign[:campaign.index('::mods_hookExactClass("states/tactical_state"')]
campaign=campaign.replace('/*CAMPAIGN_COPY*/',a.campaign_copy)
out=ROOT/'build/kill-hitch-20261014/mod_afeix_kill_hitch_probe.zip'
out.parent.mkdir(parents=True,exist_ok=True)
with ZipFile(out,'w',ZIP_DEFLATED) as z:
    z.writestr('scripts/!mods_preload/mod_afeix_kill_hitch_probe.nut','''
::mods_registerMod("mod_afeix_kill_hitch_probe", 1, "AFEIX temporary kill timing probe");
::mods_queue("mod_afeix_kill_hitch_probe", ">mod_afeix_expedition, >mod_afeix_dlc_afei_skins", function(){
    ::include("scripts/mods/afeix_kill_campaign");
    ::include("scripts/mods/afeix_kill_profile");
});
''')
    z.writestr('scripts/mods/afeix_kill_campaign.nut',campaign)
    z.write(HERE/'profile.nut','scripts/mods/afeix_kill_profile.nut')
with ZipFile(out) as z:assert z.testzip() is None
print(out)
