import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';
import 'package:vector_canvas/vector_canvas.dart';
import 'package:vector_path/vector_path.dart';

class EllipseComponent extends Component {
  Ellipse _ellipse;
  late Path _arc1;
  late Path _arc2;
  Stroke? _stroke;
  Fill? _fill;
  Paint? _fillPaint;
  Paint? _strokePaint;

  EllipseComponent(this._ellipse, {Stroke? stroke, Fill? fill = const Fill()}) {
    _stroke = stroke;
    _fill = fill;
    _strokePaint = _stroke?.paint;
    _fillPaint = _fill?.paint;
    _arc1 = _makeArc(0, 0.5);
    _arc2 = _makeArc(0.5, 1);
  }

  @override
  void render(Canvas canvas) {
    _drawArc(canvas, _arc1);
    _drawArc(canvas, _arc2);
  }

  Path _makeArc(double start, double end) {
    final arcLength = _ellipse.arcLengthBetweenT(start, end, clockwise: false);
    final perimeter = _ellipse.perimeter;
    return Path()
      ..moveToOffset(_ellipse.lerp(start).o)
      ..arcToPoint(_ellipse.lerp(end).o,
          rotation: _ellipse.rotation.toDegree,
          radius: _ellipse.radii.r,
          clockwise: false,
          largeArc: arcLength > perimeter / 2);
  }

  void _drawArc(Canvas canvas, Path path) {
    if (_fillPaint != null) canvas.drawPath(path, _fillPaint!);
    if (_strokePaint != null) canvas.drawPath(path, _strokePaint!);
  }

  @override
  void tick(TickCtx ctx) {
    if (!_dirty) return;
    ctx.shouldRender();
    _dirty = false;
  }

  bool _dirty = true;

  void set({Ellipse? ellipse, Optional<Stroke>? stroke, Optional<Fill>? fill}) {
    bool needsUpdate = false;
    if (ellipse != null) {
      if (ellipse != _ellipse) {
        _ellipse = ellipse;
        needsUpdate = true;
      }
    }
    if (stroke != null) {
      if (stroke.value != _stroke) {
        _stroke = stroke.value;
        _strokePaint = _stroke?.paint;
        needsUpdate = true;
      }
    }
    if (fill != null) {
      if (fill.value != _fill) {
        _fill = fill.value;
        _fillPaint = _fill?.paint;
        needsUpdate = true;
      }
    }
    _dirty = _dirty || needsUpdate;
  }

  @override
  void handlePointerEvent(PointerEvent event) {
    // TODO: implement handlePointerEvent
  }
}
