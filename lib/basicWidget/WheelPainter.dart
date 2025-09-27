import 'dart:math';

import 'package:flutter/material.dart';

///绘制自定义view，其中画笔 paint ，画布 canvas，而 CustomPainter 负责具体的绘制逻辑处理
class WheelPainter extends CustomPainter {
  WheelPainter(this.list, this.listColor);

  List<double> list;
  List<Color> listColor;
  double total = 0; //总份数

  @override
  void paint(Canvas canvas, Size size) {
    var wheelSize = min(size.width, size.height) / 2; //饼图的尺寸
    //用一个矩形框来包裹饼图
    var boundingRect = Rect.fromCircle(
        center: Offset(wheelSize, wheelSize), radius: wheelSize);
    //求出数组中所有数值的和
    total = list.reduce((value, element) => value + element);
    debugPrint("总份额是：$total");
    //求出每一份所占的角度
    var radius = (2 * pi) / total; //求出每一份的弧度
    debugPrint("总角度是${2 * pi},每份额角度是:$radius");
    //循环绘制每一份扇形
    for (var i = 0; i < list.length; i++) {
      // 求出初始角度
      double startRadius;
      if (i == 0) {
        startRadius = 0;
      } else {
        startRadius =
            list.sublist(0, i).reduce((value, element) => value + element) *
                radius;
      }
      //求出滑过角度，即当前份额乘以每份所占角度
      var sweepRadius = radius * list[i];
      debugPrint("起始角度：$startRadius,划过角度：$sweepRadius");

      /// 绘制扇形，第一个参数是绘制矩形所在的矩形，第二个参数是起始角度，第三个参数是矩形划过的角度
      /// 第三个参数代表扇形是否是实心，否则就只是绘制边框是空心的，最后一个参数是画笔
      canvas.drawArc(boundingRect, startRadius, sweepRadius, true,
          getPaintByColor(listColor[i]));
    }
  }

  //根据不同的 color 来获取对应的画笔
  Paint getPaintByColor(Color color) {
    var paint = Paint();
    paint.color = color;
    return paint;
  }

  //判断是否需要重绘
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}

Padding getCustomPaint() {
  return Padding(
      padding: EdgeInsets.all(10),
      child: CustomPaint(
        size: Size(200, 200),
        painter: WheelPainter(
            List.of([1.0, 2.0, 3.0, 4.0, 20]),
            List.of([
              Colors.red,
              Colors.blue,
              Colors.green,
              Colors.amber,
              Colors.black54
            ])),
      ));
}
