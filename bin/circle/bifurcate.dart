import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';
import 'package:vector_canvas/src/components/lines_component.dart';
import 'package:vector_canvas/src/components/points_component.dart';
import 'package:vector_canvas/src/components/vertices_component.dart';
import 'package:vector_path/vector_path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Line.normalAt',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  double radius = 100;
  double startAngle = 0;
  double endAngle = 270;
  bool largeArc = true;

  double t = 0.5;

  @override
  Widget build(BuildContext context) {
    final center = P(200, 200);
    final clockwise = startAngle < endAngle;
    final largeArc =
        Radian((endAngle - startAngle).abs().toRadian) > Radian(pi);
    final arc = CircularArcSegment(
        pointOnCircle(startAngle.toRadian, radius, center),
        pointOnCircle(endAngle.toRadian, radius, center),
        radius,
        clockwise: startAngle < endAngle,
        largeArc: largeArc);
    final arcA = CircularArcSegment(
        pointOnCircle(startAngle.toRadian, radius, center),
        pointOnCircle(endAngle.toRadian, radius, center),
        radius,
        clockwise: !clockwise,
        largeArc: largeArc);
    final arcB = CircularArcSegment(
        pointOnCircle(startAngle.toRadian, radius, center),
        pointOnCircle(endAngle.toRadian, radius, center),
        radius,
        clockwise: clockwise,
        largeArc: !largeArc);
    final arcC = CircularArcSegment(
        pointOnCircle(startAngle.toRadian, radius, center),
        pointOnCircle(endAngle.toRadian, radius, center),
        radius,
        clockwise: !clockwise,
        largeArc: !largeArc);
    final pointBf = arc.lerp(t);
    final (arc1, arc2) = arc.bifurcateAtInterval(t);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              intSlider('r', radius, 10, 200,
                  (value) => setState(() => radius = value)),
              slider('start', startAngle, 0, 360,
                  (value) => setState(() => startAngle = value)),
              slider('end', endAngle, 0, 360,
                  (value) => setState(() => endAngle = value)),
              slider('t', t, 0, 1, (value) => setState(() => t = value)),
            ],
          ),
          Expanded(
            child: Container(
              color: Colors.brown,
              child: GameWidget(color: Colors.white, components: [
                [
                  LinesComponent([arc], strokeWidth: 7),
                  LinesComponent([arcA], strokeWidth: 1),
                  LinesComponent([arcB], strokeWidth: 1, color: Colors.orange),
                  LinesComponent([arcC], strokeWidth: 1, color: Colors.blue),
                  LinesComponent([arc1], strokeWidth: 3, color: Colors.blue),
                  LinesComponent([arc2], strokeWidth: 3, color: Colors.orange),
                ],
                [
                  PointsComponent([pointBf.o],
                      vertexPainter: CircularVertexPainter(7)),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

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
