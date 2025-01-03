import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';
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
      title: 'Quadratic.boundingBox',
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

  double t = 0.1;

  @override
  Widget build(BuildContext context) {
    final quadratic =
        QuadraticSegment(p1: P(100, 100), p2: P(200, 100), c: P(150, 50));
    final bbox = quadratic.boundingBox;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              slider('T', t, 0, 1, (v) => setState(() => t = v)),
            ],
          ),
          Expanded(
            child: GameWidget(color: Colors.white, components: [
              [
                SegmentsComponent([quadratic], stroke: Stroke(strokeWidth: 5)),
              ],
              [
                RectangleComponent(bbox,
                    fill: null,
                    stroke: Stroke(color: Colors.blue, strokeWidth: 3)),
              ],
            ]),
          ),
        ],
      ),
    );
  }
}
