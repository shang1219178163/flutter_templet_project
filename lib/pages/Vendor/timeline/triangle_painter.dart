import 'package:flutter/cupertino.dart';
//自绘图像小三角
class TrianglePainter extends CustomPainter {

  Color color; //填充颜色
  // Paint painter; //画笔
  Path path; //绘制路径
  // double angle; //角度

  TrianglePainter({
    required this.color,
    required this.path,
    // required this.painter,
  }) {
    // painter = Paint()
    //   ..strokeWidth = 1.0 //线宽
    //   ..color = color
    //   ..isAntiAlias = true;
  }
  // TrianglePainter(this.color) {
  //   _paint = Paint()
  //     ..strokeWidth = 1.0 //线宽
  //     ..color = color
  //     ..isAntiAlias = true;
  //   _path = Path();
  // }

  @override
  void paint(Canvas canvas, Size size) {
    Paint painter = Paint()
        ..strokeWidth = 1.0 //线宽
        ..color = color
        ..isAntiAlias = true;

    // TODO: implement paint
    final baseX = size.width * 0.5;
    final baseY = size.height;
    //起点
    path.moveTo(baseX - 0.86 * baseX, 1.5 * baseY);
    path.lineTo(baseX + 0.86 * baseX, 1.5 * baseY);
    path.lineTo(baseX - 0.86 * baseX, 0.5 * baseY);
    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}