//
//  TabBarTabBarViewDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/22/21 2:32 PM.
//  Copyright © 10/22/21 shang. All rights reserved.
//

import 'package:enhance_expansion_panel/enhance_expansion_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/ExpandButtons/expand_icons.dart';
import 'package:flutter_templet_project/basicWidget/ExpandButtons/expand_layout.dart';
import 'package:flutter_templet_project/basicWidget/list_subtitle_cell.dart';
import 'package:flutter_templet_project/basicWidget/app_update_card.dart';
import 'package:flutter_templet_project/basicWidget/section_list_view.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';

import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/divider_ext.dart';
import 'package:flutter_templet_project/extension/list_ext.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/object_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';

import 'package:flutter_templet_project/main.dart';
import 'package:flutter_templet_project/model/mock_data.dart';
import 'package:flutter_templet_project/routes/APPRouter.dart';

import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

import 'package:flutter_templet_project/pages/demo/AutocompleteDemo.dart';


class TabBarTabBarViewDemo extends StatefulWidget {
  const TabBarTabBarViewDemo({Key? key}) : super(key: key);

  @override
  _TabBarTabBarViewDemoState createState() => _TabBarTabBarViewDemoState();
}

class _TabBarTabBarViewDemoState extends State<TabBarTabBarViewDemo> with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: items.length, vsync: this);

  final textEditingController = TextEditingController();

  // late PageController _pageController = PageController(initialPage: 0, keepPage: true);

  // late List<String> _titles = getTitlesOfTuples();

  late final List<Tuple2<String, Widget>> items = [
    Tuple2('功能列表', buildPage1()),
    Tuple2('升级列表', buildPage2()),
    Tuple2('列表搜索', buildPage3()),
    Tuple2('列表(折叠)', buildPage4()),
  ];

  @override
  void initState() {
    super.initState();

    _tabController.index = items.length - 2;
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
        // titleTextStyle: TextStyle(color: Colors.red),
        // toolbarTextStyle: TextStyle(color: Colors.orange),
        // iconTheme: IconThemeData(color: Colors.green),
        actionsIconTheme: IconThemeData(color: Colors.yellow),
        title: Text('基础组件列表'),
        leading: Builder(builder: (context) {

          return IconButton(
            icon: Icon(Icons.menu, color: Colors.white), //自定义图标
            onPressed: () {
              kScaffoldKey.currentState?.openDrawer();
            },
          );
        }),
        actions: [
          TextButton(
            onPressed: (){
              Get.toNamed(APPRouter.stateManagerDemo, arguments: "状态管理");
            },
            child: Text("状态管理",
              style: TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            onPressed: () => debugPrint("aa"),
            icon: Icon(Icons.ac_unit),
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: items.map((e) => Tab(
              key: PageStorageKey<String>(e.item1),
              text: e.item1
          )).toList(),
          // indicatorSize: TabBarIndicatorSize.label,
          // indicatorPadding: EdgeInsets.only(left: 6, right: 6),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: items.map((e) => e.item2).toList(),
      ),
      // floatingActionButton: FloatingActionButton(
      //   tooltip: 'Increment',
      //   onPressed: () {
      //     Scaffold.of(context).openEndDrawer();
      //   },
      //   child: Icon(Icons.add),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      // floatingActionButton: _buildFab(isTop: true),
    );
  }

  Widget _buildFab({bool isTop = true}) {
    final icons = [ Icons.sms, Icons.mail, Icons.phone ];
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (context, offset) {

        final dy = isTop ? offset.dy - icons.length * 35.0 : offset.dy + icons.length * 35.0;
        return CenterAbout(
          position: Offset(offset.dx, dy),
          child: ExpandIcons(
            items: icons,
            onItem: (i){
              debugPrint("i: $i");
            },
          ),
        );
      },
      child: FloatingActionButton(
        onPressed: () { },
        tooltip: 'Increment',
        child: Icon(Icons.add),
        elevation: 2.0,
      ),
    );
  }

  buildPage1() {
    return ListView.separated(
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
              color: context.colorScheme.onSurface,
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
        return Divider();
      },
    );
  }

  buildPage2() {
    return ListView.separated(
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
    );
  }

  buildPage3() {
    return AutocompleteDemo(
      hideAppBar: true,
      routingCallback: (val) {
        if (val.name == APPRouter.componentMiddlePage) {
          Get.toNamed(val.name,
              arguments: {
                ...val.toJson(),
                "onSkip": onSkip,
                "header": buildHeader(),
              },
          );
          return;
        }
        Get.toNamed(val.name, arguments: val.toJson());
      },
    );
  }

  Widget buildHeader() {
    return ElevatedButton(
        onPressed: (){
          ddlog("buildHeader");
        },
        child: Text("header_${IntExt.random(max: 100)}")
    );
  }

  onSkip() {
    Get.back();
  }

  buildPage4() {
    return EnhanceExpandListView(
      children: tuples.map<ExpandPanelModel<Tuple2<String, String>>>((e) => ExpandPanelModel(
        canTapOnHeader: true,
        isExpanded: false,
        arrowPosition: EnhanceExpansionPanelArrowPosition.none,
        // backgroundColor: Color(0xFFDDDDDD),
        headerBuilder: (contenx, isExpand) {
          final trailing = isExpand ? Icon(Icons.keyboard_arrow_up, color: Colors.blue) :
          Icon(Icons.keyboard_arrow_down, color: Colors.blue,);
          return Container(
            // color: Colors.green,
            color: isExpand ? Colors.black12 : null,
            child: ListTile(
              title: Text(e.item1, style: TextStyle(fontWeight: FontWeight.bold),),
              // subtitle: Text("subtitle"),
              trailing: trailing,
            ),
          );
        },
        bodyChildren: e.item2.sorted((a, b) => a.item1.toLowerCase().compareTo(b.item1.toLowerCase())),
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
            }
          );
        },
      )).toList(),
    );
  }

  List<String> getTitles({required List<Tuple2<String, List<Tuple2<String, String>>>> tuples}) {
    final titles = tuples.expand((e) => e.item2.map((e) => e.item1)).toList();
    final result = List<String>.from(titles.sorted());
    // print('titles runtimeType:${titles.runtimeType},${titles.every((element) => element is String)},');
    debugPrint('result runtimeType:${result.runtimeType}');
    return result;
  }

  testData() {
    const String? a = null;
    ddlog(a.runtimeType);

    const String? a1 = "a1";
    ddlog(a1.runtimeType);

    const List<String>? array = null;
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

/// 元祖总数组
var tuples = <Tuple2<String, List<Tuple2<String, String>>>>[
  Tuple2("数据类型", dataTypes),
  Tuple2("特殊功能", specials),
  Tuple2("动画相关", animateds),
  Tuple2("系统组件 demo", list),
  Tuple2("系统组件 sliver", slivers),
  Tuple2("自定义组件", customs),
  Tuple2("第三方组件", vendors),
  Tuple2("表单", forms),
  Tuple2("其它", others)

];


var list = <Tuple2<String, String>>[

  Tuple2(APPRouter.textDemo, "textDemo", ),
  Tuple2(APPRouter.materialDemo, "materialDemo", ),
  Tuple2(APPRouter.alertDialogDemo, "AlertDialog", ),
  Tuple2(APPRouter.alertDialogTagSelectDemo, "alertDialogTagSelectDemo", ),
  Tuple2(APPRouter.appBarDemo, "appBarDemo", ),
  Tuple2(APPRouter.alertSheetDemo, "AlertSheet", ),
  Tuple2(APPRouter.appWebViewDemo, "appWebViewDemo", ),
  Tuple2(APPRouter.builderDemo, "builderDemo", ),
  Tuple2(APPRouter.badgeDemo, "badgeDemo", ),
  Tuple2(APPRouter.backdropFilterDemo, "backdropFilterDemo", ),
  Tuple2(APPRouter.cupertinoTabScaffoldDemo, "CupertinoTabScaffoldDemo", ),
  Tuple2(APPRouter.cupertinoFormDemo, "cupertinoFormDemo", ),
  Tuple2(APPRouter.contextMenuActionDemo, "cupertinoFormDemo", ),

  Tuple2(APPRouter.dataTableDemo, "dateTableDemo", ),
  Tuple2(APPRouter.dataTableByPaginatedDemo, "dataTableByPaginatedDemo", ),
  Tuple2(APPRouter.draggableDemo, "draggableDemo", ),
  Tuple2(APPRouter.draggableScrollableSheetDemo, "draggableScrollableSheetDemo", ),

  Tuple2(APPRouter.expandIconDemo, "expandIconDemo", ),
  Tuple2(APPRouter.expandIconDemoNew, "ExpandIconDemoNew", ),

  Tuple2(APPRouter.gridViewDemo, "GridView", ),
  Tuple2(APPRouter.gridPaperDemo, "gridPaperDemo", ),

  Tuple2(APPRouter.menuDemo, "MenuDemo", ),

  Tuple2(APPRouter.pageViewDemo, "PageViewDemo", ),
  Tuple2(APPRouter.pageViewDemoOne, "pageViewDemoOne", ),
  Tuple2(APPRouter.pageViewDemoThree, "PageViewDemoThree", ),

  Tuple2(APPRouter.pickerDemo, "pickerDemo", ),
  Tuple2(APPRouter.progressHudDemo, "ProgressHudDemo", ),
  Tuple2(APPRouter.progressHudDemoNew, "ProgressHudDemoNew", ),
  Tuple2(APPRouter.indicatorDemo, "indicatorDemo", ),

  Tuple2(APPRouter.reorderableListViewDemo, "reorderableListViewDemo", ),
  Tuple2(APPRouter.listDismissibleDemo, "recordListDemo", ),

  Tuple2(APPRouter.segmentControlDemo, "segmentControlDemo", ),
  Tuple2(APPRouter.segmentedButtonDemo, "SegmentedButtonDemo", ),

  Tuple2(APPRouter.snackBarDemo, "SnackBar", ),
  Tuple2(APPRouter.snackBarDemoOne, "SnackBar封装", ),
  Tuple2(APPRouter.sliderDemo, "sliderDemo", ),
  Tuple2(APPRouter.stepperDemo, "stepperDemo", ),
  Tuple2(APPRouter.slidableDemo, "SlidableDemo", ),

  Tuple2(APPRouter.tabBarDemo, "tabBarDemo", ),

  Tuple2(APPRouter.textlessDemo, "textlessDemo", ),
  Tuple2(APPRouter.textFieldDemo, "textFieldDemo", ),
  Tuple2(APPRouter.textFieldDemoOne, "textFieldDemoOne", ),

  Tuple2(APPRouter.layoutBuilderDemo, "layoutBuilderDemo", ),
  Tuple2(APPRouter.tableDemo, "tableDemo", ),
  Tuple2(APPRouter.nestedScrollViewDemo, "nestedScrollViewDemo", ),

  Tuple2(APPRouter.absorbPointerDemo, "absorbPointerDemo", ),
  Tuple2(APPRouter.willPopScopeDemo, "willPopScopeDemo", ),

  Tuple2(APPRouter.futureBuilderDemo, "futureBuilderDemo", ),
  Tuple2(APPRouter.streamBuilderDemo, "streamBuilderDemo", ),

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
  Tuple2(APPRouter.shortcutsDemo, "shortcutsDemo", ),
  Tuple2(APPRouter.shortcutsDemoOne, "shortcutsDemoOne", ),
  Tuple2(APPRouter.transformDemo, "动画", ),
  Tuple2(APPRouter.fittedBoxDemo, "fittedBox", ),
  Tuple2(APPRouter.coloredBoxDemo, "coloredBoxDemo", ),
  Tuple2(APPRouter.positionedDirectionalDemo, "positionedDirectionalDemo", ),
  Tuple2(APPRouter.statefulBuilderDemo, "statefulBuilderDemo", ),
  Tuple2(APPRouter.valueListenableBuilderDemo, "valueListenableBuilderDemo", ),
  Tuple2(APPRouter.overflowBarDemo, "水平溢出自动垂直排列", ),
  Tuple2(APPRouter.navigationToolbarDemo, "navigationToolbar", ),
  Tuple2(APPRouter.selectableTextDemo, "文字选择", ),
  Tuple2(APPRouter.materialBannerDemo, "一个 Banner", ),
  Tuple2(APPRouter.autocompleteDemo, "自动填写", ),
  Tuple2(APPRouter.rotatedBoxDemo, "rotatedBoxDemo", ),
  Tuple2(APPRouter.dismissibleDemo, "左滑删除", ),
  Tuple2(APPRouter.modalBarrierDemo, "静态蒙版", ),
  Tuple2(APPRouter.bannerDemo, "角落价格标签", ),
  Tuple2(APPRouter.listViewDemo, "listView", ),
  Tuple2(APPRouter.listViewStyleDemo, "listViewStyleDemo", ),
  Tuple2(APPRouter.builderDemo, "各种回调 builder", ),
  Tuple2(APPRouter.stackDemo, "StackDemo", ),
  Tuple2(APPRouter.stackDemoOne, "stackDemoOne", ),
  Tuple2(APPRouter.stackDemoTwo, "stackDemoTwo", ),
  Tuple2(APPRouter.wrapDemo, "流水自动换行", ),
  Tuple2(APPRouter.inheritedWidgetDemo, "inheritedWidgetDemo 数据共享", ),
  Tuple2(APPRouter.notificationListenerDemo, "notificationListenerDemo 数据共享", ),
  Tuple2(APPRouter.notificationCustomDemo, "notificationCustomDemo 自定义通知", ),
  Tuple2(APPRouter.scrollbarDemo, "scrollbarDemo 滚动指示器监听", ),
  Tuple2(APPRouter.intrinsicHeightDemo, "intrinsicHeightDemo", ),
  Tuple2(APPRouter.flexDemo, "flex 布局", ),
  Tuple2(APPRouter.flexibleDemo, "flexible 布局", ),
  Tuple2(APPRouter.physicalModelDemo, "physicalModelDemo", ),
  Tuple2(APPRouter.visibilityDemo, "visibilityDemo", ),
  Tuple2(APPRouter.ignorePointerDemo, "ignorePointerDemo", ),
  Tuple2(APPRouter.boxShadowDemo, "BoxShadow 阴影", ),
  Tuple2(APPRouter.borderDemo, "buttonBorderDemo", ),
  Tuple2(APPRouter.overflowDemo, "overflowDemo", ),
  Tuple2(APPRouter.flexibleSpaceDemo, "flexibleSpaceDemo", ),
  Tuple2(APPRouter.nnHorizontalScrollWidgetDemo, "nnHorizontalScrollWidgetDemo", ),
  Tuple2(APPRouter.interactiveViewerDemo, "图片缩放", ),
  Tuple2(APPRouter.dateRangePickerDialogDemo, "日期范围组件", ),
  Tuple2(APPRouter.mergeableMaterialDemo, "mergeableMaterialDemo", ),
  Tuple2(APPRouter.navigationRailDemo, "navigationRailDemo", ),
  Tuple2(APPRouter.listTileDemo, "listTileDemo", ),
  Tuple2(APPRouter.refreshIndicatorDemo, "refreshIndicatorDemo", ),
  Tuple2(APPRouter.refreshIndicatorDemoOne, "refreshIndicatorDemoOne", ),
  Tuple2(APPRouter.showSearchDemo, "showSearchDemo", ),
  Tuple2(APPRouter.tooltipDemo, "tooltipDemo", ),
  Tuple2(APPRouter.filterDemo, "filteredDemo", ),
  Tuple2(APPRouter.filterDemoOne, "NNFilterDemoOne", ),
  Tuple2(APPRouter.fractionallySizedBoxDemo, "fractionallySizedBoxDemo", ),
  Tuple2(APPRouter.listWheelScrollViewDemo, "listWheelScrollViewDemo", ),
  Tuple2(APPRouter.nnsliverPersistentHeaderDemo, "nnsliverPersistentHeaderDemo", ),
  Tuple2(APPRouter.nestedScrollViewDemoOne, "nestedScrollViewDemoOne", ),
  Tuple2(APPRouter.nestedScrollViewDemoTwo, "nestedScrollViewDemoTwo", ),
  Tuple2(APPRouter.expansionTileCard, "expansionTileCard", ),
  Tuple2(APPRouter.dropBoxChoicDemo, "下拉菜单", ),
  Tuple2(APPRouter.dropBoxMutiRowChoicDemo, "下拉菜单多行选择", ),
  Tuple2(APPRouter.customSingleChildLayoutDemo, "customSingleChildLayoutDemo", ),
  Tuple2(APPRouter.customMultiChildLayoutDemo, "customMultiChildLayoutDemo", ),
  Tuple2(APPRouter.pageBuilderDemo, "pageBuilderDemo", ),
  Tuple2(APPRouter.npageViewDemo, "npageViewDemo", ),
  Tuple2(APPRouter.boxShadowDemoOne, "boxShadowDemoOne", ),
  Tuple2(APPRouter.scaffoldBottomSheet, "scaffoldBottomSheet", ),
  Tuple2(APPRouter.floatingActionButtonDemo, "floatingActionButtonDemo", ),
  Tuple2(APPRouter.dropdownMenuDemo, "dropdownMenuDemo", ),
  Tuple2(APPRouter.searchDemo, "searchDemo", ),
  Tuple2(APPRouter.switchDemo, "switchDemo", ),
  Tuple2(APPRouter.gestureDetectorDemo, "gestureDetectorDemo", ),
  Tuple2(APPRouter.compositedTransformTargetDemo, "compositedTransformTargetDemo", ),
  Tuple2(APPRouter.contextMenuDemo, "contextMenuDemo", ),
  Tuple2(APPRouter.targetFollowerDemo, "targetFollowerDemo", ),
  Tuple2(APPRouter.tapRegionDemo, "tapRegionDemo", ),
  Tuple2(APPRouter.glowingOverscrollIndicatorDemo, "glowingOverscrollIndicatorDemo", ),
  Tuple2(APPRouter.progressClipperDemo, "progressClipperDemo", ),
  Tuple2(APPRouter.heroDemo, "heroDemo", ),
  Tuple2(APPRouter.hitTestBehaviorDemo, "hitTestBehaviorDemo", ),
  Tuple2(APPRouter.qrcodePage, "qrcodePage", ),
  Tuple2(APPRouter.menuAnchorDemo, "menuAnchorDemo", ),
  Tuple2(APPRouter.myMenuBarDemo, "myMenuBarDemo", ),
  Tuple2(APPRouter.overlayPortalDemo, "overlayPortalDemo", ),
  Tuple2(APPRouter.componentMiddlePage, "componentMiddlePage", ),
  Tuple2(APPRouter.displayFeatureDemo, "displayFeatureDemo", ),
  Tuple2(APPRouter.preferredSizeDemo, "preferredSizeDemo", ),
  Tuple2(APPRouter.ntabBarPageDemo, "ntabBarPageDemo", ),
  Tuple2(APPRouter.nTabBarViewCustomDemo, "nTabBarViewCustomDemo", ),
  Tuple2(APPRouter.textFieldTabDemo, "textFieldTabDemo", ),
  Tuple2(APPRouter.textPaintDemo, "textPaintDemo", ),
  Tuple2(APPRouter.segmentedPageViewDemo, "segmentedPageViewDemo", ),
  Tuple2(APPRouter.nRefreshListViewDemo, "nRefreshListViewDemo", ),
  Tuple2(APPRouter.nestedScrollViewDemoThree, "nestedScrollPageDemo", ),


];

var slivers = <Tuple2<String, String>>[
  Tuple2(APPRouter.sliverFamilyDemo, "SliverFamilyDemo", ),
  Tuple2(APPRouter.sliverMainAxisGroupDemo, "sliverMainAxisGroupDemo", ),
  Tuple2(APPRouter.twoDimensionalGridViewDemo, "twoDimensionalGridViewDemo", ),
  Tuple2(APPRouter.listenerHeaderPage, "listenerHeaderPage", ),
  Tuple2(APPRouter.nPinnedTabBarPageDemo, "nPinnedTabBarPageDemo", ),


];

var specials = <Tuple2<String, String>>[
  Tuple2(APPRouter.yamlParsePage, "yaml解析", ),
  Tuple2(APPRouter.appLifecycleObserverDemo, "appLifecycleObserverDemo", ),
  Tuple2(APPRouter.themeColorDemo, "themeColor", ),
  Tuple2(APPRouter.emojiPage, "emoji", ),
  Tuple2(APPRouter.operatorDemo, "特殊操作符", ),
  Tuple2(APPRouter.mediaQueryDemo, "mediaQuery", ),
  Tuple2(APPRouter.mediaQueryDemoOne, "mediaQuery键盘", ),
  Tuple2(APPRouter.appRouteObserverDemo, "页面路由监听", ),
  Tuple2(APPRouter.appRouteObserverDemoOne, "页面路由监听1", ),
  Tuple2(APPRouter.pageLifecycleObserverDemo, "页面生命周期监听", ),
  Tuple2(APPRouter.pageLifecycleFuncTest, "页面生命方法测试", ),
  Tuple2(APPRouter.systemIconsPage, "flutter 系统 Icons", ),
  Tuple2(APPRouter.systemColorPage, "flutter 系统 颜色", ),
  Tuple2(APPRouter.systemCurvesPage, "flutter Curves动画效果", ),

  Tuple2(APPRouter.localImagePage, "本地图片", ),
  Tuple2(APPRouter.providerRoute, "providerRoute", ),
  Tuple2(APPRouter.stateManagerDemo, "状态管理", ),

  Tuple2(APPRouter.tabBarPageViewDemo, "tabBarPageViewDemo", ),
  Tuple2(APPRouter.tabBarReusePageDemo, "tabBarReusePageDemo", ),

  Tuple2(APPRouter.githubRepoDemo, "githubRepoDemo", ),
  Tuple2(APPRouter.hitTest, "hitTest", ),
  Tuple2(APPRouter.textViewDemo, "textViewDemo", ),
  Tuple2(APPRouter.flutterFFiTest, "ffi", ),
  Tuple2(APPRouter.mergeImagesDemo, "图像合并", ),
  Tuple2(APPRouter.mergeNetworkImagesDemo, "网络图像合并", ),
  Tuple2(APPRouter.drawImageNineDemo, "图像拉伸", ),
  Tuple2(APPRouter.promptBuilderDemo, "指引模板", ),
  Tuple2(APPRouter.isolateDemo, "isolateDemo", ),
  Tuple2(APPRouter.overlayDemo, "overlay弹窗", ),
  Tuple2(APPRouter.boxConstraintsDemo, "boxConstraints", ),
  Tuple2(APPRouter.gradientDemo, "渐变色", ),
  Tuple2(APPRouter.imageBlendModeDemo, "图片渲染模式", ),
  Tuple2(APPRouter.containerDemo, "containerDemo", ),
  Tuple2(APPRouter.animatedContainerDemo, "animatedContainerDemo", ),
  Tuple2(APPRouter.scrollControllerDemo, "滚动行为", ),
  Tuple2(APPRouter.buttonStyleDemo, "按钮样式研究", ),
  Tuple2(APPRouter.keyDemo, "key研究", ),

  Tuple2(APPRouter.netStateListenerDemo, "netStateListenerDemo", ),
  Tuple2(APPRouter.netStateListenerDemoOne, "mixin监听网络", ),
  Tuple2(APPRouter.reflectDemo, "模型属性动态化赋值", ),
  Tuple2(APPRouter.testFunction, "方法动态化", ),
  Tuple2(APPRouter.pageViewAndBarDemo, "pageViewAndBarDemo", ),
  Tuple2(APPRouter.mediaQueryScreeenDemo, "屏幕尺寸研究", ),
  Tuple2(APPRouter.neomorphismHomePage, "拟物风格", ),
  Tuple2(APPRouter.refreshListView, "refreshListView", ),
  Tuple2(APPRouter.globalIsolateDemo, "globalIsolateDemo", ),
  Tuple2(APPRouter.longCaptureWidgetDemo, "widget长截图", ),
  Tuple2(APPRouter.imageStretchDemo, "图片拉伸", ),
  Tuple2(APPRouter.drawCanvasDemo, "drawCanvas", ),

  Tuple2(APPRouter.todoListTabPage, "todoListTabPage", ),
  Tuple2(APPRouter.studentTabPage, "studentTabPage", ),
  Tuple2(APPRouter.orderListTabPage, "orderListTabPage", ),


];

var animateds = <Tuple2<String, String>>[
  // Tuple2(APPRouter.animatedIconDemo, "AnimatedIconDemo", ),
  Tuple2(APPRouter.animatedDemo, "animatedDemo", ),

  Tuple2(APPRouter.animatedSwitcherDemo, "animatedSwitcherDemo", ),
  Tuple2(APPRouter.animatedWidgetDemo, "animatedWidgetDemo", ),
  Tuple2(APPRouter.animatedGroupDemo, "animatedGroupDemo", ),
  Tuple2(APPRouter.animatedBuilderDemo, "animatedBuilderDemo", ),
  Tuple2(APPRouter.animatedListDemo, "animatedListDemo", ),
  Tuple2(APPRouter.animatedListSample, "animatedListSample", ),
  Tuple2(APPRouter.animatedStaggerDemo, "staggerDemo", ),
  Tuple2(APPRouter.animatedSizeDemo, "animatedSizeDemo", ),
  Tuple2(APPRouter.animatedSizeDemoOne, "animatedSizeDemoOne", ),


];

var customs = [
  Tuple2(APPRouter.datePickerPage, "DatePickerPage", ),
  Tuple2(APPRouter.dateTimeDemo, "dateTimeDemo", ),
  Tuple2(APPRouter.hudProgressDemo, "HudProgressDemo", ),
  Tuple2(APPRouter.localNotifationDemo, "localNotifationDemo", ),
  Tuple2(APPRouter.locationPopView, "locationPopView", ),
  Tuple2(APPRouter.numberStepperDemo, "商品计数器", ),
  Tuple2(APPRouter.numberFormatDemo, "数字格式化", ),
  Tuple2(APPRouter.steperConnectorDemo, "steperConnectorDemo", ),
  Tuple2(APPRouter.customSwipperDemo, "自定义轮播", ),
  Tuple2(APPRouter.neumorphismDemo, "拟物按钮", ),
  Tuple2(APPRouter.horizontalCellDemo, "水平 cell 布局", ),
  Tuple2(APPRouter.listViewOneDemo, "跑马灯效果", ),
  Tuple2(APPRouter.marqueeWidgetDemo, "跑马灯效果", ),
  Tuple2(APPRouter.ticketDemo, "券", ),
  Tuple2(APPRouter.myPopverDemo, "弹窗测试", ),
  Tuple2(APPRouter.customScrollBarDemo, "自定义 ScrollBar", ),
  Tuple2(APPRouter.enhanceTabBarDemo, "Tab 指示器支持固定宽度", ),
  Tuple2(APPRouter.collectionNavWidgetDemo, "图文导航", ),
  Tuple2(APPRouter.boxWidgetDemo, "boxWidgetDemo", ),
  Tuple2(APPRouter.nSkeletonDemo, "骨架图", ),
  Tuple2(APPRouter.nTreeDemo, "树形组件", ),
  Tuple2(APPRouter.dialogChoiceChipDemo, "选择弹窗", ),
  Tuple2(APPRouter.imChatPage, "聊天列表", ),
  Tuple2(APPRouter.expandTextDemo, "可折叠文字", ),
  Tuple2(APPRouter.suspensionButtonDemo, "悬浮按钮", ),
  Tuple2(APPRouter.uploadFileDemo, "上传demo", ),
  Tuple2(APPRouter.jsonToDartPage, "json转模型", ),
  Tuple2(APPRouter.assetUploadBoxDemo, "assetUploadBoxDemo", ),
  Tuple2(APPRouter.dashLineDemo, "dashLineDemo", ),
  Tuple2(APPRouter.choiceBoxOneDemo, "choiceBoxOneDemo", ),
  Tuple2(APPRouter.apiConvertPage, "APIConvertPage", ),
  Tuple2(APPRouter.selectListPage, "selectListPage", ),
  Tuple2(APPRouter.indexAvatarGroupDemo, "indexAvatarGroupDemo", ),
  Tuple2(APPRouter.appBarColorChangerDemo, "appBarColorChangerDemo", ),
  Tuple2(APPRouter.footerButtonBarDemo, "footerButtonBarDemo", ),
  Tuple2(APPRouter.sectionHeaderDemo, "sectionHeaderDemo", ),
  Tuple2(APPRouter.nwebViewDemo, "nwebViewDemo", ),
  Tuple2(APPRouter.iconConvertPage, "iconConvertPage", ),
  Tuple2(APPRouter.alignmentDrawDemo, "alignmentDrawDemo", ),

];

var vendors = <Tuple2<String, String>>[
  Tuple2(APPRouter.carouselSliderDemo, "carouselSliderDemo", ),
  Tuple2(APPRouter.timelinesDemo, "timelinesDemo", ),
  Tuple2(APPRouter.timelineDemo, "timelineDemo", ),
  Tuple2(APPRouter.qrCodeScannerDemo, "扫描二维码", ),
  Tuple2(APPRouter.qrFlutterDemo, "生成二维码", ),
  Tuple2(APPRouter.scribbleDemo, "scribble 画板", ),
  Tuple2(APPRouter.aestheticDialogsDemo, "aestheticDialogs 对话框", ),
  Tuple2(APPRouter.customTimerDemo, "自定义计时器", ),
  Tuple2(APPRouter.skeletonDemo, "骨架屏", ),
  Tuple2(APPRouter.smartDialogPageDemo, "弹窗", ),
  Tuple2(APPRouter.ratingBarDemo, "星评", ),
  Tuple2(APPRouter.dragAndDropDemo, "文件拖拽", ),
  Tuple2(APPRouter.popoverDemo, "popoverDemo", ),
  Tuple2(APPRouter.badgesDemo, "badgesDemo", ),
  Tuple2(APPRouter.flutterSwiperDemo, "flutterSwiperDemo", ),
  Tuple2(APPRouter.flutterSwiperIndicatorDemo, "flutterSwiperIndicatorDemo", ),
  Tuple2(APPRouter.visibilityDetectorDemo, "visibilityDetector 曝光检测", ),
  Tuple2(APPRouter.svgaImageDemo, "svgaImageDemo", ),
  Tuple2(APPRouter.providerDemo, "状态管理 - provider", ),
  Tuple2(APPRouter.providerDemoOne, "状态管理 - providerDemoOne", ),
  Tuple2(APPRouter.colorConverterDemo, "颜色转换", ),
  Tuple2(APPRouter.wechatAssetsPickerDemo, "微信相册选择器", ),
  Tuple2(APPRouter.wechatPhotoPickerDemo, "微信相册选择器组件封装", ),
  Tuple2(APPRouter.azlistviewDemo, "分组列表", ),
  Tuple2(APPRouter.slidableDemoOne, "滑动菜单", ),
  Tuple2(APPRouter.soundPlayDemo, "声音播放", ),
  Tuple2(APPRouter.wPopupMenuDemo, "微信聊天长按弹出框", ),
  Tuple2(APPRouter.syncfusionFlutterDatepickerDemo, "日期多选", ),
  Tuple2(APPRouter.tableCalenderMain, "日期", ),
  Tuple2(APPRouter.keyboardAttachDemo, "keyboardAttachableDemo", ),
  Tuple2(APPRouter.getxDemo, "getxDemo", ),
  Tuple2(APPRouter.flutterPickersDemo, "flutterPickersDemo", ),


];

var others = <Tuple2<String, String>>[
  Tuple2(APPRouter.notFound, "notFound", ),
  Tuple2(APPRouter.firstPage, "firstPage", ),
  Tuple2(APPRouter.fourthPage, "fourthPage", ),
  Tuple2(APPRouter.loginPage, "LoginPage", ),
  Tuple2(APPRouter.loginPageOne, "LoginPage2", ),
  Tuple2(APPRouter.loginPageTwo, "loginPageTwo", ),
  Tuple2(APPRouter.clipDemo, "clipDemo", ),

  Tuple2(APPRouter.navgationBarDemo, "navgationBarDemo", ),
  Tuple2(APPRouter.richTextDemo, "richTextDemo", ),
  Tuple2(APPRouter.testPage, "testPage", ),
  Tuple2(APPRouter.testPageOne, "testPageOne", ),
  Tuple2(APPRouter.decorationDemo, "decorationDemo", ),
  Tuple2(APPRouter.homeSrollDemo, "HomeSrollDemo", ),
  Tuple2(APPRouter.homeNavDemo, "HomeNavDemo", ),
  Tuple2(APPRouter.videoPlayerScreenDemo, "videoPlayerScreenDemo", ),
  Tuple2(APPRouter.textFieldLoginDemo, "textFieldLoginDemo", ),
  Tuple2(APPRouter.autoLayoutDemo, "自适应布局研究", ),
  Tuple2(APPRouter.weatherInfoPage, "天气信息", ),


];

var forms = <Tuple2<String, String>>[
  Tuple2(APPRouter.autocompleteDemo, "autocompleteDemo", ),
  Tuple2(APPRouter.autofillGroupDemo, "autofillGroupDemo", ),
  Tuple2(APPRouter.inputDatePickerFormFieldDemo, "inputDatePickerFormFieldDemo", ),

];

var dataTypes = <Tuple2<String, String>>[
  Tuple2(APPRouter.dataTypeDemo, "数据类型", ),
  Tuple2(APPRouter.regExpDemo, "正则匹配", ),
  Tuple2(APPRouter.enumDemo, "枚举研究", ),


];
