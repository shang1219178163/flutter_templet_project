//
//  ChangeNotifierExt.dart
//  flutter_templet_project
//
//  Created by shang on 3/10/23 5:38 PM.
//  Copyright © 3/10/23 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';

extension ObjectVN on Object {
  /// 获取
  ValueNotifier get vn => ValueNotifier(this);
}

extension BoolVN on bool {
  /// 获取
  ValueNotifier<bool> get vn => ValueNotifier<bool>(this);
}

extension NumVN on num {
  /// 获取
  ValueNotifier get vn => ValueNotifier<num>(this);
}

extension StringVN on String {
  /// 获取
  ValueNotifier get vn => ValueNotifier<String>(this);
}

extension ValueNotifierListExt on ValueNotifier<List> {
  /// 更新
  void update() {
    value = [...value];
  }
}
