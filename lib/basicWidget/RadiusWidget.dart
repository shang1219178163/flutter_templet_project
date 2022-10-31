

import 'package:flutter/widgets.dart';

class RadiusWidget extends StatelessWidget {
  /// Creates a widget that both has state and delegates its build to a callback.
  ///
  /// The [builder] argument must not be null.
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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: this.color,
        borderRadius: border,
      ),
      child: child,
    );
  }
}
