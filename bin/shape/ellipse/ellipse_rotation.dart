import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_canvas/vector_canvas.dart';
import 'package:ramanujan/ramanujan.dart';

import '../../_ui/controls.dart';

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
    angles.map((a) => ellipse.pointAtAngle(a));
    final ellipse2 = Ellipse(radii, center: center, rotation: rotation);
    final points2 =
    angles.map((a) => ellipse2.pointAtAngle(a));

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
              transformer: centeredYUpWith(),
              component: LayerComponent([
                PointsComponent(points,
                    vertexPainter: CircularVertexPainter(10,
                        fill: Fill(color: Colors.blue))),
                PointsComponent(points2,
                    vertexPainter: CircularVertexPainter(5,
                        fill: Fill(color: Colors.red))),
              ]),
              onResize: (size) {
                setState(() {
                  viewport = R(-size.width / 2, -size.height / 2, size.width,
                      size.height);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  R viewport = R(-200, -200, 400, 400);
}
