import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';
import 'package:vector_canvas/src/components/axis_component.dart';
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

  double startAngle = 0.toRadian;
  double endAngle = 90.toRadian;
  P radii = P(100, 70);
  P center = P(0, 0);
  double rotation = 0.toRadian;

  @override
  Widget build(BuildContext context) {
    print(rotation);
    final ellipse = Ellipse(radii, center: center, rotation: rotation);
    final arc = ArcSegment(
      ellipse.pointAtAngle(startAngle),
      ellipse.pointAtAngle(endAngle),
      radii,
      largeArc: (startAngle - endAngle).abs() > pi,
      clockwise: startAngle > endAngle,
      rotation: rotation,
    );
    final reversed = arc.reversed();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              slider('StartAngle', startAngle, 0, 2 * pi,
                  (v) => setState(() => startAngle = v)),
              slider('EndAngle', endAngle, 0, 2 * pi,
                  (v) => setState(() => endAngle = v)),
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
                  SegmentsComponent([arc], stroke: Stroke(strokeWidth: 7)),
                  SegmentsComponent([reversed],
                      stroke: Stroke(strokeWidth: 3, color: Colors.blue)),
                  AxisComponent(viewport),
                ],
                [],
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
