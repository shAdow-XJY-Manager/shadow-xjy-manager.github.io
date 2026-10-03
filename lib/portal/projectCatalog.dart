import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:url_launcher/url_launcher.dart';
import '../innerAssets/projectAsset/projectData.dart';

Future<void> openProjectLink(BuildContext context, String url) async {
  try {
    if (await launchUrl(Uri.parse(url), webOnlyWindowName: '_blank')) return;
  } catch (_) {
    // A blocked new tab is recoverable without changing the current selection.
  }
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: const Text('暂时无法打开，请检查网络或允许新窗口。'),
    action: SnackBarAction(label: '重试', onPressed: () => openProjectLink(context, url)),
  ));
}

class ProjectCatalog extends StatefulWidget {
  const ProjectCatalog({super.key, this.section = '全部', this.project});
  final String section;
  final ProjectEntry? project;
  @override
  State<ProjectCatalog> createState() => _ProjectCatalogState();
}

class _ProjectCatalogState extends State<ProjectCatalog> {
  String _query = '';
  String _kind = '全部';
  late final TextEditingController _search = TextEditingController();
  @override
  void dispose() { _search.dispose(); super.dispose(); }

  bool _inSection(ProjectEntry entry) => switch (widget.section) {
    '工具' => entry.category == '工具组件' && entry.kind != '组件',
    '阅读' => entry.category == '阅读创作',
    '游戏' => entry.category == '游戏',
    _ => true,
  };

  String get _title => switch (widget.section) {
    '工具' => '把小任务，做得顺手。',
    '阅读' => '继续读，也继续写。',
    '游戏' => '换个节奏，玩一会。',
    _ => '作品与实验',
  };

  String get _intro => switch (widget.section) {
    '工具' => '从图片处理到搜索。选一个用途，再进入独立工具。',
    '阅读' => '小说、漫画、写作和影音，各有自己的空间。进度与内容保留在对应应用。',
    '游戏' => '读懂规则，主动开始。在线游戏与本地项目清楚分开。',
    _ => '工作室里的工具、故事、游戏和代码记录。按用途找，不必先理解技术。',
  };

  @override
  Widget build(BuildContext context) {
    if (widget.project != null) return _detail(widget.project!);
    final entries = projectEntries.where(_inSection).where((entry) =>
      entry.matches(_query) && (_kind == '全部' || entry.kind == _kind)).toList();
    final kinds = {'全部', ...projectEntries.where(_inSection).map((entry) => entry.kind)};
    final largeText = MediaQuery.textScalerOf(context).scale(16) > 24;
    return SingleChildScrollView(
      key: PageStorageKey('catalog-${widget.section}'),
      padding: const EdgeInsets.all(24),
      child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1120),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 24),
          Text(widget.section == '全部' ? 'STUDIO INDEX' : 'FREQUENCY / ${widget.section}',
            style: const TextStyle(color: FrequencyPalette.accent, fontSize: 12, letterSpacing: 2)),
          const SizedBox(height: 12),
          Text(_title, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Text(_intro, style: const TextStyle(fontSize: 16, height: 1.6, color: FrequencyPalette.muted)),
          const SizedBox(height: 32),
          if (largeText) ...[
            const ExcludeSemantics(child: Text('搜索名称或用途')),
            const SizedBox(height: 8),
          ],
          Semantics(label: largeText ? '搜索名称或用途' : null,
            child: AppSearchBar(controller: _search, hintText: largeText ? '' : '搜索名称或用途',
              onChanged: (value) => setState(() => _query = value))),
          const SizedBox(height: 16),
          Wrap(spacing: 8, runSpacing: 8, children: [for (final kind in kinds)
            ChoiceChip(label: Text(kind), selected: _kind == kind,
              onSelected: (_) => setState(() => _kind = kind))]),
          const SizedBox(height: 24),
          Text('${entries.length} 项', style: const TextStyle(color: FrequencyPalette.muted)),
          const SizedBox(height: 12),
          if (entries.isEmpty)
            Padding(padding: const EdgeInsets.symmetric(vertical: 48), child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('还没有匹配的作品。', style: TextStyle(fontSize: 24)),
                const SizedBox(height: 12),
                const Text('试试“图片”“小说”或“游戏”，也可以清除筛选。'),
                const SizedBox(height: 16),
                OutlinedButton(onPressed: () { _search.clear(); setState(() { _query = ''; _kind = '全部'; }); },
                  child: const Text('清除搜索与筛选')),
              ])),
          for (final entry in entries) _row(entry),
          const SizedBox(height: 36),
          TextButton.icon(onPressed: () => Navigator.of(context).pushNamed('/projects'),
            icon: const Icon(Icons.arrow_forward), label: const Text('浏览全部作品与组件')),
        ]))),
    );
  }

  Widget _row(ProjectEntry entry) => Column(children: [
    const Divider(height: 1),
    ListTile(
      key: ValueKey('project-${entry.id}'),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      leading: Icon(switch (entry.category) {
        '游戏' => Icons.sports_esports_outlined,
        '阅读创作' => Icons.menu_book_outlined,
        '工具组件' => Icons.tune,
        _ => Icons.folder_outlined,
      }, color: FrequencyPalette.accent),
      title: Text(entry.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
      subtitle: Padding(padding: const EdgeInsets.only(top: 8), child: Text(
        '${entry.description}\n${entry.kind} · ${entry.category}',
        style: const TextStyle(fontSize: 14, height: 1.6, color: FrequencyPalette.muted))),
      isThreeLine: true,
      trailing: const Icon(Icons.arrow_forward),
      onTap: () => Navigator.of(context).pushNamed('/projects/${entry.id}'),
    ),
  ]);

  Widget _detail(ProjectEntry entry) => SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 900),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 20),
        TextButton.icon(onPressed: () { if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else { Navigator.of(context).pushReplacementNamed('/projects'); } },
          icon: const Icon(Icons.arrow_back), label: const Text('返回作品目录')),
        const SizedBox(height: 32),
        Text(entry.kind, style: const TextStyle(color: FrequencyPalette.accent)),
        const SizedBox(height: 12),
        Text(entry.title, style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w700)),
        const SizedBox(height: 24),
        Text(entry.description, style: const TextStyle(fontSize: 20, height: 1.6)),
        const SizedBox(height: 32),
        Wrap(spacing: 16, runSpacing: 16, children: [
          if (entry.launchUrl != null && entry.id != 'shadow-xjy-manager.github.io')
            FilledButton.icon(key: ValueKey('launch-${entry.id}'),
              onPressed: () => openProjectLink(context, entry.launchUrl!),
              icon: const Icon(Icons.open_in_new), label: const Text('打开独立应用')),
          OutlinedButton.icon(onPressed: () => openProjectLink(context, entry.sourceUrl),
            icon: const Icon(Icons.code), label: Text(entry.kind == '组件' ? '查看文档与用法' : '查看项目说明')),
        ]),
        const SizedBox(height: 24),
        Text(entry.launchUrl != null
          ? '应用在新窗口打开。各应用分别保存内容与进度；若独立站点不可用，可从项目说明了解运行方式。'
          : entry.kind == '组件'
            ? '这是可复用组件包。示例与集成说明保留在项目中，库本身不是在线应用。'
            : entry.kind == '原生应用'
              ? '这是原生应用，请先查看说明与运行条件。'
              : '这是本地工具、服务或学习项目。请先查看说明与运行条件。',
          style: const TextStyle(color: FrequencyPalette.muted, fontSize: 16, height: 1.6)),
        const SizedBox(height: 36),
      ]))),
  );
}
