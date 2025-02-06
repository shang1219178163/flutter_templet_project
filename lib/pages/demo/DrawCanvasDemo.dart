import 'dart:math';

import 'package:dash_painter/dash_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_dash_decoration.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/pages/demo/curve_painter.dart';

class DrawCanvasDemo extends StatefulWidget {
  DrawCanvasDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _DrawCanvasDemoState createState() => _DrawCanvasDemoState();
}

class _DrawCanvasDemoState extends State<DrawCanvasDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image(
                image: "assets/images/canvas_draw_arc.png".toAssetImage(),
                fit: BoxFit.fitWidth,
              ),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                ),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      child: CustomPaint(
                        painter: CurvePainter(
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                    Container(
                      width: 160,
                      height: 60,
                      decoration: NDashDecoration(
                        step: 2,
                        // pointWidth: 2,
                        // pointCount: 1,
                        radius: Radius.circular(15),
                        strokeWidth: 3,
                        strokeColor: Colors.red,
                      ),
                      alignment: Alignment.center,
                      child: Text("自定义虚线\nNDashDecoration"),
                    ),
                    Container(
                      width: 160,
                      height: 60,
                      decoration: DashDecoration(
                        step: 5,
                        span: 5,
                        // pointCount: 0,
                        pointWidth: 1,
                        radius: Radius.circular(15),
                        gradient: SweepGradient(
                          colors: [Colors.blue, Colors.red, Colors.yellow, Colors.green],
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text("dash_painter"),
                    ),
                    CustomPaint(
                      painter: NTrianglePainter(),
                      size: Size(130, 130),
                    ),
                    Container(
                      color: Colors.red,
                      width: 100,
                      height: 50,
                      child: CustomPaint(
                        painter: MYCustomPainter(
                          radius: 10,
                        ),
                      ),
                    ),
                  ]
                      .map((e) => Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                            ),
                            child: e,
                          ))
                      .toList(),
                ),
              ),
            ]),
      ),
    );
  }
}

class NTrianglePainter extends CustomPainter {
  NTrianglePainter({
    this.color = Colors.red,
    this.quarterTurns = 0,
    this.arrowRadius = 25,
  });

  int quarterTurns;

  Color color;

  double arrowRadius;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..strokeWidth = 2
      ..color = Colors.red;
    var path = Path();
    // path.moveTo(size.width / 2, 0);
    // path.lineTo(0, size.height);
    // path.lineTo(size.width, size.height);

    path.moveTo(0, 0);
    path.lineTo(size.width, size.height / 2);

    path.arcTo(
      Rect.fromCircle(center: Offset(size.width - arrowRadius, size.height / 2), radius: arrowRadius),
      -90.0 * (pi / 180.0), // 起始弧度
      180.0 * (pi / 180.0), // 结束弧度
      false,
    );

    path.lineTo(
      0,
      size.height,
    );

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// 梯形
class MYCustomPainter extends CustomPainter {
  MYCustomPainter({
    this.color = Colors.blue,
    this.style = PaintingStyle.fill,
    this.strokeWidth = 1,
    this.radius = 20.0,
    this.otherPaint,
  });

  final Color color;
  final PaintingStyle style;

  final double radius;
  final double strokeWidth;

  final Paint? otherPaint;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = style
      ..strokeWidth = strokeWidth;

    var path = Path();

    path.moveTo(0, size.height);
    path.lineTo(size.width / 2 - radius, radius); //开始点
    path.quadraticBezierTo(size.width / 2, 0, size.width / 2 + radius, 0); //中间点，结束点
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius); //中间点，结束点
    path.lineTo(size.width, size.height - radius);
    path.quadraticBezierTo(size.width, size.height, size.width - radius, size.height); //中间点，结束点
    path.lineTo(size.height, size.height);

    canvas.drawPath(path, otherPaint ?? paint);
  }

  @override
  bool shouldRepaint(covariant MYCustomPainter oldDelegate) {
    return color != oldDelegate.color ||
        style != oldDelegate.style ||
        radius != oldDelegate.radius ||
        strokeWidth != oldDelegate.strokeWidth ||
        otherPaint != oldDelegate.otherPaint;
  }
}
