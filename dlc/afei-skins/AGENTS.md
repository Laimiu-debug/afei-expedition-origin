# 阿飞衣橱 DLC 开发约定

- 本目录是独立可选美术 DLC。用户明确要求不合并进主 Mod；未经后续明确要求，不写主包 `src`、根版本或根 `dist`，不安装、发布、推送或合并到 main。
- 保持独立 Mod ID `mod_afeix_dlc_afei_skins`、图集 `afeix_dlc_afei_skins_v01`、运行脚本目录 `afeix_dlc_afei_skins`、画刷前缀 `afeix_dlc_skins_` 和存档旗标 `afeix_dlc_afei_skins_style`。
- 加载顺序主包 → 本 DLC；不引入兄弟 DLC 依赖、反向依赖、重复注册或递归刷新。DLC 只包装主包已有辅助函数；死亡、复活、装备和保存仍由主包钩子处理。
- 用户照片只作为美术参考，不进安装包。生成母图、最终提示词和对应 PNG 保存到本目录；不得以代码绘图替代生成模型重绘人物。
- 美术导出通过现有仓库工具做透明边界裁剪、等比缩放、头身分层及图集格式转换。修改 `head_seam`、`neck_guard` 后必须检查 `art/neck-review.png` 和 `art/equipment-preview.png`，保证完整下巴、短颈和装备叠加。
- F8 公司页及所有分页都不能超过原版六按钮；点击即切换并留在本页，保留恢复原有外观和 Esc 关闭。
- 验证与打包入口是 `python dlc/afei-skins/build.py`。更新运行脚本或资产后重跑相关检查并更新包与报告；仅改说明不重复运行整套测试。
- 不把离线图片叫作游戏截图，不把离线测试称作游戏验收。实际安装、游戏与第三方 Mod 组合另行记录。
