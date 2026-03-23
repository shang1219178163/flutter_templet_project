import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaggeredAnimationDemo extends StatefulWidget {
  const StaggeredAnimationDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<StaggeredAnimationDemo> createState() => _StaggeredAnimationDemoState();
}

class _StaggeredAnimationDemoState extends State<StaggeredAnimationDemo> with SingleTickerProviderStateMixin {
  late final controller = AnimationController(
    duration: const Duration(milliseconds: 2000),
    vsync: this,
  );

  final scrollController = ScrollController();

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                if (controller.isCompleted) {
                  controller.reverse();
                } else {
                  controller.forward();
                }
              },
              child: Text('开始'),
            ),
            StaggeredAnimationWidget(
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }
}

class StaggeredAnimationWidget extends StatelessWidget {
  final Animation<double> controller;
  final Animation<double> opacity;
  final Animation<double> width;
  final Animation<double> height;
  final Animation<Color?> color;
  final Animation<EdgeInsets> padding;
  final Animation<BorderRadius?> borderRadius;
  final Animation<double> elevation;
  final Animation<TextStyle>? style;

  StaggeredAnimationWidget({
    Key? key,
    required this.controller,
  })  : opacity = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.2, curve: Curves.easeIn),
          ),
        ),
        width = Tween<double>(
          begin: 100.0,
          end: 200.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.1, 0.4, curve: Curves.easeOut),
          ),
        ),
        height = Tween<double>(
          begin: 50.0,
          end: 200.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.3, 0.6, curve: Curves.easeInOut),
          ),
        ),
        color = ColorTween(
          begin: Colors.red,
          end: Colors.blue,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.5, 0.8, curve: Curves.easeIn),
          ),
        ),
        padding = EdgeInsetsTween(
          begin: EdgeInsets.all(8.0),
          end: EdgeInsets.all(32.0),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.7, 1.0, curve: Curves.easeOut),
          ),
        ),
        borderRadius = BorderRadiusTween(
          begin: BorderRadius.circular(4.0),
          end: BorderRadius.circular(30.0),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.6, 0.9, curve: Curves.elasticOut),
          ),
        ),
        elevation = Tween<double>(
          begin: 0.0,
          end: 12.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.8, 1.0, curve: Curves.easeIn),
          ),
        ),
        style = TextStyleTween(
          begin: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          end: TextStyle(
            color: Colors.red,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.6, 0.9, curve: Curves.linear),
          ),
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          padding: padding.value,
          decoration: BoxDecoration(
            color: color.value,
            borderRadius: borderRadius.value,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: elevation.value,
                offset: Offset(0, elevation.value / 2),
              ),
            ],
          ),
          width: width.value,
          height: height.value,
          child: Opacity(
            opacity: opacity.value,
            child: Center(
              child: Text(
                'Flutter',
                style: style?.value ??
                    TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        );
      },
    );
  }
}
