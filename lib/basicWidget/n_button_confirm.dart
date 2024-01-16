//
//  NConfirmButton.dart
//  yl_health_app
//
//  Created by shang on 2023/12/28 11:56.
//  Copyright © 2023/12/28 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';


/// 主题色确定按钮
class NButtonConfirm extends StatelessWidget {

  const NButtonConfirm({
    super.key,
    this.bgColor,
  	this.title = '确定',
    required this.onPressed,
    this.height = 44,
    this.width,
    this.padding,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.boxShadow,
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
          // color: Colors.transparent,
          //   border: Border.all(color: Colors.blue),
          borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(8)),
          gradient: LinearGradient(colors: [
              primary.withOpacity(0.5),
              primary,
              // Color(0xff359EEB),
              // Color(0xff007DBF),
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          boxShadow: boxShadow ?? [
            BoxShadow(
              color: primary.withOpacity(0.32),
              offset: const Offset(0, 5),
              blurRadius: 10,
            ),
          ]
        ),
        child: child ?? NText(
          title,
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}