//
//  ActivityType.dart
//  flutter_templet_project
//
//  Created by shang on 2024/1/18 11:07.
//  Copyright © 2024/1/18 shang. All rights reserved.
//

import 'package:flutter/foundation.dart';

/// app运行模式
enum AppRunMode {
  releaseMode(-0, 'Release 模式'),

  profileMode(1, 'Profile 模式'),

  debugMode(2, 'Debug 模式'),
  ;

  const AppRunMode(
    this.value,
    this.desc,
  );

  /// 当前枚举值对应的 int 值(非 index)
  final int value;

  /// 当前枚举对应的 描述文字
  final String desc;

  /// 当前模式
  AppRunMode get current {
    if (kReleaseMode) {
      return AppRunMode.releaseMode;
    }

    if (kProfileMode) {
      return AppRunMode.profileMode;
    }

    if (kDebugMode) {
      return AppRunMode.debugMode;
    }
    return AppRunMode.releaseMode;
  }

  @override
  String toString() {
    return '$desc is $value';
  }
}
