import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:game_engine/game_engine.dart';

class TransformComponent implements Component {
  List<Component> _children;
  Float64List _matrix;

  TransformComponent(this._children, this._matrix);

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.transform(_matrix);
    for (var child in _children) {
      child.render(canvas);
    }
    canvas.restore();
  }

  bool _dirty = true;

  @override
  void tick(TickCtx ctx) {
    for (var child in _children) {
      child.tick(ctx);
    }
    if (!_dirty) return;
    ctx.shouldRender();
    _dirty = false;
  }

  void set({Iterable<Component>? children, Float64List? matrix}) {
    bool needsUpdate = false;
    if (children != null) {
      _children = children.toList();
      needsUpdate = true;
    }
    if (matrix != null) {
      _matrix = matrix;
      needsUpdate = true;
    }
    if (needsUpdate) {
      _dirty = true;
    }
  }

  @override
  void handlePointerEvent(PointerEvent event) {
    for (var child in _children) {
      child.handlePointerEvent(event);
    }
  }
}

class OriginToCenterComponent extends Component {
  List<Component> _children;
  Size _size;

  OriginToCenterComponent(this._children, this._size);

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(_size.width / 2, _size.height / 2);
    canvas.scale(1, -1);
    for (var child in _children) {
      child.render(canvas);
    }
    canvas.restore();
  }

  bool _dirty = true;

  @override
  void tick(TickCtx ctx) {
    for (var child in _children) {
      child.tick(ctx);
    }
    if (!_dirty) return;
    _dirty = false;
    ctx.shouldRender();
  }

  @override
  void handlePointerEvent(PointerEvent event) {
    for (var child in _children) {
      child.handlePointerEvent(event);
    }
  }

  void set({Iterable<Component>? children, Size? size}) {
    bool needsUpdate = false;
    if (children != null) {
      _children = children.toList();
      needsUpdate = true;
    }
    if (size != null) {
      if (size != _size) {
        _size = size;
        needsUpdate = true;
      }
    }
    if (needsUpdate) {
      _dirty = true;
    }
  }
}
