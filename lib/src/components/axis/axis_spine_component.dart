import 'dart:ui';

import 'package:vector_canvas/vector_canvas.dart';
import 'package:ramanujan/ramanujan.dart';

class HAxisSpineComponent extends Component implements NeedsDetach {
  R _viewport;

  double _atY;

  Stroke _stroke;

  HAxisSpineComponent(
    this._viewport, {
    Stroke stroke = const Stroke(),
    double atY = 0,
  })  : _atY = atY,
        _stroke = stroke {
    _compute();
  }

  final _line = LineComponent(LineSegment.origin(P.origin));

  @override
  void render(Canvas canvas) {
    _line.render(canvas);
  }

  void set({R? viewport, Stroke? xAxisStroke, Stroke? stroke, double? atY}) {
    bool needsUpdate = false;
    if (viewport != null && !viewport.equals(_viewport)) {
      _viewport = viewport;
      needsUpdate = true;
    }
    if (stroke != null && _stroke != stroke) {
      _stroke = stroke;
      needsUpdate = true;
    }
    if (atY != null && _atY != atY) {
      _atY = atY;
      needsUpdate = true;
    }
    if (needsUpdate) {
      _compute();
    }
  }

  void _compute() {
    if (_viewport.top < _atY && _viewport.bottom > _atY) {
      _line.set(
          line: LineSegment(P(_viewport.left, _atY), P(_viewport.right, _atY)),
          stroke: _stroke);
    } else {
      _line.set(line: LineSegment(P.origin, P.origin), stroke: _stroke);
    }
  }

  @override
  void onAttach(ComponentContext ctx) {
    ctx.registerComponent(_line);
  }

  @override
  void onDetach(ComponentContext ctx) {
    ctx.unregisterComponent(_line);
  }
}

class VAxisSpineComponent extends Component implements NeedsDetach {
  R _viewport;

  Stroke _stroke;

  double _atX;

  VAxisSpineComponent(
    this._viewport, {
    Stroke stroke = const Stroke(),
    double atX = 0,
  })  : _atX = atX,
        _stroke = stroke {
    _compute();
  }

  final _line = LineComponent(LineSegment.origin(P.origin));

  @override
  void render(Canvas canvas) {
    _line.render(canvas);
  }

  void set({R? viewport, Stroke? stroke, double? atX}) {
    bool needsUpdate = false;
    if (viewport != null && !viewport.equals(_viewport)) {
      _viewport = viewport;
      needsUpdate = true;
    }
    if (stroke != null && _stroke != stroke) {
      _stroke = stroke;
      needsUpdate = true;
    }
    if (atX != null && _atX != atX) {
      _atX = atX;
      needsUpdate = true;
    }
    if (needsUpdate) {
      _compute();
    }
  }

  void _compute() {
    if (_viewport.left < 0 && _viewport.right > 0) {
      _line.set(
          line: LineSegment(P(_atX, _viewport.top), P(_atX, _viewport.bottom)),
          stroke: _stroke);
    } else {
      _line.set(line: LineSegment(P.origin, P.origin), stroke: _stroke);
    }
  }

  ComponentContext? _ctx;

  @override
  void onAttach(ComponentContext ctx) {
    ctx.registerComponent(_line);
  }

  @override
  void onDetach(ComponentContext ctx) {
    _ctx?.unregisterComponent(_line);
  }
}
