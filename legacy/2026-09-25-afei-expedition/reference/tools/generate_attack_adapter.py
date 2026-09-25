from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
p=ROOT.parents[1]/'app/build/full-l10n/decompiled/scripts/skills/skill.nut'
text=p.read_text(encoding='utf-8');start=text.index('\tfunction attackEntity(');end=text.index('\n\tfunction ',start+1)
method=text[start:end]
method=method.replace('function attackEntity(', 'o.attackEntity = function(',1).rstrip()+';'
needle='\t\tlocal defenderProperties = _targetEntity.getSkills().buildPropertiesForDefense(_user, this);'
assert needle in method
method=method.replace(needle,'''\t\tif (::AfeiExpedition.isAfeiOrigin()) {
            _targetEntity = ::AfeiExpedition.intercept(_user, this, _targetEntity, true);
            properties = this.m.Container.buildPropertiesForUse(this, _targetEntity);
        }
'''+needle)
needle='\t\t_targetEntity.onAttacked(_user);';assert needle in method
method=method.replace(needle,'\t\tif (::AfeiExpedition.isAfeiOrigin()) ::AfeiExpedition.attackAttempt(_user, this, _targetEntity);\n'+needle)
p=ROOT/'src/scripts/mods/afei/attack_adapter.nut'
p.write_text('// Preserve native hit, armor and ranged diversion calculation.\n::mods_hookExactClass("skills/skill", function(o) {\n'+method+'\n});',encoding='utf-8')
print('Generated final-target attack adapter')
