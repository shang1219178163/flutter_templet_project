//
//  NNetContainer.dart
//  flutter_templet_project
//
//  Created by shang on 3/30/23 10:13 AM.
//  Copyright © 3/30/23 shang. All rights reserved.
//


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/NNet/NNet.dart';

class NNetContainer<T> extends StatefulWidget {

  NNetContainer({
    Key? key,
    this.title,
    required this.valueListenable,
    required this.builder,
    required this.errorBuilder,
    this.cachedChild,
  }) : super(key: key);

  String? title;
  /// 数组响应式
  ValueListenable<T> valueListenable;
  /// 当前容器,一般是列表
  ValueWidgetBuilder<T> builder;
  /// 网络错误占位图
  TransitionBuilder errorBuilder;
  /// 页面有网无网不变的部分
  Widget? cachedChild;


  @override
  _NNetContainerState createState() => _NNetContainerState<T>();
}

class _NNetContainerState<T> extends State<NNetContainer<T>> {


  @override
  Widget build(BuildContext context) {
    return _buildNetListen();
  }

  _buildNetListen() {
    return NNet(
      cachedChild: widget.cachedChild,
      childBuilder: (ctx, child) {

        return ValueListenableBuilder<T>(
          valueListenable: widget.valueListenable,
          builder: widget.builder,
          child: child,
        );
      },
      errorBuilder: widget.errorBuilder,
    );
  }
}


