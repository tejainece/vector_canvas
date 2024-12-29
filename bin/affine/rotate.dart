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

  P initial = P(-100, 0);
  double angle1 = 0.toRadian;

  @override
  Widget build(BuildContext context) {
    final affine1 = Affine2d.rotator(angle1);
    final point1 = initial.transform(affine1);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              slider('Angle', angle1, 0, 2 * pi,
                  (value) => setState(() => angle1 = value)),
            ],
          ),
          Expanded(
            child: GameWidget(
              color: Colors.white,
              transformer: originToCenter,
              components: [
                [
                  AxisComponent(viewport),
                ],
                [
                  SegmentsComponent([LineSegment(origin, initial)],
                      stroke: Stroke(strokeWidth: 3)),
                  SegmentsComponent([LineSegment(origin, point1)],
                      stroke: Stroke(color: Colors.red)),
                ],
              ],
              onResize: (size) {
                setState(() {
                  viewport = Rect.fromLTWH(-size.width / 2, -size.height / 2,
                      size.width, size.height);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Rect viewport = Rect.fromLTWH(-200, -200, 400, 400);
}
