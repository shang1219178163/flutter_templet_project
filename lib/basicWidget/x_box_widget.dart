//
//  XBoxWidget.dart
//  flutter_templet_project
//
//  Created by shang on 2024/8/4 08:55.
//  Copyright © 2024/8/4 shang. All rights reserved.
//

import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

/// 组件通用外观设置
class XBoxWidget extends StatelessWidget {
  XBoxWidget({
    Key? key,
    this.title,
    required this.child,
    this.width,
    this.height,
    this.opacity = 1.0,
    this.blur = 0,
    this.bgBlur = 0,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
    this.borderRadius = const BorderRadius.all(Radius.circular(0)),
    this.border = const Border(),
    this.bgColor = Colors.transparent,
    this.bgGradient,
    this.bgUrl,
    this.imageFit = BoxFit.cover,
    this.boxShadow,
    this.hideBlur = false,
  }) : super(key: key);

  /// 标题
  final String? title;

  /// 高斯模糊
  final double? width;

  /// 高斯模糊
  final double? height;

  /// 透明度 0 - 1
  final double? opacity;

  /// 高斯模糊
  final double blur;

  /// 背景高斯模糊
  final double bgBlur;

  /// 外间距
  final EdgeInsets margin;

  /// 内间距
  final EdgeInsets padding;

  ///四个位置圆角
  final BorderRadius? borderRadius;

  /// 描边
  final BoxBorder? border;

  /// 组件背景
  final String? bgUrl;

  /// 组件背景 fit 模式,默认 BoxFit.cover
  final BoxFit? imageFit;

  /// 组件背景颜色
  final Color? bgColor;

  /// 渐变色背景色
  final Gradient? bgGradient;

  /// 组件子组件
  final Widget child;

  /// 阴影
  final List<BoxShadow>? boxShadow;

  /// 隐藏高斯模糊(测试属性)
  final bool? hideBlur;

  @override
  Widget build(BuildContext context) {
    // add test
    // bgGradient = LinearGradient(
    //     colors: [Colors.red, Colors.green],
    //     begin: Alignment.topCenter,
    //     end: Alignment.bottomCenter,
    //   );
    // add test
    // bgUrl = 'https://i.zgjm.org/top/20190526/3264-1.jpg';
    //bgUrl 不为空则为背景图片
    var decorationImage = bgUrl?.startsWith('http') == true
        ? DecorationImage(
//         image: NetworkImage(bgUrl),
            image: CachedNetworkImageProvider(bgUrl!),
            fit: imageFit,
          )
        : null;

    var effectiveMargin = margin;

    if (boxShadow != null && boxShadow!.isNotEmpty && width != null && height != null) {
      var shadow = boxShadow![0];

      /// 留出阴影空间
      effectiveMargin = effectiveMargin.mergeShadow(shadow: shadow);
    }
    effectiveMargin = effectiveMargin.positive;

    // if (this.title != null && this.title!.contains('图文导航')) {
    //   bgBlur = 5;//add test
    // }
    // bgBlur = 10;//add test
    // blur = 10;//add test

    final decoration = BoxDecoration(
        borderRadius: borderRadius,
        gradient: bgGradient,
        boxShadow: boxShadow,
        image: decorationImage,
        border: border,
        color: bgColor);

    // if (hideBlur == true) {
    //   return Container(
    //     width: width,
    //     height: height,
    //     margin: margin.isNonNegative ? margin : EdgeInsets.zero,
    //     padding: padding,
    //     decoration: decoration,
    //     child: child
    //   );
    // }

    final opacityNew = opacity?.clamp(0, 1.0).toDouble() ?? 1.0;
    var opacity2 = ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Opacity(
        opacity: opacityNew,
        child: Container(
            width: width,
            height: height,
            margin: effectiveMargin.isNonNegative ? effectiveMargin : EdgeInsets.zero,
            decoration: decoration,
            child: ClipRRect(
              borderRadius: borderRadius ?? BorderRadius.zero,
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: bgBlur, sigmaY: bgBlur),
                child: Container(
                  constraints: BoxConstraints.expand(),
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                  ),
                  child: Container(padding: padding, child: child),
                ),
              ),
            )),
      ),
    );

    if (blur <= 0) {
      return opacity2;
    }

    final stackWidget = Stack(
      children: [
        opacity2,
        Positioned(
            left: margin.left,
            top: margin.top,
            right: margin.right,
            bottom: margin.bottom,
            child: ClipRRect(
              borderRadius: borderRadius ?? BorderRadius.zero,
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(
                  sigmaX: blur,
                  sigmaY: blur,
                ),
                child: Container(
                  color: Colors.black.withValues(alpha: 0),
                ),
              ),
            ))
      ],
    );
    return stackWidget;
  }
}
