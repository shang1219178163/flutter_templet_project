import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';


// EasyLoading toast
class EasyToast {
  // toast
  static void showToast(
    String text, {
      int milliseconds = 1500,
      VoidCallback? cb,
      bool needLogin = false,
  }) {
    if (text.isEmpty) {
      return;
    }

    final duration = Duration(milliseconds: milliseconds);
    EasyLoading.showToast(
      text,
      duration: duration,
    );
    Future.delayed(duration, cb);
  }

  // toast - 错误
  static void showInfo(
    String text, {
      int milliseconds = 1500,
      VoidCallback? cb,
      bool needLogin = false,
  }) {
    if (text.isEmpty) {
      return;
    }

    final duration = Duration(milliseconds: milliseconds);
    EasyLoading.showInfo(
      text,
      duration: duration,
    );
    Future.delayed(duration, cb);
  }

  // toast - 成功
  static void showSuccess(
    String text, {
    int milliseconds = 2000,
    VoidCallback? cb,
  }) {
    if (text.isEmpty) {
      return;
    }

    final duration = Duration(milliseconds: milliseconds);
    EasyLoading.showSuccess(
      text,
      duration: duration,
    );
    Future.delayed(duration, cb);
  }

  // loading - 加载
  static void showLoading(String content, {
    Widget? indicator,
  }) {
    if (content.isEmpty) {
      return;
    }

    EasyLoading.show(
      status: content,
      indicator: indicator,
      maskType: EasyLoadingMaskType.black,
    );
  }

  // loading - 关闭
  static void hideLoading() {
    EasyLoading.dismiss();
  }
}
