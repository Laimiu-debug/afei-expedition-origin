"""Summarize the first-movement diagnostic without exposing unrelated log text."""
from pathlib import Path
from html import unescape
import argparse
import json
import re


def analyze(raw):
    text = raw.decode('utf-8', errors='replace')
    lines = [re.sub(r'<[^>]*>', '', unescape(row)).strip()
             for row in re.split(r'<div class="row ', text)[1:] if 'AFEIX_FIRST_MOVE ' in row]
    runs = {}
    exceptions = []
    registered = any('AFEIX_FIRST_MOVE registered ' in line for line in lines)
    for line in lines:
        message = line.split('AFEIX_FIRST_MOVE ', 1)[1]
        fields = dict(re.findall(r'(\w+)=([^\s]+)', message))
        if message.startswith('exception '):
            exceptions.append(message)
        if not message.startswith(('metric ', 'summary ')):
            continue
        run = runs.setdefault(fields['run'], {'metrics': []})
        if message.startswith('summary '):
            run['summary'] = {key: float(fields[key]) for key in ('frames', 'real_s', 'exact_ticks', 'max_frame_gap_s')}
            run['summary']['reason'] = fields['reason']
        else:
            run['metrics'].append({'name': fields['name'], 'calls': int(fields['calls']),
                                   'total_ticks': float(fields['total_ticks']),
                                   'max_ticks': float(fields['max_ticks']), 'errors': int(fields['errors'])})
    for run in runs.values():
        summary = run.get('summary', {})
        real, exact = summary.get('real_s', 0), summary.get('exact_ticks', 0)
        if real >= 0.1 and exact > 0:
            ratio = real / exact
            for metric in run['metrics']:
                metric['approx_total_ms'] = round(metric['total_ticks'] * ratio * 1000, 3)
                metric['approx_max_ms'] = round(metric['max_ticks'] * ratio * 1000, 3)
            run['clock_note'] = 'Approximate conversion calibrated across the capture window; nested scopes must not be summed.'
        run['metrics'].sort(key=lambda row: row['max_ticks'], reverse=True)
    return {'registered': registered, 'capture_complete': bool(runs) and all('summary' in r for r in runs.values()),
            'runs': runs, 'exceptions': exceptions,
            'markers': [line.split('AFEIX_FIRST_MOVE ', 1)[1] for line in lines if ' metric ' not in line]}


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--log', type=Path, default=Path('C:/Users/25647/OneDrive/Documents/Battle Brothers/log.html'))
    parser.add_argument('--output', type=Path)
    args = parser.parse_args()
    result = analyze(args.log.read_bytes())
    serialized = json.dumps(result, ensure_ascii=False, indent=2) + '\n'
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(serialized, encoding='utf-8')
    print(serialized)
