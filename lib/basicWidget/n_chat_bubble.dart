//
//  ChatBubble.dart
//  flutter_templet_project
//
//  Created by shang on 2026/4/20 09:39.
//  Copyright © 2026/4/20 shang. All rights reserved.
//

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// 图片背景气泡组件
class NChatBubble extends StatelessWidget {
  const NChatBubble({
    super.key,
    required this.imagePath,
    required this.metrics,
    required this.child,
  });

  final String imagePath;
  final NChatBubbleMetrics metrics;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider =
        imagePath.startsWith("http") ? CachedNetworkImageProvider(imagePath) : AssetImage(imagePath);
    return Container(
      // margin: const EdgeInsets.only(top: 10),
      // ⭐关键1：给足最小高度（防止单行塌陷）
      constraints: metrics.constraints,
      // ⭐关键2：padding 不能贴边
      padding: metrics.padding,
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.blue),
        image: DecorationImage(
          image: imageProvider,
          // ⭐关键3：中心点必须在“纯色区域”
          centerSlice: metrics.centerSlice,
          scale: 3, //必须加
        ),
      ),
      child: child,
    );
  }
}

/// 聊天气泡参数
class NChatBubbleMetrics {
  const NChatBubbleMetrics({
    required this.imageSize,
    this.safeInset = EdgeInsets.zero,
    this.adjust = const EdgeInsets.all(4),
  });

  final Size imageSize; // 原图尺寸（必须准确）
  final EdgeInsets safeInset; // 不可拉伸区域（边框 + 尾巴）
  final EdgeInsets adjust;

  /// 容器约束
  BoxConstraints get constraints => BoxConstraints(
        minWidth: imageSize.width,
        minHeight: imageSize.height,
      );

  /// 内边距
  EdgeInsets get padding => calcPadding();

  /// 中心拉伸区域
  Rect get centerSlice => calcCenterSlice();

  /// 👉 计算 centerSlice（永远在安全拉伸区中心）
  Rect calcCenterSlice() {
    return Rect.fromLTWH(safeInset.left, safeInset.top, 1, 1);

    final left = safeInset.left;
    final top = safeInset.top;

    final right = imageSize.width - safeInset.right;
    final bottom = imageSize.height - safeInset.bottom;

    final cx = (left + right) / 2;
    final cy = (top + bottom) / 2;

    return Rect.fromLTWH(cx, cy, 1, 1);
  }

  /// 👉 padding（略小于 safeInset，让文字更贴合）
  EdgeInsets calcPadding() {
    return EdgeInsets.fromLTRB(
      (safeInset.left - adjust.left).clamp(0, double.infinity),
      (safeInset.top - adjust.top).clamp(0, double.infinity),
      (safeInset.right - adjust.right).clamp(0, double.infinity),
      (safeInset.bottom - adjust.bottom).clamp(0, double.infinity),
    );
  }
}
