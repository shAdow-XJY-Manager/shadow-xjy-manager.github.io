import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_common/flutter_common.dart';

// Compatibility data for callers that use collectionEntries.
class CollectionEntry {
  const CollectionEntry(this.title, this.category, this.description, this.image, this.url, this.action);
  final String title, category, description, image, url, action;
}
const collectionEntries = [
  CollectionEntry('Game Center', '游戏', '选一个游戏，开始一局。', 'assets/image/collections/game.webp',
    'https://shadow-xjy-manager.github.io/XJY.GAME.COMP.gameCenter/', '进入游戏'),
  CollectionEntry('Novel Center', '阅读', '选择一本小说，安静读一会。', 'assets/image/collections/novel.webp',
    'https://shadow-xjy-manager.github.io/XJY.ENT.READ.novelRead/', '进入阅读'),
];

class IndexProgram extends StatelessWidget {
  const IndexProgram({super.key});
  Future<void> _open(BuildContext context, CollectionEntry entry) async {
    try { if (await launchUrl(Uri.parse(entry.url), webOnlyWindowName: '_blank')) return; } catch (_) {}
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('暂时无法打开，请重试。'),
      action: SnackBarAction(label: '重试', onPressed: () => _open(context, entry))));
  }
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(24), children: [
    const Text('阅读与游戏', style: TextStyle(fontSize: 32)),
    const SizedBox(height: 24),
    for (var i = 0; i < collectionEntries.length; i++) Padding(padding: const EdgeInsets.only(bottom: 24),
      child: Material(key: ValueKey('collection-$i'), color: FrequencyPalette.surface,
        child: ListTile(contentPadding: const EdgeInsets.all(20), title: Text(collectionEntries[i].title),
          subtitle: Text(collectionEntries[i].description), trailing: FilledButton(
            key: ValueKey('open-collection-$i'), onPressed: () => _open(context, collectionEntries[i]),
            child: Text(collectionEntries[i].action)))),
    ),
  ]);
}
