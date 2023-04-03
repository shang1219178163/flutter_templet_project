import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter_templet_project/extension/edge_insets_ext.dart';


/// 组件通用外观设置
class NBoxWidget extends StatelessWidget {
  NBoxWidget({
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
    this.boxShadows,
  }) : super(key: key);

  /// 标题
  String? title;

  /// 高斯模糊
  double? width;

  /// 高斯模糊
  double? height;

  /// 透明度 0 - 1
  double? opacity;

  /// 高斯模糊
  double blur;

  /// 背景高斯模糊
  double bgBlur;

  /// 外间距
  EdgeInsets margin;

  /// 内间距
  EdgeInsets padding;

  ///四个位置圆角
  BorderRadius? borderRadius;

  /// 描边
  BoxBorder? border;

  /// 组件背景
  String? bgUrl;

  /// 组件背景 fit 模式,默认 BoxFit.cover
  BoxFit? imageFit;

  /// 组件背景颜色
  Color? bgColor;

  /// 渐变色背景色
  Gradient? bgGradient;

  /// 组件子组件
  Widget child;

  /// 阴影
  List<BoxShadow>? boxShadows;

  /// 前景滤镜
  ui.ImageFilter? foregroundFilter;
  /// 背景滤镜
  ui.ImageFilter? filter;

  @override
  Widget build(BuildContext context) {
    return _buildBody(
      width: width,
      height: height,
      blur: blur,
      bgBlur: bgBlur,
      opacity: opacity,
      margin: margin,
      padding: padding,
      border: border,
      borderRadius: borderRadius,
      bgUrl: bgUrl,
      bgColor: bgColor,
      bgGradient: bgGradient,
      boxShadows: boxShadows,
      child: child,
      imageFit: imageFit,
    );
  }

  _buildBody({
    double? width,
    double? height,
    double blur = 0,
    double bgBlur = 0,
    double? opacity = 1.0,
    EdgeInsets margin = const EdgeInsets.all(0),
    EdgeInsets padding = const EdgeInsets.all(0),
    BoxBorder? border,
    BorderRadius? borderRadius,
    Color? bgColor,
    Gradient? bgGradient,
    String? bgUrl,
    BoxFit? imageFit,
    List<BoxShadow>? boxShadows,
    required Widget child,
    bool? hideBlur = false
  }) {
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
    ) : null;

    if (width != null && height != null) {
      /// 留出阴影空间
      margin = margin.mergeShadows(shadows: boxShadows);
      // print("margin: ${margin}");
    }

    // if (this.title != null && this.title!.contains('图文导航')) {
    //   bgBlur = 5;//add test
    // }
    // bgBlur = 10;//add test
    // blur = 10;//add test

    final decoration = BoxDecoration(
      borderRadius: borderRadius,
      gradient: bgGradient,
      boxShadow: boxShadows,
      image: decorationImage,
      border: border,
      // color: bgGradient != null ? Colors.white : bgColor,
      color: bgColor,
    );

    final opacityNew = opacity?.clamp(0, 1.0).toDouble() ?? 1.0;
    return Opacity(
      opacity: opacityNew,
      child: Container(
        width: width,
        height: height,
        margin: margin.isNonNegative ? margin : EdgeInsets.zero,
        padding: padding,
        decoration: decoration,
          child: ClipRRect(
            borderRadius: borderRadius,
            child: BackdropFilter(
              filter: filter ?? ui.ImageFilter.blur(
                sigmaX: bgBlur,
                sigmaY: bgBlur,
              ),
              child: ImageFiltered(
                imageFilter: foregroundFilter ?? ui.ImageFilter.blur(
                  sigmaX: blur,
                  sigmaY: blur,
                ),
                child: child
              ),
          ),
        ),
      ),
    );
  }
}
