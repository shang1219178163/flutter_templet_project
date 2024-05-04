import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/util/color_util.dart';

enum NPlaceholderType {
  none,
  empty,
  offline;
}

/// 占位
class NPlaceholder extends StatelessWidget {
  NPlaceholder({
    Key? key,
    this.onTap,
    this.placeholder =
        const AssetImage("assets/images/img_placeholder_empty.png"),
    this.message,
    this.imageAndTextSpacing = 10,
    this.image,
    this.text,
  }) : super(key: key);

  AssetImage placeholder;

  String? message;

  Widget? image;

  Widget? text;

  double imageAndTextSpacing;

  VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      // alignment: Alignment.center,
      child: TextButton(
          style: ButtonStyle(
            overlayColor:
                MaterialStateColor.resolveWith((states) => Colors.transparent),
          ),
          onPressed: onTap ??
              () {
                debugPrint("$this");
              },
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
                      color: fontColor999999,
                      fontSize: 14.sp,
                    ),
                  )
            ],
          )),
    );
  }
}
