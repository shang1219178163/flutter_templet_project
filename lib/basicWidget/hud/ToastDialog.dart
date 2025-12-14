// import 'dart:ffi';

import 'package:flutter/material.dart';

//loading加载框
@Deprecated("已弃用")
class ToastDialog extends Dialog {
  const ToastDialog({
    Key? key,
    this.loadingView,
    this.message = "加载中...",
    this.messageMargin = const EdgeInsets.only(left: 20, right: 20),
    this.radius = 10,
  })  : assert((loadingView != null || message != null)),
        super(key: key);

  //loading动画
  final Widget? loadingView;
  //提示内容
  final String? message;
  final EdgeInsets? messageMargin;

  //圆角大小
  final double? radius;

  ///展示
  static void show({
    required BuildContext context,
    Widget? loadingView,
    String? message,
    EdgeInsets? messageMargin,
    double? radius,
    Color? backgroundColor,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return ToastDialog(
          loadingView: loadingView,
          message: message,
          messageMargin: messageMargin,
          radius: radius,
          // backgroundColor: backgroundColor,
        );
      },
    );
  }

  ///退出
  static void dismiss({required BuildContext context}) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (loadingView != null && message != null) {
      return buildProgressIndicatorAndText(
        loadingView: loadingView,
        message: message ?? "异常提示",
        backgroundColor: backgroundColor ?? Colors.black54,
        radius: radius ?? 10,
      );
    }

    if (loadingView != null) {
      return buildProgressIndicator(
        loadingView: loadingView,
        backgroundColor: backgroundColor ?? Colors.black54,
        radius: radius ?? 10,
      );
    }

    return buildMessage(
      message: message ?? "异常提示",
      backgroundColor: backgroundColor ?? Colors.black54,
    );
  }

  Decoration buildDecoration({Color? backgroundColor, required double radius}) {
    return ShapeDecoration(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(radius),
        ),
      ),
    );
  }

  Widget buildProgressIndicator({
    Widget? loadingView,
    required Color backgroundColor,
    required double radius,
  }) {
    return Center(
      child: Container(
        height: 90,
        width: 90,
        // color: Colors.black,
        decoration: buildDecoration(backgroundColor: backgroundColor, radius: radius),
        child: loadingView ??
            Container(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(),
            ),
      ),
    );
  }

  Widget buildMessage({required String message, required Color backgroundColor}) {
    return Center(
      widthFactor: 1,
      heightFactor: 1,
      child: Container(
        margin: messageMargin ?? EdgeInsets.only(left: 20, right: 20),
        padding: EdgeInsets.all(8),
        // color: Colors.black,
        decoration: buildDecoration(backgroundColor: backgroundColor, radius: 4),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.normal,
            decoration: TextDecoration.none,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildProgressIndicatorAndText({
    Widget? loadingView,
    required String message,
    required Color backgroundColor,
    required double radius,
  }) {
    return Center(
      // widthFactor: 1,
      // heightFactor: 1,
      child: Container(
        margin: messageMargin ?? EdgeInsets.only(left: 20, right: 20),
        padding: EdgeInsets.all(8),
        decoration: buildDecoration(backgroundColor: backgroundColor, radius: radius),
        // child: Container(child: CircularProgressIndicator(), padding: EdgeInsets.all(12),),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 90,
              width: 90,
              child: loadingView ??
                  Container(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(),
                  ),
            ),
            Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
