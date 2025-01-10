import 'dart:ui';

import 'package:vector_canvas/vector_canvas.dart';
import 'package:vector_path/vector_path.dart';

class HAxisTickComponent extends Component {
  R _viewport;

  double _gap;

  VertexPainter _tickPainter;

  double _atY;

  int? _specialEvery;

  VertexPainter _specialTickPainter;

  HAxisTickComponent(
    this._viewport, {
    double gap = 10,
    double atY = 0,
    VertexPainter tickPainter = const VTickPainter(),
    int? specialEvery = 5,
    VertexPainter specialTickPainter = const VTickPainter(size: 4),
  })  : _gap = gap,
        _atY = atY,
        _tickPainter = tickPainter,
        _specialEvery = specialEvery,
        _specialTickPainter = specialTickPainter {
    _compute();
  }

  List<P> _points = [];

  @override
  void render(Canvas canvas) {
    for (final point in _points) {
      if (_specialEvery != null) {
        int n = point.x.abs() ~/ _gap;
        if (n % _specialEvery! == 0) {
          _specialTickPainter.paint(canvas, point);
          continue;
        }
      }
      _tickPainter.paint(canvas, point);
    }
  }

  void set(
      {R? viewport,
      double? gap,
      double? atY,
      VertexPainter? tickPainter,
      int? specialEvery,
      VertexPainter? specialTickPainter}) {
    bool needsUpdate = false;
    if (viewport != null && !viewport.equals(_viewport)) {
      _viewport = viewport;
      needsUpdate = true;
    }
    if (gap != null && _gap != gap) {
      _gap = gap;
      needsUpdate = true;
    }
    if (atY != null && _atY != atY) {
      _atY = atY;
      needsUpdate = true;
    }
    if (needsUpdate) {
      _compute();
    }
    if (tickPainter != null && _tickPainter != tickPainter) {
      _tickPainter = tickPainter;
      needsUpdate = true;
    }
    if (specialEvery != null && _specialEvery != specialEvery) {
      _specialEvery = specialEvery;
      needsUpdate = true;
    }
    if (specialTickPainter != null &&
        _specialTickPainter != specialTickPainter) {
      _specialTickPainter = specialTickPainter;
      needsUpdate = true;
    }
    if (needsUpdate) {
      _ctx?.requestRender(this);
    }
  }

  void _compute() {
    final points = <P>[];
    double low = _viewport.left.lowerNearestMultipleOf(_gap);
    double high = _viewport.right.higherNearestMultipleOf(_gap);
    for (double x = low; x <= high + 1e-8; x += _gap) {
      points.add(P(x, _atY));
    }
    _points = points;
  }

  ComponentContext? _ctx;

  @override
  void onAttach(ComponentContext ctx) {
    _ctx = ctx;
  }
}

class VAxisTickComponent extends Component {
  R _viewport;

  double _gap;

  VertexPainter _tickPainter;

  double _atX;

  int? _specialEvery;

  VertexPainter _specialTickPainter;

  VAxisTickComponent(
    this._viewport, {
    double gap = 10,
    double atX = 0,
    VertexPainter tickPainter = const HTickPainter(),
    int? specialEvery = 5,
    VertexPainter specialTickPainter = const HTickPainter(size: 4),
  })  : _gap = gap,
        _atX = atX,
        _tickPainter = tickPainter,
        _specialEvery = specialEvery,
        _specialTickPainter = specialTickPainter {
    _compute();
  }

  List<P> _points = [];

  @override
  void render(Canvas canvas) {
    for (final point in _points) {
      if (_specialEvery != null) {
        int n = point.y.abs() ~/ _gap;
        if (n % _specialEvery! == 0) {
          _specialTickPainter.paint(canvas, point);
          continue;
        }
      }
      _tickPainter.paint(canvas, point);
    }
  }

  void set(
      {R? viewport,
      double? gap,
      double? atX,
      VertexPainter? tickPainter,
      int? specialEvery,
      VertexPainter? specialTickPainter}) {
    bool needsUpdate = false;
    if (viewport != null && !viewport.equals(_viewport)) {
      _viewport = viewport;
      needsUpdate = true;
    }
    if (gap != null && _gap != gap) {
      _gap = gap;
      needsUpdate = true;
    }
    if (atX != null && _atX != atX) {
      _atX = atX;
      needsUpdate = true;
    }
    if (needsUpdate) {
      _compute();
    }
    if (tickPainter != null && _tickPainter != tickPainter) {
      _tickPainter = tickPainter;
      needsUpdate = true;
    }
    if (specialEvery != null && _specialEvery != specialEvery) {
      _specialEvery = specialEvery;
      needsUpdate = true;
    }
    if (specialTickPainter != null &&
        _specialTickPainter != specialTickPainter) {
      _specialTickPainter = specialTickPainter;
      needsUpdate = true;
    }
    if (needsUpdate) {
      _ctx?.requestRender(this);
    }
  }

  void _compute() {
    final points = <P>[];
    double low = _viewport.top.lowerNearestMultipleOf(_gap);
    double high = _viewport.bottom.higherNearestMultipleOf(_gap);
    for (double y = low; y <= high + 1e-8; y += _gap) {
      points.add(P(_atX, y));
    }
    _points = points;
  }

  ComponentContext? _ctx;

  @override
  void onAttach(ComponentContext ctx) {
    _ctx = ctx;
  }
}

class VTickPainter extends VertexPainter {
  final double size;

  final Stroke stroke;

  const VTickPainter({this.size = 2, this.stroke = const Stroke()});

  @override
  void paint(Canvas canvas, P point) {
    canvas.drawLine(Offset(point.x, point.y - size),
        Offset(point.x, point.y + size), stroke.paint);
  }
}

class HTickPainter extends VertexPainter {
  final double size;

  final Stroke stroke;

  const HTickPainter({this.size = 2, this.stroke = const Stroke()});

  @override
  void paint(Canvas canvas, P point) {
    canvas.drawLine(Offset(point.x - size, point.y),
        Offset(point.x + size, point.y), stroke.paint);
  }
}
