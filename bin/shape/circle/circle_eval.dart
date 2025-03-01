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
      title: 'Circle.eval',
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

  var center = P(0, 0);
  double radius = 100;

  double x = 0;
  double y = 0;

  @override
  Widget build(BuildContext context) {
    final circle = Circle(radius: radius, center: center);
    final yEval = circle.evalY(x).map((y) => P(x, y));
    final xEval = circle.evalX(y).map((x) => P(x, y));

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              slider('Center.x', center.x, -400, 400,
                  (value) => setState(() => center = P(value, center.y))),
              slider('Center.y', center.y, -400, 400,
                  (value) => setState(() => center = P(center.x, value))),
              slider('Radius', radius, 0, 400,
                  (value) => setState(() => radius = value)),
            ],
          ),
          Expanded(
            child: GameWidget(
              color: Colors.white,
              transformer: yUp
                  ? centeredYUpWith(translate: viewport.center)
                  : centeredYDownWith(translate: viewport.center),
              component: LayerComponent([
                AxisComponent(viewport, yUp: yUp),
                CircleComponent(circle),
                centerControl,
                xControl,
                yControl,
                PointsComponent(xEval,
                    vertexPainter: CircularVertexPainter(5,
                        fill: Fill(color: Colors.purple))),
                PointsComponent(yEval,
                    vertexPainter: CircularVertexPainter(5,
                        fill: Fill(color: Colors.red))),
              ]),
              onResize: (size) {
                setState(() {
                  viewport =
                      R.centerAt(viewport.center, size.width, size.height);
                });
              },
              onPan: _onPan,
              onTap: _onTap,
            ),
          ),
        ],
      ),
    );
  }

  late final centerControl = PointControlComponent(center,
      selected: controls.isSelected(PointId.center),
      controlData: ControlData(controls, PointId.center));
  late final xControl = PointControlComponent(P(x, 0),
      selected: controls.isSelected(PointId.x),
      controlData: ControlData(controls, PointId.x));
  late final yControl = PointControlComponent(P(0, y),
      selected: controls.isSelected(PointId.y),
      controlData: ControlData(controls, PointId.y));

  void _onTap(ClickEvent data) {
    if (controls.pointer == data.pointer) return;
    controls.clear();
  }

  void _onPan(PanData data) {
    final offset = P(data.offsetDelta.dx, -data.offsetDelta.dy);
    if (controls.isNotEmpty) {
      for (var id in PointId.values) {
        if (!controls.isSelected(id)) continue;
        final point = _map[id]!;
        point.value = point.value + offset;
      }
    } else {
      viewport = viewport.shift(-offset);
    }
    setState(() {});
  }

  bool yUp = true;
  R viewport = R(-200, -200, 400, 400);

  late final controls = Controls(onChanged: () => setState(() {}));

  late final _map = <PointId, Proxy<P>>{
    PointId.center: Proxy(() => center, (v) {
      center = v;
      centerControl.set(
          point: center, selected: controls.isSelected(PointId.center));
    }),
    PointId.x: Proxy(() => P(x, 0), (v) {
      x = v.x;
      xControl.set(point: P(x, 0), selected: controls.isSelected(PointId.x));
    }),
    PointId.y: Proxy(() => P(0, y), (v) {
      y = v.y;
      yControl.set(point: P(0, y), selected: controls.isSelected(PointId.y));
    }),
  };
}

enum PointId { center, x, y }
