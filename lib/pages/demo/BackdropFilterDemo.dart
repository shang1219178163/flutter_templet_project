//
//  BackdropFilterDemo.dart
//  flutter_templet_project
//
//  Created by shang on 7/30/21 11:13 AM.
//  Copyright © 7/30/21 shang. All rights reserved.
//

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/generated/assets.dart';

class BackdropFilterDemo extends StatefulWidget {

  const BackdropFilterDemo({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _BackdropFilterDemoState createState() => _BackdropFilterDemoState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }
}

class _BackdropFilterDemoState extends State<BackdropFilterDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildBody1(),
    );
  }

  Widget buildBody() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image(
          image: AssetImage(Assets.imagesBg),
          fit: BoxFit.cover,
        ),
        Center(
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY: 5.0,
              ),
              child: Container(
                alignment: Alignment.center,
                width: 200.0,
                height: 200.0,
                // color: Colors.red,
                child: const Text('Hello World'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBody1() {
    return StackExt.createBlurView(
        blur: 5,
        child: Image(
          image: AssetImage(Assets.imagesBg),
          fit: BoxFit.cover,
        ));
  }
}
