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

  P center = P(0, 0);
  double radius = 100;
  double startAngle = 0;
  double endAngle = 270;
  bool largeArc = true;

  double t = 0.5;

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
    final arcA = CircularArcSegment(
        P.onCircle(startAngle.toRadian, radius, center),
        P.onCircle(endAngle.toRadian, radius, center),
        radius,
        clockwise: !clockwise,
        largeArc: largeArc);
    final arcB = CircularArcSegment(
        P.onCircle(startAngle.toRadian, radius, center),
        P.onCircle(endAngle.toRadian, radius, center),
        radius,
        clockwise: clockwise,
        largeArc: !largeArc);
    final arcC = CircularArcSegment(
        P.onCircle(startAngle.toRadian, radius, center),
        P.onCircle(endAngle.toRadian, radius, center),
        radius,
        clockwise: !clockwise,
        largeArc: !largeArc);
    final pointBf = arc.lerp(t);
    final (arc1, arc2) = arc.bifurcateAtInterval(t);

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
                    intSlider('r', radius, 10, 200,
                        (value) => setState(() => radius = value)),
                    slider('start', startAngle, 0, 360,
                        (value) => setState(() => startAngle = value)),
                    slider('end', endAngle, 0, 360,
                        (value) => setState(() => endAngle = value)),
                    slider('t', t, 0, 1, (value) => setState(() => t = value)),
                  ],
                ),
              )),
          Expanded(
            child: GameWidget(
              color: Colors.white,
              transformer: yUp
                  ? centeredYUpWith(translate: viewport.center)
                  : centeredYDownWith(translate: viewport.center),
              component: LayerComponent([
                AxisComponent(viewport, yUp: yUp),
                SegmentsComponent([arc], stroke: Stroke(strokeWidth: 7)),
                SegmentsComponent([arcA]),
                SegmentsComponent([arcB], stroke: Stroke(color: Colors.orange)),
                SegmentsComponent([arcC], stroke: Stroke(color: Colors.blue)),
                SegmentsComponent([arc1],
                    stroke: Stroke(strokeWidth: 3, color: Colors.blue)),
                SegmentsComponent([arc2],
                    stroke: Stroke(strokeWidth: 3, color: Colors.orange)),
                PointsComponent([pointBf],
                    vertexPainter: CircularVertexPainter(7)),
                PointControlComponent(center,
                    selected: controls.isSelected(PointId.center),
                    controlData: ControlData(controls, PointId.center)),
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
