//
//  LogUtil.dart
//  flutter_templet_project
//
//  Created by shang on 2023/10/16 09:40.
//  Copyright © 2023/10/16 shang. All rights reserved.
//

import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// 自定义打印方法
void debugLog(dynamic obj){
  DebugLog.d(obj);
}


class DebugLog {

  // /// 防止日志被截断
  // static void d(String text) {
  //   if (!kDebugMode) {
  //     return;
  //   }
  //   developer.log("${DateTime.now()} $text");
  //
  //   // final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  //   // pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
  // }


  /// 防止日志被截断
  static void d(dynamic obj) {
    if (!kDebugMode) {
      return;
    }
    developer.log("${DateTime.now()} $obj");
  }
}


