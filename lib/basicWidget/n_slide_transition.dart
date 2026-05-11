//
//  NSlideTransition.dart
//  flutter_templet_project
//
//  Created by shang on 2024/5/10 12:26.
//  Copyright © 2024/5/10 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';

///移动动画
class NSlideTransition extends AnimatedWidget {
  NSlideTransition({
    Key? key,
    required Animation<double> position,
    this.transformHitTests = true,
    this.direction = AxisDirection.down,
    required this.child,
  }) : super(key: key, listenable: position) {
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
    // DLog.d("_tween: ${_tween.begin},${_tween.end}");
  }

  final bool transformHitTests;

  //退场（出）方向
  final AxisDirection direction;

  final Widget child;

  late final Tween<Offset> _tween;

  Animation<double> get _position => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    var offset = _tween.evaluate(_position);
    if (_position.status == AnimationStatus.reverse) {
      offset = Offset(-offset.dx, -offset.dy);
    }

    return FractionalTranslation(
      translation: offset,
      transformHitTests: transformHitTests,
      child: child,
    );
  }
}
