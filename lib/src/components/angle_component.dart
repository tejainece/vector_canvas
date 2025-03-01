import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';
import 'package:vector_canvas/vector_canvas.dart';
import 'package:ramanujan/ramanujan.dart';

class AnglesComponent implements Component {
  List<LineSegment> _lines = [];

  List<Path> _pies = [];
  List<Path> _arcs = [];

  double _radius = 25;

  ToPaint? _piePainter;
  Paint? _piePaint;
  Stroke? _arcPainter;
  Paint? _arcPaint;

  AnglesComponent(Iterable<LineSegment> lines,
      {double radius = 25,
      ToPaint? piePainter,
      Stroke? arcPainter = const Stroke()}) {
    _radius = radius;
    _lines = lines.toList();
    _updateArcs();
    _updatePies();

    _piePainter = piePainter;
    _piePaint = _piePainter?.paint;
    _arcPainter = arcPainter;
    _arcPaint = _arcPainter?.paint;
  }

  @override
  void render(Canvas canvas) {
    if (_piePaint != null) {
      for (final pie in _pies) {
        if (_piePaint != null) canvas.drawPath(pie, _piePaint!);
      }
    }
    if (_arcPaint != null) {
      for (final arc in _arcs) {
        if (_arcPaint != null) canvas.drawPath(arc, _arcPaint!);
      }
    }
  }

  void set(
      {Iterable<LineSegment>? lines,
      double? radius,
      Argument<ToPaint>? piePainter,
      Argument<Stroke>? arcPainter}) {
    bool needsUpdate = false;
    if (lines != null) {
      if (!lines.isSame(_lines)) {
        _lines = lines.toList();
        needsUpdate = true;
      }
    }
    if (radius != null) {
      if (radius != _radius) {
        _radius = radius;
        needsUpdate = true;
      }
    }
    if (needsUpdate) {
      _updateArcs();
      _updatePies();
    }
    if (piePainter != null) {
      if (piePainter.value != _piePainter) {
        _piePainter = piePainter.value;
        _piePaint = _piePainter?.paint;
        needsUpdate = true;
      }
    }
    if (arcPainter != null) {
      if (arcPainter.value != _arcPainter) {
        _arcPainter = arcPainter.value;
        _arcPaint = _arcPainter?.paint;
        needsUpdate = true;
      }
    }
    if (needsUpdate) {
      _ctx?.requestRender(this);
    }
  }

  void _updatePies() {
    _pies = [];
    for (final pair in _lines.pairs()) {
      final line1 = pair.$1;
      final line2 = pair.$2;
      final center = line1.p2;
      final angle = line2.angleTo(line1.reversed());
      final p1 = line1.pointAtDistanceFromP2(_radius);
      final p2 = line2.pointAtDistanceFromP1(_radius);
      bool largeArc = angle.value > pi;
      bool clockwise = false;
      _pies.add(Path()
        ..moveTo(p1.x, p1.y)
        ..lineTo(center.x, center.y)
        ..lineTo(p2.x, p2.y)
        ..arcToPoint(p1.o,
            radius: Radius.circular(_radius),
            clockwise: clockwise,
            largeArc: largeArc)
        ..close());
    }
  }

  void _updateArcs() {
    _arcs = [];
    for (final pair in _lines.pairs()) {
      final line1 = pair.$1;
      final line2 = pair.$2;
      final angle = line2.angleTo(line1.reversed());
      final p1 = line1.pointAtDistanceFromP2(_radius);
      final p2 = line2.pointAtDistanceFromP1(_radius);
      bool largeArc = angle.value > pi;
      bool clockwise = false;
      _arcs.add(Path()
        ..moveTo(p2.x, p2.y)
        ..arcToPoint(p1.o,
            radius: Radius.circular(_radius),
            clockwise: clockwise,
            largeArc: largeArc));
    }
  }

  ComponentContext? _ctx;

  @override
  void onAttach(ComponentContext ctx) {
    _ctx = ctx;
  }
}
