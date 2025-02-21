import 'package:flutter/material.dart';
import 'package:vector_canvas/vector_canvas.dart';
import 'package:vector_path/vector_path.dart';

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

  P c1 = P(0, 0);
  double r1 = 100;
  P c2 = P(0, 150);
  double r2 = 100;

  P get rp1 => c1 + P(r1, 0);

  P get rp2 => c2 + P(r2, 0);

  @override
  Widget build(BuildContext context) {
    _update();
    final circle1 = Circle(center: c1, radius: r1);
    final circle2 = Circle(center: c2, radius: r2);
    final intersects = circle1.intersectCircle(circle2).where((e) => !e.isNaN);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [],
          ),
          Expanded(
            child: GameWidget(
              color: Colors.white,
              transformer: yUp
                  ? centeredYUpWith(translate: viewport.center)
                  : centeredYDownWith(translate: viewport.center),
              component: LayerComponent([
                AxisComponent(viewport, yUp: yUp),
                CircleComponent(circle1),
                CircleComponent(circle2),
                PointsComponent(intersects,
                    vertexPainter: CircularVertexPainter(5,
                        fill: Fill(color: Colors.red))),
                c1Control,
                c2Control,
                rp1Control,
                rp2Control,
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

  late final c1Control = PointControlComponent(c1,
      selected: controls.isSelected(PointId.c1),
      controlData: ControlData(controls, PointId.c1),
      fill: null,
      stroke: Stroke(color: Colors.blue, strokeWidth: 2));
  late final c2Control = PointControlComponent(c2,
      selected: controls.isSelected(PointId.c2),
      controlData: ControlData(controls, PointId.c2),
      fill: null,
      stroke: Stroke(color: Colors.blue, strokeWidth: 2));
  late final rp1Control = PointControlComponent(rp1,
      selected: controls.isSelected(PointId.rp1),
      controlData: ControlData(controls, PointId.rp1),
      fill: null,
      stroke: Stroke(color: Colors.blue, strokeWidth: 2));
  late final rp2Control = PointControlComponent(rp2,
      selected: controls.isSelected(PointId.rp2),
      controlData: ControlData(controls, PointId.rp2),
      fill: null,
      stroke: Stroke(color: Colors.blue, strokeWidth: 2));

  void _update() {
    c1Control.set(point: c1, selected: controls.isSelected(PointId.c1));
    c2Control.set(point: c2, selected: controls.isSelected(PointId.c2));
    rp1Control.set(point: rp1, selected: controls.isSelected(PointId.rp1));
    rp2Control.set(point: rp2, selected: controls.isSelected(PointId.rp2));
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
    PointId.c1: Proxy(() => c1, (v) => c1 = v),
    PointId.rp1: Proxy(() => c1 + P(r1, 0), (v) => r1 = v.x - c1.x),
    PointId.c2: Proxy(() => c2, (v) => c2 = v),
    PointId.rp2: Proxy(() => c2 + P(r2, 0), (v) => r2 = v.x - c2.x),
  };
}

enum PointId { c1, rp1, c2, rp2 }
