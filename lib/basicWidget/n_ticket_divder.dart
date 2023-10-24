//
//  NTicketDivder.dart
//  flutter_templet_project
//
//  Created by shang on 2023/10/24 18:24.
//  Copyright © 2023/10/24 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_dash_line.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';


/// 票据分割线
class NTicketDivder extends StatelessWidget {

  const NTicketDivder({
  	Key? key,
    this.halfCircleWidth = 10,
    this.halfCircleHeight = 20,
    this.halfCircleColor,
    this.dashLine,
  }) : super(key: key);

  /// 半圆宽度
  final double halfCircleWidth;
  /// 半圆高度
  final double halfCircleHeight;
  /// 半圆颜色
  final Color? halfCircleColor;
  /// 中间虚线
  final NDashLine? dashLine;

  @override
  Widget build(BuildContext context) {

    final halfCircle = Image(
      image: "icon_circle_half.png".toAssetImage(),
      width: halfCircleWidth.h,
      height: halfCircleHeight.h,
    );

    return Row(
      children: [
        halfCircle,
        Expanded(
          child: dashLine ?? NDashLine(
            color: const Color(0xffCCCCCC),
          )
        ),
        RotatedBox(
          quarterTurns: 2,
          child: halfCircle,
        ),
      ],
    );
  }
}