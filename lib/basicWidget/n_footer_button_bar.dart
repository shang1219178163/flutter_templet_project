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
    super.key,
    this.primary,
    this.padding,
    this.decoration,
    this.cancelTitle = "取消",
    this.confirmTitle = "确定",
    this.gap = 16,
    this.btnBorderRadius = const BorderRadius.all(Radius.circular(8)),
    this.onCancel,
    this.onCancelTitle,
    required this.onConfirm,
    this.onConfirmTitle,
    this.hideCancel = false,
    this.hideConfirm = false,
    this.boxShadow,
    this.gradient,
    this.header,
    this.footer,
    this.leading,
    this.trailing,
    this.isReverse = false,
    this.enable = true,
  });

  /// 主题色
  final Color? primary;

  /// 内边距
  final EdgeInsets? padding;

  /// 装饰器
  final BoxDecoration? decoration;

  /// 取消按钮标题
  final String cancelTitle;

  /// 确定按钮标题
  final String confirmTitle;

  /// 取消按钮和确认按钮间距
  final double gap;

  /// 按钮圆角
  final BorderRadius? btnBorderRadius;

  /// 取消按钮回调
  final VoidCallback? onCancel;

  /// 确定按钮回调
  final VoidCallback? onConfirm;

  /// 取消按钮回调(带标题)
  final ValueChanged<String>? onCancelTitle;

  /// 确定按钮回调(带标题)
  final ValueChanged<String>? onConfirmTitle;

  /// 确定按钮渐变色
  final Gradient? gradient;

  /// 阴影
  final List<BoxShadow>? boxShadow;

  /// 是否隐藏取消按钮
  final bool hideCancel;

  /// 是否隐藏确定按钮
  final bool hideConfirm;

  final Widget? header;
  final Widget? footer;
  final Widget? leading;
  final Widget? trailing;

  /// 是否顺序翻转
  final bool isReverse;

  /// 确定按钮是否可点击
  final bool enable;

  @override
  Widget build(BuildContext context) {
    if (hideCancel && hideConfirm) {
      return const SizedBox();
    }

    return Container(
      padding: padding ??
          EdgeInsets.only(
            top: 12,
            left: 16,
            right: 16,
            bottom: max(12, MediaQuery.of(context).padding.bottom),
          ),
      decoration: decoration ??
          const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(width: 0.5, color: Color(0xffE5E5E5)),
            ),
          ),
      child: Column(
        children: [
          header ?? const SizedBox(),
          buildButtonBar(),
          footer ?? const SizedBox(),
        ],
      ),
    );
  }

  /// 按钮菜单栏
  Widget buildButtonBar() {
    var children = [
      leading ?? const SizedBox(),
      if (!hideCancel)
        Expanded(
          child: NButtonCancel(
            title: cancelTitle,
            onPressed: onCancel,
            onTitle: onCancelTitle,
            borderRadius: btnBorderRadius,
          ),
        ),
      if (!hideCancel && !hideConfirm) SizedBox(width: gap),
      if (!hideConfirm)
        Expanded(
          child: NButtonConfirm(
            boxShadow: boxShadow,
            gradient: gradient,
            title: confirmTitle,
            enable: enable,
            onPressed: onConfirm,
            onTitle: onConfirmTitle,
            borderRadius: btnBorderRadius,
          ),
        ),
      trailing ?? const SizedBox(),
    ];
    if (isReverse) {
      children = children.reversed.toList();
    }
    return Row(
      children: children,
    );
  }
}
