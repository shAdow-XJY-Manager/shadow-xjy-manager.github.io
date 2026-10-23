import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'router/router.dart';
import 'router/browser_history.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.initialPath, this.builder});
  final String? initialPath;
  final TransitionBuilder? builder;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final Object? initialState = widget.initialPath == null
      ? initialBrowserState()
      : null;
  late final StudioRouterDelegate navigation = StudioRouterDelegate(
    initialPath:
        widget.initialPath ??
        WidgetsBinding.instance.platformDispatcher.defaultRouteName,
  );
  late final PlatformRouteInformationProvider information =
      PlatformRouteInformationProvider(
        initialRouteInformation: RouteInformation(
          state: initialState,
          uri: Uri.parse(
            widget.initialPath ??
                WidgetsBinding.instance.platformDispatcher.defaultRouteName,
          ),
        ),
      );
  @override
  void dispose() {
    information.dispose();
    navigation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    debugShowCheckedModeBanner: false,
    title: 'shAdow 工作室 · 频率站',
    theme: FrequencyTheme.dark(fontFamily: 'FrequencySans'),
    routeInformationProvider: information,
    routeInformationParser: const StudioRouteParser(),
    routerDelegate: navigation,
    builder: widget.builder,
  );
}
