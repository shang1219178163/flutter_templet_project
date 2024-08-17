//
//  after_layout_builder.dart
//  flutter_templet_project
//
//  Created by shang on 2023/1/12 23:29.
//  Copyright © 2023/1/12 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

typedef AfterLayoutWidgetBuilder = Widget Function(
    BuildContext context, Widget? child, Size? size);

/// 获取布局尺寸
class AfterLayoutBuilder extends StatefulWidget {
  const AfterLayoutBuilder({
    Key? key,
    this.child,
    required this.builder,
  }) : super(key: key);

  final AfterLayoutWidgetBuilder builder;

  final Widget? child;

  @override
  _AfterLayoutBuilderState createState() => _AfterLayoutBuilderState();
}

class _AfterLayoutBuilderState extends State<AfterLayoutBuilder> {
  Size? _currentSize;

  @override
  void initState() {
    // WidgetsBinding.instance?.addPostFrameCallback((timeStamp) { });
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (context.size == null) {
        return;
      }
      _currentSize = context.size;
      if (mounted) setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.child, _currentSize);
  }
}
