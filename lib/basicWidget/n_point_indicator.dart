import 'package:flutter/material.dart';

class NPointIndicator extends StatelessWidget {
  const NPointIndicator({
    Key? key,
    required this.color,
    this.bigCircleRadius = 6,
    this.smallCircleRadius = 3,
  }) : super(key: key);

  final Color color;
  final double bigCircleRadius;
  final double smallCircleRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: bigCircleRadius * 2,
      height: bigCircleRadius * 2,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Container(
        width: smallCircleRadius * 2,
        height: smallCircleRadius * 2,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
