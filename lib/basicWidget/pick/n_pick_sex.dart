import 'package:flutter/material.dart';

/// 想别选择器
class NPickSex extends StatelessWidget {
  const NPickSex({
    super.key,
    this.items = const [
      "男",
      "女",
      "保密",
    ],
    required this.onTap,
    this.onCancel,
    this.itemHeight = 56,
  });

  final List<String> items;
  final ValueChanged<int> onTap;
  final VoidCallback? onCancel;
  final double? itemHeight;

  static show({
    required BuildContext context,
    List<String> items = const [
      "男",
      "女",
      "保密",
    ],
    required ValueChanged<int> onTap,
    VoidCallback? onCancel,
    double? itemHeight = 56,
  }) {
    return showModalBottomSheet(
      context: context,
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      builder: (context) {
        return NPickSex(
          items: items,
          onTap: onTap,
          onCancel: onCancel,
          itemHeight: itemHeight,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Color(0xFFF6F6F6);
    final foregroundColor = Colors.white;

    final textColor = Colors.black87;
    final textColorCancel = Colors.red;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...items.map((e) {
            final i = items.indexOf(e);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildItem(
                  e: e,
                  onTap: () {
                    onTap(i);
                  },
                  height: itemHeight,
                  foregroundColor: foregroundColor,
                  textColor: textColor,
                ),
                if (e != items.last) Divider(height: 0.5, color: backgroundColor),
              ],
            );
          }),
          const SizedBox(height: 8),
          buildItem(
            e: "取消",
            onTap: () {
              if (onCancel != null) {
                onCancel?.call();
                return;
              }
              Navigator.pop(context);
            },
            height: itemHeight,
            foregroundColor: foregroundColor,
            textColor: textColorCancel,
          ),
        ],
      ),
    );
  }

  Widget buildItem({
    required String e,
    required VoidCallback onTap,
    required double? height,
    Color? foregroundColor,
    Color? textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: foregroundColor,
        ),
        child: Text(
          e,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
