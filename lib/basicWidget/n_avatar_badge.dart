//
//  NAvatarBadge.dart
//  flutter_templet_project
//
//  Created by shang on 2024/3/30 09:41.
//  Copyright © 2024/3/30 shang. All rights reserved.
//


import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

/// 带角标的头像组件
class NAvatarBadge extends StatelessWidget {

  const NAvatarBadge({
  	super.key,
    required this.url,
    this.width = 60,
    this.height = 60,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    required this.badgeStr,
    this.badgeSize = 20,
    this.badgePadding = const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    this.badgeTextStyle = const TextStyle(
      fontSize: 12,
      color: Colors.white,
    ),
  });

  /// 头像宽
  final double width;
  /// 头像高
  final double height;
  /// 头像链接
  final String url;
  /// 头像圆角
  final BorderRadius borderRadius;
  /// 角标 尺寸
  final double badgeSize;
  /// 角标值
  final String badgeStr;
  /// 角标内边距
  final EdgeInsets badgePadding;
  /// 角标字体样式
  final TextStyle badgeTextStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.topRight,
      decoration: BoxDecoration(
        // color: Colors.grey.withAlpha(88),
        borderRadius: borderRadius,
        image: DecorationImage(
          image: ExtendedNetworkImageProvider(
            url,
            cache: true,
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: SizedOverflowBox(
        alignment: Alignment.center,
        size: Size.zero,
        child: UnconstrainedBox(
          child: Container(
            // width: size,
            height: badgeSize,
            constraints: BoxConstraints(
              minWidth: badgeSize + badgePadding.horizontal*2,
            ),
            padding: badgePadding,
            alignment: Alignment.center,
            decoration: ShapeDecoration(
              color: Colors.red,
              shape: badgeStr.length <= 2 ? CircleBorder() : StadiumBorder(),
            ),
            child: Text(badgeStr,
              style: badgeTextStyle,
            ),
          ),
        ),
      ),
    );
  }
}