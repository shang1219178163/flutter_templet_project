//
//  NSkeletonDemo.dart
//  flutter_templet_project
//
//  Created by shang on 3/30/23 8:17 AM.
//  Copyright © 3/30/23 shang. All rights reserved.
//


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/NNet/NNet.dart';
import 'package:flutter_templet_project/basicWidget/NNetContainer.dart';
import 'package:flutter_templet_project/basicWidget/NSkeleton.dart';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_templet_project/basicWidget/nn_slider.dart';
import 'package:flutter_templet_project/pages/demo/ValueListenableBuilderDemo.dart';
import 'package:flutter_templet_project/provider/notifier_demo.dart';
import 'package:flutter_templet_project/service/connectivity_service.dart';
import 'package:easy_refresh/easy_refresh.dart';


class NSkeletonDemo extends StatefulWidget {

  NSkeletonDemo({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _NSkeletonDemoState createState() => _NSkeletonDemoState();
}

class _NSkeletonDemoState extends State<NSkeletonDemo> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => print(e),)
        ).toList(),
      ),
      body: _buildPage()
    );
  }

  _buildPage() {
    return NSkeleton(

    );
  }

}

