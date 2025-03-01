import 'package:flutter/material.dart';
import 'package:vector_canvas/vector_canvas.dart';
import 'package:ramanujan/ramanujan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
    final cubic = CubicSegment(
        p1: P(100, 300), p2: P(200, 400), c1: P(200, 300), c2: P(100, 400));
    final bbox = cubic.boundingBox;

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
                  label: t.toStringAsFixed(3),
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
            ],
          ),
          Expanded(
            child: GameWidget(
              color: Colors.white,
              component: LayerComponent([
                SegmentsComponent([cubic], stroke: Stroke(strokeWidth: 5)),
                RectangleComponent(bbox,
                    fill: null,
                    stroke: Stroke(color: Colors.blue, strokeWidth: 3)),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  double t = 0.1;
}
