import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';

class IndexHome extends StatelessWidget {
  const IndexHome({super.key, this.onSelected});
  final ValueChanged<int>? onSelected;
  void _open(BuildContext context, int section) {
    if (onSelected != null) { onSelected!(section); } else {
      Navigator.of(context).pushNamed(switch(section) { 2 => '/tools', 6 => '/read', 7 => '/play', _ => '/projects' });
    }
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, box) {
    final mobile = box.maxWidth < 700;
    final largeText = MediaQuery.textScalerOf(context).scale(16) > 24;
    final compactHero = box.maxWidth < 1100 || largeText;
    final pad = mobile ? 24.0 : 64.0;
    final titleSize = mobile || largeText ? 42.0 : (box.maxWidth < 1100 ? 60.0 : 76.0);
    final copy = Padding(padding: EdgeInsets.fromLTRB(pad, mobile ? 28 : 56, pad, 48),
      child: ConstrainedBox(constraints: BoxConstraints(maxWidth: compactHero ? double.infinity : box.maxWidth * .55),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('FOR A BRIGHTER ORDINARY', style: TextStyle(fontSize: 12, letterSpacing: 3, color: FrequencyPalette.muted)),
          const SizedBox(height: 24),
          Text('创作，\n探索，玩一会。', style: TextStyle(
            color: FrequencyPalette.accent, fontFamily: 'FrequencySans',
            fontSize: titleSize, fontWeight: FontWeight.w900, height: 1.12)),
          const SizedBox(height: 24),
          const Text('一座属于创作者的在线工作台，\n把灵感变成可用的东西。',
            style: TextStyle(fontSize: 20, height: 1.6, color: FrequencyPalette.muted)),
          const SizedBox(height: 36),
          _action(context),
        ])));
    return SingleChildScrollView(key: const PageStorageKey('home-scroll'), child: Column(children: [
      if (compactHero) ...[
        SizedBox(height: mobile ? 240 : 320, width: double.infinity, child: _heroImage(Alignment.centerRight)),
        Align(alignment: Alignment.centerLeft, child: copy),
      ] else
        Container(width: double.infinity, constraints: const BoxConstraints(minHeight: 610), child: Stack(alignment: Alignment.topLeft, children: [
          Positioned.fill(child: _heroImage(Alignment.topCenter)),
          copy,
        ])),
      Padding(padding: EdgeInsets.symmetric(horizontal: mobile ? 24 : (box.maxWidth < 1100 ? 48 : 160), vertical: 12),
        child: box.maxWidth < 1100 || largeText
          ? Material(color: FrequencyPalette.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: FrequencyPalette.border)),
              child: Padding(padding: const EdgeInsets.all(12), child: Wrap(
                alignment: WrapAlignment.center, spacing: 8, runSpacing: 12, children: [
                  _channel(context, '工具', Icons.tune, 2, active: true),
                  _channel(context, '阅读', Icons.menu_book_outlined, 6),
                  _channel(context, '游戏', Icons.sports_esports_outlined, 7),
                ])))
          : LayoutBuilder(builder: (context, panel) => SizedBox(height: panel.maxWidth / 7,
              child: Stack(fit: StackFit.expand, children: [
                Image.asset('assets/image/frequency-panel.webp', fit: BoxFit.fill, excludeFromSemantics: true,
                  errorBuilder: (_, __, ___) => const ColoredBox(color: FrequencyPalette.surface)),
                Positioned(left: panel.maxWidth * .065, top: panel.maxWidth / 7 * .25,
                  child: Text('FREQUENCY\nTERMINAL', style: TextStyle(color: FrequencyPalette.muted,
                    fontSize: (panel.maxWidth / 1167 * 12).clamp(10, 12).toDouble(), height: 1.8, letterSpacing: 1.5))),
                for (final task in [('工具', 2, .387), ('阅读', 6, .537), ('游戏', 7, .693)])
                  Positioned(left: panel.maxWidth * task.$3 - 56, bottom: 12, width: 112,
                    child: Semantics(selected: task.$2 == 2, child: TextButton(
                      onPressed: () => _open(context, task.$2),
                      style: TextButton.styleFrom(minimumSize: const Size(80, 48),
                        foregroundColor: task.$2 == 2 ? FrequencyPalette.accent : FrequencyPalette.muted),
                      child: Text(task.$1, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600))))),
              ])))),
      Padding(padding: EdgeInsets.fromLTRB(pad, 44, pad, 40), child: SizedBox(width: double.infinity, child: Wrap(
        alignment: WrapAlignment.spaceBetween, crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 48, runSpacing: 24, children: [
          const Text('SMALL TOOLS\nA RICHER LIFE', style: TextStyle(fontSize: 12, height: 1.8, letterSpacing: 2, color: FrequencyPalette.muted)),
          Wrap(spacing: 24, runSpacing: 16, children: [
            TextButton.icon(onPressed: () => _open(context, 6), icon: const Icon(Icons.arrow_forward), label: const Text('继续阅读')),
            TextButton.icon(onPressed: () => _open(context, 7), icon: const Icon(Icons.arrow_forward), label: const Text('玩一局')),
          ]),
        ]))),
    ]));
  });

  Widget _heroImage(Alignment alignment) => Image.asset('assets/image/frequency-hero.webp',
    fit: BoxFit.cover, alignment: alignment, excludeFromSemantics: true,
    errorBuilder: (_, __, ___) => const ColoredBox(color: FrequencyPalette.background));

  Widget _action(BuildContext context) => SizedBox(width: 370,
    height: MediaQuery.textScalerOf(context).scale(16) > 24 ? 172 : 116,
    child: Stack(fit: StackFit.expand, children: [
      Image.asset('assets/image/frequency-action.webp', fit: BoxFit.fill, excludeFromSemantics: true,
        errorBuilder: (_, __, ___) => const ColoredBox(color: FrequencyPalette.amber)),
      Padding(padding: const EdgeInsets.all(12), child: FilledButton.icon(
        key: const ValueKey('enter-tools'),
        style: FilledButton.styleFrom(backgroundColor: Colors.transparent,
          foregroundColor: FrequencyPalette.background, textStyle: TextStyle(fontSize: MediaQuery.textScalerOf(context).scale(16) > 24 ? (MediaQuery.sizeOf(context).width < 700 ? 18 : 24) : (MediaQuery.sizeOf(context).width < 700 ? 26 : 32), height: 1.1, fontWeight: FontWeight.w900),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        onPressed: () => _open(context, 2), icon: const Icon(Icons.arrow_forward, size: 30), label: const Text('进入工具台'))),
    ]));

  Widget _channel(BuildContext context, String label, IconData icon, int section, {bool active = false}) =>
    SizedBox(width: 112, child: TextButton(onPressed: () => _open(context, section),
      style: TextButton.styleFrom(foregroundColor: active ? FrequencyPalette.accent : FrequencyPalette.muted,
        minimumSize: const Size(80, 72)), child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 28), const SizedBox(height: 8), Text(label, style: const TextStyle(fontSize: 18)),
        ])));
}
