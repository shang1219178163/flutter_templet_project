import 'dart:math';

import 'package:flutter/material.dart';

class SelectedRedPacketWidget extends StatefulWidget {
  const SelectedRedPacketWidget({
    super.key,
    required this.from,
    required this.size,
    this.child,
    required this.onFinish,
  });

  final Offset from; // 起始点（点击时）
  final double size; // 原始大小
  final Widget? child;
  final VoidCallback onFinish;

  @override
  State<SelectedRedPacketWidget> createState() => _SelectedRedPacketWidgetState();
}

class _SelectedRedPacketWidgetState extends State<SelectedRedPacketWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<Offset> _position;
  late final Animation<double> _scale;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    onForward();
  }

  void onForward() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    final screen = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    final center = Offset(
      screen.width / 2 - widget.size / 2,
      screen.height / 2 - widget.size / 2,
    );

    _position = Tween<Offset>(
      begin: widget.from,
      end: center,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _scale = Tween<double>(
      begin: 1.0,
      end: 3,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward().whenComplete(_requestResult);
  }

  /// ③ 网络请求
  Future<void> _requestResult() async {
    // 👉 这里换成真实接口
    await Future.delayed(const Duration(seconds: 2));
    _controller.stop();

    final win = Random().nextBool();
    final resultText = win ? '🎉 恭喜中奖！' : '😢 未中奖';
    debugPrint([runtimeType, resultText].join(", "));
    widget.onFinish();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform.translate(
          offset: _position.value,
          child: Transform.scale(
            scale: _scale.value,
            child: child,
          ),
        );
      },
      child: RepaintBoundary(
        child: widget.child ??
            Image(
              image: AssetImage('assets/images/icon_lucky_bag.png'),
              width: widget.size,
              height: widget.size,
            ),
      ),
    );
  }
}
