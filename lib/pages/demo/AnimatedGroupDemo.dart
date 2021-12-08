//
//  AnimatedGroupDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/6/21 5:52 PM.
//  Copyright © 12/6/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class AnimatedGroupWidget extends StatelessWidget {

  late Animation<double> controller;
  late Animation<double> aHeight;
  late Animation<EdgeInsets> aPadding;
  late ColorTween aColor;
  
  AnimatedGroupWidget({
  	Key? key,
  	required this.controller,
  }) : super(key: key){
    aHeight = Tween<double>(begin: 0.0, end: 300.0).animate(_buildCurvedAnimation(0, 0.6));
    aPadding = Tween<EdgeInsets>(begin: EdgeInsets.only(left: .0), end: EdgeInsets.only(left: 100.0)).animate(_buildCurvedAnimation(0.6, 1.0));
    aColor = ColorTween(begin: Colors.green, end: Colors.red);
  }

  _buildCurvedAnimation(double begin, double end) {
    return
    CurvedAnimation(
      parent: controller,
      curve: Interval(
        begin, end, //间隔，前60%的动画时间
        curve: Curves.ease,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child){
        return Container(
          alignment: Alignment.bottomCenter,
          padding: aPadding.value,
            child: Container(
              // color: aColor.value,
              width: 50,
              height: aHeight.value,
            ),
        );
      });
    }
}



class AnimatedGroupDemo extends StatefulWidget {

  final String? title;

  AnimatedGroupDemo({ Key? key, this.title}) : super(key: key);


  @override
  _AnimatedGroupDemoState createState() => _AnimatedGroupDemoState();
}

class _AnimatedGroupDemoState extends State<AnimatedGroupDemo> with TickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    _controller = new AnimationController(duration:Duration(milliseconds: 2000), vsync: this);
    // TODO: implement initState
    super.initState();
  }

  _palyeAnimation() async {
    try {
      await _controller.forward().orCancel;
      await _controller.reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    };
  }


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
                  _palyeAnimation();
                },
              ),
              Container(
                width: 300,
                height: 300,
                child: AnimatedGroupWidget(controller: _controller,),
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
