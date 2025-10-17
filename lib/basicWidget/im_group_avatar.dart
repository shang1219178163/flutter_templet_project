//
//  ImGroupAvatar.dart
//  flutter_templet_project
//
//  Created by shang on 2024/5/18 16:24.
//  Copyright © 2024/5/18 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_network_image.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';

class ImGroupAvatar extends StatelessWidget {
  const ImGroupAvatar({
    super.key,
    this.onTap,
    this.avatar,
    this.placeholder = const AssetImage("assets/images/img_placeholder.png"),
    required this.title,
    required this.subtitle,
    this.hasSubtitle = true,
  });

  final VoidCallback? onTap;
  // 头像url
  final String? avatar;

  final AssetImage placeholder;
  // 姓名
  final String title;
  // 状态（在线、离线 等。。。）
  final String subtitle;

  final bool hasSubtitle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // width: width,
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NNetworkImage(
              url: avatar ?? "",
              placeholder: placeholder,
              width: 46,
              height: 46,
              radius: 4,
            ),
            const SizedBox(
              height: 6,
            ),
            SizedBox(
              height: 14,
              child: NText(
                title,
                fontSize: 11,
                color: AppColor.fontColor737373,
                maxLines: 1,
              ),
            ),
            if (hasSubtitle)
              NText(
                subtitle,
                fontSize: 11,
                color: AppColor.fontColor737373,
                maxLines: 1,
              ),
          ],
        ),
      ),
    );
  }
}
