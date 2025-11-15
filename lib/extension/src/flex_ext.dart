//
//  FlexExt.dart
//  flutter_templet_project
//
//  Created by shang on 2023/8/29 20:17.
//  Copyright © 2023/8/29 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter_templet_project/extension/src/widget_ext.dart';

extension FlexExt on Flex {
  /// 自定义方法
  Flex copy({
    Key? key,
    Axis? direction,
    MainAxisAlignment? mainAxisAlignment,
    MainAxisSize? mainAxisSize,
    CrossAxisAlignment? crossAxisAlignment,
    TextDirection? textDirection,
    VerticalDirection? verticalDirection,
    TextBaseline? textBaseline,
    Clip? clipBehavior,
    List<Widget>? children,
  }) {
    return Flex(
      key: key ?? this.key,
      direction: direction ?? this.direction,
      mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
      mainAxisSize: mainAxisSize ?? this.mainAxisSize,
      crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
      textDirection: textDirection ?? this.textDirection,
      verticalDirection: verticalDirection ?? this.verticalDirection,
      textBaseline: textBaseline ?? this.textBaseline,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      children: children ?? this.children,
    );
  }

  /// 转为 SliverToBoxAdapter
  CustomScrollView toCustomScrollView({
    Key? key,
    Widget Function(Widget e)? itemBuilder,
  }) =>
      CustomScrollView(
        key: key,
        slivers: children.map((e) => itemBuilder?.call(e) ?? e.toSliverToBoxAdapter()).toList(),
        clipBehavior: clipBehavior,
      );
}
