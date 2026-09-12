//
//  color_ext.dart
//  flutter_templet_project
//
//  Created by shang on 7/16/21 2:08 PM.
//  Copyright © 7/16/21 shang. All rights reserved.
//

import 'dart:math';

import 'package:color_converter/color_converter.dart';
import 'package:flutter/material.dart';

/// [Color] 常用扩展：解析、格式化、亮度适配文字色等
extension ColorExt on Color {
  /// 随机不透明色（`#RRGGBB`，alpha 固定为 `FF`）
  static Color get random => Color(0xFF000000 | Random().nextInt(0x1000000));

  /// 十六进制字符串转 [Color]
  ///
  /// 支持 `#RRGGBB` / `#AARRGGBB`，以及 `0x` 前缀；6 位时自动补 `FF` alpha。
  /// [alpha] 最终透明度，范围 `[0.0, 1.0]`。
  static Color? fromHex(String? val, {double alpha = 1}) {
    if (val == null || val.isEmpty) {
      return null;
    }
    var hex = val.replaceAll(RegExp(r'#|0[xX]'), '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    final v = int.tryParse(hex, radix: 16);
    return v == null ? null : Color(v).withValues(alpha: alpha);
  }

  /// CSS 风格颜色字符串转 [Color]
  ///
  /// 支持：
  /// - `rgb(r,g,b)` / `rgba(r,g,b)`（不透明，alpha = 1）
  /// - `rgba(r,g,b,a)` / `rgb(r,g,b,a)`（含透明通道）
  static Color? fromRGBA(String? val) {
    final m = RegExp(
      r'rgba?\(\s*([\d.]+)\s*,\s*([\d.]+)\s*,\s*([\d.]+)(?:\s*,\s*([\d.]+))?\s*\)',
    ).firstMatch(val ?? '');
    if (m == null) {
      return null;
    }

    final r = int.tryParse(m.group(1) ?? '');
    final g = int.tryParse(m.group(2) ?? '');
    final b = int.tryParse(m.group(3) ?? '');
    if (r == null || g == null || b == null) {
      return null;
    }

    final a = double.tryParse(m.group(4) ?? '') ?? 1;
    return Color.fromRGBO(r, g, b, a);
  }

  /// 是否为全透明黑（`r/g/b/a` 均为 0）
  bool get isPureBlack => r == 0 && g == 0 && b == 0 && a == 0;

  /// 是否为全透明白（`r/g/b == 1` 且 `a == 0`；组件值为 0.0–1.0）
  bool get isPureWhite => r == 1 && g == 1 && b == 1 && a == 0;

  /// 0–255 的 `(R, G, B)` 分量
  (int, int, int) get rgb => ((r * 255).round(), (g * 255).round(), (b * 255).round());

  /// `#RRGGBB`（大写，不含 alpha）
  String get hex {
    final (rr, gg, bb) = rgb;
    return '#${rr.toRadixString(16).padLeft(2, '0')}'
            '${gg.toRadixString(16).padLeft(2, '0')}'
            '${bb.toRadixString(16).padLeft(2, '0')}'
        .toUpperCase();
  }

  /// RGB 文本，如 `(255,128,0)`
  String get rgbText {
    final (rr, gg, bb) = rgb;
    return '($rr,$gg,$bb)';
  }

  /// CMYK 文本，如 `(0,50,100,0)`
  String get cmykText {
    final (rr, gg, bb) = rgb;
    final cmyk = RGB(r: rr, g: gg, b: bb).toCmyk();
    return '(${cmyk.c},${cmyk.m},${cmyk.y},${cmyk.k})';
  }

  /// 转为单色线性渐变（两端同色，便于接口统一传 [Gradient]）
  Gradient? toGradient() => LinearGradient(colors: [this, this], stops: const [0.0, 1]);

  /// 随机透明度（alpha ∈ [0.00, 0.99]）
  Color randomOpacity() => withValues(alpha: Random().nextInt(100) / 100);

  /// 根据当前背景亮度选择前景文字色
  ///
  /// 深色底用 [textColorDark]，浅色底用 [textColorLight]；
  /// 并单独处理 [isPureWhite] / [isPureBlack] 边界。
  Color textColor({
    Color textColorLight = Colors.black,
    Color textColorDark = Colors.white,
  }) {
    var brightness = ThemeData.estimateBrightnessForColor(this);
    var textColor = brightness == Brightness.dark ? textColorDark : textColorLight;
    if (isPureWhite) {
      textColor = textColorDark;
    } else if (isPureBlack) {
      textColor = textColorLight;
    }
    return textColor;
  }
}
