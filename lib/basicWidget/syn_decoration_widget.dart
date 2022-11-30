import 'dart:ui' as ui;
import 'package:flutter/material.dart';


/// 组件通用外观设置
class SynDecorationWidget extends StatelessWidget {

  SynDecorationWidget({
    Key? key,
    this.title,
    this.width = double.infinity,
    this.height = double.infinity,
    this.opacity = 1.0,
    this.blur = 0,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
    this.topLeftRadius = 0,
    this.topRightRadius = 0,
    this.bottomLeftRadius = 0,
    this.bottomRightRadius = 0,
    this.border = const Border.fromBorderSide(BorderSide(color: Colors.transparent, width: 0)),
    this.bgColor,
    this.bgGradient,
    this.bgUrl,
    this.bgChild,
    required this.child
  }) : super(key: key);

  /// 标题
  String? title;

  /// 高斯模糊
  double? width;
  /// 高斯模糊
  double? height;

  /// 透明度 0 - 1
  double opacity;
  /// 高斯模糊
  double blur;

  /// 外间距
  EdgeInsetsGeometry margin;
  /// 内间距
  EdgeInsetsGeometry padding;

  ///四个位置圆角
  double topLeftRadius;
  double topRightRadius;
  double bottomLeftRadius;
  double bottomRightRadius;

  /// 描边
  BoxBorder? border;

  /// 组件背景
  String? bgUrl;

  /// 组件背景颜色
  Color? bgColor;

  /// 渐变色背景色
  Gradient? bgGradient;

  /// 组件背景自定义
  Widget? bgChild;

  /// 组件子组件
  Widget child;

  // 模型传参
  // SynDecorationWidget.model({
  //   Key? key,
  //   Object? model,
  // }): this(
  //     blur: model.blur,
  //     opacity: model.opacity,
  //     margin: model.margin,
  //     padding: model.padding,
  //     border: model.border,
  //     topLeftRadius: model.topLeftRadius,
  //     topRightRadius: model.topRightRadius,
  //     bottomLeftRadius: model.bottomLeftRadius,
  //     bottomRightRadius: model.bottomRightRadius,
  //     child: model.child,
  //     bgChild: model.bgChild,
  //   );
  // };


  @override
  Widget build(BuildContext context) {
    return buildBody(
      width: this.width,
      height: this.height,
      blur: this.blur,
      opacity: this.opacity,
      margin: this.margin,
      padding: this.padding,
      border: this.border,
      topLeftRadius: this.topLeftRadius,
      topRightRadius: this.topRightRadius,
      bottomLeftRadius: this.bottomLeftRadius,
      bottomRightRadius: this.bottomRightRadius,
      bgUrl: this.bgUrl,
      bgColor: this.bgColor,
      bgGradient: this.bgGradient,
      child: this.child,
      bgChild: this.bgChild,
    );
  }

  buildBorderRadius({
    double topLeftRadius = 0,
    double topRightRadius = 0,
    double bottomLeftRadius = 0,
    double bottomRightRadius = 0,
  }) {
    return BorderRadius.only(
      topLeft: Radius.circular(topLeftRadius),
      topRight: Radius.circular(topRightRadius),
      bottomLeft: Radius.circular(bottomLeftRadius),
      bottomRight: Radius.circular(bottomRightRadius),
    );
  }

  buildBoxDecoration({
    Color? color,
    Gradient? gradient,
    BoxBorder? border = const Border.fromBorderSide(BorderSide(color: Colors.transparent, width: 0)),
    required BorderRadius borderRadius,
  }) {
    return BoxDecoration(
      gradient: gradient,
      color: color,
      border: border,
      borderRadius: borderRadius,
      // image: DecorationImage(
      //   image: NetworkImage(imgUrl),
      //     fit: BoxFit.cover,
      // ),
    );
  }

  buildBody({
    double? width,
    double? height,
    double blur = 0,
    double opacity = 1.0,
    EdgeInsetsGeometry margin = const EdgeInsets.all(0),
    EdgeInsetsGeometry padding = const EdgeInsets.all(0),
    BoxBorder? border,
    double topLeftRadius = 0,
    double topRightRadius = 0,
    double bottomLeftRadius = 0,
    double bottomRightRadius = 0,
    Color? bgColor,
    Gradient? bgGradient,
    String? bgUrl,
    Widget? bgChild,
    required Widget child,
  }) {

    final borderRadius = buildBorderRadius(
      topLeftRadius: topLeftRadius,
      topRightRadius: topRightRadius,
      bottomLeftRadius: bottomLeftRadius,
      bottomRightRadius: bottomRightRadius,
    );

    final decoration = buildBoxDecoration(
      border: border,
      borderRadius: borderRadius,
      color: bgColor,
      gradient: bgGradient,
    );

    // bgUrl 不为空则为背景图片
    // final refreshImage = bgUrl != null && bgUrl != '' ? AutoRefreshImage(
    //   bgUrl,
    //   BoxFit.fitWidth,
    //   width: width,
    //   height: height,
    // ) : Container(
    //   width: width,
    //   height: height,
    //   decoration: decoration,
    // );

    final refreshImage = bgUrl != null && bgUrl != '' ? FadeInImage.assetNetwork(
      placeholder: 'images/img_placeholder.png',
      image: 'https://tenfei02.cfp.cn/creative/vcg/800/new/VCG21409037867.jpg',
      fit: BoxFit.fill,
      width: width,
      height: height,
    ) : Container(
      width: width,
      height: height,
      decoration: decoration,
    );

    final bg = (bgGradient != null) ? SizedBox() : ClipRRect(
      borderRadius: borderRadius,
      child: bgChild ?? refreshImage,
    );

    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: blur,
          sigmaY: blur,
        ),
        child: Opacity(
          opacity: opacity,
          child: Container(
            width: width,
            height: height,
            margin: margin,
            padding: padding,
            decoration: decoration,
            child: Stack(
              children: [
                bg,
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}