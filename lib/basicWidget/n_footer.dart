

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///表尾
class NFooter extends StatelessWidget {

  NFooter({
  	Key? key,
    required this.title,
    required this.onPressed,
    this.style,
    this.padding = const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
    this.height = 45,
    this.radius = 22.5,
    this.color,
    this.btnColor,
    this.btnElevation = 2,
    this.header,
    this.child,
    this.footer,
  }) : super(key: key);

  String title;
  TextStyle? style;
  EdgeInsets padding;
  double height;
  double radius;
  VoidCallback? onPressed;
  Color? color;
  Color? btnColor;
  double? btnElevation;
  Widget? header;
  Widget? footer;
  Widget? child;

  @override
  Widget build(BuildContext context) {
    return buildPageFooter(context);
  }

  buildPageFooter(
      BuildContext context
  //     {
  //   String title = "button",
  //   TextStyle? style,
  //   EdgeInsets padding = const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
  //   double height = 45,
  //   double radius = 22.5,
  //   bool enable = true,
  //   VoidCallback? onPressed,
  //   Color? bgColor,
  //   Color? btnColor = primary,
  //   Widget? header,
  //   Widget? footer,
  // }
  ) {
    btnColor ??= Theme.of(context).primaryColor;
    return Container(
      color: color,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (header!= null) header!,
          MaterialButton(
            height: height,
            color: btnColor,
            disabledColor: btnColor?.withOpacity(0.5),
            elevation: btnElevation,
            onPressed: onPressed ?? () {
              debugPrint("$title");
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
            ),
            child: child ?? Text(title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (footer!= null) footer!,
        ],
      ),
    );
  }
}