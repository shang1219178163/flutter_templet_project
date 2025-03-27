import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/util/global_isolate.dart';

class GlobalIsolateDemo extends StatefulWidget {
  GlobalIsolateDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _GlobalIsolateDemoState createState() => _GlobalIsolateDemoState();
}

class _GlobalIsolateDemoState extends State<GlobalIsolateDemo> {
  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;
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
                  onPressed: () => test(),
                ))
            .toList(),
      ),
      body: Text(arguments.toString()),
    );
  }

  test() async {
    // await GlobalIsolate.init();
    var a = 10;

    final result = await GlobalIsolate.isolateDo(
        params: {"a": a},
        work: (Map<String, dynamic> params) async {
          sleep(Duration(seconds: 2));
          var a = params["a"];
          return {
            "result1": "1 - ${a++}",
            "result2": "2 - ${a++}",
            "result3": "3 - ${a++}",
          };
        });
    debugPrint("result: $result");
  }
}
