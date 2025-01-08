import 'package:flutter/material.dart';
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

  double t = 0.5;
  double angle = 0;

  @override
  Widget build(BuildContext context) {
    final placement = P(200, 200);
    final line = LineSegment.radial(angle.toRadian, 100, placement);
    final point = line.lerp(t);
    final cw = line.normalAt(point, length: 100, cw: true);
    final ccw = line.normalAt(point, length: 100, cw: false);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              slider('t', t, 0, 1, (v) => setState(() => t = v)),
              slider('θ', angle, 0, 360, (v) => setState(() => angle = v)),
            ],
          ),
          Expanded(
            child: GameWidget(
              color: Colors.white,
              component: LayerComponent([
                AxisComponent(viewport),
                SegmentsComponent([line], stroke: Stroke(strokeWidth: 5)),
                SegmentsComponent([cw],
                    stroke: Stroke(strokeWidth: 5, color: Colors.blue)),
                SegmentsComponent([ccw],
                    stroke: Stroke(strokeWidth: 5, color: Colors.orange)),
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
