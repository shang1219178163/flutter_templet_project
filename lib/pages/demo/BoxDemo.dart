//
//  BoxDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/10/21 10:11 AM.
//  Copyright © 12/10/21 shang. All rights reserved.
//

/// 尺寸限制类容器:
/// AspectRatio它可以指定子组件的长宽比、
/// LimitedBox 用于指定最大宽高、
/// FractionallySizedBox 可以根据父容器宽高的百分比来设置子组件宽高等
///

import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_avatar_badge.dart';
import 'package:flutter_templet_project/basicWidget/n_menu_anchor.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/extension/alignment_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/util/R.dart';

class BoxDemo extends StatefulWidget {
  final String? title;

  const BoxDemo({Key? key, this.title}) : super(key: key);

  @override
  _BoxDemoState createState() => _BoxDemoState();
}

class _BoxDemoState extends State<BoxDemo> {
  final values = AlignmentExt.allCases;
  late final selectedItemVN = ValueNotifier<Alignment>(Alignment.topRight);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          children: [
            NMenuAnchor<Alignment>(
              values: values,
              initialItem: values.first,
              cbName: (e) => e.toString() ?? "请选择",
              equal: (a, b) => a == b,
              onChanged: (e) {
                selectedItemVN.value = e;
              },
            ),
            NSectionBox(
              title: "UnconstrainedBox",
              child: buildSizedBox(),
            ),
            ValueListenableBuilder(
              valueListenable: selectedItemVN,
              builder: (context, value, child) {
                return NSectionBox(
                  title: "SizedOverflowBox",
                  child: buildSizedOverflowBox(),
                );
              },
            ),
            NSectionBox(
              title: "UnconstrainedBox",
              child: buildConstrainedBox(),
            ),
            NSectionBox(
              title: "FittedBox",
              child: buildFittedBox(),
            ),
            NSectionBox(
              title: "UnconstrainedBox",
              child: buildUnconstrainedBox(),
            ),
            NSectionBox(
              title: "OverflowBox",
              child: buildOverflowBox(),
            ),
            NSectionBox(
              title: "OverflowBox1",
              child: buildOverflowBox(alignment: Alignment.center),
            ),
            NSectionBox(
              title: "OverflowBox2",
              child: buildOverflowBox(alignment: Alignment.topRight),
            ),
            NSectionBox(
              title: "buildBage",
              child: buildBage(),
            ),
            NSectionBox(
              title: "buildAvatarBage",
              child: buildAvatarBage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSizedBox() {
    return Container(
      width: 300,
      height: 100,
      // color: Colors.green,
      child: SizedBox.expand(
        child: FractionallySizedBox(
          widthFactor: 0.5,
          heightFactor: 0.5,
          alignment: FractionalOffset.center,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue,
                width: 4,
              ),
            ),
            child: Text("SizedBox.expand"),
          ),
        ),
      ),
    );
  }

  /// SizedOverflowBox
  Widget buildSizedOverflowBox() {
    Alignment alignment = Alignment.topRight;
    alignment = selectedItemVN.value;

    final size = Size(100, 100);
    final childSize = size * 0.5;
    final radius = 8.0;
    final childSizeRadius = min(childSize.width, childSize.height) * 0.5;
    return Container(
      padding: EdgeInsets.only(
        left: alignment.x == -1 ? childSize.width * 0.5 : 0,
        right: alignment.x == 1 ? childSize.width * 0.5 : 0,
        top: alignment.y == -1 ? childSize.height * 0.5 : 0,
        bottom: alignment.y == 1 ? childSize.height * 0.5 : 0,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
      ),
      child: Container(
        width: size.width,
        height: size.height,
        alignment: alignment,
        decoration: BoxDecoration(
          color: Colors.green[400],
          borderRadius: BorderRadius.circular(radius),
        ),
        child: SizedOverflowBox(
          size: Size.zero,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(childSizeRadius),
            child: Container(
              width: childSize.width,
              height: childSize.height,
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                childAspectRatio: 1,
                children: [
                  ...Colors.primaries.sublist(0, 4).map(
                    (e) {
                      return Container(color: e);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ConstrainedBox用于对子组件添加额外的约束。
  Widget buildConstrainedBox() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: double.infinity, //宽度尽可能大
        minHeight: 50.0, //最小高度为50像素
      ),
      child: Container(
        // height: 5.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.green,
        ),
        child: Text("ConstrainedBox"),
      ),
    );
  }

  Widget buildFittedBox() {
    return Container(
      height: 100,
      width: 300,
      color: Colors.green,
      child: FittedBox(
        fit: BoxFit.contain,
        // child: Image.network('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
        child: Image.asset(
          'bg.png'.toPath(),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// UnconstrainedBox会消除上层组件的约束，也就意味着UnconstrainedBox 的子组件将不再受到约束，大小完全取决于自己。
  Widget buildUnconstrainedBox() {
    return Container(
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 200.0, minHeight: 100.0), //父
        child: UnconstrainedBox(
          //“去除”父级限制
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 90.0, minHeight: 30.0), //子
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildOverflowBox({
    double width = 70.0,
    double height = 70.0,
    padding = const EdgeInsets.all(5.0),
    alignment = Alignment.topLeft,
  }) {
    return Container(
      color: Colors.green,
      width: width,
      height: height,
      padding: padding,
      child: OverflowBox(
        alignment: alignment,
        maxWidth: width + 20,
        maxHeight: width + 20,
        child: Container(
          color: Colors.yellow.withOpacity(0.5),
        ),
      ),
    );
  }

  var badge = 9;
  var badgeStr = "999+";

  Widget buildBage() {
    double width = 60;
    double height = 60;
    double size = 20;

    final padding = EdgeInsets.symmetric(horizontal: 4, vertical: 2);

    final content = Container(
      width: width,
      height: height,
      alignment: Alignment.topRight,
      decoration: BoxDecoration(
        // color: Colors.grey.withAlpha(88),
        borderRadius: BorderRadius.all(Radius.circular(8)),
        image: DecorationImage(
          image: ExtendedNetworkImageProvider(
            R.image.urls[7],
            cache: true,
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: SizedOverflowBox(
        alignment: Alignment.center,
        size: Size.zero,
        child: UnconstrainedBox(
          child: Container(
            // width: size,
            height: size,
            constraints: BoxConstraints(
              minWidth: size + padding.horizontal * 2,
            ),
            padding: padding,
            alignment: Alignment.center,
            decoration: ShapeDecoration(
              color: Colors.red,
              shape: badgeStr.length <= 2 ? CircleBorder() : StadiumBorder(),
            ),
            child: Text(
              badgeStr,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );

    return InkWell(
      onTap: () {
        badge = badge < 999 ? badge * 10 : 9;
        DLog.d("badge: $badge");
        badgeStr = badge > 99 ? "$badge+" : "$badge";
        // badgeStr = "1";
        setState(() {});
      },
      child: content,
    );
  }

  Widget buildAvatarBage() {
    return InkWell(
      onTap: () {
        badge = badge < 999 ? badge * 10 : 9;
        DLog.d("badge: $badge");
        badgeStr = badge > 99 ? "$badge+" : "$badge";
        // badgeStr = "1";
        setState(() {});
      },
      child: NAvatarBadge(
        url: R.image.urls[7],
        badgeStr: badgeStr,
      ),
    );
  }
}
