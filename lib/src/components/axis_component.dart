import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:game_engine/game_engine.dart';
import 'package:vector_canvas/vector_canvas.dart';
import 'package:vector_path/vector_path.dart';

class AxisComponent extends Component {
  Rect _rect;

  Stroke _xAxisStroke;
  Stroke _yAxisStroke;

  AxisComponent(this._rect,
      {Stroke xAxisStroke = const Stroke(),
      Stroke yAxisStroke = const Stroke()})
      : _xAxisStroke = xAxisStroke,
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

  @override
  void tick(TickCtx ctx) {
    for (var child in _children) {
      child.tick(ctx);
    }

    if (!_dirty) return;
    ctx.shouldRender();
    _dirty = false;
  }

  @override
  void handlePointerEvent(PointerEvent event) {
    for (var child in _children) {
      child.handlePointerEvent(event);
    }
  }

  bool _dirty = true;

  void set({Rect? rect, Stroke? xAxisStroke, Stroke? yAxisStroke}) {
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
      _dirty = true;
    }
  }

  double _xAxisIntercept = 0;
  double _yAxisIntercept = 0;

  void _compute() {
    final children = <Component>[];
    if (_rect.top < _xAxisIntercept && _rect.bottom > _xAxisIntercept) {
      children.add(LineComponent(
          LineSegment(
              P(_rect.left, _xAxisIntercept), P(_rect.right, _xAxisIntercept)),
          stroke: _xAxisStroke));
      // TODO ticks
    }
    if (_rect.left < 0 && _rect.right > 0) {
      children.add(LineComponent(
          LineSegment(
              P(_yAxisIntercept, _rect.top), P(_yAxisIntercept, _rect.bottom)),
          stroke: _yAxisStroke));
      // TODO ticks
    }
    _children = children;
  }
}
