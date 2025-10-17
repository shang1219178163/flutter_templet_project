import 'package:flutter/material.dart';

/// App 自定义主题
class NAppTheme extends ThemeExtension<NAppTheme> {
  /// App 自定义主题
  NAppTheme({
    this.primary = const Color(0xFF007DBF),
    this.primary2 = const Color(0xFF359EEB),
    this.bgColor = const Color(0xFFF3F3F3),
    this.fontColor = const Color(0xFF1A1A1A),
    this.titleStyle = const TextStyle(
      color: Color(0xFF1A1A1A),
      fontSize: 18,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none,
    ),
    this.textStyle = const TextStyle(
      color: Color(0xFF1A1A1A),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.none,
    ),
    this.cancelColor = const Color(0xFFE65F55),
    this.lineColor = const Color(0xFFE5E5E5),
    this.borderColor = const Color(0xFFE5E5E5),
    this.disabledColor = const Color(0xffB3B3B3),
  });

  /// 字体颜色
  final Color primary;

  /// 主色调辅助色(用于渐进色)
  final Color primary2;

  /// 背景色
  final Color bgColor;

  /// 标题字体样式
  final Color fontColor;

  /// 标题字体样式
  final TextStyle titleStyle;

  /// 字体样式
  final TextStyle textStyle;

  /// 取消按钮的那种深红色 cancel 0xFFE65F55
  final Color cancelColor;

  /// 线条 #E5E5E5
  final Color lineColor;

  /// 边框线条 #E5E5E5
  final Color borderColor;

  /// 禁用状态的颜色 #B3B3B3
  final Color disabledColor;

  @override
  ThemeExtension<NAppTheme> copyWith({
    Color? primary,
    Color? primary2,
    Color? bgColor,
    Color? fontColor,
    TextStyle? titleStyle,
    TextStyle? textStyle,
    Color? cancelColor,
    Color? lineColor,
    Color? borderColor,
    Color? disabledColor,
  }) =>
      NAppTheme(
        primary: primary ?? this.primary,
        primary2: primary2 ?? this.primary2,
        bgColor: bgColor ?? this.bgColor,
        fontColor: fontColor ?? this.fontColor,
        titleStyle: titleStyle ?? this.titleStyle,
        textStyle: textStyle ?? this.textStyle,
        cancelColor: cancelColor ?? this.cancelColor,
        lineColor: lineColor ?? this.lineColor,
        borderColor: borderColor ?? this.borderColor,
        disabledColor: disabledColor ?? this.disabledColor,
      );

  @override
  ThemeExtension<NAppTheme> lerp(
    covariant NAppTheme? other,
    double t,
  ) =>
      NAppTheme(
        primary: Color.lerp(primary, other?.primary, t) ?? primary,
        primary2: Color.lerp(primary2, other?.primary2, t) ?? primary2,
        bgColor: Color.lerp(bgColor, other?.bgColor, t) ?? bgColor,
        fontColor: Color.lerp(fontColor, other?.fontColor, t) ?? fontColor,
        titleStyle: TextStyle.lerp(titleStyle, other?.titleStyle, t) ?? titleStyle,
        textStyle: TextStyle.lerp(textStyle, other?.textStyle, t) ?? textStyle,
        cancelColor: Color.lerp(cancelColor, other?.cancelColor, t) ?? cancelColor,
        lineColor: Color.lerp(lineColor, other?.lineColor, t) ?? lineColor,
        borderColor: Color.lerp(borderColor, other?.borderColor, t) ?? borderColor,
        disabledColor: Color.lerp(disabledColor, other?.disabledColor, t) ?? disabledColor,
      );
}
