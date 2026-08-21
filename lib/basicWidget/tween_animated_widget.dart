import 'package:flutter/material.dart';

typedef TweenAnimatedBuilder<T extends Object?> = Widget Function(
    BuildContext context, Widget? child, Animation<T> animation);

///自定义动画组件
class TweenAnimatedWidget<T extends Object?> extends StatefulWidget {
  TweenAnimatedWidget({
    super.key,
    this.duration = const Duration(seconds: 2),
    required this.tween,
    this.child,
    required this.builder,
  });

  final Duration? duration;

  final Tween<T> tween;

  final Widget? child;

  final TweenAnimatedBuilder<T> builder;

  @override
  _TweenAnimatedWidgetState<T> createState() => _TweenAnimatedWidgetState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Duration?>('duration', duration));
    properties.add(DiagnosticsProperty<Tween<T>>('tween', tween));
    properties.add(ObjectFlagProperty<TweenAnimatedBuilder<T>>.has('builder', builder));
  }
}

class _TweenAnimatedWidgetState<T extends Object?> extends State<TweenAnimatedWidget<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController controller = AnimationController(duration: widget.duration, vsync: this);
  late Animation<T> animation = widget.tween.animate(controller);

  @override
  initState() {
    super.initState();
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
      builder: (ctx, child) {
        return widget.builder(ctx, child, animation);
      },
      child: widget.child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AnimationController>('controller', controller));
    properties.add(DiagnosticsProperty<Animation<T>>('animation', animation));
  }
}
