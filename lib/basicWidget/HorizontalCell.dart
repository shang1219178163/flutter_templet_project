//
//  HorizontalCell.dart
//  flutter_templet_project
//
//  Created by shang on 1/11/23 4:33 PM.
//  Copyright © 1/11/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/color_extension.dart';
import 'package:flutter_templet_project/extension/widget_extension.dart';

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
    this.separator
  }) : super(key: key);


  Text title;
  Text? titleRight;
  Text? subtitle;
  Text? subtitleRight;
  Widget titleSpace;

  Widget? left;
  Widget? mid;
  Widget? right;
  Widget? arrow;
  double? height;
  EdgeInsetsGeometry? margin;
  EdgeInsetsGeometry? padding;
  Decoration? decoration;
  Widget? separator;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
                    // if (subtitle != null || subtitleRight != null) titleSpace,
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
        ),
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


