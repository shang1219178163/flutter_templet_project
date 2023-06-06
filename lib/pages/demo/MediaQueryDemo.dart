//
//  MediaQueryDemo.dart
//  flutter_templet_project
//
//  Created by shang on 3/6/23 4:13 PM.
//  Copyright © 3/6/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/mixin/keyboard_change_mixin.dart';
import 'package:tuple/tuple.dart';


class MediaQueryDemo extends StatefulWidget {

  const MediaQueryDemo({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _MediaQueryDemoState createState() => _MediaQueryDemoState();
}

class _MediaQueryDemoState extends State<MediaQueryDemo> with WidgetsBindingObserver, KeyboardChangeMixin {
  final _textcontroller = TextEditingController();

  var labelText = "";

  final isVisibleVN = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            handleScreenHeight();
          },
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),)
        ).toList(),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            TextField(
              controller: _textcontroller,
              decoration: InputDecoration(
                hintText: 'Please enter',
                labelText: labelText,
                // border: InputBorder.none,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide()
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    _textcontroller.clear();
                    FocusScope.of(context).requestFocus(FocusNode());
                  }
                ),
              ),
            ),
            _buildItems(),
            _buildTips(),
            buildTable(rows: _renderTuples(items: tips)),
            Divider(),
            buildTable(rows: _renderTuples(items: items)),
          ].map((e) => e.toSliverToBoxAdapter()).toList(),
        ),
      )
    );
  }

  onPressed() {

  }

  @override
  void onKeyboardChanged(bool visible) {
    // TODO deal with keyboard visibility change.
    debugPrint("onKeyboardChanged:${visible ? "展开键盘" : "收起键盘"} ${context.viewBottom}");
    isVisibleVN.value = visible;
  }


  Widget _buildItems() {
    return Column(
      children: [
        TextButton(
          onPressed: () => debugPrint("viewInsets: ${mediaQuery.viewInsets}"),
          child: ValueListenableBuilder<bool>(
            valueListenable: isVisibleVN,
            builder: (context, value, child) {
              // print("ValueListenableBuilder:${context.viewBottom} ${MediaQuery.of(context).viewInsets.bottom}");

              return Text(value ? "展示键盘" : "隐藏键盘");
            }
          ),
        ),
        TextButton(
          onPressed: () => debugPrint("viewInsets: ${mediaQuery.viewInsets}"),
          child: Text("viewInsets: ${mediaQuery.viewInsets}"),
        ),
        TextButton(
          onPressed: () => debugPrint("viewPadding: ${mediaQuery.viewPadding}"),
          child: Text("viewPadding: ${mediaQuery.viewPadding}"),
        ),
        TextButton(
          onPressed: () => debugPrint("padding: ${mediaQuery.padding}"),
          child: Text("padding: ${mediaQuery.padding}"),
        ),
      ],
    );
  }

  Widget _buildTips() {
    return Column(
      children: [
        Divider(),
        Text("""
无键盘: viewInsets: EdgeInsets.zero
无键盘: viewPadding: EdgeInsets(0.0, 47.0, 0.0, 34.0)
无键盘: padding: EdgeInsets(0.0, 47.0, 0.0, 34.0)
          """),
        Divider(),
        Text("""
显示键盘: viewInsets: EdgeInsets(0.0, 0.0, 0.0, 336.0)
显示键盘: viewPadding: EdgeInsets(0.0, 47.0, 0.0, 34.0)
显示键盘: padding: EdgeInsets(0.0, 47.0, 0.0, 0.0)
          """),
        Divider(),
      ],
    );
  }


  Widget buildTable({required List<TableRow> rows}) {
    return Table(
      columnWidths: <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth(80),
        2: FlexColumnWidth(80),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(
        color: Colors.green,
        width: 1,
        style: BorderStyle.solid,
      ),
      children: rows,
    );
  }


  List<TableRow> _renderTuples({List items = const []}) {
    if (items.isEmpty || !isTuple(items[0])) {
      return [];
    }

    return items.map((e) => TableRow(
      children: List.generate(tupleLength(e), (index) => Container(
        padding: EdgeInsets.all(8),
        child: Text(e.toList()[index]),
      )).toList(),
    )).toList();
  }

  handleScreenHeight() {
    // /// AppBar 高度
    // const double kToolbarHeight = 56.0;
    //
    // /// BottomNavigationBar 高度
    // const double kBottomNavigationBarHeight = 56.0;

    MediaQueryData mq = MediaQuery.of(context);
    // 屏幕密度
    final pixelRatio = mq.devicePixelRatio;
    // 屏幕宽(注意是dp, 转换px 需要 screenWidth * pixelRatio)
    final screenWidth = mq.size.width;
    // 屏幕高(注意是dp)
    final screenHeight = mq.size.height;
    // 顶部状态栏, 随着刘海屏会增高
    final statusBarHeight = mq.padding.top;
    // 底部功能栏, 类似于iPhone XR 底部安全区域
    final bottomBarHeight = mq.padding.bottom;
    //
    // /// 安全内容高度(包含 AppBar 和 BottomNavigationBar 高度)
    // double get safeContentHeight => screenHeight - statusBarHeight - bottomBarHeight;
    // /// 实际的安全高度
    // double get safeHeight => safeContentHeight - kToolbarHeight - kBottomNavigationBarHeight;

    /// 安全内容高度(包含 AppBar 和 BottomNavigationBar 高度)
    var safeContentHeight = screenHeight - statusBarHeight - bottomBarHeight;
    /// 实际的安全高度
    var safeHeight = safeContentHeight - kToolbarHeight - kBottomNavigationBarHeight;
    debugPrint("statusBarHeight:${statusBarHeight.toString()}");
    debugPrint("bottomBarHeight:${bottomBarHeight.toString()}");
    debugPrint("safeContentHeight:${safeContentHeight.toString()}");
    debugPrint("safeHeight:${safeHeight.toString()}");

  }

  final tips = [
    Tuple3("", "无键盘", "显示键盘"),
    Tuple3("viewInsets", "EdgeInsets.zero", "EdgeInsets(0.0, 0.0, 0.0, 336.0)"),
    Tuple3("viewPadding", "EdgeInsets(0.0, 47.0, 0.0, 34.0)", "EdgeInsets(0.0, 47.0, 0.0, 34.0)"),
    Tuple3("padding", "EdgeInsets(0.0, 47.0, 0.0, 34.0)", "EdgeInsets(0.0, 47.0, 0.0, 0.0)"),
  ];

  final items = [
    Tuple2("属性", "说明"),
    Tuple2("size", "逻辑像素，并不是物理像素，类似于Android中的dp，逻辑像素会在不同大小的手机上显示的大小基本一样，物理像素 = size*devicePixelRatio。"),
    Tuple2("devicePixelRatio", "单位逻辑像素的物理像素数量，即设备像素比。"),
    Tuple2("textScaleFactor", "单位逻辑像素字体像素数，如果设置为1.5则比指定的字体大50%。"),
    Tuple2("platformBrightness", "当前设备的亮度模式，比如在Android Pie手机上进入省电模式，所有的App将会使用深色（dark）模式绘制。"),
    Tuple2("viewInsets", "被系统遮挡的部分，通常指键盘，弹出键盘，viewInsets.bottom表示键盘的高度。"),
    Tuple2("padding", "被系统遮挡的部分，通常指“刘海屏”或者系统状态栏。"),
    Tuple2("viewPadding", "被系统遮挡的部分，通常指“刘海屏”或者系统状态栏，此值独立于padding和viewInsets，它们的值从MediaQuery控件边界的边缘开始测量。在移动设备上，通常是全屏。"),
    Tuple2("systemGestureInsets", "显示屏边缘上系统“消耗”的区域输入事件，并阻止将这些事件传递给应用。比如在Android Q手势滑动用于页面导航（ios也一样），比如左滑退出当前页面。"),
    Tuple2("physicalDepth", "设备的最大深度，类似于三维空间的Z轴。"),
    Tuple2("alwaysUse24HourFormat", "是否是24小时制。"),
    Tuple2("accessibleNavigation", "用户是否使用诸如TalkBack或VoiceOver之类的辅助功能与应用程序进行交互，用于帮助视力有障碍的人进行使用。"),
    Tuple2("invertColors", "是否支持颜色反转。"),
    Tuple2("highContrast", "用户是否要求前景与背景之间的对比度高， iOS上，方法是通过“设置”->“辅助功能”->“增加对比度”。 此标志仅在运行iOS 13的iOS设备上更新或以上。"),
    Tuple2("disableAnimations", "平台是否要求尽可能禁用或减少动画。"),
    Tuple2("boldText", "平台是否要求使用粗体。"),
    Tuple2("orientation", "是横屏还是竖屏。"),
  ];
}

bool isTuple(dynamic obj) {
  return obj is Tuple2 || obj is Tuple3 || obj is Tuple4 || obj is Tuple5 || obj is Tuple6 || obj is Tuple7;
}

int tupleLength(dynamic obj) {
  if (obj is Tuple2) {
    return 2;
  }
  if (obj is Tuple3) {
    return 3;
  }
  if (obj is Tuple4) {
    return 4;
  }
  if (obj is Tuple5) {
    return 5;
  }
  if (obj is Tuple6) {
    return 6;
  }
  if (obj is Tuple7) {
    return 7;
  }
  return 0;
}