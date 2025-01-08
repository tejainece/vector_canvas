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

  @override
  void render(Canvas canvas) {
    for (final segment in _segments) {
      canvas.drawPath(segment.path, _paint);
    }
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
    if (needsUpdate) {
      _ctx?.requestRender(this);
    }
  }

  ComponentContext? _ctx;

  @override
  void onAttach(ComponentContext ctx) {
    _ctx = ctx;
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
    if (needsUpdate) {
      _ctx?.requestRender(this);
    }
  }

  ComponentContext? _ctx;

  @override
  void onAttach(ComponentContext ctx) {
    _ctx = ctx;
  }
}
