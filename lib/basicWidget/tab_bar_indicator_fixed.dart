//
//  TabBarIndicatorFixed.dart
//  flutter_templet_project
//
//  Created by shang on 4/6/23 11:12 AM.
//  Copyright © 4/6/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class TabBarIndicatorFixed extends Decoration {
  /// Create an underline style selected tab indicator.
  ///
  /// The [borderSide] and [insets] arguments must not be null.
 const TabBarIndicatorFixed({
    this.width = 20,
    this.height = 4.0,
    this.borderSide = const BorderSide(width: 0.0, color: Colors.redAccent),
    this.insets = EdgeInsets.zero,
    this.radius = 4.0,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.color = Colors.redAccent,
    this.shadowColor,
    this.shadowElevation = 4,
  });

  /// The color and weight of the horizontal line drawn below the selected tab.
 final BorderSide borderSide;

  /// Locates the selected tab's underline relative to the tab's boundary.
  ///
  /// The [TabBar.indicatorSize] property can be used to define the tab
  /// indicator's bounds in terms of its (centered) tab widget with
  /// [TabBarIndicatorSize.label], or the entire tab with
  /// [TabBarIndicatorSize.tab].
  final EdgeInsetsGeometry insets;

// 圆角
  final double radius;
// 周围内边距间距
  @override
  final EdgeInsets padding;
// 周围间距
  final EdgeInsets margin;
// 颜色
  final Color color;
// 阴影颜色
  final Color? shadowColor;

  final double shadowElevation;

// 宽度
  final double width;
// 高度
  final double height;


  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is TabBarIndicatorFixed) {
      return TabBarIndicatorFixed(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b is TabBarIndicatorFixed) {
      return TabBarIndicatorFixed(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _UnderlinePainter(this, onChanged);
  }

  // 计算 indicator 的 rect
  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    final indicator = insets.resolve(textDirection).deflateRect(rect);
    return Rect.fromLTWH(
      indicator.left +
          (indicator.width - width - padding.left - padding.right) * 0.5,
      indicator.height - height - padding.top - padding.bottom - margin.bottom,
      width + padding.left + padding.right,
      height + padding.top + padding.bottom,
    );
  }

  @override
  Path getClipPath(Rect rect, TextDirection textDirection) {
    return Path()
      ..addRect(_indicatorRectFor(rect, textDirection));
  }
}

class _UnderlinePainter extends BoxPainter {
  _UnderlinePainter(this.decoration, VoidCallback? onChanged)
      : super(onChanged);

  final TabBarIndicatorFixed decoration;

  ///决定控制器边角形状的方法
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final rect = offset & configuration.size!;
    final textDirection = configuration.textDirection!;
    final indicator = decoration
        ._indicatorRectFor(rect, textDirection)
        .deflate(decoration.borderSide.width / 2.0);
    // 定义绘制的样式
    final rrect = RRect.fromRectAndRadius(indicator, Radius.circular(decoration.radius));
    final paint = decoration.borderSide.toPaint()
      ..style = PaintingStyle.fill
      ..color = decoration.color;

    final path = Path()
      ..addRRect(rrect.shift(Offset(1, 1)));
    // 绘制阴影
    if (decoration.shadowColor != null) {
      canvas.drawShadow(path, decoration.shadowColor!, decoration.shadowElevation, false);
    }
    // 绘制圆角矩形
    canvas.drawRRect(rrect, paint);
  }
}
