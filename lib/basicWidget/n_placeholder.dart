

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/uti/color_uti.dart';

/// 占位
class NPlaceholder extends StatelessWidget {

  NPlaceholder({
  	Key? key,
    required this.onTap,
    this.imageName,
    this.message,
    this.imageAndTextSpacing = 10,
    this.image,
    this.text,
  }) : super(key: key);

  String? imageName;

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
          overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
        ),
        onPressed: onTap ?? () {
          debugPrint("$this");
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image ?? Image(
              image: imageName?.toAssetImage() ??
                  "img_network_empty.png".toAssetImage(),
              width: 110.w,
              height: 110.w,
            ),
            SizedBox(height: imageAndTextSpacing,),
            text ?? Text(message ?? "暂无数据",
              style: TextStyle(
                color: fontColor[30],
                fontSize: 14.sp,
              ),
            )
          ],
        )
      ),
    );
  }
}