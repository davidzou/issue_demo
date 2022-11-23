import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    _counter++;
    /// This update is nice.
    // GradientNotifier.instance().colors = <Color>[Colors.primaries[_counter % Colors.primaries.length], Colors.red, Colors.yellow];

    /// TODO Question  Why state set incorrectly. Odd time not work.
    /// 这样设置是无法刷新的，但是每次刷新都是间隔的
    GradientNotifier.instance().setColor(0, Colors.primaries[_counter % Colors.primaries.length]);
    // GradientNotifier.instance().setColor(1, Colors.accents.reversed.toList()[_counter % Colors.primaries.length]);
  }

  void _setState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    GradientNotifier.instance().addListener(_setState);
  }

  @override
  void dispose() {
    GradientNotifier.instance().removeListener(_setState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: GradientNotifier.instance().colors,
        )),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text('${GradientNotifier.instance().colors[0].toString()}, ${GradientNotifier.instance().colors[1].toString()}'),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class GradientNotifier with ChangeNotifier {
  GradientNotifier._();

  static final GradientNotifier _instance = GradientNotifier._();

  factory GradientNotifier.instance() => _instance;

  /// Gradient Colors
  List<Color>? _colors;

  List<Color> get colors => _colors ?? <Color>[Colors.blue, Colors.white];

  set colors(List<Color> colors) {
    _colors = colors;
    notifyListeners();
  }

  setColor(int index, Color? color) {
    if (color == null) return;
    colors[index] = color;
    print("after $colors");
    List<Color> temp = colors.toList(growable: true);
    _colors = temp;
    notifyListeners();
  }
}
