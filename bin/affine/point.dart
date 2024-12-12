import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';
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

  P initial = P(100, 0);
  double angle1 = 30.toRadian;
  double angle2 = 15.toRadian;

  @override
  Widget build(BuildContext context) {
    final affine1 = Affine2d.rotator(angle1);
    final affine2 = affine1.rotate(angle2);
    final point1 = initial.transform(affine1);
    final point2 = initial.transform(affine2);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [],
          ),
          Expanded(
            child: GameWidget(color: Colors.white,
                transformer: originToCenter,
                components: [
              [
                SegmentsComponent([LineSegment(origin, initial)], strokeWidth: 3),
                SegmentsComponent([LineSegment(origin, point1)],
                    color: Colors.red),
                SegmentsComponent([LineSegment(origin, point2)],
                    color: Colors.blue),
              ],
            ]),
          ),
        ],
      ),
    );
  }
}
