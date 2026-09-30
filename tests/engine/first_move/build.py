"""Build a temporary diagnostic ZIP outside the main mod package."""
from pathlib import Path
from zipfile import ZIP_DEFLATED, ZipFile

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
destination = ROOT / 'build/first-move-diagnostic-20260930/mod_afeix_first_move_diagnostic.zip'
destination.parent.mkdir(parents=True, exist_ok=True)
with ZipFile(destination, 'w', ZIP_DEFLATED) as archive:
    for source in sorted((HERE / 'src').rglob('*.nut')):
        archive.write(source, source.relative_to(HERE / 'src').as_posix())
with ZipFile(destination) as archive:
    assert archive.testzip() is None
    for source in (HERE / 'src').rglob('*.nut'):
        assert archive.read(source.relative_to(HERE / 'src').as_posix()) == source.read_bytes()
print(destination)
