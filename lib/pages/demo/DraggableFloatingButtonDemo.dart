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
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/mixin/draggable_floating_button_mixin.dart';
import 'package:get/get.dart';

class DraggableFloatingButtonDemo extends StatefulWidget {
  const DraggableFloatingButtonDemo({super.key});

  @override
  _DraggableFloatingButtonDemoState createState() => _DraggableFloatingButtonDemoState();
}

class _DraggableFloatingButtonDemoState extends State<DraggableFloatingButtonDemo> with DraggableFloatingButtonMixin {
  @override
  void dispose() {
    DLog.d("$widget dispose");
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    DLog.d("$widget initState");
  }

  @override
  DraggableFloatingButtonConfig get draggableFloatingButtonConfig {
    return super.draggableFloatingButtonConfig.copyWith(
          // globalPosition: Offset(dx, dy),
          buttonSize: Size(52, 68),
          button: buildFirst(childSize: Size(52, 68)),
          expandedButtonSize: Size(200, 90),
          expandedButton: buildSecond(childSize: Size(200, 90)),
          onButton: () {
            DLog.d("onButton");
          },
        );

    return super.draggableFloatingButtonConfig.copyWith(
          button: Material(
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
            OutlinedButton(
              onPressed: () {
                floatingButtonToggle();
              },
              child: Text(isFloatingButtonShow ? "hide" : "show"),
            ),
          ],
        ),
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
          child: Image(
            image: "assets/images/rec_left_flot_btn.gif".toAssetImage(),
            width: childSize.width,
            height: childSize.height,
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

  Widget buildFirst({VoidCallback? onTap, bool isLeft = true, required Size childSize}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      transform: Matrix4.rotationY(isLeft ? 2 * pi : pi),
      transformAlignment: Alignment.center,
      child: Image(
        image: "assets/images/rec_left_flot_btn.gif".toAssetImage(),
        width: childSize.width,
        height: childSize.height,
      ),
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

  var _isExpanded = false;

  /// 展开收起
  onToggle() {
    _isExpanded = !_isExpanded;
    setState(() {});
  }
}
