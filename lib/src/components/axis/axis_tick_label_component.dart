import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vector_canvas/vector_canvas.dart';
import 'package:ramanujan/ramanujan.dart';

class HAxisTickLabelComponent implements Component, NeedsDetach {
  R _viewport;

  double _gap;

  double _atY;

  bool _flip = false;

  TextStyle _style;

  Alignment _alignment;

  String Function(double) _tickLabeler;

  List<double> _skip;

  HAxisTickLabelComponent(
    this._viewport, {
    double gap = 100,
    double atY = -5,
    bool flip = false,
    TextStyle? style,
    Alignment alignment = Alignment.bottomCenter,
    String Function(double) tickLabeler = tickLabeler,
    List<double> skip = const [0],
  })  : _gap = gap,
        _atY = atY,
        _flip = flip,
        _style = style ?? TextStyle(color: Colors.black),
        _alignment = alignment,
        _tickLabeler = tickLabeler,
        _skip = skip.toList() {
    _compute();
  }

  List<AnchoredTextComponent> _texts = [];

  @override
  void render(Canvas canvas) {
    canvas.save();
    try {
      if (_flip) {
        FlipVerticallyComponent.transformCanvas(canvas, atY: _atY);
      }
      for (final text in _texts) {
        text.render(canvas);
      }
    } finally {
      canvas.restore();
    }
  }

  void set({
    R? viewport,
    double? gap,
    double? atY,
    bool? flip,
    TextStyle? style,
    Alignment? alignment,
    String Function(double)? tickLabeler,
    List<double>? skip,
  }) {
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
    if (flip != null && _flip != flip) {
      _flip = flip;
      needsUpdate = true;
    }
    if (style != null && _style != style) {
      _style = style;
      needsUpdate = true;
    }
    if (alignment != null && _alignment != alignment) {
      _alignment = alignment;
      needsUpdate = true;
    }
    if (tickLabeler != null && _tickLabeler != tickLabeler) {
      _tickLabeler = tickLabeler;
      needsUpdate = true;
    }
    if (skip != null && listEquals(_skip, skip)) {
      _skip = skip;
      needsUpdate = true;
    }
    if (needsUpdate) {
      _ctx?.requestRender(this);
    }
  }

  void _compute() {
    _ctx?.unregisterComponents(_texts);
    final points = <AnchoredTextComponent>[];
    double low = _viewport.left.lowerNearestMultipleOf(_gap);
    double high = _viewport.right.higherNearestMultipleOf(_gap);
    for (double x = low; x <= high + 1e-8; x += _gap) {
      if (_skip.any((v) => (v - x).abs() < 1e-6)) continue;
      points.add(AnchoredTextComponent(
          text: _tickLabeler(x),
          anchor: Offset(x, _atY),
          style: _style,
          anchorPlacement: _alignment));
    }
    _texts = points;
    _ctx?.registerComponents(_texts);
  }

  ComponentContext? _ctx;

  @override
  void onAttach(ComponentContext ctx) {
    _ctx = ctx;
    _ctx?.registerComponents(_texts);
  }

  @override
  void onDetach(ComponentContext ctx) {
    _ctx?.unregisterComponents(_texts);
    _ctx = null;
  }
}

class VAxisTickLabelComponent implements Component, NeedsDetach {
  R _viewport;

  double _gap;

  double _atX;

  bool _flip = false;

  TextStyle _style;

  Alignment _alignment;

  String Function(double) _tickLabeler;

  List<double> _skip;

  VAxisTickLabelComponent(
    this._viewport, {
    double gap = 100,
    double atX = -5,
    bool flip = false,
    TextStyle? style,
    Alignment alignment = Alignment.centerRight,
    String Function(double) tickLabeler = tickLabeler,
    List<double> skip = const [0],
  })  : _gap = gap,
        _atX = atX,
        _flip = flip,
        _style = style ?? TextStyle(color: Colors.black),
        _alignment = alignment,
        _tickLabeler = tickLabeler,
        _skip = skip.toList() {
    _compute();
  }

  List<AnchoredTextComponent> _texts = [];

  @override
  void render(Canvas canvas) {
    if (_flip) {
      for (final text in _texts) {
        canvas.save();
        try {
          FlipVerticallyComponent.transformCanvas(canvas, atY: text.anchor.dy);
          text.render(canvas);
        } finally {
          canvas.restore();
        }
      }
    } else {
      for (final text in _texts) {
        text.render(canvas);
      }
    }
  }

  void set(
      {R? viewport,
      double? gap,
      double? atX,
      bool? flip,
      TextStyle? style,
      Alignment? alignment,
      String Function(double)? tickLabeler,
      List<double>? skip}) {
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
    if (flip != null && _flip != flip) {
      _flip = flip;
      needsUpdate = true;
    }
    if (style != null && _style != style) {
      _style = style;
      needsUpdate = true;
    }
    if (alignment != null && _alignment != alignment) {
      _alignment = alignment;
      needsUpdate = true;
    }
    if (tickLabeler != null && _tickLabeler != tickLabeler) {
      _tickLabeler = tickLabeler;
      needsUpdate = true;
    }
    if (skip != null && listEquals(_skip, skip)) {
      _skip = skip;
      needsUpdate = true;
    }
    if (needsUpdate) {
      _ctx?.requestRender(this);
    }
  }

  void _compute() {
    _ctx?.unregisterComponents(_texts);
    final points = <AnchoredTextComponent>[];
    double low = _viewport.top.lowerNearestMultipleOf(_gap);
    double high = _viewport.bottom.higherNearestMultipleOf(_gap);
    for (double y = low; y <= high + 1e-8; y += _gap) {
      if (_skip.any((v) => (v - y).abs() < 1e-6)) continue;
      points.add(AnchoredTextComponent(
          text: _tickLabeler(y),
          anchor: Offset(_atX, y),
          style: _style,
          anchorPlacement: _alignment));
    }
    _texts = points;
    _ctx?.registerComponents(_texts);
  }

  ComponentContext? _ctx;

  @override
  void onAttach(ComponentContext ctx) {
    _ctx = ctx;
    _ctx?.registerComponents(_texts);
  }

  @override
  void onDetach(ComponentContext ctx) {
    _ctx?.unregisterComponents(_texts);
    _ctx = null;
  }
}

String tickLabeler(double x) {
  int integer = x.round();
  if ((x - integer).abs() < 1e-6) {
    return integer.toString();
  }
  return x.toStringAsFixed(2);
}
