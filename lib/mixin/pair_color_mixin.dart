import 'package:flutter/painting.dart';

/// 成对颜色（枚举专用，可按进度在列表项之间插值）
mixin PairColorMixin<T> {
  Color get color;
  Color get other;

  /// 按进度 [t] 插值相邻项的 (colorA, colorB)
  ///
  /// t 示例:  tabController.animation!.value
  static (Color, Color) lerpColors(List<PairColorMixin> values, double t) {
    // 当前页下标（向下取整）
    final i = t.floor().clamp(0, values.length - 1);
    // 下一页下标（末页时与 i 相同）
    final j = (i + 1).clamp(0, values.length - 1);
    // 两页之间的插值比例 [0, 1]
    final frac = (t - i).clamp(0.0, 1.0);
    // 背景色：相邻两页 colorA 插值
    final bg = Color.lerp(values[i].color, values[j].color, frac)!;
    // 前景色：相邻两页 colorB 插值
    final fg = Color.lerp(values[i].other, values[j].other, frac)!;
    // 返回 (背景, 前景)
    return (bg, fg);
  }
}
