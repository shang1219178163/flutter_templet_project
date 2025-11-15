import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';

class TransformDemo extends StatefulWidget {
  final String? title;

  const TransformDemo({Key? key, this.title}) : super(key: key);

  @override
  _TransformDemoState createState() => _TransformDemoState();
}

class _TransformDemoState extends State<TransformDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return ListView(
      children: [
        NSectionBox(
          title: "Matrix4.skewX",
          mainAxisSize: MainAxisSize.min,
          child: Container(
            color: Colors.black,
            child: Transform(
              alignment: Alignment.topRight,
              transform: Matrix4.skewX(-0.3),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                color: const Color(0xFFE8581C),
                child: const Text('Apartment for rent!'),
              ),
            ),
          ),
        ),
        NSectionBox(
          title: "Matrix4.skewY",
          mainAxisSize: MainAxisSize.min,
          child: Container(
            color: Colors.black,
            child: Transform(
              alignment: Alignment.topRight,
              transform: Matrix4.skewY(0.7)..rotateZ(-math.pi / 12.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                color: const Color(0xFFE8581C),
                child: const Text('Apartment for rent!'),
              ),
            ),
          ),
        ),
        NSectionBox(
          title: "Transform.rotate",
          child: Transform.rotate(
            angle: pi / 4,
            child: Container(
              width: 50,
              height: 50,
              color: primaryColor,
              child: Text("rotate"),
            ),
          ),
        ),
        NSectionBox(
          title: "Transform.translate",
          child: DecoratedBox(
            decoration: BoxDecoration(color: Colors.red),
            //默认原点为左上角，左移20像素，向上平移5像素
            child: Transform.translate(
              offset: Offset(-20.0, -5.0),
              child: Text("Hello world"),
            ),
          ),
        ),
        NSectionBox(
          title: "Transform.rotate",
          child: DecoratedBox(
            decoration: BoxDecoration(color: Colors.red),
            child: Transform.rotate(
              //旋转90度
              angle: math.pi / 2,
              child: Text("Hello world"),
            ),
          ),
        ),
        NSectionBox(
          title: "Transform.scale",
          child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.red),
              child: Transform.scale(
                  scale: 1.5, //放大到1.5倍
                  child: Text("Hello world"))),
        ),
        NSectionBox(
          title: "RotatedBox",
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(color: Colors.red),
                //将Transform.rotate换成RotatedBox
                child: RotatedBox(
                  quarterTurns: 1, //旋转90度(1/4圈)
                  child: Text("Hello world"),
                ),
              ),
              Text(
                "你好",
                style: TextStyle(color: Colors.green, fontSize: 18.0),
              )
            ],
          ),
        ),
      ]
          .map(
            (e) => Padding(
              padding: EdgeInsets.all(28.0),
              child: e,
            ),
          )
          .toList(),
    );
  }
}
