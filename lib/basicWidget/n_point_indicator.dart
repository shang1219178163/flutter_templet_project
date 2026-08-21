import 'package:flutter/material.dart';

class NPointIndicator extends StatelessWidget {
  const NPointIndicator({
    super.key,
    required this.color,
    this.bigCircleRadius = 6,
    this.smallCircleRadius = 3,
  });

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
        color: color.withValues(alpha: 0.1),
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color));
    properties.add(DoubleProperty('bigCircleRadius', bigCircleRadius));
    properties.add(DoubleProperty('smallCircleRadius', smallCircleRadius));
  }
}
