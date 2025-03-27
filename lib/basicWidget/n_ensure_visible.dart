import 'package:flutter/material.dart';

/// 键盘弹起时确保当前组件可见
class NEnsureVisible extends StatefulWidget {
  const NEnsureVisible({
    super.key,
    this.delayed = kThemeAnimationDuration,
    this.duration = kThemeAnimationDuration,
    this.child = const SizedBox(),
  });

  /// 延迟滚动
  final Duration delayed;

  /// 滚动出现动画时长
  final Duration duration;

  final Widget child;

  @override
  State<NEnsureVisible> createState() => _NEnsureVisibleState();
}

class _NEnsureVisibleState extends State<NEnsureVisible> with WidgetsBindingObserver {
  late Duration delayed = widget.delayed;
  late Duration duration = widget.duration;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    Future.delayed(delayed).then((value) {
      if (!mounted) {
        return;
      }
      Scrollable.ensureVisible(
        context,
        alignment: Alignment.bottomCenter.y,
        duration: duration,
      );
    });

    super.didChangeMetrics();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
