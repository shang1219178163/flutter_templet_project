//
//  ButtonBorderDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/15/21 5:28 PM.
//  Copyright © 12/15/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_section_header.dart';

class BorderDemo extends StatefulWidget {
  final String? title;

  const BorderDemo({Key? key, this.title}) : super(key: key);

  @override
  _BorderDemoState createState() => _BorderDemoState();
}

class _BorderDemoState extends State<BorderDemo> {
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
        Column(
          children: [
            NSectionHeader(
              title: "BorderSide",
              child: TextButton(
                style: TextButton.styleFrom(
                  side: BorderSide(color: Colors.red, width: 1),
                ),
                onPressed: () {},
                child: Text('BorderSide'),
              ),
            ),
            NSectionHeader(
              title: "BeveledRectangleBorder",
              child: Column(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      shape: _buildBeveledRectangleBorder(radius: 0),
                    ),
                    onPressed: () {},
                    child: Text('BeveledRectangleBorder - radius: 0'),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      shape: _buildBeveledRectangleBorder(radius: 10),
                    ),
                    onPressed: () {},
                    child: Text('BeveledRectangleBorder - radius: 10'),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      shape: _buildBeveledRectangleBorder(radius: 100),
                    ),
                    onPressed: () {},
                    child: Text('BeveledRectangleBorder - radius: 100'),
                  ),
                ],
              ),
            ),
            NSectionHeader(
              title: "CircleBorder",
              child: Column(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      shape: CircleBorder(
                        side: BorderSide(width: 1, color: Colors.red),
                      ),
                      minimumSize: Size(100, 100),
                    ),
                    onPressed: () {},
                    child: Text('CircleBorder'),
                  ),
                ],
              ),
            ),
            NSectionHeader(
              title: "ContinuousRectangleBorder",
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: ContinuousRectangleBorder(
                      side: BorderSide(width: 1, color: Colors.red),
                      borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {},
                child: Text('ContinuousRectangleBorder'),
              ),
            ),
            NSectionHeader(
              title: "OutlinedBorder - LinearBorder",
              child: TextButton(
                style: TextButton.styleFrom(
                  // side: const BorderSide(color: Colors.red),
                  shape: const LinearBorder(
                    side: BorderSide(color: Colors.green),
                    bottom: LinearBorderEdge(),
                  ),
                ),
                onPressed: () {},
                child: Text('LinearBorder'),
              ),
            ),
            NSectionHeader(
              title: "RoundedRectangleBorder",
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Colors.red),
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {},
                child: Text('RoundedRectangleBorder'),
              ),
            ),
            NSectionHeader(
              title: "StadiumBorder",
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: StadiumBorder(
                    side: BorderSide(width: 1, color: Colors.red),
                  ),
                ),
                onPressed: () {},
                child: Text('StadiumBorder'),
              ),
            ),
            NSectionHeader(
              title: "OutlinedBorder - StarBorder",
              child: TextButton(
                style: TextButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: const StarBorder(
                    side: BorderSide(color: Colors.blue),
                  ),
                ),
                onPressed: () {},
                child: Text('StarBorder'),
              ),
            ),
            NSectionHeader(
              title: "BoxDecoration - BoxBorder",
              child: Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.all(8),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    border: Border(
                        top: BorderSide(
                      color: Colors.red,
                      width: 3,
                    ))),
                child: Icon(
                  Icons.pool,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
            NSectionHeader(
              title: "BoxDecoration - BoxShape.circle",
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 4),
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  iconSize: 24,
                  icon: Icon(Icons.check),
                  onPressed: () {},
                ),
              ),
            ),
            NSectionHeader(
              title: "ShapeDecoration - ShapeBorder",
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(8),
                    decoration: ShapeDecoration(
                        // color: Colors.green,
                        shape: Border.all(color: Colors.green, width: 2)),
                    child: TextButton(
                      onPressed: () {},
                      child: Text("ShapeDecoration - Border.all"),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    decoration: ShapeDecoration(
                        shape: Border(
                            top: BorderSide(color: Colors.red, width: 5),
                            bottom: BorderSide(color: Colors.yellow, width: 5),
                            right: BorderSide(color: Colors.blue, width: 5),
                            left: BorderSide(color: Colors.green, width: 5))),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                          'ShapeDecoration - Border.top,bottom,right,left'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    decoration: ShapeDecoration(
                        color: Colors.yellowAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            side: BorderSide(color: Colors.red, width: 2))),
                    child: TextButton(
                      onPressed: () {},
                      child: Text('ShapeDecoration - RoundedRectangleBorder'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    decoration: ShapeDecoration(
                        color: Colors.yellowAccent,
                        shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            side: BorderSide(color: Colors.red, width: 2))),
                    child: TextButton(
                      onPressed: () {},
                      child: Text('ShapeDecoration - BeveledRectangleBorder'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    decoration: ShapeDecoration(
                        // color: Colors.yellowAccent,
                        gradient: LinearGradient(
                          colors: [
                            Colors.yellow,
                            Colors.green,
                          ],
                        ),
                        shape: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 2))),
                    child: TextButton(
                      onPressed: () {},
                      child: Text('ShapeDecoration - UnderlineInputBorder'),
                    ),
                  ),
                ],
              ),
            ),
            NSectionHeader(
              title: "Decoration - UnderlineTabIndicator",
              child: Container(
                margin: EdgeInsets.all(8),
                decoration: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 2.0, color: Colors.red),
                    insets: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                child: TextButton(
                  onPressed: () {},
                  child: Text('Decoration - UnderlineTabIndicator'),
                ),
              ),
            ),
            NSectionHeader(
              title: "ShapeDecoration - InputBorder",
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(8),
                    decoration: ShapeDecoration(
                      shape: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.red),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: Text('ShapeDecoration - OutlineInputBorder'),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(8),
              decoration: ShapeDecoration(
                shape: UnderlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.red),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: TextButton(
                onPressed: () {},
                child: Text('ShapeDecoration - UnderlineInputBorder'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 斜角矩形边框
  _buildBeveledRectangleBorder({
    required double radius,
    double width = 1,
    Color color = Colors.red,
  }) {
    return BeveledRectangleBorder(
        side: BorderSide(width: width, color: color),
        borderRadius: BorderRadius.circular(radius));
  }
}
