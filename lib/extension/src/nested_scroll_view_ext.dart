//
//  NestedScrollViewExt.dart
//  flutter_templet_project
//
//  Created by shang on 2026/2/2 10:10.
//  Copyright © 2026/2/2 shang. All rights reserved.
//

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

extension NestedScrollViewExt on NestedScrollView {
  /// 自定义 copyWith
  NestedScrollView copyWith({
    ScrollController? controller,
    Axis? scrollDirection,
    bool? reverse,
    ScrollPhysics? physics,
    NestedScrollViewHeaderSliversBuilder? headerSliverBuilder,
    Widget? body,
    DragStartBehavior? dragStartBehavior,
    bool? floatHeaderSlivers,
    Clip? clipBehavior,
    HitTestBehavior? hitTestBehavior,
    String? restorationId,
    ScrollBehavior? scrollBehavior,
  }) {
    return NestedScrollView(
      controller: controller ?? this.controller,
      scrollDirection: scrollDirection ?? this.scrollDirection,
      reverse: reverse ?? this.reverse,
      physics: physics ?? this.physics,
      headerSliverBuilder: headerSliverBuilder ?? this.headerSliverBuilder,
      body: body ?? this.body,
      dragStartBehavior: dragStartBehavior ?? this.dragStartBehavior,
      floatHeaderSlivers: floatHeaderSlivers ?? this.floatHeaderSlivers,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      hitTestBehavior: hitTestBehavior ?? this.hitTestBehavior,
      restorationId: restorationId ?? this.restorationId,
      scrollBehavior: scrollBehavior ?? this.scrollBehavior,
    );
  }
}
