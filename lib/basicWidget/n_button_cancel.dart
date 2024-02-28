//
//  NButtonCancel.dart
//  yl_health_app
//
//  Created by shang on 2023/12/28 11:56.
//  Copyright © 2023/12/28 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';


/// 浅主题色(10%)取消按钮
class NButtonCancel extends StatelessWidget {

  const NButtonCancel({
    super.key,
    this.bgColor,
  	this.title = '取消',
    required this.onPressed,
    this.height = 44,
    this.width,
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
  /// 高度
  final double height;
  final double? width;

  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
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
          padding: padding,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0xffF2F2F2),
            //   border: Border.all(color: Colors.blue),
            borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(8)),
          ),
          child: child ?? NText(
            title,
            color: Color(0xffb3b3b3),
            fontSize: 16,
          ),
        ),
      );
    }

    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: primary.withOpacity(0.1),
          borderRadius: borderRadius,
        ),
        child: child ?? NText(
          title,
          color: primary,
        ),
      ),
    );
  }
}