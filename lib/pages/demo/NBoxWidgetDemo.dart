//
//  NnBoxWidgetDemo.dart
//  flutter_templet_project
//
//  Created by shang on 3/22/23 2:03 PM.
//  Copyright © 3/22/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_box.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:flutter_templet_project/util/AppRes.dart';

class NBoxWidgetDemo extends StatefulWidget {
  const NBoxWidgetDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _NBoxWidgetDemoState createState() => _NBoxWidgetDemoState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }
}

class _NBoxWidgetDemoState extends State<NBoxWidgetDemo> {
  var bgGradient = LinearGradient(tileMode: TileMode.clamp, colors: [
    Colors.yellow,
    Colors.blue,
  ]);

  var boxShadows = <BoxShadow>[
    BoxShadow(
        //add test
        color: Colors.red,
        blurRadius: 3,
        spreadRadius: 3,
        offset: Offset(0, 0)),
  ];

  var border = Border.all(color: Colors.red, width: 3.3, style: BorderStyle.solid);

  @override
  Widget build(BuildContext context) {
    bgGradient = LinearGradient(
      tileMode: TileMode.clamp,
      colors: [
        Colors.yellow,
        Colors.blue,
      ],
    );

    boxShadows = <BoxShadow>[
      BoxShadow(
          //add test
          color: Colors.red,
          blurRadius: 3,
          spreadRadius: 3,
          offset: Offset(3, 3)),
    ];

    border = Border.all(color: Colors.red, width: 3.3, style: BorderStyle.solid);

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
      body: Container(
          color: Colors.green.withValues(alpha: 0.3),
          margin: EdgeInsets.all(16),
          child: Stack(children: [
            Text("01" * 399),
            Container(
              padding: EdgeInsets.all(18),
              child: Column(
                children: [
                  buildBox(),
                  Divider(),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      gradient: bgGradient,
                      boxShadow: boxShadows,
                    ),
                    child: Image.asset(
                      'assets/images/404.png',
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
            ),
          ])),
    );
  }

  Widget buildBox() {
    return NBox(
      // width: 300,
      height: 200,
      opacity: 1,
      blur: 0,
      bgBlur: 0,
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(0),
      borderRadius: const BorderRadius.all(Radius.circular(18)),
      // border: border,
      bgColor: Colors.transparent,
      bgGradient: bgGradient,
      bgUrl: AppRes.image.urls[5],
      imageFit: BoxFit.cover,
      boxShadows: boxShadows,
      child: Image(
        image: AssetImage(Assets.images404),
        fit: BoxFit.cover,
        // width: 300.0,
        // height: 200.0,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<LinearGradient>('bgGradient', bgGradient));
    properties.add(IterableProperty<BoxShadow>('boxShadows', boxShadows));
    properties.add(DiagnosticsProperty<Border>('border', border));
  }
}
