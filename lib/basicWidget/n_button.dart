//
//  NConfirmButton.dart
//  yl_health_app
//
//  Created by shang on 2023/12/28 11:56.
//  Copyright © 2023/12/28 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/theme/n_button_theme.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';

/// 主题色确定按钮
class NButton extends StatelessWidget {
  const NButton({
    super.key,
    this.primary,
    this.enable = true,
    this.title = '确定',
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.borderRadius,
    this.gradient,
    this.boxShadow,
    this.border,
    required this.onPressed,
    this.onLongPressed,
    this.onTap,
    this.child,
  });

  factory NButton.outline({
    Key? key,
    Color? primary,
    String title,
    bool enable,
    double? width,
    double? height,
    EdgeInsets? margin,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
    Border? border,
    VoidCallback? onLongPressed,
    required VoidCallback? onPressed,
    ValueChanged<String>? onTap,
    Widget? child,
  }) = ButtonOutline;

  factory NButton.text({
    Key? key,
    Color? primary,
    String title,
    bool enable,
    double? width,
    double? height,
    EdgeInsets? margin,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
    Border? border,
    VoidCallback? onLongPressed,
    required VoidCallback? onPressed,
    ValueChanged<String>? onTap,
    Widget? child,
  }) = ButtonText;

  /// 主题色
  final Color? primary;

  /// 标题
  final String title;

  /// 按钮是否可点击
  final bool enable;

  /// 高度
  final double? height;
  final double? width;

  final EdgeInsets? margin;

  final EdgeInsets? padding;

  final Gradient? gradient;

  /// 阴影
  final List<BoxShadow>? boxShadow;
  final BorderRadius? borderRadius;
  final Border? border;

  /// 点击事件
  final VoidCallback? onPressed;
  final VoidCallback? onLongPressed;

  final ValueChanged<String>? onTap;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theTheme = Theme.of(context).extension<NButtonTheme>();

    final primaryNew = primary ?? theTheme?.primary ?? context.primaryColor;
    final heightNew = height ?? theTheme?.height ?? 44;
    final marginNew = margin ?? theTheme?.margin;
    final paddingNew = padding ?? theTheme?.padding;
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
    final borderRadiusNew =
        theTheme?.borderRadius ?? const BorderRadius.all(Radius.circular(8));
    final borderRadiusDisableNew = theTheme?.borderRadiusDisable ??
        const BorderRadius.all(Radius.circular(8));

    final borderNew = theTheme?.border;
    final borderDisableNew = theTheme?.borderDisable;

    final decorationEnable = BoxDecoration(
      // color: Colors.transparent,
      border: borderNew,
      borderRadius: borderRadiusNew,
      gradient: gradientNew,
      boxShadow: boxShadowNew,
    );

    final decorationDisable = BoxDecoration(
      // color: Colors.transparent,
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
        if (onTap != null) {
          onTap?.call(title);
          return;
        }
        onPressed?.call();
      },
      onLongPress: onLongPressed,
      child: Container(
        width: width,
        height: heightNew,
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
            ),
      ),
    );
  }
}

/// 带边框线
class ButtonOutline extends NButton {
  const ButtonOutline({
    super.key,
    super.primary,
    super.title = '确定',
    super.enable,
    super.width,
    super.height,
    super.margin,
    super.padding,
    super.borderRadius,
    super.border,
    required super.onPressed,
    super.onLongPressed,
    super.onTap,
    super.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!enable) {
      return NButton(enable: enable, onPressed: () {});
    }

    final theTheme = Theme.of(context).extension<NButtonTheme>();

    final primaryNew = primary ?? theTheme?.primary ?? context.primaryColor;
    final heightNew = height ?? theTheme?.height ?? 44;
    final marginNew = margin ?? theTheme?.margin;
    final paddingNew = padding ?? theTheme?.padding;

    final decoration = BoxDecoration(
      color: primaryNew.withOpacity(0.1),
      border: border ?? theTheme?.border ?? Border.all(color: primaryNew),
      borderRadius:
          theTheme?.borderRadius ?? const BorderRadius.all(Radius.circular(8)),
    );

    final textColor = primaryNew;

    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap?.call(title);
          return;
        }
        onPressed?.call();
      },
      onLongPress: onLongPressed,
      child: Container(
        width: width,
        height: heightNew,
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
            ),
      ),
    );
  }
}

/// 纯文字
class ButtonText extends NButton {
  const ButtonText({
    super.key,
    super.primary,
    super.title = '确定',
    super.enable,
    super.width,
    super.height,
    super.margin,
    super.padding,
    super.borderRadius,
    super.border,
    required super.onPressed,
    super.onLongPressed,
    super.onTap,
    super.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!enable) {
      return NButton(enable: enable, onPressed: () {});
    }

    final theTheme = Theme.of(context).extension<NButtonTheme>();

    final primaryNew = primary ?? theTheme?.primary ?? context.primaryColor;
    final heightNew = height ?? theTheme?.height;
    final marginNew = margin ?? theTheme?.margin;
    final paddingNew = padding ?? theTheme?.padding;

    final decoration = BoxDecoration(
      // color: primaryNew.withOpacity(0.1),
      border:
          border ?? theTheme?.border ?? Border.all(color: Colors.transparent),
      borderRadius:
          theTheme?.borderRadius ?? const BorderRadius.all(Radius.circular(8)),
    );

    final textColor = primaryNew;

    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap?.call(title);
          return;
        }
        onPressed?.call();
      },
      onLongPress: onLongPressed,
      child: Container(
        width: width,
        height: heightNew,
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
            ),
      ),
    );
  }
}
