import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';
import 'package:vector_canvas/src/components/vertices_component.dart';
import 'package:vector_path/vector_path.dart';

class PointsComponent extends Component {
  List<P> _points;
  VertexPainter _vertexPainter;

  PointsComponent(Iterable<P> points,
      {VertexPainter vertexPainter = const CircularVertexPainter(5)})
      : _points = points.toList(),
        _vertexPainter = vertexPainter;

  @override
  void render(Canvas canvas) {
    for (final point in _points) {
      _vertexPainter.paint(canvas, point);
    }
  }

  void set({Iterable<P>? points, VertexPainter? vertexPainter}) {
    bool needsUpdate = false;
    if (points != null) {
      if (!points.equals(_points)) {
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
