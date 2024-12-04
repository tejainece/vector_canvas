import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';
import 'package:vector_path/vector_path.dart';

class VerticesComponent extends Component {
  final VectorCurve curve;
  late VertexPainter _vertexPainter;

  VerticesComponent(this.curve, {VertexPainter? vertexPainter}) {
    _vertexPainter = vertexPainter ?? CircularVertexPainter(5);
  }

  @override
  void render(Canvas canvas) {
    for (final segment in curve.segments) {
      _vertexPainter.paint(canvas, segment.p1.o);
      _vertexPainter.paint(canvas, segment.p2.o);
    }
  }

  @override
  void tick(TickCtx ctx) {
    // TODO
  }

  @override
  void handlePointerEvent(PointerEvent event) {
    // TODO
  }
}

abstract class VertexPainter {
  void paint(Canvas canvas, Offset point);
}

class CircularVertexPainter extends VertexPainter {
  final double radius;
  final Paint? stroke;
  final Paint? fill;

  CircularVertexPainter(this.radius, {this.stroke, Paint? fill})
      : fill = stroke == null && fill == null
            ? (Paint()..color = Colors.blue)
            : fill {
    stroke?.style = PaintingStyle.stroke;
    fill?.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Offset point) {
    if (fill != null) {
      canvas.drawCircle(point, radius, fill!);
    }
    if (stroke != null) {
      canvas.drawCircle(point, radius, stroke!);
    }
  }
}
