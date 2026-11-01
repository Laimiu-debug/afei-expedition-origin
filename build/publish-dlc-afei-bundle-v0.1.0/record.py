from pathlib import Path
import json

stage=Path(__file__).resolve().parent
root=stage.parents[1]
published=json.loads((stage/'website-published.json').read_text(encoding='utf-8'))
verification=json.loads((stage/'website-verification.json').read_text(encoding='utf-8'))
withdrawn=json.loads((stage/'website-withdrawn.json').read_text(encoding='utf-8'))
assert verification['old_works_withdrawn'] and verification['download_bytes_match']

def update(path,fields):
    report=json.loads(path.read_text(encoding='utf-8'))
    report.update(fields)
    path.write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')

update(root/'dlc/afei-bundle/report.json',dict(published=True,website_mod_id=published['mod_id'],
    website_release_id=published['release_id'],website_detail_url=published['detail_url'],
    website_download_url=verification['download_url'],website_verified_at=verification['verified_at'],
    website_download_bytes_match=True,publication_backup=published['backup'],
    withdrawn_old_release_ids=withdrawn['release_ids'],withdrawal_backup=withdrawn['backup'],
    old_skin_separate_work_absent=True))
update(root/'dlc/afei-voice/report.json',dict(published=False,withdrawn=True,
    website_withdrawn_at=verification['verified_at'],replacement_mod_id=published['mod_id'],
    replacement_url=published['detail_url'],old_archives_retained=True))
update(root/'dlc/afei-skins/report.json',dict(bundle_published=True,bundle_mod_id=published['mod_id'],
    bundle_release_id=published['release_id'],bundle_url=published['detail_url']))
print('Recorded publication, withdrawal, verification and backup evidence.')
