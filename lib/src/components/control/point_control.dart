import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_canvas/vector_canvas.dart';
import 'package:vector_path/vector_path.dart';

class PointControlComponent extends Component
    implements CanHitTest, NeedsDetach, PointerEventHandler {
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

  Circle _circle = Circle();
  Affine2d _transform = Affine2d();

  void set(
      {P? point,
      double? radius,
      bool? selected,
      Argument<Stroke>? stroke,
      Argument<Fill>? fill,
      Argument<Stroke>? selectedStroke,
      Argument<Fill>? selectedFill}) {
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
      _ctx?.requestRender(this);
    }
  }

  void _update() {
    _circle = Circle(center: _point, radius: _radius);
  }

  late final TapDetector _tapDetector = TapDetector(
    onTap: (e) {
      if (_wasSelected) {
        controlData?.toggle(e.pointer,
            append: HardwareKeyboard.instance.isShiftPressed);
      } else {
        controlData?.select(e.pointer,
            append: HardwareKeyboard.instance.isShiftPressed);
      }
      _wasSelected = false;
    },
    debug: controlData?.id,
  );

  bool _wasSelected = false;

  @override
  void handlePointerEvent(PointerEvent e) {
    if (!hitTest(e.position)) {
      return;
    }
    if (e is PointerDownEvent) {
      _wasSelected = controlData?.isSelected ?? false;
      controlData?.select(e.pointer,
          append: HardwareKeyboard.instance.isShiftPressed);
    } else if (e is PointerCancelEvent) {
      _wasSelected = false;
    }
    _tapDetector.handlePointerEvent(e);
  }

  @override
  bool hitTest(Offset point) {
    P p = P(point.dx, point.dy).transform(_transform.inverse());
    return _circle.containsPoint(p);
  }

  ComponentContext? _ctx;

  @override
  void onAttach(ComponentContext ctx) {
    _ctx = ctx;
    controlData?.controls.addChangedListener(this, () {
      bool selected = controlData!.isSelected;
      set(selected: selected);
    });
  }

  @override
  void onDetach(ComponentContext ctx) {
    controlData?.controls.removeChangedListener(this);
  }
}

class ControlData {
  final Controls controls;

  final Object id;

  ControlData(this.controls, this.id);

  bool get isSelected => controls.isSelected(id);

  void toggle(int pointer, {bool append = false}) {
    controls.toggle(pointer, id, append: append);
  }

  void select(int pointer, {bool append = false}) {
    controls.select(pointer, id, append: append);
  }

  void append(int pointer) {
    controls.append(pointer, id);
  }
}
