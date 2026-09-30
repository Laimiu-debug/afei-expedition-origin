"""Inject conflicting project packages to verify the build refuses them."""
from pathlib import Path
import sys
import tempfile

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from compatibility import inspect_packages


MAIN = '::mods_registerMod("mod_afeix_expedition",55,"Main");\n::mods_queue("mod_afeix_expedition",null,function(){});\n'
EVENTS = '::mods_registerMod("mod_afeix_dlc_events",1,"Events");\n::mods_queue("mod_afeix_dlc_events","mod_afeix_expedition(>=54), >mod_afeix_expedition",function(){});\n'
OTHER = '::mods_registerMod("mod_other",1,"Other");\n::mods_queue("mod_other",">mod_afeix_expedition",function(){});\n'


def main():
    passed = 0
    with tempfile.TemporaryDirectory(prefix="compatibility-") as directory:
        base = Path(directory)
        own = base / "dlc/events"

        def put(relative, value):
            path = base / relative
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(value, encoding="utf-8")
            return path

        main_path = put("src/scripts/!mods_preload/main.nut", MAIN)
        own_path = put("dlc/events/src/scripts/!mods_preload/events.nut", EVENTS)
        other_path = put("dlc/other/src/scripts/!mods_preload/other.nut", OTHER)
        put("dlc/events/src/scripts/events/afeix_event.nut", 'this.m.ID="event.afeix_dlc_events";')
        report = inspect_packages(base, own)
        assert len(report["project_mod_ids"]) == 3 and not report["dependency_cycles"]
        passed += 1

        def reject(label):
            nonlocal passed
            try:
                inspect_packages(base, own)
            except ValueError:
                passed += 1
                return
            raise AssertionError("Did not reject " + label)

        other_path.write_text(OTHER.replace('"mod_other"', '"mod_afeix_dlc_events"'), encoding="utf-8")
        reject("duplicate Mod ID")
        other_path.write_text(OTHER, encoding="utf-8")
        duplicate = put("dlc/other/src/scripts/events/other.nut", 'this.m.ID="event.afeix_dlc_events";')
        reject("runtime event ID collision")
        duplicate.unlink()
        duplicate = put("dlc/other/src/SCRIPTS/EVENTS/AFEIX_EVENT.NUT", "// collision")
        reject("case-insensitive package path collision")
        duplicate.unlink()
        main_path.write_text(MAIN.replace("null", '">mod_afeix_dlc_events"'), encoding="utf-8")
        reject("main/events reverse dependency cycle")
        main_path.write_text(MAIN, encoding="utf-8")
        other_path.write_text(OTHER.replace(">mod_afeix_expedition", ">mod_fourth"), encoding="utf-8")
        fourth = put("dlc/fourth/src/scripts/!mods_preload/fourth.nut",
                     '::mods_registerMod("mod_fourth",1,"Fourth");::mods_queue("mod_fourth",">mod_other",function(){});')
        reject("cycle between sibling DLCs")
        fourth.unlink()
        other_path.write_text(OTHER, encoding="utf-8")
        own_path.write_text(EVENTS.replace('"mod_afeix_expedition(>=54), >mod_afeix_expedition"', "dynamicDeps"), encoding="utf-8")
        reject("unaudited dynamic dependency")
    print("COMPATIBILITY_TESTS_PASSED=" + str(passed))


if __name__ == "__main__":
    main()
