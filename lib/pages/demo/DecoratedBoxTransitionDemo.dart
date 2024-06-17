//
//  DecoratedBoxTransitionDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/6/17 12:17.
//  Copyright © 2024/6/17 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 装饰器动画
class DecoratedBoxTransitionDemo extends StatefulWidget {
  const DecoratedBoxTransitionDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<DecoratedBoxTransitionDemo> createState() =>
      _DecoratedBoxTransitionDemoState();
}

class _DecoratedBoxTransitionDemoState extends State<DecoratedBoxTransitionDemo>
    with SingleTickerProviderStateMixin {
  late final ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2000),
  );
  late Animation<Decoration> animation;

  @override
  void initState() {
    super.initState();
    onChangeDecoration();

    ctrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        ctrl.reverse();
      }
      if (status == AnimationStatus.dismissed) {
        ctrl.forward();
      }
    });

    ctrl.forward();
  }

  @override
  void dispose() {
    ctrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
        actions: [
          TextButton(
            onPressed: onChangeDecoration,
            child: Text(
              "reset",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return GestureDetector(
      onTap: _startAnim,
      child: AnimatedBuilder(
        animation: ctrl,
        builder: (_, __) {
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DecoratedBoxTransition(
                  decoration: animation,
                  child: const Icon(
                    Icons.ac_unit,
                    color: Colors.white,
                    size: 80,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void onChangeDecoration() {
    animation = DecorationTween(
      begin: buildDecoration(
        color: Colors.deepPurple,
        radius: 60,
        blurRadius: 5,
        spreadRadius: 2,
      ),
      end: buildDecoration(
        color: Colors.blue,
        radius: 60,
        blurRadius: 15,
        spreadRadius: 6,
      ),
    ).animate(ctrl);
  }

  BoxDecoration buildDecoration({
    required Color color,
    double radius = 60,
    double blurRadius = 10,
    double spreadRadius = 0,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      boxShadow: [
        BoxShadow(
          offset: Offset(1, 1),
          color: color,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        )
      ],
    );
  }

  void _startAnim() {
    ctrl.reset();
    ctrl.forward();
  }
}
