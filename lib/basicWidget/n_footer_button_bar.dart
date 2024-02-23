//
//  NFooterButtonBar.dart
//  yl_health_app
//
//  Created by shang on 2023/12/28 16:55.
//  Copyright © 2023/12/28 shang. All rights reserved.
//


import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_button_cancel.dart';
import 'package:flutter_templet_project/basicWidget/n_button_confirm.dart';


/// 页面底部取消确定菜单
class NFooterButtonBar extends StatelessWidget {

  const NFooterButtonBar({
  	Key? key,
    this.primary,
    this.padding,
    this.decoration,
    this.cancelTitle = "取消",
    this.confirmTitle = "确定",
    this.height = 44,
    this.gap = 16,
    this.btnBorderRadius = const BorderRadius.all(Radius.circular(8)),
    this.onCancel,
    required this.onConfirm,
    this.hideCancel = false,
    this.enable = true,
    this.isReverse = false,
  }) : super(key: key);

  final Color? primary;
  final EdgeInsets? padding;
  final BoxDecoration? decoration;

  final String cancelTitle;
  final String confirmTitle;
  final double height;
  final double gap;
  final BorderRadius? btnBorderRadius;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  /// 是否隐藏取消按钮
  final bool hideCancel;

  /// 确定按钮是否可点击
  final bool enable;

  final bool isPageBottom = true;
  /// 标题图标翻转
  final bool isReverse;

  @override
  Widget build(BuildContext context) {
    var children = [
      if(!hideCancel)Expanded(
        child: NButtonCancel(
          height: height,
          bgColor: primary,
          borderRadius: btnBorderRadius,
          title: cancelTitle,
          onPressed: onCancel,
        ),
      ),
      if(!hideCancel)SizedBox(
        width: gap,
      ),
      Expanded(
        child: NButtonConfirm(
          height: height,
          bgColor: primary,
          borderRadius: btnBorderRadius,
          title: confirmTitle,
          enable: enable,
          onPressed: onConfirm,
        ),
      ),
    ];

    if (isReverse) {
      children = children.reversed.toList();
    }

    return Container(
      padding: padding ?? EdgeInsets.only(
        top: 12,
        left: 16,
        right: 16,
        bottom: max(12, MediaQuery.of(context).padding.bottom),
      ),
      decoration: decoration ?? const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xffE5E5E5))
        )
      ),
      child: Row(
        children: children,
      ),
    );
  }

}