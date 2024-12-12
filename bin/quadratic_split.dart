import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';
import 'package:vector_canvas/vector_canvas.dart';
import 'package:vector_path/vector_path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quadratic Split',
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
    final quadratic = VectorCurve(
        [QuadraticSegment(p1: P(100, 100), p2: P(200, 100), c: P(150, 50))]);
    final cubic = VectorCurve([
      CubicSegment(
          p1: P(100, 300), p2: P(200, 400), c1: P(200, 300), c2: P(100, 400))
    ]);
    final quadraticSplit = quadratic.splitSegments(3);
    final cubicSplit = cubic.splitSegments(3);

    return Scaffold(
      body: Center(
        child: GameWidget(color: Colors.white, components: [
          [
            PathComponent(quadratic, strokeWidth: 5),
            PathComponent(quadraticSplit, strokeWidth: 3, color: Colors.red),
            PathComponent(cubic, strokeWidth: 5),
            PathComponent(cubicSplit, strokeWidth: 3, color: Colors.red),
          ],
          [
            VerticesComponent(
              quadratic,
              vertexPainter:
                  CircularVertexPainter(12, fill: Paint()..color = Colors.blue),
            ),
            VerticesComponent(quadraticSplit,
                vertexPainter: CircularVertexPainter(10,
                    fill: Paint()..color = Colors.red)),
            VerticesComponent(cubic,
                vertexPainter: CircularVertexPainter(12,
                    fill: Paint()..color = Colors.blue)),
            VerticesComponent(cubicSplit,
                vertexPainter: CircularVertexPainter(10,
                    fill: Paint()..color = Colors.red)),
          ],
        ]),
      ),
    );
  }
}
