import 'package:flutter/material.dart';
import 'package:vector_canvas/vector_canvas.dart';
import 'package:ramanujan/ramanujan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vector Canvas',
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
  late VectorCurve polyline;
  late VectorCurve smooth;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    polyline = VectorCurve([
      for (final i in Iterable.generate(count))
        LineSegment(P(i.isEven ? x1 : x2, startY + i * gapY),
            P(i.isOdd ? x1 : x2, startY + (i + 1) * gapY)),
    ]);
    smooth = polyline.expandWithControls(catmullRomSmoother(),
        controlStart: P(0, startY + 100));
    final smooth1 = polyline.expandWithControls(cardinalSmoother(tension: 2));

    return Scaffold(
      body: Center(
        child: GameWidget(
            component: LayerComponent([
          PathComponent(polyline.segments),
        ])),
        /*child: VectorCanvas(layers: [
          VectorLayer([polyline],
              paint: Paint()
                ..color = Colors.black
                ..style = PaintingStyle.stroke
                ..strokeWidth = 5),
          VectorLayer([smooth],
              paint: Paint()
                ..color = Colors.red
                ..style = PaintingStyle.stroke
                ..strokeWidth = 3),
          VectorLayer([smooth1],
              paint: Paint()
                ..color = Colors.green
                ..style = PaintingStyle.stroke
                ..strokeWidth = 3),*/
      ),
    );
  }

  static double x1 = 100;
  static double x2 = 400;
  static double startY = 200;
  static double gapY = 100;
  static int count = 3;
}
