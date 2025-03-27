//
//  NIndexAvatarGroup.dart
//  yl_health_app
//
//  Created by shang on 2023/12/19 16:13.
//  Copyright © 2023/12/19 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_network_image.dart';

/// 层叠头像组
class NAvatarGroup extends StatelessWidget {
  const NAvatarGroup({
    Key? key,
    required this.avatars,
    this.placehorder = const AssetImage("assets/images/img_placeholder_doctor.png"),
    this.isRevered = false,
    this.itemWidth = 28,
    this.scale = 18 / 28,
    this.itemPadding = const EdgeInsets.all(2),
  }) : super(key: key);

  /// url
  final List<String?> avatars;

  /// 占位图
  final AssetImage placehorder;

  /// 层叠反向
  final bool isRevered;

  /// 子项宽高
  final double itemWidth;

  /// 子项 padding
  final EdgeInsets? itemPadding;

  /// 层叠比
  final double scale;

  @override
  Widget build(BuildContext context) {
    if (avatars.isEmpty) {
      return const SizedBox();
    }

    return SizedBox(
      width: itemWidth * scale * (avatars.length - 1) + itemWidth,
      height: itemWidth,
      child: Stack(
        children: buildAvatars(),
      ),
    );
  }

  List<Positioned> buildAvatars() {
    var list = <Positioned>[];
    for (var i = 0; i < avatars.length; i++) {
      final url = avatars[i];
      final left = itemWidth * scale * i.toDouble();

      final item = Positioned(
        left: left,
        top: 0,
        bottom: 0,
        child: buildAvatar(
          url: url ?? "",
          placehorder: placehorder,
        ),
      );
      list.add(item);
    }
    if (isRevered) {
      return list.reversed.toList();
    }
    return list;
  }

  Widget buildAvatar({
    required String url,
    required AssetImage placehorder,
  }) {
    return Container(
      padding: itemPadding ?? const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(itemWidth * 0.5),
      ),
      width: itemWidth,
      height: itemWidth,
      child: NNetworkImage(
        radius: itemWidth * 0.5,
        url: url,
        placeholder: placehorder,
      ),
    );
  }
}
