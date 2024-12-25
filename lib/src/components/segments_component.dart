import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';
import 'package:vector_canvas/vector_canvas.dart';
import 'package:vector_path/vector_path.dart';

class SegmentsComponent implements Component {
  List<Segment> _segments;

  Stroke _stroke;
  Paint _paint;

  SegmentsComponent(Iterable<Segment> segments,
      {Stroke stroke = const Stroke()})
      : _segments = segments.toList(),
        _stroke = stroke,
        _paint = stroke.paint;

  bool _dirty = true;

  @override
  void render(Canvas canvas) {
    for (final segment in _segments) {
      canvas.drawPath(segment.path, _paint);
    }
  }

  @override
  void tick(TickCtx ctx) {
    if (!_dirty) return;
    ctx.shouldRender();
    _dirty = false;
  }

  void set({Iterable<Segment>? segments, Stroke? stroke}) {
    bool needsUpdate = false;
    if (segments != null) {
      if (!segments.isSame(_segments)) {
        _segments = segments.toList();
        needsUpdate = true;
      }
    }
    if (stroke != null) {
      if (stroke != _stroke) {
        _stroke = stroke;
        _paint = stroke.paint;
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

class LineComponent extends Component {
  LineSegment _line;

  Stroke _stroke;
  Paint _strokePaint;

  LineComponent(this._line, {Stroke stroke = const Stroke()})
      : _stroke = stroke,
        _strokePaint = stroke.paint;

  @override
  void render(Canvas canvas) {
    canvas.drawLine(_line.p1.o, _line.p2.o, _strokePaint);
  }

  @override
  void tick(TickCtx ctx) {
    if (!_dirty) return;
    ctx.shouldRender();
    _dirty = false;
  }

  bool _dirty = true;

  void set({LineSegment? line, Stroke? stroke}) {
    bool needsUpdate = false;
    if (line != null) {
      _line = line;
      needsUpdate = true;
    }
    if (stroke != null) {
      if (stroke != _stroke) {
        _stroke = stroke;
        _strokePaint = stroke.paint;
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
