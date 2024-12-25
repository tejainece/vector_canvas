import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';
import 'package:vector_canvas/vector_canvas.dart';
import 'package:vector_path/vector_path.dart';

class PathComponent implements Component {
  late List<Segment> _segments;
  late Path _path;
  Fill? _fill;
  Stroke? _stroke;
  Paint? _fillPaint;
  Paint? _strokePaint;

  PathComponent(List<Segment> segments,
      {Fill? fill, Stroke? stroke = const Stroke()}) {
    _fill = fill;
    _stroke = stroke;
    _fillPaint = fill?.paint;
    _strokePaint = stroke?.paint;
    _segments = segments.toList();
    _path = segments.path;
  }

  @override
  void render(Canvas canvas) {
    if (_fillPaint != null) {
      canvas.drawPath(_path, _fillPaint!);
    }
    if (_strokePaint != null) {
      canvas.drawPath(_path, _strokePaint!);
    }
  }

  @override
  void tick(TickCtx ctx) {
    if (!_dirty) return;
    ctx.shouldRender();
    _dirty = false;
  }

  bool _dirty = true;

  void set(
      {Iterable<Segment>? segments,
      Optional<Fill>? fill,
      Optional<Stroke>? stroke}) {
    bool needsUpdate = false;
    if (segments != null) {
      if (!segments.isSame(_segments)) {
        _segments = segments.toList();
        _path = segments.path;
        needsUpdate = true;
      }
    }
    if (fill != null) {
      if (fill.value != _fill) {
        _fill = fill.value;
        _fillPaint = fill.value?.paint;
        needsUpdate = true;
      }
    }
    if (stroke != null) {
      if (stroke.value != _stroke) {
        _stroke = stroke.value;
        _strokePaint = stroke.value?.paint;
        needsUpdate = true;
      }
    }
    _dirty = _dirty || needsUpdate;
  }

  @override
  void handlePointerEvent(PointerEvent event) {
    // TODO
  }
}
