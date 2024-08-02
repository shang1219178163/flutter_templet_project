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
    this.height = 44,
    this.gap = 16,
    this.btnBorderRadius = const BorderRadius.all(Radius.circular(8)),
    this.onCancel,
    this.onCancelTap,
    required this.onConfirm,
    this.onConfirmTap,
    this.hideCancel = false,
    this.hideConfirm = false,
    this.boxShadow,
    this.gradient,
    this.header,
    this.footer,
    this.enable = true,
  });

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
  final ValueChanged<String>? onCancelTap;
  final ValueChanged<String>? onConfirmTap;
  final Gradient? gradient;

  /// 阴影
  final List<BoxShadow>? boxShadow;

  /// 是否隐藏取消按钮
  final bool hideCancel;

  /// 是否隐藏确定按钮
  final bool hideConfirm;

  final bool isPageBottom = true;

  final Widget? header;
  final Widget? footer;

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
    return Row(
      children: [
        if (!hideCancel)
          Expanded(
            child: NButtonCancel(
              title: cancelTitle,
              onPressed: onCancel,
              onTap: onCancelTap,
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
              onTap: onConfirmTap,
            ),
          ),
      ],
    );
  }
}
