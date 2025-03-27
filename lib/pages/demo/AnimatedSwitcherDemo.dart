//
//  AnimatedSwitcherDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/19/21 10:08 PM.
//  Copyright © 10/19/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_menu_anchor.dart';
import 'package:flutter_templet_project/basicWidget/n_slide_transition.dart';
import 'package:flutter_templet_project/extension/dlog.dart';

class AnimatedSwitcherDemo extends StatefulWidget {
  final String? title;

  const AnimatedSwitcherDemo({Key? key, this.title}) : super(key: key);

  @override
  _AnimatedSwitcherDemoState createState() => _AnimatedSwitcherDemoState();
}

class _AnimatedSwitcherDemoState extends State<AnimatedSwitcherDemo> {
  int _count = 0;

  final selectedItemVN = ValueNotifier(AxisDirection.up);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    final child = Text(
      '第 $_count 相很长长长',
      //显示指定key，不同的key会被认为是不同的Text，这样才能执行动画
      key: ValueKey<int>(_count),
      style: Theme.of(context).textTheme.titleMedium,
    );

    return Scrollbar(
      child: ListView(
        children: [
          UnconstrainedBox(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: NMenuAnchor<AxisDirection>(
                values: AxisDirection.values,
                initialItem: selectedItemVN.value,
                cbName: (e) => e?.name ?? "请选择",
                equal: (a, b) => a == b,
                onChanged: (e) {
                  debugPrint(e.name);
                  selectedItemVN.value = e;
                  setState(() {});
                },
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            child: child,
            transitionBuilder: (Widget child, Animation<double> animation) {
              // var tween = Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0));

              // return ScaleTransition(scale: animation, child: child);
              return NSlideTransition(
                direction: selectedItemVN.value, //上入下出
                position: animation,
                child: child,
              );
            },
          ),
          OutlinedButton(
            onPressed: () {
              _count += 1;
              setState(() {});
            },
            child: const Text('+1'),
          ),
        ],
      ),
    );
  }
}

///移动动画
class LineSlideTransition extends AnimatedWidget {
  const LineSlideTransition({
    Key? key,
    required Animation<Offset> position,
    this.transformHitTests = true,
    required this.child,
  }) : super(key: key, listenable: position);

  final bool transformHitTests;

  final Widget child;

  Animation<Offset> get _position => listenable as Animation<Offset>;

  @override
  Widget build(BuildContext context) {
    var offset = _position.value;
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
