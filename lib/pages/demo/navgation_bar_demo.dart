//
//  TransparentNavgationBarDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/15/21 10:57 AM.
//  Copyright © 12/15/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';

class NavgationBarDemo extends StatefulWidget {
  final String? title;

  const NavgationBarDemo({Key? key, this.title}) : super(key: key);

  @override
  _NavgationBarDemoState createState() => _NavgationBarDemoState();
}

class _NavgationBarDemoState extends State<NavgationBarDemo> {
  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      extendBodyBehindAppBar: true,
      // backgroundColor: Colors.blue,
      body: Stack(children: [
        SafeArea(
          child: Container(
            color: Colors.red,
            // padding: EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 0),
            child: Center(
              child: Image.asset(
                'assets/images/bg.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Positioned(
          child: Container(
            height: 102,
            child: _buildAppBar(),
          ),
        ),
      ]),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: Text("title"),
      actions: [
        IconButton(
          onPressed: () {
            DLog.d("share");
          },
          icon: Icon(Icons.share),
        ),
      ],
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.black,
    );
  }
}
