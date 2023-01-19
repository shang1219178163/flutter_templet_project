//
//  AnimatedGroupDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/6/21 5:52 PM.
//  Copyright © 12/6/21 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/animated_group.dart';

class AnimatedGroupDemo extends StatefulWidget {
  AnimatedGroupDemo({ Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _AnimatedGroupDemoState createState() => _AnimatedGroupDemoState();
}

class _AnimatedGroupDemoState extends State<AnimatedGroupDemo> {

  GlobalKey<AnimatedGroupState> _globalKey = GlobalKey();

  final _animations = <AnimatedGroupItemModel>[
    AnimatedGroupItemModel(
      tween: Tween<double>(begin: .0, end: 300.0,),
      begin: 0.0,
      end: 0.6
    ),
    AnimatedGroupItemModel(
      tween: ColorTween(begin: Colors.green, end: Colors.red,),
      begin: 0.0,
      end: 0.6
    ),
    AnimatedGroupItemModel(
      tween: Tween<EdgeInsets>(
        begin: const EdgeInsets.only(left: .0),
        end: const EdgeInsets.only(left: 100.0),
      ),
      begin: 0.6,
      end: 1.0
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: Text("start animation"),
              onPressed: (){
                _globalKey.currentState?.palyeAnimations(isRemovedOnCompletion: false);
              },
            ),
            Container(
              width: 300,
              height: 300,
              child: AnimatedGroup(
                key: _globalKey,
                duration: Duration(milliseconds: 2000),
                animations: _animations,
                child: Text("AnimatedGroup 混合动画", style: TextStyle(color: Colors.white, backgroundColor: Colors.green),),
                builder: (BuildContext context, Widget? child, List<Animation<dynamic>> animations) {
                  final aHeight = animations[0];
                  final aColor = animations[1];
                  final aPadding = animations[2];

                  return Stack(
                    children: [
                      Container(
                        alignment: Alignment.bottomCenter,
                        padding: aPadding.value,
                        child: Container(
                          color: aColor.value,
                          width: 50.0,
                          height: aHeight.value,
                        ),
                      ),
                      Center(child: child!)
                    ],
                  );
                },
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                border: Border.all(
                  color: Colors.black.withOpacity(0.5),
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}
