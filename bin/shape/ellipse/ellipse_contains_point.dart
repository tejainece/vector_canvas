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
      title: 'Ellipse.containsPoint',
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

  late final controls = Controls<PointId>(onChanged: () {
    setState(() {});
  });

  double rotation = 0;
  var center = P(0, 0);
  var radii = P(100, 80);

  var point = P(50, 50);

  @override
  Widget build(BuildContext context) {
    final ellipse = Ellipse(radii, center: center, rotation: rotation);
    bool has = ellipse.containsPoint(point);

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
              transformer: originToCenterWith(translate: viewport.center),
              component: LayerComponent([
                LayerComponent([
                  AxisComponent(viewport),
                  // HAxisGridComponent(viewport, gap: 100),
                  // VAxisGridComponent(viewport, gap: 100),
                  /*HAxisTickComponent(viewport, gap: 10, specialEvery: 5),
                  VAxisTickComponent(viewport, gap: 10, specialEvery: 5),
                  HAxisTickLabelComponent(viewport,
                      gap: 100, atY: -5, flip: true),
                  VAxisTickLabelComponent(viewport,
                      gap: 100, atX: 10, flip: true),*/
                ]),
                LayerComponent([
                  EllipseComponent(ellipse),
                ]),
                LayerComponent([
                  PointControlComponent(point,
                      selected: controls.isSelected(PointId.point),
                      controlData: ControlData(controls, PointId.point)),
                  PointControlComponent(center,
                      selected: controls.isSelected(PointId.center),
                      controlData: ControlData(controls, PointId.center)),
                ]),
              ]),
              onResize: (size) {
                setState(() {
                  viewport = R(-size.width / 2, -size.height / 2, size.width,
                      size.height);
                });
              },
              onPan: _onPan,
            ),
          ),
          Row(
            children: [
              Checkbox(value: has, onChanged: null),
            ],
          ),
        ],
      ),
    );
  }

  void _onPan(PanData data) {
    if (controls.isNotEmpty) {
      final offset = P(data.offsetDelta.dx, -data.offsetDelta.dy);
      for (var id in PointId.values) {
        if (!controls.isSelected(id)) continue;
        final point = _map[id]!;
        point.value = point.value + offset;
      }
    } else {
      // viewportOffset = viewportOffset - data.offsetDelta;
      viewport = viewport.shift(-P(data.offsetDelta.dx, data.offsetDelta.dy));
      setState(() {});
    }
    setState(() {});
  }

  Offset viewportOffset = Offset.zero;
  R viewport = R(-200, -200, 400, 400);

  late final _map = <PointId, Proxy<P>>{
    PointId.point: Proxy(() => point, (v) => point = v),
    PointId.center: Proxy(() => center, (v) => center = v),
  };
}

enum PointId {
  point,
  center,
}
