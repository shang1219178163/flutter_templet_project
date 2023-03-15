//
//  AnimatedContainerDemo.dart
//  flutter_templet_project
//
//  Created by shang on 3/15/23 12:19 PM.
//  Copyright © 3/15/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/change_notifier_ext.dart';


class AnimatedContainerDemo extends StatefulWidget {

  AnimatedContainerDemo({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _AnimatedContainerDemoState createState() => _AnimatedContainerDemoState();
}

class _AnimatedContainerDemoState extends State<AnimatedContainerDemo> {

  final sizeStart = Size(200, 200);
  final sizeEnd = Size(400, 400);

  final _width = 0.vn;
  final _height = 0.vn;
  final _alignment = Alignment.topLeft.vn;
  final _color = Colors.lightBlue.vn;

  @override
  void initState() {
    _width.value = sizeStart.width;
    _height.value = sizeStart.height;

    // TODO: implement initState
    super.initState();
  }

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
          onPressed: onPressed,
        )).toList(),
      ),
      body: buildBody()
    );
  }

  Widget buildBody() {
    return Center(
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          ElevatedButton(
            child: const Text('更新宽高'),
            onPressed: _changeSize,
          ),
          const SizedBox(height: 10,),
          buildAnimatedContainer(),
        ],
      ),
    );
  }

  Widget buildAnimatedContainer() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _width,
        _height,
        _color,
        _alignment,
      ]),
      builder: (context, child) {

        return AnimatedContainer(
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
          width: _width.value.toDouble(),
          height: _height.value.toDouble(),
          color: _color.value,
          alignment: _alignment.value,
          onEnd: onEnd,
          child: TextButton(
            onPressed: () { print("AnimatedContainer"); },
            child: Text("AnimatedContainer", style: TextStyle(color: Colors.white),),
          ),
        );
      }
    );
  }

  void onEnd() {
    print('End');
  }

  onPressed(){
    _changeSize();
  }

  void _changeSize() {
    _width.value = _width.value == sizeStart.width ? sizeEnd.width : sizeStart.width;
    _height.value = _height.value == sizeStart.height ? sizeEnd.height : sizeStart.height;
    _color.value = _color.value == Colors.green ? Colors.lightBlue : Colors.green;
    _alignment.value = _alignment.value == Alignment.topLeft ? Alignment.center : Alignment.topLeft;
  }
}


