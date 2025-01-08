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

  late final controls = Controls(onChanged: () {
    setState(() {});
  });

  P l1p1 = P(-100, -100);
  P l1p2 = P(100, 100);
  P l2p1 = P(-100, 100);
  P l2p2 = P(100, -100);

  @override
  Widget build(BuildContext context) {
    final line1 = LineSegment(l1p1, l1p2);
    final circle = Circle(center: l2p1, radius: l2p1.distanceTo(l2p2));
    final intersects = line1.intersectCircle(circle);

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
              transformer: originToCenter,
              component: LayerComponent([
                AxisComponent(viewport),
                SegmentsComponent([line1], stroke: Stroke(strokeWidth: 5)),
                // TODO CircleComponent(),
                PointsComponent(intersects),
                PointControlComponent(l1p1,
                    selected: controls.isSelected(PointId.l1p1),
                    controlData: ControlData(controls, PointId.l1p1)),
                PointControlComponent(l1p2,
                    selected: controls.isSelected(PointId.l1p2),
                    controlData: ControlData(controls, PointId.l1p2)),
                PointControlComponent(l2p1,
                    selected: controls.isSelected(PointId.l2p1),
                    controlData: ControlData(controls, PointId.l2p1)),
                PointControlComponent(l2p2,
                    selected: controls.isSelected(PointId.l2p2),
                    controlData: ControlData(controls, PointId.l2p2)),
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
        ],
      ),
    );
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
      setState(() {});
    }
    setState(() {});
  }

  late final _map = <PointId, Proxy<P>>{
    PointId.l1p1: Proxy(() => l1p1, (v) => l1p1 = v),
    PointId.l1p2: Proxy(() => l1p2, (v) => l1p2 = v),
    PointId.l2p1: Proxy(() => l2p1, (v) => l2p1 = v),
    PointId.l2p2: Proxy(() => l2p2, (v) => l2p2 = v),
  };

  R viewport = R(-200, -200, 400, 400);
}

enum PointId { l1p1, l1p2, l2p1, l2p2 }
