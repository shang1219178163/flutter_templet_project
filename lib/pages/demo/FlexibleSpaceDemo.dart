//
//  FlexibleSpaceDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2/14/23 6:16 PM.
//  Copyright © 2/14/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class FlexibleSpaceDemo extends StatefulWidget {

  FlexibleSpaceDemo({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _FlexibleSpaceDemoState createState() => _FlexibleSpaceDemoState();
}

class _FlexibleSpaceDemoState extends State<FlexibleSpaceDemo> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: FlexibleSpaceBar(
          title: Text("FlexibleSpace", style: TextStyle(color: Colors.black),),
          // collapseMode: CollapseMode.pin,
          background: Image.network(
              "https://p3-passport.byteimg.com/img/user-avatar/af5f7ee5f0c449f25fc0b32c050bf100~180x180.awebp",
              fit: BoxFit.cover),
          stretchModes: [
            // StretchMode.fadeTitle,
            // StretchMode.blurBackground,
            StretchMode.zoomBackground
          ],
        ),
      ),
      body: Text(arguments.toString())
    );
  }

}

