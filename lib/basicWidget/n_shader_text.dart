import 'package:flutter/material.dart';

/// 渐变文字效果
class NShaderText extends StatelessWidget {
  const NShaderText({
    super.key,
    this.hasShader = false,
    this.colors = const [
      Colors.transparent,
      Colors.transparent,
      Colors.white,
    ],
    required this.child,
  });

  /// 是否展开  - 展开隐藏渐变色，用于档案多行文本
  final bool hasShader;

  /// 渐变色
  final List<Color> colors;

  /// 子text组件
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!hasShader) {
      return child;
    }

    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: colors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          tileMode: TileMode.clamp,
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcATop,
      child: child,
    );
  }
}
