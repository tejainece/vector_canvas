import 'dart:math';

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
      title: 'Ellipse.lerp',
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

  double rotation = 0;
  var center = P(0, 0);
  var radii = P(100, 80);

  @override
  Widget build(BuildContext context) {
    final ellipse = Ellipse(radii, center: center, rotation: rotation);
    final xBounds = ellipse.xBounds();
    final yBounds = ellipse.yBounds();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              slider('Theta', rotation, 0, 2 * pi,
                  (value) => setState(() => rotation = value)),
              slider('Center.x', center.x, -400, 400,
                  (value) => setState(() => center = P(value, center.y))),
              slider('Center.y', center.y, -400, 400,
                  (value) => setState(() => center = P(center.x, value))),
              slider('Radii.x', radii.x, 0, 400,
                  (value) => setState(() => radii = P(value, radii.y))),
              slider('Radii.y', radii.y, 0, 400,
                  (value) => setState(() => radii = P(radii.x, value))),
            ],
          ),
          Expanded(
            child: GameWidget(
              color: Colors.white,
              transformer: centeredYUp,
              component: LayerComponent([
                AxisComponent(viewport),
                EllipseComponent(ellipse),
                LineComponent(
                    LineSegment.vertical(
                        viewport.top, viewport.bottom, xBounds.$1),
                    stroke: Stroke(color: Colors.purple)),
                LineComponent(
                    LineSegment.vertical(
                        viewport.top, viewport.bottom, xBounds.$2),
                    stroke: Stroke(color: Colors.purple)),
                LineComponent(
                    LineSegment.horizontal(
                        viewport.left, viewport.right, yBounds.$1),
                    stroke: Stroke(color: Colors.purple)),
                LineComponent(
                    LineSegment.horizontal(
                        viewport.left, viewport.right, yBounds.$2),
                    stroke: Stroke(color: Colors.purple)),
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
