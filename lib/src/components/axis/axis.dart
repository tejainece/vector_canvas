import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';
import 'package:vector_canvas/src/components/axis/axis_grid_component.dart';
import 'package:vector_canvas/src/components/axis/axis_spine_component.dart';
import 'package:vector_canvas/src/components/axis/axis_tick_component.dart';
import 'package:vector_canvas/src/components/axis/axis_tick_label_component.dart';
import 'package:vector_path/vector_path.dart';

export 'axis_grid_component.dart';
export 'axis_spine_component.dart';
export 'axis_tick_component.dart';
export 'axis_tick_label_component.dart';

typedef AxisEntityMaker<T> = T Function(R viewport);

class AxisComponent implements Component, NeedsDetach {
  R _viewport;

  HAxisSpineComponent? _hSpine;
  VAxisSpineComponent? _vSpine;
  HAxisGridComponent? _hGrid;
  VAxisGridComponent? _vGrid;
  HAxisTickComponent? _hTick;
  VAxisTickComponent? _vTick;
  HAxisTickLabelComponent? _hTickLabel;
  VAxisTickLabelComponent? _vTickLabel;

  AxisComponent(
    this._viewport, {
    AxisEntityMaker<HAxisSpineComponent>? hSpine,
    AxisEntityMaker<VAxisSpineComponent>? vSpine,
    AxisEntityMaker<HAxisGridComponent>? hGrid,
    AxisEntityMaker<VAxisGridComponent>? vGrid,
    AxisEntityMaker<HAxisTickComponent>? hTick,
    AxisEntityMaker<VAxisTickComponent>? vTick,
    AxisEntityMaker<HAxisTickLabelComponent>? hTickLabel,
    AxisEntityMaker<VAxisTickLabelComponent>? vTickLabel,
    bool yUp = false,
  })  : _hSpine = hSpine?.call(_viewport) ?? HAxisSpineComponent(_viewport),
        _vSpine = vSpine?.call(_viewport) ?? VAxisSpineComponent(_viewport),
        _hGrid = hGrid?.call(_viewport) ?? HAxisGridComponent(_viewport),
        _vGrid = vGrid?.call(_viewport) ?? VAxisGridComponent(_viewport),
        _hTick = hTick?.call(_viewport) ?? HAxisTickComponent(_viewport),
        _vTick = vTick?.call(_viewport) ?? VAxisTickComponent(_viewport),
        _hTickLabel = hTickLabel?.call(_viewport) ??
            HAxisTickLabelComponent(_viewport,
                flip: yUp,
                alignment: yUp ? Alignment.topCenter : Alignment.bottomCenter),
        _vTickLabel = vTickLabel?.call(_viewport) ??
            VAxisTickLabelComponent(_viewport, flip: yUp);

  @override
  void render(Canvas canvas) {
    _hSpine?.render(canvas);
    _vSpine?.render(canvas);
    _hGrid?.render(canvas);
    _vGrid?.render(canvas);
    _hTick?.render(canvas);
    _vTick?.render(canvas);
    _hTickLabel?.render(canvas);
    _vTickLabel?.render(canvas);
  }

  void set(
      {R? viewport,
      Argument<AxisEntityMaker<HAxisSpineComponent>>? hSpine,
      Argument<AxisEntityMaker<VAxisSpineComponent>>? vSpine,
      Argument<AxisEntityMaker<HAxisGridComponent>>? hGrid,
      Argument<AxisEntityMaker<VAxisGridComponent>>? vGrid,
      Argument<AxisEntityMaker<HAxisTickComponent>>? hTick,
      Argument<AxisEntityMaker<VAxisTickComponent>>? vTick,
      Argument<AxisEntityMaker<HAxisTickLabelComponent>>? hTickLabel,
      Argument<AxisEntityMaker<VAxisTickLabelComponent>>? vTickLabel}) {
    if (viewport != null && !viewport.equals(_viewport)) {
      _viewport = viewport;
      _hSpine?.set(viewport: viewport);
      _vSpine?.set(viewport: viewport);
      _hGrid?.set(viewport: viewport);
      _vGrid?.set(viewport: viewport);
      _hTick?.set(viewport: viewport);
      _vTick?.set(viewport: viewport);
      _hTickLabel?.set(viewport: viewport);
      _vTickLabel?.set(viewport: viewport);
    }
    if (hSpine != null) {
      if (_hSpine != null) {
        _ctx?.unregisterComponent(_hSpine!);
      }
      _hSpine = hSpine.value?.call(_viewport);
      if (_hSpine != null) {
        _ctx?.registerComponent(_hSpine!);
      }
    }
    if (vSpine != null) {
      if (_vSpine != null) {
        _ctx?.unregisterComponent(_vSpine!);
      }
      _vSpine = vSpine.value?.call(_viewport);
      if (_vSpine != null) {
        _ctx?.registerComponent(_vSpine!);
      }
    }
    if (hGrid != null) {
      if (_hGrid != null) {
        _ctx?.unregisterComponent(_hGrid!);
      }
      _hGrid = hGrid.value?.call(_viewport);
      if (_hGrid != null) {
        _ctx?.registerComponent(_hGrid!);
      }
    }
    if (vGrid != null) {
      if (_vGrid != null) {
        _ctx?.unregisterComponent(_vGrid!);
      }
      _vGrid = vGrid.value?.call(_viewport);
      if (_vGrid != null) {
        _ctx?.registerComponent(_vGrid!);
      }
    }
    if (hTick != null) {
      if (_hTick != null) {
        _ctx?.unregisterComponent(_hTick!);
      }
      _hTick = hTick.value?.call(_viewport);
      if (_hTick != null) {
        _ctx?.registerComponent(_hTick!);
      }
    }
    if (vTick != null) {
      if (_vTick != null) {
        _ctx?.unregisterComponent(_vTick!);
      }
      _vTick = vTick.value?.call(_viewport);
      if (_vTick != null) {
        _ctx?.registerComponent(_vTick!);
      }
    }
    if (hTickLabel != null) {
      if (_hTickLabel != null) {
        _ctx?.unregisterComponent(_hTickLabel!);
      }
      _hTickLabel = hTickLabel.value?.call(_viewport);
      if (_hTickLabel != null) {
        _ctx?.registerComponent(_hTickLabel!);
      }
    }
    if (vTickLabel != null) {
      if (_vTickLabel != null) {
        _ctx?.unregisterComponent(_vTickLabel!);
      }
      _vTickLabel = vTickLabel.value?.call(_viewport);
      if (_vTickLabel != null) {
        _ctx?.registerComponent(_vTickLabel!);
      }
    }
  }

  ComponentContext? _ctx;

  @override
  void onAttach(ComponentContext ctx) {
    _ctx = ctx;
    _ctx?.registerComponents([
      if (_hSpine != null) _hSpine!,
      if (_vSpine != null) _vSpine!,
      if (_hGrid != null) _hGrid!,
      if (_vGrid != null) _vGrid!,
      if (_hTick != null) _hTick!,
      if (_vTick != null) _vTick!,
      if (_hTickLabel != null) _hTickLabel!,
      if (_vTickLabel != null) _vTickLabel!,
    ]);
  }

  @override
  void onDetach(ComponentContext ctx) {
    ctx.unregisterComponents([
      if (_hSpine != null) _hSpine!,
      if (_vSpine != null) _vSpine!,
      if (_hGrid != null) _hGrid!,
      if (_vGrid != null) _vGrid!,
      if (_hTick != null) _hTick!,
      if (_vTick != null) _vTick!,
      if (_hTickLabel != null) _hTickLabel!,
      if (_vTickLabel != null) _vTickLabel!,
    ]);
  }
}
