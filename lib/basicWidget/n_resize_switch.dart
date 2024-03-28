//
//  NSizeSwitch.dart
//  flutter_templet_project
//
//  Created by shang on 2024/3/28 14:05.
//  Copyright © 2024/3/28 shang. All rights reserved.
//


import 'package:flutter/cupertino.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';

/// 可设置尺寸的 Switch 组件
class NResizeSwitch extends StatefulWidget {

  NResizeSwitch({
    super.key,
    this.width,
    this.height,
    this.value = false,
    this.onChanged,
    this.child,
  });

  final double? width;

  final double? height;

  final bool value;

  final ValueChanged<bool>? onChanged;
  /// 自定义 Switch
  final Widget? child;

  @override
  State<NResizeSwitch> createState() => _NResizeSwitchState();
}

class _NResizeSwitchState extends State<NResizeSwitch> {

  late bool switchValue = widget.value;

  @override
  void didUpdateWidget(covariant NResizeSwitch oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value ||
        oldWidget.width != widget.width ||
        oldWidget.height != widget.height ||
        oldWidget.onChanged != widget.onChanged ||
        oldWidget.child != widget.child
    ) {
      switchValue = widget.value;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: FittedBox(
        fit: BoxFit.fill,
        child: widget.child ?? CupertinoSwitch(
          activeColor: context.primaryColor,
          value: switchValue,
          onChanged: (value) {
            switchValue = value;
            widget.onChanged?.call(value);
            setState(() {});
          },
        ),
      ),
    );
  }

  
}

