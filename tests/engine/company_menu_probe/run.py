"""Run the temporary menu probe with a bounded lifetime and capture its log."""
import argparse
import json
import subprocess
import time
from pathlib import Path

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--game', type=Path, required=True)
parser.add_argument('--log', type=Path, required=True)
parser.add_argument('--output', type=Path, required=True)
parser.add_argument('--marker', default='AFEIX_COMPANY_PROBE')
parser.add_argument('--seconds', type=int, default=85)
args = parser.parse_args()
args.output.mkdir(parents=True, exist_ok=True)
exe = args.game / 'win32/BattleBrothers.exe'
startup = subprocess.STARTUPINFO()
startup.dwFlags |= subprocess.STARTF_USESHOWWINDOW
startup.wShowWindow = 0
started_wall = time.time()
process = subprocess.Popen([str(exe)], cwd=exe.parent, startupinfo=startup)
print('Own probe process:', process.pid, flush=True)
started = time.monotonic()
outcome = 'timeout'
try:
    while time.monotonic() - started < args.seconds:
        if process.poll() is not None:
            outcome = 'engine exited'
            break
        try:
            if args.log.stat().st_mtime < started_wall:
                time.sleep(0.4)
                continue
            with args.log.open('rb') as handle:
                handle.seek(max(0, args.log.stat().st_size - 30000))
                tail = handle.read().decode('utf-8', 'replace')
            if args.marker + ' COMPLETE' in tail:
                outcome = 'passed'
                break
            if args.marker + ' FAILED' in tail:
                outcome = 'probe failed'
                break
            if 'A critical error occured:' in tail:
                outcome = 'engine critical error'
                break
        except OSError:
            pass
        time.sleep(0.4)
finally:
    if process.poll() is None:
        process.terminate()
        try:
            process.wait(timeout=5)
        except subprocess.TimeoutExpired:
            process.kill()
            process.wait(timeout=5)
    size = args.log.stat().st_size
    with args.log.open('rb') as handle:
        data = handle.read(min(size, 1500000))
    (args.output / 'game-log.html').write_bytes(data)
    report = {'outcome': outcome, 'pid': process.pid, 'elapsed_seconds': round(time.monotonic() - started, 2),
              'log_bytes': size, 'log_truncated': size > len(data)}
    (args.output / 'result.json').write_text(json.dumps(report, indent=2) + '\n', encoding='utf-8')
    print(json.dumps(report), flush=True)
raise SystemExit(0 if outcome == 'passed' else 1)
