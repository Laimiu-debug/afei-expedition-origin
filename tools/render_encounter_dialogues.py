"""Export the shipped encounter dialogue for author review, in story order."""
from pathlib import Path
import json

ROOT = Path(__file__).resolve().parents[1]
GROUPS = (
    ('四派与旅途事件', 'ideaScenes', ('dao', 'bao', 'er', 'cao', 'hurt', 'recover', 'reply', 'grip', 'gift',
        'dao_sign', 'bao_spares', 'er_blanket', 'cao_chorus', 'mocha_receipt', 'xiaoyueya_salvage',
        'xiaoning_map', 'xiaogui_board', 'shuaizi_rhythm', 'songnuanyang_notes')),
    ('人物相遇与成长回应', 'chronicles', ('liu', 'liu_reply', 'er_xiaoyuan', 'er_haman', 'er_sige', 'er_keke', 'er_xiaogui', 'er_yuchujiu', 'route_toad', 'route_jiahao', 'route_feidie', 'bottle_daily', 'bottle_after', 'luoyike_cache', 'luoyike_home', 'yanzi_signatures', 'yanzi_own_name')),
)


def render():
    data = json.loads((ROOT / 'build/characters.json').read_text(encoding='utf-8'))
    scenes = [data[field][key] for _, field, keys in GROUPS for key in keys]
    names = {character['key']: character['name'] for character in data['characters']}
    count = sum(len(scene['choices']) for scene in scenes)
    lines = ['# 已接入相遇对白｜v0.20.0', '',
             f'{len(scenes)} 段剧情、{count} 个选项及各自后续。此文件由实际游戏脚本导出，供作者审阅，会提前展示未遇见的内容；游戏仍按剧情资格逐段开放。', '',
             '四派普通相遇与新增旅途日常可按冷却重复，刘青松两次相遇和各人物回应各结算一次。均为对话选择，不直接开战；原有曹飞热血选择可影响下一场符合条件的战斗。[原有规则](../playtest-0.19.md) · [新增 10 事件规则](../playtest-0.20.md)。', '',
             '下方后续是成功提交选项时的对白。补给装不下、药品不足或角色不在队时，游戏会显示对应提示；不强行发放或扣除。', '']
    for title, field, keys in GROUPS:
        if set(keys) != set(data[field]):
            raise ValueError(f'Update dialogue reading order for {field}')
        lines += [f'## {title}', '']
        for key in keys:
            scene = data[field][key]
            lines += [f"### {scene['title']}", '']
            if 'random' in scene:
                rule = scene['random']
                place = {'road': '安全行军途中', 'safe': '安全扎营或友好城镇附近',
                         'town': '友好城镇附近', 'either': '安全行军、扎营或友好城镇附近'}[rule['place']]
                members = '、'.join(names[key] for key in rule['members']) or '不限指定人物'
                lines += [f"触发：第 3 天起，{place}；{members}；至少 {rule['minimum']} 名存活队员。单事件冷却 {scene['days']} 天，抽选权重 {scene['weight']}；与普通相遇共享 1.5 天间隔。", '']
            lines += [scene['text'], '']
            if 'priorText' in scene:
                lines += ['前段不同选择的对应补叙：', '']
                for text in scene['priorText']: lines += [text, '']
            for index, (choice, ending) in enumerate(zip(scene['choices'], scene['outcomes'], strict=True), 1):
                lines += [f'**选项 {index}：{choice}**', '', ending, '']
    (ROOT / 'docs/design/encounter-dialogues.md').write_text('\n'.join(lines), encoding='utf-8')


if __name__ == '__main__':
    render()
