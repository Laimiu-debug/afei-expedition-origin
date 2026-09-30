"""Check/package the optional voice DLC without changing the main mod or installing it."""
from pathlib import Path
from zipfile import ZipFile, ZipInfo, ZIP_DEFLATED
import argparse
import hashlib
import json
import re
import shutil
import subprocess
import tempfile
import wave

DLC = Path(__file__).resolve().parent
ROOT = DLC.parents[1]
PREFIX = "sounds/afeix_dlc_afei_voice/"


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run(command, cwd):
    result = subprocess.run([str(item) for item in command], cwd=cwd, capture_output=True)
    output = (result.stdout + result.stderr).decode("utf-8", errors="replace")
    if result.returncode or "AN ERROR HAS OCCUR" in output:
        raise RuntimeError(output)
    return output


def method(source, name):
    """Extract a native method verbatim; generated fixtures never enter the ZIP."""
    start = source.index("\tfunction " + name + "(")
    opening = source.index("{", start)
    depth = 1
    cursor = opening + 1
    while depth:
        depth += (source[cursor] == "{") - (source[cursor] == "}")
        cursor += 1
    return source[start:cursor]


def clips():
    config = (DLC / "src/scripts/mods/afeix_dlc_afei_voice/config.nut").read_text(encoding="utf-8")
    config = re.sub(r"//[^\n]*", "", config)
    block = re.search(r"HurtSounds\s*<-\s*\[([^\]]*)\]", config)
    if not block:
        raise ValueError("HurtSounds must be a literal list of WAV paths")
    paths = re.findall(r'"([^"\n]+)"', block[1])
    if re.sub(r'"[^"\n]+"|[\s,]', "", block[1]) or len(set(paths)) != len(paths):
        raise ValueError("Invalid or duplicate HurtSounds entries")
    volume = re.search(r"VolumeMult\s*<-\s*([0-9.]+)\s*;", config)
    if not volume or not 0 < float(volume[1]) <= 2:
        raise ValueError("VolumeMult must be greater than 0 and at most 2")
    report = []
    for relative in paths:
        if not re.fullmatch(re.escape(PREFIX) + r"[a-z0-9_]+\.wav", relative):
            raise ValueError("Voice WAV path must stay in the DLC sound directory: " + relative)
        path = DLC / "src" / relative
        with wave.open(str(path), "rb") as audio:
            duration = audio.getnframes() / audio.getframerate()
            if (audio.getnchannels() != 1 or audio.getsampwidth() != 2
                    or audio.getframerate() not in (44100, 48000) or not 0.1 <= duration <= 2.0):
                raise ValueError("Use short mono 16-bit PCM WAV at 44100/48000 Hz: " + relative)
            pcm = audio.readframes(audio.getnframes())
            if len(pcm) != audio.getnframes() * 2:
                raise ValueError("Truncated voice WAV: " + relative)
        report.append({"path": relative, "duration_seconds": duration, "sha256": sha(path)})
    return report


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="Validate framework; permit missing voice clips")
    parser.add_argument("--base", type=Path, default=ROOT)
    parser.add_argument("--kit", type=Path)
    parser.add_argument("--game", type=Path, default=Path("F:/SteamLibrary/steamapps/common/Battle Brothers"))
    args = parser.parse_args()
    base = args.base.resolve()
    kit = (args.kit or base / ".cache/afei-art/bbros-modkit-v9/bin").resolve()
    preload = base / "src/scripts/!mods_preload/mod_afeix_expedition.nut"
    version = re.search(r"Version\s*=\s*(\d+)", preload.read_text(encoding="utf-8"))
    if not version or int(version[1]) < 36:
        raise ValueError("Afei Voice DLC needs main mod internal version 36 or newer")
    base_files = [p for p in (base / "src").rglob("*") if p.is_file()]
    before = {p.relative_to(base).as_posix(): sha(p) for p in base_files}
    audio = clips()
    files = sorted(p for p in (DLC / "src").rglob("*") if p.is_file())
    entries = [p.relative_to(DLC / "src").as_posix() for p in files]
    collisions = [name for name in entries if (base / "src" / name).exists()]
    if collisions:
        raise ValueError("DLC must not overwrite main-package files: " + repr(collisions))
    audio_paths = {row["path"] for row in audio}
    if any(p.suffix != ".nut" and name not in audio_paths for p, name in zip(files, entries)):
        raise ValueError("Unexpected/unregistered file in DLC src")
    cache = base / ".cache"
    cache.mkdir(exist_ok=True)
    scratch = Path(tempfile.mkdtemp(prefix="afei-voice-", dir=cache))
    (scratch / "native").mkdir()
    shutil.copytree(DLC / "src", scratch / "src")
    shutil.copy2(DLC / "tests/voice.nut", scratch / "voice.nut")
    with ZipFile(args.game.resolve() / "data/data_001.dat") as archive:
        for name in ("human", "actor"):
            bytecode = scratch / "native" / (name + ".cnut")
            bytecode.write_bytes(archive.read("scripts/entity/tactical/" + name + ".cnut"))
            run([kit / "bbsq.exe", "-d", bytecode], scratch)
            decoded = run([kit / "nutcracker.exe", bytecode], scratch)
            bytecode.with_suffix(".nut").write_text(decoded, encoding="utf-8")
    native_actor = (scratch / "native/actor.nut").read_text(encoding="utf-8")
    (scratch / "native/voice_resources.nut").write_text(
        "this.nativeVoiceResources <- {\n" + method(native_actor, "loadResources") + "\n};\n", encoding="utf-8")
    scripts = [p for p in files if p.suffix == ".nut"]
    for path in scripts:
        run([kit / "sq.exe", "-c", "-o", scratch / "compile.cnut", path], scratch)
    output = run([kit / "sq.exe", "voice.nut"], scratch)
    passed = re.search(r"TESTS_PASSED=(\d+)", output)
    if not passed:
        raise RuntimeError(output)
    after = {p.relative_to(base).as_posix(): sha(p) for p in (base / "src").rglob("*") if p.is_file()}
    if before != after:
        raise ValueError("Main-package source changed during validation; review concurrent changes")
    report = {"version": (DLC / "VERSION").read_text().strip(), "status": "ready_for_audio_review" if audio else "awaiting_original_voice_clips",
        "minimum_base_internal": 36, "verified_base_internal": int(version[1]),
        "base_preload_sha256": before[preload.relative_to(base).as_posix()],
        "base_source_unchanged": True, "base_path_collisions": collisions, "scripts_compiled": len(scripts),
        "behavior_assertions": int(passed[1]), "test_output": output, "clips": audio,
        "entries": entries, "package_ready": bool(audio), "in_game_tested": False,
        "installed": False, "published": False}
    if not args.check and audio:
        destination = DLC / "dist" / ("mod_afeix_dlc_afei_voice v" + report["version"] + ".zip")
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
    print(f"PASS: {report['behavior_assertions']} assertions, {len(scripts)} scripts; main source unchanged.")
    if not audio:
        print("Awaiting original Afei voice clips; no installable package generated.")
        if not args.check:
            raise SystemExit("Packaging blocked: add reviewed original voice WAVs and register HurtSounds first.")
    elif not args.check:
        print(destination)


if __name__ == "__main__":
    main()
