//
//  AeTimeLine.dart
//  yl_ylgcp_app
//
//  Created by shang on 2024/6/20 09:25.
//  Copyright © 2024/6/20 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/form/ae_section_header.dart';

/// 日期时间线
class AeTimeLine extends StatelessWidget {
  const AeTimeLine({
    super.key,
    required this.dateStr,
    required this.child,
    this.addExpanded = true,
  });

  /// 日期时间
  final String dateStr;

  /// 内容组件
  final Widget child;

  /// 子视图是否需要 Expanded
  final bool addExpanded;

  @override
  Widget build(BuildContext context) {
    final content = addExpanded ? Expanded(child: child) : child;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AeSectionHeader(
          title: dateStr,
          isRequired: false,
          hasIndicator: true,
        ),
        const SizedBox(height: 10),
        content,
      ],
    );
  }
}
