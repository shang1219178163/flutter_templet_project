//
//  SystemChannelsExt.dart
//  flutter_templet_project
//
//  Created by shang on 2024/12/18 16:24.
//  Copyright © 2024/12/18 shang. All rights reserved.
//

import 'package:flutter/services.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

extension SystemChannelsExt on SystemChannels {
  /// 键盘展示
  Future<T?> textInputShow<T>() {
    return SystemChannels.textInput.invokeMethod<T>('TextInput.show');
  }

  /// 键盘隐藏
  Future<T?> textInputHide<T>() {
    return SystemChannels.textInput.invokeMethod<T>('TextInput.hide');
  }
}
