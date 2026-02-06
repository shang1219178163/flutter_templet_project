import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/n_marquee_widget.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:tuple/tuple.dart';

// typedef onKeyCallback = void Function(BuildContext context, int index, GlobalKey key);

class MarqueeWidgetDemo extends StatefulWidget {
  const MarqueeWidgetDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MarqueeWidgetDemoState createState() => _MarqueeWidgetDemoState();
}

class _MarqueeWidgetDemoState extends State<MarqueeWidgetDemo> {
  final _globalKey = GlobalKey();

  final offset = ValueNotifier(0.0);

  Timer? _timer;

  var items = [
    Tuple4(
      'https://avatar.csdn.net/8/9/A/3_chenlove1.jpg',
      '标题｜无边界厨房',
      '跳转url',
      true,
    ),
    Tuple4(
      'https://pic.616pic.com/bg_w1180/00/04/08/G5Bftx5ZDI.jpg!/fw/1120',
      '标题｜无边界客厅',
      '跳转url',
      false,
    ),
    Tuple4(
      'https://cdn.pixabay.com/photo/2018/02/01/21/00/tree-3124103_1280.jpg',
      '标题｜无边界厨房',
      '跳转url',
      false,
    ),
    // Tuple4(
    //   'https://cdn.pixabay.com/photo/2018/02/01/21/00/tree-3124103_1280.jpg',
    //   '海尔｜无边界厨房',
    //   '跳转url',
    //   false,
    // ),
  ];

  List<String> mottos = [];

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    final str = await rootBundle.loadString("assets/data/motto.txt");
    final list = str.split("\n");
    DLog.d(list);
    mottos.addAll(list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: Icon(Icons.all_inclusive),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 30,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: NMarqueeWidget(
              itemCount: mottos.length,
              itemBuilder: (BuildContext context, int index, BoxConstraints constraints) {
                final e = mottos[index];
                // final text = "${index}_${e.item2}";
                final text = e;
                return Container(
                  // color: Colors.green,
                  // child: itemWidgets[index],
                  child: Text(text),
                );
              },
              separatorBuilder: (BuildContext context, int index, BoxConstraints constraints) {
                return Container(
                  width: 100,
                  // decoration: BoxDecoration(
                  //   color: Colors.green,
                  //   border: Border.all(color: Colors.blue),
                  // ),
                  // child: Text("$index"),
                );
              },
              edgeBuilder: (BuildContext context, int index, BoxConstraints constraints) {
                // print("MarqueeWidget edgeBuilder: $index ${index % 2 == 0}");
                return Container(
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    border: Border.all(color: Colors.red),
                  ),
                  // child: Text("$index"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
