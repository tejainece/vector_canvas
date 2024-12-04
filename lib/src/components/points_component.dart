import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';
import 'package:vector_canvas/src/components/vertices_component.dart';

class PointsComponent extends Component {
  final List<Offset> points;
  late VertexPainter _vertexPainter;

  PointsComponent(this.points, {VertexPainter? vertexPainter}) {
    _vertexPainter = vertexPainter ?? CircularVertexPainter(5);
  }

  @override
  void render(Canvas canvas) {
    for (final point in points) {
      _vertexPainter.paint(canvas, point);
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