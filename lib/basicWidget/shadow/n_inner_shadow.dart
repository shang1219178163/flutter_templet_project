//
//  NInnerShadowBox.dart
//  flutter_templet_project
//
//  Created by shang on 2026/7/24 09:19.
//  Copyright © 2026/7/24 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class NInnerShadow extends StatelessWidget {
  const NInnerShadow({
    super.key,
    required this.shadow,
    this.borderRadius = BorderRadius.zero,
    this.blurExtent = 4.0,
    required this.child,
  });

  final BoxShadow shadow;
  final BorderRadius borderRadius;
  final Widget child;

  /// Multiplier used to expand the outer rect to avoid clipping
  /// the blurred shadow.
  ///
  /// The actual padding is:
  ///
  /// `padding = blur * blurExtent`
  ///
  /// Usually 3.0~4.0 is sufficient.
  final double blurExtent;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _InnerShadowPainter(
        shadow: shadow,
        borderRadius: borderRadius,
        blurExtent: blurExtent,
      ),
      child: child,
    );
  }
}

class _InnerShadowPainter extends CustomPainter {
  const _InnerShadowPainter({
    required this.shadow,
    this.blurExtent = 3.0,
    this.borderRadius = BorderRadius.zero,
  });

  final BoxShadow shadow;

  /// Multiplier used to expand the outer rect to avoid clipping
  /// the blurred shadow.
  ///
  /// The actual padding is:
  ///
  /// `padding = blur * blurExtent`
  ///
  /// Usually 3.0~4.0 is sufficient.
  final double blurExtent;

  final BorderRadius borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    /// Gaussian blur sigma.
    final blurSigma = shadow.blurSigma;
    final offset = shadow.offset;
    final spreadRadius = shadow.spreadRadius;

    // 当前组件的绘制区域，从 (0, 0) 到 (width, height)
    final rect = Offset.zero & size;
    final padding = blurSigma * blurExtent;

    // 创建组件内部区域（圆角矩形）
    // 后续会使用它作为裁剪区域，确保阴影只显示在组件内部
    final clipRRect = borderRadius.toRRect(rect);
    final inner = Path()..addRRect(clipRRect);

    // spreadRadius > 0：缩小空洞，阴影向内扩散（覆盖更多内部区域）
    // spreadRadius < 0：扩大空洞，阴影向内收缩
    final holeRRect = clipRRect.deflate(spreadRadius);

    // 创建外部路径
    //
    // PathFillType.evenOdd 表示偶奇填充规则：
    // 最终得到的是「外部矩形 - 内部圆角矩形」形成的一个环形区域。
    //
    // inflate(blur * blurExtent) 用于扩大外部矩形，
    // 防止高斯模糊向外扩散时被裁剪。
    final outer = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(rect.inflate(padding))
      ..addRRect(holeRRect);

    // 保存当前 Canvas 状态（裁剪、变换等）
    canvas.save();

    // 只允许绘制到组件内部
    canvas.clipPath(inner);

    // 平移整个阴影
    //
    // offset 决定光源方向：
    // Offset(2,2) -> 左上亮，右下暗
    // Offset(-2,-2)-> 右下亮，左上暗
    canvas.translate(offset.dx, offset.dy);

    // 绘制环形路径
    canvas.drawPath(outer, shadow.toPaint());

    // 恢复 Canvas 状态
    // 撤销 clipPath() 和 translate() 的影响，
    // 避免影响后续绘制内容。
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _InnerShadowPainter oldDelegate) =>
      shadow != oldDelegate.shadow || borderRadius != oldDelegate.borderRadius || blurExtent != oldDelegate.blurExtent;
}
