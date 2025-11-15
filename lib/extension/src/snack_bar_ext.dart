//
//  SnackBarExt.dart
//  flutter_templet_project
//
//  Created by shang on 2023/8/29 20:17.
//  Copyright © 2023/8/29 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

final List<Widget> _snackBars = [];

extension SnackBarExt<T extends StatefulWidget> on State<T> {
  /// ScaffoldMessengerState
  ScaffoldMessengerState get scaffoldMessenger =>
      ScaffoldMessenger.of(Get.context ?? context);

  /// 当前 snackBar 堆栈
  List<Widget> get snackBars => _snackBars;

  /// 清除 SnackBar
  clearSnackBars() {
    scaffoldMessenger.clearSnackBars();
    _snackBars.clear();
  }

  /// 隐藏 SnackBar
  hideSnackBar({bool isClear = false}) {
    if (isClear) {
      scaffoldMessenger.clearSnackBars();
      _snackBars.clear();
    } else {
      scaffoldMessenger.hideCurrentSnackBar();
      if (_snackBars.isNotEmpty) {
        _snackBars.removeLast();
      }
    }
  }

  /// 展示 SnackBar
  showSnackBar(
    SnackBar snackBar, {
    bool isClear = false,
    bool isReplace = false,
  }) {
    if (isClear) {
      scaffoldMessenger.clearSnackBars();
      _snackBars.clear();
    }
    if (isReplace) {
      scaffoldMessenger.hideCurrentSnackBar();
      _snackBars.removeLast();
    }
    hideSnackBar(isClear: isClear);
    scaffoldMessenger.showSnackBar(snackBar);
    _snackBars.add(snackBar);
  }

  /// 隐藏 MaterialBanner
  hideMaterialBanner({bool isClear = false}) {
    if (isClear) {
      scaffoldMessenger.clearMaterialBanners();
      _snackBars.clear();
    } else {
      scaffoldMessenger.hideCurrentMaterialBanner();
      _snackBars.removeLast();
    }
  }

  /// 清除 MaterialBanner
  clearMaterialBanners() {
    scaffoldMessenger.clearMaterialBanners();
    _snackBars.clear();
  }

  /// 清除 MaterialBanner 无动画
  removeCurrentMaterialBanner() {
    scaffoldMessenger.removeCurrentMaterialBanner();
    _snackBars.removeLast();
  }

  /// 展示 MaterialBanner
  showMaterialBanner(
    MaterialBanner banner, {
    bool isClear = false,
    bool isReplace = false,
  }) {
    if (isClear) {
      scaffoldMessenger.clearMaterialBanners();
      _snackBars.clear();
    }
    if (isReplace) {
      scaffoldMessenger.hideCurrentMaterialBanner();
      _snackBars.removeLast();
    }
    scaffoldMessenger.showMaterialBanner(banner);
    _snackBars.add(banner);
  }
}
