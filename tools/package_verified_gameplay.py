"""Package already-validated source bytes, without regenerating art or content."""
import hashlib
import json
from pathlib import Path
from zipfile import ZipFile, ZipInfo, ZIP_DEFLATED

ROOT=Path(__file__).resolve().parents[1]
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def main():
    validation=json.loads((ROOT/'build/gameplay-validation.json').read_text(encoding='utf-8'))
    assert validation['syntax_passed'] and validation['behavior_tests_passed'] and validation['native_resource_paths_passed']
    for row in validation['scripts']+validation['ui_scripts']:
        assert sha(ROOT/row['path'])==row['sha256'],row['path']
    root=ROOT/'src';files=sorted(p for p in root.rglob('*') if p.is_file())
    assert all(p.suffix in {'.nut','.js','.css','.png','.brush'} for p in files)
    version=(ROOT/'VERSION').read_text().strip()
    package=ROOT/f'dist/mod_afeix_expedition v{version}.zip'
    package.parent.mkdir(exist_ok=True)
    with ZipFile(package,'w',ZIP_DEFLATED) as z:
        for path in files:
            info=ZipInfo(path.relative_to(root).as_posix(),(2026,9,30,0,0,0));info.compress_type=ZIP_DEFLATED
            z.writestr(info,path.read_bytes())
    expected=[p.relative_to(root).as_posix() for p in files]
    with ZipFile(package) as z:
        assert z.testzip() is None
        assert sorted(z.namelist())==expected
        for path in files:assert z.read(path.relative_to(root).as_posix())==path.read_bytes(),path
    report={'version':version,'package':package.relative_to(ROOT).as_posix(),'sha256':sha(package),
        'entries':expected,'crc_passed':True,'source_bytes_match':True,
        'behavior_assertions':sum(t['assertions'] for t in validation['tests']),'in_game_tested':False,
        'scope':'Current working tree, including preceding art/documentation work; no install or publish.'}
    package.with_suffix('.sha256').write_text(f"{report['sha256']}  {package.name}\n",encoding='utf-8')
    (ROOT/'build/endgame-balance-package.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    manifest_path=ROOT/'build/gameplay-package.json'
    manifest=json.loads(manifest_path.read_text(encoding='utf-8'))
    manifest.update(report)
    manifest['install_name']=package.name
    manifest['new_member_skills_this_version']=0
    manifest_path.write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(f'Packaged v{version}: {len(files)} entries; CRC, complete entry set and source bytes verified.')
if __name__=='__main__':main()
