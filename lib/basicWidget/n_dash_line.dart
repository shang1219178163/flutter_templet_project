

import 'package:flutter/material.dart';

class NDashLine extends StatelessWidget {

  const NDashLine({
    Key? key,
    this.height = 1,
    this.color = Colors.black,
    this.dashWidth = 10.0
  }) : super(key: key);

  final double height;
  final Color color;
  final double dashWidth;


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}