//
//  n_dash_line.dart
//  flutter_templet_project
//
//  Created by shang on 7/16/21 9:11 AM.
//  Copyright © 7/16/21 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

/// 自定义虚线
class NDashLine extends StatelessWidget {

  const NDashLine({
    Key? key,
    this.direction = Axis.horizontal,
    this.color = Colors.black,
    this.steps = const [],
    this.height = 1,
    this.step = 5,
  }) : super(key: key);

  /// 单色虚线
  final Color color;
  /// 彩色虚线
  final List<Tuple2<double, Color>> steps;
  /// 方向
  final Axis direction;
  /// 线条高度
  final double height;
  /// 单色步长
  final double step;

  @override
  Widget build(BuildContext context) {
    if (steps.length > 1) {
      return NDashLineOfMutiColor(
        steps: steps,
        direction: direction,
        height: height,
      );
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = direction == Axis.horizontal
            ? constraints.constrainWidth()
            : constraints.constrainHeight();
        final dashHeight = height;
        final count = boxWidth / (2 * step);
        final dashCount = count.floor();
        /// 剩余宽度不够一组
        final otherCount = ((count%1)*2).truncate();
        // debugPrint("boxWidth:$boxWidth, dashWidth:$step");
        // debugPrint("count:$count, dashCount:$dashCount, otherCount:$otherCount");

        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: direction,
          children: [
            ...List.generate(dashCount, (_) {
              return SizedBox(
                width: direction == Axis.horizontal ? step : dashHeight,
                height: direction == Axis.horizontal ? dashHeight : step,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: color),
                ),
              );
            }),
            ...List.generate(otherCount, (_) {
              return SizedBox(
                width: direction == Axis.horizontal ? step : dashHeight,
                height: direction == Axis.horizontal ? dashHeight : step,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: color),
                ),
              );
            }),
          ]
        );
      },
    );
  }
}


/// 多颜色虚线
class NDashLineOfMutiColor extends StatelessWidget {

  const NDashLineOfMutiColor({
    Key? key,
    this.direction = Axis.horizontal,
    this.steps = const <Tuple2<double, Color>>[
      Tuple2(5, Colors.transparent),
      Tuple2(5, Colors.red),
      Tuple2(5, Colors.transparent),
      Tuple2(5, Colors.blue),
    ],
    this.height = 1,
  }) : super(key: key);

  /// 每种颜色及步长宽度
  final List<Tuple2<double, Color>> steps;
  /// 水平或者垂直
  final Axis direction;
  /// 线条高度
  final double height;


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = direction == Axis.horizontal
            ? constraints.constrainWidth()
            : constraints.constrainHeight();

        final step = steps.map((e) => e.item1).reduce((v, e) => v + e);

        final dashHeight = height;
        final count = boxWidth / step;
        final dashCount = count.floor();
        /// 剩余宽度不够一组
        final otherCount = ((count%1)*steps.length).truncate();
        // debugPrint("boxWidth:$boxWidth, dashWidth:$step");
        // debugPrint("count:$count, dashCount:$dashCount, otherCount:$otherCount");

        return Flex(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,//剩余的间隙平分
          direction: direction,
          children: [
            ...List.generate(dashCount, (_) {
              return Flex(
                mainAxisSize: MainAxisSize.min,
                direction: direction,
                children: buildItems(
                  steps: steps,
                  dashHeight: dashHeight,
                ),
              );
            }),
            ...buildItems(
              steps: steps.take(otherCount).toList(),
              dashHeight: dashHeight,
            ),
          ],
        );
      },
    );
  }

  List<Widget> buildItems({
    required List<Tuple2<double, Color>> steps,
    required double dashHeight,
  }) {
    return steps.map((e) {
      return SizedBox(
        width: direction == Axis.horizontal ? e.item1 : dashHeight,
        height: direction == Axis.horizontal ? dashHeight : e.item1,
        child: DecoratedBox(
          decoration: BoxDecoration(color: e.item2),
        ),
      );
    }).toList();
  }
}
