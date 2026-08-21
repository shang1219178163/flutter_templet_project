//
//  LerpDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/8/6 12:09.
//  Copyright © 2024/8/6 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:get/get.dart';

class LerpDemo extends StatefulWidget {
  const LerpDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<LerpDemo> createState() => _LerpDemoState();
}

class _LerpDemoState extends State<LerpDemo>
    with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  late final AnimationController _controller = AnimationController(
    duration: Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);

  late final tween = ColorTween(
    begin: Colors.red,
    end: Colors.blue,
  );
  late final Animation<Color?> _animation = tween.animate(_controller);

  final String desc = r"在 Flutter 中，lerp 是 'linear interpolation' "
      "的缩写，中文通常称为线性插值。线性插值是用于在两个值之间进行平滑过渡的一种方法。它在动画、颜色过渡、尺寸变化等许多场景中广泛使用。lerp "
      "的基本原理是通过给定的参数 t，在两个值 a 和 b 之间进行插值。参数 t 通常在 0 到 1 的范围内，其中 t = 0 时返回 a，t = 1 时返回 b，而 t 在 0 和 1 之间时返回一个介于 a 和 b 之间的值。";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NSectionBox(
                text: Text(desc),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("其数学公式为："),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "lerp(a,b,t)=a+(b−a)×t",
                        style: TextStyle(
                          fontSize: 26,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              NSectionBox(
                text: Text(
                  "二. 随滑块变化的颜色和尺寸",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: buildLerpColor(),
              ),
              NSectionBox(
                text: Text(
                  "三. 基于 ColorTween 的动画",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: ValueListenableBuilder(
                  valueListenable: _animation,
                  builder: (context, value, child) {
                    return Container(
                      width: 100,
                      height: 100,
                      color: _animation.value,
                      child: Column(
                        children: [
                          Text("a: Colors.red"),
                          Text("b: Colors.blue"),
                        ]
                            .map((e) => Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  child: e,
                                ))
                            .toList(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLerpColor({
    double min = 0,
    double max = 1,
    double current = 0,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        Color a = Colors.red;
        Color b = Colors.blue;
        var color = Color.lerp(a, b, current);

        var sizeStart = Size(240, 150);
        var sizeEnd = Size(300, 200);
        var size = Size.lerp(sizeStart, sizeEnd, current);

        final desc = "t: ${current.toStringAsFixed(2)}";

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: current,
                    onChanged: (double value) {
                      current = value;
                      setState(() {});
                    },
                    min: 0,
                    max: 1,
                    divisions: 100,
                  ),
                ),
                Text(desc),
              ],
            ),
            Container(
              width: size?.width,
              height: size?.height,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color,
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.all(Radius.circular(0)),
              ),
              child: Column(
                children: [
                  Text("a: Colors.red"),
                  Text("b: Colors.blue"),
                  Text("sizeStart: $sizeStart"),
                  Text("sizeEnd: $sizeEnd"),
                ]
                    .map((e) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: e,
                        ))
                    .toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
