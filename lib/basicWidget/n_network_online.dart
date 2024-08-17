//
//  NNetworkState.dart
//  flutter_templet_project
//
//  Created by shang on 3/30/23 9:46 AM.
//  Copyright © 3/30/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/service/connectivity_service.dart';

/// 网络状态组件
class NNetworkOnLine extends StatefulWidget {
  const NNetworkOnLine({
    super.key,
    this.onLine,
    this.cachedChild,
    required this.builder,
    required this.offlineBuilder,
  });

  /// 在线/离线状态值
  final ValueNotifier<bool>? onLine;

  /// ValueListenableBuilder 缓存的 child
  final Widget? cachedChild;

  /// child 构造器
  final TransitionBuilder builder;

  /// 离线
  final TransitionBuilder offlineBuilder;

  @override
  _NNetworkOnLineState createState() => _NNetworkOnLineState();
}

class _NNetworkOnLineState extends State<NNetworkOnLine> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.onLine ?? ConnectivityService().onLine,
      child: widget.cachedChild,
      builder: (context, value, child) {
        // debugPrint('ValueListenableBuilder: $value');
        if (!value) {
          return widget.offlineBuilder(context, child);
        }
        return widget.builder(context, child);
      },
    );
  }
}
