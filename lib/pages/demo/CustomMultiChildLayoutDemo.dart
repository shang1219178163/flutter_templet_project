import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/CircleLayout.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';

class CustomMultiChildLayoutDemo extends StatefulWidget {
  CustomMultiChildLayoutDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _CustomMultiChildLayoutDemoState createState() => _CustomMultiChildLayoutDemoState();
}

class _CustomMultiChildLayoutDemoState extends State<CustomMultiChildLayoutDemo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    _controller = AnimationController(
      lowerBound: 0.0,
      upperBound: 1.0,
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _controller.repeat(reverse: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: [
            'done',
          ]
              .map((e) => TextButton(
                    child: Text(
                      e,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => debugPrint(e),
                  ))
              .toList(),
        ),
        body: CustomScrollView(
          slivers: [
            buildBody1(),
            buildBody2(),
          ].map((e) => e.toSliverToBoxAdapter()).toList(),
        ));
  }

  Widget buildPoint({
    Color color = Colors.blue,
    double width = 50,
    double height = 50,
    BoxShape shape = BoxShape.circle,
  }) {
    return Container(
      margin: const EdgeInsets.all(2),
      alignment: Alignment.center,
      width: width,
      height: height,
      decoration: BoxDecoration(
        boxShadow: const [BoxShadow(blurRadius: 20, color: Colors.black)],
        color: color,
        shape: shape,
      ),
    );
  }

  Widget buildBody1() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
        ),
        width: 300,
        height: 300,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            var _v = (2 * (_controller.value - 0.5)).abs();
            return CircleLayout(
              // radiusRatio: _v,
              initAngle: _controller.value * 360,
              children: List.generate(
                9,
                (index) => index == 8
                    ? buildPoint(width: 80, height: 80, color: Colors.red)
                    : buildPoint(width: 100, height: 40, shape: BoxShape.rectangle),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildBody2() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
        ),
        width: 300,
        height: 300,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            var _v = (2 * (_controller.value - 0.5)).abs();
            return CircleLayout(
              // radiusRatio: _v,
              initAngle: _controller.value * 360,
              children: List.generate(9, (index) {
                if (index == 8) {
                  return buildPoint(width: 80, height: 80, color: Colors.red);
                }
                if (index % 2 == 0) {
                  return buildPoint(width: 40, height: 50 * _v + 30, shape: BoxShape.rectangle);
                }
                return buildPoint(width: 50 * _v + 30, height: 30, shape: BoxShape.rectangle);
              }),
            );
          },
        ),
      ),
    );
  }
}
