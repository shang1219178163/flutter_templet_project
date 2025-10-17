import 'package:flutter/material.dart';

/// 弹窗 主题文件
class NDialogTheme extends ThemeExtension<NDialogTheme> {
  /// App 默认主题
  const NDialogTheme({
    this.width = 315,
    this.padding = const EdgeInsets.all(20),
    this.raidus = 16,
    this.titleStyle = const TextStyle(
      color: Color(0xFF1A1A1A),
      fontSize: 24,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none,
    ),
    this.textStyle = const TextStyle(
      color: Color(0xFF1A1A1A),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.none,
    ),
  });

  /// 宽
  final double? width;

  /// 内边距
  final EdgeInsets? padding;

  /// 圆角
  final double? raidus;

  /// 标题字体样式
  final TextStyle? titleStyle;

  /// 字体样式
  final TextStyle? textStyle;

  @override
  ThemeExtension<NDialogTheme> copyWith({
    double? width,
    EdgeInsets? padding,
    double? raidus,
    TextStyle? titleStyle,
    TextStyle? textStyle,
  }) =>
      NDialogTheme(
        width: width ?? this.width,
        padding: padding ?? this.padding,
        raidus: raidus ?? this.raidus,
        titleStyle: titleStyle ?? this.titleStyle,
        textStyle: textStyle ?? this.textStyle,
      );

  @override
  ThemeExtension<NDialogTheme> lerp(
    covariant NDialogTheme? other,
    double t,
  ) =>
      NDialogTheme(
        padding: EdgeInsets.lerp(padding, other?.padding, t),
        titleStyle: TextStyle.lerp(titleStyle, other?.titleStyle, t),
        textStyle: TextStyle.lerp(textStyle, other?.textStyle, t),
      );
}
