//
//  AnimatedSwitcherDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/19/21 10:08 PM.
//  Copyright © 10/19/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class AnimatedSwitcherDemo extends StatefulWidget {

  final String? title;

  AnimatedSwitcherDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _AnimatedSwitcherDemoState createState() => _AnimatedSwitcherDemoState();
}

class _AnimatedSwitcherDemoState extends State<AnimatedSwitcherDemo> {
  int _count = 0;

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
    return ListView(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            //执行缩放动画
            return ScaleTransition(child: child, scale: animation);
          },
          child: Text(
            '$_count',
            //显示指定key，不同的key会被认为是不同的Text，这样才能执行动画
            key: ValueKey<int>(_count),
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        // AnimatedSwitcher(
        //   duration: Duration(milliseconds: 200),
        //   transitionBuilder: (Widget child, Animation<double> animation) {
        //     var tween=Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0));
        //     return SlideTransitionX(
        //       child: child,
        //       direction: AxisDirection.down, //上入下出
        //       position: animation,
        //     );
        //   },
        // ),
        // AnimatedSwitcher(
        //   duration: Duration(milliseconds: 200),
        //   transitionBuilder: (Widget child, Animation<double> animation) {
        //     var tween = Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0));
        //     return MySlideTransition(
        //       child: child,
        //       position: tween.animate(animation),
        //     );
        //   },
        // ),
        OutlinedButton(
          child: const Text('+1',),
          onPressed: () {
            _count += 1;
            setState(() {});
          },
        ),
      ],
    );
  }
}

///非对称滑动
class MySlideTransition extends AnimatedWidget {
  MySlideTransition( {
    Key? key,
    required this.position,
    this.transformHitTests = true,
    required this.child,
  }) : super(key: key, listenable: position) ;

  // Animation<Offset> get position => listenable as Animation<Offset>;

  final Animation<Offset> position;

  final bool transformHitTests;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Animation<Offset> _position = listenable as Animation<Offset>;

    Offset offset = position.value;
    //动画反向执行时，调整x偏移，实现“从左边滑出隐藏”
    if (position.status == AnimationStatus.reverse) {
      offset = Offset(-offset.dx, offset.dy);
    }
    return FractionalTranslation(
      translation: offset,
      transformHitTests: transformHitTests,
      child: child,
    );
  }
}



///移动动画
class SlideTransitionX extends AnimatedWidget {
  SlideTransitionX({
    Key? key,
    required Animation<double> position,
    this.transformHitTests = true,
    this.direction = AxisDirection.down,
    required this.child,
  })
      : assert(position != null),
        super(key: key, listenable: position) {
    // 偏移在内部处理
    switch (direction) {
      case AxisDirection.up:
        _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));
        break;
      case AxisDirection.right:
        _tween = Tween(begin: Offset(-1, 0), end: Offset(0, 0));
        break;
      case AxisDirection.down:
        _tween = Tween(begin: Offset(0, -1), end: Offset(0, 0));
        break;
      case AxisDirection.left:
        _tween = Tween(begin: Offset(1, 0), end: Offset(0, 0));
        break;
    }
  }


  Animation<double> get position => listenable as Animation<double>;

  final bool transformHitTests;

  final Widget child;

  //退场（出）方向
  final AxisDirection direction;

  late final Tween<Offset> _tween;

  @override
  Widget build(BuildContext context) {
    Offset offset = _tween.evaluate(position);
    if (position.status == AnimationStatus.reverse) {
      offset = Offset(-offset.dx, -offset.dy);
    }
    return FractionalTranslation(
      translation: offset,
      transformHitTests: transformHitTests,
      child: child,
    );
  }
}



///移动动画
class LineSlideTransition extends AnimatedWidget {
  LineSlideTransition({
    Key? key,
    required Animation<Offset> position,
    this.transformHitTests = true,
    this.direction = AxisDirection.down,
    required this.child,
  })
      : assert(position != null),
        super(key: key, listenable: position);

  Animation<Offset> get position => listenable as Animation<Offset>;

  final bool transformHitTests;

  final Widget child;

  //退场（出）方向
  final AxisDirection direction;

  late final Tween<Offset> _tween;

  @override
  Widget build(BuildContext context) {
    Offset offset = position.value;
    if (position.status == AnimationStatus.reverse) {
      offset = Offset(-offset.dx, -offset.dy);
    }
    return FractionalTranslation(
      translation: offset,
      transformHitTests: transformHitTests,
      child: child,
    );
  }
}

