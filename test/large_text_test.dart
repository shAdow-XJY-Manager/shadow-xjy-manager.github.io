import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_xjy_manager_github_io/main.dart';
import 'package:shadow_xjy_manager_github_io/portal/projectCatalog.dart';

Widget _largeTextApp() => Builder(builder: (context) {
  final app = const MyApp().build(context) as MaterialApp;
  return MaterialApp(
    debugShowCheckedModeBanner: app.debugShowCheckedModeBanner,
    title: app.title,
    theme: app.theme,
    initialRoute: app.initialRoute,
    onGenerateInitialRoutes: app.onGenerateInitialRoutes,
    onGenerateRoute: app.onGenerateRoute,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(2)),
      child: child!,
    ),
  );
});

Finder _button(String label) => find.ancestor(
  of: find.text(label),
  matching: find.byWidgetPredicate((widget) => widget is ButtonStyleButton),
);

void main() {
  testWidgets('320px at real 200% text keeps portal routes and native details usable', (tester) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    final errors = <String>[];
    final bindingErrorHandler = FlutterError.onError;
    FlutterError.onError = (details) {
      errors.add(details.toString());
      bindingErrorHandler?.call(details);
    };
    final semantics = tester.ensureSemantics();

    void collectException() {
      final exception = tester.takeException();
      if (exception != null) errors.add(exception.toString());
    }

    Future<void> settle() async {
      await tester.pumpAndSettle();
      collectException();
    }

    void completeText(Finder text) {
      expect(text, findsOneWidget);
      expect(MediaQuery.textScalerOf(tester.element(text)).scale(14), 28);
      final paragraph = tester.renderObject<RenderParagraph>(text);
      expect(paragraph.textScaler.scale(14), 28);
      final requiredHeight = paragraph.getMaxIntrinsicHeight(paragraph.size.width);
      if (paragraph.didExceedMaxLines || paragraph.size.height + 1 < requiredHeight) {
        errors.add('${paragraph.text.toPlainText()} on ${ModalRoute.of(tester.element(text))?.settings.name}: '
          'requires $requiredHeight px, has ${paragraph.size.height} px; '
          'didExceedMaxLines=${paragraph.didExceedMaxLines}');
      }
    }

    Future<void> visible(Finder control) async {
      expect(control, findsOneWidget);
      await tester.ensureVisible(control);
      await settle();
      expect(control.hitTestable(), findsOneWidget);
      final rect = tester.getRect(control);
      expect(rect.left, greaterThanOrEqualTo(-1));
      expect(rect.right, lessThanOrEqualTo(321));
      expect(rect.top, greaterThanOrEqualTo(-1));
      expect(rect.bottom, lessThanOrEqualTo(801));
      expect(MediaQuery.sizeOf(tester.element(control)), const Size(320, 800));
      expect(MediaQuery.textScalerOf(tester.element(control)).scale(14), 28);
      final labels = find.descendant(of: control, matching: find.byType(Text));
      for (var i = 0; i < labels.evaluate().length; i++) {
        completeText(labels.at(i));
      }
    }

    Future<void> tap(Finder control) async {
      await visible(control);
      await tester.tap(control.hitTestable());
      await settle();
    }

    void route(String name) {
      final catalog = find.byType(ProjectCatalog);
      expect(catalog, findsOneWidget);
      expect(ModalRoute.of(tester.element(catalog))!.settings.name, name);
    }

    try {
      await tester.pumpWidget(_largeTextApp());
      collectException();
      await settle();
      final enter = find.byKey(const ValueKey('enter-tools'));
      expect(ModalRoute.of(tester.element(enter))!.settings.name, '/');
      await tap(enter);
      route('/tools');

      final search = find.byType(TextField);
      final toolsPrompt = find.text('搜索名称或用途');
      await visible(toolsPrompt);
      completeText(toolsPrompt);
      await visible(search);
      expect(tester.getSemantics(search).getSemanticsData().label,
        contains('搜索名称或用途'));
      await tester.enterText(search, '图片');
      await settle();
      expect(find.text('1 项'), findsOneWidget);
      await tap(find.byKey(const ValueKey('project-websiteTools')));
      route('/projects/websiteTools');
      final launch = find.byKey(const ValueKey('launch-websiteTools'));
      await visible(launch);
      expect(tester.widget<ButtonStyleButton>(launch).onPressed, isNotNull);
      await tap(_button('返回作品目录'));
      route('/tools');
      expect(tester.widget<TextField>(find.byType(TextField)).controller!.text, '图片');
      expect(find.text('1 项'), findsOneWidget);

      await tap(_button('浏览全部作品与组件'));
      route('/projects');
      final allSearch = find.byType(TextField);
      final projectsPrompt = find.text('搜索名称或用途');
      await visible(projectsPrompt);
      completeText(projectsPrompt);
      await visible(allSearch);
      expect(tester.getSemantics(allSearch).getSemanticsData().label,
        contains('搜索名称或用途'));
      await tester.enterText(allSearch, 'tv');
      await settle();
      expect(find.text('1 项'), findsOneWidget);
      await tap(find.byKey(const ValueKey('project-tv')));
      route('/projects/tv');
      expect(find.byKey(const ValueKey('launch-tv')), findsNothing);
      expect(find.text('打开独立应用'), findsNothing);
      final nativeCopy = find.text('这是原生应用，请先查看说明与运行条件。');
      await visible(nativeCopy);
      completeText(nativeCopy);
      final source = _button('查看项目说明');
      await visible(source);
      expect(tester.widget<ButtonStyleButton>(source).onPressed, isNotNull);
      await tap(_button('返回作品目录'));
      route('/projects');
      expect(tester.widget<TextField>(find.byType(TextField)).controller!.text, 'tv');
      expect(find.byKey(const ValueKey('project-tv')), findsOneWidget);
    } finally {
      try {
        await tester.pumpWidget(const SizedBox.shrink());
        collectException();
      } finally {
        semantics.dispose();
        FlutterError.onError = bindingErrorHandler;
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      }
    }
    expect(errors, isEmpty, reason: errors.join('\n\n'));
  });
}
