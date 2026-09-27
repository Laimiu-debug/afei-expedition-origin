"""Restore only archived art-build tools and native QA references to a local cache."""
from pathlib import Path
from zipfile import ZipFile
import hashlib
import json

ROOT = Path(__file__).resolve().parents[1]
ARCHIVE = ROOT / 'legacy/2026-09-25-afei-expedition/original-project.zip'
TARGET = (ROOT / '.cache/afei-art').resolve()
PREFIXES = (
    'test-output/bbros-modkit-v9/bin/',
    'test-output/vanilla-layer-audit/',
    'test-output/decompile-player/',
)


def main():
    records = []
    with ZipFile(ARCHIVE) as archive:
        for item in archive.infolist():
            if item.is_dir() or not item.filename.startswith(PREFIXES):
                continue
            destination = (TARGET / item.filename.removeprefix('test-output/')).resolve()
            destination.relative_to(TARGET)
            destination.parent.mkdir(parents=True, exist_ok=True)
            data = archive.read(item)
            destination.write_bytes(data)
            records.append({'file': str(destination.relative_to(TARGET)), 'sha256': hashlib.sha256(data).hexdigest()})
    (TARGET / 'restore-report.json').write_text(json.dumps({'archive': str(ARCHIVE), 'files': records}, indent=2), encoding='utf-8')
    print(f'Restored {len(records)} archived files to {TARGET}')
    print('This cache is excluded from Git and the distributable Mod ZIP.')


if __name__ == '__main__':
    main()
