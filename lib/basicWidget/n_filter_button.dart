//
//  NFilterButton.dart
//  yl_ylgcp_app
//
//  Created by shang on 2024/1/4 15:51.
//  Copyright © 2024/1/4 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/util/color_util.dart';

/// 筛选按钮
class NFilterButton extends StatelessWidget {
  const NFilterButton({
    super.key,
    this.margin = const EdgeInsets.only(right: 14),
    this.padding = const EdgeInsets.only(left: 10),
    this.title = "筛选",
    this.image = const AssetImage("assets/images/icon_filter.png"),
    this.color = fontColor,
    this.onPressed,
  });

  final EdgeInsets? margin;
  final EdgeInsets? padding;

  final String title;
  final AssetImage image;
  final Color? color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: margin,
        padding: padding,
        child: NPair(
          icon: Image(
            image: image,
            color: color,
            width: 13,
            height: 13,
          ),
          isReverse: true,
          child: NText(
            title,
            fontSize: 14,
            color: color,
          ),
        ),
      ),
    );
  }
}
