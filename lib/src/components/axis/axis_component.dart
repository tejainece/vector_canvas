import 'dart:ui';

import 'package:vector_canvas/vector_canvas.dart';
import 'package:vector_path/vector_path.dart';

class AxisComponent extends Component implements NeedsDetach {
  R _rect;

  Stroke _xAxisStroke;
  Stroke _yAxisStroke;

  AxisComponent(
    this._rect, {
    Stroke xAxisStroke = const Stroke(),
    Stroke yAxisStroke = const Stroke(),
  })  : _xAxisStroke = xAxisStroke,
        _yAxisStroke = yAxisStroke {
    _compute();
  }

  List<Component> _children = [];

  @override
  void render(Canvas canvas) {
    for (var child in _children) {
      child.render(canvas);
    }
  }

  void set({R? rect, Stroke? xAxisStroke, Stroke? yAxisStroke}) {
    bool needsUpdate = false;
    if (rect != null) {
      if (rect != _rect) {
        _rect = rect;
        _compute();
        needsUpdate = true;
      }
    }
    if (xAxisStroke != null) {
      if (xAxisStroke != _xAxisStroke) {
        _xAxisStroke = xAxisStroke;
        needsUpdate = true;
      }
    }
    if (yAxisStroke != null) {
      if (yAxisStroke != _yAxisStroke) {
        _yAxisStroke = yAxisStroke;
        needsUpdate = true;
      }
    }
    if (needsUpdate) {
      _ctx?.requestRender(this);
    }
  }

  double _xAxisIntercept = 0;
  double _yAxisIntercept = 0;

  void _compute() {
    for (final component in _children) {
      _ctx?.unregisterComponent(component);
    }
    final children = <Component>[];
    if (_rect.top < _xAxisIntercept && _rect.bottom > _xAxisIntercept) {
      children.add(LineComponent(
          LineSegment(
              P(_rect.left, _xAxisIntercept), P(_rect.right, _xAxisIntercept)),
          stroke: _xAxisStroke));
    }
    if (_rect.left < 0 && _rect.right > 0) {
      print('v => $_rect ${_rect.top} ${_rect.bottom}');
      children.add(LineComponent(
          LineSegment(
              P(_yAxisIntercept, -_rect.top), P(_yAxisIntercept, -_rect.bottom)),
          stroke: _yAxisStroke));
    }
    _children = children;
    for (final component in _children) {
      _ctx?.registerComponent(component);
    }
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
