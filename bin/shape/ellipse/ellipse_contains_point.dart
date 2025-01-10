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
          SizedBox(
            width: double.infinity,
            height: 50,
            child: SingleChildScrollView(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
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
                EllipseComponent(ellipse),
                PointControlComponent(point,
                    selected: controls.isSelected(PointId.point),
                    controlData: ControlData(controls, PointId.point)),
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
          Row(
            children: [
              Checkbox(value: has, onChanged: null, shape: CircleBorder()),
              Text('Contains',
                  style: TextStyle(color: has ? Colors.green : Colors.red)),
            ],
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
    PointId.point: Proxy(() => point, (v) => point = v),
    PointId.center: Proxy(() => center, (v) => center = v),
  };
}

enum PointId {
  point,
  center,
}
