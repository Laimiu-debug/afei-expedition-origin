"""Build one installable ZIP from the validated skins and voice DLCs."""
from pathlib import Path
from zipfile import ZipFile, ZipInfo, ZIP_DEFLATED
import argparse
import hashlib
import importlib.util
import json
import re
import subprocess
import sys
import tempfile

DLC = Path(__file__).resolve().parent
ROOT = DLC.parents[1]
KIT = ROOT / '.cache/afei-art/bbros-modkit-v9/bin'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def fingerprints(root):
    return {p.relative_to(root).as_posix(): sha(p)
            for p in sorted(root.rglob('*')) if p.is_file()}


def run(command, cwd=ROOT):
    result = subprocess.run([str(v) for v in command], cwd=cwd, capture_output=True)
    output = (result.stdout + result.stderr).decode('utf-8', errors='replace')
    if result.returncode or 'AN ERROR HAS OCCUR' in output or 'FAIL ' in output:
        raise RuntimeError(output)
    return output


def load_module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def report_package_sha(report):
    package = report.get('package')
    return package.get('sha256') if isinstance(package, dict) else report.get('package_sha256')


def build_component(key, game):
    directory = ROOT / 'dlc' / key
    report_path = directory / 'report.json'
    previous = json.loads(report_path.read_text(encoding='utf-8')) if report_path.exists() else {}
    command = [sys.executable, directory / 'build.py']
    if key == 'afei-voice':
        command += ['--game', game]
    print(run(command).strip(), flush=True)
    current = json.loads(report_path.read_text(encoding='utf-8'))
    # Revalidating identical bytes must not erase the component's publication,
    # installation or audio-review evidence. New bytes retain fresh statuses.
    if report_package_sha(previous) == report_package_sha(current):
        current = dict(previous, **current)
        for flag in ('published', 'installed'):
            if flag in previous:
                current[flag] = previous[flag]
        report_path.write_text(json.dumps(current, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def collect_components():
    """Read flat, audited archives; reject stale, duplicate or unexpected files."""
    files, folded, components = {}, {}, []
    for key in ('afei-skins', 'afei-voice'):
        directory = ROOT / 'dlc' / key
        report = json.loads((directory / 'report.json').read_text(encoding='utf-8'))
        skins = key == 'afei-skins'
        package = ROOT / (report['package']['path'] if skins else report['package'])
        expected_sha = report['package']['sha256'] if skins else report['package_sha256']
        expected = fingerprints(directory / 'src')
        if sha(package) != expected_sha:
            raise ValueError('Component package differs from its validated report: ' + key)
        with ZipFile(package) as archive:
            names = archive.namelist()
            if archive.testzip() or len(names) != len(set(names)) or sorted(names) != sorted(expected):
                raise ValueError('Component CRC/entry-set mismatch: ' + key)
            for name in names:
                if (name.startswith('/') or '\\' in name or '..' in name.split('/')
                        or Path(name).suffix not in {'.nut', '.png', '.brush', '.wav'}):
                    raise ValueError('Unexpected install path: ' + name)
                data = archive.read(name)
                if hashlib.sha256(data).hexdigest() != expected[name]:
                    raise ValueError('Stale component package: ' + key + '/' + name)
                if name.casefold() in folded:
                    raise ValueError('Duplicate install path: ' + name + ' / ' + folded[name.casefold()])
                if (ROOT / 'src' / name).exists():
                    raise ValueError('Bundle overwrites the main mod: ' + name)
                files[name] = data
                folded[name.casefold()] = name
        components.append(dict(name=key, version=report['version'], package=package.relative_to(ROOT).as_posix(),
            sha256=sha(package), entries=len(expected),
            assertions=sum(t['assertions'] for t in report['validation']['tests']) if skins else report['behavior_assertions'],
            scripts_compiled=report['validation']['scripts_compiled'] if skins else report['scripts_compiled']))
    return files, components


def write_package(path, files):
    with ZipFile(path, 'w', ZIP_DEFLATED) as archive:
        for name, data in sorted(files.items()):
            info = ZipInfo(name, (2026, 10, 2, 0, 0, 0))
            info.compress_type = ZIP_DEFLATED
            archive.writestr(info, data)
    with ZipFile(path) as archive:
        if archive.testzip() or sorted(archive.namelist()) != sorted(files):
            raise ValueError('Bundle CRC/entry-set mismatch')
        for name, data in files.items():
            if archive.read(name) != data:
                raise ValueError('Bundle changes component bytes: ' + name)


def combined_tests(stage, package, game):
    """Run real bundled preloads together in both valid sibling load orders."""
    combined = stage / 'combined'
    with ZipFile(package) as archive:
        archive.extractall(combined)
    voice = load_module('afei_bundle_voice', ROOT / 'dlc/afei-voice/build.py')
    methods = []
    with ZipFile(game / 'data/data_001.dat') as archive:
        for name, method in [('human', 'playSound'), ('actor', 'loadResources')]:
            bytecode = stage / (name + '.cnut')
            bytecode.write_bytes(archive.read('scripts/entity/tactical/' + name + '.cnut'))
            run([KIT / 'bbsq.exe', '-d', bytecode], stage)
            methods.append(voice.method(run([KIT / 'nutcracker.exe', bytecode], stage), method))
    native = stage / 'native_voice.nut'
    native.write_text('::bundleNativeVoice <- {\n' + '\n'.join(methods) + '\n};\n', encoding='utf-8')
    runtime = (ROOT / 'dlc/afei-skins/tests/runtime.nut').read_text(encoding='utf-8')
    old = ('    dofile("dlc/afei-skins/src/scripts/mods/afeix_dlc_afei_skins/content.nut");\n'
           '    dofile("dlc/afei-skins/src/scripts/mods/afeix_dlc_afei_skins/hooks.nut");')
    setup = (DLC / 'tests/load_both.nut').read_text(encoding='utf-8')
    behavior = (DLC / 'tests/combined.nut').read_text(encoding='utf-8')
    marker = '    print("DLC_SKINS_RUNTIME_CHECKS_PASS\\n");'
    if runtime.count(old) != 1 or runtime.count(marker) != 1:
        raise ValueError('Skins fixture changed; review bundle adapter')
    runtime = runtime.replace(old, setup).replace(marker, behavior + '\n' + marker)
    fixture = (ROOT / 'tests/gameplay/test_appearance.nut').read_text(encoding='utf-8')
    marker = '    print("ALL_APPEARANCE_BEHAVIOR_CHECKS_PASS'
    if fixture.count(marker) != 1:
        raise ValueError('Base fixture changed; review bundle adapter')
    fixture = fixture.replace(marker, runtime + '\n' + marker)
    results = []
    for voice_first in (False, True):
        path = stage / ('voice_first.nut' if voice_first else 'skins_first.nut')
        path.write_text('::bundleSource <- ' + json.dumps(combined.as_posix()) + ';\n'
            + '::bundleVoiceFirst <- ' + str(voice_first).lower() + ';\n'
            + 'dofile(' + json.dumps(native.as_posix()) + ');\n' + fixture, encoding='utf-8')
        output = run([KIT / 'sq.exe', path])
        match = re.search(r'TESTS_PASSED=(\d+)', output)
        if not match or 'BUNDLE_COMBINED_CHECKS_PASS' not in output:
            raise ValueError(output)
        results.append(dict(order='voice_then_skins' if voice_first else 'skins_then_voice',
                            assertions=int(match[1]), output=output.strip()))
    return results


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true', help='Validate without writing the bundle ZIP')
    parser.add_argument('--game', type=Path, default=Path('F:/SteamLibrary/steamapps/common/Battle Brothers'))
    args = parser.parse_args()
    report_path = DLC / 'report.json'
    previous = json.loads(report_path.read_text(encoding='utf-8')) if report_path.exists() else {}
    before = fingerprints(ROOT / 'src')
    for key in ('afei-skins', 'afei-voice'):
        build_component(key, args.game)
    files, components = collect_components()
    audit = load_module('afei_bundle_compatibility', ROOT / 'dlc/events/compatibility.py')
    compatibility = audit.inspect_packages(ROOT, ROOT / 'dlc/events')
    version = (DLC / 'VERSION').read_text(encoding='utf-8').strip()
    if not re.fullmatch(r'\d+\.\d+\.\d+', version):
        raise ValueError('Invalid bundle version')
    with tempfile.TemporaryDirectory(prefix='afei-bundle-', dir=ROOT / '.cache') as temp:
        stage = Path(temp)
        package = stage / ('mod_afeix_dlc_afei_bundle v' + version + '.zip')
        write_package(package, files)
        tests = combined_tests(stage, package, args.game.resolve())
        if fingerprints(ROOT / 'src') != before:
            raise ValueError('Main source changed during bundle build; review concurrent changes')
        report = dict(version=version, minimum_base='0.28.12 / internal 62', components=components,
            validation=dict(component_assertions=sum(c['assertions'] for c in components), combined_tests=tests,
                scripts_compiled=sum(c['scripts_compiled'] for c in components), compatibility=compatibility),
            entries=sorted(files), entry_sha256={n: hashlib.sha256(v).hexdigest() for n, v in sorted(files.items())},
            package_bytes=package.stat().st_size, package_sha256=sha(package),
            crc_passed=True, component_bytes_unchanged=True, main_src_unchanged=True,
            in_game_tested=False, installed=False, published=False)
        if not args.check:
            destination = DLC / 'dist' / package.name
            destination.parent.mkdir(parents=True, exist_ok=True)
            package.replace(destination)
            report['package'] = destination.relative_to(ROOT).as_posix()
            destination.with_suffix('.sha256').write_text(
                sha(destination) + '  ' + destination.name + '\n', encoding='utf-8')
    if previous.get('package_sha256') == report['package_sha256']:
        report = dict(previous, **report)
        for flag in ('published', 'installed'):
            if flag in previous:
                report[flag] = previous[flag]
    report_path.write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(json.dumps(dict(package=report.get('package'), bytes=report['package_bytes'], entries=len(files),
        component_assertions=report['validation']['component_assertions'],
        combined_assertions=[t['assertions'] for t in tests], main_src_unchanged=True), ensure_ascii=False))


if __name__ == '__main__':
    main()
