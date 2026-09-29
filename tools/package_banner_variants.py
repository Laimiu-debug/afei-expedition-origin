"""Package the reviewed toad banner variants with the current release version."""
from pathlib import Path
from zipfile import ZIP_DEFLATED, ZipFile, ZipInfo
import hashlib
import re

ROOT = Path(__file__).resolve().parents[1]
ART = ROOT / 'art/runtime/banner-v25'


def main():
    version = (ROOT / 'VERSION').read_text(encoding='utf-8').strip()
    if not re.fullmatch(r'\d+\.\d+\.\d+', version):
        raise ValueError('VERSION must contain a release version such as 0.25.0')
    filenames = [
        'sources/toad-banner.png',
        'variants/01-toad-front.png',
        'variants/02-toad-profile.png',
        'variants/03-toad-medallion.png',
        'variants/04-golden-angel.png',
        'variants/references/golden-frog.png',
        'variants/README.md',
        'variants/index.html',
    ]
    contents = {name: (ART / name).read_bytes() for name in filenames}
    contents['README.md'] = (
        f'# 蛤蟆旗帜备选素材 v{version}\n\n'
        '包含正面踩球、侧身踩球、圆章蛤蟆和黄金天使蛙四款透明 PNG。\n\n'
        '解压后打开 `variants/index.html` 对比，`variants/README.md` 保存完整提示词。\n\n'
        '图像使用内置 imagegen 生成；`sources/` 和 `variants/references/` 为风格与角色参考。\n\n'
        '这是美术素材包，不是可安装的 Mod，请勿放入游戏 data 目录。\n'
    ).encode('utf-8')
    destination = ROOT / f'dist/afeix_banner_variants v{version}.zip'
    destination.parent.mkdir(exist_ok=True)
    with ZipFile(destination, 'w', compression=ZIP_DEFLATED) as archive:
        for name, data in sorted(contents.items()):
            info = ZipInfo(name, (2026, 9, 28, 0, 0, 0))
            info.compress_type = ZIP_DEFLATED
            archive.writestr(info, data)
    with ZipFile(destination) as archive:
        if archive.testzip() is not None:
            raise ValueError('Banner ZIP CRC failed')
        if set(archive.namelist()) != set(contents):
            raise ValueError('Banner ZIP entries mismatch')
        for name, data in contents.items():
            if archive.read(name) != data:
                raise ValueError(f'Banner ZIP/source mismatch: {name}')
    digest = hashlib.sha256(destination.read_bytes()).hexdigest()
    destination.with_suffix('.sha256').write_text(f'{digest}  {destination.name}\n', encoding='utf-8')
    print(f'Built {destination} ({len(contents)} files). CRC and source bytes verified.')


if __name__ == '__main__':
    main()
