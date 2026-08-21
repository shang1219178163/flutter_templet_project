import 'package:flutter/material.dart';
import 'package:flutter_isolate/flutter_isolate.dart';

class FlutterIsolateDemo extends StatefulWidget {
  FlutterIsolateDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _FlutterIsolateDemoState createState() => _FlutterIsolateDemoState();
}

class _FlutterIsolateDemoState extends State<FlutterIsolateDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: [
            'done',
          ]
              .map((e) => TextButton(
                    child: Text(
                      e,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => debugPrint(e),
                  ))
              .toList(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                child: const Text('01 - 简单的执行顶层函数'),
                onPressed: () {
                  FlutterIsolate.spawn(someFunction, "hello world");
                },
              ),
              ElevatedButton(
                child: const Text('02 - Compute函数'),
                onPressed: () async {
                  var res = await flutterCompute(expensiveWork, 123);
                  debugPrint(res.toString());
                },
              ),
            ],
          ),
        ));
  }

  @pragma('vm:entry-point')
  void someFunction(String arg) {
    debugPrint("Running in an isolate with argument : $arg");
  }

  @pragma('vm:entry-point')
  Future<int> expensiveWork(int arg) async {
    var result = arg + 100;
    return result;
  }
}
