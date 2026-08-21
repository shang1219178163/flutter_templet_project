//
//  LiveStreamEnterEffectCard.dart
//  flutter_templet_project
//
//  Created by shang on 2026/4/27 12:18.
//  Copyright © 2026/4/27 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_chat_bubble.dart';

/// 直播间进场特效卡片
class LiveStreamEnterEffectCard extends StatelessWidget {
  const LiveStreamEnterEffectCard({
    super.key,
    required this.imagePath,
    required this.text,
  });

  /// 背景图
  final String imagePath;

  /// 文字
  final String text;

  @override
  Widget build(BuildContext context) {
    return NChatBubble(
      imagePath: imagePath,
      metrics: NChatBubbleMetrics(
        imageSize: const Size(150, 40),
        safeInset: const EdgeInsets.fromLTRB(25, 11, 37, 11),
        adjust: EdgeInsets.only(top: 0),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontFamily: 'PingFang SC',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
