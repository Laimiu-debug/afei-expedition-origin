"""Map V2 workbook skills to reviewed current images and proposal-only artwork."""
from pathlib import Path
import hashlib
import json
import sys
from build_member_skill_art import build_art, validate_icons

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'docs/design/balance-v2'


def main():
    # Refresh only deterministic skill-image exports from the already reviewed source art.
    build_art()
    current={x['key']:x for x in validate_icons()}
    proposal=json.loads((OUT/'proposal.json').read_text(encoding='utf-8'))
    rows=[]
    def add(key,name,path,status):
        assert path.is_file(), path
        rows.append({'key':key,'name':name,'path':path.relative_to(ROOT).as_posix(),'status':status,'sha256':hashlib.sha256(path.read_bytes()).hexdigest()})
    for s in proposal['skills']:
        key=s['key']
        if key in current:
            add(key,s['name'],ROOT/current[key]['output'],'current_generated' if current[key]['generated'] else 'current_legacy')
        else:
            assert key.startswith(('yanzi_','xiwen_'))
            add(key,s['name'],OUT/'icons'/f'{key}.png','proposal_native_placeholder' if key.startswith('xiwen_') else 'proposal_only_generated')
    for key,name in [('wawa','哇哇叫'),('haoqi','豪气冲天'),('feidie','飞爹在此'),('ecig_puff','抽一口')]:
        add(key,name,ROOT/f'src/gfx/skills/afeix_{key}.png','current')
    add('unleash_wardog','释放里根',OUT/'icons/unleash_wardog.png','native_active_83')
    assert len(rows)==len(proposal['skills'])+5 and len({r['key'] for r in rows})==len(rows)
    (OUT/'skill-icon-manifest.json').write_text(json.dumps({'date':'2026-09-29','icons':rows},ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(f'{len(rows)} skill images mapped; 3 generated proposal icons and 3 native placeholder icons.')


if __name__=='__main__':
    sys.stdout.reconfigure(encoding='utf-8')
    main()
