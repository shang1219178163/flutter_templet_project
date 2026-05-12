//
//  GiftSendCard.dart
//  projects
//
//  Created by shang on 2026/4/23 17:57.
//  Copyright © 2026/4/23 shang. All rights reserved.
//

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_boder_text.dart';

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

  final String avatar;
  final String name;
  final String giftName;
  final String giftUrl;
  final Color? giftColor;
  final int giftCount;

  @override
  Widget build(BuildContext context) {
    final giftColorNew = giftColor ?? const Color(0xFFE13508);
    return Container(
      height: 40,
      constraints: const BoxConstraints(minWidth: 210, maxWidth: 270),
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
          const SizedBox(width: 2),
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: avatar,
              width: 34,
              height: 34,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 90,
            padding: EdgeInsets.only(top: 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
          ),
          const SizedBox(width: 8),
          CachedNetworkImage(
            imageUrl: giftUrl,
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 8),
          FittedBox(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                NBoderText(
                  text: "×",
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
                NBoderText(
                  text: "$giftCount",
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                ),
              ],
            ),
          ),
          const SizedBox(width: 2),
        ],
      ),
    );
  }
}
