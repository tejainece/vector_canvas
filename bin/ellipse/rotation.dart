
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
      title: 'Ellipse.rotation',
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

  P radii = P(100, 70);
  P center = P(0, 0);
  double rotation = 0.toRadian;

  @override
  Widget build(BuildContext context) {
    print(rotation);
    final ellipse = Ellipse(radii, center: center, rotation: 0);
    final angles = <double>[
      0,
      pi / 3,
      2 * pi / 3,
      pi,
      4 * pi / 3,
      5 * pi / 3,
    ];
    final points =
        angles.map((a) => ellipse.pointAtAngle(a)).map((p) => p.o).toList();
    final ellipse2 = Ellipse(radii, center: center, rotation: rotation);
    final points2 =
        angles.map((a) => ellipse2.pointAtAngle(a)).map((p) => p.o).toList();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              slider('Rotation', rotation, 0, 2 * pi,
                  (v) => setState(() => rotation = v)),
              // TODO
            ],
          ),
          Expanded(
            child: GameWidget(
              color: Colors.white,
              transformer: originToCenterWith(),
              components: [
                [
                  PointsComponent(points,
                      vertexPainter: CircularVertexPainter(10,
                          fill: Paint()..color = Colors.blue)),
                  PointsComponent(points2,
                      vertexPainter: CircularVertexPainter(5,
                          fill: Paint()..color = Colors.red)),
                ],
                [],
              ],
              onResize: (size) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    viewport = Rect.fromLTWH(-size.width / 2, -size.height / 2,
                        size.width, size.height);
                  });
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
