//
//  NSplitView.dart
//  flutter_templet_project
//
//  Created by shang on 2024/8/8 19:31.
//  Copyright © 2024/8/8 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class NSplitView extends StatefulWidget {
  const NSplitView({
    super.key,
    this.direction = Axis.horizontal,
    this.dividerWidth = 16,
    this.ratio = 0.5,
    required this.start,
    required this.end,
  });

  final Axis direction;
  final double dividerWidth;
  final double ratio;

  final Widget start;
  final Widget end;

  @override
  State<NSplitView> createState() => _NSplitViewState();
}

class _NSplitViewState extends State<NSplitView> {
  late var direction = widget.direction;
  late var dividerWidth = widget.dividerWidth;

  //from 0-1
  late double ratio = widget.ratio;
  late double _total = 0;

  double get start => ratio * _total;

  double get end => (1 - ratio) * _total;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NSplitView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.direction != oldWidget.direction ||
        widget.dividerWidth != oldWidget.dividerWidth ||
        widget.ratio != oldWidget.ratio) {
      direction = widget.direction;
      dividerWidth = widget.dividerWidth;
      ratio = widget.ratio;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    ratio = ratio.clamp(0, 1.0);
    if (direction == Axis.horizontal) {
      return buildHorizal();
    }
    return buildVertical();
  }

  Widget buildHorizal() {
    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      assert(ratio <= 1 && ratio >= 0);
      if (_total != constraints.maxWidth) {
        _total = constraints.maxWidth - dividerWidth;
      }

      return SizedBox(
        width: constraints.maxWidth,
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            SizedBox(
              width: start,
              child: buildLeft(),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: SizedBox(
                width: dividerWidth,
                height: constraints.maxHeight,
                child: RotationTransition(
                  turns: AlwaysStoppedAnimation(0.25),
                  child: Icon(Icons.drag_handle, size: dividerWidth),
                ),
              ),
              onPanUpdate: (DragUpdateDetails details) {
                ratio += details.delta.dx / _total;
                ratio = ratio.clamp(0, 1.0);
                setState(() {});
              },
            ),
            SizedBox(
              width: end,
              child: buildRight(),
            ),
          ],
        ),
      );
    });
  }

  Widget buildVertical() {
    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      assert(ratio <= 1 && ratio >= 0);
      // if (_totalWidth != constraints.maxHeight) {
      //   _totalWidth = constraints.maxHeight - _dividerWidth;
      // }
      _total = constraints.maxHeight - dividerWidth;

      return SizedBox(
        height: constraints.maxHeight,
        child: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            SizedBox(
              height: start,
              child: buildLeft(),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Container(
                height: dividerWidth,
                width: constraints.maxWidth,
                child: RotationTransition(
                  turns: AlwaysStoppedAnimation(0),
                  child: Icon(Icons.drag_handle, size: dividerWidth),
                ),
              ),
              onPanUpdate: (DragUpdateDetails details) {
                ratio += details.delta.dy / _total;
                ratio = ratio.clamp(0, 1.0);
                setState(() {});
              },
            ),
            SizedBox(
              height: end,
              child: buildRight(),
            ),
          ],
        ),
      );
    });
  }

  Widget buildLeft() {
    return widget.start;
  }

  Widget buildRight() {
    return widget.end;
  }
}
