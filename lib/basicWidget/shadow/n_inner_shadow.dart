//
//  NInnerShadowBox.dart
//  flutter_templet_project
//
//  Created by shang on 2026/7/24 09:19.
//  Copyright © 2026/7/24 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class NInnerShadow extends StatelessWidget {
  const NInnerShadow({
    super.key,
    required this.child,
    this.color = Colors.black26,
    this.blur = 10,
    this.offset = const Offset(2, 2),
    this.borderRadius = BorderRadius.zero,
    this.blurExtent = 4.0,
  });

  final Widget child;
  final Color color;
  final double blur;
  final Offset offset;
  final BorderRadius borderRadius;

  /// Multiplier used to expand the outer rect to avoid clipping
  /// the blurred shadow.
  ///
  /// The actual padding is:
  ///
  /// `padding = blur * blurExtent`
  ///
  /// Usually 3.0~4.0 is sufficient.
  final double blurExtent;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _InnerShadowPainter(
        color: color,
        blur: blur,
        offset: offset,
        borderRadius: borderRadius,
        blurExtent: blurExtent,
      ),
      child: child,
    );
  }
}

class _InnerShadowPainter extends CustomPainter {
  const _InnerShadowPainter({
    required this.color,
    required this.blur,
    required this.offset,
    required this.borderRadius,
    this.blurExtent = 4.0,
  });

  final Color color;

  /// Gaussian blur sigma.
  final double blur;

  final Offset offset;

  final BorderRadius borderRadius;

  /// Multiplier used to expand the outer rect to avoid clipping
  /// the blurred shadow.
  ///
  /// The actual padding is:
  ///
  /// `padding = blur * blurExtent`
  ///
  /// Usually 3.0~4.0 is sufficient.
  final double blurExtent;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final padding = blur * blurExtent;

    final inner = Path()..addRRect(borderRadius.toRRect(rect));

    final outer = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(rect.inflate(blur * padding))
      ..addRRect(borderRadius.toRRect(rect));

    canvas.save();

    // 只允许绘制到组件内部
    canvas.clipPath(inner);

    canvas.translate(offset.dx, offset.dy);

    canvas.drawPath(
      outer,
      Paint()
        ..color = color
        ..maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          blur,
        ),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _InnerShadowPainter oldDelegate) =>
      color != oldDelegate.color ||
      blur != oldDelegate.blur ||
      offset != oldDelegate.offset ||
      borderRadius != oldDelegate.borderRadius ||
      blurExtent != oldDelegate.blurExtent;
}
