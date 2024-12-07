import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';
import 'package:vector_canvas/src/components/angle_component.dart';
import 'package:vector_canvas/vector_canvas.dart';
import 'package:vector_path/vector_path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'lerp',
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

  @override
  Widget build(BuildContext context) {
    // print('${startAngle.toRadian} ${endAngle.toRadian}');
    final line1 =
        LineSegment.radial(startAngle.toRadian, 100, P(300, 300)).reversed();
    final line2 = LineSegment.radial(endAngle.toRadian, 100, P(300, 300));

    final polyLine = VectorCurve([line1, line2]);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: 200),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Slider(
                  label: startAngle.toStringAsFixed(3),
                  value: startAngle,
                  onChanged: (value) {
                    setState(() {
                      startAngle = value;
                    });
                  },
                  autofocus: true,
                  min: 0,
                  max: 360,
                ),
              ),
              Text(startAngle.toString()),
              SizedBox(width: 10),
              Container(
                constraints: BoxConstraints(maxWidth: 200),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Slider(
                  label: endAngle.toStringAsFixed(3),
                  value: endAngle,
                  onChanged: (value) {
                    setState(() {
                      endAngle = value;
                    });
                  },
                  autofocus: true,
                  min: 0,
                  max: 360,
                ),
              ),
              Text(endAngle.toString()),
              SizedBox(width: 10),
            ],
          ),
          Expanded(
            child: Container(
              color: Colors.brown,
              child: GameWidget(color: Colors.white, components: [
                [
                  PathComponent(polyLine, strokeWidth: 5),
                ],
                [
                  AngleComponent([line1, line2],
                      paint: Paint()..color = Colors.purple..shader),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }

  double startAngle = 0;
  double endAngle = 60;
}
