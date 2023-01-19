//
//  TicketUi.dart
//  flutter_templet_project
//
//  Created by shang on 1/19/23 5:00 PM.
//  Copyright © 1/19/23 shang. All rights reserved.
//
//  左上角为绘制原点

import 'package:flutter/material.dart';

class TicketUi extends StatelessWidget {
  const TicketUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            height: 220,
            margin: const EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width,
            child: CustomPaint(
              painter: TicketPainter(
                borderColor: Colors.black,
                bgColor: const Color(0xFFfed966),
              ),
              child: Container(),
            ),
          ),
        ),
      ),
    );
  }
}


class TicketPainter extends CustomPainter {
  TicketPainter({
    required this.bgColor,
    required this.borderColor,
    this.borderStrokeWidth = 1,
    this.cornerRadius = 20.0,
    this.cutoutRadius = 20.0,
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
  /// 边角圆半径
  final double cornerRadius;
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
    double dottedLineStartX = cutoutRadius;

    // const double dashWidth = 8.5;
    // const double dashSpace = 4;
    final double dottedLineEndX = maxWidth - cutoutRadius - dottedSpace;

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

    path.moveTo(cornerRadius, 0);
    path.lineTo(maxWidth - cornerRadius, 0);
    _drawCornerArc(path, maxWidth, cornerRadius);
    path.lineTo(maxWidth, rightCutoutStartY);
    _drawCutout(path, maxWidth, rightCutoutStartY + _cutoutDiameter);
    path.lineTo(maxWidth, maxHeight - cornerRadius);
    _drawCornerArc(path, maxWidth - cornerRadius, maxHeight);
    path.lineTo(cornerRadius, maxHeight);
    _drawCornerArc(path, 0, maxHeight - cornerRadius);
    path.lineTo(0, leftCutoutStartY);
    _drawCutout(path, 0.0, leftCutoutStartY - _cutoutDiameter);
    path.lineTo(0, cornerRadius);
    _drawCornerArc(path, cornerRadius, 0);

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

  _drawCornerArc(Path path, double endPointX, double endPointY) {
    path.arcToPoint(
      Offset(endPointX, endPointY),
      radius: Radius.circular(cornerRadius),
    );
  }

  @override
  bool shouldRepaint(TicketPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(TicketPainter oldDelegate) => false;
}



class DashLine extends StatelessWidget {

  final double dashHeight;
  final Color color;
  final double dashWidth;

  const DashLine({this.dashHeight = 1, this.color = Colors.black, this.dashWidth = 10.0});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
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