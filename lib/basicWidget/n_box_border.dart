// //
// //  NBoxBorder.dart
// //  flutter_templet_project
// //
// //  Created by shang on 4/12/23 11:02 AM.
// //  Copyright © 4/12/23 shang. All rights reserved.
// //
//
//
// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
//
// class NBoxBorder extends StatelessWidget {
//
//   NBoxBorder({
//     Key? key,
//     this.title,
//     this.radius,
//     this.border,
//     this.fixedSize,
//     required this.isSDKBorder,
//     required this.child,
//   }) : super(key: key);
//
//   final String? title;
//
//   final AttrRadius? radius;
//
//   final AttrBorder? border;
//   /// 是否是 flutter SDK 边框
//   final bool isSDKBorder;
//
//   final Widget child;
//   /// 边框是否固定尺寸
//   final Size? fixedSize;
//
//   @override
//   Widget build(BuildContext context) {
//
//     // final isSDKBorder = ['unset', 'solid', null].contains(this.border?.style);
//     if (isSDKBorder) {
//       return child;
//     }
//
//     var borderRadius = this.radius?.borderRadius ?? BorderRadius.circular(0);
//
//     final container = Container(
//       decoration: BoxDecoration(
//         // color: Colors.white,
//         borderRadius: borderRadius,
//         // border: this.border?.border,
//         // border: Border.all(color: Colors.red),
//       ),
//       child: child,
//     );
//
//     return toDottedBorder(
//       child: container,
//       borderRadius: borderRadius,
//     ) ?? container;
//   }
//
//   /// 第三方 DottedBorder 边框线
//   Widget? toDottedBorder({
//     required Widget child,
//     BorderRadius? borderRadius = const BorderRadius.all(Radius.circular(0)),
//   }) {
//     if (this.border?.style == 'unset' ||
//         this.border?.width == 0) {
//       return null;
//     }
//
//     final color = CommonUtil.toColor(this.border?.color?.value);
//     if (color == null) {
//       return null;
//     }
//
//     var strokeWidth = this.border?.width ?? 0;
//     var radius = borderRadius?.topLeft ?? Radius.circular(0);
//
//     var dashPattern = this.border?.lineDashPattern ?? [4, 0];
//
//     // dashPattern = [1.5, 1.5];//add test
//     // dashPattern = [10, 6];//add test
//     // strokeWidth = 2;//add test
//     // borderRadius = BorderRadius.all(Radius.circular(19));//add test
//
//     return DottedBorder(
//       padding: EdgeInsets.all(strokeWidth),
//       borderType: BorderType.RRect,
//       color: color,
//       strokeWidth: strokeWidth,
//       dashPattern: dashPattern,
//       radius: radius,
//       // fixedSize: fixedSize,
//       child: ClipRRect(
//         borderRadius: borderRadius,
//         child: child,
//       ),
//     );
//   }
//
// }
//
// class AttrBorder {
//   AttrBorder(
//     this.color,
//     this.style,
//     this.width,
//   );
//
//   String? style;
//   double? width;
//   Color? color;
// }