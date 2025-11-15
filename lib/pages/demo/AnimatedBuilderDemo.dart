import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/tween_animated_widget.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class AnimatedBuilderDemo extends StatefulWidget {
  const AnimatedBuilderDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _AnimatedBuilderDemoState createState() => _AnimatedBuilderDemoState();
}

class _AnimatedBuilderDemoState extends State<AnimatedBuilderDemo> with SingleTickerProviderStateMixin {
  late AnimationController controller = AnimationController(duration: Duration(seconds: 2), vsync: this);
  //图片宽高从0变到400
  late Animation<double> animation = Tween(begin: 0.0, end: 400.0).animate(controller);

  @override
  initState() {
    super.initState();
    //启动动画
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: [
            'done',
          ]
              .map((e) => TextButton(
                    child: Text(
                      e,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (controller.value == 1) {
                        controller.reverse().orCancel;
                      } else {
                        controller.forward().orCancel;
                      }
                    },
                  ))
              .toList(),
        ),
        body: Column(
          children: [
            buildAnimatedBuilder(),
            buildTweenAnimatedWidget(),
          ]
              .map(
                (e) => Expanded(
                  child: e,
                ),
              )
              .toList(),
        ));
  }

  buildAnimatedBuilder() {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext ctx, child) {
        return Center(
          child: Container(
            color: Colors.green,
            child: SizedBox(
              height: animation.value,
              width: animation.value,
              child: child,
            ),
          ),
        );
      },
      child: Image(image: "bg.png".toAssetImage()),
    );
  }

  buildTweenAnimatedWidget() {
    return TweenAnimatedWidget<double>(
      tween: Tween(begin: 0, end: 300),
      builder: (BuildContext ctx, child, animation) {
        return Center(
          child: Container(
            color: Colors.yellow,
            child: SizedBox(
              height: animation.value,
              width: animation.value,
              child: child,
            ),
          ),
        );
      },
      child: Image(image: "bg.png".toAssetImage()),
    );
  }
}
