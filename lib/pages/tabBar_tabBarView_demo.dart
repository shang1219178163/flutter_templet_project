//
//  TabBarTabBarViewDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/22/21 2:32 PM.
//  Copyright © 10/22/21 shang. All rights reserved.
//

import 'package:enhance_expansion_panel/enhance_expansion_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_templet_project/basicWidget/list_subtitle_cell.dart';
import 'package:flutter_templet_project/basicWidget/app_update_card.dart';
import 'package:flutter_templet_project/basicWidget/section_list_view.dart';

import 'package:flutter_templet_project/extensions/color_extension.dart';
import 'package:flutter_templet_project/extensions/divider_extension.dart';
import 'package:flutter_templet_project/extensions/list_extension.dart';
import 'package:flutter_templet_project/extensions/string_extension.dart';
import 'package:flutter_templet_project/extensions/ddlog.dart';
import 'package:flutter_templet_project/extensions/widget_extension.dart';

import 'package:flutter_templet_project/main.dart';
import 'package:flutter_templet_project/mockData/mock_data.dart';
import 'package:flutter_templet_project/routes/APPRouter.dart';

import 'package:get/get.dart';
import 'package:tuple/tuple.dart';


class TabBarTabBarViewDemo extends StatefulWidget {

  @override
  _TabBarTabBarViewDemoState createState() => _TabBarTabBarViewDemoState();
}

class _TabBarTabBarViewDemoState extends State<TabBarTabBarViewDemo> with SingleTickerProviderStateMixin {
  late TabController _tabController = TabController(length: _pages.length, vsync: this);

  // late PageController _pageController = PageController(initialPage: 0, keepPage: true);

  @override
  void initState() {
    super.initState();
    _tabController.index = _pages.length - 1;

    // testData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('基础组件列表'),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: Icon(Icons.menu, color: Colors.white), //自定义图标
            onPressed: () {
              // 打开抽屉菜单
              // Scaffold.of(context).openDrawer();
              kScaffoldKey.currentState!.openDrawer();
            },
          );
        }),
        actions: [
          TextButton(onPressed: (){
            ddlog("provider");
            Get.toNamed(APPRouter.stateManagerDemo, arguments: "状态管理");
          }, child: Text("状态管理", style: TextStyle(color: Colors.white),),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _pages.map((e) => Tab(text: e.item1)).toList(),
          // indicatorSize: TabBarIndicatorSize.label,
          // indicatorPadding: EdgeInsets.only(left: 6, right: 6),
        ),
        //自定义导航栏
        // bottom: PreferredSize(
        //     child: Theme(
        //       data: Theme.of(context).copyWith(accentColor: Colors.white),
        //       child: Container(
        //         height: 40,
        //         alignment: Alignment.center, //圆点居中
        //         //给自定义导航栏设置圆点控制器
        //         child: TabPageSelector(
        //           color: Colors.grey,
        //           selectedColor: Colors.white,
        //           controller: _tabController,
        //         ),
        //       ),
        //     ),
        //     preferredSize: Size.fromHeight(48)),

      ),
      body: TabBarView(
        controller: _tabController,
        children: _pages.map((e) => e.item2).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
        onPressed: () {
          // ddlog(["a", 18, null, true, ["1", "2", "3"], {"a": "aa", "b": "bb"}]);
          // ddlog(_list);
        },
      ),
    );
  }

  List<Tuple2<String, Widget>> _pages = [
    Tuple2('功能列表', ListView.separated(
      cacheExtent: 180,
      itemCount: kAliPayList.length,
      itemBuilder: (context, index) {
        final data = kAliPayList[index];
        return ListSubtitleCell(
          padding: EdgeInsets.all(10),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              data.imageUrl,
              width: 40,
              height: 40,
            ),
          ),
          title: Text(
            data.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
          subtitle: Text(data.content,
            // maxLines: 1,
            // overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF999999),
            ),
          ),
          trailing: Text(data.time,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF999999),
            ),
          ),
          subtrailing: Text("已完成",
            style: TextStyle(
              fontSize: 13,
              color: Colors.blue,
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return DividerExt.custome();
      },
    )),

    Tuple2('升级列表', ListView.separated(
      cacheExtent: 180,
      itemCount: kUpdateAppList.length,
      itemBuilder: (context, index) {
        final data = kUpdateAppList[index];
        if (index == 0) {
          return AppUpdateCard(data: data, isExpand: true, showExpand: false,);
        }
        return AppUpdateCard(data: data);
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    )),

    Tuple2('列表(泛型)', SectionListView<String, Tuple2<String, String>>(
      headerList: _tuples.map((e) => e.item1).toList(),
      itemList: _tuples.map((e) => e.item2).toList()
          .map((e) => e.sorted((a, b) => a.item1.toLowerCase().compareTo(b.item1.toLowerCase()))).toList(),
      headerBuilder: (e) {
        return Text(e, style: TextStyle(fontWeight: FontWeight.w600),);
      },
      itemBuilder: (section, row, e) {
        return ListTile(
          title: Text(e.item2),
          subtitle: Text(e.item2.toCapitalize()),
          trailing: Icon(Icons.keyboard_arrow_right_rounded),
          dense: true,
          onTap: (){
            // Get.toNamed(e.item1, arguments: e);
            if (e.item1.toLowerCase().contains("loginPage".toLowerCase())){
              Get.offNamed(e.item1, arguments: e.item1);
            } else {
              Get.toNamed(e.item1, arguments: e.item1);
            }
          },
        );
      },
    ),),

    Tuple2('列表(折叠)', EnhanceExpandListView(
      children: _tuples.map<ExpandPanelModel<Tuple2<String, String>>>((e) => ExpandPanelModel(
      canTapOnHeader: true,
      isExpanded: false,
      arrowPosition: EnhanceExpansionPanelArrowPosition.none,
      // backgroundColor: Color(0xFFDDDDDD),
      headerBuilder: (contenx, isExpand) {
        return Container(
          // color: Colors.green,
          color: isExpand ? Colors.black12 : null,
          child: ListTile(
            title: Text("${e.item1}", style: TextStyle(fontWeight: FontWeight.bold),),
            // subtitle: Text("subtitle"),
          ),
        );
      },
      bodyChildren: e.item2,
      bodyItemBuilder: (context, e) {
        return ListTile(
          title: Text(e.item1, style: TextStyle(fontSize: 14),),
          subtitle: Text(e.item2, style: TextStyle(fontSize: 12),),
          trailing: Icon(Icons.chevron_right),
          dense: true,
          // contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
          onTap: () {
            ddlog("section_");
            if (e.item1.toLowerCase().contains("loginPage".toLowerCase())){
              Get.offNamed(e.item1, arguments: e.item1);
            } else {
              Get.toNamed(e.item1, arguments: e.item1);
            }
          });
      },
    )).toList(),)),

  ];

  void testData() {
    final String? a = null;
    ddlog(a.runtimeType);

    final String? a1 = "a1";
    ddlog(a1.runtimeType);

    final List<String>? array = null;
    ddlog(array.runtimeType);

    ddlog(a.isBlank);
    // ddlog(a.or(block: (){
    //   return "123";
    // }));
    ddlog(a.or(() => "456"));
    ddlog(a.or((){
      return "111";
    }));

    // array.or(() => null);

    final List<String>? array1 = List.generate(9, (index) => "$index");
    final result = array1!.reduce((value, element) => value + element);
    ddlog(result);

    ddlog(array.or(() => array1));

    final nums = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
    final val = nums.reduce((value, element) => value + element);
    ddlog(val);

    final map = {"a": "aa", "b": "bb", "c": "cc",} ;
    final value = map["d"] ?? "-";
    ddlog(value);
  }
}

final _tuples = [
  Tuple2("特殊功能", _specials),
  Tuple2("动画相关", _animateds),
  Tuple2("系统组件demo", _list),
  Tuple2("自定义组件", _customs),
  Tuple2("第三方组件", _vendors),
  Tuple2("其它", _others)

];

var _list = [
  Tuple2(APPRouter.alertDialogDemo, "AlertDialog", ),
  Tuple2(APPRouter.alertSheetDemo, "AlertSheet", ),
  Tuple2(APPRouter.appWebViewDemo, "appWebViewDemo", ),

  Tuple2(APPRouter.backdropFilterDemo, "backdropFilterDemo", ),

  Tuple2(APPRouter.cupertinoTabScaffoldDemo, "CupertinoTabScaffoldDemo", ),
  Tuple2(APPRouter.cupertinoFormDemo, "cupertinoFormDemo", ),
  Tuple2(APPRouter.contextMenuActionDemo, "cupertinoFormDemo", ),

  Tuple2(APPRouter.dateTableDemo, "dateTableDemo", ),
  Tuple2(APPRouter.dataTableDemoNew, "dataTableDemoNew", ),
  Tuple2(APPRouter.draggableDemo, "draggableDemo", ),
  Tuple2(APPRouter.draggableScrollableSheetDemo, "draggableScrollableSheetDemo", ),

  Tuple2(APPRouter.enlargeStrategyDemo, "enlargeStrategyDemo", ),
  Tuple2(APPRouter.expandIconDemo, "expandIconDemo", ),
  Tuple2(APPRouter.expandIconDemoNew, "ExpandIconDemoNew", ),

  Tuple2(APPRouter.gridViewDemo, "GridView", ),
  Tuple2(APPRouter.gridPaperDemo, "gridPaperDemo", ),

  Tuple2(APPRouter.menuDemo, "MenuDemo", ),

  Tuple2(APPRouter.pageViewDemo, "PageViewDemo", ),
  Tuple2(APPRouter.pageViewTabBarWidget, "PageViewTabBarWidget", ),

  Tuple2(APPRouter.pickerDemo, "pickerDemo", ),
  Tuple2(APPRouter.progressHudDemo, "ProgressHudDemo", ),
  Tuple2(APPRouter.progressHudDemoNew, "ProgressHudDemoNew", ),
  Tuple2(APPRouter.progressIndicatorDemo, "ProgressIndicatorDemo", ),

  Tuple2(APPRouter.reorderableListViewDemo, "reorderableListViewDemo", ),
  Tuple2(APPRouter.recordListDemo, "textFieldDemo", ),
  Tuple2(APPRouter.rangerSliderDemo, "rangerSliderDemo", ),

  Tuple2(APPRouter.segmentControlDemo, "segmentControlDemo", ),
  Tuple2(APPRouter.snackBarDemo, "SnackBar", ),
  Tuple2(APPRouter.stepperDemo, "stepperDemo", ),
  Tuple2(APPRouter.slidableDemo, "SlidableDemo", ),
  Tuple2(APPRouter.sliverAppBarDemo, "SliverAppBarDemo", ),
  Tuple2(APPRouter.sliverFamilyDemo, "SliverFamilyDemo", ),
  Tuple2(APPRouter.sliverFamilyPageViewDemo, "sliverFamilyPageViewDemo", ),
  Tuple2(APPRouter.sliverPersistentHeaderDemo, "sliverPersistentHeaderDemo", ),

  Tuple2(APPRouter.tabBarDemo, "tabBarDemo", ),
  Tuple2(APPRouter.textlessDemo, "textlessDemo", ),
  Tuple2(APPRouter.textFieldDemo, "textFieldDemo", ),

  Tuple2(APPRouter.layoutBuilderDemo, "layoutBuilderDemo", ),
  Tuple2(APPRouter.tableDemo, "tableDemo", ),
  Tuple2(APPRouter.nestedScrollViewDemo, "nestedScrollViewDemo", ),

  Tuple2(APPRouter.popoverDemo, "popoverDemo", ),
  Tuple2(APPRouter.absorbPointerDemo, "absorbPointerDemo", ),
  Tuple2(APPRouter.willPopScopeDemo, "willPopScopeDemo", ),

  Tuple2(APPRouter.futureBuilderDemo, "futureBuilderDemo", ),
  Tuple2(APPRouter.streamBuilderDemo, "streamBuilderDemo", ),
  Tuple2(APPRouter.bannerDemo, "bannerDemo", ),

  Tuple2(APPRouter.indexedStackDemo, "indexedStackDemo", ),
  Tuple2(APPRouter.responsiveColumnDemo, "responsiveColumnDemo", ),
  Tuple2(APPRouter.offstageDemo, "offstageDemo", ),
  Tuple2(APPRouter.bottomAppBarDemo, "bottomAppBarDemo", ),
  Tuple2(APPRouter.calendarDatePickerDemo, "calendarDatePickerDemo", ),
  Tuple2(APPRouter.chipDemo, "chipDemo", ),
  Tuple2(APPRouter.chipFilterDemo, "chipFilterDemo", ),
  Tuple2(APPRouter.bottomSheetDemo, "bottomSheetDemo", ),
  Tuple2(APPRouter.timePickerDemo, "timePickerDemo", ),
  Tuple2(APPRouter.shaderMaskDemo, "ShaderMaskDemo", ),
  Tuple2(APPRouter.blurViewDemo, "blurViewDemo", ),
  Tuple2(APPRouter.boxDemo, "boxDemo", ),
  Tuple2(APPRouter.mouseRegionDemo, "mouseRegionDemo", ),
  Tuple2(APPRouter.navigationBarDemo, "navigationBarDemo", ),
];

var _specials = [
  Tuple2(APPRouter.systemIconsPage, "flutter 系统 Icons", ),
  Tuple2(APPRouter.systemColorPage, "flutter 系统 颜色", ),
  Tuple2(APPRouter.localImagePage, "本地图片", ),
  Tuple2(APPRouter.providerRoute, "providerRoute", ),
  Tuple2(APPRouter.stateManagerDemo, "状态管理", ),

  Tuple2(APPRouter.tabBarPageViewDemo, "tabBarPageViewDemo", ),
  Tuple2(APPRouter.tabBarReusePageDemo, "tabBarReusePageDemo", ),

  Tuple2(APPRouter.githubRepoDemo, "githubRepoDemo", ),
  Tuple2(APPRouter.hitTest, "hitTest", ),
  Tuple2(APPRouter.constrainedBoxDemo, "constrainedBoxDemo", ),
  Tuple2(APPRouter.flutterFFiTest, "ffi", ),
  Tuple2(APPRouter.mergeImagesDemo, "图像合并", ),
  Tuple2(APPRouter.mergeNetworkImagesDemo, "网络图像合并", ),

];

var _animateds = [
  // Tuple2(APPRouter.animatedIconDemo, "AnimatedIconDemo", ),
  Tuple2(APPRouter.animatedDemo, "animatedDemo", ),

  Tuple2(APPRouter.animatedSwitcherDemo, "animatedSwitcherDemo", ),
  Tuple2(APPRouter.animatedWidgetDemo, "animatedWidgetDemo", ),
  Tuple2(APPRouter.animatedGroupDemo, "animatedGroupDemo", ),

];

var _customs = [
  Tuple2(APPRouter.datePickerPage, "DatePickerPage", ),
  Tuple2(APPRouter.dateTimeDemo, "dateTimeDemo", ),
  Tuple2(APPRouter.hudProgressDemo, "HudProgressDemo", ),
  Tuple2(APPRouter.localNotifationDemo, "localNotifationDemo", ),
  Tuple2(APPRouter.locationPopView, "locationPopView", ),
  Tuple2(APPRouter.numberStepperDemo, "NumberStepperDemo", ),
  Tuple2(APPRouter.numberFormatDemo, "numberFormatDemo", ),
  Tuple2(APPRouter.steperConnectorDemo, "steperConnectorDemo", ),

];

var _vendors = [
  Tuple2(APPRouter.timelinesDemo, "timelinesDemo", ),
  Tuple2(APPRouter.timelineDemo, "timelineDemo", ),
  Tuple2(APPRouter.qrCodeScannerDemo, "扫描二维码", ),
  Tuple2(APPRouter.qrFlutterDemo, "生成二维码", ),
  Tuple2(APPRouter.scribbleDemo, "scribble 画板", ),
  Tuple2(APPRouter.aestheticDialogsDemo, "aestheticDialogs 对话框", ),
  Tuple2(APPRouter.customTimerDemo, "自定义计时器", ),
  Tuple2(APPRouter.skeletonDemo, "骨架屏", ),
  Tuple2(APPRouter.smartDialogPageDemo, "弹窗", ),
];

var _others = [
  Tuple2(APPRouter.borderDemo, "buttonBorderDemo", ),
  Tuple2(APPRouter.clipDemo, "clipDemo", ),

  Tuple2(APPRouter.transparentNavgationBarDemo, "transparentNavgationBarDemo", ),
  Tuple2(APPRouter.richTextDemo, "richTextDemo", ),
  Tuple2(APPRouter.loginPage, "LoginPage", ),
  Tuple2(APPRouter.loginPage2, "LoginPage2", ),
  Tuple2(APPRouter.testPage, "testPage", ),

];
