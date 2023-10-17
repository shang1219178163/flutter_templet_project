//
//  LogUtil.dart
//  flutter_templet_project
//
//  Created by shang on 2023/10/16 09:40.
//  Copyright © 2023/10/16 shang. All rights reserved.
//


import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// 防止日志被截断
void printWrapped(String text) {
  if (!kDebugMode) {
    return;
  }
  developer.log(text);

  // final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  // pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
}
