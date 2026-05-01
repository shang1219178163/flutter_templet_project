//
//  LiveStreamGiftSendCard.dart
//  flutter_templet_project
//
//  Created by shang on 2026/4/27 12:17.
//  Copyright © 2026/4/27 shang. All rights reserved.
//

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// 直播间礼物发送动画卡片
class LiveStreamGiftSendCard extends StatelessWidget {
  const LiveStreamGiftSendCard({
    super.key,
    required this.avatar,
    required this.name,
    required this.giftName,
    required this.giftUrl,
    required this.giftColor,
    required this.giftCount,
  });

  /// 用户头像
  final String avatar;

  /// 用户名称
  final String name;

  /// 礼物名称
  final String giftName;

  /// 礼物图标
  final String giftUrl;

  /// 礼物背景色
  final Color? giftColor;

  /// 礼物数量
  final int giftCount;

  @override
  Widget build(BuildContext context) {
    final num = "×$giftCount";

    var width = 210.0;
    if (giftCount >= 10 && giftCount <= 99) {
      width = 220;
    } else if (giftCount >= 100) {
      width = 240;
    }

    final giftColorNew = giftColor ?? const Color(0xFFE13508);
    return Container(
      height: 40,
      width: width,
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          colors: [
            giftColorNew,
            giftColorNew.withOpacity(0.0),
          ],
        ),
        shape: const StadiumBorder(),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 4),
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: avatar,
              width: 32,
              height: 32,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(width: 13),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                giftName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(width: 13),
          CachedNetworkImage(
            imageUrl: giftUrl,
            width: 32,
            height: 32,
          ),
          const SizedBox(width: 8),
          FittedBox(
            child: Text(
              num,
              style: const TextStyle(
                color: Color(0xFFFFD876),
                fontSize: 26,
                fontWeight: FontWeight.w900,
                fontFamily: 'DDINPRO',
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
