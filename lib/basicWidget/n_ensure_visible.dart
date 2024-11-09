import 'package:flutter/material.dart';

/// 键盘弹起时确保当前组件可见
class NEnsureVisible extends StatefulWidget {
  const NEnsureVisible({
    super.key,
    this.child = const SizedBox(),
  });

  final Widget child;

  @override
  State<NEnsureVisible> createState() => _NEnsureVisibleState();
}

class _NEnsureVisibleState extends State<NEnsureVisible> with WidgetsBindingObserver {
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
  void didUpdateWidget(covariant NEnsureVisible oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      setState(() {});
    }
  }

  @override
  void didChangeMetrics() {
    Future.delayed(kThemeAnimationDuration).then((value) {
      Scrollable.ensureVisible(
        context,
        alignment: Alignment.bottomCenter.y,
        duration: kThemeAnimationDuration,
      );
    });

    super.didChangeMetrics();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
