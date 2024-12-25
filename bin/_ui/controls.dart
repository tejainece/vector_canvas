import 'package:flutter/material.dart';

Widget slider(String label, double value, double min, double max,
    ValueSetter<double> onChanged) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text('$label: '),
      Container(
        constraints: BoxConstraints(maxWidth: 200),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Slider(
          value: value,
          onChanged: onChanged,
          min: min,
          max: max,
        ),
      ),
      Text(value.toStringAsFixed(2).toString()),
    ],
  );
}

Widget intSlider(String label, double value, double min, double max,
    ValueSetter<double> onChanged) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text('$label: '),
      Container(
        constraints: BoxConstraints(maxWidth: 200),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Slider(
          value: value,
          onChanged: onChanged,
          min: min,
          max: max,
        ),
      ),
      Text(value.toInt().toString()),
    ],
  );
}

Widget checkbox(String label, bool value, ValueSetter<bool> onChanged) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text('$label: '),
      Checkbox(value: value, onChanged: (v) => onChanged(v!)),
    ],
  );
}
