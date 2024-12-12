import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:game_engine/game_engine.dart';
import 'package:vector_canvas/src/components/components.dart';
import 'package:vector_path/vector_path.dart';

class AxisComponent extends Component {
  Rect _rect;

  AxisComponent(this._rect) {
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

  void set({Rect? rect}) {
    bool needsUpdate = false;

    if (rect != null) {
      if (rect != _rect) {
        _rect = rect;
        _compute();
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
          LineSegment(P(_rect.left, _xAxisIntercept), P(_rect.right, _xAxisIntercept))));
      // TODO ticks
    }
    if (_rect.left < 0 && _rect.right > 0) {
      children.add(LineComponent(
          LineSegment(P(_yAxisIntercept, _rect.top), P(_yAxisIntercept, _rect.bottom))));
      // TODO
    }
    _children = children;
  }
}
