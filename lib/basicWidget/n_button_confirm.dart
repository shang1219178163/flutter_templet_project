//
//  NConfirmButton.dart
//  flutter_templet_project
//
//  Created by shang on 2023/12/28 11:56.
//  Copyright © 2023/12/28 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';

/// 主题色确定按钮
class NButtonConfirm extends StatelessWidget {
  const NButtonConfirm({
    super.key,
    this.bgColor,
    this.title = '确定',
    required this.onPressed,
    this.onTitle,
    this.height = 44,
    this.width,
    this.margin,
    this.padding,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.gradient,
    this.boxShadow,
    this.enable = true,
    this.child,
  });

  final Color? bgColor;

  /// 标题
  final String title;

  /// 点击事件
  final VoidCallback? onPressed;
  final ValueChanged<String>? onTitle;

  /// 高度
  final double height;
  final double? width;

  final EdgeInsets? margin;

  final EdgeInsets? padding;

  final BorderRadius? borderRadius;

  final Gradient? gradient;

  /// 阴影
  final List<BoxShadow>? boxShadow;

  /// 按钮是否可点击
  final bool enable;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final primary = bgColor ?? context.primaryColor;

    if (!enable) {
      return InkWell(
        onTap: null,
        child: Container(
          width: width,
          height: height,
          margin: margin,
          padding: padding,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0xffF2F2F2),
            //   border: Border.all(color: Colors.blue),
            borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(8)),
          ),
          child: child ??
              NText(
                title,
                color: Color(0xffb3b3b3),
                fontSize: 16,
              ),
        ),
      );
    }

    final borderRadiusNew = borderRadius ?? const BorderRadius.all(Radius.circular(8));

    final gradientNew = gradient ??
        LinearGradient(
          colors: [
            primary.withOpacity(0.8),
            primary,
            // Color(0xff359EEB),
            // Color(0xff007DBF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

    final boxShadowNew = boxShadow ??
        [
          BoxShadow(
            color: primary.withOpacity(0.32),
            offset: const Offset(0, 5),
            blurRadius: 10,
          ),
        ];

    return InkWell(
      onTap: () {
        if (onTitle != null) {
          onTitle?.call(title);
          return;
        }
        onPressed?.call();
      },
      child: Container(
        width: width,
        height: height,
        padding: padding,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          // color: Colors.transparent,
          //   border: Border.all(color: Colors.blue),
          borderRadius: borderRadiusNew,
          gradient: gradientNew,
          boxShadow: boxShadowNew,
        ),
        child: child ??
            NText(
              title,
              color: Colors.white,
              fontSize: 16,
              maxLines: 1,
            ),
      ),
    );
  }
}
