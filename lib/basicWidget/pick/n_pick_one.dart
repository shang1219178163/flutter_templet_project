import 'package:flutter/material.dart';

/// 选择器
class NPickOne<T> extends StatelessWidget {
  const NPickOne({
    super.key,
    required this.items,
    this.initialItem,
    required this.onSelected,
    this.onCancel,
    this.itemHeight = 56,
  });

  final List<T> items;
  final T? initialItem;
  final void Function(T value) onSelected;
  final VoidCallback? onCancel;
  final double? itemHeight;

  static show<T>({
    required BuildContext context,
    required List<T> items,
    T? initialItem,
    required void Function(T value) onSelected,
    VoidCallback? onCancel,
    double? itemHeight = 56,
  }) {
    return showModalBottomSheet(
      context: context,
      clipBehavior: Clip.hardEdge,
      // isScrollControlled: true,
      // useRootNavigator: true,
      // scrollControlDisabledMaxHeightRatio: 0.75,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      builder: (context) {
        return NPickOne(
          items: items,
          onSelected: onSelected,
          onCancel: onCancel,
          itemHeight: itemHeight,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final colorScheme = themeData.colorScheme;
    final primary = colorScheme.primary;
    final onPrimary = colorScheme.onPrimary;
    final isDark = themeData.brightness == Brightness.dark;

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...items.map((e) {
                      final i = items.indexOf(e);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          buildItem(
                            e: e.toString(),
                            onTap: () {
                              onSelected(e);
                            },
                            height: itemHeight,
                          ),
                          if (e != items.last) Divider(),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
          Divider(thickness: 8, color: colorScheme.surfaceDim),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: buildItem(
              e: "取消",
              onTap: () {
                if (onCancel != null) {
                  onCancel?.call();
                  return;
                }
                Navigator.pop(context);
              },
              height: itemHeight,
              textColor: colorScheme.error,
            ),
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
