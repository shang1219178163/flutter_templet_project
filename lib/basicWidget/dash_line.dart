//
//  dash_line.dart
//  flutter_templet_project
//
//  Created by shang on 7/16/21 9:11 AM.
//  Copyright © 7/16/21 shang. All rights reserved.
//


import 'package:flutter/material.dart';

class DashLine extends StatelessWidget {

  final Color color;
  final Axis direction;
  final double height;
  final double itemWidth;

  const DashLine({
    Key? key,
    this.color = Colors.black,
    this.direction = Axis.horizontal,
    this.height = 1,
    this.itemWidth = 5,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
