//
//  ScaffoldDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/7/4 09:28.
//  Copyright © 2024/7/4 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/util/color_util.dart';
import 'package:get/get.dart';

class ScaffoldDemo extends StatefulWidget {
  const ScaffoldDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<ScaffoldDemo> createState() => _ScaffoldDemoState();
}

class _ScaffoldDemoState extends State<ScaffoldDemo>
    with SingleTickerProviderStateMixin {
  late bool _isOpen = false;
  late AnimationController _animationController;
  late Animation<Color?> _animationColor;
  late Animation<double> _animationIcon;
  final Curve _curve = Curves.easeOut;

  final _scaffoldStateKey = GlobalKey<ScaffoldState>();

  int _currentIndex = 0;
  final pages = <({BottomNavigationBarItem barItem, Widget page})>[
    (
      barItem: BottomNavigationBarItem(icon: Icon(Icons.ac_unit), label: "首页"),
      page: Center(
        child: Text("tab1"),
      )
    ),
    (
      barItem: BottomNavigationBarItem(
          icon: Icon(Icons.my_library_add), label: "我的"),
      page: Center(
        child: Text("tab2"),
      )
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250))
          ..addListener(() {
            setState(() {});
          });

    _animationColor = ColorTween(begin: Colors.red, end: Colors.green).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.0, 1.0, curve: _curve)));

    _animationIcon = Tween(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldStateKey,
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: true,
      primary: true,
      extendBody: false,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Text("ScaffoldExample"),
        leading: IconButton(
            onPressed: () {
              _scaffoldStateKey.currentState?.openDrawer();
            },
            icon: Icon(Icons.menu_open)),
      ),
      body: pages[_currentIndex].page,
      floatingActionButton: FloatingActionButton(
          backgroundColor: _animationColor.value,
          onPressed: () {
            if (!_isOpen) {
              _animationController.forward();
            } else {
              _animationController.reverse();
            }
            _isOpen = !_isOpen;
          },
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _animationIcon,
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      persistentFooterButtons: [
        TextButton(onPressed: () {}, child: Text("取消")),
        TextButton(onPressed: () {}, child: Text("确认授权")),
      ],
      drawer: Drawer(
        child: Center(
          child: Text("drawer"),
        ),
      ),
      onDrawerChanged: (isOpen) {
        DLog.d(isOpen);
      },
      endDrawer: Drawer(
        child: Center(
          child: Text("endDrawer"),
        ),
      ),
      onEndDrawerChanged: (isOpen) {
        DLog.d(isOpen);
      },
      drawerDragStartBehavior: DragStartBehavior.start,
      drawerScrimColor: Colors.black12, // 抽屉弹窗背景
      drawerEdgeDragWidth: 200,
      drawerEnableOpenDragGesture: true,
      bottomNavigationBar: BottomNavigationBar(
        items: pages.map((e) => e.barItem).toList(),
        currentIndex: _currentIndex,
        onTap: (currentIndex) {
          _currentIndex = currentIndex;
          setState(() {});
        },
      ),
      bottomSheet: Row(
        children: [
          Expanded(child: TextField()),
          TextButton(onPressed: () {}, child: Text("发送"))
        ],
      ),
    );
  }
}
