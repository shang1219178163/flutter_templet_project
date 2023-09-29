import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/uti/color_util.dart';


class NCancelAndConfirmBar extends StatelessWidget {
  NCancelAndConfirmBar({
    Key? key,
    this.height = 48,
    this.cancelTitle = "取消",
    this.confirmTitle = "确定",
    this.bottomLeftRadius = const Radius.circular(4),
    this.bottomRightRadius = const Radius.circular(4),
    this.hasCancelButton = true,
    required this.onCancel,
    required this.onConfirm,
    this.cancelBgColor = bgColor,
    this.confirmBgColor = Colors.blueAccent,
    this.cancelTextStyle,
    this.confirmTextStyle,
    this.divider,
  }) : super(key: key);


  double height;
  /// 默认取消
  String cancelTitle;
  /// 默认确定
  String confirmTitle;
  /// 默认 Radius.circular(4)
  Radius bottomLeftRadius;
  /// 默认 Radius.circular(4)
  Radius bottomRightRadius;
  /// 是否存在取消按钮
  bool hasCancelButton;
  /// 取消按钮事件
  VoidCallback? onCancel;
  /// 确定按钮事件
  VoidCallback? onConfirm;
  /// 取消按钮背景色
  Color? cancelBgColor;
  /// 确定按钮背景色
  Color? confirmBgColor;
  /// 取消按钮字体样式
  TextStyle? cancelTextStyle;
  /// 确定按钮字体样式
  TextStyle? confirmTextStyle;
  /// 取消按钮和确定之间竖线
  VerticalDivider? divider;

  @override
  Widget build(BuildContext context) {
    return buildCancelAndConfirmBar();
  }

  buildCancelAndConfirmBar() {
    return Card(
      child: Container(
        height: height.h,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: bottomLeftRadius.r,
            bottomRight: bottomRightRadius.r,
          ),
        ),
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
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: fontColor[20],
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            if (divider != null) divider!,
            Expanded(
              child: InkWell(
                onTap: onConfirm,
                child: Container(
                  color: confirmBgColor,
                  child: Center(
                    child: Text(
                      confirmTitle,
                      style: confirmTextStyle ??
                          TextStyle(
                            fontSize: 16.sp,
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
    );
  }
}
