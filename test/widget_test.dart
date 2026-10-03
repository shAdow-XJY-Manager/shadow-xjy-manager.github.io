import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_xjy_manager_github_io/main.dart';
import 'package:shadow_xjy_manager_github_io/portal/projectCatalog.dart';
import 'package:shadow_xjy_manager_github_io/innerAssets/projectAsset/projectData.dart';

void main() {
  test('directory identifies all repositories uniquely and separates libraries from apps', () {
    expect(projectEntries, hasLength(47));
    expect(projectEntries.map((p) => p.id).toSet(), hasLength(47));
    expect(projectById('websiteTools')!.matches('图片'), isTrue);
    expect(projectById('blurGlass')!.launchUrl, isNull);
    expect(projectById('missing-project'), isNull);
  });
  for (final width in [320.0, 390.0, 768.0, 1280.0]) {
    testWidgets('home to tools to project details works at width $width', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = Size(width, 900);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      expect(find.text('创作，\n探索，玩一会。'), findsOneWidget);
      final enter = find.byKey(const ValueKey('enter-tools'));
      await tester.ensureVisible(enter);
      await tester.tap(enter);
      await tester.pumpAndSettle();
      expect(find.text('把小任务，做得顺手。'), findsOneWidget);
      final search = find.byType(TextField);
      await tester.enterText(search, '图片');
      await tester.pumpAndSettle();
      expect(find.text('1 项'), findsOneWidget);
      final project = find.byKey(const ValueKey('project-websiteTools'));
      await tester.ensureVisible(project);
      await tester.tap(project);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('launch-websiteTools')), findsOneWidget);
      await tester.tap(find.text('返回作品目录'));
      await tester.pumpAndSettle();
      expect(find.text('1 项'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('empty search can clear back to all 47 entries', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: ProjectCatalog())));
    await tester.pumpAndSettle();
    expect(find.text('47 项'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'no-frequency-project-987654');
    await tester.pumpAndSettle();
    expect(find.text('还没有匹配的作品。'), findsOneWidget);
    await tester.ensureVisible(find.text('清除搜索与筛选'));
    await tester.tap(find.text('清除搜索与筛选'));
    await tester.pumpAndSettle();
    expect(find.text('47 项'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
