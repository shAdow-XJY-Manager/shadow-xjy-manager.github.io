import 'dart:ui_web' as web;

Object? initialBrowserState() {
  final raw = web.urlStrategy?.getState();
  // Flutter's multi-entry history wraps application state with a serial count.
  final state = raw is Map && raw.containsKey('serialCount')
      ? raw['state']
      : raw;
  return state is Map && state['studio'] == 1 ? state : null;
}

bool requestBrowserBack() {
  final strategy = web.urlStrategy;
  if (strategy == null) return false;
  strategy.go(-1);
  return true;
}
