"""Run through BBMOD's manage.py shell; validates by default, publishes with AFEIX_PUBLISH=1.

Place website-release.json and the reviewed ZIP beside this script first.
Uses the website's own forms, archive inspection, quota checks and audit service.
"""
import hashlib
import json
import os
import sqlite3
from datetime import datetime, timezone
from pathlib import Path

from django.conf import settings
from django.contrib.auth.models import User
from django.core.files.uploadedfile import SimpleUploadedFile
from django.db import transaction
from catalog.forms import ModForm, ReleaseForm
from catalog.models import Mod, Release, DesktopRelease
from catalog.services import create_release


def publish():
    stage = Path(os.environ['AFEIX_STAGE'])
    spec = json.loads((stage / 'website-release.json').read_text(encoding='utf-8'))
    archive = (stage / spec['mod']['install_name']).read_bytes()
    assert hashlib.sha256(archive).hexdigest() == spec['sha256'], 'Package hash mismatch'
    owner = User.objects.get(username=spec['owner'], is_active=True)
    existing = Mod.objects.filter(install_name__iexact=spec['mod']['install_name']).first()
    if spec.get('expected_mod_id'):
        assert existing and str(existing.pk) == spec['expected_mod_id'], 'Unexpected target work'
    if existing:
        assert existing.owner_id == owner.pk and not existing.blocked, 'Owner or status mismatch'
        release = existing.releases.filter(version=spec['version']).first()
        if release:
            assert release.sha256 == spec['sha256'] and release.status == 'published', 'Version exists with different bytes/status'
            print(json.dumps({'already_published': True, 'mod_id': str(existing.pk), 'release_id': str(release.pk)}))
            return
        if spec.get('expected_metadata'):
            assert existing.snapshot() == spec['expected_metadata'], 'Website metadata changed; refresh before publishing'
    form = ModForm(spec['mod'], instance=existing)
    upload = ReleaseForm({'version': spec['version'], 'notes': spec['notes'], 'rights': True, 'publish': True},
                         {'archive': SimpleUploadedFile(spec['mod']['install_name'], archive)})
    assert form.is_valid(), form.errors.as_json()
    assert upload.is_valid(), upload.errors.as_json()
    assert upload.inspection['sha256'] == spec['sha256']
    print(json.dumps({'validated': True, 'version': spec['version'], 'sha256': spec['sha256'],
                      'size': len(archive), 'owner': owner.username}, ensure_ascii=False))
    if os.environ.get('AFEIX_PUBLISH') != '1':
        return

    # Existing archives are immutable; an online SQLite backup preserves prior records.
    destination = Path(settings.DATABASES['default']['NAME']).parent / 'backups'
    destination.mkdir(exist_ok=True)
    backup = destination / ('afeix-pre-v' + spec['version'] + '-' + datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ') + '.sqlite3')
    with sqlite3.connect(settings.DATABASES['default']['NAME']) as source, sqlite3.connect(backup) as target:
        source.backup(target)
        assert target.execute('PRAGMA integrity_check').fetchone()[0] == 'ok'

    # Verify every pre-existing catalog record remains unchanged in this transaction.
    with transaction.atomic():
        previous = [(model, list(model.objects.values())) for model in (Mod, Release, DesktopRelease)]
        mod = form.save(commit=False)
        mod.owner = owner
        mod.save()
        release = create_release(owner, mod, upload)
        for model, rows in previous:
            for row in rows:
                if model is Mod and existing and row['id'] == existing.pk:
                    continue
                assert model.objects.filter(pk=row['id']).values().get() == row, 'Existing catalog row changed'
    print(json.dumps({'published': True, 'mod_id': str(mod.pk), 'release_id': str(release.pk),
                      'detail_url': 'https://bbmod.site/mods/' + str(mod.pk) + '/',
                      'sha256': release.sha256, 'size': release.size, 'backup': str(backup)}, ensure_ascii=False))


publish()
