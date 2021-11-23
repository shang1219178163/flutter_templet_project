//
//  progresshud.dart
//  fluttertemplet
//
//  Created by shang on 7/29/21 10:08 AM.
//  Copyright © 7/29/21 shang. All rights reserved.
//


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum NNProgressHUDType {
  /// 成功
  success,

  /// 失败
  error,

  /// 加载中
  loading,

  /// 仅文字提示
  toast,
}


class NNProgressHUD {

  static showLoading(BuildContext context, {String? message}) {
    if (message != null) {
      _show(NNProgressHUDType.loading, context, message: message);
    } else {
      _show(NNProgressHUDType.loading, context);
    }
  }

  static showSuccess(BuildContext context, {String? message}) async {
    if (message != null) {
      _show(NNProgressHUDType.success, context, message: message);
    } else {
      _show(NNProgressHUDType.success, context);
    }
    dismiss(context, delay: 2);
  }

  static showError(BuildContext context, {String? message}) {
    if (message != null) {
      _show(NNProgressHUDType.error, context, message: message);
    } else {
      _show(NNProgressHUDType.error, context);
    }
    dismiss(context, delay: 2);
  }

  static showToast(BuildContext context, {String? message}) {
    if (message != null) {
      _show(NNProgressHUDType.toast, context, message: message);
    } else {
      _show(NNProgressHUDType.toast, context);
    }
    dismiss(context, delay: 2);
  }

  static _show(NNProgressHUDType type, BuildContext context, {String? message}) {
    Navigator.push(context,
        ProgressHUD(
            barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
            message: message,
            progressType: type)
    );
  }

  static dismiss(BuildContext context, {int delay = 0}) {
    Future.delayed(Duration(seconds: delay), () {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    });
  }
}

class ProgressHUD<T> extends PopupRoute<T> {
  String? message;
  NNProgressHUDType progressType;

  ProgressHUD({required this.barrierLabel, required this.message, required this.progressType});

  @override
  Color? get barrierColor => null;

  @override
  Duration get transitionDuration => Duration(seconds: 1);

  @override
  bool get barrierDismissible => false;

  @override
  String barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    Size size = this.progressType == NNProgressHUDType.toast ? Size(MediaQuery.of(context).size.width - 60, 60) : Size(120, 120);
    return Center(
      child: Container(
        width: size.width,
        height: size.height,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  color: Colors.black54),
            ),
            getProgressHUDWidget()
          ],
        ),
      ),
    );
  }

  Widget getProgressHUDWidget() {
    double iconSize = 50;
    Widget? icon;
    switch (this.progressType) {
      case NNProgressHUDType.success:
        icon = Icon(Icons.check, color: Colors.white, size: iconSize);
        break;
      case NNProgressHUDType.error:
        icon = Icon(Icons.close, color: Colors.white, size: iconSize);
        break;
      case NNProgressHUDType.loading:
        icon = CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        );
        break;
    }

    if (this.progressType == NNProgressHUDType.toast) {
      assert(message != null);
      return Padding(
        padding: EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 5),
        child: Text(this.message!,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.none)
        )
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        if (icon != null) icon,
        if (message != null) Padding(
          padding: EdgeInsets.only(left: 5.0, right: 5.0),
          child: Text(this.message!,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.none)))
      ],
    );
  }
}
