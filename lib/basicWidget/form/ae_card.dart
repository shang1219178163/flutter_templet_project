//
//  AeCard.dart
//  yl_ylgcp_app
//
//  Created by shang on 2024/6/22 09:43.
//  Copyright © 2024/6/22 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 不良事件卡片样式
class AeCard extends StatelessWidget {
  const AeCard({
    super.key,
    this.margin = const EdgeInsets.only(bottom: 10),
    this.padding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 12,
    ),
    this.color = Colors.white,
    required this.children,
  });
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Color color;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}
