//
//  ProgressIndicatorDemoPage.dart
//  flutter_templet_project
//
//  Created by shang on 6/7/21 3:21 PM.
//  Copyright © 6/7/21 shang. All rights reserved.
//


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_templet_project/extensions/ddlog.dart';

class ProgressIndicatorDemoPage extends StatefulWidget {

  final String? title;

  ProgressIndicatorDemoPage({ Key? key, this.title}) : super(key: key);

  
  @override
  _ProgressIndicatorDemoPageState createState() => _ProgressIndicatorDemoPageState();
}

class _ProgressIndicatorDemoPageState extends State<ProgressIndicatorDemoPage> with TickerProviderStateMixin {

  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: Duration(seconds: 3),)
    ..addListener(() {
      setState(() {
        // ddlog("${controller.value}");
      });
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
        title: Text(widget.title ?? "$widget"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'Circular progress indicator with a fixed color',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                value: controller.value,
                semanticsLabel: 'Linear progress indicator',
                strokeWidth: 4,
                backgroundColor: Colors.grey.withAlpha(30),
              ),
            ),

            Divider(
              height: 10,
              thickness: 5,
              color: Colors.purple,
              indent: 0,
              endIndent: 0,
            ),
            Text(
              'Linear progress indicator with a fixed color',
              style: Theme.of(context).textTheme.headline6,
            ),

            LinearProgressIndicator(
              value: controller.value,
              minHeight: 4,
              backgroundColor: Colors.grey.withAlpha(30),
              color: Colors.red,
            ),

            CupertinoActivityIndicator(
              radius: 12,
            ),

          ],
        ),
      ),
    );
  }
}
