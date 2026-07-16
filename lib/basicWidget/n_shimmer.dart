import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 微光
class NShimmer extends StatefulWidget {
  const NShimmer({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.baseColor = Colors.white54,
    this.highlightColor = Colors.white,
    this.direction = Axis.horizontal,
    this.angle = 0,
  });

  /// 子组件
  final Widget child;

  /// 动画时长
  final Duration duration;

  /// 基础颜色
  final Color baseColor;

  /// 高亮颜色
  final Color highlightColor;

  /// 流动方向
  final Axis direction;

  /// 倾斜角度（度），0 为不倾斜
  final double angle;

  @override
  State<NShimmer> createState() => _NShimmerState();
}

class _NShimmerState extends State<NShimmer> with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant NShimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration || oldWidget.angle != widget.angle) {
      controller
        ..duration = widget.duration
        ..repeat();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      child: widget.child,
      builder: (_, child) {
        final value = controller.value;
        final begin = widget.direction == Axis.horizontal ? Alignment(-2 + value * 4, 0) : Alignment(0, -2 + value * 4);
        final end = widget.direction == Axis.horizontal ? Alignment(value * 4, 0) : Alignment(0, value * 4);
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: begin,
              end: end,
              transform: GradientRotation(widget.angle * math.pi / 180),
              colors: [
                widget.baseColor,
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
                widget.baseColor,
              ],
              stops: const [
                0.35,
                0.45,
                0.50,
                0.55,
                0.65,
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }
}
