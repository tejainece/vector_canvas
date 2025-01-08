import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vector_canvas/vector_canvas.dart';
import 'package:vector_path/vector_path.dart';

class HAxisTickLabelComponent implements Component, NeedsDetach {
  R _rect;

  double _gap;

  double _atY;

  bool _flip = false;

  TextStyle _style;

  Alignment _alignment;

  String Function(double) _tickLabeler;

  Set<double> _skip;

  HAxisTickLabelComponent(
    this._rect, {
    double gap = 10,
    double atY = 0,
    bool flip = false,
    TextStyle? style,
    Alignment alignment = Alignment.bottomCenter,
    String Function(double) tickLabeler = tickLabeler,
    Set<double> skip = const {},
  })  : _gap = gap,
        _atY = atY,
        _flip = flip,
        _style = style ?? TextStyle(color: Colors.black),
        _alignment = alignment,
        _tickLabeler = tickLabeler,
        _skip = skip.toSet() {
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
    R? rect,
    double? gap,
    double? atY,
    bool? flip,
    TextStyle? style,
    Alignment? alignment,
    String Function(double)? tickLabeler,
    Set<double>? skip,
  }) {
    bool needsUpdate = false;
    if (rect != null && rect != _rect) {
      _rect = rect;
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
    if (skip != null && setEquals(_skip, skip)) {
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
    double low = _rect.left.lowerNearestMultipleOf(_gap);
    double high = _rect.right.higherNearestMultipleOf(_gap);
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
  R _rect;

  double _gap;

  double _atX;

  bool _flip = false;

  TextStyle _style;

  Alignment _alignment;

  String Function(double) _tickLabeler;

  Set<double> _skip;

  VAxisTickLabelComponent(
    this._rect, {
    double gap = 10,
    double atX = 0,
    bool flip = false,
    TextStyle? style,
    Alignment alignment = Alignment.centerRight,
    String Function(double) tickLabeler = tickLabeler,
    Set<double> skip = const {},
  })  : _gap = gap,
        _atX = atX,
        _flip = flip,
        _style = style ?? TextStyle(color: Colors.black),
        _alignment = alignment,
        _tickLabeler = tickLabeler, _skip = skip.toSet() {
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
      {R? rect,
      double? gap,
      double? atX,
      bool? flip,
      TextStyle? style,
      Alignment? alignment,
      String Function(double)? tickLabeler, Set<double>? skip}) {
    bool needsUpdate = false;
    if (rect != null && rect != _rect) {
      _rect = rect;
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
    if (skip != null && setEquals(_skip, skip)) {
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
    double low = _rect.top.lowerNearestMultipleOf(_gap);
    double high = _rect.bottom.higherNearestMultipleOf(_gap);
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
