//
//  horizontal_cell.dart
//  flutter_templet_project
//
//  Created by shang on 1/11/23 4:33 PM.
//  Copyright © 1/11/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';

class HorizontalCell extends StatelessWidget {

  HorizontalCell({
  	Key? key,
    required this.title,
    this.titleRight,
    this.subtitle,
    this.subtitleRight,
    this.titleSpace = const SizedBox(height: 8),
    this.left,
    this.mid,
    this.right,
    this.arrow,
    this.height,
    this.margin,
    this.padding,
    this.decoration,
    this.separator,
    this.useIntrinsicHeight = true,
  }) : super(key: key);

  /// 主标题
  Text title;
  /// 主标题-右标题
  Text? titleRight;
  /// 副标题
  Text? subtitle;
  /// 副标题-右标题
  Text? subtitleRight;
  /// 主副标题中间的Widget
  Widget titleSpace;

  /// 总体为 left + mid + right + arrow;
  Widget? left;
  /// 总体为 left + mid + right + arrow;
  Widget? mid;
  /// 总体为 left + mid + right + arrow;
  Widget? right;
  /// 总体为 left + mid + right + arrow;
  Widget? arrow;
  /// 内容高度;
  double? height;
  /// 内容外边距;
  EdgeInsetsGeometry? margin;
  /// 内容内边距;
  EdgeInsetsGeometry? padding;
  /// 内容装饰器;
  Decoration? decoration;
  /// 内容下边的线条;
  Widget? separator;
  /// mid 是否使用 IntrinsicHeight;
  bool useIntrinsicHeight;

  @override
  Widget build(BuildContext context) {
    Widget contentView = Container(
      height: height,
      margin: margin,
      padding: padding,
      decoration: decoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if(left != null) left!,
          mid ?? Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      title,
                      if(titleRight != null) titleRight!,
                    ]
                        .map((e) => e.toContainer(color: ColorExt.random)).toList()
                    ,
                  ),
                  if (subtitle != null || subtitleRight != null) titleSpace,
                  if (subtitle != null || subtitleRight != null) Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      if(subtitle != null) subtitle!,
                      if(subtitleRight != null) subtitleRight!,
                    ]
                        .map((e) => e.toContainer(color: ColorExt.random)).toList()
                    ,
                  ),
                ]
            )
                .toContainer(color: ColorExt.random)
            ,
          ),
          if (right != null) right!,
          arrow ?? Container(
            padding: const EdgeInsets.only(left: 20),
            child: Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Colors.grey
            ),
          ),
        ],
      ),
    );

    if (useIntrinsicHeight) {
      contentView = IntrinsicHeight(
        child: contentView,
      );
    }

    return Column(
      children: [
        contentView,
        if (separator != null) separator!,
        // separator ?? Divider(
        //   color: Colors.blue,
        //   height: 1,
        //   // indent: 10,
        // ),
      ],
    );
  }

  /// 自定义 Cell
  // Widget buildHorizontalCell({
  //   required Text title,
  //   Text? titleRight,
  //   Text? subtitle,
  //   Text? subtitleRight,
  //   Widget titleSpace = const SizedBox(height: 8),
  //   Widget? right,
  //   Widget? arrow,
  //   double? height,
  //   EdgeInsetsGeometry? margin,
  //   EdgeInsetsGeometry? padding,
  //   Decoration? decoration,
  // }) {
  //   return Container(
  //     height: height,
  //     margin: margin,
  //     padding: padding,
  //     decoration: decoration,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Expanded(
  //           child: Column(
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     title,
  //                     if(titleRight != null) titleRight,
  //                   ].map((e) => e.toContainer(color: ColorExt.random)).toList(),
  //                 ),
  //                 if (subtitle != null || subtitleRight != null) titleSpace,
  //                 if (subtitle != null || subtitleRight != null) Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     if(subtitle != null) subtitle,
  //                     if(subtitleRight != null) subtitleRight,
  //                   ].map((e) => e.toContainer(color: ColorExt.random)).toList(),
  //                 ),
  //               ]
  //           ).toContainer(color: ColorExt.random),
  //         ),
  //         if (right != null) right,
  //         arrow ?? Container(
  //           padding: const EdgeInsets.only(left: 20),
  //           child: Icon(
  //               Icons.arrow_forward_ios,
  //               size: 20,
  //               color: Colors.grey
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}


