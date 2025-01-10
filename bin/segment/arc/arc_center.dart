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
      title: 'Ellipse.center',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
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
      clockwise: startAngle > endAngle,
      rotation: rotation,
    );

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: SingleChildScrollView(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  slider('StartAngle', startAngle, 0, 2 * pi,
                      (v) => setState(() => startAngle = v)),
                  slider('EndAngle', endAngle, 0, 2 * pi,
                      (v) => setState(() => endAngle = v)),
                  slider('Rotation', rotation, 0, 2 * pi,
                      (v) => setState(() => rotation = v)),
                  slider('radiiX', radii.x, 0, 400,
                      (v) => setState(() => radii = P(v, radii.y))),
                  slider('radiiY', radii.y, -400, 400,
                      (v) => setState(() => radii = P(radii.x, v))),
                ],
              ),
            ),
          ),
          Expanded(
            child: GameWidget(
              color: Colors.white,
              transformer: yUp
                  ? centeredYUpWith(translate: viewport.center)
                  : centeredYDownWith(translate: viewport.center),
              component: LayerComponent([
                AxisComponent(viewport, yUp: yUp),
                SegmentsComponent([arc], stroke: Stroke(strokeWidth: 7)),
                PointsComponent([center],
                    vertexPainter: CircularVertexPainter(10)),
                PointControlComponent(center,
                    selected: controls.isSelected(PointId.center),
                    controlData: ControlData(controls, PointId.center)),
                PointsComponent([arc.center],
                    vertexPainter: CircularVertexPainter(5,
                        fill: Fill(color: Colors.orange))),
              ]),
              onResize: (size) {
                setState(() {
                  viewport =
                      R.centerAt(viewport.center, size.width, size.height);
                });
              },
              onPan: _onPan,
            ),
          ),
        ],
      ),
    );
  }

  void _onPan(PanData data) {
    P delta = -P(data.offsetDelta.dx, (yUp ? -1 : 1) * data.offsetDelta.dy);
    if (controls.isNotEmpty) {
      for (var id in PointId.values) {
        if (!controls.isSelected(id)) continue;
        final point = _map[id]!;
        point.value = point.value - delta;
      }
    } else {
      viewport = viewport.shift(delta);
      setState(() {});
    }
    setState(() {});
  }

  bool yUp = true;
  R viewport = R(-200, -200, 400, 400);

  late final controls = Controls<PointId>(onChanged: () {
    setState(() {});
  });

  late final _map = <PointId, Proxy<P>>{
    PointId.center: Proxy(() => center, (v) => center = v),
  };
}

enum PointId {
  center,
}
