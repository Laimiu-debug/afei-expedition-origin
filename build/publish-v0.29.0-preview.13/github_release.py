"""Publish a tagged GitHub prerelease and verify its public assets without storing credentials."""
from pathlib import Path
from zipfile import ZipFile
import hashlib
import json
import os
import shutil
import subprocess

stage = Path(__file__).resolve().parent
root = stage.parents[1]
repo = 'Laimiu-debug/afei-expedition-origin'
tag = 'v0.29.0-preview.13'
commit = '85bae130e29968c7dc07512007a9bb64663652e2'
original = root/'dist/mod_afeix_expedition v0.29.0-preview.13.zip'
package = stage/'mod_afeix_expedition.zip'
checksum = stage/'mod_afeix_expedition.sha256'
shutil.copy2(original, package)
checksum.write_text(hashlib.sha256(package.read_bytes()).hexdigest()+'  '+package.name+'\n', encoding='utf-8')
env = {**os.environ, 'GIT_TERMINAL_PROMPT': '0', 'GCM_INTERACTIVE': 'Never'}
credential = subprocess.run(['git', 'credential', 'fill'], input='protocol=https\nhost=github.com\n\n',
                            capture_output=True, encoding='utf-8', env=env, timeout=25, check=True)
values = dict(line.split('=', 1) for line in credential.stdout.splitlines() if '=' in line)
assert values.get('password'), 'GitHub credential unavailable'
env.update({'GH_TOKEN': values['password'], 'HTTPS_PROXY': 'http://127.0.0.1:7899',
            'HTTP_PROXY': 'http://127.0.0.1:7899'})
env.pop('GH_DEBUG', None)

def gh(*args, required=True):
    result = subprocess.run(['gh', *args], env=env, capture_output=True, encoding='utf-8', timeout=55)
    if required and result.returncode:
        raise RuntimeError(result.stderr)
    return result

remote_main = json.loads(gh('api', f'repos/{repo}/git/ref/heads/main').stdout)['object']['sha']
if remote_main != commit:
    comparison = json.loads(gh('api', f'repos/{repo}/compare/{commit}...{remote_main}').stdout)
    assert comparison['merge_base_commit']['sha'] == commit, 'Release source is absent from remote main'
remote_tag = json.loads(gh('api', f'repos/{repo}/git/ref/tags/{tag}').stdout)['object']
if remote_tag['type'] == 'tag':
    remote_tag = json.loads(gh('api', f'repos/{repo}/git/tags/{remote_tag["sha"]}').stdout)['object']
assert remote_tag['type'] == 'commit' and remote_tag['sha'] == commit
view = gh('api', f'repos/{repo}/releases/tags/{tag}', required=False)
if view.returncode:
    assert '404' in view.stderr, 'Unexpected error looking up existing release'
    result = gh('release', 'create', tag, str(package), str(checksum), '--repo', repo,
                '--verify-tag', '--target', commit, '--prerelease',
                '--title', 'v0.29.0-preview.13：修复黑潮全屏覆盖',
                '--notes-file', str(stage/'github-notes.md'))
    print('GitHub prerelease created: '+result.stdout.strip(), flush=True)
release = json.loads(gh('api', f'repos/{repo}/releases/tags/{tag}').stdout)
assert not release['draft'] and release['prerelease'] and release['tag_name'] == tag
assert release['body'].replace('\r\n', '\n').strip() == (stage/'github-notes.md').read_text(encoding='utf-8').strip()
assets = {asset['name']: asset for asset in release['assets']}
# GitHub replaces spaces in asset names. Retain this revision's uploaded ZIP
# while giving both download assets the stable installation basename.
for canonical, old in [(package.name, original.name.replace(' ', '.')),
                       (checksum.name, original.with_suffix('.sha256').name.replace(' ', '.'))]:
    if canonical not in assets:
        assert old in assets and len(assets) == 2, 'Unexpected release assets'
        if old.endswith('.zip'):
            assert assets[old]['size'] == original.stat().st_size
            assert assets[old]['digest'] == 'sha256:'+hashlib.sha256(original.read_bytes()).hexdigest()
        gh('api', '--method', 'PATCH', f'repos/{repo}/releases/assets/{assets[old]["id"]}', '-f', 'name='+canonical)
        assets[canonical] = assets.pop(old)
checksum_digest = 'sha256:'+hashlib.sha256(checksum.read_bytes()).hexdigest()
if assets[checksum.name].get('digest') != checksum_digest:
    gh('release', 'upload', tag, str(checksum), '--repo', repo, '--clobber')
release = json.loads(gh('api', f'repos/{repo}/releases/tags/{tag}').stdout)
assets = {asset['name']: asset for asset in release['assets']}
assert set(assets) == {package.name, checksum.name}
verified_assets = []
for local in (package, checksum):
    asset = assets[local.name]
    assert asset['state'] == 'uploaded' and asset['size'] == local.stat().st_size
    expected_sha = hashlib.sha256(local.read_bytes()).hexdigest()
    if asset.get('digest'):
        assert asset['digest'] == 'sha256:'+expected_sha
    destination = stage/('github-download.zip' if local == package else 'github-download.sha256')
    subprocess.run(['curl', '--proxy', 'http://127.0.0.1:7899', '--fail', '--silent', '--show-error',
                    '--location', '--connect-timeout', '8', '--max-time', '45',
                    '--output', str(destination), asset['browser_download_url']], check=True, timeout=50)
    assert destination.read_bytes() == local.read_bytes()
    verified_assets.append({'name': local.name, 'size': asset['size'], 'sha256': expected_sha,
                            'url': asset['browser_download_url'], 'public_bytes_match': True})
with ZipFile(stage/'github-download.zip') as archive:
    assert archive.testzip() is None
    source = {p.relative_to(root/'src').as_posix(): p for p in (root/'src').rglob('*') if p.is_file()}
    assert set(archive.namelist()) == set(source)
    assert all(archive.read(name) == path.read_bytes() for name, path in source.items())
report = {'repository': repo, 'commit': commit, 'remote_main_at_publication': remote_main,
          'tag': tag, 'tag_commit_matches': True, 'release_id': release['id'], 'url': release['html_url'],
          'prerelease': True, 'draft': False, 'notes_match': True, 'entries': len(source),
          'source_bytes_match': True, 'crc_passed': True, 'assets': verified_assets, 'in_game_tested': False}
(stage/'github-verification.json').write_text(json.dumps(report, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
print(json.dumps(report, ensure_ascii=False, indent=2))
