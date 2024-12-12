import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';
import 'package:vector_path/vector_path.dart';

class SegmentsComponent implements Component {
  List<Segment> _segments;

  final Paint _paint = Paint();

  SegmentsComponent(this._segments,
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
    for (final line in _segments) {
      if (line is LineSegment) {
        canvas.drawLine(line.p1.o, line.p2.o, _paint);
      } else if (line is CircularArcSegment) {
        canvas.drawPath(
            Path()
              ..moveTo(line.p1.x, line.p1.y)
              ..arcToPoint(
                line.p2.o,
                radius: Radius.circular(line.radius),
                largeArc: line.largeArc,
                clockwise: line.clockwise,
              ),
            _paint);
      } else if (line is ArcSegment) {
        canvas.drawPath(
            Path()
              ..moveTo(line.p1.x, line.p1.y)
              ..arcToPoint(line.p2.o,
                  radius: Radius.elliptical(line.radius.x, line.radius.y),
                  rotation: line.rotation,
                  largeArc: line.largeArc,
                  clockwise: line.clockwise),
            _paint);
      } else if (line is QuadraticSegment) {
        canvas.drawPath(
            Path()
              ..moveTo(line.p1.x, line.p1.y)
              ..quadraticBezierTo(line.c.x, line.c.y, line.p2.x, line.p2.y),
            _paint);
      } else if (line is CubicSegment) {
        canvas.drawPath(
            Path()
              ..moveTo(line.p1.x, line.p2.y)
              ..cubicTo(line.c1.x, line.c1.y, line.c2.x, line.c2.y, line.p2.x,
                  line.p2.y),
            _paint);
      } else {
        throw UnimplementedError('${line.runtimeType}');
      }
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

  void set({Iterable<Segment>? lines}) {
    bool needsUpdate = false;

    if (lines != null) {
      if (!lines.isSame(this._segments)) {
        _segments = lines.toList();
        needsUpdate = true;
      }
    }

    if (needsUpdate) {
      _dirty = true;
    }
  }
}

class LineComponent extends Component {
  LineSegment _line;

  final Paint _paint = Paint();

  LineComponent(this._line,
      {Color color = Colors.black, double strokeWidth = 1}) {
    _paint.color = color;
    _paint.strokeWidth = strokeWidth;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawLine(_line.p1.o, _line.p2.o, _paint);
  }

  @override
  void tick(TickCtx ctx) {
    if (!_dirty) return;
    ctx.shouldRender();
    _dirty = false;
  }

  @override
  void handlePointerEvent(PointerEvent event) {
    // TODO: implement handlePointerEvent
  }

  bool _dirty = true;

  Color get color => _paint.color;

  set color(Color value) {
    if (_paint.color == value) return;
    _paint.color = value;
    _dirty = true;
  }

  void set({LineSegment? line, Color? color, double? strokeWidth}) {
    bool needsUpdate = false;

    if (line != null) {
      _line = line;
      needsUpdate = true;
    }
    if (color != null) {
      _paint.color = color;
      needsUpdate = true;
    }
    if (strokeWidth != null) {
      _paint.strokeWidth = strokeWidth;
      needsUpdate = true;
    }

    if (needsUpdate) {
      _dirty = true;
    }
  }
}
