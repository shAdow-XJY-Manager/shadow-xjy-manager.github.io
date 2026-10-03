class ProjectEntry {
  const ProjectEntry(this.id, this.title, this.description, this.category,
      this.kind, this.sourceUrl, this.launchUrl);
  final String id, title, description, category, kind, sourceUrl;
  // A destination candidate from the actual repository identity. Runtime and
  // publication health is verified separately; source always remains available.
  final String? launchUrl;
  bool matches(String query) => '$title $description $category $kind $id'
      .toLowerCase().contains(query.trim().toLowerCase());
}

const projectEntries = <ProjectEntry>[
  ProjectEntry("Community", "社区讨论", "交流、反馈与项目讨论。", "系统社区", "本地与源码", "https://github.com/shAdow-XJY-Manager/XJY.COM.ORG.Community", null),
  ProjectEntry("Workers", "站点代理", "自定义域名的静态站点代理。", "系统社区", "本地与源码", "https://github.com/shAdow-XJY-Manager/XJY.COM.ORG.Workers", null),
  ProjectEntry("musicListen", "音乐随听", "选一首音乐，听见自己的节奏。", "阅读创作", "在线应用", "https://github.com/shAdow-XJY-Manager/XJY.ENT.MUSI.musicListen", "https://shadow-xjy-manager.github.io/XJY.ENT.MUSI.musicListen/"),
  ProjectEntry("tv", "Shadow TV", "选择来源和节目，进入视频播放。", "阅读创作", "原生应用", "https://github.com/shAdow-XJY-Manager/XJY.ENT.VIDEO.tv", null),
  ProjectEntry("comicRead", "漫画阅读", "进入漫画目录，按章节浏览画面。", "阅读创作", "在线应用", "https://github.com/shAdow-XJY-Manager/XJY.ENT.READ.comicRead", "https://shadow-xjy-manager.github.io/XJY.ENT.READ.comicRead/"),
  ProjectEntry("novelRead", "小说阅读", "打开小说、选择章节，安静读一会。", "阅读创作", "在线应用", "https://github.com/shAdow-XJY-Manager/XJY.ENT.READ.novelRead", "https://shadow-xjy-manager.github.io/XJY.ENT.READ.novelRead/"),
  ProjectEntry("gameCenter", "Game Center", "找到一个游戏，读懂规则，开始一局。", "游戏", "在线应用", "https://github.com/shAdow-XJY-Manager/XJY.GAME.COMP.gameCenter", "https://shadow-xjy-manager.github.io/XJY.GAME.COMP.gameCenter/"),
  ProjectEntry("world_flutter", "World · Flutter", "独立项目与实现记录；查看说明和源代码了解使用方式。", "游戏", "在线应用", "https://github.com/shAdow-XJY-Manager/XJY.GAME.COMP.world_flutter", "https://shadow-xjy-manager.github.io/XJY.GAME.COMP.world_flutter/"),
  ProjectEntry("world_vue", "World · Vue", "独立项目与实现记录；查看说明和源代码了解使用方式。", "游戏", "本地与源码", "https://github.com/shAdow-XJY-Manager/XJY.GAME.COMP.world_vue", null),
  ProjectEntry("superMario_QT", "超级马里奥 · Qt", "独立项目与实现记录；查看说明和源代码了解使用方式。", "游戏", "本地与源码", "https://github.com/shAdow-XJY-Manager/XJY.GAME.MARIO.superMario_QT", null),
  ProjectEntry("findDifferencesGame", "找不同", "仔细观察两幅画，找出不同。", "游戏", "在线应用", "https://github.com/shAdow-XJY-Manager/XJY.GAME.MINI.findDifferencesGame", "https://shadow-xjy-manager.github.io/XJY.GAME.MINI.findDifferencesGame/"),
  ProjectEntry("flipChess_flutter", "翻棋", "翻开棋子，选择合法动作。", "游戏", "在线应用", "https://github.com/shAdow-XJY-Manager/XJY.GAME.MINI.flipChess_flutter", "https://shadow-xjy-manager.github.io/XJY.GAME.MINI.flipChess_flutter/"),
  ProjectEntry("parkourGame", "跑酷", "看准时机跳跃，尝试跑得更远。", "游戏", "在线应用", "https://github.com/shAdow-XJY-Manager/XJY.GAME.MINI.parkourGame", "https://shadow-xjy-manager.github.io/XJY.GAME.MINI.parkourGame/"),
  ProjectEntry("rockPaperScissors", "石头剪刀布", "做出选择，看看这一回合谁更胜一筹。", "游戏", "在线应用", "https://github.com/shAdow-XJY-Manager/XJY.GAME.MINI.rockPaperScissors", "https://shadow-xjy-manager.github.io/XJY.GAME.MINI.rockPaperScissors/"),
  ProjectEntry("snakeGame", "贪吃蛇", "转向、吃食物，把蛇养得更长。", "游戏", "在线应用", "https://github.com/shAdow-XJY-Manager/XJY.GAME.MINI.snakeGame", "https://shadow-xjy-manager.github.io/XJY.GAME.MINI.snakeGame/"),
  ProjectEntry("ticTacToe", "井字棋", "落下你的棋子，连成一条线。", "游戏", "在线应用", "https://github.com/shAdow-XJY-Manager/XJY.GAME.MINI.ticTacToe", "https://shadow-xjy-manager.github.io/XJY.GAME.MINI.ticTacToe/"),
  ProjectEntry("pvz_flutter", "植物大战僵尸", "独立项目与实现记录；查看说明和源代码了解使用方式。", "游戏", "在线应用", "https://github.com/shAdow-XJY-Manager/XJY.GAME.PVZ.pvz_flutter", "https://shadow-xjy-manager.github.io/XJY.GAME.PVZ.pvz_flutter/"),
  ProjectEntry("backendService", "Dart 服务练习", "独立项目与实现记录；查看说明和源代码了解使用方式。", "学习实验", "学习", "https://github.com/shAdow-XJY-Manager/XJY.LEARN.BE.backendService", null),
  ProjectEntry("sqlAPI", "MyBatis API", "独立项目与实现记录；查看说明和源代码了解使用方式。", "学习实验", "学习", "https://github.com/shAdow-XJY-Manager/XJY.LEARN.BE.sqlAPI", null),
  ProjectEntry("sqlAPI2", "MyBatis Plus API", "独立项目与实现记录；查看说明和源代码了解使用方式。", "学习实验", "学习", "https://github.com/shAdow-XJY-Manager/XJY.LEARN.BE.sqlAPI2", null),
  ProjectEntry("componentPassMessage_vue", "Vue 组件通信", "独立项目与实现记录；查看说明和源代码了解使用方式。", "学习实验", "学习", "https://github.com/shAdow-XJY-Manager/XJY.LEARN.FE.componentPassMessage_vue", null),
  ProjectEntry("filePass", "图片上传练习", "独立项目与实现记录；查看说明和源代码了解使用方式。", "学习实验", "学习", "https://github.com/shAdow-XJY-Manager/XJY.LEARN.FE.filePass", null),
  ProjectEntry("filePass2", "媒体流传输练习", "独立项目与实现记录；查看说明和源代码了解使用方式。", "学习实验", "学习", "https://github.com/shAdow-XJY-Manager/XJY.LEARN.FE.filePass2", null),
  ProjectEntry("jsCoding", "JavaScript 编程题", "独立项目与实现记录；查看说明和源代码了解使用方式。", "学习实验", "学习", "https://github.com/shAdow-XJY-Manager/XJY.LEARN.FE.jsCoding", null),
  ProjectEntry("passData", "HTML 参数传递", "独立项目与实现记录；查看说明和源代码了解使用方式。", "学习实验", "学习", "https://github.com/shAdow-XJY-Manager/XJY.LEARN.FE.passData", null),
  ProjectEntry("routerTrain_vue", "Vue Router 练习", "独立项目与实现记录；查看说明和源代码了解使用方式。", "学习实验", "学习", "https://github.com/shAdow-XJY-Manager/XJY.LEARN.FE.routerTrain_vue", null),
  ProjectEntry("webpack", "Webpack 入门", "独立项目与实现记录；查看说明和源代码了解使用方式。", "学习实验", "学习", "https://github.com/shAdow-XJY-Manager/XJY.LEARN.FE.webpack", null),
  ProjectEntry("learnDodgeTheCreeps_GoDot", "Godot 入门游戏", "独立项目与实现记录；查看说明和源代码了解使用方式。", "学习实验", "学习", "https://github.com/shAdow-XJY-Manager/XJY.LEARN.learnDodgeTheCreeps_GoDot", null),
  ProjectEntry("xcodeProject", "iOS 学习记录", "独立项目与实现记录；查看说明和源代码了解使用方式。", "学习实验", "学习", "https://github.com/shAdow-XJY-Manager/XJY.LEARN.xcodeProject", null),
  ProjectEntry("campusPrice", "校园价格", "独立项目与实现记录；查看说明和源代码了解使用方式。", "系统社区", "原生应用", "https://github.com/shAdow-XJY-Manager/XJY.SYS.campusPrice", null),
  ProjectEntry("readingReader", "创作阅读端", "阅读从写作工作台导出的作品。", "阅读创作", "原生应用", "https://github.com/shAdow-XJY-Manager/XJY.SYS.CREA.readingReader", null),
  ProjectEntry("writingWriter", "写作工作台", "本地写作、组织卷章和人物，继续你的故事。", "阅读创作", "原生应用", "https://github.com/shAdow-XJY-Manager/XJY.SYS.CREA.writingWriter", null),
  ProjectEntry("secondHandHouse_flask", "房产数据助手", "独立项目与实现记录；查看说明和源代码了解使用方式。", "系统社区", "本地与源码", "https://github.com/shAdow-XJY-Manager/XJY.SYS.secondHandHouse_flask", null),
  ProjectEntry("schoolSecondhandApp_flutter", "校园二手交易", "独立项目与实现记录；查看说明和源代码了解使用方式。", "系统社区", "原生应用", "https://github.com/shAdow-XJY-Manager/XJY.SYS.TRADE.schoolSecondhandApp_flutter", null),
  ProjectEntry("schoolSecondhandApp_springBoot", "校园交易服务", "独立项目与实现记录；查看说明和源代码了解使用方式。", "系统社区", "本地与源码", "https://github.com/shAdow-XJY-Manager/XJY.SYS.TRADE.schoolSecondhandApp_springBoot", null),
  ProjectEntry("blurGlass", "Blur Glass", "可复用的 Flutter 背景模糊容器。", "工具组件", "组件", "https://github.com/shAdow-XJY-Manager/XJY.UTIL.blurGlass", null),
  ProjectEntry("clickTextField", "Click Text Field", "识别并操作文本中的高亮片段。", "工具组件", "组件", "https://github.com/shAdow-XJY-Manager/XJY.UTIL.clickTextField", null),
  ProjectEntry("fontRegenerated", "字体变形", "独立项目与实现记录；查看说明和源代码了解使用方式。", "工具组件", "本地与源码", "https://github.com/shAdow-XJY-Manager/XJY.UTIL.FONT.fontRegenerated", null),
  ProjectEntry("fontToolExe", "字体工具执行层", "独立项目与实现记录；查看说明和源代码了解使用方式。", "工具组件", "本地与源码", "https://github.com/shAdow-XJY-Manager/XJY.UTIL.FONT.fontToolExe", null),
  ProjectEntry("subFontPackage", "字体裁剪", "在桌面上选择字体并按需裁剪字形。", "工具组件", "本地与源码", "https://github.com/shAdow-XJY-Manager/XJY.UTIL.FONT.subFontPackage", null),
  ProjectEntry("listTwoLevel", "Two Level List", "可配置的 Flutter 双层列表组件。", "工具组件", "组件", "https://github.com/shAdow-XJY-Manager/XJY.UTIL.listTwoLevel", null),
  ProjectEntry("browserExtensions", "浏览器扩展实验", "独立项目与实现记录；查看说明和源代码了解使用方式。", "工具组件", "本地与源码", "https://github.com/shAdow-XJY-Manager/XJY.UTIL.WEB.browserExtensions", null),
  ProjectEntry("customSearchPage", "自定义搜索", "选择搜索引擎，让查找更顺手。", "工具组件", "在线应用", "https://github.com/shAdow-XJY-Manager/XJY.UTIL.WEB.customSearchPage", "https://shadow-xjy-manager.github.io/XJY.UTIL.WEB.customSearchPage/"),
  ProjectEntry("fakeBrowser", "本地网页启动器", "独立项目与实现记录；查看说明和源代码了解使用方式。", "工具组件", "本地与源码", "https://github.com/shAdow-XJY-Manager/XJY.UTIL.WEB.fakeBrowser", null),
  ProjectEntry("websiteTools", "Web 工具台", "处理图片、调整尺寸，把一个小任务做完。", "工具组件", "在线应用", "https://github.com/shAdow-XJY-Manager/XJY.UTIL.WEB.websiteTools", "https://shadow-xjy-manager.github.io/XJY.UTIL.WEB.websiteTools/"),
  ProjectEntry("shadow-xjy-manager.github.io", "shAdow 工作室", "独立项目与实现记录；查看说明和源代码了解使用方式。", "工作室", "工作室", "https://github.com/shAdow-XJY-Manager/shadow-xjy-manager.github.io", "https://shadowplusing.cn/"),
  ProjectEntry("flutter_common", "Flutter Common", "共享主题、输入、布局与内容组件。", "工具组件", "组件", "https://github.com/shAdow-XJY-Manager/XJY.UTIL.PAC.FlutterCommon", null),
];

ProjectEntry? projectById(String id) {
  for (final entry in projectEntries) {
    if (entry.id == id) return entry;
  }
  return null;
}
