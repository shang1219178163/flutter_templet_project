//
//  SuspensionButtonDemoNew.dart
//  flutter_templet_project
//
//  Created by shang on 2024/11/21 11:16.
//  Copyright © 2024/11/21 shang. All rights reserved.
//

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';

/// 非展开组件支持 Y 轴翻转
class FloatingButtonDemoThree extends StatefulWidget {
  const FloatingButtonDemoThree({
    super.key,
    this.title,
  });

  final String? title;

  @override
  State<FloatingButtonDemoThree> createState() => _FloatingButtonDemoThreeState();
}

class _FloatingButtonDemoThreeState extends State<FloatingButtonDemoThree> {
  final _topVN = ValueNotifier(0.0);
  final _leftVN = ValueNotifier(0.0);
  final _rightVN = ValueNotifier(0.0);

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: buildBody(),
      ),
    );
  }

  buildBody() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildFloatingButton(
              onPanStart: (e) {
                // onToggle();
              },
              bgChild: Container(
                color: Colors.green.withOpacity(0.5),
                height: 200,
                width: double.infinity,
              ),
              child: ValueListenableBuilder(
                valueListenable: _leftVN,
                builder: (context, value, child) {
                  final isLeft = value < MediaQuery.of(context).size.width / 2;
                  return buildToggle(isLeft: isLeft, childSize: Size(52, 68));
                },
              ),
              childSize: Size(52, 68),
              expandChildSize: Size(200, 90),
            ),
          ],
        ),
      ),
    );
  }

  /// 创建悬浮按钮
  buildFloatingButton({
    GestureDragStartCallback? onPanStart,
    GestureDragEndCallback? onPanEnd,
    EdgeInsets padding = const EdgeInsets.only(
      left: 10,
      top: 10,
      right: 10,
      bottom: 10,
    ),
    required Widget bgChild,
    required Widget child,
    required Size childSize,
    required Size expandChildSize,
    bool attachHorizalEdge = true,
    bool attachVerticalEdge = false,
    bool rotationY = true,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;
        final midX = _leftVN.value + childSize.width / 2;
        var isLeft = midX < maxWidth * 0.5;

        return Stack(
          children: [
            Container(
              constraints: constraints,
              child: bgChild,
            ),
            AnimatedBuilder(
              animation: Listenable.merge([
                _topVN,
                _leftVN,
                _rightVN,
              ]),
              // child: child,
              builder: (context, c) {
                return Positioned(
                  top: _topVN.value,
                  left: isLeft ? _leftVN.value : null,
                  right: !isLeft ? _rightVN.value : null,
                  child: GestureDetector(
                    onPanStart: (d) {
                      isLeft = d.globalPosition.dx < maxWidth * 0.5;
                      // DLog.d("onPanStart isLeft: $isLeft, $d");
                    },
                    onPanUpdate: (DragUpdateDetails e) {
                      // debugPrint("e.delta:${e.delta.dx},${e.delta.dy}");

                      //用户手指滑动时，更新偏移，重新构建
                      //顶部
                      if (_topVN.value < padding.top && e.delta.dy < 0) {
                        return;
                      }
                      // 左边
                      if (_leftVN.value < padding.left && e.delta.dx < 0) {
                        return;
                      }
                      // 右边
                      if (_topVN.value > (maxHeight - childSize.height - padding.bottom) && e.delta.dy > 0) {
                        return;
                      }
                      // 下边
                      if (_leftVN.value > (maxWidth - childSize.width - padding.right) && e.delta.dx > 0) {
                        return;
                      }
                      _topVN.value += e.delta.dy;
                      _leftVN.value += e.delta.dx;
                      _rightVN.value = maxWidth - _leftVN.value - childSize.width;
                      // debugPrint("xy:${_topVN.value},${_leftVN.value},${_rightVN.value}");
                    },
                    onPanEnd: (DragEndDetails e) {
                      // debugPrint("_leftVN.value:${_leftVN.value}");
                      final midX = _leftVN.value + childSize.width / 2;
                      final midY = _topVN.value + childSize.height / 2;

                      if (attachHorizalEdge) {
                        if (midX < maxWidth * 0.5) {
                          _leftVN.value = padding.left;
                        } else {
                          _leftVN.value = maxWidth - childSize.width - padding.right;
                        }
                        _rightVN.value = maxWidth - _leftVN.value - childSize.width;
                      }

                      final isLeftTmp = midX < maxWidth * 0.5;

                      var radians = isLeftTmp != isLeft ? pi : 0.0;
                      DLog.d("isLeft: $isLeft, isLeftTmp: $isLeftTmp, $radians");
                      if (rotationY) {
                        if (!isExpanded) {
                          child = AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            transform: Matrix4.rotationY(radians),
                            transformAlignment: Alignment.center,
                            alignment: isLeftTmp ? Alignment.centerLeft : Alignment.centerRight,
                            child: child,
                          );
                        }

                        if (isExpanded) {
                          onToggle();
                        }
                      }
                      onPanEnd?.call(e);
                    },
                    child: child,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  /// 两种形态切换
  Widget buildToggle({bool isLeft = true, required Size childSize}) {
    Widget bom = FittedBox(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Image(
              image: "assets/images/icon_again_shopping_cart.png".toAssetImage(),
              width: 27,
              height: 27,
            ),
          ),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "测试用药",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Flexible(
                  child: Text(
                    "药品b(1片*1板/盒),心安宁...",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 350),
      firstChild: InkWell(
        onTap: onToggle,
        child: Image(
          image: "assets/images/rec_left_flot_btn.gif".toAssetImage(),
          width: childSize.width,
          height: childSize.height,
        ),
      ),
      secondChild: InkWell(
        onTap: onToggle,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 44),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                // color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [primaryColor.withOpacity(.35), primaryColor.withOpacity(.7)],
                ),
              ),
              child: bom,
            ),
            Positioned(
              top: 15,
              left: 40,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  // border: Border.all(color: Colors.blue),
                ),
                child: Image(
                  image: "assets/images/icon_rec_cat.png".toAssetImage(),
                  width: 45,
                  height: 40,
                ),
              ),
            ),
          ],
        ),
      ),
      crossFadeState: !isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }

  /// 展开收起
  onToggle() {
    isExpanded = !isExpanded;
    setState(() {});
  }
}
