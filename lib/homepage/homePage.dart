import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import '../global/musicPlayer.dart';
import '../innerAssets/videoAsset/videoData.dart';
import '../innerAssets/projectAsset/projectData.dart';
import '../indexPage/indexVideo/videoWatch.dart';
import '../indexPage/indexFavorite/indexFavorite.dart';
import '../indexPage/indexHome/indexHome.dart';
import '../indexPage/indexVideo/indexVideo.dart';
import '../portal/projectCatalog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.video, this.initialSection = 0,
    this.onSectionSelected, this.project, this.errorRoute});
  final VideoEntry? video;
  final int initialSection;
  final ValueChanged<int>? onSectionSelected;
  final ProjectEntry? project;
  final String? errorRoute;
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _music = GlobalKey<MusicPlayerState>();
  final _pageStorage = PageStorageBucket();
  bool _navigating = false;
  late final int _selectedIndex = widget.video == null ? widget.initialSection : 1;
  static const _routes = ['/', '/videos', '/tools', '/projects', '/about', '/favorites', '/read', '/play', '/listen'];
  static const _labels = ['首页', '放映室', '工具', '全部作品', '关于工作室', '收藏', '阅读', '游戏', '背景音乐'];

  Future<void> _openVideo(VideoEntry video) async {
    await _music.currentState?.suspend();
    if (!mounted) return;
    final section = await Navigator.of(context).pushNamed('/videos/${video.id}');
    if (!mounted) return;
    _music.currentState?.release();
    if (section is int) _select(section);
  }

  void selectSection(int index) => _select(index);
  Future<void> _select(int index) async {
    if (index < 0 || index >= _routes.length || _navigating) return;
    if (widget.video != null) {
      Navigator.of(context).pop(index);
      widget.onSectionSelected?.call(index);
      return;
    }
    if (index == _selectedIndex && widget.project == null && widget.errorRoute == null) return;
    _navigating = true;
    await _music.currentState?.suspend();
    if (!mounted) return;
    try { await Navigator.of(context).pushNamed(_routes[index]); }
    finally { _navigating = false; if (mounted) _music.currentState?.release(); }
  }

  Widget _body() {
    if (widget.errorRoute != null) return SingleChildScrollView(child: Center(child: Padding(padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.explore_off_outlined, color: FrequencyPalette.accent, size: 48),
        const SizedBox(height: 24), const Text('这个频率暂时没有节目。', style: TextStyle(fontSize: 28)),
        const SizedBox(height: 12), const Text('地址可能已变化。可以回工作室，或从作品目录重新查找。'),
        const SizedBox(height: 24), FilledButton(onPressed: () => _select(0), child: const Text('回到工作室')),
      ]))));
    if (widget.video != null) return VideoWatch(video: widget.video!);
    if (widget.project != null) return ProjectCatalog(project: widget.project);
    return switch (_selectedIndex) {
      0 => IndexHome(onSelected: _select),
      1 => IndexVideo(onOpen: _openVideo),
      2 => const ProjectCatalog(section: '工具'),
      3 => const ProjectCatalog(),
      4 => _about(),
      5 => const IndexFavorite(),
      6 => const ProjectCatalog(section: '阅读'),
      7 => const ProjectCatalog(section: '游戏'),
      8 => _listening(),
      _ => const ProjectCatalog(),
    };
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
    final mobile = constraints.maxWidth < 700 || MediaQuery.textScalerOf(context).scale(16) > 24;
    return Scaffold(backgroundColor: FrequencyPalette.background,
      drawer: mobile ? Drawer(child: SafeArea(child: ListView(children: [
        const ListTile(title: Text('shAdow 工作室', style: TextStyle(fontSize: 24))),
        for (final index in [0, 2, 6, 7, 3, 1, 4, 5, 8]) ListTile(
          selected: index == _selectedIndex, title: Text(_labels[index]),
          onTap: () { Navigator.of(context).pop(); _select(index); }),
      ]))) : null,
      body: SafeArea(child: Column(children: [
        Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: FrequencyPalette.border))),
          padding: EdgeInsets.symmetric(horizontal: mobile ? 12 : 36, vertical: 18),
          child: Row(children: [
            if (mobile) Builder(builder: (context) => IconButton(tooltip: '打开导航',
              onPressed: () => Scaffold.of(context).openDrawer(), icon: const Icon(Icons.menu))),
            Expanded(child: InkWell(onTap: () => _select(0), child: Row(children: [
              if (!mobile) ...[Image.asset('assets/image/frequency-mark.webp', width: 48, height: 48, fit: BoxFit.contain, excludeFromSemantics: true, errorBuilder: (_, __, ___) => const SizedBox(width: 48, height: 48)), const SizedBox(width: 20)],
              Flexible(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('shAdow 工作室', style: TextStyle(fontSize: mobile ? 22 : 26, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('频率站 / Frequency Terminal', style: TextStyle(fontSize: mobile ? 12 : 14, color: FrequencyPalette.muted)),
              ])),
            ]))),
            if (!mobile) ...[
              for (final index in [2, 6, 7]) Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _nav(index)),
              const SizedBox(width: 20),
            ],
            if (!mobile) PopupMenuButton<int>(tooltip: '更多工作室入口',
              onSelected: _select, icon: const Icon(Icons.more_horiz), itemBuilder: (_) => [
                for (final index in [3, 1, 4, 5, 8]) PopupMenuItem(value: index, child: Text(_labels[index])),
              ]),
          ])),
        Expanded(child: PageStorage(bucket: _pageStorage, child: _body())),
      ])),
    );
  });

  Widget _nav(int index) => TextButton(onPressed: () => _select(index),
    style: TextButton.styleFrom(foregroundColor: (_selectedIndex == index || (_selectedIndex == 0 && index == 2)) ? FrequencyPalette.accent : FrequencyPalette.muted,
      minimumSize: const Size(80, 48)),
    child: Text(_labels[index], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)));

  Widget _about() => SingleChildScrollView(padding: const EdgeInsets.all(32), child: Center(
    child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 760), child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 32),
        ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset('assets/image/avatar.jpg', width: 96, height: 96, fit: BoxFit.cover, semanticLabel: 'ShadowPlusing 头像')),
        const SizedBox(height: 24),
        const Text('把灵感，变成可用的东西。', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700)),
        const SizedBox(height: 24),
        const Text('这里是 shAdow 的个人工作室。工具、故事、音乐和小游戏，都是日常创作留下的作品。\n\n每个作品保持自己的用途与节奏；工作室帮你找到入口。', style: TextStyle(fontSize: 18, height: 1.7)),
        const SizedBox(height: 32),
        Wrap(spacing: 16, runSpacing: 16, children: [
          OutlinedButton.icon(onPressed: () => openProjectLink(context, 'https://github.com/shAdow-XJY-Manager'), icon: const Icon(Icons.code), label: const Text('GitHub')),
          OutlinedButton.icon(onPressed: () => openProjectLink(context, 'https://space.bilibili.com/437699902'), icon: const Icon(Icons.video_library_outlined), label: const Text('Bilibili')),
          OutlinedButton.icon(onPressed: () => openProjectLink(context, 'https://github.com/shAdow-XJY-Manager/XJY.COM.ORG.Community/discussions'), icon: const Icon(Icons.forum_outlined), label: const Text('社区讨论')),
        ]),
        const SizedBox(height: 32),
        TextButton(onPressed: () => _select(1), child: const Text('去放映室看看')),
        TextButton(onPressed: () => _select(5), child: const Text('看看收藏')),
      ]))));

  Widget _listening() => SingleChildScrollView(child: Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(
    mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.headphones, size: 48, color: FrequencyPalette.accent),
      const SizedBox(height: 24), const Text('给此刻一点声音。', style: TextStyle(fontSize: 28)),
      const SizedBox(height: 16), const Text('主动播放；离开本页或进入视频时暂停。返回后不会自动播放。', textAlign: TextAlign.center),
      const SizedBox(height: 24), MusicPlayer(key: _music),
    ]))));
}
