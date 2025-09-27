//
//  SplitViewDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/8/8 18:17.
//  Copyright © 2024/8/8 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_split_view.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';

class SplitViewDemo extends StatefulWidget {
  const SplitViewDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<SplitViewDemo> createState() => _SplitViewDemoState();
}

class _SplitViewDemoState extends State<SplitViewDemo> {
  var direction = Axis.horizontal;
  double ratio = 0.5;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
        actions: [
          buildExchange(),
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildExchange() {
    return IconButton(
      onPressed: () {
        direction =
            direction == Axis.horizontal ? Axis.vertical : Axis.horizontal;
        ratio = 0.5;
        setState(() {});
      },
      icon: Icon(
        Icons.currency_exchange,
      ),
    );
  }

  Widget buildBody() {
    return NSplitView(
      direction: direction,
      ratio: ratio,
      start: buildLeft(),
      end: buildRight(),
    );
  }

  Widget buildLeft() {
    return Container(
      key: ValueKey("left"),
      color: ColorExt.random,
      child: ListTile(
        title: Text("buildLeft" * 9),
      ),
    );
  }

  Widget buildRight() {
    return Container(
      key: ValueKey("right"),
      color: ColorExt.random,
      child: ListTile(
        title: Text("buildRight" * 9),
      ),
    );
  }
}
