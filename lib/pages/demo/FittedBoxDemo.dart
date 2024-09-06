//
//  FittedBoxDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/11/22 2:12 PM.
//  Copyright © 10/11/22 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class FittedBoxDemo extends StatefulWidget {
  final String? title;

  const FittedBoxDemo({Key? key, this.title}) : super(key: key);

  @override
  _FittedBoxDemoState createState() => _FittedBoxDemoState();
}

class _FittedBoxDemoState extends State<FittedBoxDemo> {
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
    return Center(
      child: Column(
        children: [
          wImage(),
          ...BoxFit.values.map((e) => wContainer(e)).toList(),
        ],
      ),
    );
  }

  wImage() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.green,
      child: FittedBox(
        fit: BoxFit.contain,
        alignment: Alignment.centerLeft,
        child: Container(
            color: Colors.yellow,
            child: Image.asset("assets/images/avatar.png",
                width: 200, height: 100)),
      ),
    );
  }

  Widget wContainer(BoxFit boxFit) {
    return Container(
      width: 150,
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.red,
        border: Border.all(color: Colors.black, width: 3),
      ),
      child: FittedBox(
        fit: boxFit,
        // 子容器超过父容器大小
        child: Container(
          width: 200,
          height: 70,
          color: Colors.blue,
          child: Text(boxFit.toString()),
        ),
      ),
    );
  }
}
