import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// 组件通用外观设置
class XDecorationWidgetOne extends StatelessWidget {
  XDecorationWidgetOne({
    Key? key,
    this.title,
    this.width,
    this.height,
    this.opacity = 1.0,
    this.blur = 0,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
    this.topLeftRadius = 0,
    this.topRightRadius = 0,
    this.bottomLeftRadius = 0,
    this.bottomRightRadius = 0,
    this.border = const Border(),
    this.bgColor = Colors.transparent,
    this.bgGradient,
    this.bgUrl,
    this.bgChild,
    this.boxShadow,
    required this.child,
    this.addToSliverBox = false,
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

  bool addToSliverBox;

  /// 组件背景自定义
  Widget? bgChild;

  /// 组件子组件
  Widget child;

  /// 阴影
  List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    final child = buildBody(
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
      boxShadow: this.boxShadow,
      child: this.child,
      bgChild: this.bgChild,
    );

    if (this.addToSliverBox) {
      return SliverToBoxAdapter(
        child: child,
      );
    }
    return child;
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
    List<BoxShadow>? boxShadow,
    required Widget child,
  }) {
    final borderRadius = buildBorderRadius(
      topLeftRadius: topLeftRadius,
      topRightRadius: topRightRadius,
      bottomLeftRadius: bottomLeftRadius,
      bottomRightRadius: bottomRightRadius,
    );

    //bgUrl 不为空则为背景图片
    final decorationImage = bgUrl != null && bgUrl.startsWith('http')
        ? DecorationImage(
            image: NetworkImage(this.bgUrl!),
            fit: BoxFit.cover,
          ) : null;

    final decoration = BoxDecoration(
      borderRadius: borderRadius,
      gradient: bgGradient,
      boxShadow: boxShadow,
      image: decorationImage,
    );

    return Opacity(
      opacity: opacity,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        padding: padding,
        decoration: decoration,
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              // color: Colors.white,
              borderRadius: borderRadius,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
