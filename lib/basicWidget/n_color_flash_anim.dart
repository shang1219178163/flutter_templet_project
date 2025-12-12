import 'package:flutter/material.dart';

/// 颜色闪烁动画
class NColorFlashAnim extends StatefulWidget {
  const NColorFlashAnim({
    super.key,
    this.controller,
    this.tween,
    required this.builder,
    this.duration = const Duration(milliseconds: 800),
    this.repeatCount = 2,
    this.onFinish,
  });

  final NColorFlashAnimController? controller;

  final ColorTween? tween;

  final Duration duration;

  /// -1：无限循环；>=0：循环次数
  final int repeatCount;

  final VoidCallback? onFinish;

  // final Widget child;
  final AnimatedBuilder Function(AnimationController animationController, Animation<Color?> animation) builder;

  @override
  State<NColorFlashAnim> createState() => _NColorFlashAnimState();
}

class _NColorFlashAnimState extends State<NColorFlashAnim> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnim;
  int _currentCount = 0;
  int get currentCount => _currentCount;

  bool isRunning = false;

  late ColorTween tween = widget.tween ?? ColorTween(begin: Colors.transparent, end: Colors.red);

  @override
  void dispose() {
    widget.controller?._detach(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(this);

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _colorAnim = tween.animate(_controller);

    _controller.addStatusListener((status) {
      if (!isRunning) {
        return;
      }

      if (status == AnimationStatus.completed) {
        _currentCount++;
        if (widget.repeatCount == -1 || _currentCount < widget.repeatCount) {
          _controller.reverse();
        } else {
          isRunning = false;
        }
      } else if (status == AnimationStatus.dismissed) {
        if (isRunning) {
          _controller.forward();
        }
      }
    });
  }

  void startAnim() {
    if (isRunning) {
      return;
    }
    _currentCount = 0;
    isRunning = true;
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_controller, _colorAnim);
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        var color = _colorAnim.value ?? Colors.transparent;
        if (_controller.isCompleted) {
          color = Colors.transparent;
        }
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: color,
              width: 3,
            ),
          ),
          child: GestureDetector(
            onTap: startAnim,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text("NColorAnim_$currentCount, $isRunning"),
            ),
          ),
        );
      },
    );
  }
}

class NColorFlashAnimController {
  _NColorFlashAnimState? _anchor;

  VoidCallback? _startAnim;

  void _attach(_NColorFlashAnimState anchor) {
    _anchor = anchor;
  }

  void _detach(_NColorFlashAnimState anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }

  void startAnim() {
    _anchor?.startAnim();
  }

  int get currentCount => _anchor?.currentCount ?? 0;
}
