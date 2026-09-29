"""Export authored campaign/member endings to Squirrel and a review document."""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def build_endings():
    data = json.loads((ROOT / 'data/company-endings.json').read_text(encoding='utf-8'))
    order = [r['key'] for r in json.loads((ROOT / 'data/character-stories.json').read_text(encoding='utf-8'))['characters']]
    if list(data['members']) != order:
        raise ValueError('Endings must cover all current members in roster order')
    for key, row in data['members'].items():
        if set(row) != {'good', 'lean', 'memorial'} or any(len(t) < 25 for t in row.values()):
            raise ValueError('Incomplete personal ending: ' + key)
    def sq(value):
        if isinstance(value, dict):
            return '{ ' + ', '.join(k + ' = ' + sq(v) for k, v in value.items()) + ' }'
        return json.dumps(value, ensure_ascii=False)
    (ROOT / 'src/scripts/mods/afeix/ending_data.nut').write_text(
        '// Generated from data/company-endings.json.\n::AfeixExpedition.Endings <- ' + sq(data) + ';\n', encoding='utf-8')
    names = {r['key']: r['name'] for r in json.loads((ROOT / 'data/character-stories.json').read_text(encoding='utf-8'))['characters']}
    lines = ['# 黑旗战团结局', '', '以下均为 Mod 原创虚构剧情。已接入退隐与败亡界面；按本次战役记录选文，不写入额外成长或死亡标记。', '',
             '主结局：退隐按双危机且声望 ≥6000、单危机、声望 ≥3000、声望 ≥1000、起步阶段依次判断；败亡按第30天前且声望<1000、已有危机战绩或声望≥3000、普通败亡判断。', '',
             '成员后续只写实际在队、已阵亡或已离队的人；未招募者不出场。退隐的富足版要求声望≥3000或度过危机，其余使用拮据版；败亡中的存活者只写余生未定。自行车、路线和六根只回应已经发生的选择。', '']
    for row in data['company'].values():
        lines += ['## ' + row['title'], '', row['text'], '']
    lines += ['## 战役经历回应', '']
    for key, text in data['callbacks'].items():
        lines += ['### ' + key, '', text, '']
    for key, row in data['members'].items():
        lines += ['## ' + names[key], '', '**声名已立**：' + row['good'], '', '**平凡收旗**：' + row['lean'], '', '**阵亡纪念**：' + row['memorial'], '']
    (ROOT / 'docs/design/company-endings.md').write_text('\n'.join(lines), encoding='utf-8')
    return len(data['members'])


if __name__ == '__main__':
    print(f'Built endings for {build_endings()} members.')
