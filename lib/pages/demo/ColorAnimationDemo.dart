import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_blinking_text.dart';
import 'package:flutter_templet_project/basicWidget/n_color_Animation.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/util/app_color.dart';
import 'package:get/get.dart';

class ColorAnimationDemo extends StatefulWidget {
  const ColorAnimationDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<ColorAnimationDemo> createState() => _ColorAnimationDemoState();
}

class _ColorAnimationDemoState extends State<ColorAnimationDemo> {
  final scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  final List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.blue, // 回到起始颜色形成循环
  ];

  @override
  void didUpdateWidget(covariant ColorAnimationDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NColorAnimation(
              colors: [
                Colors.transparent,
                Colors.red,
                Colors.green,
                Colors.orange,
                Colors.purple,
              ],
              builder: (bgColor, anim) {
                return Container(
                  width: 200,
                  height: 100,
                  color: bgColor,
                  child: Center(
                    child: Text(
                      '自定义颜色动画',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                );
              },
            ),
            TweenSequenceColorAnimation(
              colors: [
                Colors.transparent,
                Colors.red,
                Colors.green,
                Colors.orange,
                Colors.purple,
              ],
              builder: (bgColor, anim) {
                return Container(
                  width: 200,
                  height: 100,
                  color: bgColor,
                  child: Center(
                    child: Text(
                      '自定义颜色动画',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                );
              },
            ),
            NBlinkingText(
              text: 'Flutter 呼吸灯文字',
            ),
          ],
        ),
      ),
    );
  }
}

class TweenSequenceColorAnimation extends StatefulWidget {
  const TweenSequenceColorAnimation({
    super.key,
    required this.colors,
    this.duration = const Duration(seconds: 3),
    required this.builder,
  });

  final List<Color> colors;
  final Duration? duration;
  final Widget Function(Color? color, Animation<Color?> anim) builder;

  @override
  _TweenSequenceColorAnimationState createState() => _TweenSequenceColorAnimationState();
}

class _TweenSequenceColorAnimationState extends State<TweenSequenceColorAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;

  late List<Color> colors = widget.colors;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _setupTweenSequence();
    _controller.repeat();
  }

  void _setupTweenSequence() {
    List<TweenSequenceItem<Color?>> items = [];

    for (int i = 0; i < colors.length - 1; i++) {
      items.add(
        TweenSequenceItem<Color?>(
          weight: 1.0,
          tween: ColorTween(begin: colors[i], end: colors[i + 1]),
        ),
      );
    }

    _animation = TweenSequence<Color?>(items).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final color = _animation.value;
        return widget.builder(color, _animation);
        return Container(
          width: 200,
          height: 200,
          color: _animation.value,
          child: Center(
            child: Text(
              '多颜色序列动画',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        );
      },
    );
  }
}
