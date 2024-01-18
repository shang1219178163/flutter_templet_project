//
//  ClipDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/15/21 6:42 PM.
//  Copyright © 12/15/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/NSectionHeader.dart';
import 'package:flutter_templet_project/basicWidget/triangle_path.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/pages/demo/ChipDemo.dart';

class ClipDemo extends StatefulWidget {

  final String? title;

  const ClipDemo({ Key? key, this.title}) : super(key: key);

  
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
            NSectionHeader(
              title: 'ClipRect //将溢出部分剪裁',
              child: ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: 0.5,
                  child: _buildBox(),
                ),
              ),
            ),
            NSectionHeader(
              title: "ClipRRect",
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _buildBox(),
              ),
            ),
            NSectionHeader(
              title: "ClipOval",
              child: ClipOval(
                child: _buildBox(),
              ),
            ),
            NSectionHeader(
              title: "ClipPath.shape",
              child: ClipPath.shape(
                shape: StadiumBorder(),
                child: _buildBox(),
              ),
            ),
            NSectionHeader(
              title: "ClipPath - TrianglePath",
              child: ClipPath(
                clipper: TrianglePath(),
                child: _buildBox(),
              ),
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
      child: Image(
        image: 'bg.png'.toAssetImage(),
        fit: BoxFit.cover,
      ),
    );
  }
}



