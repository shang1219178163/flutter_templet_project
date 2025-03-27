import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_dash_line.dart';
import 'package:tuple/tuple.dart';

class DashLineDemo extends StatefulWidget {
  DashLineDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _DashLineDemoState createState() => _DashLineDemoState();
}

class _DashLineDemoState extends State<DashLineDemo> {
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
      body: buildBody(),
    );
  }

  buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          NDashLine(
            color: Colors.blue,
          ),
          SizedBox(
            height: 10,
          ),
          buildDashLineOfMutiColor(),
          SizedBox(
            height: 300,
            child: buildDashLineOfMutiColor(
              direction: Axis.vertical,
            ),
          ),
        ],
      ),
    );
  }

  buildDashLineOfMutiColor({direction = Axis.horizontal}) {
    return NDashLineOfMutiColor(
      direction: direction,
      height: 2,
      steps: <Tuple2<double, Color>>[
        Tuple2(8, Colors.transparent),
        Tuple2(8, Colors.red),
        Tuple2(8, Colors.transparent),
        Tuple2(8, Colors.yellow),
        Tuple2(8, Colors.transparent),
        Tuple2(8, Colors.blue),
        Tuple2(8, Colors.transparent),
        Tuple2(8, Colors.green),
      ],
    );
  }
}
