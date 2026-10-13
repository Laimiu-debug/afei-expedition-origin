"""Build a local-only probe using the installed game's actual portrait factory."""
from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED
import argparse

ROOT = Path(__file__).resolve().parents[3]
HERE = Path(__file__).resolve().parent
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--game', type=Path, required=True)
parser.add_argument('--combat', action='store_true', help='Auto-start an isolated native ghost scenario with passive UI tracing')
parser.add_argument('--fault', action='store_true', help='Return empty portrait selector matches after the third native activation; requires --combat')
parser.add_argument('--campaign-copy', help='Auto-load the named copied campaign (basename without .sav); disables campaign saving')
args = parser.parse_args()
if args.fault and not args.combat:
    parser.error('--fault requires --combat')
if args.campaign_copy and (args.combat or args.fault):
    parser.error('--campaign-copy is separate from --combat/--fault')
if args.campaign_copy and not args.campaign_copy.replace('-', '').replace('_', '').isalnum():
    parser.error('Use a simple copied campaign basename')
with ZipFile(args.game / 'data/data_001.dat') as archive:
    native = archive.read('ui/screens/tactical/modules/tactical_screen_turnsequencebar/turnsequencebar_module.js').decode('utf-8')
start = native.index('TacticalScreenTurnSequenceBarModule.prototype.createEntityDIV = ')
end = native.index('TacticalScreenTurnSequenceBarModule.prototype.addSkillToList = ', start)
factory = native[start:end].split(' = ', 1)[1].strip()
source = (HERE / 'probe.js').read_text(encoding='utf-8').replace('/*NATIVE_FACTORY*/', factory)
if args.combat or args.campaign_copy:
    methods = ['createEntityDIV', 'updateEntityImage', 'selectFirstEntity', 'removeEntity', 'notifyBackendEntityEnteredFirstSlotFully']
    definitions = []
    for method in methods:
        start = native.index('TacticalScreenTurnSequenceBarModule.prototype.' + method + ' = ')
        end = native.find('TacticalScreenTurnSequenceBarModule.prototype.', start + 1)
        definitions.append(native[start:end] if end >= 0 else native[start:])
    source += '\n' + (HERE / 'trace.js').read_text(encoding='utf-8').replace('/*RESTORE_NATIVE_METHODS*/', '\n'.join(definitions))
    if args.campaign_copy:
        source += '\n' + (HERE / 'query_trace.js').read_text(encoding='utf-8')
    if args.fault:
        source += '\n' + (HERE / 'fault.js').read_text(encoding='utf-8')
out = ROOT / 'build/turnbar-engine-probe/mod_afeix_turnbar_engine_probe.zip'
out.parent.mkdir(parents=True, exist_ok=True)
preload = '''::mods_registerMod("mod_afeix_turnbar_engine_probe", 1, "AFEIX temporary UI engine probe");
::mods_queue("mod_afeix_turnbar_engine_probe", ">mod_afeix_expedition", function() {
    ::mods_registerJS("afeix_turnbar_engine_probe.js");
    /*AUTO_SCENARIO*/
});
'''
include = '::include("scripts/mods/afeix_probe_auto");' if args.combat else ''
if args.campaign_copy:
    include = '::include("scripts/mods/afeix_probe_campaign");'
preload = preload.replace('/*AUTO_SCENARIO*/', include)
with ZipFile(out, 'w', ZIP_DEFLATED) as archive:
    archive.writestr('scripts/!mods_preload/mod_afeix_turnbar_engine_probe.nut', preload)
    archive.writestr('ui/mods/afeix_turnbar_engine_probe.js', source)
    if args.combat:
        archive.write(HERE / 'auto.nut', 'scripts/mods/afeix_probe_auto.nut')
        archive.write(HERE / 'scenario.nut', 'scripts/scenarios/tactical/scenario_afeix_ghost_probe.nut')
    if args.campaign_copy:
        campaign = (HERE / 'campaign.nut').read_text(encoding='utf-8').replace('/*CAMPAIGN_COPY*/', args.campaign_copy)
        archive.writestr('scripts/mods/afeix_probe_campaign.nut', campaign)
with ZipFile(out) as archive:
    assert archive.testzip() is None
    assert archive.read('ui/mods/afeix_turnbar_engine_probe.js').decode('utf-8') == source
(ROOT / '.cache/afei-art/geist-turnbar/engine-probe.js').write_text(source, encoding='utf-8')
print(out)
