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
      title: 'Ellipse.center',
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
    final ellipse = Ellipse(radii, center: center, rotation: rotation);
    final arc = ArcSegment(
      ellipse.pointAtAngle(startAngle),
      ellipse.pointAtAngle(endAngle),
      radii,
      largeArc: (startAngle - endAngle).abs() > pi || startAngle == endAngle,
      clockwise: startAngle < endAngle,
      rotation: rotation,
    );
    /*print(arc.p1);
    print(ellipse.unitCircleTransform);
    print(ellipse.inverseUnitCircleTransform);*/

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
              slider('centerX', center.x, -400, 400,
                  (v) => setState(() => center = P(v, center.y))),
              slider('centerY', center.y, -400, 400,
                  (v) => setState(() => center = P(center.x, v))),
              slider('radiiX', radii.x, 0, 400,
                  (v) => setState(() => radii = P(v, radii.y))),
              slider('radiiY', radii.y, -400, 400,
                  (v) => setState(() => radii = P(radii.x, v))),
            ],
          ),
          Expanded(
            child: GameWidget(
              color: Colors.white,
              transformer: originToCenterWith(),
              components: [
                [
                  SegmentsComponent([arc], stroke: Stroke(strokeWidth: 7)),
                ],
                [
                  PointsComponent([center.o],
                      vertexPainter: CircularVertexPainter(10)),
                  PointsComponent([arc.center.o],
                      vertexPainter: CircularVertexPainter(5,
                          fill: Fill(color: Colors.orange))),
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
