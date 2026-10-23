import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../homepage/homePage.dart';
import '../innerAssets/videoAsset/videoData.dart';
import '../innerAssets/projectAsset/projectData.dart';

const studioSectionPaths = [
  '/',
  '/videos',
  '/tools',
  '/projects',
  '/about',
  '/favorites',
  '/read',
  '/play',
  '/listen',
];
const studioSectionLabels = [
  '工作室',
  '放映室',
  '工具',
  '作品目录',
  '关于工作室',
  '收藏',
  '阅读',
  '游戏',
  '背景音乐',
];
const _sections = <String, int>{
  '/': 0,
  '/homePage': 0,
  '/videos': 1,
  '/tools': 2,
  '/projects': 3,
  '/about': 4,
  '/favorites': 5,
  '/read': 6,
  '/play': 7,
  '/listen': 8,
  '/websites': 2,
  '/collections': 3,
  '/people': 4,
  '/favorite': 5,
};

/// The URL owns the destination; origin describes how to return from a detail.
/// Its serializable state also survives browser Back/Forward and a refresh.
class StudioLocation {
  const StudioLocation({
    required this.path,
    required this.section,
    this.returnPath,
    this.entryId,
    this.hasParentEntry = false,
  });
  final String path;
  final int section;
  final String? returnPath;
  final String? entryId;
  final bool hasParentEntry;

  factory StudioLocation.parse(String raw, {Object? state}) {
    final uri = Uri.tryParse(raw) ?? Uri(path: '/');
    final path = uri.path.isEmpty ? '/' : uri.path;
    final canonical = _sections.containsKey(path)
        ? studioSectionPaths[_sections[path]!]
        : path;
    if (state is Map && state['path'] is String && state['path'] != canonical)
      state = null;
    final section = _sections[path];
    if (section != null) {
      return StudioLocation(
        path: studioSectionPaths[section],
        section: section,
        entryId: _stateString(state, 'entry'),
        hasParentEntry: _stateValue(state, 'parent') == true,
      );
    }
    final parts = uri.pathSegments;
    final video = parts.length == 2 && parts.first == 'videos'
        ? videoById(parts.last)
        : null;
    final project = parts.length == 2 && parts.first == 'projects'
        ? projectById(parts.last)
        : null;
    final fallback = video != null
        ? 1
        : project != null
        ? 3
        : 0;
    final origin = _stateValue(state, 'section');
    final originSection =
        origin is int && origin >= 0 && origin < studioSectionPaths.length
        ? origin
        : fallback;
    final parent = _stateString(state, 'return');
    return StudioLocation(
      path: path,
      section: originSection,
      returnPath: _sections.containsKey(parent)
          ? parent
          : studioSectionPaths[fallback],
      entryId: _stateString(state, 'entry'),
      hasParentEntry: _stateValue(state, 'parent') == true,
    );
  }

  static Object? _stateValue(Object? state, String key) =>
      state is Map && state['studio'] == 1 ? state[key] : null;
  static String? _stateString(Object? state, String key) {
    final value = _stateValue(state, key);
    return value is String ? value : null;
  }

  ProjectEntry? get project {
    final parts = Uri.parse(path).pathSegments;
    return parts.length == 2 && parts.first == 'projects'
        ? projectById(parts.last)
        : null;
  }

  VideoEntry? get video {
    final parts = Uri.parse(path).pathSegments;
    return parts.length == 2 && parts.first == 'videos'
        ? videoById(parts.last)
        : null;
  }

  bool get isSection => _sections.containsKey(path);
  bool get isDetail => project != null || video != null;
  bool get isUnknown => !isSection && !isDetail;
  String get returnLabel =>
      '返回${studioSectionLabels[_sections[returnPath] ?? 3]}';

  Map<String, Object?> get state => {
    'studio': 1,
    'path': path,
    'entry': entryId,
    'section': section,
    'return': returnPath,
    'parent': hasParentEntry,
  };
}

class StudioRouteParser extends RouteInformationParser<StudioLocation> {
  const StudioRouteParser();
  @override
  Future<StudioLocation> parseRouteInformation(RouteInformation information) =>
      SynchronousFuture(
        StudioLocation.parse(
          information.uri.toString(),
          state: information.state,
        ),
      );
  @override
  RouteInformation restoreRouteInformation(StudioLocation configuration) =>
      RouteInformation(
        uri: Uri.parse(configuration.path),
        state: configuration.state,
      );
}

class StudioRouterDelegate extends RouterDelegate<StudioLocation>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<StudioLocation> {
  StudioRouterDelegate({String initialPath = '/'}) {
    _history.add(_identify(StudioLocation.parse(initialPath)));
  }
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final List<StudioLocation> _history = [];
  final Map<String, Completer<void>> _detailExits = {};
  int _position = 0;
  int _serial = 0;
  final String _session = DateTime.now().microsecondsSinceEpoch.toString();
  int get historyLength => _history.length;
  // Restored entries are discovered in arrival order after a refresh. Their
  // index in this local cache does not prove a preceding browser app entry.
  bool get canGoBack => currentConfiguration.hasParentEntry;
  @override
  StudioLocation get currentConfiguration => _history[_position];

  static StudioRouterDelegate of(BuildContext context) =>
      Router.of(context).routerDelegate as StudioRouterDelegate;

  /// Returns the detail entry token, or null for a no-op/section navigation.
  String? go(String path) {
    final target = StudioLocation.parse(path);
    if (target.path == currentConfiguration.path) return null;
    final previous = currentConfiguration;
    final entry = '$_session-${++_serial}';
    final origin = previous.section;
    final next = StudioLocation(
      path: target.path,
      section: target.isDetail ? origin : target.section,
      returnPath: target.isDetail ? studioSectionPaths[origin] : null,
      entryId: entry,
      hasParentEntry: true,
    );
    _history.removeRange(_position + 1, _history.length);
    _history.add(next);
    _position++;
    if (next.isDetail) _detailExits[entry] = Completer<void>();
    _changed();
    return next.isDetail ? entry : null;
  }

  Future<void> untilExit(String? entry) => entry == null
      ? SynchronousFuture(null)
      : _detailExits[entry]?.future ?? SynchronousFuture(null);

  void backLocal() {
    if (canGoBack && _position > 0) {
      _position--;
    } else {
      final current = currentConfiguration;
      _history[_position] = _identify(
        StudioLocation.parse(current.returnPath ?? '/'),
        current.entryId,
      );
    }
    _changed();
  }

  void _changed() {
    for (final entry in _detailExits.keys.toList()) {
      if (entry != currentConfiguration.entryId)
        _detailExits.remove(entry)?.complete();
    }
    notifyListeners();
  }

  StudioLocation _identify(StudioLocation location, [String? knownEntry]) =>
      StudioLocation(
        path: location.path,
        section: location.section,
        returnPath: location.returnPath,
        hasParentEntry: location.hasParentEntry,
        entryId: location.entryId ?? knownEntry ?? '$_session-${++_serial}',
      );

  @override
  Future<void> setNewRoutePath(StudioLocation configuration) async {
    configuration = _identify(
      configuration,
      configuration.path == currentConfiguration.path
          ? currentConfiguration.entryId
          : null,
    );
    final found = configuration.entryId == null
        ? -1
        : _history.indexWhere(
            (location) =>
                location.entryId == configuration.entryId &&
                location.path == configuration.path,
          );
    if (found >= 0) {
      _position = found;
    } else if (currentConfiguration.path == configuration.path) {
      _history[_position] = configuration;
    } else {
      _history.removeRange(_position + 1, _history.length);
      _history.add(configuration);
      _position++;
    }
    _changed();
  }

  @override
  Future<bool> popRoute() async {
    if (navigatorKey.currentState?.canPop() ?? false) {
      return navigatorKey.currentState!.maybePop();
    }
    if (canGoBack || currentConfiguration.isDetail) {
      backLocal();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) => Navigator(
    key: navigatorKey,
    pages: [
      MaterialPage<void>(
        key: const ValueKey('studio-shell'),
        name: currentConfiguration.path,
        child: HomePage(
          key: const ValueKey('studio-home'),
          navigation: this,
          location: currentConfiguration,
        ),
      ),
    ],
    onDidRemovePage: (_) {},
  );

  @override
  void dispose() {
    for (final exit in _detailExits.values) {
      exit.complete();
    }
    _detailExits.clear();
    super.dispose();
  }
}
