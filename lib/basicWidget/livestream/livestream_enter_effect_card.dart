//
//  LiveStreamEnterEffectCard.dart
//  flutter_templet_project
//
//  Created by shang on 2026/4/27 12:18.
//  Copyright © 2026/4/27 shang. All rights reserved.
//

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/overlay/n_reuse_toast.dart';
import 'package:flutter_templet_project/generated/assets.dart';

/// 直播间进场特效卡片
class LiveStreamEnterEffectCard extends StatelessWidget {
  const LiveStreamEnterEffectCard({
    super.key,
    required this.imagePath,
    required this.text,
    this.scale,
  });

  /// 背景图
  final String imagePath;

  /// 文字
  final String text;

  final double? scale;

  @override
  Widget build(BuildContext context) {
    ImageProvider image = imagePath.startsWith("http") ? CachedNetworkImageProvider(imagePath) : AssetImage(imagePath);
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 35, top: 11, bottom: 11),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: image,
          fit: BoxFit.fill,
          scale: scale ?? 3.0,
        ),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontFamily: 'PingFang SC',
          fontWeight: FontWeight.w500,
          // backgroundColor: Colors.green,
        ),
      ),
    );
    // return NChatBubble(//图片没有可拉伸的点,会变行
    //   imagePath: imagePath,
    //   metrics: const NChatBubbleMetrics(
    //     imageSize: Size(150, 40),
    //     safeInset: EdgeInsets.fromLTRB(25, 11, 37, 11),
    //     adjust: EdgeInsets.only(top: 0),
    //   ),
    //   scale: scale,
    //   child: Text(
    //     text,
    //     maxLines: 1,
    //     overflow: TextOverflow.ellipsis,
    //     style: TextStyle(
    //       color: Colors.white,
    //       fontSize: 12,
    //       fontFamily: 'PingFang SC',
    //       fontWeight: FontWeight.w500,
    //     ),
    //   ),
    // );
  }
}

/// 进场特效测试组件
class LivestreamEnterEffectTest extends StatelessWidget {
  const LivestreamEnterEffectTest({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Assets.messageEffectFootball,
        Assets.messageEffectBasketball,
        Assets.messageEffectFireworks,
        Assets.messageEffectBeer,
        Assets.messageEffectFirst,
        Assets.messageEffectCar,
      ].map((e) {
        final child = Container(
          // height: 40,
          // width: 201,
          child: LiveStreamEnterEffectCard(
            imagePath: e,
            text: "某某某进入直播间",
          ),
        );
        return GestureDetector(
          onTap: () {
            NReuseToast.show(
              context: context,
              tag: '篮球',
              left: 200,
              child: child,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.blue),
            ),
            child: child,
          ),
        );
      }).toList(),
    );
  }
}
