//
//  ClipDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/15/21 6:42 PM.
//  Copyright © 12/15/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/section_header.dart';
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
    return ListView(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SectionHeader.h4(title: 'ClipRRect'),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: _buildBox(),
            ),

            SectionHeader.h4(title: 'ClipOval'),
            ClipOval(
              child: _buildBox(),
            ),

            SectionHeader.h4(title: 'ClipPath.shape'),
            ClipPath.shape(
              shape: StadiumBorder(),
              child: _buildBox(),
            ),

            SectionHeader.h4(title: 'ClipPath'),
            ClipPath(
              clipper: TrianglePath(),
              child: _buildBox(),
            ),
          ],
        ),
      ],
    );
  }

  _buildBox() {
    return Container(
      height: 100,
      width: 150,
      child: Image.asset(
        'images/bg.jpg',
        fit: BoxFit.cover,
      ),
    );
  }

}



