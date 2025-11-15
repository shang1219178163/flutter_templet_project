//
//  DraggableFloatingButtonDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/11/21 12:01.
//  Copyright © 2024/11/21 shang. All rights reserved.
//

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_app_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_cross_fade.dart';
import 'package:flutter_templet_project/basicWidget/n_menu_anchor.dart';

import 'package:flutter_templet_project/mixin/floating_button_mixin.dart';
import 'package:get/get.dart';

/// 通过 FloatingButtonMixin 实现悬浮按钮
class FloatingButtonDemo extends StatefulWidget {
  const FloatingButtonDemo({super.key});

  @override
  _FloatingButtonDemoState createState() => _FloatingButtonDemoState();
}

class _FloatingButtonDemoState extends State<FloatingButtonDemo> with FloatingButtonMixin {
  Alignment topAlignment = Alignment.topCenter;

  var _isExpanded = false;

  @override
  void dispose() {
    DLog.d("$widget dispose");
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    DLog.d("$widget initState");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      insertOverlayEntry(0, buildOverlayEntry());
    });
  }

  @override
  FloatingButtonConfig get floatingButtonConfig {
    return super.floatingButtonConfig.copyWith(
          globalPosition: Offset(context.screenWidth, context.screenHeight - kBottomNavigationBarHeight - 68),
          buttonSize: Size(52, 68),
          button: (onToggle) => GestureDetector(onTap: onToggle, child: buildFirst(childSize: Size(52, 68))),
          expandedButtonSize: Size(200, 90),
          expandedButton: (onToggle) => GestureDetector(onTap: onToggle, child: buildSecond(childSize: Size(200, 90))),
          // draggable: false,
          onChanged: (v) {
            DLog.d("onChanged: $v");
          },
        );

    return super.floatingButtonConfig.copyWith(
          button: (onToggle) => Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: Icon(
                Icons.circle_notifications_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          expandedButtonSize: Size(120, 60),
        );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: NAppBar(
          title: Text("$widget"),
          onBack: () {
            floatingButtonHide();
            Get.back();
          },
        ),
        body: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NMenuAnchor(
              values: AlignmentExt.allCases,
              initialItem: topAlignment,
              onChanged: (val) {
                DLog.d(val);
                topAlignment = val;
                hideOverlayEntry(0);
                insertOverlayEntry(0, buildOverlayEntry(alignment: topAlignment));
              },
              cbName: (e) => "$e",
              equal: (a, b) => a == b,
            ),
            OutlinedButton(
              onPressed: () {
                floatingButtonToggle();
                setState(() {});
              },
              child: Text(isFloatingButtonShow ? "hide" : "show"),
            ),
          ].map((e) => Padding(padding: EdgeInsets.symmetric(vertical: 4), child: e)).toList(),
        ),
      ),
    );
  }

  Widget buildFirst({VoidCallback? onTap, bool isLeft = true, required Size childSize}) {
    return Image(
      image: "assets/images/rec_left_flot_btn.gif".toAssetImage(),
      width: childSize.width,
      height: childSize.height,
    );
  }

  Widget buildSecond({VoidCallback? onTap, bool isLeft = true, required Size childSize}) {
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

    return Stack(
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
    );
  }

  OverlayEntry buildOverlayEntry({Alignment alignment = Alignment.topCenter}) {
    return OverlayEntry(
      builder: (context) => Positioned(
        top: floatingButtonConfig.buttonMargin.top,
        left: 0,
        right: 0,
        bottom: floatingButtonConfig.buttonMargin.bottom,
        child: Align(
          alignment: alignment,
          child: buildNCrossFade(),
          // child: StatefulBuilder(
          //   builder: (BuildContext context, StateSetter setState) {
          //     /// 展开收起
          //     onToggle() {
          //       _isExpanded = !_isExpanded;
          //       DLog.d("onToggle $_isExpanded");
          //       setState(() {});
          //     }
          //
          //     return AnimatedCrossFade(
          //       duration: const Duration(milliseconds: 350),
          //       firstChild: InkWell(
          //         onTap: onToggle,
          //         child: Container(
          //           height: 100,
          //           width: 200,
          //           decoration: BoxDecoration(
          //             color: Colors.green,
          //             border: Border.all(color: Colors.blue),
          //           ),
          //         ),
          //       ),
          //       secondChild: InkWell(
          //         onTap: onToggle,
          //         child: Container(
          //           height: 200,
          //           width: 100,
          //           decoration: BoxDecoration(
          //             color: Colors.yellow,
          //             border: Border.all(color: Colors.blue),
          //           ),
          //         ),
          //       ),
          //       crossFadeState: !_isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          //     );
          //   },
          // ),
        ),
      ),
    );
  }

  /// 展开收起
  onToggle() {
    _isExpanded = !_isExpanded;
    setState(() {});
  }

  Widget buildNCrossFade() {
    return NCrossFade(
      isFirst: true,
      onChanged: (v) {
        DLog.d("onChanged: $v");
      },
      firstChild: (onToggle) => Container(
        height: 200,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.yellow,
          border: Border.all(color: Colors.blue),
        ),
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              DLog.d("视图2");
              onToggle();
            },
            child: Text("视图2"),
          ),
        ),
      ),
      secondChild: (onToggle) => Container(
        height: 100,
        width: 200,
        decoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(color: Colors.blue),
        ),
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              DLog.d("视图1");
              onToggle();
            },
            child: Text("视图1"),
          ),
        ),
      ),
    );
  }
}

/// 旋风拖拽按钮
class NFloatingButtonTest extends StatefulWidget {
  const NFloatingButtonTest({
    super.key,
    this.isLeft = true,
    required this.childSize,
  });

  final bool isLeft;
  final Size childSize;

  @override
  State<NFloatingButtonTest> createState() => _NFloatingButtonTestState();
}

class _NFloatingButtonTestState extends State<NFloatingButtonTest> {
  @override
  void didUpdateWidget(covariant NFloatingButtonTest oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLeft != widget.isLeft || oldWidget.childSize != widget.childSize) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
      ),
      child: buildToggle(
        isLeft: widget.isLeft,
        childSize: widget.childSize,
      ),
    );
  }

  AnimatedCrossFade buildToggle({bool isLeft = true, required Size childSize}) {
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: Matrix4.rotationY(isLeft ? 2 * pi : pi),
          transformAlignment: Alignment.center,
          // transformAlignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
          child: Image(
            image: "assets/images/rec_left_flot_btn.gif".toAssetImage(),
            width: childSize.width,
            height: childSize.height,
            alignment: !isLeft ? Alignment.centerLeft : Alignment.centerRight,
          ),
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
      crossFadeState: !_isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }

  var _isExpanded = false;

  /// 展开收起
  onToggle() {
    _isExpanded = !_isExpanded;
    setState(() {});
  }
}
