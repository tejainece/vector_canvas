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
      title: 'Circle.boundingBox',
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

  double radius = 100;
  double startAngle = 0;
  double endAngle = 270;
  bool largeArc = true;
  P center = P(0, 0);

  @override
  Widget build(BuildContext context) {
    final clockwise = startAngle > endAngle;
    final largeArc =
        Radian((endAngle - startAngle).abs().toRadian) > Radian(pi);
    final arc = CircularArcSegment(
        P.onCircle(startAngle.toRadian, radius, center),
        P.onCircle(endAngle.toRadian, radius, center),
        radius,
        clockwise: clockwise,
        largeArc: largeArc);
    final bbox = arc.boundingBox;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              intSlider('r', radius, 10, 200,
                  (value) => setState(() => radius = value)),
              slider('start', startAngle, 0, 360,
                  (value) => setState(() => startAngle = value)),
              slider('end', endAngle, 0, 360,
                  (value) => setState(() => endAngle = value)),
              slider('centerX', center.x, -400, 400,
                  (v) => setState(() => center = P(v, center.y))),
              slider('centerY', center.y, -400, 400,
                  (v) => setState(() => center = P(center.x, v))),
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
                  SegmentsComponent([arc], stroke: Stroke(strokeWidth: 3)),
                ],
                [
                  RectangleComponent(bbox,
                      fill: null,
                      stroke: Stroke(color: Colors.blue, strokeWidth: 3)),
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
