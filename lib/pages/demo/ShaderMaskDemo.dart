//
//  ShaderMaskDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/10/21 9:15 AM.
//  Copyright © 12/10/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class ShaderMaskDemo extends StatelessWidget {
  final String? title;

  const ShaderMaskDemo({
    Key? key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("$this"),
        ),
        body: Center(
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return RadialGradient(
                center: Alignment.topLeft,
                radius: 1.0,
                colors: <Color>[Colors.yellow, Colors.deepOrange.shade900],
                tileMode: TileMode.mirror,
              ).createShader(bounds);
            },
            child: const Text(
              'I’m burning the memories!',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        ));
  }
}
