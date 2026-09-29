"""Build the optional local engine reproduction. Never included in the main mod."""
from pathlib import Path
from zipfile import ZIP_DEFLATED, ZipFile

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
destination = ROOT / 'build/net-headshot-playtest/mod_afeix_net_playtest.zip'
destination.parent.mkdir(parents=True, exist_ok=True)
with ZipFile(destination, 'w', ZIP_DEFLATED) as archive:
    for source in sorted((HERE / 'src').rglob('*.nut')):
        archive.write(source, source.relative_to(HERE / 'src').as_posix())
print(destination)
