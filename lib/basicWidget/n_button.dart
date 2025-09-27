//
//  NButton.dart
//  flutter_templet_project
//
//  Created by shang on 2023/12/28 11:56.
//  Copyright © 2023/12/28 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/theme/n_button_theme.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/dlog.dart';

/// 主题色背景确定按钮
class NButton extends StatelessWidget {
  const NButton({
    super.key,
    this.primary,
    this.enable = true,
    this.title = '确定',
    this.style,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.constraints,
    this.borderRadius,
    this.backgroudColor,
    this.gradient,
    this.boxShadow,
    this.border,
    required this.onPressed,
    this.onLongPressed,
    this.onTitle,
    this.child,
  });

  factory NButton.tonal({
    Key? key,
    Color? primary,
    String title,
    TextStyle? style,
    bool enable,
    double? width,
    double? height,
    BoxConstraints? constraints,
    EdgeInsets? margin,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
    Border? border,
    Color? backgroudColor,
    Gradient? gradient,
    VoidCallback? onLongPressed,
    required VoidCallback? onPressed,
    ValueChanged<String>? onTitle,
    Widget? child,
  }) = _NButtonTonal;

  factory NButton.text({
    Key? key,
    Color? primary,
    String title,
    TextStyle? style,
    bool enable,
    double? width,
    double? height,
    BoxConstraints? constraints,
    EdgeInsets? margin,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
    Border? border,
    VoidCallback? onLongPressed,
    required VoidCallback? onPressed,
    ValueChanged<String>? onTitle,
    Widget? child,
  }) = _NButtonText;

  /// 主题色
  final Color? primary;

  /// 标题
  final String title;

  /// 标题样式
  final TextStyle? style;

  /// 按钮是否可点击
  final bool enable;

  /// 高度
  final double? height;

  /// 宽度
  final double? width;

  /// 约束
  final BoxConstraints? constraints;

  /// 外边距
  final EdgeInsets? margin;

  /// 内边距
  final EdgeInsets? padding;

  /// 背景色
  final Color? backgroudColor;

  /// 渐进色背景
  final Gradient? gradient;

  /// 阴影
  final List<BoxShadow>? boxShadow;

  /// 圆角
  final BorderRadius? borderRadius;

  /// 边框线
  final Border? border;

  /// 点击事件
  final VoidCallback? onPressed;

  /// 长按事件
  final VoidCallback? onLongPressed;

  /// 标题回调
  final ValueChanged<String>? onTitle;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theTheme = Theme.of(context).extension<NButtonTheme>();

    final primaryNew = primary ?? theTheme?.primary ?? context.primaryColor;
    final heightNew = height ?? theTheme?.height ?? 44;
    final constraintsNew = constraints ??
        theTheme?.constraints ??
        BoxConstraints(
          minWidth: 10,
          minHeight: 10,
        );
    final marginNew = margin ?? theTheme?.margin;
    final paddingNew = padding ?? theTheme?.padding;

    final backgroudColorNew = backgroudColor ?? theTheme?.backgroudColor;
    final backgroudColorDisableNew = theTheme?.backgroudColorDisable ?? Color(0xffF3F3F3);

    final gradientNew = gradient ??
        theTheme?.gradient ??
        LinearGradient(
          colors: [primaryNew, primaryNew],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    final gradientDisableNew = theTheme?.gradientDisable ??
        LinearGradient(
          colors: [
            const Color(0xffF3F3F3),
            const Color(0xffF3F3F3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

    final boxShadowNew = boxShadow ?? theTheme?.boxShadow;
    final boxShadowDisableNew = theTheme?.boxShadowDisable;
    final borderRadiusNew = theTheme?.borderRadius ?? const BorderRadius.all(Radius.circular(8));
    final borderRadiusDisableNew = theTheme?.borderRadiusDisable ?? const BorderRadius.all(Radius.circular(8));

    final borderNew = theTheme?.border;
    final borderDisableNew = theTheme?.borderDisable;

    final decorationEnable = BoxDecoration(
      color: backgroudColorNew,
      border: borderNew,
      borderRadius: borderRadiusNew,
      gradient: gradientNew,
      boxShadow: boxShadowNew,
    );

    final decorationDisable = BoxDecoration(
      color: backgroudColorDisableNew,
      border: borderDisableNew,
      borderRadius: borderRadiusDisableNew,
      gradient: gradientDisableNew,
      boxShadow: boxShadowDisableNew,
    );

    final decoration = enable ? decorationEnable : decorationDisable;
    final textColor = enable ? Colors.white : Color(0xffb3b3b3);

    return GestureDetector(
      onTap: () {
        if (!enable) {
          DLog.d("按钮禁用");
          return;
        }
        if (onTitle != null) {
          onTitle?.call(title);
          return;
        }
        onPressed?.call();
      },
      onLongPress: onLongPressed,
      child: Container(
        width: width,
        height: heightNew,
        constraints: constraintsNew,
        margin: marginNew,
        padding: paddingNew,
        alignment: Alignment.center,
        decoration: decoration,
        child: child ??
            NText(
              title,
              color: textColor,
              fontSize: 16,
              maxLines: 1,
              style: style ?? theTheme?.textStyle,
            ),
      ),
    );
  }
}

/// 主题浅色背景
class _NButtonTonal extends NButton {
  const _NButtonTonal({
    super.key,
    super.primary,
    super.enable,
    super.title = '确定',
    super.style,
    super.width,
    super.height,
    super.constraints,
    super.margin,
    super.padding,
    super.backgroudColor,
    super.gradient,
    super.borderRadius,
    super.border,
    required super.onPressed,
    super.onLongPressed,
    super.onTitle,
    super.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!enable) {
      return NButton(
        key: key,
        enable: enable,
        title: title,
        style: style,
        width: width,
        height: height,
        margin: margin,
        padding: padding,
        backgroudColor: backgroudColor,
        gradient: gradient,
        borderRadius: borderRadius,
        border: border,
        onPressed: onPressed,
        onLongPressed: onLongPressed,
        onTitle: onTitle,
        child: child,
      );
    }

    final theTheme = Theme.of(context).extension<NButtonTheme>();

    final primaryNew = primary ?? theTheme?.primary ?? context.primaryColor;
    final heightNew = height ?? theTheme?.height ?? 44;
    final marginNew = margin ?? theTheme?.margin;
    final paddingNew = padding ?? theTheme?.padding;

    final decoration = BoxDecoration(
      color: backgroudColor ?? theTheme?.backgroudColor ?? primaryNew.withOpacity(0.1),
      border: border ?? theTheme?.border ?? Border.all(color: primaryNew),
      borderRadius: theTheme?.borderRadius ?? const BorderRadius.all(Radius.circular(8)),
      gradient: gradient,
    );

    final textColor = primaryNew;

    return GestureDetector(
      onTap: () {
        if (onTitle != null) {
          onTitle?.call(title);
          return;
        }
        onPressed?.call();
      },
      onLongPress: onLongPressed,
      child: Container(
        width: width,
        height: heightNew,
        constraints: constraints,
        margin: marginNew,
        padding: paddingNew,
        alignment: Alignment.center,
        decoration: decoration,
        child: child ??
            NText(
              title,
              color: textColor,
              fontSize: 16,
              maxLines: 1,
              style: style ?? theTheme?.textStyle,
            ),
      ),
    );
  }
}

/// 纯文字
class _NButtonText extends NButton {
  const _NButtonText({
    super.key,
    super.primary,
    super.enable,
    super.title = '确定',
    super.style,
    super.width,
    super.height,
    super.constraints,
    super.margin,
    super.padding,
    super.borderRadius,
    super.border,
    required super.onPressed,
    super.onLongPressed,
    super.onTitle,
    super.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!enable) {
      return NButton(
        key: key,
        enable: enable,
        title: title,
        style: style,
        width: width,
        height: height,
        constraints: constraints,
        margin: margin,
        padding: padding,
        gradient: gradient,
        borderRadius: borderRadius,
        border: border,
        onPressed: onPressed,
        onLongPressed: onLongPressed,
        onTitle: onTitle,
        child: child,
      );
    }

    final theTheme = Theme.of(context).extension<NButtonTheme>();

    final primaryNew = primary ?? theTheme?.primary ?? context.primaryColor;
    final heightNew = height ?? theTheme?.height;
    final marginNew = margin ?? theTheme?.margin;
    final paddingNew = padding ?? theTheme?.padding;

    final decoration = BoxDecoration(
      // color: primaryNew.withOpacity(0.1),
      border: border ?? theTheme?.border ?? Border.all(color: Colors.transparent),
      borderRadius: theTheme?.borderRadius ?? const BorderRadius.all(Radius.circular(8)),
    );

    final textColor = primaryNew;

    return GestureDetector(
      onTap: () {
        if (onTitle != null) {
          onTitle?.call(title);
          return;
        }
        onPressed?.call();
      },
      onLongPress: onLongPressed,
      child: Container(
        width: width,
        height: heightNew,
        constraints: constraints,
        margin: marginNew,
        padding: paddingNew,
        alignment: Alignment.center,
        decoration: decoration,
        child: child ??
            NText(
              title,
              color: textColor,
              fontSize: 16,
              maxLines: 1,
              style: style ?? theTheme?.textStyle,
            ),
      ),
    );
  }
}
