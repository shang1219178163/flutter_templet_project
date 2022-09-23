//
//  MouseRegionDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/10/21 10:41 AM.
//  Copyright © 12/10/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';


class MouseRegionDemo extends StatefulWidget {

  String? title;

  MouseRegionDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _MouseRegionDemoState createState() => _MouseRegionDemoState();
}

class _MouseRegionDemoState extends State<MouseRegionDemo> {
  int _enterCounter = 0;
  int _exitCounter = 0;
  double x = 0.0;
  double y = 0.0;

  void _incrementEnter(PointerEvent details) {
    setState(() {
      _enterCounter++;
    });
  }

  void _incrementExit(PointerEvent details) {
    setState(() {
      _exitCounter++;
    });
  }

  void _updateLocation(PointerEvent details) {
    setState(() {
      x = details.position.dx;
      y = details.position.dy;
    });
  }


  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: [
            MouseRegion(
              onEnter: (PointerEvent details) {
                setState(() {
                  setState(() => ddlog(details));
                  widget.title = "onEnter";
                  _isVisible = true;
                });
              },
              onExit: (PointerEvent details) {
                setState(() {
                  setState(() => ddlog(details));
                  widget.title = "onExit";
                  // _isVisible = false;
                });
              },
              child: Container(
                width: 120,
                height: 44,
                margin: EdgeInsets.only(right: 15),
                // color: Colors.green,
                child: TextButton(
                  child: Center(
                      child: Text("鼠标悬浮菜单", style: TextStyle(fontSize: 15, color: Colors.white),)
                  ),
                  onPressed: (){
                    setState(() => ddlog("鼠标悬浮菜单"));
                    _isVisible = !_isVisible;
                  },
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
            if (_isVisible) Positioned(
                right: 15,
                child: Container(
                  width: 120,
                  height: 150,
                  color: Colors.red,
                  child: ListView(
                    children: List.generate(3, (index) => "菜单_$index").map((e) => ListTile(title: Text(e), onTap: (){
                      setState(() => ddlog("鼠标悬浮菜单"));
                      _isVisible = !_isVisible;
                    },)).toList(),
                  ),
                )
            )
          ],
        ),

    );
  }

  Widget buildBody1() {
    return Container(
      child: MouseRegion(
        onEnter: _incrementEnter,
        onHover: _updateLocation,
        onExit: _incrementExit,
        child: Container(
          color: Colors.lightBlueAccent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('You have entered or exited this box this many times:'),
              Text('$_enterCounter Entries\n$_exitCounter Exits',
                style: Theme.of(context).textTheme.headline4,
              ),
              Text('The cursor is here: (${x.toStringAsFixed(2)}, ${y.toStringAsFixed(2)})',
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
        onEnter: _incrementEnter,
        onHover: _updateLocation,
        onExit: _incrementExit,
        child: Container(
          color: Colors.lightBlueAccent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('You have entered or exited this box this many times:'),
              Text('$_enterCounter Entries\n$_exitCounter Exits',
                style: Theme.of(context).textTheme.headline4,
              ),
              Text('The cursor is here: (${x.toStringAsFixed(2)}, ${y.toStringAsFixed(2)})',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
