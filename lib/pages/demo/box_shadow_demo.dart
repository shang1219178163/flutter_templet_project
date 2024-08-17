//
//  BoxShadowDemo.dart
//  flutter_templet_project
//
//  Created by shang on 1/13/23 5:03 PM.
//  Copyright © 1/13/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class BoxShadowDemo extends StatefulWidget {
  const BoxShadowDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _BoxShadowDemoState createState() => _BoxShadowDemoState();
}

class _BoxShadowDemoState extends State<BoxShadowDemo> {
  final tips = """
  /** 阴影效果
      const BoxShadow({
      Color color = const Color(0xFF000000),//阴影默认颜色,不能与父容器同时设置color
      Offset offset = Offset.zero,//延伸的阴影，向右下偏移的距离
      double blurRadius = 0.0,//延伸距离,会有模糊效果
      this.spreadRadius = 0.0 //延伸距离,不会有模糊效果
      })
   */
""";

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
                  onPressed: () => debugPrint(e.toString()),
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                ))
            .toList(),
      ),
      body: ListView(
        children: <Widget>[
          Text(tips),
          _buildBox(
            text: "spreadRadius: 5.0",
            decoration: BoxDecoration(color: Color(0xffffffff), boxShadow: [
              BoxShadow(
                color: Color(0xffff0000),
                spreadRadius: 5.0,
              ),
            ]),
          ),
          _buildBox(
            text: "blurRadius: 5.0",
            decoration: BoxDecoration(color: Color(0xffffffff), boxShadow: [
              BoxShadow(
                color: Color(0xffff0000),
                blurRadius: 5.0,
              ),
            ]),
          ),
          _buildBox(
            text: "spreadRadius: 5.0, blurRadius: 5.0",
            decoration: BoxDecoration(color: Color(0xffffffff), boxShadow: [
              BoxShadow(
                color: Color(0xffff0000),
                spreadRadius: 5.0,
                blurRadius: 5.0,
              ),
            ]),
          ),
          _buildBox(
            text:
                "spreadRadius: 5.0, blurRadius: 5.0, offset: Offset(3.0, 3.0)",
            decoration: BoxDecoration(
              color: Color(0xffffffff),
              boxShadow: [
                BoxShadow(
                  color: Color(0xffff0000),
                  spreadRadius: 5.0,
                  blurRadius: 5.0,
                  offset: Offset(3.0, 3.0),
                ),
              ],
            ),
          ),
          _buildBox(
            text: "spreadRadius: 0, blurRadius: 0, offset: Offset(0, 0)",
            decoration: BoxDecoration(
              color: Color(0xffffffff),
              boxShadow: [
                BoxShadow(
                  // color: Color(0xffff0000),
                  color: Color(0xff000000),
                  spreadRadius: 0,
                  blurRadius: 0,
                  offset: Offset(0, 0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildBox({
    required BoxDecoration decoration,
    String text = "",
  }) {
    return Container(
      width: 100.0,
      height: 60.0,
      margin: EdgeInsets.all(20.0),
      decoration: decoration,
      child: Text(text),
    );
  }
}
