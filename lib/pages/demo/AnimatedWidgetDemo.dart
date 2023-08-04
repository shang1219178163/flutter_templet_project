//
//  AnimatedWidgetDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/19/21 9:55 PM.
//  Copyright © 10/19/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class AnimatedWidgetDemo extends StatefulWidget {

  final String? title;

  const AnimatedWidgetDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _AnimatedWidgetDemoState createState() => _AnimatedWidgetDemoState();
}

class _AnimatedWidgetDemoState extends State<AnimatedWidgetDemo> {

  double _padding = 10;
  var _align = Alignment.topRight;
  double _height = 100;
  double _left = 0;
  Color _color = Colors.red;
  TextStyle _style = TextStyle(color: Colors.black);
  // Color _decorationColor = Colors.blue;

  double opacityLevel = 1.0;

  double _size = 100.0;

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    var duration = Duration(seconds: 2);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[

          ElevatedButton(
            onPressed: () {
              setState(() {
                _padding += 10;
              });
            },
            child: AnimatedPadding(
              duration: duration,
              padding: EdgeInsets.all(_padding),
              child: Text("AnimatedPadding"),
            ),
          ),
          SizedBox(
            height: 50,
            child: Stack(
              children: <Widget>[
                AnimatedPositioned(
                  duration: duration,
                  left: _left,
                  child: ElevatedButton(
                    onPressed: () {
                      _left = 100;
                      setState(() {});
                    },
                    child: Text("AnimatedPositioned"),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 100,
            color: Colors.grey,
            child: AnimatedAlign(
              duration: duration,
              alignment: _align,
              child: ElevatedButton(
                onPressed: () {
                  _align = Alignment.center;
                  setState(() {});
                },
                child: Text("AnimatedAlign"),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedOpacity(
                opacity: opacityLevel,
                duration: const Duration(seconds: 3),
                child: const FlutterLogo(size: 80,),
              ),
              ElevatedButton(
                onPressed: (){
                opacityLevel = opacityLevel == 0 ? 1.0 : 0.0;
                setState((){});
              },
              child: const Text('Fade Logo'),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              _size = _size == 100 ? 200.0 : 100.0;
              setState(() {});
            },
            child: ColoredBox(
              color: Colors.amberAccent,
              child: AnimatedSize(
                curve: Curves.easeIn,
                duration: const Duration(milliseconds: 350),
                reverseDuration: const Duration(milliseconds: 350),
                // child: FlutterLogo(size: _size),
                child: Container(
                  color: Colors.green,
                  width: 200,
                  height: _size,
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: duration,
            height: _height,
            color: _color,
            child: TextButton(
              onPressed: () {
                _height = 150;
                _color = Colors.blue;
                setState(() {});
              },
              child: Text(
                "AnimatedContainer",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          AnimatedDefaultTextStyle(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _style = TextStyle(
                    color: Colors.blue,
                    decorationStyle: TextDecorationStyle.solid,
                    decorationColor: Colors.blue,
                  );
                });
              },
              child: Text("hello world"),
            ),
            style: _style,
            duration: duration,
          ),
          // AnimatedDecoratedBox(
          //   duration: duration,
          //   decoration: BoxDecoration(color: _decorationColor),
          //   child: TextButton(
          //     onPressed: () {
          //       setState(() {
          //         _decorationColor = Colors.red;
          //       });
          //     },
          //     child: Text(
          //       "AnimatedDecoratedBox",
          //       style: TextStyle(color: Colors.white),
          //     ),
          //   ),
          // )
        ].map((e) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: e,
          );
        }).toList(),
      ),
    );
  }
}



class AnimatedDecoratedBox extends ImplicitlyAnimatedWidget {
  const AnimatedDecoratedBox({
    Key? key,
    required this.decoration,
    required this.child,
    Curve curve = Curves.linear,
    required Duration duration,
  }) : super(
    key: key,
    curve: curve,
    duration: duration,
  );
  final BoxDecoration decoration;
  final Widget child;

  @override
  _AnimatedDecoratedBoxState createState() => _AnimatedDecoratedBoxState();
}

class _AnimatedDecoratedBoxState extends AnimatedWidgetBaseState<AnimatedDecoratedBox> {
  late DecorationTween _decoration; //定义一个Tween

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: _decoration.evaluate(animation),
      child: widget.child,
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    // 在需要更新Tween时，基类会调用此方法
    // ignore: cast_nullable_to_non_nullable
    _decoration = visitor(
      _decoration,
      widget.decoration,
      (value) => DecorationTween(begin: value),
    ) as DecorationTween;
  }
}
