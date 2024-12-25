import 'dart:ui';

extension OffsetExt on Offset {
  bool equals(Offset other, {double epsilon = 1e-3}) {
    final diffX = (dx - other.dx).abs();
    if (diffX > epsilon) return false;
    final diffY = (dy - other.dy).abs();
    return diffY <= epsilon;
  }
}

extension OffsetIterableExt on Iterable<Offset> {
  bool isSame(Iterable<Offset> other, {double epsilon = 1e-3}) {
    final it1 = iterator;
    final it2 = other.iterator;

    while (true) {
      if (!it1.moveNext()) return !it2.moveNext();
      if (!it2.moveNext()) return false;

      if (!it1.current.equals(it2.current, epsilon: epsilon)) return false;
    }
  }
}
