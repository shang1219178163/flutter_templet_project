import 'package:flutter/material.dart';

/// 不能设置阴影
class NTicketClipPath extends StatelessWidget {
  const NTicketClipPath({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: NTicketClipper(),
      child: child,
    );
  }
}

class NTicketClipper extends CustomClipper<Path> {
  NTicketClipper({
    this.radius = 15.0,
    this.percent = 0.7,
  });

  final double radius;
  final double percent;

  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    path.addOval(Rect.fromCircle(
      center: Offset(0.0, size.height * percent),
      radius: radius,
    ));
    path.addOval(Rect.fromCircle(
      center: Offset(size.width, size.height * percent),
      radius: radius,
    ));
    return path;
  }

  @override
  bool shouldReclip(NTicketClipper oldClipper) {
    return radius != oldClipper.radius || percent != oldClipper.percent;
  }
}
