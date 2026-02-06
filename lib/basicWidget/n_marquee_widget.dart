//
//  MarqueeWidget.dart
//  flutter_templet_project
//
//  Created by shang on 1/18/23 10:48 AM.
//  Copyright © 1/18/23 shang. All rights reserved.
//

import 'dart:async';

import 'package:flutter/material.dart';

/// 跑马灯 Builder 类型
typedef MarqueeWidgetBuilder = Widget Function(BuildContext context, int index, BoxConstraints constraints);

/// 跑马灯
class NMarqueeWidget extends StatefulWidget {
  /// 跑马灯
  NMarqueeWidget({
    Key? key,
    this.title,
    this.controller,
    this.duration = const Duration(milliseconds: 350),
    this.durationOffset = 30,
    required this.itemCount,
    required this.itemBuilder,
    required this.separatorBuilder,
    required this.edgeBuilder,
  }) : super(key: key);

  final String? title;

  final int itemCount;

  /// item builder
  final MarqueeWidgetBuilder itemBuilder;

  /// 边界(前后新增) builder
  final MarqueeWidgetBuilder edgeBuilder;

  /// item 间距 builder
  final MarqueeWidgetBuilder separatorBuilder;

  /// 控制器
  final ScrollController? controller;

  /// 定时器运行间隔
  final Duration? duration;

  /// 定时器运行间隔移动偏移量
  final double? durationOffset;

  @override
  _NMarqueeWidgetState createState() => _NMarqueeWidgetState();
}

class _NMarqueeWidgetState extends State<NMarqueeWidget> {
  late final scrollController = widget.controller ?? ScrollController();

  final _globalKey = GlobalKey();

  // final offset = ValueNotifier(0.0);

  Timer? _timer;

  @override
  void initState() {
    _initTimer();
    super.initState();
  }

  @override
  void dispose() {
    _cancelTimer();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount == 0) {
      return Container();
    }

    final totalCount = widget.itemCount + 2;

    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView.separated(
          key: _globalKey,
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.all(0),
          itemCount: totalCount,
          // cacheExtent: 10,
          itemBuilder: (context, index) {
            // return widget.itemBuilder(context, index, constraints);
            final isEdge = (index == 0 || index == totalCount - 1);
            if (isEdge) {
              return widget.edgeBuilder(context, index, constraints);
            }
            return widget.itemBuilder(context, index - 1, constraints);
          },
          separatorBuilder: (context, index) {
            if (index == 0 || index == totalCount - 2) {
              return Container();
            }
            return widget.separatorBuilder(context, index, constraints);
          },
        );
      },
    );
  }

  /// 取消定时器
  _cancelTimer({bool isContinue = false}) {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
      if (isContinue) {
        _initTimer();
      }
    }
  }

  /// 初始化定时任务
  _initTimer() {
    if (_timer == null) {
      final duration = widget.duration ?? Duration(milliseconds: 350);
      _timer = Timer.periodic(duration, (t) {
        final val = scrollController.offset + (widget.durationOffset ?? 30);
        scrollController.animateTo(val, duration: duration, curve: Curves.linear);
        if (scrollController.position.outOfRange) {
          // print("atEdge:到边界了");
          scrollController.jumpTo(0);
        }
      });
    }
  }
}
