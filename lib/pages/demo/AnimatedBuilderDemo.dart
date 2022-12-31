import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/tween_animated_widget.dart';

class AnimatedBuilderDemo extends StatefulWidget {

  AnimatedBuilderDemo({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _AnimatedBuilderDemoState createState() => _AnimatedBuilderDemoState();
}

class _AnimatedBuilderDemoState extends State<AnimatedBuilderDemo> with SingleTickerProviderStateMixin {

  late Animation<double> animation;
  late AnimationController controller;

  @override
  initState() {
    super.initState();
    controller = AnimationController(duration: Duration(seconds: 2), vsync: this);
    //图片宽高从0变到300
    animation = Tween(begin: 0.0, end: 400.0).animate(controller);
    //启动动画
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: Column(
        children: [
          buildAnimatedBuilder(),
          buildTweenAnimatedWidget(),

        ],
      )
    );
  }

  buildAnimatedBuilder() {
    return AnimatedBuilder(
      animation: animation,
      child: Image.asset("images/bg.png"),
      builder: (BuildContext ctx, child) {
        return Center(
          child: SizedBox(
            height: animation.value,
            width: animation.value,
            child: child,
          ),
        );
      },
    );
  }

  buildTweenAnimatedWidget() {
    return TweenAnimatedWidget<double>(
      tween: Tween(begin: 0, end: 300),
      child: Image.asset("images/bg.png"),
      builder: (BuildContext ctx, child, animation) {
        return Center(
          child: SizedBox(
            height: animation.value,
            width: animation.value,
            child: child,
          ),
        );
      },
    );
  }

}