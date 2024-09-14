//
//  AppTabPage.dart
//  flutter_templet_project
//
//  Created by shang on 2024/5/10 14:52.
//  Copyright © 2024/5/10 shang. All rights reserved.
//

import 'dart:async';
import 'dart:developer';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/Pages/app_user_center_page.dart';
import 'package:flutter_templet_project/Pages/second_page.dart';
import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/button_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/network/proxy/dio_proxy.dart';
import 'package:flutter_templet_project/pages/app_tab_bar_controller.dart';
import 'package:flutter_templet_project/pages/demo/APPDrawerMenuPage.dart';
import 'package:flutter_templet_project/pages/demo/TabBarViewDemo.dart';
import 'package:flutter_templet_project/pages/tabBar_tabBarView_demo.dart';
import 'package:flutter_templet_project/pages/third_page.dart';
import 'package:flutter_templet_project/provider/color_filtered_provider.dart';
import 'package:flutter_templet_project/util/AppLifecycleObserver.dart';
import 'package:get/get.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

final kScaffoldKey = GlobalKey<ScaffoldState>();

class AppTabPage extends StatefulWidget {
  const AppTabPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _AppTabPageState createState() => _AppTabPageState();
}

class _AppTabPageState extends State<AppTabPage>
    with WidgetsBindingObserver, AppLifecycleObserverMixin {
  final appController = Get.find<AppTabBarController>();

  int currentIndex = 0;

  final unreadVN = ValueNotifier(0);

  final List<Tuple2<Tuple2<String, Widget>, Widget>> items = [
    Tuple2(Tuple2("首页", Icon(Icons.home)), TabBarTabBarViewDemo()),
    Tuple2(Tuple2("按钮", Icon(Icons.pets)), SecondPage()),
    Tuple2(Tuple2("消息", Icon(Icons.message)), TabBarViewDemo()),
    Tuple2(Tuple2("购物车", Icon(Icons.shopping_cart)), ThirdPage()),
    Tuple2(Tuple2("我的", Icon(Icons.person)), APPUserCenterPage()),
  ];

  late AppLifecycleListener _lifecycleListener;

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    // 代理
    DioProxy.initHttp();
    // 收起键盘
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    // _lifecycleListener = AppLifecycleListener(
    //   onRestart: (){
    //     ddlog("$widget onRestart - AppLifecycleListener");
    //   },
    //   onResume: (){
    //     ddlog("$widget onResume - AppLifecycleListener");
    //   },
    //   onInactive: (){
    //     ddlog("$widget onInactive - AppLifecycleListener");
    //   },
    //   onPause: (){
    //     ddlog("$widget onPause - AppLifecycleListener");
    //   },
    //   onDetach: (){
    //     ddlog("$widget onDetach - AppLifecycleListener");
    //   },
    //   onHide: (){
    //     ddlog("$widget onHide - AppLifecycleListener");
    //   },
    // );

    /// 保存app包信息
    await appController.getPackageInfo();

    /// 获取 Observatory uri
    appController.getObservatoryUri();

    /// 列表刷新组件配置
    configRefresh();

    /// app 生命周期监听
    // appController.appState.listen((event) {
    //   ddlog("$widget appController.appState.listen ${event}");
    // });
  }

  @override
  void onAppLifecycleStateChanged(AppLifecycleState state) {
    appController.appState.value = state;
    appController.appStateVN.value = state;
    ddlog("$widget ${state.name}, ${appController.appState.value}");
  }

  @override
  Widget build(BuildContext context) {
    final page = Scaffold(
      key: kScaffoldKey,
      drawer: APPDrawerMenuPage(),
      endDrawer: APPDrawerMenuPage(),
      // appBar: buildAppBar(),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            // canvasColor: Colors.red,
            ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          selectedFontSize: 10.sp, // 选中字体大小
          unselectedFontSize: 10.sp, // 未选中字体大小
          selectedItemColor: context.primaryColor,
          onTap: (index) => onTapBar(index),
          items: items
              .map(
                (e) => BottomNavigationBarItem(
                  tooltip: '', // 去除长按文字提示
                  label: e.item1.item1,
                  icon: ValueListenableBuilder<int>(
                    valueListenable: unreadVN,
                    builder: (context, badge, child) {
                      return buildIcon(
                        title: e.item1.item1,
                        normalIcon: e.item1.item2,
                        activeIcon: e.item1.item2,
                        badge: badge,
                      );
                    },
                  ),
                ),
              )
              .toList(),
        ),
      ),
      body: items.map((e) => e.item2).toList()[currentIndex],
      // body: PageView(onPageChanged: (index){
      //     _changePage(index);
      //   },
      //     children: pages,
      // ),
    );
    return Consumer<ColorFilteredProvider>(
      builder: (BuildContext context, provider, Widget? child) {
        //仅首页置灰
        return ColorFiltered(
          colorFilter: ColorFilter.mode(provider.color, BlendMode.color),
          child: page,
        );
      },
    );
  }

  ///创建导航栏
  AppBar buildAppBar() {
    return AppBar(
      title: Text(widget.title ?? "标题"),
      leading: Icon(Icons.arrow_back),
    );
  }

  Widget buildIcon({
    required String title,
    required Widget normalIcon,
    required Widget activeIcon,
    int badge = 0,
  }) {
    if (badge > 99) {
      badge = 99;
    }

    final badgeChild = title != "消息" || badge == 0
        ? SizedBox()
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
            decoration: const ShapeDecoration(
              color: Colors.red,
              shape: StadiumBorder(),
            ),
            child: Text(
              "$badge",
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.white,
              ),
            ),
          );

    final icon = Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        normalIcon,
        Positioned(
          // draw a red marble
          top: -5,
          right: -5,
          child: badgeChild,
        ),
      ],
    );
    return icon;
  }

  /*切换页面*/
  void onTapBar(int index) {
    /*如果点击的导航项不是当前项  切换 */
    if (index != currentIndex) {
      currentIndex = index;
      ddlog(currentIndex);
      setState(() {});
    }
  }

  /// 上拉刷新,下拉加载全局配置
  configRefresh() {
    EasyRefresh.defaultHeaderBuilder = () => ClassicHeader(
          triggerOffset: 50,
          showMessage: false,
          dragText: "下拉刷新",
          armedText: "释放刷新",
          readyText: "正在刷新...",
          processingText: "正在刷新...",
          processedText: "刷新完成",
          noMoreText: "我可是有底线的 ~",
          failedText: "刷新失败",
          messageText: '更新时间 %T',
          spacing: 0,
          textBuilder: (context, state, text) {
            return const SizedBox();
          },
          messageBuilder: (context, state, text, dateTime) {
            return const SizedBox();
          },
          pullIconBuilder: (context, state, animation) {
            return const SizedBox(
              child: CupertinoActivityIndicator(radius: 10),
            );
          },
          infiniteOffset: null,
        );

    EasyRefresh.defaultFooterBuilder = () => ClassicFooter(
          triggerOffset: 50,
          showMessage: false,
          dragText: "上拉加载",
          armedText: "释放加载",
          readyText: "加载中...",
          processingText: "加载中...",
          processedText: "加载完成",
          noMoreText: "我可是有底线的 ~",
          failedText: "加载失败",
          // noMoreIcon: SizedBox(),
          spacing: 0,
          textBuilder: (context, state, text) {
            return const SizedBox();
          },
          messageBuilder: (context, state, text, dateTime) {
            return const SizedBox();
          },
          pullIconBuilder: (context, state, animation) {
            return const SizedBox(
              child: CupertinoActivityIndicator(radius: 10),
            );
          },
          infiniteOffset: null,
        );
  }

  Widget buildUpdateAlert(BuildContext context) {
    const title = "新版本v ${2.0}";
    const message = """
      1、支持立体声蓝牙耳机，同时改善配对性能
      2、提供屏幕虚拟键盘
      3、更简洁更流畅，使用起来更快
      4、修复一些软件在使用时自动退出bug5、新增加了分类查看功能
      """;

    return Container(
      padding: EdgeInsets.only(top: 100, left: 15, bottom: 100, right: 15),
      child: Column(
        //Column控件用来垂直摆放子Widget
        // crossAxisAlignment: CrossAxisAlignment.start, //水平方向距左对⻬
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 20),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              message,
              style: TextStyle(fontSize: 14),
            ),
          ),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  ddlog("以后再说");
                },
                child: Text(
                  "以后再说",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              TextButton(
                onPressed: () {
                  ddlog("立即升级");
                },
                child: Text(
                  "立即升级",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
