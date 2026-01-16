//
//  CustomPageViewScrollPhysics.dart
//  flutter_templet_project
//
//  Created by shang on 2025/2/5 15:52.
//  Copyright © 2025/2/5 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 自定义滚动行为
class CustomPageViewScrollPhysics extends ScrollPhysics {
  const CustomPageViewScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  CustomPageViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPageViewScrollPhysics(parent: buildParent(ancestor)!);
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 50,
        stiffness: 100,
        damping: 0.8,
      );
}
