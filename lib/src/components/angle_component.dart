
import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';
import 'package:vector_path/vector_path.dart';

class AngleComponent implements Component {
  Iterable<LineSegment> _lines = [];

  List<Path> _arcs = [];

  double _radius = 25;

  Paint _paint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.fill;

  AngleComponent(Iterable<LineSegment> lines,
      {double radius = 25, Paint? paint}) {
    set(lines: lines, radius: radius, paint: paint);
  }

  bool _dirty = false;

  void set({Iterable<LineSegment>? lines, double? radius, Paint? paint}) {
    bool needsUpdate = false;

    if (lines != null) {
      if (!lines.isSame(_lines)) {
        _lines = lines;
        needsUpdate = true;
      }
    }

    if (radius != null) {
      if (radius != _radius) {
        _radius = radius;
        needsUpdate = true;
      }
    }

    if (paint != null) {
      _paint = paint;
      needsUpdate = true;
    }

    if (needsUpdate) _update();
  }

  set radius(double radius) {
    if (radius == _radius) return;
    _radius = radius;
    _update();
  }

  set lines(Iterable<LineSegment> lines) {
    if (_lines.isSame(lines)) return;
    _lines = lines;
    _update();
  }

  void _update() {
    _dirty = true;
    _arcs = [];
    for (final pair in _lines.pairs()) {
      final line1 = pair.$1;
      final line2 = pair.$2;
      final center = line1.p2;
      final angle = line2.angleTo(line1.reversed());
      final p1 = line1.pointAtDistanceFromP2(_radius);
      final p2 = line2.pointAtDistanceFromP1(_radius);
      print('angle ${line2.angle.value} ${line2.angle.unclamped} ${line2.angle}');
      // print('angle ${line1.angle} ${line2.angle} ${angle}');
      bool largeArc = false;
      bool clockwise = false;
      if(angle.value > pi) {
        largeArc = true;
      }

      final path = Path()
        ..moveTo(p1.x, p1.y)
        ..lineTo(center.x, center.y)
        ..lineTo(p2.x, p2.y)
        ..arcToPoint(p1.o,
            radius: Radius.circular(_radius),
            clockwise: clockwise,
            largeArc: largeArc)
        ..close();
      _arcs.add(path);
    }
  }

  set paint(Paint paint) {
    _paint = paint;
    _dirty = true;
  }

  @override
  void render(Canvas canvas) {
    for (final arc in _arcs) {
      canvas.drawPath(arc, _paint);
    }
  }

  @override
  void tick(TickCtx ctx) {
    if (!_dirty) return;
    ctx.shouldRender();
    _dirty = false;
  }

  @override
  void handlePointerEvent(PointerEvent event) {
    // TODO
  }
}
