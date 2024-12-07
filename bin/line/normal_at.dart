import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';
import 'package:vector_canvas/src/components/lines_component.dart';
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
              Text('t: '),
              Container(
                constraints: BoxConstraints(maxWidth: 200),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Slider(
                  value: t,
                  onChanged: (value) {
                    setState(() {
                      t = value;
                    });
                  },
                  autofocus: true,
                  min: 0,
                  max: 1,
                ),
              ),
              Text(t.toStringAsFixed(3)),
              Text('Angle: '),
              Container(
                constraints: BoxConstraints(maxWidth: 200),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Slider(
                  value: angle,
                  onChanged: (value) {
                    setState(() {
                      angle = value;
                    });
                  },
                  autofocus: true,
                  min: 0,
                  max: 360,
                ),
              ),
              Text(angle.toStringAsFixed(3)),
            ],
          ),
          Expanded(
            child: Container(
              color: Colors.brown,
              child: GameWidget(color: Colors.white, components: [
                [
                  LinesComponent([line], strokeWidth: 5),
                  LinesComponent([cw], strokeWidth: 5, color: Colors.blue),
                  LinesComponent([ccw], strokeWidth: 5, color: Colors.orange),
                ],
                [],
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
