import 'package:flutter/material.dart';
import 'package:vector_canvas/vector_canvas.dart';
import 'package:vector_path/vector_path.dart';

import '../../_ui/controls.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'lerp',
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
    final quadratic = VectorCurve(
        [QuadraticSegment(p1: P(100, 100), p2: P(200, 100), c: P(150, 50))]);
    final quadraticPoint = quadratic.segments[0].lerp(t);

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
            child: GameWidget(
                color: Colors.white,
                component: LayerComponent([
                  PathComponent(quadratic.segments,
                      stroke: Stroke(strokeWidth: 5)),
                  PointsComponent([quadraticPoint],
                      vertexPainter: CircularVertexPainter(12,
                          fill: Fill(color: Colors.blue))),
                ])),
          ),
        ],
      ),
    );
  }
}
