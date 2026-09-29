"""Render the selected full-bust prompts, preserving provenance and edit inputs."""
from pathlib import Path
import json
import re

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / 'art/runtime/portraits-v04'


def read(path):
    return json.loads(path.read_text(encoding='utf-8'))


def render_legacy_prompts():
    manifest = read(BASE / 'manifest.json')
    records = {r['key']: r for r in read(BASE / 'root-source-selections.json')['characters']}
    for group in ('a', 'b'):
        for record in read(BASE / f'PROMPTS-group-{group}.json')['records']:
            if record['key'] in records:
                raise ValueError(f'Duplicate prompt key: {record["key"]}')
            records[record['key']] = record
    legacy_path = ROOT / 'legacy/2026-09-25-afei-expedition/reference/art/tactical-sprites/battle-style-v6/PROMPTS.md'
    legacy_text = legacy_path.read_text(encoding='utf-8')
    legacy_codes = {'bottle': 'C04', 'lili': 'C05', 'yuchujiu': 'C06'}
    lines = [
        '# 全员完整胸像：实际生图提示词与沿用记录 v0.4', '',
        '日期：2026-09-26。当前 34 人、36 种主体外观。飞碟是独立装饰，继续使用既有资源；不在每个人的主图里重复生成。', '',
        '**本轮规则：**一张透明胸像包含自己的头发、脸、脖子与服装。运行时隐藏原版人物及装备部件，保留选中与战斗状态提示。画风优先考虑 114×142 游戏尺寸下的粗轮廓、简单阴影、低饱和颜色和清晰特征，不追求真人照片。', '',
        '本文件由 `tools/render_portrait_prompts.py` 从实际生成记录整理；英文段落保留实际提交的提示词。阿飞三形态与小酒瓶、李李、余初九属于复用，不冒充本轮重新生成。来源与最终指纹见 [manifest.json](manifest.json)，新图均使用内置 ImageGen。', '',
        '小宁、小胖、蔓越莓、宋暖阳、小龟的标记来自用户确认；小哈尼与老蔡为待反馈的原创游戏造型，不宣称真人相貌还原。旧素材只作身份和设计参考，原版官方样本仅作画法参考，图集不复制原版素材。', '',
    ]
    count = 0
    for person in manifest['characters']:
        for form in person['forms']:
            count += 1
            key = person['key']
            title = person['name'] + (f' · {form["form"]}' if key == 'afei' else '')
            lines += [f'## {count:02d}｜{title}', '', f'- 角色键／画刷：`{key}` / `{form["brush"]}`',
                      f'- 选定源图：`{form["source"]}`', f'- 源图 SHA256：`{form["source_sha256"]}`']
            if key == 'afei':
                meta_path = (ROOT / form['source']).with_suffix('.json')
                record = read(meta_path)
                lines += [f'- 沿用既有阿飞自制母图；原始记录：`{meta_path.relative_to(ROOT).as_posix()}`']
            else:
                if key not in records:
                    raise ValueError(f'Missing prompt record: {key}')
                record = records[key]
            if key in legacy_codes:
                code = legacy_codes[key]
                match = re.search(rf'^- {code}：[\s\S]*?(?=\n\n|\n- C|\Z)', legacy_text, re.M)
                if not match:
                    raise ValueError(f'Missing legacy prompt: {code}')
                lines += ['- 本轮沿用旧自制完整胸像；以下为归档保存的提示词说明，未重新调用生成。', '',
                          match.group(0)[2:], '',
                          '[原始三人提示词记录](../../../legacy/2026-09-25-afei-expedition/reference/art/tactical-sprites/battle-style-v6/PROMPTS.md)', '']
                continue
            original = record.get('original_output_path', record.get('generated_output', record.get('original', record.get('source_file', ''))))
            if original:
                lines.append(f'- 生成器原始输出：`{original}`')
            refs = record.get('references', record.get('reference_images', []))
            if refs:
                lines.append('- 参考输入（角色目标与画法参考的角色由提示词区分）：')
                lines += [f'  - `{ref}`' for ref in refs]
            prompt = record.get('prompt')
            if not prompt:
                raise ValueError(f'Missing exact prompt: {key}')
            lines += ['', '```text', prompt, '```', '']
            for field in ('original_prompt', 'correction_prompt'):
                if field in record and record[field] != prompt:
                    lines += [f'### 补充生成记录：{field}', '', '```text', record[field], '```', '']
            for repair in record.get('repairs', []):
                lines += ['### 定向返修（已选用）', '', repair.get('reason', ''), '',
                          f'生成器输出：`{repair["original_output_path"]}`', '',
                          '输入参考：' + '、'.join(f'`{ref}`' for ref in repair.get('references', [])), '',
                          '```text', repair['prompt'], '```', '']
    if count != 36:
        raise ValueError(f'Expected 36 portrait forms, found {count}')
    (BASE / 'PROMPTS.md').write_text('\n'.join(lines), encoding='utf-8')
    return count


def render_pose_calls(edit):
    """Keep every actual facing edit, including a selected gaze-only repair."""
    calls = edit.get('prompt_chain') or edit.get('attempts') or [edit]
    lines = []
    for index, call in enumerate(calls, 1):
        prompt = call.get('prompt')
        output = call.get('generated_original', call.get('generated_output',
                 call.get('original_output', call.get('original_output_path', ''))))
        if not prompt or not output:
            raise ValueError(f'Missing exact facing call provenance: {edit["brush"]} step {index}')
        refs = call.get('references', call.get('referenced_image_paths', []))
        lines += [f'#### 朝向调用 {index}', '']
        note = call.get('review', call.get('reason', call.get('visual_review', call.get('visual_check'))))
        if note:
            lines += ['检查记录：' + note, '']
        if refs:
            lines += ['参考输入：', ''] + ['- `' + ref + '`' for ref in refs] + ['']
        lines += ['生成器原始输出：`' + output + '`', '']
        if call.get('archived_output'):
            lines += ['中间稿归档：`' + call['archived_output'] + '`', '']
        lines += ['```text', prompt, '```', '']
    return lines


def render_prompts():
    """Publish v05 photo provenance plus the complete v06 facing-edit chains."""
    base = ROOT / 'art/runtime/portraits-v05'
    manifest = read(base / 'manifest.json')
    native = [p['name'] for p in manifest['characters'] if p.get('portrait_mode') == 'native']
    pending = [p['name'] for p in manifest['characters'] if p.get('likeness_status') in
               {'awaiting_verified_photo', 'placeholder_pending_luoyike_reference'}]
    forms = [form for person in manifest['characters'] for form in person['forms']]
    facing_count = sum(form.get('source_revision') == 'v05_facing' for form in forms)
    lines = ['# 朝右战斗胸像：实际生图提示词与 v0.12 接入规则', '',
             'v0.12 使用用户提供的五张参考图，以内置 ImageGen 重绘小月牙、溺水小龟、小虎、瑶瑶牙和美伢。全员取消固定 y=102 横切，改用逐人颈部轮廓分层；其余成员保留既有源图，游戏尺寸、装备叠加和旧存档画刷 ID 不变。', '',
             'v0.7 没有重新生图：将现有源图等比缩到最大 88×100，放入 114×142 槽，在颈部拆成身体和头部，恢复原版武器、盾牌、护甲与头盔叠加。蛤蟆原画和头顶飞碟停用，转职玩法保留。下文保留真实生成历史，不把后续技术处理写成新的生图调用。', '',
             'v0.19 新增小龟禁戴头盔、厚壳与天生钢头；刘青松仅为照片参考的相遇 NPC，没有加入本战斗胸像图集。新事件头像与红装提示词见 [本轮实际提示词](../../art/runtime/ideas-v19/PROMPTS.json)，规则见 [v0.19](../playtest-0.19.md)。', '',
             '照片只负责本人脸型、眉眼、发际线和发型；画法参考《战场兄弟》官方胸像。源图使用少量宽阴影、粗轮廓、低饱和衣物和短肩大头比例，最终按 114×142 输出。', '',
             f'当前映射中 {facing_count}/{len(forms)} 幅采用 v0.6 朝右姿态修订。头部、胸肩和视线共同朝画面右侧，保留原有个人特征与衣装；每人仍使用包含自绘头发、脸和衣服的一张透明胸像。下面逐次保留实际调用、参考输入、原始输出及局部返修，不能把提示词记录当作实机通过证明。', '',
             ('待核对本人照片：' + '、'.join(pending) + '。这些成员的姿态修订基于既有游戏设计，不补足真人资料。' if pending else '此前缺参考的四位人类成员本轮已收到用户指定图片；图片仅作美术依据，不声称已核验其来源。') + '小龟使用用户指定吉祥物。蛤蟆立绘与头顶飞碟已于 v0.7 停用，转职玩法保留。', '',
             '姿态修订前的选择见 [manifest-before-facing.json](manifest-before-facing.json)，原始源图继续保留；`afeix_p04_*` 画刷与 `afeix_portraits_v04` 图集名称不变。参考照片与官方画风样本不打入游戏包。', '',
             ('当前使用原版人物外观、专属头像待补：' + '、'.join(native) + '。' if native else '当前 34 名成员均有专属胸像；罗一可按本轮用户照片重绘，眼子按仓库既有 Sylar 海报绘制。'), '',
             '## 来源与选择', '', '|成员／形态|本轮处理|源图|', '|---|---|---|']
    for person in manifest['characters']:
        for form in person['forms']:
            label = person['name'] + (' · '+form['form'] if person['key'] == 'afei' else '')
            lines += [f"|{label}|{form['review_note']}|`{form['source']}`|"]
    lines += ['', '以下照片与官方画风参考只保存在研究目录，不打入游戏包。装饰、服装与幻想种族属于游戏设计，不宣称是真实人物穿着。', '']
    files = ['PROMPTS-root-selected.json', 'PROMPTS-group-a-root.json', 'PROMPTS-group-b.json',
             'PROMPTS-group-missing.json', 'PROMPTS-supplement.json', 'PROMPTS-promotion.json']
    records = {}
    for filename in files:
        for record in read(base / filename)['records']:
            if record['key'] in records:
                raise ValueError('Duplicate generation key: ' + record['key'])
            records[record['key']] = (filename, record)
    count = 0
    for person in manifest['characters']:
        for form in person['forms']:
            key = person['key'] + ('_'+form['form'] if person['key'] == 'afei' else '')
            lines += ['## '+person['name']+(' · '+form['form'] if person['key'] == 'afei' else ''), '',
                      '- 最终文件：`'+form['source']+'`', '- SHA256：`'+form['source_sha256']+'`',
                      '- 选用记录：'+form['review_note'], '']
            if form.get('source_revision') == 'retired_alias':
                lines += ['不再使用蛤蟆原图；复用上面的正常阿飞源图，旧画刷 ID 仅用于存档兼容。', '']
                continue
            if form.get('source_revision') == 'blue_team_v24':
                filename = form['prompt_record']
                record = next(r for r in read(base / filename)['records'] if r['key'] == person['key'])
                lines += ['### 蓝队个人头像 · 内置 ImageGen', '', record['identity_basis'], '',
                          '完整记录：['+filename+']('+filename+')', '', '参考输入：', '']
                lines += ['- `'+ref+'`' for ref in record['references']]
                lines += ['', '生成器输出：`'+record['generated_original']+'`', '', '```text', record['prompt'], '```', '',
                          '颈部分界：`'+json.dumps(form['head_seam'])+'`。源图只作等比缩放和互补分层。', '']
                count += 1
                continue
            if form.get('source_revision') in ('user_v12', 'user_v17', 'user_v18', 'user_v23'):
                filename = form['prompt_record']
                record = next(r for r in read(base / filename)['records'] if r['key'] == person['key'])
                previous_source = form.get('before_user_v23_source') or form.get('before_user_v18_source') or form.get('before_user_v17_source') or form['before_user_v12_source']
                lines += ['### 用户参考重绘 · 内置 ImageGen', '',
                          '旧图：`'+previous_source+'`',
                          '完整记录：['+filename+']('+filename+')', '', '参考输入：', '']
                lines += ['- `'+ref+'`' for ref in record['references']]
                lines += ['', '生成器输出：`'+record['generated_original']+'`', '',
                          '```text', record['prompt'], '```', '',
                          '颈部分界：`'+json.dumps(form['head_seam'])+'`。原图只作等比缩放和无损分层。', '']
                count += 1
                continue
            if form.get('source_revision') == 'v17_identity_style_proportion':
                filename = form['pose_record']
                record = read(base / filename)
                lines += ['### 保留长相，修画风与比例 · 内置 ImageGen', '',
                          '参考旧稿：`'+record['reference']+'`',
                          '生成记录：['+filename+']('+filename+')', '',
                          '提示词约束整理：', '', '```text', record['constraints'], '```', '',
                          '颈部分界：`'+json.dumps(form['head_seam'])+'`；保留原版装备叠加。', '']
                count += 1
                continue
            if form.get('source_revision') == 'v05_facing':
                pose = read(base / form['pose_record'])
                edits = pose.get('entries', pose.get('records', []))
                edit = next(e for e in edits if e['brush'] == form['brush'])
                lines += ['### 朝右姿态修订', '', '保留身份和服装；头部、胸肩和视线一起朝右。', '',
                          '原图：`'+form['before_facing_source']+'`',
                          '完整记录：['+form['pose_record']+']('+form['pose_record']+')', '']
                lines += render_pose_calls(edit)
                if form.get('before_facing_revision') != 'v05':
                    lines += ['早期设计提示词见 [v0.4 归档](../portraits-v04/PROMPTS.md)。', '']
                    count += 1
                    continue
            elif form.get('source_revision') != 'v05':
                lines += ['本轮没有重新生图；提示词见 [v0.4 归档](../portraits-v04/PROMPTS.md)。', '']
                continue
            if key not in records:
                raise ValueError('Missing actual prompt for selected v05 source: '+key)
            filename, record = records[key]
            lines += ['完整机器记录：['+filename+']('+filename+')', '']
            attempts = record.get('attempts') or [record]
            for index, attempt in enumerate(attempts, 1):
                prompt = attempt.get('prompt')
                if not prompt:
                    raise ValueError('Missing exact attempt prompt: '+key)
                refs = attempt.get('references', attempt.get('referenced_image_paths', attempt.get('reference_paths', [])))
                output = attempt.get('original_output', attempt.get('original_output_path', attempt.get('generated_output', '')))
                if not output:
                    raise ValueError('Missing generator output provenance: '+key)
                lines += [f'### 调用 {index}', '', '参考输入：', ''] + ['- `'+p+'`' for p in refs]
                lines += ['', '生成器输出：`'+output+'`', '', '```text', prompt, '```', '']
            count += 1
    (base / 'PROMPTS.md').write_text('\n'.join(lines), encoding='utf-8')
    return count


if __name__ == '__main__':
    print(f'Rendered {render_prompts()} portrait prompt records.')
