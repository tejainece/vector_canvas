import 'dart:collection';

export 'point_control.dart';

class Controls<T> {
  final Set<T> _selected = {};

  final void Function()? _onChanged;

  final _onChangedListeners = <Object, void Function()>{};

  Controls({void Function()? onChanged}) : _onChanged = onChanged;

  int? _pointer;

  int? get pointer => _pointer;

  void append(int pointer, T id) {
    _pointer = pointer;
    if (_selected.contains(id)) return;
    _selected.add(id);
    _emitChanged();
  }

  void select(int pointer, T id, {bool append = false}) {
    _pointer = pointer;
    bool changed = false;
    if (!append) {
      if (_selected.isEmpty) {
        _selected.add(id);
        changed = true;
      } else if (!_selected.contains(id)) {
        _selected.clear();
        _selected.add(id);
        changed = true;
      } else {
        if (_selected.length > 1) {
          _selected.clear();
          _selected.add(id);
          changed = true;
        }
      }
    } else {
      if (!_selected.contains(id)) {
        _selected.add(id);
        changed = true;
      }
    }
    if (changed) {
      _emitChanged();
    }
  }

  void deselect(int pointer, T id, {bool append = false}) {
    _pointer = pointer;
    bool changed = false;
    if (!append) {
      changed = changed || _selected.isNotEmpty;
      _selected.clear();
    } else {
      changed = changed || _selected.remove(id);
    }
    if (changed) {
      _emitChanged();
    }
  }

  void toggle(int pointer, T id, {bool append = false}) {
    _pointer = pointer;
    if (_selected.contains(id)) {
      deselect(pointer, id, append: append);
    } else {
      select(pointer, id, append: append);
    }
  }

  void clear() {
    if (_selected.isEmpty) return;
    _selected.clear();
    _emitChanged();
  }

  bool isSelected(T id) => _selected.contains(id);

  late final UnmodifiableSetView<T> selected = UnmodifiableSetView(_selected);

  bool get isEmpty => _selected.isEmpty;

  bool get isNotEmpty => _selected.isNotEmpty;

  void _emitChanged() {
    _onChanged?.call();
    for (var f in _onChangedListeners.values) {
      f.call();
    }
  }

  void addChangedListener(Object key, void Function() f) {
    _onChangedListeners[key] = f;
  }

  void removeChangedListener(Object key) {
    _onChangedListeners.remove(key);
  }
}

class Proxy<T> {
  final T Function() getter;
  final void Function(T value) setter;

  Proxy(this.getter, this.setter);

  T get value => getter();

  set value(T value) => setter(value);
}
