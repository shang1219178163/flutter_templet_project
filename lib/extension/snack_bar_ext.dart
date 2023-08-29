//
//  SnackBarExt.dart
//  flutter_templet_project
//
//  Created by shang on 2023/8/29 20:17.
//  Copyright © 2023/8/29 shang. All rights reserved.
//


import 'package:flutter/material.dart';

extension SnackBarExt<T extends StatefulWidget> on State<T> {

  /// ScaffoldMessengerState
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(context);

  /// 清除 SnackBar
  clearSnackBars() {
    scaffoldMessenger.clearSnackBars();
  }

  /// 隐藏 SnackBar
  hideSnackBar({bool isClear = false}) {
    if (isClear) {
      scaffoldMessenger.clearSnackBars();
    } else {
      scaffoldMessenger.hideCurrentSnackBar();
    }
  }

  /// 展示 SnackBar
  showSnackBar(SnackBar snackBar, {bool isClear = false, bool isReplace = false}) {
    if (isClear) {
      scaffoldMessenger.clearSnackBars();
    }
    if (isReplace) {
      scaffoldMessenger.hideCurrentSnackBar();
    }
    hideSnackBar(isClear: isClear);
    scaffoldMessenger.showSnackBar(snackBar);
  }

  /// 隐藏 MaterialBanner
  hideMaterialBanner({bool isClear = false}) {
    if (isClear) {
      scaffoldMessenger.clearMaterialBanners();
    } else {
      scaffoldMessenger.hideCurrentMaterialBanner();
    }
  }

  /// 清除 MaterialBanner
  clearMaterialBanners() {
    scaffoldMessenger.clearMaterialBanners();
  }

  /// 清除 MaterialBanner 无动画
  removeCurrentMaterialBanner() {
    scaffoldMessenger.removeCurrentMaterialBanner();
  }

  /// 展示 MaterialBanner
  showMaterialBanner(MaterialBanner banner, {bool isClear = false, bool isReplace = false}) {
    if (isClear) {
      scaffoldMessenger.clearMaterialBanners();
    }
    if (isReplace) {
      scaffoldMessenger.hideCurrentMaterialBanner();
    }
    scaffoldMessenger.showMaterialBanner(banner);
  }

}