//
//  NnBoxWidgetDemo.dart
//  flutter_templet_project
//
//  Created by shang on 3/22/23 2:03 PM.
//  Copyright © 3/22/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/nn_box_widget.dart';
import 'package:flutter_templet_project/uti/R.dart';

class NNBoxWidgetDemo extends StatefulWidget {

  const NNBoxWidgetDemo({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _NNBoxWidgetDemoState createState() => _NNBoxWidgetDemoState();
}

class _NNBoxWidgetDemoState extends State<NNBoxWidgetDemo> {

  var bgGradient = LinearGradient(
    tileMode: TileMode.clamp,
    colors: [
      Colors.yellow,
      Colors.blue,
    ]
  );

  var boxShadows = <BoxShadow>[
     BoxShadow(//add test
      color: Colors.red,
      blurRadius: 3,
      spreadRadius: 3,
      offset: Offset(0, 0)
    ),
  ];

  var border = Border.all(
    color: Colors.red,
    width: 3.3,
    style: BorderStyle.solid
  );


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    bgGradient = LinearGradient(
        tileMode: TileMode.clamp,
        colors: [
          Colors.yellow,
          Colors.blue,
        ]
    );

    boxShadows = <BoxShadow>[
      BoxShadow(//add test
          color: Colors.red,
          blurRadius: 3,
          spreadRadius: 3,
          offset: Offset(3, 3)
      ),
    ];

    border = Border.all(
        color: Colors.red,
        width: 3.3,
        style: BorderStyle.solid
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          onPressed: () => debugPrint(e.toString()),
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),)
        ).toList(),
      ),
      body: Container(
        color: Colors.green.withOpacity(0.3),
        margin: EdgeInsets.all(16),
        child: Stack(
          children: [
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
                      'images/404.png',
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
            ),
          ]
        )
      ),
    );
  }

  buildBox() {
    return NNBoxWidget(
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
      bgUrl: R.image.urls[5],
      imageFit: BoxFit.cover,
      boxShadows: boxShadows,
      child: Image.asset(
        'images/404.png',
        fit: BoxFit.cover,
        // width: 300.0,
        // height: 200.0,
      ),
    );
  }

}

