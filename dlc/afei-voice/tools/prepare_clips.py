"""Reproduce candidate voice clips from the supplied video; never change the main mod."""
from array import array
from pathlib import Path
import argparse
import hashlib
import io
import json
import math
import shutil
import subprocess
import sys
import wave
from zipfile import ZipFile

DLC = Path(__file__).resolve().parents[1]
ROOT = DLC.parents[1]
RATE = 48000
# Two isolated shouts from the short video, plus standalone ASR-located
# exclamations from the full video. These are candidates for listening review.
CUTS = [('short', 2.70, 3.55), ('short', 13.85, 14.68),
        ('full', 86.67, 87.48), ('full', 188.03, 188.80), ('full', 287.00, 287.89)]
FILTER = "highpass=f=100,lowpass=f=6500,afftdn=nr=8:nf=-35:tn=0"
TARGET_RMS_DBFS = -12
PEAK_LIMIT_DBFS = -1
VOLUME_MULT = 1.0


def sha(path):
    digest = hashlib.sha256()
    with path.open('rb') as source:
        for block in iter(lambda: source.read(1024 * 1024), b''):
            digest.update(block)
    return digest.hexdigest()


def wav(path, pcm):
    path.parent.mkdir(parents=True, exist_ok=True)
    with wave.open(str(path), 'wb') as target:
        target.setnchannels(1)
        target.setsampwidth(2)
        target.setframerate(RATE)
        target.writeframes(pcm.tobytes())


def amplify_original_package(package):
    """Reuse verified original-pitch cuts without requiring the source videos."""
    archive_dir = DLC / 'audio/archive/v0.1.0'
    original = json.loads((archive_dir / 'source.json').read_text(encoding='utf-8'))
    base_report = json.loads((archive_dir / 'report.json').read_text(encoding='utf-8'))
    if sha(package) != base_report['package_sha256']:
        raise ValueError('Expected the archived original-pitch 0.1.0 package')
    preview = array('h', [0] * round(RATE * .25))
    rows = []
    with ZipFile(package) as archive:
        for baseline in original['clips']:
            data = archive.read(baseline['path'])
            if hashlib.sha256(data).hexdigest() != baseline['sha256']:
                raise ValueError('Original clip differs from provenance: ' + baseline['path'])
            with wave.open(io.BytesIO(data), 'rb') as stream:
                if (stream.getnchannels(), stream.getsampwidth(), stream.getframerate()) != (1, 2, RATE):
                    raise ValueError('Unexpected original PCM format')
                pcm = array('h', stream.readframes(stream.getnframes()))
            rms = math.sqrt(sum(float(value) ** 2 for value in pcm) / len(pcm))
            peak = max(abs(value) for value in pcm)
            gain = min(32768 * 10 ** (TARGET_RMS_DBFS / 20) / rms,
                       32768 * 10 ** (PEAK_LIMIT_DBFS / 20) / peak)
            # A constant gain preserves timing, pitch and the original fades.
            processed = array('h', (round(value * gain) for value in pcm))
            wav(DLC / 'src' / baseline['path'], processed)
            preview.extend(processed)
            preview.extend(array('h', [0] * round(RATE * .40)))
            level = 20 * math.log10(gain)
            row = dict(baseline)
            row.update(gain_db=baseline['gain_db'] + level,
                       level_increase_db=level,
                       effective_level_increase_db=level + 20 * math.log10(VOLUME_MULT / .85),
                       rms_dbfs=20 * math.log10(math.sqrt(sum(float(v) ** 2 for v in processed) / len(processed)) / 32768),
                       peak_dbfs=20 * math.log10(max(abs(v) for v in processed) / 32768),
                       sha256=sha(DLC / 'src' / baseline['path']))
            assert max(abs(v) for v in processed) < 32767
            rows.append(row)
    version = (DLC / 'VERSION').read_text().strip()
    for name in ('preview.wav', 'preview-v' + version + '.wav'):
        wav(DLC / 'audio' / name, preview)
    report = dict(original)
    report.update(target_rms_dbfs=TARGET_RMS_DBFS, peak_limit_dbfs=PEAK_LIMIT_DBFS,
                  playback_volume_mult=VOLUME_MULT, clips=rows, auditory_reviewed=False, in_game_tested=False,
                  processing_base={'version': '0.1.0', 'package': package.name, 'sha256': sha(package)},
                  processing_method='Constant per-clip PCM gain; no resampling or additional fading.')
    (DLC / 'audio/source.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    configuration = ('// Original-pitch voice clips; louder v' + version + ', see audio/source.json.\n'
        '::AfeixVoiceDLC.HurtSounds <- [\n'
        + ',\n'.join('    "' + row['path'] + '"' for row in rows)
        + f'\n];\n::AfeixVoiceDLC.VolumeMult <- {VOLUME_MULT};\n')
    (DLC / 'src/scripts/mods/afeix_dlc_afei_voice/config.nut').write_text(configuration, encoding='utf-8')
    print('Prepared original-pitch louder clips; effective increase %.2f to %.2f dB.' % (
        min(row['effective_level_increase_db'] for row in rows), max(row['effective_level_increase_db'] for row in rows)))
    print(DLC / 'audio' / ('preview-v' + version + '.wav'))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source', type=Path)
    parser.add_argument('--short-source', type=Path, default=ROOT / '哇哇叫.mp4')
    parser.add_argument('--ffmpeg', type=Path)
    parser.add_argument('--from-original-package', type=Path,
                        help='Amplify the verified original-pitch 0.1.0 cuts without recutting the videos')
    args = parser.parse_args()
    if args.from_original_package:
        amplify_original_package(args.from_original_package.resolve())
        return
    if args.source:
        source = args.source.resolve()
    else:
        videos = list(ROOT.glob('*冰牛*.mp4'))
        if len(videos) != 1:
            raise ValueError('Specify --source with the supplied original video')
        source = videos[0]
    ffmpeg = args.ffmpeg or shutil.which('ffmpeg')
    if not ffmpeg:
        sys.path.insert(0, str(ROOT / '.cache/afei-voice-tools'))
        import imageio_ffmpeg
        ffmpeg = imageio_ffmpeg.get_ffmpeg_exe()
    source_paths = {'full': source, 'short': args.short_source.resolve()}
    sources = {key: {'filename': path.name, 'bytes': path.stat().st_size, 'sha256': sha(path)}
               for key, path in source_paths.items()}
    provenance = DLC / 'audio/source.json'
    if provenance.exists():
        previous = json.loads(provenance.read_text(encoding='utf-8'))
        if 'sources' in previous:
            for key, entry in sources.items():
                if entry['sha256'] != previous['sources'][key]['sha256']:
                    raise ValueError('This clip selection belongs to a different source video: ' + key)
        elif sources['full']['sha256'] != previous['source_sha256']:
            raise ValueError('This clip selection belongs to a different full-length video')
    scratch = ROOT / '.cache/afei-voice-source/processed'
    scratch.mkdir(parents=True, exist_ok=True)
    rows = []
    preview = array('h', [0] * round(RATE * .25))
    for index, (source_id, start, end) in enumerate(CUTS, 1):
        name = f'afei_hurt_{index:02d}.wav'
        raw = scratch / name
        subprocess.run([str(ffmpeg), '-hide_banner', '-loglevel', 'error', '-y',
            '-ss', str(start), '-i', str(source_paths[source_id]), '-t', str(end - start), '-vn',
            '-ac', '1', '-ar', str(RATE), '-af', FILTER, '-c:a', 'pcm_s16le', str(raw)], check=True)
        with wave.open(str(raw), 'rb') as stream:
            pcm = array('h', stream.readframes(stream.getnframes()))
        rms = math.sqrt(sum(float(value) ** 2 for value in pcm) / len(pcm))
        peak = max(abs(value) for value in pcm)
        if rms == 0 or peak == 0:
            raise ValueError('Selected audio is silent: ' + name)
        gain = min(32768 * 10 ** (TARGET_RMS_DBFS / 20) / rms, 32768 * 10 ** (PEAK_LIMIT_DBFS / 20) / peak)
        fade = round(RATE * .015)
        processed = array('h')
        for position, value in enumerate(pcm):
            edge = min(1.0, position / fade, (len(pcm) - 1 - position) / fade)
            processed.append(round(value * gain * max(0, edge)))
        relative = 'sounds/afeix_dlc_afei_voice/' + name
        output = DLC / 'src' / relative
        wav(output, processed)
        preview.extend(processed)
        preview.extend(array('h', [0] * round(RATE * .40)))
        output_rms = math.sqrt(sum(float(value) ** 2 for value in processed) / len(processed)) / 32768
        rows.append({'path': relative, 'source_id': source_id, 'source_start_seconds': start, 'source_end_seconds': end,
            'candidate_utterance': '哇', 'duration_seconds': len(processed) / RATE,
            'gain_db': 20 * math.log10(gain), 'rms_dbfs': 20 * math.log10(output_rms),
            'peak_dbfs': 20 * math.log10(max(abs(v) for v in processed) / 32768),
            'sha256': sha(output)})
    wav(DLC / 'audio/preview.wav', preview)
    versioned_preview = DLC / 'audio' / ('preview-v' + (DLC / 'VERSION').read_text().strip() + '.wav')
    wav(versioned_preview, preview)
    report = {'sources': sources,
        'selection_method': 'local ASR word timestamps for full video; isolated voice-band peaks for short video',
        'asr_model': 'Systran/faster-whisper-small', 'audio_sent_to_remote_service': False,
        'filter': FILTER, 'target_rms_dbfs': TARGET_RMS_DBFS, 'peak_limit_dbfs': PEAK_LIMIT_DBFS,
        'playback_volume_mult': VOLUME_MULT,
        'fade_seconds': .015, 'sample_rate': RATE, 'channels': 1, 'pcm_bits': 16,
        'auditory_reviewed': False, 'in_game_tested': False, 'clips': rows}
    provenance.parent.mkdir(parents=True, exist_ok=True)
    provenance.write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    configuration = ('// Original voice excerpts from the supplied video; see audio/source.json.\n'
        '// Candidate cuts await listening review and in-game acceptance.\n'
        '::AfeixVoiceDLC.HurtSounds <- [\n'
        + ',\n'.join('    "' + row['path'] + '"' for row in rows)
        + f'\n];\n::AfeixVoiceDLC.VolumeMult <- {VOLUME_MULT};\n')
    (DLC / 'src/scripts/mods/afeix_dlc_afei_voice/config.nut').write_text(configuration, encoding='utf-8')
    print(f'Prepared {len(rows)} candidate clips; listening review and game acceptance pending.')
    print(versioned_preview)


if __name__ == '__main__':
    main()
