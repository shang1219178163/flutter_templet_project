import 'dart:async';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';


// void _init() async {
//   await ViewUtil.initFinish();
//   ///下面可以使用加载弹窗
// }


class ViewUtil {
  ///界面初始化完成
  static Future<Void> initFinish() async {
    Completer<Void> completer = Completer();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      completer.complete();
    });

    return completer.future;
  }
}