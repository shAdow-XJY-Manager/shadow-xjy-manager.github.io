import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';

// Retained historical page entry; no fabricated reading progress.
class IndexPeople extends StatelessWidget {
  const IndexPeople({super.key});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(24), children: [
    Align(alignment: Alignment.centerLeft, child: ClipRRect(borderRadius: BorderRadius.circular(12),
      child: Image.asset('assets/image/avatar.jpg', width: 96, height: 96, fit: BoxFit.cover, semanticLabel: 'ShadowPlusing 头像'))),
    const SizedBox(height: 24),
    const Text('ShadowPlusing', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700)),
    const SizedBox(height: 16),
    const Text('创作、探索，也玩一会。', style: TextStyle(fontSize: 20, color: FrequencyPalette.muted)),
    const SizedBox(height: 24),
    FilledButton(onPressed: () => Navigator.of(context).pushNamed('/about'), child: const Text('关于工作室')),
  ]);
}
