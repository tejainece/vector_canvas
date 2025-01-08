import 'dart:ui';

import 'package:vector_canvas/vector_canvas.dart';
import 'package:vector_path/vector_path.dart';

class HAxisGridComponent extends Component implements NeedsDetach {
  R _rect;

  double _gap;
  Stroke _stroke;

  HAxisGridComponent(this._rect,
      {double gap = 10, Stroke stroke = const Stroke()})
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

  void set({R? rect, double? gap, Stroke? stroke}) {
    bool needsCompute = false;
    if (rect != null && rect != _rect) {
      _rect = rect;
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
    double low = _rect.top.lowerNearestMultipleOf(_gap);
    double high = _rect.bottom.higherNearestMultipleOf(_gap);
    for (double y = low; y <= high + 1e-8; y += _gap) {
      final component = LineComponent(
          LineSegment(P(_rect.left, y), P(_rect.right, y)),
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
  R _rect;

  double _gap;
  Stroke _stroke;

  VAxisGridComponent(this._rect,
      {double gap = 10, Stroke stroke = const Stroke()})
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

  void set({R? rect, double? gap, Stroke? stroke}) {
    bool needsCompute = false;
    if (rect != null && rect != _rect) {
      _rect = rect;
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
    double low = _rect.left.lowerNearestMultipleOf(_gap);
    double high = _rect.right.higherNearestMultipleOf(_gap);
    for (double x = low; x < high + 1e-8; x += _gap) {
      final component = LineComponent(
          LineSegment(P(x, _rect.top), P(x, _rect.bottom)),
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
