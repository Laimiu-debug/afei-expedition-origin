"""Validate and package the independent travel/tavern event DLC, including an empty framework."""
from pathlib import Path
from zipfile import ZipFile, ZipInfo, ZIP_DEFLATED
import argparse
import hashlib
import json
import re
import shutil
import subprocess
import sys
import tempfile
from compatibility import inspect_packages, hooks_runner

DLC = Path(__file__).resolve().parent
ROOT = DLC.parents[1]


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run(command, cwd):
    result = subprocess.run([str(item) for item in command], cwd=cwd, capture_output=True, timeout=60)
    output = (result.stdout + result.stderr).decode("utf-8", errors="replace")
    if result.returncode or "AN ERROR HAS OCCUR" in output or "FAIL " in output:
        raise RuntimeError(output or f"Command failed: {command[0]}")
    return output


def method(source, name):
    start = source.index("\tfunction " + name + "(")
    opening = source.index("{", start)
    depth, cursor = 1, opening + 1
    while depth:
        depth += (source[cursor] == "{") - (source[cursor] == "}")
        cursor += 1
    return source[start:cursor]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="Check only; do not write a ZIP")
    parser.add_argument("--base", type=Path, default=ROOT)
    parser.add_argument("--kit", type=Path)
    parser.add_argument("--game", type=Path, default=Path("F:/SteamLibrary/steamapps/common/Battle Brothers"))
    args = parser.parse_args()
    base = args.base.resolve()
    kit = (args.kit or base / ".cache/afei-art/bbros-modkit-v9/bin").resolve()
    preload = base / "src/scripts/!mods_preload/mod_afeix_expedition.nut"
    version = re.search(r"Version\s*=\s*(\d+)", preload.read_text(encoding="utf-8"))
    if not version or int(version[1]) < 54:
        raise ValueError("Events DLC requires Afei Expedition v0.28.4/internal 54 or newer")
    before = {p.relative_to(base / "src").as_posix(): sha(p) for p in (base / "src").rglob("*") if p.is_file()}
    files = sorted(p for p in (DLC / "src").rglob("*") if p.is_file())
    entries = [p.relative_to(DLC / "src").as_posix() for p in files]
    if not files or any(p.suffix != ".nut" for p in files):
        raise ValueError("This framework packages Squirrel source only")
    collisions = sorted(set(entries) & set(before))
    for other in (base / "dlc").iterdir():
        if other.resolve() == DLC.resolve() or not (other / "src").is_dir():
            continue
        collisions += [str(other.name) + ":" + name for name in entries if (other / "src" / name).exists()]
    if collisions:
        raise ValueError("DLC paths collide with installed project packages: " + repr(collisions))
    compatibility = inspect_packages(base, DLC)
    compatibility_output = run([sys.executable, DLC / "tests/compatibility.py"], DLC)
    compatibility_passed = re.search(r"COMPATIBILITY_TESTS_PASSED=(\d+)", compatibility_output)
    if not compatibility_passed:
        raise RuntimeError(compatibility_output)
    compatibility["audit_regression_assertions"] = int(compatibility_passed[1])
    cache = base / ".cache"
    cache.mkdir(exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="afei-events-", dir=cache) as temporary:
        scratch = Path(temporary)
        native = scratch / "native"
        native.mkdir()
        shutil.copytree(DLC / "src", scratch / "src")
        shutil.copy2(DLC / "tests/events.nut", scratch / "events.nut")
        (scratch / "base_version.nut").write_text("::TestBaseInternal <- " + version[1] + ";\n", encoding="utf-8")
        shutil.copy2(base / "src/scripts/mods/afeix/hooks.nut", scratch / "base_hooks.nut")
        shutil.copy2(base / "src/scripts/mods/afeix/characters.nut", scratch / "base_characters.nut")
        native_hashes = {}
        graph_source = "modern_hooks/queue/mod_hooks_queue_graph.nut"
        graph_packages = []
        for package in sorted((args.game.resolve() / "data").glob("*.zip")):
            with ZipFile(package) as archive:
                if graph_source in archive.namelist():
                    graph_packages.append((package, archive.read(graph_source)))
        if len(graph_packages) != 1:
            raise ValueError("Need exactly one installed Hooks queue graph for dependency-cycle verification")
        graph_package, graph_bytes = graph_packages[0]
        (native / "hooks_queue_graph.nut").write_bytes(graph_bytes)
        (scratch / "queue.nut").write_text(hooks_runner(compatibility["queue_declarations"]), encoding="utf-8")
        queue_output = run([kit / "sq.exe", "queue.nut"], scratch)
        if "HOOKS_GRAPH_PASSED=3" not in queue_output:
            raise RuntimeError(queue_output)
        compatibility.update(native_hooks_graph_passed=True, native_hooks_graph_assertions=3,
            native_hooks_package=graph_package.name, native_hooks_graph_sha256=sha(native / "hooks_queue_graph.nut"))
        sources = {
            "event": "scripts/events/event.cnut",
            "event_manager": "scripts/events/event_manager.cnut",
            "world_state": "scripts/states/world_state.cnut",
            "tavern_building": "scripts/entity/world/settlements/buildings/tavern_building.cnut",
        }
        with ZipFile(args.game.resolve() / "data/data_001.dat") as archive:
            for name, path in sources.items():
                bytecode = native / (name + ".cnut")
                bytecode.write_bytes(archive.read(path))
                native_hashes[path] = sha(bytecode)
                run([kit / "bbsq.exe", "-d", bytecode], scratch)
                decoded = run([kit / "nutcracker.exe", bytecode], scratch)
                bytecode.with_suffix(".nut").write_text(decoded, encoding="utf-8")
        world = (native / "world_state.nut").read_text(encoding="utf-8")
        tavern = (native / "tavern_building.nut").read_text(encoding="utf-8")
        (native / "ui.nut").write_text("::nativeUI <- {\n" +
            method(world, "showEventScreen") + "\n" + method(world, "showEventScreenFromTown") + "\n};\n" +
            "::nativeTavern <- {\n" + method(tavern, "onClicked") + "\n};\n", encoding="utf-8")
        for path in files + list((DLC / "templates").glob("*.nut")):
            run([kit / "sq.exe", "-c", "-o", scratch / "compile.cnut", path], scratch)
        # Inspect actual production content through the real preload, before test
        # fixtures add synthetic events. This prevents shipping test dialogue.
        (scratch / "content_audit.nut").write_text(
            'dofile("base_version.nut");\n'
            '::AfeixExpedition <- {Version=::TestBaseInternal};\n'
            'dofile("base_characters.nut");\n'
            '::mods_registerMod <- function(...) {};\n'
            '::mods_queue <- function(id,deps,callback) {callback();};\n'
            '::mods_hookExactClass <- function(...) {};\n'
            '::activeIncludes <- {};\n'
            '::include <- function(path) {\n'
            '  if(path in ::activeIncludes) throw "Cyclic content include: "+path;\n'
            '  ::activeIncludes[path] <- true;\n'
            '  dofile("src/"+path+".nut");\n'
            '  delete ::activeIncludes[path];\n'
            '};\n'
            '::AfeixExpedition.openLedger <- function(...) {};\n'
            'dofile("src/scripts/!mods_preload/mod_afeix_dlc_events.nut");\n'
            'print("CONTENT_COUNT="+::AfeixEventsDLC.Order.len()+"\\n");\n'
            'foreach(id in ::AfeixEventsDLC.Order) print("SCENE="+id+"\\n");\n', encoding="utf-8")
        audit = run([kit / "sq.exe", "content_audit.nut"], scratch)
        count = re.search(r"CONTENT_COUNT=(\d+)", audit)
        if not count:
            raise RuntimeError(audit)
        output = run([kit / "sq.exe", "events.nut"], scratch)
        passed = re.search(r"TESTS_PASSED=(\d+)", output)
        if not passed:
            raise RuntimeError(output)
    after = {p.relative_to(base / "src").as_posix(): sha(p) for p in (base / "src").rglob("*") if p.is_file()}
    if before != after:
        raise ValueError("Main source changed during validation; review concurrent changes")
    report = {"version": (DLC / "VERSION").read_text().strip(),
        "status": "framework_only" if int(count[1]) == 0 else "content_ready_for_game_test",
        "content_count": int(count[1]), "scene_ids": re.findall(r"SCENE=([^\r\n]+)", audit),
        "minimum_base_internal": 54, "verified_base_internal": int(version[1]),
        "base_preload_sha256": before[preload.relative_to(base / "src").as_posix()],
        "base_hooks_sha256": before["scripts/mods/afeix/hooks.nut"],
        "base_source_unchanged": True, "path_collisions": collisions,
        "compatibility": compatibility, "content_include_cycles": [],
        "scripts_compiled": len(files), "template_scripts_compiled": len(list((DLC / "templates").glob("*.nut"))),
        "behavior_assertions": int(passed[1]), "test_output": output, "native_fixtures": native_hashes,
        "entries": entries, "in_game_tested": False, "installed": False, "published": False}
    if not args.check:
        destination = DLC / "dist" / ("mod_afeix_dlc_events v" + report["version"] + ".zip")
        destination.parent.mkdir(exist_ok=True)
        with ZipFile(destination, "w", ZIP_DEFLATED) as archive:
            for path, name in zip(files, entries):
                info = ZipInfo(name, (2026, 9, 30, 0, 0, 0))
                info.compress_type = ZIP_DEFLATED
                archive.writestr(info, path.read_bytes())
        with ZipFile(destination) as archive:
            if archive.testzip() or sorted(archive.namelist()) != entries:
                raise ValueError("ZIP CRC or entry-set validation failed")
            for path, name in zip(files, entries):
                if archive.read(name) != path.read_bytes():
                    raise ValueError("ZIP differs from DLC source: " + name)
        report.update(package=destination.relative_to(ROOT).as_posix(), package_sha256=sha(destination),
                      crc_passed=True, source_bytes_match=True)
        destination.with_suffix(".sha256").write_text(sha(destination) + "  " + destination.name + "\n", encoding="utf-8")
    (DLC / "report.json").write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"PASS: {report['behavior_assertions']} assertions; {len(files)} runtime scripts; {report['content_count']} authored events.")
    if not args.check:
        print(destination)


if __name__ == "__main__":
    main()
