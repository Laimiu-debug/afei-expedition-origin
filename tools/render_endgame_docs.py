"""Refresh current player-facing profiles without regenerating historical design."""
import json
from pathlib import Path
import re

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'docs/design/balance-v2'
def main():
    source=(ROOT/'tools/balance_v1_render.py').read_text(encoding='utf-8')
    source=source.split("lines=['# 全技能契约",1)[0]
    source=source.replace("OUT=ROOT/'docs/design/balance-v1'","OUT=ROOT/'docs/design/balance-v2'")
    source=source.replace('34人','35人').replace('本稿未实装。','主包v0.28.4已实装，含可选DLC培养；实机战斗尚未验收。')
    source=source.replace('一级值不含装备、剧情','一级值含固定原版特质，不重复加算；不含装备、剧情')
    source=source.replace('现行定位：','历史快照定位：').replace("'现行一级','建议一级'","'历史快照一级','当前一级'")
    exec(compile(source,str(ROOT/'tools/balance_v1_render.py'),'exec'),{'__file__':str(ROOT/'tools/balance_v1_render.py'),'__name__':'endgame_profiles'})
    p=json.loads((OUT/'proposal.json').read_text(encoding='utf-8'))
    doc=OUT/'技能总表.md';text=doc.read_text(encoding='utf-8')
    for s in p['skills']:
        if not s.get('specialized_mastery'):continue
        pattern=r'(### '+re.escape(s['name'])+r' `'+re.escape(s['key'])+r'`[\s\S]*?\*\*11级\*\*：)[^\n]*'
        text,count=re.subn(pattern,lambda m:m[1]+s['mastery'],text,count=1)
        assert count==1,s['key']
    for q in p['people']:
        text=re.sub(r'^## '+re.escape(q['name'])+r' · [^\n]+',f"## {q['name']} · {q['role']}",text,flags=re.M)
    text=re.sub(r'本稿数值已实装至 v[^；\n]+', '本稿数值已实装至 v0.28.4 / DLC 0.2.4',text,count=1)
    text=re.sub(r'^状态：已实装至 v[^，\n]+', '状态：已实装至 v0.28.4 / DLC 0.2.4',text,count=1,flags=re.M)
    doc.write_text(text,encoding='utf-8')
    readme=OUT/'README.md';old=readme.read_text(encoding='utf-8')
    note='**2026-09-30终局岗位平衡已实装至v0.28.4：各角色基础八维总和、天赋总星数保持原预算，35份培养仍各30项。生命/决心/先攻取舍和六项岗位精通见[本轮改动](../endgame-balance-20260930.md)。希文培养本体决心33、戴镜53；旧正文保留为历史说明，以本轮改动与当前总表为准。实机验收待完成。**'
    if note not in old:readme.write_text(old.replace('\n\n','\n\n'+note+'\n\n',1),encoding='utf-8')
    release=ROOT/'docs/releases/v0.28.4.md'
    release.write_text('''# v0.28.4：终局岗位数值平衡

按全员定位方案复核34名主包成员及可选DLC希文。每人基础八维总和、总天赋星数保持预算，30项培养分配重排；费用、装备、招募和剧情成长沿用现有配置。

- 宋暖阳以生命换部分先攻和疲劳培养，11级裸均值66→84生命，141→130先攻。
- 苏袜重排总5星与培养，11级69→81生命、81→86近攻、24→30近防。
- 小鱼、瑶瑶牙、玩蛇等补足生命/决心容错，区分低耗双手、持续破甲与单手续击。
- 旗手减少补刀培养，增加号令疲劳；弓弩减少固定远防培养，补生命和行动空间。盾卫按相邻护卫、中央稳线、防远程、伤员掩护等职责区分。
- 六个被动精通改为增强本岗位效果，替换原通用自身恢复+1，维持已有触发和叠加上限。
- 旧档基础属性差额仅同步一次；保留已分配属性、技能选择，不自动治疗；若当前生命超过降低后的新上限，仅下调至上限。苏袜只调整未使用的普通升级队列，不重掷老兵+1。培养建议不会替玩家洗点。

完整数字、35份培养和3/6轮资源预算见[终局平衡说明](../design/endgame-balance-20260930.md)。希文保持可选DLC；本体/饰品决心分别计算。飞碟新的站位协同玩法本轮未新增。

离线行为、原版费用、表格重算与打包检查记录于构建报告；真实战斗与长期战役仍待验收，资源模型不代表胜率。
''',encoding='utf-8')
    print('Updated 35 profiles, six mastery entries, design index and release notes.')
if __name__=='__main__':main()
