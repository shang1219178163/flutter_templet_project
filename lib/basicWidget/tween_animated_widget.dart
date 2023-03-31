

import 'package:flutter/material.dart';

typedef TweenAnimatedBuilder<T extends Object?> = Widget Function(BuildContext context, Widget? child, Animation<T> animation);
///自定义动画组件
class TweenAnimatedWidget<T extends Object?> extends StatefulWidget {

  TweenAnimatedWidget({
    Key? key,
    this.duration = const Duration(seconds: 2),
    required this.tween,
    this.child,
    required this.builder,
  }) : super(key: key);

  Duration? duration;

  Tween<T> tween;

  Widget? child;

  TweenAnimatedBuilder<T> builder;

  @override
  _TweenAnimatedWidgetState<T> createState() => _TweenAnimatedWidgetState<T>();
}

class _TweenAnimatedWidgetState<T extends Object?> extends State<TweenAnimatedWidget<T>> with SingleTickerProviderStateMixin {
  late Animation<T> animation;
  late AnimationController controller;

  @override
  initState() {
    super.initState();
    controller = AnimationController(duration: widget.duration, vsync: this);
    //图片宽高从0变到300
    animation = widget.tween.animate(controller);
    //启动动画
    controller.forward();
  }

  @override
  dispose() {
    //路由销毁时需要释放动画资源
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext ctx, child) {
        return widget.builder(ctx, child, animation);
      },
      child: widget.child,
    );
  }

}