import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';

class IndexHome extends StatelessWidget {
  const IndexHome({super.key, this.onSelected, this.onOpenProject});
  final ValueChanged<int>? onSelected;
  final ValueChanged<String>? onOpenProject;

  void _open(BuildContext context, int section) {
    if (onSelected != null) {
      onSelected!(section);
    } else {
      Navigator.of(context).pushNamed(switch (section) {
        2 => '/tools',
        6 => '/read',
        7 => '/play',
        _ => '/projects',
      });
    }
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final largeText = MediaQuery.textScalerOf(context).scale(16) > 24;
      final compact = box.maxWidth < 720 || largeText;
      final padding = box.maxWidth < 600 ? 20.0 : 48.0;
      return SingleChildScrollView(
        key: const PageStorageKey('home-scroll'),
        padding: EdgeInsets.fromLTRB(padding, compact ? 28 : 48, padding, 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _hero(context, compact, box.maxWidth < 1100 ? 52 : 64),
                const SizedBox(height: 32),
                const Divider(height: 1),
                const SizedBox(height: 28),
                _heading('随手好用', '处理日常的小需求，把注意力留给更重要的创作。'),
                const SizedBox(height: 20),
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: FrequencyPalette.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      _tool(
                        context,
                        compact,
                        Icons.photo_size_select_large_outlined,
                        '图片尺寸调整',
                        '调整尺寸与格式，文件在你的浏览器处理。',
                        'websiteTools',
                      ),
                      const Divider(height: 1),
                      _tool(
                        context,
                        compact,
                        Icons.code,
                        '编码 / 解码',
                        '转换文本，处理常见的编码与解码。',
                        'websiteTools',
                      ),
                      const Divider(height: 1),
                      _tool(
                        context,
                        compact,
                        Icons.search,
                        '频率搜索',
                        '选择搜索引擎，从一个关键词开始探索。',
                        'customSearchPage',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _heading('换个频率', '读一段故事，或留一点时间认真玩一会。'),
                const SizedBox(height: 20),
                if (compact) ...[
                  _channel(
                    context,
                    6,
                    '文字阅览',
                    '沉下心来，读一些好内容。',
                    Icons.menu_book_outlined,
                    const Alignment(.8, 0),
                  ),
                  const SizedBox(height: 16),
                  _channel(
                    context,
                    7,
                    '频率游戏中心',
                    '短局、解谜与策略，选一款就开始。',
                    Icons.sports_esports_outlined,
                    Alignment.centerRight,
                  ),
                ] else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _channel(
                          context,
                          6,
                          '文字阅览',
                          '沉下心来，读一些好内容。',
                          Icons.menu_book_outlined,
                          const Alignment(.8, 0),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _channel(
                          context,
                          7,
                          '频率游戏中心',
                          '短局、解谜与策略，选一款就开始。',
                          Icons.sports_esports_outlined,
                          Alignment.centerRight,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    },
  );

  Widget _hero(BuildContext context, bool compact, double titleSize) {
    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'FOCUS WORKBENCH',
          style: TextStyle(
            color: FrequencyPalette.muted,
            fontSize: 12,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          '今天，想做点什么？',
          style: TextStyle(
            fontSize: compact ? 34 : titleSize,
            height: 1.2,
            fontWeight: FontWeight.w900,
            color: FrequencyPalette.text,
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          '从一件小事开始，让灵感变成作品。',
          style: TextStyle(
            fontSize: 18,
            height: 1.6,
            color: FrequencyPalette.muted,
          ),
        ),
        const SizedBox(height: 28),
        FilledButton.icon(
          key: const ValueKey('enter-tools'),
          onPressed: () => _open(context, 2),
          style: FilledButton.styleFrom(
            backgroundColor: FrequencyPalette.amber,
            minimumSize: Size(compact ? 48 : 240, 56),
            foregroundColor: FrequencyPalette.background,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          icon: const Icon(Icons.arrow_forward),
          label: const Text(
            '进入工具台',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
    if (compact) return copy;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 280),
      child: Row(
        children: [
          Expanded(flex: 6, child: copy),
          const SizedBox(width: 24),
          Expanded(
            flex: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Transform.scale(
                scale: 1.4,
                alignment: Alignment.topRight,
                child: Image.asset(
                  'assets/image/frequency-hero.webp',
                  height: 280,
                  fit: BoxFit.cover,
                  alignment: Alignment.centerRight,
                  excludeFromSemantics: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _heading(String title, String subtitle) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 8),
      Text(
        subtitle,
        style: const TextStyle(
          fontSize: 16,
          height: 1.6,
          color: FrequencyPalette.muted,
        ),
      ),
    ],
  );

  Widget _tool(
    BuildContext context,
    bool compact,
    IconData icon,
    String title,
    String description,
    String id,
  ) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () {
        if (onOpenProject != null) {
          onOpenProject!(id);
        } else {
          Navigator.of(context).pushNamed('/projects/$id');
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.all(compact ? 16 : 20),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: FrequencyPalette.selected,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: FrequencyPalette.accent, size: 26),
            ),
            SizedBox(width: compact ? 16 : 24),
            Expanded(
              child: compact
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: FrequencyPalette.muted,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 6,
                          child: Text(
                            description,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.6,
                              color: FrequencyPalette.muted,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            if (!compact) ...[
              const SizedBox(width: 24),
              const Icon(Icons.arrow_forward, color: FrequencyPalette.muted),
            ],
          ],
        ),
      ),
    ),
  );

  Widget _channel(
    BuildContext context,
    int section,
    String title,
    String subtitle,
    IconData icon,
    Alignment alignment,
  ) => Material(
    color: FrequencyPalette.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: const BorderSide(color: FrequencyPalette.border),
    ),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: () => _open(context, section),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (MediaQuery.textScalerOf(context).scale(16) <= 24 &&
                MediaQuery.sizeOf(context).width >= 500) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  'assets/image/frequency-hero.webp',
                  width: 96,
                  height: 110,
                  fit: BoxFit.cover,
                  alignment: alignment,
                  excludeFromSemantics: true,
                ),
              ),
              const SizedBox(width: 20),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: FrequencyPalette.accent),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: FrequencyPalette.muted,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.arrow_forward, color: FrequencyPalette.muted),
          ],
        ),
      ),
    ),
  );
}
