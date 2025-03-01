import 'package:flutter/material.dart';
import 'package:vector_canvas/vector_canvas.dart';
import 'package:ramanujan/ramanujan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quadratic Bifurcate',
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

  @override
  Widget build(BuildContext context) {
    final cubic = VectorCurve([
      CubicSegment(
          p1: P(100, 300), p2: P(200, 400), c1: P(200, 300), c2: P(100, 400))
    ]);
    final cubicSplit = cubic.bifurcateSegments(t);

    return Scaffold(
      body: Center(
        child: GameWidget(
            color: Colors.white,
            component: LayerComponent([
              PathComponent(cubic.segments, stroke: Stroke(strokeWidth: 5)),
              PathComponent(cubicSplit.segments,
                  stroke: Stroke(strokeWidth: 3, color: Colors.red)),
              VerticesComponent(cubic.segments,
                  vertexPainter: CircularVertexPainter(12,
                      fill: Fill(color: Colors.blue))),
              VerticesComponent(cubicSplit.segments,
                  vertexPainter:
                      CircularVertexPainter(10, fill: Fill(color: Colors.red))),
            ])),
      ),
    );
  }

  static const t = 0.1;
}
