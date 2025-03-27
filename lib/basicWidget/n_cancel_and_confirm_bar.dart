import 'package:flutter/material.dart';
import 'package:flutter_templet_project/util/color_util.dart';

class NCancelAndConfirmBar extends StatelessWidget {
  NCancelAndConfirmBar({
    Key? key,
    this.height = 48,
    this.cancelTitle = "取消",
    this.confirmTitle = "确定",
    this.bottomRadius = const Radius.circular(4),
    this.hasCancelButton = true,
    this.divider,
    this.dividerTop,
    this.cancelTextStyle,
    this.confirmTextStyle,
    this.cancelBgColor = bgColor,
    this.confirmBgColor = Colors.blueAccent,
    required this.onCancel,
    required this.onConfirm,
  }) : super(key: key);

  final double height;

  /// 默认 Radius.circular(4)
  final Radius bottomRadius;

  /// 顶部线
  final Divider? dividerTop;

  /// 垂直分割线
  final VerticalDivider? divider;

  /// 是否存在取消按钮
  final bool hasCancelButton;

  /// 默认取消
  final String cancelTitle;

  /// 默认确定
  final String confirmTitle;

  /// 取消按钮字体样式
  final TextStyle? cancelTextStyle;

  /// 确定按钮字体样式
  final TextStyle? confirmTextStyle;

  /// 取消按钮背景色
  final Color? cancelBgColor;

  /// 确定按钮背景色
  final Color? confirmBgColor;

  /// 取消按钮事件
  final VoidCallback? onCancel;

  /// 确定按钮事件
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    return buildCancelAndConfirmBar();
  }

  buildCancelAndConfirmBar() {
    return Card(
      margin: EdgeInsets.zero,
      // color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          bottomRadius,
        ),
      ),
      child: Container(
        height: height,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: bottomRadius,
            bottomRight: bottomRadius,
          ),
        ),
        child: Column(
          children: [
            dividerTop ?? const SizedBox(),
            Expanded(
              child: Row(
                children: [
                  if (hasCancelButton)
                    Expanded(
                      child: InkWell(
                        onTap: onCancel,
                        child: Container(
                          color: cancelBgColor,
                          child: Center(
                            child: Text(
                              cancelTitle,
                              style: cancelTextStyle ??
                                  TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: fontColor777777,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  divider ?? const SizedBox(),
                  Expanded(
                    child: InkWell(
                      onTap: onConfirm,
                      child: Container(
                        color: confirmBgColor,
                        child: Center(
                          child: Text(
                            confirmTitle,
                            style: confirmTextStyle ??
                                const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
