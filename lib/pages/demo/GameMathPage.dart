import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/util/AppRes.dart';
import 'package:get/get.dart';
import 'package:flutter_templet_project/extension/dlog.dart';

class GameMathPage extends StatefulWidget {
  const GameMathPage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<GameMathPage> createState() => _GameMathPageState();
}

class _GameMathPageState extends State<GameMathPage> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  @override
  void didUpdateWidget(covariant GameMathPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1B),
      appBar: AppBar(
        title: Text('淘汰赛对阵图'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // const Padding(
              //   padding: EdgeInsets.all(16),
              //   child: TournamentView(),
              // ),
              Container(
                height: 500,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  // border: Border.all(color: Colors.blue),
                ),
                child: GameMatchItem(
                  imageUrl: 'https://flagcdn.com/w40/kr.png',
                  text: '韩国男篮',
                  imageUrlRight: 'https://flagpedia.net/data/flags/w40/cn.webp',
                  textRight: '关岛男篮',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 比赛数据
final tournamentData = [
  {
    "team1": {"name": "韩国男篮", "flag": "https://flagcdn.com/w40/kr.png", "score": 99},
    "team2": {"name": "关岛男篮", "flag": "https://flagcdn.com/w40/gum.png", "score": 66}
  },
  {
    "team1": {"name": "日本男篮", "flag": "https://flagcdn.com/w40/jp.png", "score": 73},
    "team2": {"name": "黎巴嫩男篮", "flag": "https://flagcdn.com/w40/lb.png", "score": 97}
  }
];

/// 整个淘汰赛视图
class TournamentView extends StatelessWidget {
  const TournamentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Column(
        //   children: tournamentData
        //       .map((match) => Padding(
        //             padding: const EdgeInsets.symmetric(vertical: 24),
        //             child: MatchCard(
        //               team1: match["team1"]!,
        //               team2: match["team2"]!,
        //             ),
        //           ))
        //       .toList(),
        // ),
        CustomPaint(
          size: const Size(50, 200),
          painter: BracketLinePainter(),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.blue),
          ),
          child: CustomPaint(
            size: const Size(200, 80),
            painter: BracketHorLinePainter(),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.blue),
          ),
          child: NetworkImageWithText(
            imageUrl: AppRes.image.urls.first,
            text: "韩国男篮",
          ),
        ),
        // Flexible(
        //   child: const MatchCard(
        //     team1: {"name": "韩国男篮", "flag": "https://flagcdn.com/w40/kr.png", "score": null},
        //     team2: {"name": "黎巴嫩男篮", "flag": "https://flagcdn.com/w40/lb.png", "score": null},
        //   ),
        // ),
      ],
    );
  }
}

/// 单场比赛卡片
class MatchCard extends StatelessWidget {
  final Map<String, dynamic> team1;
  final Map<String, dynamic> team2;

  const MatchCard({
    super.key,
    required this.team1,
    required this.team2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Flexible(child: _buildTeamRow(team1)),
          const SizedBox(height: 4),
          Flexible(child: _buildTeamRow(team2)),
        ],
      ),
    );
  }

  Widget _buildTeamRow(Map<String, dynamic> team) {
    return Row(
      children: [
        Image.network(team["flag"], width: 24, height: 16, fit: BoxFit.cover),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            team["name"],
            style: const TextStyle(color: Colors.white, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (team["score"] != null)
          Text(
            team["score"].toString(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
      ],
    );
  }
}

/// 连线绘制
class BracketLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white38
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // 上半场到中间
    canvas.drawLine(Offset(0, 25), Offset(size.width / 2, 25), paint);
    canvas.drawLine(Offset(size.width / 2, 25), Offset(size.width / 2, size.height / 2), paint);

    // 下半场到中间
    canvas.drawLine(Offset(0, size.height - 25), Offset(size.width / 2, size.height - 25), paint);
    canvas.drawLine(Offset(size.width / 2, size.height / 2), Offset(size.width / 2, size.height - 25), paint);

    // 中间到决赛
    canvas.drawLine(Offset(size.width / 2, size.height / 2), Offset(size.width, size.height / 2), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BracketHorLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white38
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final paint2 = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final paint3 = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    double paddingX = 25;
    double paddingY = 10;

    double lineHori = (size.width - paddingX * 2) / 2;
    double lineVert = (size.height - paddingY * 2) / 2;

    // 上半场到中间
    canvas.drawLine(Offset(paddingX, paddingY), Offset(paddingX, size.height / 2), paint);
    canvas.drawLine(Offset(paddingX, size.height / 2), Offset(size.width / 2, size.height / 2), paint);

    // 下半场到中间
    canvas.drawLine(Offset(size.width / 2, size.height / 2), Offset(size.width - paddingX, size.height / 2), paint2);
    canvas.drawLine(Offset(size.width - paddingX, size.height / 2), Offset(size.width - paddingX, paddingY), paint2);

    // 中间到决赛
    canvas.drawLine(Offset(size.width / 2, size.height / 2), Offset(size.width / 2, size.height - paddingY), paint3);

    // 1. 定义文字内容与样式
    final textSpan = TextSpan(
      text: "99 - 66",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        backgroundColor: Colors.amberAccent,
      ),
    );

    // 2. 创建 TextPainter
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // 3. 排版
    textPainter.layout();

    // 4. 计算绘制位置（居中）
    // final offset = Offset(
    //   (size.width - textPainter.width) / 2,
    //   (size.height - textPainter.height) / 2,
    // );

    final offset = Offset(
      (size.width - textPainter.width) / 2,
      paddingY,
    );

    // 5. 绘制到 Canvas
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class NetworkImageWithText extends StatefulWidget {
  final String imageUrl;
  final String text;

  const NetworkImageWithText({
    super.key,
    required this.imageUrl,
    required this.text,
  });

  @override
  State<NetworkImageWithText> createState() => _NetworkImageWithTextState();
}

class _NetworkImageWithTextState extends State<NetworkImageWithText> {
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    _loadImage(widget.imageUrl);
  }

  @override
  void didUpdateWidget(covariant NetworkImageWithText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_image == null) {
      _loadImage(widget.imageUrl);
    }
  }

  Future<void> _loadImage(String url) async {
    try {
      final response = await Dio().get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      // 转成 Uint8List
      final Uint8List data = Uint8List.fromList(response.data!);
      final codec = await ui.instantiateImageCodec(data);
      final frame = await codec.getNextFrame();
      _image = frame.image;
      setState(() {});
    } catch (e) {
      debugPrint("图片加载失败: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(80, 100),
      painter: _ImageTextPainter(_image, widget.text),
    );
  }
}

class _ImageTextPainter extends CustomPainter {
  final ui.Image? image;
  final String text;

  _ImageTextPainter(this.image, this.text);

  @override
  void paint(Canvas canvas, Size size) {
    if (image == null) {
      return;
    }

    // 文字绘制
    final textSpan = TextSpan(
      text: text,
      style: const TextStyle(color: Colors.white, fontSize: 14),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // 图片高度（限制最大高度）
    final imgHeight = size.height - textPainter.height - 8;
    final imgWidth = (imgHeight / image!.height) * image!.width;

    // 计算整体垂直居中
    final totalHeight = imgHeight + 8 + textPainter.height;
    final startY = (size.height - totalHeight) / 2;

    // 绘制图片（居中）
    final imgRect = Rect.fromLTWH(
      (size.width - imgWidth) / 2,
      startY,
      imgWidth,
      imgHeight,
    );
    paintImage(
      canvas: canvas,
      rect: imgRect,
      image: image!,
      fit: BoxFit.contain,
    );

    // 绘制文字（在图片下方居中）
    final textOffset = Offset(
      (size.width - textPainter.width) / 2,
      startY + imgHeight + 4,
    );
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class GameMatchItem extends StatefulWidget {
  const GameMatchItem({
    super.key,
    required this.imageUrl,
    required this.text,
    required this.imageUrlRight,
    required this.textRight,
  });

  final String imageUrl;
  final String text;

  final String imageUrlRight;
  final String textRight;

  @override
  State<GameMatchItem> createState() => _GameMatchItemState();
}

class _GameMatchItemState extends State<GameMatchItem> {
  ui.Image? _image;
  ui.Image? _imageRight;

  @override
  void initState() {
    super.initState();

    initData();
  }

  initData() async {
    _image = await _loadImage(widget.imageUrl);
    _imageRight = await _loadImage(widget.imageUrlRight);
  }

  @override
  void didUpdateWidget(covariant GameMatchItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_image == null || _imageRight == null) {
      initData();
    }
  }

  Future<ui.Image?> _loadImage(String url) async {
    ui.Image? _image;
    try {
      final response = await Dio().get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      // 转成 Uint8List
      final Uint8List data = Uint8List.fromList(response.data!);
      final codec = await ui.instantiateImageCodec(data);
      final frame = await codec.getNextFrame();
      _image = frame.image;
    } catch (e) {
      debugPrint("图片加载失败: $e");
    }
    return _image;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(80, 100),
      painter: GameMatchItemPainter(
        image: _image,
        text: widget.text,
        imageRight: _imageRight,
        textRight: widget.textRight,
      ),
    );
  }
}

class GameMatchItemPainter extends CustomPainter {
  GameMatchItemPainter({
    required this.image,
    required this.text,
    required this.imageRight,
    required this.textRight,
  });

  final ui.Image? image;
  final String text;

  final ui.Image? imageRight;
  final String textRight;

  @override
  void paint(Canvas canvas, Size size) {
    final bool isVer = size.height > size.width;
    double lineHor = 50;
    double lineVer = 20;

    double leve1Hor = lineHor * 2.4;
    double leve2Hor = lineHor * 1.2;
    double leve3Hor = lineHor * 0.6;

    if (isVer) {
      leve1Hor = size.width / 4;
      leve2Hor = size.width / 4 - 3 * 10 - 20;
      leve3Hor = size.width / 8 - 7 * 4 + 4;
    } else {
      leve1Hor = size.width / 4;
      leve2Hor = size.width / 5 - 3 * 10 - 20;
      leve3Hor = size.width / 12 - 7 * 4 + 4;
    }

    DLog.d([size, leve1Hor, leve2Hor, leve3Hor].asMap());

    final level0 =
        paintGameItem(canvas, size, startPoint: size.center(ui.Offset(0, 100)), lineVer: lineVer, lineHor: leve1Hor);
    final level10 = paintGameItem(canvas, size, startPoint: level0.leftEndPoint, lineVer: lineVer, lineHor: leve2Hor);
    final level11 = paintGameItem(canvas, size, startPoint: level0.rightEndPoint, lineVer: lineVer, lineHor: leve2Hor);

    final level20 = paintGameItem(canvas, size, startPoint: level10.leftEndPoint, lineVer: lineVer, lineHor: leve3Hor);
    final level21 = paintGameItem(canvas, size, startPoint: level10.rightEndPoint, lineVer: lineVer, lineHor: leve3Hor);

    final level22 = paintGameItem(canvas, size, startPoint: level11.leftEndPoint, lineVer: lineVer, lineHor: leve3Hor);
    final level23 = paintGameItem(canvas, size, startPoint: level11.rightEndPoint, lineVer: lineVer, lineHor: leve3Hor);

    final level0Bom = paintGameItem(canvas, size,
        isReverse: false, startPoint: size.center(ui.Offset(0, 100 + 60)), lineVer: lineVer, lineHor: leve1Hor);
    final level10Bom = paintGameItem(canvas, size,
        isReverse: false, startPoint: level0Bom.leftEndPoint, lineVer: lineVer, lineHor: leve2Hor);
    final level11Bom = paintGameItem(canvas, size,
        isReverse: false, startPoint: level0Bom.rightEndPoint, lineVer: lineVer, lineHor: leve2Hor);

    final level20Bom = paintGameItem(canvas, size,
        isReverse: false, startPoint: level10Bom.leftEndPoint, lineVer: lineVer, lineHor: leve3Hor);
    final level21Bom = paintGameItem(canvas, size,
        isReverse: false, startPoint: level10Bom.rightEndPoint, lineVer: lineVer, lineHor: leve3Hor);

    final level22Bom = paintGameItem(canvas, size,
        isReverse: false, startPoint: level11Bom.leftEndPoint, lineVer: lineVer, lineHor: leve3Hor);
    final level23Bom = paintGameItem(canvas, size,
        isReverse: false, startPoint: level11Bom.rightEndPoint, lineVer: lineVer, lineHor: leve3Hor);

    /// 决赛
    final left = size.center(ui.Offset(0 - 50, 165));
    final right = size.center(ui.Offset(0 + 50, 165));

    paintGameImageAndText(canvas, size, isReverse: true, startPoint: left, text: text, image: image);
    paintGameImageAndText(canvas, size, isReverse: true, startPoint: right, text: text, image: imageRight);

    return;

    // // 绘制曲线
    // var line = paintGameLine(
    //   canvas,
    //   size,
    //   startPoint: size.center(ui.Offset.zero),
    //   lineHori: lineHori,
    //   lineVert: lineVert,
    // );
    //
    // // 比分
    // customDrawTextCenter(
    //   canvas,
    //   point: Offset(
    //     line.startPoint.dx,
    //     line.startPoint.dy - lineVert - lineVert / 2,
    //   ),
    //   text: "99 - 66",
    //   style: const TextStyle(
    //     color: Colors.white,
    //     fontSize: 14,
    //     fontWeight: FontWeight.bold,
    //     backgroundColor: Colors.green,
    //   ),
    // );
    //
    // /// 绘制左边图文
    // paintGameImageAndText(canvas, size, startPoint: line.leftEndPoint, text: text, image: image!);
    //
    // /// 绘制右边图文
    // paintGameImageAndText(canvas, size, startPoint: line.rightEndPoint, text: textRight, image: image!);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  ({ui.Offset startPoint, ui.Offset leftEndPoint, ui.Offset rightEndPoint}) paintGameItem(
    Canvas canvas,
    Size size, {
    bool isReverse = true,
    bool isLeftWin = true,
    required Offset startPoint,
    double lineHor = 60,
    double lineVer = 30,
  }) {
    double factor = isReverse == true ? 1.0 : -1.0;

    // 绘制曲线
    var line = paintGameLine(
      canvas,
      size,
      isLeftWin: isLeftWin,
      isReverse: isReverse,
      startPoint: startPoint,
      lineHori: lineHor,
      lineVert: lineVer,
    );

    // 比分
    customDrawTextCenter(
      canvas,
      point: Offset(
        line.startPoint.dx,
        line.startPoint.dy - (lineVer + lineVer / 2) * factor,
      ),
      text: "99 - 66",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.bold,
        backgroundColor: Colors.green,
      ),
    );

    /// 绘制左边图文
    var left = paintGameImageAndText(
      canvas,
      size,
      isReverse: isReverse,
      startPoint: line.leftEndPoint,
      text: text,
      image: image,
    );

    /// 绘制右边图文
    var right = paintGameImageAndText(
      canvas,
      size,
      isReverse: isReverse,
      startPoint: line.rightEndPoint,
      text: textRight,
      image: imageRight,
    );
    return (startPoint: startPoint, leftEndPoint: left.endPoint, rightEndPoint: right.endPoint);
  }

  /// 绘制线
  ({ui.Offset startPoint, ui.Offset leftEndPoint, ui.Offset rightEndPoint}) paintGameLine(
    Canvas canvas,
    Size size, {
    double radius = 4.0,
    required bool isLeftWin,
    required bool isReverse,
    required ui.Offset startPoint,
    double lineHori = 120,
    double lineVert = 60,
  }) {
    final strokeColor = Colors.white38;
    final winStrokeColor = Colors.red;

    final paintCenter = Paint()
      ..color = isLeftWin ? winStrokeColor : strokeColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final paintLeft = Paint()
      ..color = isLeftWin ? winStrokeColor : strokeColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final paintRight = Paint()
      ..color = !isLeftWin ? winStrokeColor : strokeColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    var centerPoint = Offset(startPoint.dx, startPoint.dy - lineVert);
    var pointLeft1 = Offset(centerPoint.dx - lineHori, centerPoint.dy);
    var pointLeft2 = Offset(pointLeft1.dx, pointLeft1.dy - lineVert);
    var pointRight1 = Offset(centerPoint.dx + lineHori, centerPoint.dy);
    var pointRight2 = Offset(pointRight1.dx, pointRight1.dy - lineVert);

    if (!isReverse) {
      centerPoint = Offset(startPoint.dx, startPoint.dy + lineVert);
      pointLeft1 = Offset(centerPoint.dx - lineHori, centerPoint.dy);
      pointLeft2 = Offset(pointLeft1.dx, pointLeft1.dy + lineVert);
      pointRight1 = Offset(centerPoint.dx + lineHori, centerPoint.dy);
      pointRight2 = Offset(pointRight1.dx, pointRight1.dy + lineVert);
    }

    // 中间到决赛
    canvas.drawLine(startPoint, centerPoint, paintCenter);
    // // 中间到上半场
    // canvas.drawLine(centerPoint, pointLeft1, paintLeft);
    // canvas.drawLine(pointLeft1, pointLeft2, paintLeft);
    // 下半场到中间
    // canvas.drawLine(centerPoint, pointRight1, paintRight);
    // canvas.drawLine(pointRight1, pointRight2, paintRight);

    paintCornerArc(
      canvas: canvas,
      paint: paintLeft,
      radius: radius,
      centerPoint: centerPoint,
      point1: pointLeft1,
      point2: pointLeft2,
      alignment: isReverse ? Alignment.bottomLeft : Alignment.topLeft,
    );

    paintCornerArc(
      canvas: canvas,
      paint: paintRight,
      radius: radius,
      centerPoint: centerPoint,
      point1: pointRight1,
      point2: pointRight2,
      alignment: isReverse ? Alignment.bottomRight : Alignment.topRight,
    );

    return (startPoint: startPoint, leftEndPoint: pointLeft2, rightEndPoint: pointRight2);
  }

  /// 绘制四角圆弧
  void paintCornerArc({
    required Canvas canvas,
    required Paint paint,
    double radius = 4.0,
    required ui.Offset centerPoint,
    required ui.Offset point1,
    required ui.Offset point2,
    required Alignment alignment,
  }) {
    var arcPointStart = point1.translate(radius, 0);
    var arcPointEnd = point1.translate(0, -radius);

    var startAngle = 0.0;
    var sweepAngle = math.pi / 2;

    switch (alignment) {
      case Alignment.bottomLeft:
        {
          arcPointStart = point1.translate(radius, 0);
          arcPointEnd = point1.translate(0, -radius);

          startAngle = math.pi / 2;
          sweepAngle = math.pi / 2;
        }
        break;
      case Alignment.topLeft:
        {
          arcPointStart = point1.translate(radius, 0);
          arcPointEnd = point1.translate(0, radius);

          startAngle = -math.pi;
          sweepAngle = math.pi / 2;
        }
        break;
      case Alignment.bottomRight:
        {
          arcPointStart = point1.translate(-radius, 0);
          arcPointEnd = point1.translate(0, -radius);

          startAngle = math.pi / 2;
          sweepAngle = -math.pi / 2;
        }
        break;
      case Alignment.topRight:
        {
          arcPointStart = point1.translate(-radius, 0);
          arcPointEnd = point1.translate(0, radius);

          startAngle = math.pi / 2 * 3;
          sweepAngle = math.pi / 2;
        }
        break;
      default:
        break;
    }

    canvas.drawLine(centerPoint, arcPointStart, paint);
    canvas.drawLine(arcPointEnd, point2, paint);

    // 定义圆的外接矩形
    final rect = Rect.fromCircle(
      center: ui.Offset(arcPointStart.dx, arcPointEnd.dy),
      radius: radius,
    );
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  /// 上图下字
  ({ui.Offset startPoint, ui.Offset endPoint}) paintGameImageAndText(
    Canvas canvas,
    Size size, {
    required bool isReverse,
    required ui.Offset startPoint,
    required String text,
    required ui.Image? image,
  }) {
    // 图片高度（限制最大高度）
    double imgHeight = 30;
    double imgWidth = 30;
    double imgTextSpacing = 4;

    double factor = isReverse == true ? 1.0 : -1.0;

    // 文字绘制
    final textSpan = TextSpan(
      text: text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 9,
        backgroundColor: Colors.green,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // 5. 绘制到 Canvas
    var offset = Offset(
      startPoint.dx - textPainter.width / 2,
      startPoint.dy - (textPainter.height + imgTextSpacing) * factor,
    );

    if (!isReverse) {
      offset = Offset(
        startPoint.dx - textPainter.width / 2,
        startPoint.dy + imgTextSpacing + imgHeight,
      );
    }

    textPainter.paint(canvas, offset);

    // 总高度
    final totalHeight = imgHeight + imgTextSpacing * 2 + textPainter.height;

    final endPoint = Offset(startPoint.dx, startPoint.dy - totalHeight * factor);

    if (image != null) {
      // 绘制图片（居中）
      var imgRect = Rect.fromCenter(
        center: Offset(endPoint.dx, endPoint.dy + imgHeight / 2 * factor),
        width: imgWidth,
        height: imgHeight,
      );

      if (!isReverse) {
        imgRect = Rect.fromCenter(
          center: Offset(endPoint.dx, startPoint.dy + imgHeight / 2),
          width: imgWidth,
          height: imgHeight,
        );
      }

      final paintCenter = Paint()
        ..color = Colors.white38
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      canvas.drawRect(imgRect, paintCenter);

      paintImage(
        canvas: canvas,
        rect: imgRect,
        image: image!,
        fit: BoxFit.contain,
      );
    }
    return (startPoint: startPoint, endPoint: endPoint);
  }

  /// 绘制文字居中
  TextPainter customDrawTextCenter(
    Canvas canvas, {
    required Offset point,
    required String text,
    required TextStyle style,
  }) {
    // InlineSpan? text
    // 1. 定义文字内容与样式

    // 1. 创建 TextPainter
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    // 3. 排版
    textPainter.layout();
    // 4. 计算绘制位置（居中）
    final offset = Offset(
      point.dx - textPainter.width / 2,
      point.dy - textPainter.height / 2,
    );

    // 5. 绘制到 Canvas
    textPainter.paint(canvas, offset);
    return textPainter;
  }
}
