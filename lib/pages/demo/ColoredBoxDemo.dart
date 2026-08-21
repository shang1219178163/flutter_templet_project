//
//  ColoredBoxDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/11/22 3:25 PM.
//  Copyright © 10/11/22 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class ColoredBoxDemo extends StatefulWidget {

  const ColoredBoxDemo({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _ColoredBoxDemoState createState() => _ColoredBoxDemoState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }
}

class _ColoredBoxDemoState extends State<ColoredBoxDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        ColoredBox(
          color: Colors.orange,
          child: SizedBox(
            width: 200,
            height: 100,
          ),
        ),
        Divider(),
        Image.network('https://fastly.jsdelivr.net/npm/@vant/assets/apple-1.jpeg', width: 150, height: 150),
        Divider(),
        ColoredBox(
          color: Colors.yellow,
          child: Image.network('https://fastly.jsdelivr.net/npm/@vant/assets/apple-1.jpeg', width: 150, height: 150),
        ),
        Divider(),
        Center(
          child: ColoredBox(
            color: Colors.orange,
            child: CircleAvatar(
              radius: 75,
              backgroundColor: Colors.pink,
            ),
          ),
        ),
      ],
    );
  }
}
