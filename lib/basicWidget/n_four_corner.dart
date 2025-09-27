import 'package:flutter/material.dart';

/// 四角有图标
class NFourCorner extends StatelessWidget {
  NFourCorner({
    Key? key,
    required this.child,
    this.cornerImage = const AssetImage("assets/images/icon_corner.png"),
    this.cornerImageSize = 20,
    this.cornerImageColor,
  }) : super(key: key);

  final Widget child;

  /// 四角图片
  final AssetImage cornerImage;

  /// 图片大小
  final double cornerImageSize;

  /// 图片颜色
  final Color? cornerImageColor;

  @override
  Widget build(BuildContext context) {
    final image = Image(
      image: cornerImage,
      width: cornerImageSize,
      height: cornerImageSize,
      color: cornerImageColor,
    );

    return Stack(
      children: [
        child,
        Positioned(
          top: 0,
          left: 0,
          child: RotatedBox(
            quarterTurns: 0,
            child: image,
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: RotatedBox(
            quarterTurns: 1,
            child: image,
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: RotatedBox(
            quarterTurns: 2,
            child: image,
          ),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          child: RotatedBox(
            quarterTurns: 3,
            child: image,
          ),
        ),
      ],
    );
  }
}
