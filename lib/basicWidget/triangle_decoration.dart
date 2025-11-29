import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

/// Decoration that can be used to render a triangle in the bottom-right
/// corner of a container
class TriangleDecoration extends Decoration {
  /// Constructor
  TriangleDecoration({
    this.color = Colors.red,
    this.size = 8,
  });

  final Color color;
  final double size;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _TriangleShapePainter(color: color, size: size);
  }
}

class _TriangleShapePainter extends BoxPainter {
  _TriangleShapePainter({
    required this.color,
    this.size = 8,
  });

  final Color color;
  final double size;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    var painter = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final s = configuration.size!;
    var path = Path()
      ..moveTo(s.width + offset.dx, s.height - size + offset.dy)
      ..lineTo(s.width - size + offset.dx, s.height + offset.dy)
      ..lineTo(s.width + offset.dx, s.height + offset.dy)
      ..lineTo(s.width + offset.dx, s.height - size + offset.dy)
      ..close();

    canvas.drawPath(path, painter);
  }
}
