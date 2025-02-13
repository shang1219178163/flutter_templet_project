//
//  NCustomScrollBehavior.dart
//  flutter_templet_project
//
//  Created by shang on 2025/2/13 09:45.
//  Copyright © 2025/2/13 shang. All rights reserved.
//

import 'dart:ui';

import 'package:flutter/material.dart';

class NCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
