import 'package:flutter/material.dart';

/// 底部弹窗
class BottomSheetUtil {
  /// 展示自定义UI
  static Future show({
    required BuildContext context,
    Widget? topControl,
    Color? topControlColor,
    bool isScrollable = true,
    double maxHeight = 500,
    double minHeight = 200,
    double? heightFactor,
    double raius = 15,
    required Widget child,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xff181829) : Colors.white;
    final barrierColor = isDark ? Colors.black.withOpacity(0.7) : Colors.black.withOpacity(0.1);
    // final borderColor = isDark ? Colors.black : Colors.white;

    final titleColor = isDark ? Colors.white : Color(0xff313135);
    final subtitleColor = isDark ? Colors.white.withOpacity(0.8) : Color(0xff7C7C85);

    final topControlColorDefault =
        isDark ? const Color(0xFFEEEEEE).withOpacity(0.3) : const Color(0xFFFFFFFF).withOpacity(0.3);
    return showModalBottomSheet(
      context: context,
      backgroundColor: backgroundColor,
      barrierColor: barrierColor,
      shape: RoundedRectangleBorder(
        // side: BorderSide(color: borderColor),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(raius),
          topRight: Radius.circular(raius),
        ),
      ),
      elevation: 0,
      builder: (context) {
        Widget content = child;
        if (isScrollable) {
          content = Scrollbar(
            child: SingleChildScrollView(
              child: Material(
                color: backgroundColor,
                // elevation: 0,
                // shadowColor: backgroundColor,
                // shape: RoundedRectangleBorder(
                //   side: BorderSide(color: Colors.red),
                // ),
                child: content,
              ),
            ),
          );
        }
        if (heightFactor != null) {
          content = FractionallySizedBox(
            heightFactor: heightFactor,
            child: content,
          );
        } else {
          content = ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: maxHeight,
              minHeight: minHeight,
            ),
            child: content,
          );
        }
        return Stack(
          children: [
            content,
            Positioned(
              top: 8,
              left: 0,
              right: 0,
              child: Center(
                child: topControl ??
                    Container(
                      width: 30,
                      height: 4,
                      decoration: BoxDecoration(
                        color: topControlColor ?? topControlColorDefault,
                        borderRadius: const BorderRadius.all(Radius.circular(2)),
                      ),
                    ),
              ),
            ),
          ],
        );
      },
    );
  }

  // BottomSheetHelper.showBottomMenu(
  //   context: context,
  //   items: [
  //     (
  //       title: "即时",
  //       onTap: () {},
  //     ),
  //     (
  //       title: "赛前",
  //       onTap: () {},
  //     ),
  //   ],
  // );
  /// 显示选择菜单
  static Future showBottomMenu({
    required BuildContext context,
    required List<({String title, VoidCallback onTap})> items,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? Color(0xff181829) : Color(0xffF6F6F6);
    final cardColor = isDark ? Color(0xff242434) : Colors.white;

    final titleColor = isDark ? Colors.white : Color(0xff313135);
    final subtitleColor = isDark ? Colors.white.withOpacity(0.6) : Color(0xff7C7C85);
    final cancelColor = Color(0xffE44554);

    return show(
      context: context,
      topControl: const SizedBox(),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...items.map((e) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  e.onTap();
                },
                child: Container(
                  height: 50,
                  margin: EdgeInsets.only(bottom: 1),
                  decoration: BoxDecoration(
                    color: cardColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        e.title,
                        style: TextStyle(fontSize: 14, color: titleColor),
                      ),
                    ],
                  ),
                ),
              );
            }),
            SizedBox(height: 8),
            GestureDetector(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: cardColor,
                ),
                alignment: Alignment.center,
                child: Text(
                  "取消",
                  style: TextStyle(fontSize: 14, color: titleColor),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
