# ShadowPlusing

基于 Flutter Web 的个人工作室与产品入口。Frequency Terminal 使用炭黑、酸黄和琥珀的仪器工作室视觉，首页以进入工具台为主任务，阅读与游戏为次级入口。

- 网站：[shadowplusing.cn](https://shadowplusing.cn/)
- 源码：[GitHub](https://github.com/shAdow-XJY-Manager/shadow-xjy-manager.github.io)
- 开发、字体打包、测试及发布步骤：[CMD_README.md](CMD_README.md)

## 运行环境

已验证：macOS、Flutter **3.35.7**、Dart **3.9.2**。当前维护平台为 **Web**；原生平台目录仍保留，但 Web 专用依赖使原生构建不在支持范围内。SDK 约束已与已验证工具链对齐：Dart ≥3.9、Flutter ≥3.35。

```sh
flutter pub get
flutter build web --no-pub --no-web-resources-cdn --release --pwa-strategy=none
python3 tool/preview_web.py --port 8765
```

打开 [本地预览](http://127.0.0.1:8765/)。`build/web/` 是构建输出；`docs/` 是历史发布产物，按维护约定保留，不能代表当前源码效果。

## 结构与内容维护

入口为 `lib/main.dart` → `lib/router/router.dart` → `lib/homepage/homePage.dart`。工具、阅读、游戏和完整目录均有独立 URL，支持深链接、刷新与浏览器返回；视频继续支持 `/#/videos/summer-preview`。

| 入口 | 修改路径 | 职责 |
| --- | --- | --- |
| 首页 `/#/` | `lib/indexPage/indexHome/indexHome.dart` | 工作室身份、进入工具台、阅读与游戏入口 |
| 工具 `/#/tools`、阅读 `/#/read`、游戏 `/#/play` | `lib/portal/projectCatalog.dart` | 用途搜索、身份筛选、项目详情与启动/说明入口 |
| 全部作品 `/#/projects` | `lib/innerAssets/projectAsset/projectData.dart` | 对齐47个子模块的真实项目目录 |
| 项目详情 `/#/projects/:id` | `lib/portal/projectCatalog.dart` | 用途与运行身份，独立应用或源码/文档 |
| 放映室 `/#/videos` | `lib/innerAssets/videoAsset/videoData.dart` | 类型化视频数据与三种来源 |
| 关于、收藏、背景音乐 | `lib/homepage/homePage.dart` 与对应内容组件 | 作者/社区、可放大收藏图片、主动音乐播放 |

校园价格、校园交易、TV、readingReader、writingWriter 保持原生应用职责，仅提供说明/源码入口，不能为统一风格强行迁 Web。组件库维持可复用身份。目录中的独立应用地址不等于远端部署健康保证，发布配置与应用流程需要分别核验。

共享主题为 `flutter_common` 的 `FrequencyPalette` / `FrequencyTheme.dark()`；门户旧 `global/siteStyle.dart` 仅兼容 re-export。新增文案需更新字体子集，新增资产目录或依赖声明交工程负责人处理。

## 运行资源

- 首页仪器照片 `assets/image/frequency-hero.webp`、琥珀按钮背景 `frequency-action.webp`、黑金属任务面板 `frequency-panel.webp`，合计118,352 bytes。标题、导航与按钮是真实控件，图片没有烘焙网页文字。
- 头像 `assets/image/avatar.jpg`、收藏 `assets/image/favorite/`、视频封面 `assets/image/video/`、兼容集合数据的 `assets/image/collections/` 与原媒体资源保留。
- 已移除真正无引用的旧 `background.jpg`、五张 `book/redesign/` 图片及三个 `icon/` 社交图标。删除前的可恢复归档和校验清单保留在 Git 外；历史 `docs/` 副本未修改。
- 正文与控件采用已授权 Noto Sans SC 的 FrequencySans 400/900 子集，合计241,552 bytes；许可见 `assets/fonts/site/NotoSansSC_LICENSE.txt`。WDXL只保留旧大标题兼容，WDXL子集沿用已登记的 `assets/fonts/WDXLLubrifontSC-Regular.ttf`，当前500字符覆盖无缺失；Roboto / SiteBody 用于正文。完整源字体、字符清单、工具环境继续保存在忽略的 `local/`。
- 运行许可 `assets/fonts/WDXL_LICENSE.txt`（OFL1.1）与 `assets/fonts/site/Roboto_LICENSE.txt`（Apache2.0）保留，不随普通资料清理删除。
- 概念图、生成原图、过程文档、日志、截图和QA报告放 Git 外；仅运行必要压缩资源保留在源码。

## 导航与视频

- 桌面顶部按工具、阅读、游戏导航，更多菜单提供全部作品、放映室、关于、收藏与音乐；窄屏使用抽屉。
- 视频列表在桌面为16:9封面卡片、手机为紧凑列表；点击直接进入独立播放视图，返回保留列表位置与焦点。
- 站内视频统一使用原生 HTML 控制条，支持播放、暂停、进度、音量与浏览器全屏；加载失败有重试和换源。嵌入来源保留原站入口。
- 进入播放视图暂停本站背景音乐，返回不自动恢复；换源和退出会释放旧媒体元素与订阅。
- 原中文视频改名为 `assets/video/summer-preview.mp4`，避免构建输出文件名编码差异；不要恢复按 debug/release 猜测编码次数的分支。

## 后续优化边界

手机选择目的后关闭抽屉，媒体/音乐互斥，公共组件尊重减少动画。真实设备动画帧耗时仍需测量，不能声称首次卡顿彻底消失。Edge普通窗口曾出现图标缺失，而InPrivate正常；当前字体与源码包含全部六个导航图标，排查步骤见CMD_README。保留字体裁剪，不把浏览器个人配置问题改成一套专用图标。Web媒体仍使用 `dart:html`，音频依赖也有Web限制，本轮不承诺Wasm。旧文章生成流程已脱离当前导航。

手工目录工具保留为 `test/file_operation.dart`，不带 `_test` 后缀，避免测试套件自动执行它的 Windows 路径创建逻辑。
