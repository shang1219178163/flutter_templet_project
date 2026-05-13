//
//  MediaQueryVsScreenManager.dart
//  flutter_templet_project
//
//  Created by shang on 2026/5/13 12:16.
//  Copyright © 2026/5/13 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/text_field/n_textfield_bar.dart';
import 'package:flutter_templet_project/mixin/safe_set_state_mixin.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/n_screen_manager.dart';
import 'package:get/get.dart';

class MediaQueryVsScreenManager extends StatefulWidget {
  const MediaQueryVsScreenManager({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<MediaQueryVsScreenManager> createState() => _MediaQueryVsScreenManagerState();
}

class _MediaQueryVsScreenManagerState extends State<MediaQueryVsScreenManager> with SafeSetStateMixin {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();
  final textEditingController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    focusNode.addListener(() async {
      await Future.delayed(Duration(milliseconds: 300));
      // DLog.d([focusNode.hasFocus, mediaQuery.viewInsets, NScreenManager.viewInsets.bottom]);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        NTextfieldBar(
          controller: textEditingController,
          onConfirm: (String value) {
            DLog.d([
              NScreenManager.viewInsets,
              "viewInsets: ${MediaQuery.of(context).viewInsets.bottom}",
              "viewInsets: ${MediaQuery.viewInsetsOf(context).bottom}",
            ]);
          },
        ),
        Divider(height: 8),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                buildTable(),
              ],
            ),
          ),
        ),
        Container(
          height: 30,
          decoration: BoxDecoration(
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget buildTable() {
    final mediaQueryData = MediaQuery.of(context);

    final items = <DeviceScreenProperty>[
      DeviceScreenProperty(
        name: "属性",
        value: "mediaQueryData",
        extra: "NScreenManager",
        extraNew: "自定义属性",
        desc: "说明",
      ),
      DeviceScreenProperty(
        name: "size",
        value: mediaQueryData.size,
        extra: NScreenManager.current.physicalSize,
        extraNew: NScreenManager.screenSize,
        desc: "逻辑像素，并不是物理像素，类似于Android中的dp，逻辑像素会在不同大小的手机上显示的大小基本一样，物理像素 = size*devicePixelRatio。",
      ),
      DeviceScreenProperty(
        name: "devicePixelRatio",
        value: mediaQueryData.devicePixelRatio,
        extra: NScreenManager.current.devicePixelRatio,
        extraNew: NScreenManager.devicePixelRatio,
        desc: "单位逻辑像素的物理像素数量，即设备像素比。",
      ),
      DeviceScreenProperty(
        name: "viewInsets",
        value: mediaQueryData.viewInsets,
        extra: NScreenManager.current.viewInsets,
        extraNew: NScreenManager.viewInsets,
        desc: "被系统遮挡的部分，通常指键盘，弹出键盘，viewInsets.bottom表示键盘的高度。",
      ),
      DeviceScreenProperty(
        name: "padding",
        value: mediaQueryData.padding,
        extra: NScreenManager.current.padding,
        extraNew: NScreenManager.padding,
        desc: "被系统遮挡的部分，通常指“刘海屏”或者系统状态栏。",
      ),
      DeviceScreenProperty(
        name: "viewPadding",
        value: mediaQueryData.viewPadding,
        extra: NScreenManager.current.viewPadding,
        extraNew: NScreenManager.viewPadding,
        desc: "被系统遮挡的部分，通常指“刘海屏”或者系统状态栏，此值独立于padding和viewInsets，它们的值从MediaQuery控件边界的边缘开始测量。在移动设备上，通常是全屏。",
      ),
      DeviceScreenProperty(
        name: "systemGestureInsets",
        value: mediaQueryData.systemGestureInsets,
        extra: NScreenManager.current.systemGestureInsets,
        extraNew: NScreenManager.systemGestureInsets,
        desc: "显示屏边缘上系统“消耗”的区域输入事件，并阻止将这些事件传递给应用。比如在Android Q手势滑动用于页面导航（ios也一样），比如左滑退出当前页面。",
      ),
      DeviceScreenProperty(
        name: "orientation",
        value: mediaQueryData.orientation,
        extra: NScreenManager.orientation,
        extraNew: NScreenManager.orientation,
        desc: "是横屏还是竖屏。",
      ),
    ];

    List<TableRow> renderItems({List<DeviceScreenProperty> items = const []}) {
      if (items.isEmpty) {
        return [];
      }

      final length = 3;
      return items.map((e) {
        return TableRow(
          children: List.generate(e.properties.sublist(0, length).length, (index) {
            final key = e.properties[index];
            final map = e.toJson();
            var value = map[key]?.toString() ?? "";
            // debugPrint([runtimeType, key, value].join(", "));
            return Container(
              padding: EdgeInsets.all(8),
              child: Text(
                value,
                style: TextStyle(fontSize: 12),
              ),
            );
          }).toList(),
        );
      }).toList();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        columnWidths: <int, TableColumnWidth>{
          0: FixedColumnWidth(140),
          1: FixedColumnWidth(140),
          2: FixedColumnWidth(140),
          3: FixedColumnWidth(140),
          4: FixedColumnWidth(200),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.all(
          color: Colors.green,
          width: 0.5,
          style: BorderStyle.solid,
        ),
        children: renderItems(items: items),
      ),
    );
  }
}

class DeviceScreenProperty {
  DeviceScreenProperty({
    this.name,
    this.value,
    this.extra,
    this.extraNew,
    this.desc,
  });

  String? name;
  dynamic value;
  dynamic extra;
  dynamic extraNew;
  String? desc;

  Map<String, dynamic> toJson() {
    var data = Map<String, dynamic>();
    data['name'] = name;
    data['value'] = value;
    data['extra'] = extra;
    data['extraNew'] = extraNew;
    data['desc'] = desc;
    return data;
  }

  List<String> get properties => ["name", "value", "extraNew", "extra", "desc"];
}
