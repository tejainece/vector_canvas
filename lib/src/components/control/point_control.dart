import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_engine/game_engine.dart';
import 'package:vector_canvas/vector_canvas.dart';
import 'package:vector_path/vector_path.dart';

class PointControlComponent extends Component
    implements CanHitTest, NeedsDetach {
  final ControlData? controlData;

  P _point;

  double _radius = 10;

  bool _selected = false;

  Stroke? _stroke;

  Fill? _fill;

  Stroke? _selectedStroke;

  Fill? _selectedFill;

  PointControlComponent(this._point,
      {double radius = 10,
      bool selected = false,
      Stroke? stroke,
      Fill? fill = const Fill(),
      Stroke? selectedStroke,
      this.controlData,
      Fill? selectedFill = const Fill(color: Colors.blue)})
      : _radius = radius,
        _selected = selected,
        _stroke = stroke,
        _fill = fill,
        _selectedStroke = selectedStroke,
        _selectedFill = selectedFill {
    _update();
  }

  @override
  void render(Canvas canvas) {
    _transform = Affine2d.fromMatrix4Cols(canvas.getTransform());
    Stroke? stroke = _selected ? _selectedStroke : _stroke;
    Fill? fill = _selected ? _selectedFill : _fill;
    if (stroke != null) {
      canvas.drawCircle(_point.o, _radius, stroke.paint);
    }
    if (fill != null) {
      canvas.drawCircle(_point.o, _radius, fill.paint);
    }
  }

  bool _dirty = true;

  @override
  void tick(TickCtx ctx) {
    ctx.registerDetach(this);
    if (!_dirty) return;
    ctx.shouldRender();
    _dirty = false;
  }

  Circle _circle = Circle();
  Affine2d _transform = Affine2d();

  void set(
      {P? point,
      double? radius,
      bool? selected,
      Optional<Stroke>? stroke,
      Optional<Fill>? fill,
      Optional<Stroke>? selectedStroke,
      Optional<Fill>? selectedFill}) {
    bool needsUpdate = false;
    if (point != null) {
      if (!_point.isEqual(point)) {
        _point = point;
        needsUpdate = true;
      }
    }
    if (radius != null) {
      if (!_radius.equals(radius)) {
        _radius = radius;
        needsUpdate = true;
      }
    }

    if (needsUpdate) {
      _update();
    }

    if (selected != null) {
      if (selected != _selected) {
        _selected = selected;
        needsUpdate = true;
      }
    }
    if (stroke != null) {
      if (stroke.value != _stroke) {
        _stroke = stroke.value;
        needsUpdate = true;
      }
    }
    if (fill != null) {
      if (fill.value != _fill) {
        _fill = fill.value;
        needsUpdate = true;
      }
    }
    if (selectedStroke != null) {
      if (selectedStroke.value != _selectedStroke) {
        _selectedStroke = selectedStroke.value;
        needsUpdate = true;
      }
    }
    if (selectedFill != null) {
      if (selectedFill.value != _selectedFill) {
        _selectedFill = selectedFill.value;
        needsUpdate = true;
      }
    }

    if (needsUpdate) {
      _dirty = true;
    }
  }

  void _update() {
    _circle = Circle(center: _point, radius: _radius);
  }

  late final TapDetector _tapDetector = TapDetector(
    onTap: (_) {
      controlData?.toggle(append: HardwareKeyboard.instance.isShiftPressed);
    },
  );

  @override
  void handlePointerEvent(PointerEvent event) {
    if (!hitTest(event.localPosition)) {
      return;
    }
    _tapDetector.handlePointerEvent(event);
  }

  @override
  bool hitTest(Offset point) => _circle
      .containsPoint(P(point.dx, point.dy).transform(_transform.inverse()));

  @override
  void onAttach() {
    controlData?.controls.addChangedListener(this, () {
      bool selected = controlData!.isSelected;
      set(selected: selected);
    });
  }

  @override
  void onDetach() {
    controlData?.controls.removeChangedListener(this);
  }
}

class ControlData {
  final Controls controls;

  final Object id;

  ControlData(this.controls, this.id);

  bool get isSelected => controls.isSelected(id);

  void toggle({bool append = false}) {
    controls.toggle(id, append: append);
  }
}