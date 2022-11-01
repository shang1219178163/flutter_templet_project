

import 'package:flutter/widgets.dart';

class RadiusWidget extends StatelessWidget {

  RadiusWidget({
    Key? key,
    required this.child,
    this.color,
    this.borderRadius,
    this.radius,
  }) : super(key: key);

  Widget child;

  final BorderRadius? borderRadius;
  final double? radius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (this.radius == 0 && this.borderRadius == null) {
      return this.child;
    }

    final border = this.borderRadius ?? BorderRadius.circular(this.radius ?? 0);
    return DecosceneOrderListratedBox(
      decoration: BoxDecoration(
        color: this.color,
        borderRadius: border,
      ),
      child: child,
    );
  }
}
