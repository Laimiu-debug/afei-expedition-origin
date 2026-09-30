from read_log import analyze

def html(messages):
    return ''.join('<div class="row info"><div class="text">AFEIX_FIRST_MOVE ' + line + '</div></div>' for line in messages).encode()

result = analyze(html(['registered window_s=12', 'metric run=1 name=world.onUpdate calls=5 total_ticks=250 max_ticks=100 errors=0',
                       'summary run=1 reason=window_complete frames=5 real_s=12 exact_ticks=12000 max_frame_gap_s=2.1']))
assert result['registered'] and result['capture_complete']
assert result['runs']['1']['metrics'][0]['approx_max_ms'] == 100.0
assert result['runs']['1']['summary']['max_frame_gap_s'] == 2.1
assert not analyze(html(['registered window_s=12', 'begin run=1 reason=first_movement_click']))['capture_complete']
assert not analyze(b'<html>unrelated log</html>')['registered']
assert analyze(html(['exception name=events.update message=native_failure']))['exceptions']
print('TESTS_PASSED=6')
