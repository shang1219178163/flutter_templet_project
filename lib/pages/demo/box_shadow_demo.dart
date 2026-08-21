//
//  BoxShadowDemo.dart
//  flutter_templet_project
//
//  Created by shang on 1/13/23 5:03 PM.
//  Copyright © 1/13/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/enhance/en_box_decoration/en_box_decoration.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/basicWidget/shadow/n_inner_shadow.dart';

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
    final themeData = Theme.of(context);
    final primary = themeData.colorScheme.primary;
    final isDark = themeData.brightness == Brightness.dark;

    final shadowColor = Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16).copyWith(bottom: 34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                tips,
                style: TextStyle(fontSize: 14),
              ),
              buildBox(
                text: "spreadRadius: 5.0",
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
                      spreadRadius: 5.0,
                    ),
                  ],
                ),
              ),
              buildBox(
                text: "blurRadius: 5.0",
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
                      blurRadius: 5.0,
                    ),
                  ],
                ),
              ),
              buildBox(
                text: "spreadRadius: 5.0, blurRadius: 5.0",
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
                      spreadRadius: 5.0,
                      blurRadius: 5.0,
                    ),
                  ],
                ),
              ),
              buildBox(
                text: "spreadRadius: 5.0, blurRadius: 5.0, offset: Offset(3.0, 3.0)",
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
                      spreadRadius: 5.0,
                      blurRadius: 5.0,
                      offset: Offset(3.0, 3.0),
                    ),
                  ],
                ),
              ),
              buildBox(
                text: "spreadRadius: 0, blurRadius: 0, offset: Offset(0, 0)",
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  boxShadow: [
                    BoxShadow(
                      // color: shadowColor,
                      color: Color(0xff000000),
                      spreadRadius: 0,
                      blurRadius: 0,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
              NSectionBox(
                title: "NInnerShadow",
                child: DefaultTextStyle(
                  style: TextStyle(fontSize: 12, color: Colors.black),
                  child: Row(
                    children: [
                      Expanded(
                        child: buildInnerShadow(
                          boxShadow: [
                            BoxShadow(
                              color: shadowColor,
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                            BoxShadow(
                              color: Colors.blue,
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(12),
                          child: Text("NInnerShadowBox - 30"),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: buildInnerShadow(
                          boxShadow: [
                            BoxShadow(
                              color: shadowColor,
                              blurRadius: 15,
                              spreadRadius: 5,
                            ),
                            BoxShadow(
                              color: Colors.blue,
                              blurRadius: 5,
                              spreadRadius: 5,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(12),
                          child: Text("NInnerShadowBox - 8"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              NSectionBox(
                title: "EnBoxDecoration",
                child: DefaultTextStyle(
                  style: TextStyle(fontSize: 12, color: Colors.black),
                  child: buildEnBoxDecoration(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBox({
    required BoxDecoration decoration,
    String text = "",
  }) {
    return Container(
      height: 60.0,
      margin: EdgeInsets.all(20.0),
      decoration: decoration,
      child: Text(text),
    );
  }

  Widget buildInnerShadow({
    List<BoxShadow>? boxShadow,
    BorderRadius borderRadius = BorderRadius.zero,
    double blurExtent = 4,
    Widget? child,
  }) {
    return NInnerShadow(
      boxShadow: boxShadow,
      blurExtent: blurExtent,
      borderRadius: borderRadius,
      child: Container(
        height: 100.0,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  Widget buildEnBoxDecoration() {
    return Container(
      height: 100.0,
      alignment: Alignment.center,
      decoration: EnBoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.red,
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
        innerBoxShadow: [
          BoxShadow(
            color: Colors.blue,
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Text([
        "EnBoxDecoration",
        "boxShadow color: Colors.red",
        "innerBoxShadow color: Colors.blue",
      ].join("\n")),
    );
  }
}
