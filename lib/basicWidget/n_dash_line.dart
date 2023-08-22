//
//  n_dash_line.dart
//  flutter_templet_project
//
//  Created by shang on 7/16/21 9:11 AM.
//  Copyright © 7/16/21 shang. All rights reserved.
//


import 'package:flutter/material.dart';

class NDashLine extends StatelessWidget {

  const NDashLine({
    Key? key,
    this.direction = Axis.horizontal,
    this.color = Colors.black,
    this.colors = const [],
    this.height = 1,
    this.itemWidth = 5,
  }) : super(key: key);

  final Color color;
  final List<Color> colors;
  final Axis direction;
  final double height;
  final double itemWidth;

  @override
  Widget build(BuildContext context) {
    if (colors.length > 1) {
      return _NDashLineNew(
        colors: colors,
        direction: direction,
        height: height,
        itemWidth: itemWidth,
      );
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = direction == Axis.horizontal
            ? constraints.constrainWidth()
            : constraints.constrainHeight();
        final dashWidth = itemWidth;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();

        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: direction,
          children: List.generate(dashCount, (_) {

            return SizedBox(
              width: direction == Axis.horizontal ? dashWidth : dashHeight,
              height: direction == Axis.horizontal ? dashHeight : dashWidth,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}


class _NDashLineNew extends StatelessWidget {

  const _NDashLineNew({
    Key? key,
    this.direction = Axis.horizontal,
    this.colors = const [Colors.transparent,
      Colors.red,
      Colors.transparent,
      Colors.blue,
    ],
    this.height = 1,
    this.itemWidth = 5,
  }) : super(key: key);

  final List<Color> colors;
  final Axis direction;
  final double height;
  final double itemWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = direction == Axis.horizontal
            ? constraints.constrainWidth()
            : constraints.constrainHeight();
        final dashWidth = itemWidth;
        final dashHeight = height;
        final count = (boxWidth / (colors.length * dashWidth));
        final dashCount = count.floor();
        final otherItemCount = (count%1 * colors.length).truncate();

        debugPrint("count:$count, dashCount:$dashCount, otherItemCount:$otherItemCount");

        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,//剩余的间隙平分
          direction: direction,
          children: [
            ...List.generate(dashCount, (_) {

              return Flex(
                mainAxisSize: MainAxisSize.min,
                direction: direction,
                children: buildItems(
                  colors: colors,
                  dashWidth: dashWidth,
                  dashHeight: dashHeight,
                ),
              );
            }),
            ...buildItems(
              colors: colors.take(otherItemCount).toList(),
              dashWidth: dashWidth,
              dashHeight: dashHeight,
            ),
          ],
        );
      },
    );
  }

  List<Widget> buildItems({
    required List<Color> colors,
    required double dashWidth,
    required double dashHeight,
  }) {
    return colors.map((e) {
      return SizedBox(
        width: direction == Axis.horizontal ? dashWidth : dashHeight,
        height: direction == Axis.horizontal ? dashHeight : dashWidth,
        child: DecoratedBox(
          decoration: BoxDecoration(color: e),
        ),
      );
    }).toList();
  }
}
