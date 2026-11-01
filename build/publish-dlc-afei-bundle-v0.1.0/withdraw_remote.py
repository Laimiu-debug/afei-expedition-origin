"""Reversibly withdraw all old component releases after bundle verification."""
from datetime import datetime, timezone
from pathlib import Path
import json
import os
import sqlite3
from django.conf import settings
from django.db import transaction
from catalog.models import Mod, Release, DesktopRelease
from catalog.services import audit

stage = Path(os.environ['AFEIX_STAGE'])
spec = json.loads((stage/'website-release.json').read_text(encoding='utf-8'))
published = json.loads((stage/'website-published.json').read_text(encoding='utf-8'))
bundle = Release.objects.select_related('mod','mod__owner').get(pk=published['release_id'])
assert str(bundle.mod_id)==published['mod_id'] and bundle.status=='published'
assert bundle.sha256==spec['sha256'] and bundle.mod.install_name==spec['mod']['install_name']
owner = bundle.mod.owner
assert owner.username==spec['owner'] and owner.is_active
for name in spec['absent_old_install_names']:
    assert not Mod.objects.filter(install_name__iexact=name).exists(), 'An old work appeared; refresh snapshot'
for old in spec['withdraw_works']:
    target=Mod.objects.get(pk=old['id'])
    assert target.install_name==old['install_name'] and target.owner_id==owner.pk and not target.blocked
    rows=list(target.releases.values('id','version','sha256','status','size'))
    assert {str(r['id']) for r in rows}=={r['id'] for r in old['releases']}, 'Old versions changed; refresh snapshot'
    for row in rows:
        expected=next(r for r in old['releases'] if r['id']==str(row['id']))
        assert all(row[k]==expected[k] for k in ['version','sha256','size'])
        assert row['status'] in (expected['status'],'withdrawn')
print(json.dumps(dict(validated=True,targets=[m['install_name'] for m in spec['withdraw_works']]),ensure_ascii=False))
if os.environ.get('AFEIX_WITHDRAW')=='1':
    verification=json.loads((stage/'website-verification.json').read_text(encoding='utf-8'))
    assert verification['download_bytes_match'] and verification['catalog_metadata_match']
    assert verification['sha256']==bundle.sha256 and verification['detail_url']==published['detail_url']
    directory=Path(settings.DATABASES['default']['NAME']).parent/'backups'
    directory.mkdir(exist_ok=True)
    backup=directory/('afeix-pre-bundle-withdraw-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ')+'.sqlite3')
    with sqlite3.connect(settings.DATABASES['default']['NAME']) as source,sqlite3.connect(backup) as target:
        source.backup(target)
        assert target.execute('PRAGMA integrity_check').fetchone()[0]=='ok'
    changed=[]
    with transaction.atomic():
        before=[(model,list(model.objects.values())) for model in [Mod,Release,DesktopRelease]]
        for old in spec['withdraw_works']:
            mod=Mod.objects.select_for_update().get(pk=old['id'])
            assert mod.owner_id==owner.pk
            for release in mod.releases.select_for_update().filter(status='published'):
                release.status='withdrawn'
                release.save(update_fields=['status'])
                changed.append(str(release.pk))
                audit(owner,'撤回版本',release.pk,'已整合至 '+published['detail_url']+'；原文件保留')
        for model,rows in before:
            for row in rows:
                if model is Release and str(row['id']) in changed: row['status']='withdrawn'
                assert model.objects.filter(pk=row['id']).values().get()==row,'Unexpected catalog change'
        assert not Release.objects.filter(mod_id__in=[m['id'] for m in spec['withdraw_works']],status='published').exists()
    print(json.dumps(dict(withdrawn=True,release_ids=changed,backup=str(backup),
        retained_archives=True,other_catalog_records_unchanged=True,absent_old_install_names=spec['absent_old_install_names']),ensure_ascii=False))
