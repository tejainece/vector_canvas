import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';
import 'package:vector_canvas/src/components/vertices_component.dart';
import 'package:vector_canvas/src/util.dart';

class PointsComponent extends Component {
  List<Offset> _points;
  VertexPainter _vertexPainter;

  PointsComponent(Iterable<Offset> points,
      {VertexPainter vertexPainter = const CircularVertexPainter(5)})
      : _points = points.toList(),
        _vertexPainter = vertexPainter;

  @override
  void render(Canvas canvas) {
    for (final point in _points) {
      _vertexPainter.paint(canvas, point);
    }
  }

  bool _dirty = true;

  @override
  void tick(TickCtx ctx) {
    if (!_dirty) return;
    ctx.shouldRender();
    _dirty = false;
  }

  void set({Iterable<Offset>? points, VertexPainter? vertexPainter}) {
    bool needsUpdate = false;
    if (points != null) {
      if (!points.isSame(_points)) {
        _points = points.toList();
        needsUpdate = true;
      }
    }
    if (vertexPainter != null) {
      if (vertexPainter != _vertexPainter) {
        _vertexPainter = vertexPainter;
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
