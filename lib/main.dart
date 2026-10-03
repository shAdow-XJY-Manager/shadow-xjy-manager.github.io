import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'router/router.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'shAdow 工作室 · 频率站',
      theme: FrequencyTheme.dark(fontFamily: 'FrequencySans'),
      onGenerateInitialRoutes: initialRoutes,
      onGenerateRoute: onGenerateRoute,
    );
  }
}
