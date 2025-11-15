//
//  NavigationRailDemo.dart
//  flutter_templet_project
//
//  Created by shang on 3/14/23 8:56 AM.
//  Copyright © 3/14/23 shang. All rights reserved.
//
/// TrackingScrollController 在2.0.6 mac 平台无效,后续观察

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class NavigationRailDemo extends StatefulWidget {
  const NavigationRailDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _NavigationRailDemoState createState() => _NavigationRailDemoState();
}

class _NavigationRailDemoState extends State<NavigationRailDemo> {
  final _controller = PageController();
  final _selectIndex = ValueNotifier(0);

  final _trackingScrollController = TrackingScrollController();

  final destinations = const <NavigationRailDestination>[
    NavigationRailDestination(icon: Icon(Icons.message), label: Text("消息")),
    NavigationRailDestination(icon: Icon(Icons.video_camera_back), label: Text("视频会议")),
    NavigationRailDestination(icon: Icon(Icons.book_outlined), label: Text("通讯录")),
    NavigationRailDestination(icon: Icon(Icons.cloud_upload), label: Text("云文档")),
    NavigationRailDestination(icon: Icon(Icons.games_sharp), label: Text("工作台")),
    NavigationRailDestination(icon: Icon(Icons.camera), label: Text("日历"))
  ];

  var isNavigationRailExpand = false.vn;

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: [
            'done',
          ]
              .map((e) => TextButton(
                    onPressed: onPressed,
                    child: Text(
                      e,
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
              .toList(),
        ),
        body: Row(children: [
          AnimatedBuilder(
            animation: Listenable.merge([_selectIndex, isNavigationRailExpand]),
            builder: (context, child) {
              return _buildLeftNavigation(selectedIndex: _selectIndex.value, extended: isNavigationRailExpand.value);
            },
          ),
          _buildRight(),
        ]));
  }

  onPressed() {}

  void onPageChanged(int value) {
    _selectIndex.value = value;
  }

  Widget _buildLeftNavigation({int selectedIndex = 0, bool extended = false}) {
    final openIcon = extended ? Icon(Icons.menu_open) : Icon(Icons.menu);
    return NavigationRail(
      leading: IconButton(
        icon: openIcon,
        onPressed: () {
          isNavigationRailExpand.value = !isNavigationRailExpand.value;
        },
      ),
      extended: extended,
      trailing: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: 20.0),
          child: FlutterLogo(),
        ),
      ),

      // trailing: Expanded(
      //   child: Align(
      //     alignment: Alignment.bottomCenter,
      //     child: Padding(
      //       padding: EdgeInsets.only(bottom: 20.0),
      //       child: FlutterLogo(),
      //     ),
      //   ),
      // ),
      onDestinationSelected: onDestinationSelected,
      destinations: destinations,
      selectedIndex: selectedIndex,
    );
  }

  void onDestinationSelected(int value) {
    _controller.jumpToPage(value);
    _selectIndex.value = value;
  }

  _buildRight() {
    return Expanded(
      child: PageView(
        scrollDirection: Axis.vertical,
        controller: _controller,
        onPageChanged: onPageChanged,
        children: destinations
            .map((e) => Container(
                  color: ColorExt.random,
                  child: ListView(
                    controller: _trackingScrollController,
                    children: List.generate(199, (index) => Text("data_$index")),
                    // children: List.generate(299, (index) => TextButton(
                    //   onPressed: () { print("data_${index}"); },
                    //   child: Text("data_${index}"),
                    // )),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
