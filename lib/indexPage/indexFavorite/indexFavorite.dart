import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';

class IndexFavorite extends StatelessWidget {
  const IndexFavorite({super.key});
  static const _items = [('Wlop', 'assets/image/favorite/wlop.jpg'), ('迅哥儿', 'assets/image/favorite/run.jpg')];
  @override
  Widget build(BuildContext context) => SingleChildScrollView(padding: const EdgeInsets.all(24),
    child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1000),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 24),
        const Text('留住喜欢的画面。', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        const Text('工作室的个人收藏。点击图片可以放大查看。', style: TextStyle(color: FrequencyPalette.muted, height: 1.6)),
        const SizedBox(height: 32),
        for (final item in _items) Padding(padding: const EdgeInsets.only(bottom: 32),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Material(color: FrequencyPalette.surface, borderRadius: BorderRadius.circular(12), clipBehavior: Clip.antiAlias,
              child: InkWell(onTap: () => showDialog<void>(context: context, builder: (context) => Dialog(
                child: Stack(children: [
                  Padding(padding: const EdgeInsets.all(24), child: InteractiveViewer(child: Image.asset(item.$2, fit: BoxFit.contain, semanticLabel: item.$1))),
                  Positioned(right: 4, top: 4, child: IconButton(tooltip: '关闭图片', onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close))),
                ]))),
                child: Image.asset(item.$2, width: double.infinity, height: 420, fit: BoxFit.cover,
                  semanticLabel: '${item.$1}，点击放大', errorBuilder: (_, __, ___) => const SizedBox(height: 200, child: Center(child: Text('图片暂时无法载入')))))),
            const SizedBox(height: 12), Text(item.$1, style: const TextStyle(fontSize: 20)),
          ])),
      ]))));
}
