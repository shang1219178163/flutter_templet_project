//
//  ClipDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/15/21 6:42 PM.
//  Copyright © 12/15/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/triangle_path.dart';

class ClipDemo extends StatefulWidget {

  final String? title;

  ClipDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _ClipDemoState createState() => _ClipDemoState();
}

class _ClipDemoState extends State<ClipDemo> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 150,
              width: 150,
              child: Image.asset(
                'images/bg.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),

          ClipOval(
            child: Container(
              height: 150,
              width: 250,
              child: Image.asset(
                'images/bg.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),

          ClipPath.shape(
            shape: StadiumBorder(),
            child: Container(
              height: 150,
              width: 250,
              child: Image.asset(
                'images/bg.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),

          ClipPath(
            clipper: TrianglePath(),
            child: Container(
              height: 150,
              width: 250,
              child: Image.asset(
                'images/bg.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),

        ],
      ),
    );
  }

}



