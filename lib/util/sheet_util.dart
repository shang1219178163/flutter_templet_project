import 'package:flutter/material.dart';

/// sheet 原生弹窗封装类
class SheetUtil {
  /// 选择主题
  static void show({
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    required Widget child,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        minHeight: 200,
        maxHeight: 500,
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: padding,
            child: Column(
              children: [
                child,
              ],
            ),
          ),
        );
      },
    );
  }
}
