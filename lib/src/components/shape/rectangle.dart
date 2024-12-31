import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';
import 'package:vector_canvas/vector_canvas.dart';
import 'package:vector_path/vector_path.dart';

class RectangleComponent extends Component {
  R _rect;
  late Path _path;
  Stroke? _stroke;
  Fill? _fill;
  Paint? _fillPaint;
  Paint? _strokePaint;

  RectangleComponent(this._rect, {Stroke? stroke, Fill? fill = const Fill()}) {
    _stroke = stroke;
    _fill = fill;
    _strokePaint = _stroke?.paint;
    _fillPaint = _fill?.paint;
    _path = _makePath();
  }

  @override
  void render(Canvas canvas) {
    if (_fillPaint != null) canvas.drawPath(_path, _fillPaint!);
    if (_strokePaint != null) canvas.drawPath(_path, _strokePaint!);
  }

  Path _makePath() {
    return Path()
      ..addRect(
          Rect.fromLTWH(_rect.left, _rect.top, _rect.width, _rect.height));
  }

  @override
  void tick(TickCtx ctx) {
    if (!_dirty) return;
    ctx.shouldRender();
    _dirty = false;
  }

  bool _dirty = true;

  void set({R? rectangle, Optional<Stroke>? stroke, Optional<Fill>? fill}) {
    bool needsUpdate = false;
    if (rectangle != null) {
      if (rectangle != _rect) {
        _rect = rectangle;
        _path = _makePath();
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
