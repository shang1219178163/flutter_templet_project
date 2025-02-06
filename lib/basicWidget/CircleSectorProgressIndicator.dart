import 'dart:math';
import 'package:flutter/material.dart';

/// 环形进度指示器
class CircleSectorProgressIndicator extends StatelessWidget {
  CircleSectorProgressIndicator({
    Key? key,
    required this.width,
    required this.height,
    required this.progressVN,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.child,
  }) : super(key: key);

  final double width;
  final double height;

  final ValueNotifier<double> progressVN;

  final BorderRadius? borderRadius;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: progressVN,
      child: child,
      builder: (context, value, child) {
        debugPrint("value: $value");
        final precent = (value * 100).toInt().toStringAsFixed(0);
        var precentStr = "$precent%";
        if (precent == "0") {
          precentStr = "加载中";
        }

        return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: width,
                height: height,
                child: child ?? FlutterLogo(),
              ),
              ClipPath(
                clipper: CircleSectorProgressClipper(
                  progress: value,
                ),
                child: Container(
                  width: width,
                  height: height,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
              Positioned(
                child: Text(
                  precentStr,
                  style: TextStyle(
                    color: Color(0xffEDFBFF),
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

/// 扇形进度条
class CircleSectorProgressClipper extends CustomClipper<Path> {
  final double progress;

  CircleSectorProgressClipper({
    this.progress = 0,
  });

  @override
  Path getClip(Size size) {
    // 灰色区域
    var zone = Path()..addRect(Rect.fromLTRB(0, 0, size.width, size.height));
    if (progress == 0) {
      // return Path();
      return Path.combine(PathOperation.xor, Path(), zone);
    }

    var halfWidth = size.width / 2;
    var halfHeight = size.height / 2;
    // 蓝色弧线
    var outRadius = sqrt(pow(halfWidth, 2) + pow(halfHeight, 2));
    // debugPrint("halfWidth: $halfWidth, halfHeight: $halfHeight, outRadius: $outRadius");

    final rect = Rect.fromCenter(
      center: Offset(halfWidth, halfHeight),
      width: outRadius * 2,
      height: outRadius * 2,
    );
    // debugPrint("rect: $rect");

    var path = Path()
      ..moveTo(size.width / 2, size.height / 2)
      ..relativeLineTo(0, -size.height / 2)
      ..arcTo(rect, -pi / 2, pi * 2 * progress, false);
    return Path.combine(PathOperation.xor, path, zone);
  }

  @override
  bool shouldReclip(covariant CircleSectorProgressClipper oldClipper) {
    return progress != oldClipper.progress;
  }
}
