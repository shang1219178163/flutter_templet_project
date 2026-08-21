//
//  MyPopverDemo.dart
//  flutter_templet_project
//
//  Created by shang on 1/20/23 8:09 AM.
//  Copyright © 1/20/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class MyPopverDemo extends StatefulWidget {
  const MyPopverDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyPopverDemoState createState() => _MyPopverDemoState();
}

class _MyPopverDemoState extends State<MyPopverDemo> {
  final _globalKey = GlobalKey();

  var btnIdx = 0;
  var isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: ListView(
        children: [
          ...List.generate(
              10,
              (index) => ListTile(
                    title: Text("top_$index"),
                  )).toList(),
          buildSection(),
          ...List.generate(
              20,
              (index) => ListTile(
                    title: Text("row_$index"),
                  )).toList(),
        ],
      ),
    );
  }

  Widget buildSection() {
    return Stack(
      key: _globalKey,
      clipBehavior: Clip.none,
      children: [
        buildMenu(),
        if (isVisible)
          Positioned(
            // left: 0,
            right: 0.0,
            top: _globalKey.currentContext?.renderBoxSize?.height ?? 30,
            width: context.screenSize.width,
            height: 300.0,
            child: buildDropBox(),
          ),
      ],
    );
  }

  Widget buildMenu({int count = 3}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
          count,
          (index) => ElevatedButton(
                onPressed: () {
                  final val = _globalKey.currentContext?.origin();
                  debugPrint("菜单${index}_$val");
                  btnIdx = index;
                  isVisible = !isVisible;
                  setState(() {});
                },
                child: Text("菜单$index"),
              )).map((e) => Expanded(child: e)).toList(),
    );
  }

  Widget buildDropBox() {
    return Builder(builder: (context) {
      if (btnIdx == 0) {
        return buildDropBox1();
      }
      if (btnIdx == 1) {
        return buildDropBox2();
      }
      return buildDropBox3();
    });
  }

  Widget buildDropBox1() {
    return Container(
        decoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(width: 5, color: Colors.red),
        ),
        child: Center(child: Text("one")));
  }

  Widget buildDropBox2() {
    return Container(
        decoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(width: 5, color: Colors.yellow),
        ),
        child: Center(child: Text("two")));
  }

  Widget buildDropBox3() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        // borderRadius: BorderRadius.circular(10),
      ),
      child: ListView(
        children: [
          Column(
            children: [
              ...List.generate(
                  20,
                  (index) => ListTile(
                        title: Text("我是弹窗_$index"),
                      )).toList(),
            ],
          ),
        ],
      ),
    );
  }

  final OutlineInputBorder _border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(4.0),
    borderSide: BorderSide(
      color: Colors.grey,
      width: 1.0,
    ),
  );

  Widget buildDemo() {
    return Column(children: [
      LayoutBuilder(builder: (context, constraints) {
        return SizedBox();
      }),
      Builder(builder: (context) {
        return SizedBox();
      }),
      StatefulBuilder(builder: (context, setState) {
        return SizedBox();
      }),
    ]);
  }
}
