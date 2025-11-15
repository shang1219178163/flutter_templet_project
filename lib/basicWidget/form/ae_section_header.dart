//
//  AeSectionHeader.dart
//  yl_ylgcp_app
//
//  Created by shang on 2024/6/18 17:08.
//  Copyright © 2024/6/18 shang. All rights reserved.
//

import 'package:flutter/material.dart';

import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

/// 表单中每项标题
class AeSectionHeader extends StatelessWidget {
  const AeSectionHeader({
    super.key,
    required this.title,
    required this.isRequired,
    this.hasIndicator = false,
    this.style = const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: Color(0xFF737373),
    ),
    this.maxLines,
    this.tailing,
  });

  /// 标题
  final String title;

  /// 标题样式
  final TextStyle style;
  final int? maxLines;

  /// 小红点
  final bool isRequired;

  /// 竖线指示器
  final bool hasIndicator;

  final Widget? tailing;

  @override
  Widget build(BuildContext context) {
    if (title.isEmpty) {
      return const SizedBox();
    }

    final leading = Text.rich(
      TextSpan(
        children: [
          if (hasIndicator)
            WidgetSpan(
              child: Container(
                width: 3,
                height: 14,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: context.primaryColor,
                ),
                margin: const EdgeInsets.only(right: 6),
              ),
              alignment: PlaceholderAlignment.middle,
            ),
          if (isRequired)
            const TextSpan(
              text: "*",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColor.cancelColor,
              ),
            ),
          TextSpan(
            text: title,
            style: style,
          ),
        ],
      ),
      maxLines: maxLines ?? 3,
      overflow: TextOverflow.ellipsis,
    );

    if (tailing == null) {
      return leading;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: leading),
        tailing ?? const SizedBox(),
      ],
    );
  }
}
