//
//  BackdropFilterDemo.dart
//  flutter_templet_project
//
//  Created by shang on 7/30/21 11:13 AM.
//  Copyright © 7/30/21 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/blur_view.dart';

class BackdropFilterDemo extends StatefulWidget {

  final String? title;

  BackdropFilterDemo({ Key? key, this.title}) : super(key: key);
  
  @override
  _BackdropFilterDemoState createState() => _BackdropFilterDemoState();
}

class _BackdropFilterDemoState extends State<BackdropFilterDemo> {

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    final title = 'BackdropFilter class';
    final message = 'A widget that applies a filter to the existing painted content and then paints child.'
        'The filter will be applied to all the area within its parent or ancestor widget\'s clip. If there\'s no clip, the filter will be applied to the full screen.';

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.asset(
          'assets/images/bg.jpg',
          fit: BoxFit.cover,
        ),
        Center(
          child: BlurView(
            child: Container(
              // color: Colors.white10,
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Text(message,
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
