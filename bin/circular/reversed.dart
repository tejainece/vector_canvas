import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_canvas/vector_canvas.dart';
import 'package:vector_path/vector_path.dart';

import '../_ui/controls.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circle.reversed',
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

  double startAngle = 0.toRadian;
  double endAngle = 90.toRadian;
  double radius = 100;

  @override
  Widget build(BuildContext context) {
    final center = P(150, 150);
    final arc = CircularArcSegment(P.onCircle(startAngle, radius, center),
        P.onCircle(endAngle, radius, center), radius,
        largeArc: (endAngle - startAngle).abs() > pi,
        clockwise: startAngle < endAngle);
    final reversed = arc.reversed();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              slider('StartAngle', startAngle, 0, 2 * pi,
                  (v) => setState(() => startAngle = v)),
              slider('EndAngle', endAngle, 0, 2 * pi,
                  (v) => setState(() => endAngle = v)),
              slider(
                  'Radius', radius, 0, 200, (v) => setState(() => radius = v)),
            ],
          ),
          Expanded(
            child: GameWidget(
                color: Colors.white,
                component: LayerComponent([
                  SegmentsComponent([arc], stroke: Stroke(strokeWidth: 7)),
                  SegmentsComponent([reversed],
                      stroke: Stroke(strokeWidth: 3, color: Colors.blue)),
                ])),
          ),
        ],
      ),
    );
  }
}
