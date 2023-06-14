

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';

class MediaQueryScreeenDemo extends StatefulWidget {

  MediaQueryScreeenDemo({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _MediaQueryScreeenDemoState createState() => _MediaQueryScreeenDemoState();
}

class _MediaQueryScreeenDemoState extends State<MediaQueryScreeenDemo> {

  late MediaQueryData mq = MediaQuery.of(context);
  // 屏幕密度
  late final pixelRatio = mq.devicePixelRatio;
  // 屏幕宽(注意是dp, 转换px 需要 screenWidth * pixelRatio)
  late final screenWidth = mq.size.width;
  // 屏幕高(注意是dp)
  late final screenHeight = mq.size.height;
  // 顶部状态栏, 随着刘海屏会增高
  late final statusBarHeight = mq.padding.top;
  // 底部功能栏, 类似于iPhone XR 底部安全区域
  late final bottomBarHeight = mq.padding.bottom;

  late final iosTabHeight = mq.viewPadding.bottom;

  /// 安全内容高度(包含 AppBar 和 BottomNavigationBar 高度)
  double get safeContentHeight => screenHeight - statusBarHeight - bottomBarHeight;
  /// 实际的安全高度
  double get safeHeight => safeContentHeight - kToolbarHeight - kBottomNavigationBarHeight;



  final _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return buildBodyNew();
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: ['done',].map((e) => TextButton(
            child: Text(e,
              style: TextStyle(color: Colors.white),
            ),
            onPressed: handleScreenHeight,
          )).toList(),
        ),
        body: Text(arguments.toString())
    );
  }

  buildBodyNew() {
    return Scaffold(
      body: Container(
        // color: ColorExt.random,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: ColorExt.random,
              height: mq.viewPadding.top,
              padding: EdgeInsets.only(top: 20, left: 20),
              child: Text("statusBar ${mq.viewPadding.top}"),
            ),
            Container(
              color: ColorExt.random,
              height: kToolbarHeight,
              padding: EdgeInsets.only(left: 20),
              child: TextButton(
                onPressed: () {
                  handleScreenHeight();
                },
                child: Text("kToolbarHeight $kToolbarHeight"),
              ),
            ),
            Container(
              key: _globalKey,
              color: ColorExt.random,
              padding: EdgeInsets.only(left: 20),
              // alignment: Alignment.topLeft,
              // child: Text((_globalKey.currentState?.context.size.toString() ?? "-")),
              //   child: Text((_globalKey.currentContext?.renderBox?.size.height.toString() ?? "-")),
              child: InkWell(
                onTap: (){
                  final a = _globalKey.currentContext?.origin().toString() ?? "-";

                  debugPrint("A: $a");
                },
                child: Container(
                  color: Colors.red,
                  child: Text("_globalKey"),
                ),
              ),
            ),
            Container(
              color: ColorExt.random,
              padding: EdgeInsets.only(left: 20),
              child: Text("size: ${mq.size.toString()}"),
            ),
            Container(
              color: ColorExt.random,
              padding: EdgeInsets.only(left: 20),
              child: Text("viewInsets: ${mq.viewInsets.toString()}"),
            ),
            Container(
              color: ColorExt.random,
              padding: EdgeInsets.only(left: 20),
              child: Text("viewPadding: ${mq.viewPadding.toString()}"),
            ),
            Container(
              color: ColorExt.random,
              padding: EdgeInsets.only(left: 20),
              child: Text("padding: ${mq.padding.toString()}"),
            ),
            Spacer(),
            Container(
              color: ColorExt.random,
              padding: EdgeInsets.only(left: 20),
              height: mq.viewPadding.bottom,
              child: Text("padding: ${mq.viewPadding.toString()}"),
            ),
          ],
        ),
      )
    );
  }

  buildBody() {
    return Scaffold(
        body: Container(
          // color: ColorExt.random,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: ColorExt.random,
                height: statusBarHeight,
                padding: EdgeInsets.only(top: 20, left: 20),
                child: Text("statusBar $statusBarHeight"),
              ),
              Container(
                color: ColorExt.random,
                height: kToolbarHeight,
                padding: EdgeInsets.only(top: 20, left: 20),
                child: TextButton(
                  onPressed: () {
                    handleScreenHeight();
                  },
                  child: Text("kToolbarHeight $kToolbarHeight"),
                ),
              ),
              Spacer(),
              Container(
                color: ColorExt.random,
                height: bottomBarHeight,
                padding: EdgeInsets.only(top: 20, left: 20),
                child: Text("bottomBarHeight.toString(): $bottomBarHeight"),
              ),
              Container(
                color: ColorExt.random,
                // height: iosTabHeight,
                padding: EdgeInsets.only(top: 20, left: 20),
                child: Text("viewInsets: ${mq.viewInsets.toString()}"),
              ),
              Container(
                color: ColorExt.random,
                // height: iosTabHeight,
                padding: EdgeInsets.only(top: 20, left: 20),
                child: Text("viewPadding: ${mq.viewPadding.toString()}"),
              ),
              Container(
                color: ColorExt.random,
                // height: iosTabHeight,
                padding: EdgeInsets.only(top: 20, left: 20),
                child: Text("padding: ${mq.padding.toString()}"),
              ),
              Container(
                color: ColorExt.random,
                height: kBottomNavigationBarHeight,
                padding: EdgeInsets.only(top: 20, left: 20),
                child: Text("kBottomNavigationBarHeight: $kBottomNavigationBarHeight"),
              ),
              Container(
                color: ColorExt.random,
                height: iosTabHeight,
                padding: EdgeInsets.only(top: 20, left: 20),
                child: Text("iosTabHeight2: $iosTabHeight"),
              ),
              Container(
                color: ColorExt.random,
                height: iosTabHeight,
                padding: EdgeInsets.only(top: 20, left: 20),
                child: Text("iosTabHeight1111: $iosTabHeight"),
              ),

              Container(
                color: ColorExt.random,
                height: iosTabHeight,
                padding: EdgeInsets.only(top: 20, left: 20),
                child: Text("iosTabHeight3: $iosTabHeight"),
              ),
            ],
          ),
        )
    );
  }

  handleScreenHeight() {
    // /// AppBar 高度
    // const double kToolbarHeight = 56.0;
    //
    // /// BottomNavigationBar 高度
    // const double kBottomNavigationBarHeight = 56.0;


    /// 安全内容高度(包含 AppBar 和 BottomNavigationBar 高度)
    var safeContentHeight = screenHeight - statusBarHeight - bottomBarHeight;
    /// 实际的安全高度
    var safeHeight = safeContentHeight - kToolbarHeight - kBottomNavigationBarHeight;
    debugPrint("kBottomNavigationBarHeight:${kBottomNavigationBarHeight.toString()}");
    debugPrint("statusBarHeight:${statusBarHeight.toString()}");
    debugPrint("bottomBarHeight:${bottomBarHeight.toString()}");
    debugPrint("safeContentHeight:${safeContentHeight.toString()}");
    debugPrint("safeHeight:${safeHeight.toString()}");

  }
}