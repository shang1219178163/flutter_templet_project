import 'package:flutter/material.dart';

/// 手指动画
class NAnimatedFinger extends StatelessWidget {
  const NAnimatedFinger({
    super.key,
    required this.child,
    this.offset = 0,
    this.scale = 1.0,
    this.isShow = true,
    this.offsetX,
    this.handsX,
    this.handsY,
  });

  final Widget child;

  final double scale;
  final double offset;
  final double? offsetX;
  final bool isShow;

  final double? handsX;
  final double? handsY;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.center,
      children: [
        child,
        if (isShow)
          Positioned(
            top: offset,
            right: -20,
            left: offsetX ?? -20,
            child: IgnorePointer(
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.center,
                child: Center(
                  child: SizedBox(
                    width: 52,
                    height: 52,
                    child: buildFingerIcon(handsX: handsX, handsY: handsY),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget buildFingerIcon({double? handsX, double? handsY}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: 52,
          height: 52,
          child: Image.asset(
            "assets/images/icon_finger_target.png",
            width: 52,
            height: 52,
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          top: handsX ?? 24,
          right: handsY ?? -14,
          child: Image.asset(
            "assets/images/icon_finger.png",
            width: 42,
            height: 42,
            fit: BoxFit.fill,
          ),
        ),
      ],
    );
  }
}
