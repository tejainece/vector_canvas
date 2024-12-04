import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';
import 'package:vector_canvas/src/components/points_component.dart';
import 'package:vector_canvas/src/components/vertices_component.dart';
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

  @override
  Widget build(BuildContext context) {
    final quadratic = VectorCurve(
        [QuadraticSegment(p1: P(100, 100), p2: P(200, 100), c: P(150, 50))]);
    final cubic = VectorCurve([
      CubicSegment(
          p1: P(100, 300), p2: P(200, 400), c1: P(200, 300), c2: P(100, 400))
    ]);
    final quadraticPoint = quadratic.segments[0].lerp(t).o;
    final cubicPoint = cubic.segments[0].lerp(t).o;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: 200),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Slider(
                  label: t.toStringAsFixed(3),
                  value: t,
                  onChanged: (value) {
                    setState(() {
                      t = value;
                    });
                  },
                  autofocus: true,
                  min: 0,
                  max: 1,
                ),
              ),
              Text(t.toStringAsFixed(3)),
            ],
          ),
          Expanded(
            child: Container(
              color: Colors.brown,
              child: GameWidget(color: Colors.white, components: [
                [
                  PathComponent(quadratic, strokeWidth: 5),
                  PathComponent(cubic, strokeWidth: 5),
                ],
                [
                  PointsComponent([quadraticPoint],
                      vertexPainter: CircularVertexPainter(12,
                          fill: Paint()..color = Colors.blue)),
                  PointsComponent([cubicPoint],
                      vertexPainter: CircularVertexPainter(12,
                          fill: Paint()..color = Colors.blue)),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }

  double t = 0.1;
}
