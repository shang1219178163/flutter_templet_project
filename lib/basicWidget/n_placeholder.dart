import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';

enum NPlaceholderType {
  none,
  empty,
  offline;
}

/// 占位
class NPlaceholder extends StatelessWidget {
  const NPlaceholder({
    super.key,
    this.onTap,
    this.placeholder = const AssetImage("assets/images/img_placeholder_empty.png"),
    this.message,
    this.imageAndTextSpacing = 10,
    this.image,
    this.text,
  });

  final AssetImage placeholder;

  final String? message;

  final Widget? image;

  final Widget? text;

  final double imageAndTextSpacing;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      // alignment: Alignment.center,
      child: TextButton(
          style: ButtonStyle(
            overlayColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
          ),
          onPressed: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              image ??
                  Image(
                    image: placeholder,
                    width: 110.w,
                    height: 110.w,
                  ),
              SizedBox(
                height: imageAndTextSpacing,
              ),
              text ??
                  Text(
                    message ?? "暂无数据",
                    style: TextStyle(
                      color: AppColor.fontColor999999,
                      fontSize: 14.sp,
                    ),
                  )
            ],
          )),
    );
  }
}
