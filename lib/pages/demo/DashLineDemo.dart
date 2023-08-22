

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_dash_line.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:tuple/tuple.dart';

class DashLineDemo extends StatefulWidget {

  DashLineDemo({
    Key? key,
    this.title
  }) : super(key: key);

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
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => debugPrint(e),)
        ).toList(),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 10,),
          NDashLine(color: Colors.red,),
          SizedBox(height: 10,),
          NDashLine(color: Colors.blue,),
          SizedBox(height: 10,),
          NDashLineOfMutiColor(
            height: 2,
            steps: <Tuple2<double, Color>>[
              Tuple2(8, Colors.transparent),
              Tuple2(8, Colors.red),
              Tuple2(8, Colors.transparent),
              Tuple2(8, ColorExt.random),
              Tuple2(8, Colors.transparent),
              Tuple2(8, ColorExt.random),
              Tuple2(8, Colors.transparent),
              Tuple2(8, ColorExt.random),
              Tuple2(8, Colors.transparent),
              Tuple2(8, ColorExt.random),
              Tuple2(8, Colors.transparent),
              Tuple2(8, ColorExt.random),
            ],
          ),
          SizedBox(
            height: 200,
            child: NDashLineOfMutiColor(
              direction: Axis.vertical,
              height: 2,
              steps: <Tuple2<double, Color>>[
                Tuple2(8, Colors.transparent),
                Tuple2(8, Colors.red),
                Tuple2(8, Colors.transparent),
                Tuple2(8, Colors.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }

}