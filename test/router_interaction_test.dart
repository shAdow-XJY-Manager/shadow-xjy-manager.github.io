import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_xjy_manager_github_io/homepage/homePage.dart';
import 'package:shadow_xjy_manager_github_io/main.dart';
import 'package:shadow_xjy_manager_github_io/portal/projectCatalog.dart';
import 'package:shadow_xjy_manager_github_io/router/router.dart';

Future<void> mountStudio(
  WidgetTester tester, {
  String path = '/',
  Size size = const Size(1280, 800),
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox.shrink());
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
  await tester.pumpWidget(MyApp(initialPath: path));
  await tester.pumpAndSettle();
}

StudioRouterDelegate studio(WidgetTester tester) =>
    StudioRouterDelegate.of(tester.element(find.byType(HomePage)));

Finder nav(int index) => find.byKey(ValueKey('nav-$index'));

Future<void> selectSection(WidgetTester tester, int index) async {
  await tester.tap(nav(index));
  await tester.pumpAndSettle();
}

Finder catalog(String section) => find.byWidgetPredicate(
  (widget) =>
      widget is ProjectCatalog &&
      widget.project == null &&
      widget.section == section,
);

Finder catalogSearch(String section) =>
    find.descendant(of: catalog(section), matching: find.byType(TextField));

void expectSelected(WidgetTester tester, int index) {
  final widgets = <Widget>[
    tester.widget(nav(index)),
    ...tester.widgetList<Semantics>(
      find.ancestor(of: nav(index), matching: find.byType(Semantics)),
    ),
    ...tester.widgetList<Semantics>(
      find.descendant(of: nav(index), matching: find.byType(Semantics)),
    ),
  ];
  expect(
    widgets.whereType<Semantics>().any(
      (widget) => widget.properties.selected == true,
    ),
    isTrue,
  );
}

void main() {
  test('刷新后后退到首次详情时使用目录兜底，不误退到站外', () async {
    const parser = StudioRouteParser();
    final original = StudioRouterDelegate(
      initialPath: '/projects/websiteTools',
    );
    addTearDown(original.dispose);
    final firstDetail = parser.restoreRouteInformation(
      original.currentConfiguration,
    );
    expect(original.canGoBack, isFalse);
    original.go('/tools');
    final tools = parser.restoreRouteInformation(original.currentConfiguration);

    final refreshed = StudioRouterDelegate(initialPath: '/tools');
    addTearDown(refreshed.dispose);
    await refreshed.setNewRoutePath(await parser.parseRouteInformation(tools));
    expect(refreshed.historyLength, 1);
    expect(refreshed.canGoBack, isTrue);
    await refreshed.setNewRoutePath(
      await parser.parseRouteInformation(firstDetail),
    );
    expect(refreshed.historyLength, 2);
    expect(refreshed.currentConfiguration.path, '/projects/websiteTools');
    expect(refreshed.currentConfiguration.hasParentEntry, isFalse);
    expect(refreshed.canGoBack, isFalse);
    refreshed.backLocal();
    expect(refreshed.currentConfiguration.path, '/projects');
    expect(refreshed.currentConfiguration.section, 3);
    expect(refreshed.canGoBack, isFalse);
    expect(refreshed.historyLength, 2);

    // Browser Forward can still restore the later entry. New app navigation
    // then retains ordinary local Back behavior.
    await refreshed.setNewRoutePath(await parser.parseRouteInformation(tools));
    expect(refreshed.currentConfiguration.path, '/tools');
    expect(refreshed.canGoBack, isTrue);
    refreshed.go('/projects/customSearchPage');
    expect(refreshed.canGoBack, isTrue);
    refreshed.backLocal();
    expect(refreshed.currentConfiguration.path, '/tools');
  });

  test('有父历史的详情刷新后仍可浏览器后退，本地缺父项则回来源栏目', () async {
    const parser = StudioRouteParser();
    final original = StudioRouterDelegate(initialPath: '/tools');
    addTearDown(original.dispose);
    original.go('/projects/websiteTools');
    final information = parser.restoreRouteInformation(
      original.currentConfiguration,
    );
    final refreshed = StudioRouterDelegate(
      initialPath: '/projects/websiteTools',
    );
    addTearDown(refreshed.dispose);
    await refreshed.setNewRoutePath(
      await parser.parseRouteInformation(information),
    );
    expect(refreshed.historyLength, 1);
    expect(refreshed.canGoBack, isTrue);
    expect(refreshed.currentConfiguration.returnPath, '/tools');
    refreshed.backLocal();
    expect(refreshed.currentConfiguration.path, '/tools');
    expect(refreshed.currentConfiguration.section, 2);
  });

  test('历史 state 与 URL 冲突时始终以 URL 为准', () async {
    final delegate = StudioRouterDelegate(initialPath: '/tools');
    addTearDown(delegate.dispose);
    const parser = StudioRouteParser();
    delegate.go('/projects/websiteTools');
    final detail = delegate.currentConfiguration;
    final information = parser.restoreRouteInformation(detail);
    final restored = await parser.parseRouteInformation(information);
    expect(restored.path, detail.path);
    expect(restored.entryId, detail.entryId);
    expect(restored.section, 2);
    expect(restored.returnPath, '/tools');

    final conflicting = await parser.parseRouteInformation(
      RouteInformation(uri: Uri.parse('/read'), state: information.state),
    );
    expect(conflicting.path, '/read');
    expect(conflicting.section, 6);
    expect(conflicting.returnPath, isNull);
    expect(conflicting.entryId, isNull);
    expect(conflicting.hasParentEntry, isFalse);
    await delegate.setNewRoutePath(conflicting);
    expect(delegate.currentConfiguration.path, '/read');

    // Even if an entry token is reused with a matching serialized path, the
    // delegate must not select a different URL's old history record.
    final reusedToken = await parser.parseRouteInformation(
      RouteInformation(
        uri: Uri.parse('/projects/customSearchPage'),
        state: {
          ...detail.state,
          'path': '/projects/customSearchPage',
          'section': 3,
          'return': '/projects',
        },
      ),
    );
    expect(reusedToken.entryId, detail.entryId);
    await delegate.setNewRoutePath(reusedToken);
    expect(delegate.currentConfiguration.path, '/projects/customSearchPage');
    expect(delegate.currentConfiguration.section, 3);
    expect(delegate.currentConfiguration.returnPath, '/projects');
  });

  testWidgets('栏目切换保持同一个外壳，侧栏在中间帧没有位移', (tester) async {
    await mountStudio(tester, path: '/tools');
    final shell = tester.state<HomePageState>(find.byType(HomePage));
    final sidebar = find.byKey(const ValueKey('studio-sidebar'));
    final sidebarRect = tester.getRect(sidebar);
    for (final destination in [
      (6, '/read'),
      (7, '/play'),
      (3, '/projects'),
      (2, '/tools'),
    ]) {
      await tester.tap(nav(destination.$1));
      await tester.pump();
      for (final frame in [
        Duration.zero,
        const Duration(milliseconds: 16),
        const Duration(milliseconds: 90),
        const Duration(milliseconds: 180),
      ]) {
        await tester.pump(frame);
        expect(find.byType(HomePage), findsOneWidget);
        expect(tester.state<HomePageState>(find.byType(HomePage)), same(shell));
        expect(tester.getRect(sidebar), sidebarRect);
      }
      await tester.pumpAndSettle();
      expect(studio(tester).currentConfiguration.path, destination.$2);
      expectSelected(tester, destination.$1);
      final navigator = tester.widget<Navigator>(find.byType(Navigator));
      expect(navigator.pages, hasLength(1));
      expect(navigator.pages.single.key, const ValueKey('studio-shell'));
      expect(navigator.pages.single.name, destination.$2);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('工具查询筛选和滚动位置在切换栏目后保留', (tester) async {
    await mountStudio(tester, path: '/tools', size: const Size(1280, 480));
    final toolsState = tester.state(catalog('工具'));
    await tester.enterText(catalogSearch('工具'), '工具');
    await tester.pumpAndSettle();
    final kind = find.widgetWithText(ChoiceChip, '在线应用');
    await tester.ensureVisible(kind);
    await tester.tap(kind);
    await tester.pumpAndSettle();
    final scrolling = find
        .descendant(of: catalog('工具'), matching: find.byType(Scrollable))
        .first;
    final position = tester.state<ScrollableState>(scrolling).position;
    expect(position.maxScrollExtent, greaterThan(0));
    position.jumpTo(position.maxScrollExtent * .7);
    await tester.pump();
    final offset = position.pixels;
    final query = tester
        .widget<TextField>(catalogSearch('工具'))
        .controller!
        .text;

    await selectSection(tester, 6);
    expect(studio(tester).currentConfiguration.path, '/read');
    await selectSection(tester, 2);
    expect(tester.state(catalog('工具')), same(toolsState));
    expect(
      tester.widget<TextField>(catalogSearch('工具')).controller!.text,
      query,
    );
    expect(
      tester
          .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, '在线应用'))
          .selected,
      isTrue,
    );
    expect(position.pixels, closeTo(offset, .01));
    expect(tester.takeException(), isNull);
  });

  testWidgets('重复选择当前栏目不增加路由历史，全部目录不显示自跳入口', (tester) async {
    await mountStudio(tester, path: '/projects');
    final delegate = studio(tester);
    final historyLength = delegate.historyLength;
    final location = delegate.currentConfiguration;
    for (var i = 0; i < 3; i++) {
      await selectSection(tester, 3);
      expect(delegate.historyLength, historyLength);
      expect(delegate.currentConfiguration.path, location.path);
    }
    expect(find.text('浏览全部作品与组件'), findsNothing);
    expect(
      tester.widget<Navigator>(find.byType(Navigator)).pages,
      hasLength(1),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('从首页进入作品详情保留首页上下文并返回工作室', (tester) async {
    await mountStudio(tester);
    final shell = tester.state<HomePageState>(find.byType(HomePage));
    final tool = find.widgetWithText(InkWell, '图片尺寸调整');
    await tester.ensureVisible(tool);
    await tester.tap(tool);
    await tester.pumpAndSettle();
    final location = studio(tester).currentConfiguration;
    expect(location.path, '/projects/websiteTools');
    expect(location.section, 0);
    expect(location.returnPath, '/');
    expectSelected(tester, 0);
    expect(find.text('返回工作室'), findsOneWidget);
    await tester.tap(find.text('返回工作室'));
    await tester.pumpAndSettle();
    expect(studio(tester).currentConfiguration.path, '/');
    expect(tester.state<HomePageState>(find.byType(HomePage)), same(shell));
    expectSelected(tester, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('作品直接深链接有明确目录返回目的地', (tester) async {
    await mountStudio(tester, path: '/projects/websiteTools');
    expect(studio(tester).currentConfiguration.returnPath, '/projects');
    expectSelected(tester, 3);
    expect(find.text('返回作品目录'), findsOneWidget);
    await tester.tap(find.text('返回作品目录'));
    await tester.pumpAndSettle();
    expect(studio(tester).currentConfiguration.path, '/projects');
    expect(catalog('全部'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('解析并恢复浏览器历史保留栏目状态与详情返回上下文', (tester) async {
    await mountStudio(tester, path: '/tools');
    final delegate = studio(tester);
    final parser = StudioRouteParser();
    final shell = tester.state<HomePageState>(find.byType(HomePage));
    await tester.enterText(catalogSearch('工具'), '图片');
    await tester.pumpAndSettle();
    final toolsInformation = parser.restoreRouteInformation(
      delegate.currentConfiguration,
    )!;
    await tester.ensureVisible(
      find.byKey(const ValueKey('project-websiteTools')),
    );
    await tester.tap(find.byKey(const ValueKey('project-websiteTools')));
    await tester.pumpAndSettle();
    final detailInformation = parser.restoreRouteInformation(
      delegate.currentConfiguration,
    )!;
    expect(delegate.currentConfiguration.returnPath, '/tools');
    await selectSection(tester, 6);
    final readingInformation = parser.restoreRouteInformation(
      delegate.currentConfiguration,
    )!;

    // Replaying RouteInformation models the information delivered by browser
    // Back/Forward; native browser history is also checked by the live review.
    await delegate.setNewRoutePath(
      await parser.parseRouteInformation(toolsInformation),
    );
    await tester.pumpAndSettle();
    expect(delegate.currentConfiguration.path, '/tools');
    expect(
      tester.widget<TextField>(catalogSearch('工具')).controller!.text,
      '图片',
    );
    await delegate.setNewRoutePath(
      await parser.parseRouteInformation(detailInformation),
    );
    await tester.pumpAndSettle();
    expect(delegate.currentConfiguration.path, '/projects/websiteTools');
    expect(delegate.currentConfiguration.returnPath, '/tools');
    expect(delegate.currentConfiguration.section, 2);
    expect(find.text('返回工具'), findsOneWidget);
    expectSelected(tester, 2);
    await delegate.setNewRoutePath(
      await parser.parseRouteInformation(readingInformation),
    );
    await tester.pumpAndSettle();
    expect(delegate.currentConfiguration.path, '/read');
    expectSelected(tester, 6);
    expect(tester.state<HomePageState>(find.byType(HomePage)), same(shell));
    expect(tester.takeException(), isNull);
  });

  testWidgets('移动抽屉点当前栏目和品牌都关闭抽屉', (tester) async {
    await mountStudio(tester, path: '/tools', size: const Size(390, 844));
    final delegate = studio(tester);
    final shell = tester.state<HomePageState>(find.byType(HomePage));
    final historyLength = delegate.historyLength;
    await tester.tap(find.byTooltip('打开导航'));
    await tester.pumpAndSettle();
    expect(
      tester.state<ScaffoldState>(find.byType(Scaffold)).isDrawerOpen,
      isTrue,
    );
    await tester.tap(nav(2));
    await tester.pumpAndSettle();
    expect(
      tester.state<ScaffoldState>(find.byType(Scaffold)).isDrawerOpen,
      isFalse,
    );
    expect(delegate.currentConfiguration.path, '/tools');
    expect(delegate.historyLength, historyLength);

    await tester.tap(find.byTooltip('打开导航'));
    await tester.pumpAndSettle();
    final brand = find.descendant(
      of: find.byType(Drawer),
      matching: find.text('shAdow 工作室'),
    );
    await tester.tap(brand);
    await tester.pumpAndSettle();
    expect(
      tester.state<ScaffoldState>(find.byType(Scaffold)).isDrawerOpen,
      isFalse,
    );
    expect(delegate.currentConfiguration.path, '/');
    expect(tester.state<HomePageState>(find.byType(HomePage)), same(shell));
    expect(tester.takeException(), isNull);
  });
}
