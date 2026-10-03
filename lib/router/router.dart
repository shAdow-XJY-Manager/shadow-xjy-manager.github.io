import 'package:flutter/material.dart';
import '../homepage/homePage.dart';
import '../innerAssets/videoAsset/videoData.dart';
import '../innerAssets/projectAsset/projectData.dart';

const _sections = <String, int>{
  '/': 0, '/homePage': 0, '/videos': 1, '/tools': 2, '/projects': 3,
  '/about': 4, '/favorites': 5, '/read': 6, '/play': 7, '/listen': 8,
  '/websites': 2, '/collections': 3, '/people': 4, '/favorite': 5,
};

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  final uri = Uri.tryParse(settings.name ?? '/');
  final parts = uri?.pathSegments ?? const <String>[];
  final video = parts.length == 2 && parts.first == 'videos' ? videoById(parts.last) : null;
  final project = parts.length == 2 && parts.first == 'projects' ? projectById(parts.last) : null;
  final section = _sections[uri?.path ?? '/'];
  return MaterialPageRoute(settings: settings, builder: (_) => HomePage(
    initialSection: video != null ? 1 : project != null ? 3 : section ?? 0,
    video: video, project: project,
    errorRoute: video == null && project == null && section == null ? settings.name : null,
  ));
}

List<Route<dynamic>> initialRoutes(String name) {
  final parts = Uri.tryParse(name)?.pathSegments ?? const <String>[];
  final video = parts.length == 2 && parts.first == 'videos' ? videoById(parts.last) : null;
  if (video != null) {
    final homeKey = GlobalKey<HomePageState>();
    return [
      MaterialPageRoute(settings: const RouteSettings(name: '/videos'),
        builder: (_) => HomePage(key: homeKey, initialSection: 1)),
      MaterialPageRoute(settings: RouteSettings(name: name), builder: (_) => HomePage(
        video: video, onSectionSelected: (section) => homeKey.currentState?.selectSection(section))),
    ];
  }
  if (parts.length == 2 && parts.first == 'projects' && projectById(parts.last) != null) {
    return [onGenerateRoute(const RouteSettings(name: '/projects')),
      onGenerateRoute(RouteSettings(name: name))];
  }
  return [onGenerateRoute(RouteSettings(name: name))];
}
