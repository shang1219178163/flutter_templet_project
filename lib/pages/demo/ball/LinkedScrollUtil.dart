import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LinkedScrollUtil {
  /// 平顺推进的滚动逻辑：只有当选中项越过中线时，才触发滚动使其居中
  static void scrollToCenterIfNeeded({
    required ScrollController controller,
    required int index,
    required double itemHeight,
    required int lastCenteredIndex,
    required void Function(int newIndex) onCentered,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.hasClients) {
        return;
      }

      final targetPosition = index * itemHeight;
      final viewportHeight = controller.position.viewportDimension;
      final currentOffset = controller.offset;
      final maxScrollExtent = controller.position.maxScrollExtent;

      final itemCenter = targetPosition + itemHeight / 2;
      final viewportCenter = currentOffset + viewportHeight / 2;

      final offsetFromCenter = (itemCenter - viewportCenter).abs();

      // 只有当选中项偏离中线超过一半item高度，或首次选中时，才滚动
      if (offsetFromCenter > itemHeight / 2 || lastCenteredIndex == -1) {
        onCentered(index);

        // 滚动时触发震动
        HapticFeedback.lightImpact();

        double targetScroll = targetPosition - viewportHeight / 2 + itemHeight / 2;
        targetScroll = targetScroll.clamp(0.0, maxScrollExtent);

        controller.animateTo(
          targetScroll,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }
}
