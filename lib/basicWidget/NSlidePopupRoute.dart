import 'package:flutter/material.dart';

/// 最新滑入弹窗
class NSlidePopupRoute<T> extends PopupRoute<T> {
  NSlidePopupRoute({
    required this.builder,
    this.from = Alignment.bottomCenter,
    this.barrierColor = const Color(0x80000000),
    this.barrierDismissible = true,
    this.duration = const Duration(milliseconds: 300),
    this.barrierLabel,
    this.curve = Curves.easeOutCubic,
  });

  final WidgetBuilder builder;

  /// 从哪个方向进入（推荐：topCenter / bottomCenter / centerLeft / centerRight）
  final Alignment from;

  final Duration duration;
  final Curve curve;

  @override
  final bool barrierDismissible;

  @override
  final Color barrierColor;

  @override
  final String? barrierLabel;

  @override
  Duration get transitionDuration => duration;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // 直接返回背景和内容，不应用动画
    return Material(
      color: barrierColor,
      child: const SizedBox.expand(), // 只负责背景
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final content = builder(context);

    // ⭐ 中心弹窗：Fade
    if (from == Alignment.center) {
      return FadeTransition(
        opacity: animation.drive(
          CurveTween(curve: Curves.easeOut),
        ),
        child: content,
      );
    }

    // ⭐ 其余方向：Slide
    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(
          begin: _alignmentToOffset(from),
          end: Offset.zero,
        ).chain(
          CurveTween(curve: curve),
        ),
      ),
      child: content,
    );
  }

  /// Alignment → Offset（关键点）
  Offset _alignmentToOffset(Alignment alignment) {
    return Offset(
      alignment.x.sign,
      alignment.y.sign,
    );
  }
}
