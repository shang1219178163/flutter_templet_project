import 'package:flutter/cupertino.dart';

class NTicketDividerPainter extends CustomPainter {
  NTicketDividerPainter({
    required this.bgColor,
    required this.borderColor,
    this.borderStrokeWidth = 1,
    this.cutoutRadius = 15.0,
    this.dottedWidth = 8,
    this.dottedSpace = 5,
    this.dottedStrokeWidth = 1.2,
  });

  /// 边框颜色
  final Color borderColor;

  /// 边框线条宽度
  final double borderStrokeWidth;

  /// 背景颜色
  final Color bgColor;

  /// 内切圆半径
  final double cutoutRadius;

  /// 虚线高亮宽度
  final double dottedWidth;

  /// 虚线高亮间隔
  final double dottedSpace;

  /// 虚线线条宽度
  final double dottedStrokeWidth;

  /// 内切圆直径
  get _cutoutDiameter => cutoutRadius * 2;

  @override
  void paint(Canvas canvas, Size size) {
    final maxWidth = size.width;
    final maxHeight = size.height;

    final cutoutStartPos = maxHeight - maxHeight * 0.2;
    final leftCutoutStartY = cutoutStartPos;
    final rightCutoutStartY = cutoutStartPos - _cutoutDiameter;
    final dottedLineY = cutoutStartPos - cutoutRadius;
    var dottedLineStartX = cutoutRadius;

    // const double dashWidth = 8.5;
    // const double dashSpace = 4;
    final dottedLineEndX = maxWidth - cutoutRadius - dottedSpace;

    final paintBg = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..color = bgColor;

    final paintBorder = Paint()
      ..strokeWidth = borderStrokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = borderColor;

    final paintDottedLine = Paint()
      ..color = borderColor.withOpacity(0.5)
      ..strokeWidth = dottedStrokeWidth;

    var path = Path();

    path.moveTo(maxWidth, rightCutoutStartY); //
    _drawCutout(path, maxWidth, rightCutoutStartY + _cutoutDiameter);

    path.moveTo(0, leftCutoutStartY);
    // path.lineTo(0, leftCutoutStartY);
    _drawCutout(path, 0.0, leftCutoutStartY - _cutoutDiameter);

    canvas.drawPath(path, paintBg);
    canvas.drawPath(path, paintBorder);

    while (dottedLineStartX <= dottedLineEndX) {
      canvas.drawLine(
        Offset(dottedLineStartX, dottedLineY),
        Offset(dottedLineStartX + dottedWidth, dottedLineY),
        paintDottedLine,
      );
      dottedLineStartX += dottedWidth + dottedSpace;
    }
  }

  _drawCutout(Path path, double startX, double endY) {
    path.arcToPoint(
      Offset(startX, endY),
      radius: Radius.circular(cutoutRadius),
      clockwise: false,
    );
  }

  @override
  bool shouldRepaint(NTicketDividerPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(NTicketDividerPainter oldDelegate) => false;
}
