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
from catalog.services import create_release, audit


def publish():
    stage = Path(os.environ['AFEIX_STAGE'])
    spec = json.loads((stage / 'website-release.json').read_text(encoding='utf-8'))
    # A versioned upload name is independent of the site's stable install key.
    package_filename = spec.get('package_filename', spec['mod']['install_name'])
    archive = (stage / package_filename).read_bytes()
    assert hashlib.sha256(archive).hexdigest() == spec['sha256'], 'Package hash mismatch'
    owner = User.objects.get(username=spec['owner'], is_active=True)
    existing = Mod.objects.filter(install_name__iexact=spec['mod']['install_name']).first()
    if spec.get('expected_mod_id'):
        assert existing and str(existing.pk) == spec['expected_mod_id'], 'Unexpected target work'
    superseded = None
    if existing:
        assert existing.owner_id == owner.pk and not existing.blocked, 'Owner or status mismatch'
        release = existing.releases.filter(version=spec['version']).first()
        if release:
            if release.sha256 == spec['sha256'] and release.status == 'published':
                print(json.dumps({'already_published': True, 'mod_id': str(existing.pk), 'release_id': str(release.pk)}))
                return
            # Explicit same-version revision: retain the previous immutable
            # archive and download URL under a descriptive historical label.
            requested = spec.get('supersedes', {})
            assert (str(release.pk) == requested.get('release_id') and release.sha256 == requested.get('sha256')
                    and release.status == 'published'), 'Same-version revision lacks matching expected release'
            history_version = requested.get('history_version', '')
            history_form = ReleaseForm({'version': history_version})
            history_form.is_valid()
            assert history_version and 'version' not in history_form.errors and history_version != spec['version'], 'Invalid historical version label'
            assert not existing.releases.filter(version=history_version).exists(), 'Historical label already exists'
            superseded = release
        if spec.get('expected_metadata'):
            assert existing.snapshot() == spec['expected_metadata'], 'Website metadata changed; refresh before publishing'
    form = ModForm(spec['mod'], instance=existing)
    upload = ReleaseForm({'version': spec['version'], 'notes': spec['notes'], 'rights': True, 'publish': True},
                         {'archive': SimpleUploadedFile(package_filename, archive)})
    assert form.is_valid(), form.errors.as_json()
    assert upload.is_valid(), upload.errors.as_json()
    assert upload.inspection['sha256'] == spec['sha256']
    print(json.dumps({'validated': True, 'version': spec['version'], 'sha256': spec['sha256'],
                      'size': len(archive), 'owner': owner.username,
                      'package_filename': package_filename, 'download_filename': spec['mod']['install_name']}, ensure_ascii=False))
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
        if superseded is not None:
            prior = Release.objects.select_for_update().get(pk=superseded.pk)
            assert prior.version == spec['version'] and prior.sha256 == spec['supersedes']['sha256'] and prior.status == 'published', 'Previous release changed before publication'
            prior.version = spec['supersedes']['history_version']
            prior.save(update_fields=['version'])
            audit(owner, '保留修订前版本', prior.pk, f"{spec['version']} -> {prior.version}; archive unchanged")
        mod = form.save(commit=False)
        mod.owner = owner
        mod.save()
        release = create_release(owner, mod, upload)
        for model, rows in previous:
            for row in rows:
                if model is Mod and existing and row['id'] == existing.pk:
                    continue
                if model is Release and superseded is not None and row['id'] == superseded.pk:
                    row['version'] = spec['supersedes']['history_version']
                assert model.objects.filter(pk=row['id']).values().get() == row, 'Existing catalog row changed'
    print(json.dumps({'published': True, 'mod_id': str(mod.pk), 'release_id': str(release.pk),
                      'detail_url': 'https://bbmod.com/mods/' + str(mod.pk) + '/',
                      'sha256': release.sha256, 'size': release.size, 'backup': str(backup),
                      'superseded_release_id': str(superseded.pk) if superseded else None}, ensure_ascii=False))


publish()
