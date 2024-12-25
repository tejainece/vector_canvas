import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';
import 'package:vector_canvas/vector_canvas.dart';
import 'package:vector_path/vector_path.dart';

class VerticesComponent extends Component {
  List<Segment> _segments;
  VertexPainter _vertexPainter;

  VerticesComponent(Iterable<Segment> segments,
      {VertexPainter vertexPainter = const CircularVertexPainter(5)})
      : _segments = segments.toList(),
        _vertexPainter = vertexPainter;

  @override
  void render(Canvas canvas) {
    if (_segments.isEmpty) return;
    _vertexPainter.paint(canvas, _segments.first.p1.o);
    for (final segment in _segments) {
      _vertexPainter.paint(canvas, segment.p2.o);
    }
  }

  bool _dirty = true;

  @override
  void tick(TickCtx ctx) {
    if (!_dirty) return;
    ctx.shouldRender();
    _dirty = false;
  }

  void set({Iterable<Segment>? segments, VertexPainter? vertexPainter}) {
    bool needsUpdate = false;
    if (segments != null) {
      if (!segments.isSame(_segments)) {
        _segments = segments.toList();
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

abstract class VertexPainter {
  const VertexPainter();

  void paint(Canvas canvas, Offset point);
}

class CircularVertexPainter extends VertexPainter {
  final double radius;
  final Stroke? stroke;
  final Fill? fill;

  const CircularVertexPainter(this.radius,
      {this.stroke, this.fill = const Fill(color: Colors.blue)});

  @override
  void paint(Canvas canvas, Offset point) {
    if (fill != null) {
      canvas.drawCircle(point, radius, fill!.paint);
    }
    if (stroke != null) {
      canvas.drawCircle(point, radius, stroke!.paint);
    }
  }
}
