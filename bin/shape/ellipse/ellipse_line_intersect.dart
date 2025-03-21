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
  var radii = P(100, 100);
  P lp1 = P(-100, -100);
  P lp2 = P(100, -100);// P(100, 100);

  @override
  Widget build(BuildContext context) {
    _update();
    final ellipse = Ellipse(radii, center: center, rotation: rotation);
    final line1 = LineSegment(lp1, lp2);
    final intersects = line1.standardForm
        .intersectEllipse(ellipse)
        .toList();
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
              transformer: yUp
                  ? centeredYUpWith(translate: viewport.center)
                  : centeredYDownWith(translate: viewport.center),
              component: LayerComponent([
                AxisComponent(viewport, yUp: yUp),
                EllipseComponent(ellipse),
                SegmentsComponent([line1], stroke: Stroke(strokeWidth: 5)),
                PointsComponent(intersects),
                lp1Control,
                lp2Control,
                centerControl,
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

  late final lp1Control = PointControlComponent(lp1,
      selected: controls.isSelected(PointId.lp1),
      controlData: ControlData(controls, PointId.lp1));
  late final lp2Control = PointControlComponent(lp2,
      selected: controls.isSelected(PointId.lp2),
      controlData: ControlData(controls, PointId.lp2));
  late final centerControl = PointControlComponent(center,
      selected: controls.isSelected(PointId.center),
      controlData: ControlData(controls, PointId.center));

  void _update() {
    lp1Control.set(point: lp1, selected: controls.isSelected(PointId.lp1));
    lp2Control.set(point: lp2, selected: controls.isSelected(PointId.lp2));
    centerControl.set(
        point: center, selected: controls.isSelected(PointId.center));
  }

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
    PointId.lp1: Proxy(() => lp1, (v) => lp1 = v),
    PointId.lp2: Proxy(() => lp2, (v) => lp2 = v),
    PointId.center: Proxy(() => center, (v) => center = v),
  };
}

enum PointId { lp1, lp2, center }
