

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/uti/color_util.dart';


class NCancelAndConfirmBar extends StatelessWidget {

  NCancelAndConfirmBar({
    Key? key,
    this.title,
    this.height = 45,
    this.cancelTitle = "取消",
    this.confirmTitle = "确定",
    this.bottomLeftRadius = const Radius.circular(4),
    this.bottomRightRadius = const Radius.circular(4),
    required this.onCancel,
    required this.onConfirm,
    this.cancelBgColor = bgColor,
    this.confirmBgColor = Colors.blueAccent,
    this.cancelTextStyle,
    this.confirmTextStyle,
    this.divider,
  }) : super(key: key);

  String? title;
  double height;
  String cancelTitle;
  String confirmTitle;
  Radius bottomLeftRadius;
  Radius bottomRightRadius;
  VoidCallback? onCancel;
  VoidCallback? onConfirm;
  Color? cancelBgColor = bgColor;
  Color? confirmBgColor = Colors.blueAccent;
  TextStyle? cancelTextStyle;
  TextStyle? confirmTextStyle;

  VerticalDivider? divider;

  @override
  Widget build(BuildContext context) {
    return buildCancellAndConfirmBar();
  }

  buildCancellAndConfirmBar(
      //  {
      //   double height = 48,
      //   String cancellTitle = "取消",
      //   String confirmTitle = "确定",
      //   Radius bottomLeft = const Radius.circular(4),
      //   Radius bottomRight = const Radius.circular(4),
      //   VoidCallback? onCancell,
      //   VoidCallback? onConfirm,
      //   Color cancellBgColor = bgColor,
      //   Color confirmBgColor = primary,
      //   TextStyle? cancellTextStyle,
      //   TextStyle? confirmTextStyle,
      // }
      ) {
    return Material(
      borderRadius: BorderRadius.only(
        bottomLeft: bottomRightRadius,
        bottomRight: bottomRightRadius,
      ),
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: onCancel,
                child: Container(
                  decoration: BoxDecoration(
                      color: cancelBgColor,
                      borderRadius: BorderRadius.only(bottomLeft: bottomLeftRadius)
                  ),
                  child: Center(
                    child: Text(cancelTitle,
                      style: cancelTextStyle ?? TextStyle(
                        fontSize: 18.sp,
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
                  decoration: BoxDecoration(
                      color: confirmBgColor,
                      borderRadius: BorderRadius.only(bottomRight: bottomRightRadius)
                  ),
                  child: Center(
                    child: Text(confirmTitle,
                      style: confirmTextStyle ?? TextStyle(
                        fontSize: 18.sp,
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