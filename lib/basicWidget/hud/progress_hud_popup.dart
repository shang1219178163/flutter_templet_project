//
//  progresshud.dart
//  flutter_templet_project
//
//  Created by shang on 7/29/21 10:08 AM.
//  Copyright © 7/29/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';

enum NProgressHUDType {
  /// 成功
  success,

  /// 失败
  error,

  /// 加载中
  loading,

  /// 仅文字提示
  toast,
}

extension ProgressHudPopupExt on ProgressHudPopup {
  static loading(BuildContext context, {String? message}) {
    if (message != null) {
      _show(NProgressHUDType.loading, context, message: message);
    } else {
      _show(NProgressHUDType.loading, context);
    }
  }

  static success(BuildContext context, {String? message}) async {
    if (message != null) {
      _show(NProgressHUDType.success, context, message: message);
    } else {
      _show(NProgressHUDType.success, context);
    }
    dismiss(context, delay: 2);
  }

  static error(BuildContext context, {String? message}) {
    if (message != null) {
      _show(NProgressHUDType.error, context, message: message);
    } else {
      _show(NProgressHUDType.error, context);
    }
    dismiss(context, delay: 2);
  }

  static toast(BuildContext context, {String? message}) {
    if (message != null) {
      _show(NProgressHUDType.toast, context, message: message);
    } else {
      _show(NProgressHUDType.toast, context);
    }
    dismiss(context, delay: 2);
  }

  static _show(NProgressHUDType type, BuildContext context, {String? message}) {
    Navigator.push(
      context,
      ProgressHudPopup(
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        message: message,
        progressType: type,
      ),
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

class ProgressHudPopup<T> extends PopupRoute<T> {
  ProgressHudPopup({
    required this.barrierLabel,
    required this.message,
    required this.progressType,
  });

  String? message;
  NProgressHUDType progressType;

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
    var size =
        progressType == NProgressHUDType.toast ? Size(MediaQuery.of(context).size.width - 60, 60) : Size(120, 120);
    return Center(
      child: Container(
        width: size.width,
        height: size.height,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
                color: Colors.black54,
              ),
            ),
            getProgressHUDWidget()
          ],
        ),
      ),
    );
  }

  Widget getProgressHUDWidget() {
    var iconSize = 50.0;
    Widget? icon;
    switch (progressType) {
      case NProgressHUDType.success:
        icon = Icon(Icons.check, color: Colors.white, size: iconSize);
        break;
      case NProgressHUDType.error:
        icon = Icon(Icons.close, color: Colors.white, size: iconSize);
        break;
      case NProgressHUDType.loading:
        icon = CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        );
        break;
      case NProgressHUDType.toast:
        icon = SizedBox();
        break;
    }

    if (progressType == NProgressHUDType.toast) {
      assert(message != null);
      return Padding(
        padding: EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 5),
        child: Text(
          message!,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.normal,
            decoration: TextDecoration.none,
          ),
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        icon,
        if (message != null)
          Padding(
            padding: EdgeInsets.only(left: 5.0, right: 5.0),
            child: Text(
              message!,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.none,
              ),
            ),
          )
      ],
    );
  }
}
