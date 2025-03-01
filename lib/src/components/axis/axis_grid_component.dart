import 'dart:ui';

import 'package:vector_canvas/vector_canvas.dart';
import 'package:ramanujan/ramanujan.dart';

class HAxisGridComponent extends Component implements NeedsDetach {
  R _viewport;

  double _gap;
  Stroke _stroke;

  HAxisGridComponent(this._viewport,
      {double gap = 100, Stroke stroke = const Stroke()})
      : _gap = gap,
        _stroke = stroke {
    _compute();
  }

  List<LineComponent> _children = [];

  @override
  void render(Canvas canvas) {
    for (var child in _children) {
      child.render(canvas);
    }
  }

  void set({R? viewport, double? gap, Stroke? stroke}) {
    bool needsCompute = false;
    if (viewport != null && !viewport.equals(_viewport)) {
      _viewport = viewport;
      needsCompute = true;
    }
    if (gap != null && _gap != gap) {
      _gap = gap;
      needsCompute = true;
    }
    if (needsCompute) {
      _compute();
    }
    if (stroke != null && _stroke != stroke) {
      _stroke = stroke;
      for (var child in _children) {
        child.set(stroke: stroke);
      }
    }
  }

  void _compute() {
    for (final component in _children) {
      _ctx?.unregisterComponent(component);
    }
    final children = <LineComponent>[];
    double low = _viewport.top.lowerNearestMultipleOf(_gap);
    double high = _viewport.bottom.higherNearestMultipleOf(_gap);
    for (double y = low; y <= high + 1e-8; y += _gap) {
      final component = LineComponent(
          LineSegment(P(_viewport.left, y), P(_viewport.right, y)),
          stroke: _stroke);
      children.add(component);
      _ctx?.registerComponent(component);
    }
    _children = children;
  }

  ComponentContext? _ctx;

  @override
  void onAttach(ComponentContext ctx) {
    _ctx = ctx;
    for (final child in _children) {
      _ctx?.registerComponent(child);
    }
  }

  @override
  void onDetach(ComponentContext ctx) {
    for (final child in _children) {
      _ctx?.unregisterComponent(child);
    }
    _ctx = null;
  }
}

class VAxisGridComponent extends Component implements NeedsDetach {
  R _viewport;

  double _gap;
  Stroke _stroke;

  VAxisGridComponent(this._viewport,
      {double gap = 100, Stroke stroke = const Stroke()})
      : _gap = gap,
        _stroke = stroke {
    _compute();
  }

  List<LineComponent> _children = [];

  @override
  void render(Canvas canvas) {
    for (var child in _children) {
      child.render(canvas);
    }
  }

  void set({R? viewport, double? gap, Stroke? stroke}) {
    bool needsCompute = false;
    if (viewport != null && !viewport.equals(_viewport)) {
      _viewport = viewport;
      needsCompute = true;
    }
    if (gap != null && _gap != gap) {
      _gap = gap;
      needsCompute = true;
    }
    if (needsCompute) {
      _compute();
    }
    if (stroke != null && _stroke != stroke) {
      _stroke = stroke;
      for (var child in _children) {
        child.set(stroke: stroke);
      }
    }
  }

  void _compute() {
    for (final component in _children) {
      _ctx?.unregisterComponent(component);
    }
    final children = <LineComponent>[];
    double low = _viewport.left.lowerNearestMultipleOf(_gap);
    double high = _viewport.right.higherNearestMultipleOf(_gap);
    for (double x = low; x < high + 1e-8; x += _gap) {
      final component = LineComponent(
          LineSegment(P(x, _viewport.top), P(x, _viewport.bottom)),
          stroke: _stroke);
      children.add(component);
      _ctx?.registerComponent(component);
    }
    _children = children;
  }

  ComponentContext? _ctx;

  @override
  void onAttach(ComponentContext ctx) {
    _ctx = ctx;
    for (final child in _children) {
      _ctx?.registerComponent(child);
    }
  }

  @override
  void onDetach(ComponentContext ctx) {
    for (final child in _children) {
      _ctx?.unregisterComponent(child);
    }
    _ctx = null;
  }
}

extension DoubleRoundExt on double {
  double floorLowestToDouble() {
    if (isNegative) {
      return ceilToDouble();
    }
    return floorToDouble();
  }

  double ceilHighestToDouble() {
    if (isNegative) {
      return floorToDouble();
    }
    return ceilToDouble();
  }

  double lowerNearestMultipleOf(double multiple) {
    return (this / multiple).floorToDouble() * multiple;
  }

  double higherNearestMultipleOf(double multiple) {
    return (this / multiple).ceilHighestToDouble() * multiple;
  }
}
