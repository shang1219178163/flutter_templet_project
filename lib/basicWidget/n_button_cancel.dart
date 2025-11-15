//
//  NButtonCancel.dart
//  flutter_templet_project
//
//  Created by shang on 2023/12/28 11:56.
//  Copyright © 2023/12/28 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';

/// 浅主题色(10%)取消按钮
class NButtonCancel extends StatelessWidget {
  const NButtonCancel({
    super.key,
    this.bgColor,
    this.title = '取消',
    required this.onPressed,
    this.onTitle,
    this.height = 44,
    this.width,
    this.margin,
    this.padding,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.enable = true,
    this.child,
  });

  final Color? bgColor;

  /// 标题
  final String title;

  /// 点击事件
  final VoidCallback? onPressed;

  /// 带标题回调
  final ValueChanged<String>? onTitle;

  /// 高度
  final double height;
  final double? width;

  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;

  final Widget? child;

  /// 按钮是否可点击
  final bool enable;

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
          color: primary.withOpacity(0.1),
          borderRadius: borderRadius,
        ),
        child: child ??
            NText(
              title,
              color: primary,
            ),
      ),
    );
  }
}
