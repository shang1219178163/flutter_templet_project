import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';

class BuilderDemo extends StatefulWidget {
  final String? title;

  const BuilderDemo({Key? key, this.title}) : super(key: key);

  @override
  _BuilderDemoState createState() => _BuilderDemoState();
}

class _BuilderDemoState extends State<BuilderDemo> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 10),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBox(String title) {
    return Container(
      width: 150.0,
      height: 50.0,
      color: Colors.green,
      child: Center(
        child: Text(title),
      ),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        NSectionBox(
          title: "AnimatedBuilder",
          child: AnimatedBuilder(
            animation: _controller,
            child: buildBox('AnimatedBuilder'),
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2.0 * math.pi,
                child: child,
              );
            },
          ),
        ),
        NSectionBox(
          title: "AnimatedBuilder",
          child: AnimatedBuilder(
            animation: _controller,
            child: buildBox('AnimatedBuilder'),
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2.0 * math.pi,
                child: child,
              );
            },
          ),
        ),

        NSectionBox(
          title: 'Builder/约等于 StatelessWidget',
          child: AnimatedBuilder(
            animation: _controller,
            child: buildBox('AnimatedBuilder'),
            builder: (context, child) {
              return Builder(
                builder: (context) {
                  return buildBox('Builder');
                },
              );
            },
          ),
        ),

        NSectionBox(
          title: 'Builder/约等于 StatelessWidget',
          child: AnimatedBuilder(
            animation: _controller,
            child: buildBox('AnimatedBuilder'),
            builder: (context, child) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return buildBox('StatefulBuilder');
                },
              );
            },
          ),
        ),

        // FadeUpwardsPageTransitionsBuilder(),
        // CupertinoPageTransitionsBuilder(),
        // FadeUpwardsPageTransitionsBuilder(),
        // CupertinoPageTransitionsBuilder(),
        // FadeUpwardsPageTransitionsBuilder(),
      ],
    );
  }
}
