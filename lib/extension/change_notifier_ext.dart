//
//  ChangeNotifierExt.dart
//  flutter_templet_project
//
//  Created by shang on 3/10/23 5:38 PM.
//  Copyright © 3/10/23 shang. All rights reserved.
//


import 'package:flutter/cupertino.dart';

extension ObjectExt<T> on Object{
  /// 获取
  ValueNotifier get vn => ValueNotifier(this);
}