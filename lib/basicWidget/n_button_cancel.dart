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
  });

  final Color? bgColor;

  /// 标题
  final String title;
  /// 点击事件
  final VoidCallback? onPressed;
  /// 高度
  final double height;

  @override
  Widget build(BuildContext context) {
    final primary = bgColor ?? context.primaryColor;

    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: primary.withOpacity(0.1),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: NText(
          title,
          color: primary,
        ),
      ),
    );
  }
}