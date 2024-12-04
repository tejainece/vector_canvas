import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';
import 'package:vector_path/vector_path.dart';

class PathComponent implements Component {
  final VectorCurve curve;

  Paint _paint = Paint();

  PathComponent(this.curve,
      {Color color = Colors.black,
      double strokeWidth = 1,
      PaintingStyle style = PaintingStyle.stroke}) {
    this.color = color;
    this.strokeWidth = strokeWidth;
    this.style = style;
  }

  bool _dirty = true;

  Color get color => _paint.color;

  set color(Color value) {
    if (_paint.color == value) return;
    _paint.color = value;
    _dirty = true;
  }

  double get strokeWidth => _paint.strokeWidth;

  set strokeWidth(double value) {
    if (_paint.strokeWidth == value) return;
    _paint.strokeWidth = value;
    _dirty = true;
  }

  PaintingStyle get style => _paint.style;

  set style(PaintingStyle value) {
    if (_paint.style == value) return;
    _paint.style = value;
    _dirty = true;
  }

  @override
  void render(Canvas canvas) {
    // TODO transform
    canvas.drawPath(curve.path, _paint);
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

extension VectorCurveExt on VectorCurve {
  Path get path {
    final path = Path();
    if (segments.isEmpty) return path;
    path.moveTo(segments.first.p1.x, segments.first.p1.y);
    for (final segment in segments) {
      if (segment is LineSegment) {
        path.lineTo(segment.p2.x, segment.p2.y);
      } else if (segment is CubicSegment) {
        path.cubicTo(segment.c1.x, segment.c1.y, segment.c2.x, segment.c2.y,
            segment.p2.x, segment.p2.y);
      } else if (segment is QuadraticSegment) {
        path.quadraticBezierTo(
            segment.c.x, segment.c.y, segment.p2.x, segment.p2.y);
      } /* TODO else if (segment is ArcSegment) {
        path.arcTo(segment.rect, segment.startAngle, segment.sweepAngle,
            segment.useCenter);
      }*/
    }
    return path;
  }
}
