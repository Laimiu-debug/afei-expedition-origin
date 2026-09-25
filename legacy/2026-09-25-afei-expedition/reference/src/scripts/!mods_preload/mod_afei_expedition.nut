// Battle Brothers 1.5.2.3 / Legacy Modding Script Hooks.
::AfeiExpedition <- { ID="mod_afei_expedition", Name="大飞午远征团", Version=4, Schema=4 };
::AfeiExpedition.setdelegate(getroottable());
foreach (part in ["definitions","core","world","growth","combat","actions","journeys","events","banter","rules"]) ::include("scripts/mods/afei/"+part);
// 注册必须传数字字面量：mod_hooks 只接受数字版本，静态校验也按字面量解析符号引用
::mods_registerMod("mod_afei_expedition", 4, "大飞午远征团");
::mods_queue(::AfeiExpedition.ID, null, function() { ::include("scripts/mods/afei/hooks"); });
