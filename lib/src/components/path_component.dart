import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';
import 'package:vector_canvas/vector_canvas.dart';
import 'package:ramanujan/ramanujan.dart';

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

  void set(
      {Iterable<Segment>? segments,
      Argument<Fill>? fill,
      Argument<Stroke>? stroke}) {
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
