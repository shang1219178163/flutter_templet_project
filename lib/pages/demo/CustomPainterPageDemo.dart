//
//  CustomPainterPageDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2025/1/21 09:19.
//  Copyright © 2025/1/21 shang. All rights reserved.
//

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:get/get.dart';

class CustomPainterPageDemo extends StatefulWidget {
  const CustomPainterPageDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<CustomPainterPageDemo> createState() => _CustomPainterPageDemoState();
}

class _CustomPainterPageDemoState extends State<CustomPainterPageDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  @override
  void didUpdateWidget(covariant CustomPainterPageDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
              actions: [
                'done',
              ]
                  .map((e) => TextButton(
                        child: Text(
                          e,
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          setState(() {});
                        },
                      ))
                  .toList(),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    final spacing = 16.0;
    final itemWidth = (context.screenWidth - spacing * 4) / 3.0.truncateToDouble();
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: spacing, vertical: 12),
          child: Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              buildPriceTag(),
              CustomPaint(
                painter: CameraClosePainter(),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.blue),
                  ),
                ),
              ),
              buildHexagon(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.blue),
                ),
                child: CustomPaint(
                  size: Size(200, 200), // 指定绘制区域大小
                  painter: ArcPainter(
                    startPoint: Offset(100, 100),
                    backgroundColor: Colors.green.withOpacity(0.3),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.blue),
                ),
                child: CustomPaint(
                  // size: Size(150, 150), // 指定绘制区域大小
                  painter: RightArrowPainter(),
                ),
              ),
            ]
                .map((e) => Container(
                      width: itemWidth,
                      height: itemWidth,
                      child: e,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget buildPriceTag() {
    return CustomPaint(
      painter: PriceTagPainter(
        paintCb: (path) {
          path.color = Colors.red;
          path.strokeWidth = 1;
          return path;
        },
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.blue),
        ),
        child: Center(
          child: Text(
            '28 book summariesa month',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.blue,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget buildHexagon() {
    return CustomPaint(
      painter: Hexagon(),
      child: Container(
        height: 100,
        width: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.blue),
        ),
        child: Text(
          '六边形',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.blue,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class PriceTagPainter extends CustomPainter {
  PriceTagPainter({this.paintCb});

  final Paint Function(Paint paint)? paintCb;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.lightBlue // Light blue color for the border
      ..style = PaintingStyle.stroke // Only draw the border (no fill)
      ..strokeWidth = 2; // Set the thickness of the border
    if (paintCb != null) {
      paint = paintCb!(paint);
    }

    // Create a Path for the irregular border
    Path path = Path();

    // Start drawing the irregular shape
    path.moveTo(30, 0); // Move to top-left corner

    // Draw a straight line to the top-right corner with a small cut
    path.lineTo(size.width - 30, 0);

    // Add the irregular triangular extension at the right side
    path.lineTo(size.width, size.height / 2);

    // Add the line to bottom-right corner
    path.lineTo(size.width - 30, size.height);

    // Draw a straight line to bottom-left
    path.lineTo(30, size.height);

    // Add the irregular curve back to top-left corner
    path.lineTo(0, size.height / 2);

    // Close the path to complete the shape
    path.close();

    // Draw the irregular border using the paint
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; // No need to repaint unless the path changes
  }
}

class CameraClosePainter extends CustomPainter {
  final double cornerRadius;

  CameraClosePainter({this.cornerRadius = 10.0});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue // Color for the hexagon
      ..style = PaintingStyle.fill; // Fill the hexagon

    // Calculate the center and radius of the hexagon
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius = size.width / 2;
    double cornerRadius = 10; // The radius of the circular arc at each vertex

    // Define the number of sides (6 for hexagon)
    int sides = 6;
    double angle = 2 * pi / sides;

    // Create a Path for the hexagon
    Path path = Path();

    // Loop through each side of the hexagon
    for (int i = 0; i < sides; i++) {
      // Calculate the start and end points of the hexagon sides
      double startX = centerX + radius * cos(i * angle);
      double startY = centerY + radius * sin(i * angle);
      double endX = centerX + radius * cos((i + 1) * angle);
      double endY = centerY + radius * sin((i + 1) * angle);

      // Move to the first vertex of the hexagon
      if (i == 0) {
        path.moveTo(startX, startY);
      }

      // Draw the circular arc (rounded corner) at each vertex
      path.arcTo(Rect.fromCircle(center: Offset(centerX, centerY), radius: cornerRadius), i * angle - pi / 6, angle / 3,
          false);

      // Draw the straight line from one arc to the next vertex
      path.lineTo(endX, endY);
    }

    // Close the path (to complete the hexagon)
    path.close();

    // Draw the hexagon with rounded vertices
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class RightArrowPainter extends CustomPainter {
  final double cornerRadius;

  RightArrowPainter({this.cornerRadius = 10.0});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.lightBlue
      ..style = PaintingStyle.fill;

    Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width - size.width * 0.3, 0) // Top horizontal line
      ..lineTo(size.width, size.height / 2) // Right diagonal
      ..lineTo(size.width - size.width * 0.3, size.height) // Bottom horizontal line
      ..lineTo(0, size.height) // Left vertical line
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

/// 六边形
class Hexagon extends CustomPainter {
  Hexagon({this.paintCb});

  final Paint Function(Paint paint)? paintCb;

  @override
  void paint(Canvas canvas, Size size) {
    debugPrint([runtimeType, size].asMap().toString());
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 2 * 0.7; // 六边形半径（控制大小）
    final double cornerRadius = 20; // 圆角半径（控制圆角幅度）

    // 1. 计算六边形的六个顶点坐标
    final List<Offset> vertices = _calculateHexagonVertices(centerX, centerY, radius);

    // 2. 构建圆角路径
    final Path path = _buildRoundedHexagonPath(vertices, cornerRadius);

    Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    if (paintCb != null) {
      paint = paintCb!(paint);
    }
    // 3. 绘制路径
    canvas.drawPath(path, paint);
  }

  // 计算六边形顶点坐标（带角度调整）
  List<Offset> _calculateHexagonVertices(double centerX, double centerY, double radius) {
    final List<Offset> vertices = [];
    for (int i = 0; i < 6; i++) {
      // 调整起始角度使六边形垂直（-π/6 用于对齐）
      final double angle = 2 * pi * i / 6 - pi / 6;
      final double x = centerX + radius * cos(angle);
      final double y = centerY + radius * sin(angle);
      vertices.add(Offset(x, y));
    }
    return vertices;
  }

  // 构建圆角六边形路径
  Path _buildRoundedHexagonPath(List<Offset> vertices, double cornerRadius) {
    final Path path = Path();
    for (int i = 0; i < vertices.length; i++) {
      final Offset currentVertex = vertices[i];
      final Offset nextVertex = vertices[(i + 1) % 6];

      // 计算边的方向向量（单位向量）
      final Offset edgeDirection = (nextVertex - currentVertex).normalized;

      // 计算圆弧的起点和终点
      final Offset arcStart = currentVertex + edgeDirection * cornerRadius;
      final Offset arcEnd = nextVertex - edgeDirection * cornerRadius;

      if (i == 0) {
        // 移动到第一个边的起点（略微偏移以闭合路径）
        path.moveTo(arcStart.dx, arcStart.dy);
      }

      // 绘制直线到当前边的圆弧起点（如果是第一次循环，已经 moveTo）
      if (i > 0) {
        path.lineTo(arcStart.dx, arcStart.dy);
      }

      // 在顶点处绘制圆弧
      path.arcToPoint(
        arcEnd,
        radius: Radius.circular(cornerRadius),
        clockwise: true,
      );
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// 扩展方法：向量归一化
extension _OffsetExtensions on Offset {
  Offset get normalized {
    final double length = distance;
    return length == 0 ? this : this / length;
  }
}

class ArcPainter extends CustomPainter {
  final Color color;
  final Offset startPoint;
  final double radius;
  final double startAngle;
  final double sweepAngle;
  final Color backgroundColor;

  ArcPainter({
    this.color = Colors.blue,
    required this.startPoint,
    this.radius = 15.0,
    this.startAngle = 0.0,
    this.sweepAngle = pi / 2, // 默认为90度
    this.backgroundColor = Colors.green,
  });

  @override
  void paint(Canvas canvas, Size size) {
    //背景
    final paintBg = Paint()..color = backgroundColor;

    // 使用 drawRect 来绘制背景色
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paintBg);

    // 你也可以使用 drawPaint 绘制背景色
    // canvas.drawPaint(paint);

    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // 计算等边三角形的三个顶点
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double sideLength = min(size.width, size.height) * 0.8; // 等边三角形的边长，取画布的80%

    // 计算三角形的三个顶点坐标
    double height = (sqrt(3) / 2) * sideLength; // 高度公式：h = (sqrt(3) / 2) * a
    Offset p1 = Offset(centerX, centerY - height / 2); // 顶点
    Offset p2 = Offset(centerX - sideLength / 2, centerY + height / 2); // 左下角
    Offset p3 = Offset(centerX + sideLength / 2, centerY + height / 2); // 右下角

    // 创建路径并绘制三角形
    Path path = Path()..addPolygon([p1, p2, p3], true);
    canvas.drawPath(path, paint);

    // 创建圆弧的矩形区域
    // 图案
    final Paint paintOne = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final c = radius / sin(pi / 6);
    final b = radius / tan(pi / 6);

    Offset p1One = Offset(p1.dx, p1.dy + c);
    Offset p2One = Offset(p2.dx + b, p2.dy - radius);
    Offset p3One = Offset(p3.dx - b, p3.dy - radius);
    Path pathOne = Path()..addPolygon([p1One, p2One, p3One], true);
    // canvas.drawPath(pathOne, paintOne);

    // 顶部弧形区域
    final radians = pi / 180;
    Rect rect1 = Rect.fromCircle(center: p1One, radius: radius);
    canvas.drawArc(rect1, -radians * 135, radians * 90, true, paintOne);
    // 左下角弧形区域
    Rect rect2 = Rect.fromCircle(center: p2One, radius: radius);
    canvas.drawArc(rect2, radians * 105, radians * 90, true, paintOne);
    // 右下角弧形区域
    Rect rect3 = Rect.fromCircle(center: p3One, radius: radius);
    canvas.drawArc(rect3, -radians * 15, radians * 90, true, paintOne);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
