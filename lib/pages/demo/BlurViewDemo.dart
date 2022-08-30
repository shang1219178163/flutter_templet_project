//
//  BlurViewDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/10/21 9:42 AM.
//  Copyright © 12/10/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/blur_view.dart';

class BlurViewDemo extends StatelessWidget {

  final String? title;

  const BlurViewDemo({
  	Key? key,
  	this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? "$this"),
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
          'images/bg.jpg',
          fit: BoxFit.cover,
        ),
        Center(
          child: BlurView(
            margin: EdgeInsets.all(8),
            blur: 25,
            child: Container(
              // color: Colors.red,
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



