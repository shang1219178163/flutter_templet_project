//
//  IndicatorDemo.dart
//  flutter_templet_project
//
//  Created by shang on 6/7/21 3:21 PM.
//  Copyright © 6/7/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';

class IndicatorDemo extends StatefulWidget {
  const IndicatorDemo({super.key});

  @override
  _IndicatorDemoState createState() => _IndicatorDemoState();
}

class _IndicatorDemoState extends State<IndicatorDemo>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  onPressed: () {
                    // debugPrint(CupertinoActivityIndicator().runtimeType.toString());
                  },
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                ))
            .toList(),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            NSectionBox(
              title: "CupertinoActivityIndicator",
              child: CupertinoActivityIndicator(
                radius: 24,
                color: primaryColor,
              ),
            ),
            NSectionBox(
              title: "CircularProgressIndicator",
              child: SizedBox(
                width: 60,
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      value: controller.value,
                      semanticsLabel: 'Linear progress indicator',
                      strokeWidth: 4,
                      backgroundColor: Colors.grey.withAlpha(30),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: NText(
                        controller.value.toStringAsPercent(2),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            NSectionBox(
              title: "LinearProgressIndicator",
              child: LinearProgressIndicator(
                value: controller.value,
                minHeight: 4,
                backgroundColor: Colors.grey.withAlpha(30),
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
