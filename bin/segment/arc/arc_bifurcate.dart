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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elliptic Bifurcate',
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
  double t = 0.1;
  double t1 = 0.0;
  double t2 = 0.6;

  @override
  Widget build(BuildContext context) {
    final ellipse = Ellipse(radii, center: center, rotation: rotation);

    final largeArc = ellipse.arcLengthBetweenT(t1, t2, clockwise: t1 >= t2) >
        ellipse.perimeter / 2;
    final arc = ArcSegment(
      ellipse.lerp(t1),
      ellipse.lerp(t2),
      radii,
      clockwise: t1 >= t2,
      rotation: rotation,
      largeArc: largeArc,
    );
    final point = arc.lerp(t);
    final arcs = arc.bifurcateAtInterval(t);

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
                  slider('t', t, 0, 1, (value) => setState(() => t = value)),
                  slider('t1', t1, 0, 1, (value) => setState(() => t1 = value)),
                  slider('t2', t2, 0, 1, (value) => setState(() => t2 = value)),
                  slider('Theta', rotation, 0, 2 * pi,
                      (value) => setState(() => rotation = value)),
                  slider('Radii.x', radii.x, 0, 400,
                      (value) => setState(() => radii = P(value, radii.y))),
                  slider('Radii.y', radii.y, 0, 400,
                      (value) => setState(() => radii = P(radii.x, value))),
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
                PathComponent([arc], stroke: Stroke(strokeWidth: 5)),
                PathComponent(arcs.toList(),
                    stroke: Stroke(strokeWidth: 3, color: Colors.red)),
                VerticesComponent(
                  [arc],
                  vertexPainter:
                      CircularVertexPainter(12, fill: Fill(color: Colors.blue)),
                ),
                VerticesComponent(arcs.toList(),
                    vertexPainter: CircularVertexPainter(10,
                        fill: Fill(color: Colors.red))),
                PointsComponent([point],
                    vertexPainter: CircularVertexPainter(5,
                        fill: Fill(color: Colors.green))),
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
