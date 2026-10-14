"""Build a temporary, local-only tavern menu probe with campaign saving disabled."""
from pathlib import Path
from zipfile import ZIP_DEFLATED, ZipFile
import argparse

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--campaign-copy', required=True)
args = parser.parse_args()
assert args.campaign_copy.replace('-', '').replace('_', '').isalnum()
source = (HERE / 'probe.nut').read_text(encoding='utf-8').replace('/*CAMPAIGN_COPY*/', args.campaign_copy)
out = ROOT / 'build/company-ledger-fix-20261013/mod_afeix_company_menu_probe.zip'
out.parent.mkdir(parents=True, exist_ok=True)
with ZipFile(out, 'w', ZIP_DEFLATED) as archive:
    archive.writestr('scripts/!mods_preload/mod_afeix_company_menu_probe.nut', '''
::mods_registerMod("mod_afeix_company_menu_probe", 1, "AFEIX temporary company menu probe");
::mods_queue("mod_afeix_company_menu_probe", ">mod_afeix_expedition, >mod_afeix_dlc_afei_skins", function() {
    ::include("scripts/mods/afeix_company_menu_probe");
});
''')
    archive.writestr('scripts/mods/afeix_company_menu_probe.nut', source)
with ZipFile(out) as archive:
    assert archive.testzip() is None
print(out)
