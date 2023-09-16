
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';


class AssetImageStretch extends StatelessWidget {
  const AssetImageStretch({
    super.key,
    this.path = "assets/images/bg_chat_bubble_to.png",
    this.center = const Rect.fromLTRB(16, 8, 12, 8),
    required this.child,
    this.loading,
    this.error,
  });

  final String path;
  final Widget? loading;
  final Widget? error;

  final Widget? child;

  final Rect center;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getImageFromAssets(path),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return loading ?? const Text('加载中');
        }

        final data = snapshot.data;
        if (data == null) {
          return error ?? const Text('加载失败');
        }

        return CustomPaint(
          painter: AssetImageStretchPainter(
            data,
            // center: center,
            center: Rect.fromLTWH(center.left, center.top, 1, 1),
          ),
          child: Container(
            margin: EdgeInsets.only(
              left: center.left,
              top: center.top,
              right: center.right,
              bottom: center.bottom,
            ),
            child: child,
          ),
        );
      },
    );
  }

  Future<ui.Image> getImageFromAssets(String path) async {
    final immutableBuffer = await rootBundle.loadBuffer(path);
    final codec = await ui.instantiateImageCodecFromBuffer(
      immutableBuffer,
    );
    final frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }
}

class AssetImageStretchPainter extends CustomPainter {
  const AssetImageStretchPainter(this.image, {required this.center});
  final ui.Image image;
  final Rect center;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImageNine(image, center, Offset.zero & size, Paint());
  }

  @override
  bool shouldRepaint(covariant AssetImageStretchPainter oldDelegate) {
    return image != oldDelegate.image || center != oldDelegate.center;
  }
}
