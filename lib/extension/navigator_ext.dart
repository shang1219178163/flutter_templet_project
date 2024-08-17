//
//  NavigatorExt.dart
//  flutter_templet_project
//
//  Created by shang on 2023/8/29 20:18.
//  Copyright © 2023/8/29 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';

extension NavigatorExt on Navigator {
  // @optionalTypeArgs
  // static void popPage<T extends Object?>(BuildContext context, [ T? result ]) {
  //   if (!Navigator.canPop(context)) {
  //     ddlog("已经是根页面了！");
  //     return;
  //   }
  //   Navigator.of(context).pop<T>(result);
  // }
}
