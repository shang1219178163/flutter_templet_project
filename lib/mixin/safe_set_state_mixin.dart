//
//  SafeSetStateMixin.dart
//  flutter_templet_project
//
//  Created by shang on 2024/2/22 14:26.
//  Copyright © 2024/2/22 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 重写方法,避免页面退出之后方法 调用导致的问题
mixin SafeSetStateMixin<T extends StatefulWidget> on State<T> {
  /// 重写方法,避免页面退出之后调用导致的问题
  @override
  void setState(VoidCallback fn) {
    if (!mounted) {
      return;
    }
    super.setState(fn);
  }
}
