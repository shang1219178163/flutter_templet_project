//
//  MouseRegionDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/10/21 10:41 AM.
//  Copyright © 12/10/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/util/dlog.dart';

class MouseRegionDemo extends StatefulWidget {

  MouseRegionDemo({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MouseRegionDemoState createState() => _MouseRegionDemoState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }
}

class _MouseRegionDemoState extends State<MouseRegionDemo> {
  int _enterCounter = 0;
  int _exitCounter = 0;
  double x = 0.0;
  double y = 0.0;

  void incrementEnter(PointerEvent details) {
    setState(() {
      _enterCounter++;
    });
  }

  void incrementExit(PointerEvent details) {
    setState(() {
      _exitCounter++;
    });
  }

  void updateLocation(PointerEvent details) {
    setState(() {
      x = details.position.dx;
      y = details.position.dy;
    });
  }

  bool _isVisible = false;
  String? demoTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(demoTitle ?? widget.title ?? "$widget"),
        actions: [
          MouseRegion(
              onEnter: (details) {
                setState(() {
                  setState(() => DLog.d(details));
                  demoTitle = "onEnter";
                  _isVisible = true;
                });
              },
              onExit: (details) {
                setState(() {
                  setState(() => DLog.d(details));
                  demoTitle = "onExit";
                  // _isVisible = false;
                });
              },
              child: Container(
                width: 120,
                height: 44,
                margin: EdgeInsets.only(right: 15),
                // color: Colors.green,
                child: TextButton(
                  onPressed: () {
                    setState(() => DLog.d("鼠标悬浮菜单"));
                    _isVisible = !_isVisible;
                  },
                  child: Center(
                      child: Text(
                    "鼠标悬浮菜单",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  )),
                ),
              ))
        ],
      ),
      // body: buildBody(),
      body: Stack(
        children: [
          // buildBody1(),
          Container(
              // color: Colors.lightBlueAccent,
              ),
          if (_isVisible)
            Positioned(
                right: 15,
                child: Container(
                  width: 120,
                  height: 150,
                  color: Colors.red,
                  child: ListView(
                    children: List.generate(3, (index) => "菜单_$index")
                        .map((e) => ListTile(
                              title: Text(e),
                              onTap: () {
                                setState(() => DLog.d("鼠标悬浮菜单"));
                                _isVisible = !_isVisible;
                              },
                            ))
                        .toList(),
                  ),
                ))
        ],
      ),
    );
  }

  Widget buildBody1() {
    return Container(
      child: MouseRegion(
        onEnter: incrementEnter,
        onHover: updateLocation,
        onExit: incrementExit,
        child: Container(
          color: Colors.lightBlueAccent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('You have entered or exited this box this many times:'),
              Text(
                '$_enterCounter Entries\n$_exitCounter Exits',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                'The cursor is here: (${x.toStringAsFixed(2)}, ${y.toStringAsFixed(2)})',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBody() {
    return ConstrainedBox(
      constraints: BoxConstraints.tight(const Size(300.0, 200.0)),
      child: MouseRegion(
        onEnter: incrementEnter,
        onHover: updateLocation,
        onExit: incrementExit,
        child: Container(
          color: Colors.lightBlueAccent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('You have entered or exited this box this many times:'),
              Text(
                '$_enterCounter Entries\n$_exitCounter Exits',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                'The cursor is here: (${x.toStringAsFixed(2)}, ${y.toStringAsFixed(2)})',
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('x', x));
    properties.add(DoubleProperty('y', y));
    properties.add(StringProperty('demoTitle', demoTitle));
  }
}
