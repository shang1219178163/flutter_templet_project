//
//  CustomPainterPageDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2025/1/21 09:19.
//  Copyright © 2025/1/21 shang. All rights reserved.
//

import 'dart:math';

import 'package:flutter/material.dart';
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

  final _scrollController = ScrollController();

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
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
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
          ]
              .map((e) => Container(
                    width: 200,
                    margin: EdgeInsets.only(bottom: 15),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: e,
                  ))
              .toList(),
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
        child: Text(
          '28 book summariesa month',
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
extension VectorExtensions on Offset {
  Offset get normalized {
    final double length = distance;
    return length == 0 ? this : this / length;
  }
}
