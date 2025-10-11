import 'package:flutter/material.dart';

class NColorAnimation extends StatefulWidget {
  const NColorAnimation({
    super.key,
    required this.colors,
    this.duration = const Duration(seconds: 3),
    required this.builder,
  });

  final List<Color> colors;
  final Duration? duration;
  final Widget Function(Color color, Animation<double> anim) builder;

  @override
  _NColorAnimationState createState() => _NColorAnimationState();
}

class _NColorAnimationState extends State<NColorAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;

  late final List<Color> _colors = widget.colors;

  // final List<Color> colors = [
  //   Colors.blue,
  //   Colors.red,
  //   Colors.green,
  //   Colors.orange,
  //   Colors.purple,
  // ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? Duration(seconds: 3),
      vsync: this,
    );
    _anim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.repeat(reverse: true);
  }

  Color _getCurrentColor() {
    int segmentCount = _colors.length - 1;
    double segmentValue = _anim.value * segmentCount;
    int currentSegment = segmentValue.floor();
    double progress = segmentValue - currentSegment;

    if (currentSegment >= _colors.length - 1) {
      return _colors.last;
    }

    return Color.lerp(
      _colors[currentSegment],
      _colors[currentSegment + 1],
      progress,
    )!;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) {
        final color = _getCurrentColor();
        return widget.builder(color, _anim);
        return Container(
          width: 200,
          height: 200,
          color: _getCurrentColor(),
          child: Center(
            child: Text(
              '自定义颜色动画',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        );
      },
    );
  }
}
