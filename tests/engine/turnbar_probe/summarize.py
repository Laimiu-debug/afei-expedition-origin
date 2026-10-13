"""Summarize a preserved engine log without discarding embedded DOM evidence."""
import argparse
import html
import json
import re
from pathlib import Path

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('log', type=Path)
parser.add_argument('--output', type=Path, required=True)
args = parser.parse_args()
raw = args.log.read_text(encoding='utf-8', errors='replace')
messages = [html.unescape(m) for m in re.findall(r'<div class="text">(.*?)</div>', raw, re.S)]
states = []
for message in messages:
    if 'PROBE STATE t=' not in message:
        continue
    values = dict(re.findall(r'(\w+)=([\w.]+)', message))
    states.append(values)
exceptions = [m for m in messages if re.search(r'Uncaught|TypeError|Failed to find entity image|Exception|does not exist|critical exception|\[BBForge:external\] Error', m, re.I)]
battle_messages = messages
for index, message in enumerate(messages):
    if 'AFEIX_CAMPAIGN_PROBE LOCAL_COMBAT' in message:
        battle_messages = messages[index:]
        break
battle_exceptions = [m for m in battle_messages if re.search(r'Uncaught|TypeError|Failed to find entity image|Exception|does not exist|critical exception|\[BBForge:external\] Error', m, re.I)]
fallbacks = [m for m in messages if 'AFEIX_TURNBAR_QUERY_FALLBACK' in m]
selectors = []
for message in messages:
    if 'AFEIX_SELECTOR_TRACE ' in message:
        selectors.append(json.loads(message.split('AFEIX_SELECTOR_TRACE ', 1)[1]))
report = {
    'log': str(args.log),
    'startup': [m for m in messages if 'AFEIX_TURNBAR_READY' in m],
    'scope': 'automated copied campaign' if 'AFEIX_CAMPAIGN_PROBE LOAD_COPY' in raw else 'standalone scenario',
    'fault_injected': 'AFEIX_QUERY_PROBE ARMED' in raw,
    'query_counts': [m for m in messages if 'AFEIX_QUERY_PROBE STATE' in m],
    'fallbacks': fallbacks,
    'selector_details': selectors,
    'exceptions': exceptions,
    'battle_exceptions': battle_exceptions,
    'terror_uses': sum('uses skill 恐怖尖啸' in m for m in battle_messages),
    'states': states,
    'max_round': max((int(s['round']) for s in states if 'round' in s), default=0),
    'unique_active_actors': len({s['active'] for s in states if s.get('active', '0') != '0'}),
    'completed': any(('AFEIX_CAMPAIGN_PROBE COMPLETE' if 'AFEIX_CAMPAIGN_PROBE LOAD_COPY' in raw else 'AFEIX_GHOST_PROBE COMPLETE') in m for m in messages),
    'raw_html_preserved': True,
    'acceptance_limit': 'Automatic player turn endings differ from user actions; this is focused turn-bar verification.',
}
args.output.parent.mkdir(parents=True, exist_ok=True)
args.output.write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(json.dumps({k: report[k] for k in ('scope', 'fault_injected', 'max_round', 'unique_active_actors', 'completed')}, ensure_ascii=False))
print(f'fallbacks={len(fallbacks)} exceptions={len(exceptions)} selector_details={len(selectors)}')
