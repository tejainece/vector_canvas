import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:game_engine/game_engine.dart';

class TransformComponent implements Component, NeedsDetach {
  List<Component> _children = [];
  Float64List _matrix;

  TransformComponent(List<Component> children, this._matrix) {
    _updateChildren(children);
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    try {
      canvas.transform(_matrix);
      for (var child in _children) {
        child.render(canvas);
      }
    } finally {
      canvas.restore();
    }
  }

  void set({List<Component>? children, Float64List? matrix}) {
    bool needsUpdate = false;
    if (children != null && !Component.compareChildren(children, _children)) {
      _updateChildren(children);
      needsUpdate = true;
    }
    if (matrix != null) {
      _matrix = matrix;
      needsUpdate = true;
    }
    if (needsUpdate) {
      _ctx?.requestRender(this);
    }
  }

  Set<Component> _childrenSet = <Component>{};

  void _updateChildren(List<Component> children) {
    _childrenSet = Component.updateChildren(_childrenSet, children, _ctx);
    _children = children.toList();
  }

  ComponentContext? _ctx;

  @override
  void onAttach(ComponentContext ctx) {
    _ctx = ctx;
    for (var child in _children) {
      _ctx?.registerComponent(child);
    }
  }

  @override
  void onDetach(ComponentContext ctx) {
    for (var child in _children) {
      _ctx?.unregisterComponent(child);
    }
    _ctx = null;
  }
}

class OriginToCenterComponent implements Component, NeedsDetach {
  List<Component> _children = [];
  Size _size;

  OriginToCenterComponent(List<Component> children, this._size) {
    _updateChildren(children);
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    try {
      canvas.translate(_size.width / 2, _size.height / 2);
      canvas.scale(1, -1);
      for (var child in _children) {
        child.render(canvas);
      }
    } finally {
      canvas.restore();
    }
  }

  void set({List<Component>? children, Size? size}) {
    bool needsUpdate = false;
    if (children != null && !Component.compareChildren(children, _children)) {
      _updateChildren(children);
      needsUpdate = true;
    }
    if (size != null) {
      if (size != _size) {
        _size = size;
        needsUpdate = true;
      }
    }
    if (needsUpdate) {
      _ctx?.requestRender(this);
    }
  }

  Set<Component> _childrenSet = <Component>{};

  void _updateChildren(List<Component> children) {
    _childrenSet = Component.updateChildren(_childrenSet, children, _ctx);
    _children = children.toList();
  }

  ComponentContext? _ctx;

  @override
  void onAttach(ComponentContext ctx) {
    _ctx = ctx;
    for (var child in _children) {
      _ctx?.registerComponent(child);
    }
  }

  @override
  void onDetach(ComponentContext ctx) {
    for (var child in _children) {
      _ctx?.unregisterComponent(child);
    }
    _ctx = null;
  }
}
