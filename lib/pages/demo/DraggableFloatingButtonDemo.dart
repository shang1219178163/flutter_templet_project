//
//  DraggableFloatingButtonDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/11/21 12:01.
//  Copyright © 2024/11/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/mixin/draggable_floating_button_mixin.dart';

class DraggableFloatingButtonDemo extends StatefulWidget {
  const DraggableFloatingButtonDemo({super.key});

  @override
  _DraggableFloatingButtonDemoState createState() => _DraggableFloatingButtonDemoState();
}

class _DraggableFloatingButtonDemoState extends State<DraggableFloatingButtonDemo> with DraggableFloatingButtonMixin {
  @override
  void dispose() {
    DLog.d("$widget dispose");
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    DLog.d("$widget initState");
  }

  @override
  Widget floatingButton() {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.circle_notifications_rounded,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OutlinedButton(
              onPressed: () {
                floatingButtonToggle();
              },
              child: Text(isFloatingButtonShow ? "hide" : "show"),
            ),
          ],
        ),
      ),
    );
  }
}
