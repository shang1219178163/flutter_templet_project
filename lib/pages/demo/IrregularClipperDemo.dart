import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart';

class IrregularClipperDemo extends StatefulWidget {
  const IrregularClipperDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<IrregularClipperDemo> createState() => _IrregularClipperDemoState();
}

class _IrregularClipperDemoState extends State<IrregularClipperDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final _scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  @override
  void didUpdateWidget(covariant IrregularClipperDemo oldWidget) {
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
                        onPressed: () => debugPrint(e),
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
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.all(Radius.circular(0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ClipPath(
                      clipper: IrregularRectangleClipper(
                        diffWidth: 24,
                        // transform: (size) => Matrix4.rotationZ(math.pi)..translate(-size.width, -size.height),
                      ),
                      child: buildContent(
                        title: '天王盖地虎',
                        subtitle: '天王盖地虎' * 3,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipPath(
                      clipper: IrregularRectangleClipper(
                        diffWidth: 24,
                        transform: (size) => Matrix4.rotationZ(math.pi)..translate(-size.width, -size.height),
                      ),
                      child: buildContent(
                        title: '宝塔镇河妖',
                        subtitle: '宝塔镇河妖' * 3,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ClipPath(
                      clipper: IrregularRectangleClipper(
                        topLeftRadius: 8,
                        topRightRadius: 16,
                        bottomLeftRadius: 24,
                        bottomRightRadius: 32,
                        // clockwise: false,
                      ),
                      child: buildContent(
                        title: '天王盖地虎4',
                        subtitle: '天王盖地虎' * 3,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: ClipPath(
                      clipper: IrregularRectangleClipper(
                        topLeftRadius: 8,
                        topRightRadius: 16,
                        bottomLeftRadius: 24,
                        bottomRightRadius: 32,
                        clockwise: false,
                      ),
                      child: buildContent(
                        title: '天王盖地虎4',
                        subtitle: '天王盖地虎' * 3,
                      ),
                    ),
                  ),
                ],
              ),
            ]
                .map((e) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: e,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget buildContent({
    AssetImage? bg,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 20, top: 20, bottom: 20),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: bg ?? AssetImage("assets/images/shan.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.blue),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NText(
                title,
                color: AppColor.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                maxLines: 1,
              ),
              NText(
                subtitle,
                color: AppColor.white,
                fontWeight: FontWeight.w500,
                fontSize: 12,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 首页按钮裁切
class IrregularRectangleClipper extends CustomClipper<Path> {
  IrregularRectangleClipper({
    this.transform,
    this.topLeftRadius = 8.0,
    this.bottomLeftRadius = 8.0,
    this.topRightRadius = 8.0,
    this.bottomRightRadius = 8.0,
    this.diffWidth = 20,
    this.clockwise = true,
  });

  final double topLeftRadius;
  final double bottomLeftRadius;
  final double topRightRadius;
  final double bottomRightRadius;
  final double diffWidth;
  final Matrix4 Function(Size size)? transform;

  final bool clockwise;

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

  @override
  Path getClip(Size size) {
    final path = Path()
      // topLeft
      ..moveTo(0, topLeftRadius)
      ..arcToPoint(
        Offset(topLeftRadius, 0),
        radius: Radius.circular(topLeftRadius),
        clockwise: clockwise,
      )
      // move to topRight
      ..lineTo(size.width - diffWidth, 0)
      ..arcToPoint(
        Offset(size.width - diffWidth + topRightRadius, topRightRadius),
        radius: Radius.circular(topRightRadius),
        clockwise: clockwise,
      )
      // // move to bottomRight
      ..lineTo(size.width, size.height - bottomRightRadius)
      ..arcToPoint(
        Offset(size.width - bottomRightRadius, size.height),
        radius: Radius.circular(bottomRightRadius),
        clockwise: clockwise,
      )
      // // move to bottomLeft
      ..lineTo(bottomLeftRadius, size.height)
      ..arcToPoint(
        Offset(0, size.height - bottomLeftRadius),
        radius: Radius.circular(bottomLeftRadius),
        clockwise: clockwise,
      )
      ..close();

    if (transform != null) {
      return path.transform(transform!(size).storage);
    }
    return path;
  }

  // @override
  // Path getClip(Size size) {
  //   debugPrint("getClip: $size");
  //   final width = size.width;
  //   // 钝角的 1/2
  //   final vertexRadians = math.atan(size.height / diffWidth) + 90 * (math.pi / width) / 2;
  //
  //   // 右上角弧度 相较于直角 所缺失的长度
  //   final xLeftSide = topRightRadius / math.sin(vertexRadians);
  //   final ySide = xLeftSide * math.cos(width * (math.pi / width) - vertexRadians);
  //   final xRightSide = math.sqrt(xLeftSide * xLeftSide - ySide * ySide);
  //
  //   final path = Path()
  //     // topLeft
  //     ..moveTo(0, topLeftRadius)
  //     ..arcToPoint(Offset(topLeftRadius, 0), radius: Radius.circular(topLeftRadius))
  //     // move to topRight
  //     ..lineTo(size.width - diffWidth, 0)
  //     ..arcToPoint(Offset(size.width - diffWidth + xRightSide, ySide), radius: Radius.circular(topRightRadius))
  //     // // move to bottomRight
  //     ..lineTo(size.width, size.height - bottomRightRadius)
  //     ..arcToPoint(Offset(size.width - bottomRightRadius, size.height), radius: Radius.circular(bottomRightRadius))
  //     // // move to bottomLeft
  //     ..lineTo(bottomLeftRadius, size.height)
  //     ..arcToPoint(Offset(0, size.height - bottomLeftRadius), radius: Radius.circular(bottomLeftRadius))
  //     ..close();
  //
  //   return transform == null ? path : path.transform(transform!(size).storage);
  // }

  // /// 直角三角形的顶角弧度
  // double _computeVertexRadians({
  //   required double rtBase,
  //   required double rtHeight,
  // }) {
  //   return math.atan(rtHeight / rtBase);
  // }
}
