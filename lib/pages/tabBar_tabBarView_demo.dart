//
//  TabBarTabBarViewDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/22/21 2:32 PM.
//  Copyright © 10/22/21 shang. All rights reserved.
//

import 'package:enhance_expansion_panel/enhance_expansion_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/ExpandButtons/expand_icons.dart';
import 'package:flutter_templet_project/basicWidget/ExpandButtons/expand_layout.dart';
import 'package:flutter_templet_project/basicWidget/app_update_card.dart';
import 'package:flutter_templet_project/basicWidget/list_subtitle_cell.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/extension/list_ext.dart';
import 'package:flutter_templet_project/model/mock_data.dart';
import 'package:flutter_templet_project/pages/app_tab_page.dart';
import 'package:flutter_templet_project/pages/demo/RouteNameSearchPage.dart';
import 'package:flutter_templet_project/routes/AppRouter.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

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
            onPressed: () {
              Get.toNamed(AppRouter.stateManagerDemo, arguments: "状态管理");
            },
            child: Text(
              "状态管理",
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
          tabs: items.map((e) => Tab(key: PageStorageKey<String>(e.item1), text: e.item1)).toList(),
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
    final icons = [Icons.sms, Icons.mail, Icons.phone];
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (context, offset) {
        final dy = isTop ? offset.dy - icons.length * 35.0 : offset.dy + icons.length * 35.0;
        return CenterAbout(
          position: Offset(offset.dx, dy),
          child: ExpandIcons(
            items: icons,
            onItem: (i) {
              debugPrint("i: $i");
            },
          ),
        );
      },
      child: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        elevation: 2.0,
        child: Icon(Icons.add),
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
          subtitle: Text(
            data.content,
            // maxLines: 1,
            // overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF999999),
            ),
          ),
          trailing: Text(
            data.time,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF999999),
            ),
          ),
          subtrailing: Text(
            "已完成",
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
          return AppUpdateCard(
            data: data,
            isExpand: true,
            showExpand: false,
          );
        }
        return AppUpdateCard(data: data);
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  buildPage3() {
    return RouteNameSearchPage(
      hideAppBar: true,
    );
  }

  buildPage4() {
    Widget buildHeader({required String sectionTile, required bool isExpand}) {
      final trailing = isExpand
          ? Icon(Icons.keyboard_arrow_up, color: Colors.blue)
          : Icon(Icons.keyboard_arrow_down, color: Colors.blue);
      return Container(
        // color: Colors.green,
        color: isExpand ? Colors.black12 : null,
        child: ListTile(
          title: Text(
            sectionTile,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          // subtitle: Text("subtitle"),
          trailing: trailing,
        ),
      );
    }

    Widget buildItem(Tuple2<String, String> e) {
      return ListTile(
        title: Text(
          e.item1,
          style: TextStyle(fontSize: 14),
        ),
        subtitle: Text(
          e.item2,
          style: TextStyle(fontSize: 12),
        ),
        trailing: Icon(Icons.chevron_right),
        dense: true,
        // contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
        onTap: () {
          DLog.d("section_");
          if (e.item1.toLowerCase().contains("loginPage".toLowerCase())) {
            Get.offNamed(e.item1, arguments: e.item1);
          } else {
            Get.toNamed(e.item1, arguments: e.item1);
          }
        },
      );
    }

    return EnhanceExpandListView(
      children: tuples
          .map<ExpandPanelModel<Tuple2<String, String>>>((e) => ExpandPanelModel(
                canTapOnHeader: true,
                isExpanded: false,
                arrowPosition: EnhanceExpansionPanelArrowPosition.none,
                // backgroundColor: Color(0xFFDDDDDD),
                headerBuilder: (context, isExpand) {
                  return buildHeader(isExpand: isExpand, sectionTile: e.item1);
                },
                bodyChildren: e.item2.sorted((a, b) => a.item1.toLowerCase().compareTo(b.item1.toLowerCase())),
                bodyItemBuilder: (context, e) {
                  return buildItem(e);
                },
              ))
          .toList(),
    );
  }

  List<String> getTitles({required List<Tuple2<String, List<Tuple2<String, String>>>> tuples}) {
    final titles = tuples.expand((e) => e.item2.map((e) => e.item1)).toList();
    final result = List<String>.from(titles.sorted());
    // print('titles runtimeType:${titles.runtimeType},${titles.every((element) => element is String)},');
    debugPrint('result runtimeType:${result.runtimeType}');
    return result;
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
  Tuple2(AppRouter.textDemo, "textDemo"),
  Tuple2(AppRouter.materialDemo, "materialDemo"),
  Tuple2(AppRouter.alertDialogDemo, "AlertDialog"),
  Tuple2(AppRouter.alertDialogTagSelectDemo, "alertDialogTagSelectDemo"),
  Tuple2(AppRouter.appBarDemo, "appBarDemo"),
  Tuple2(AppRouter.alertSheetDemo, "AlertSheet"),
  Tuple2(AppRouter.appWebViewDemo, "appWebViewDemo"),
  Tuple2(AppRouter.builderDemo, "builderDemo"),
  Tuple2(AppRouter.badgeDemo, "badgeDemo"),
  Tuple2(AppRouter.backdropFilterDemo, "backdropFilterDemo"),
  Tuple2(AppRouter.cupertinoTabScaffoldDemo, "CupertinoTabScaffoldDemo"),
  Tuple2(AppRouter.cupertinoFormDemo, "cupertinoFormDemo"),
  Tuple2(AppRouter.contextMenuActionDemo, "cupertinoFormDemo"),
  Tuple2(AppRouter.dataTableDemo, "dateTableDemo"),
  Tuple2(AppRouter.dataTableByPaginatedDemo, "dataTableByPaginatedDemo"),
  Tuple2(AppRouter.draggableDemo, "draggableDemo"),
  Tuple2(AppRouter.draggableScrollableSheetDemo, "draggableScrollableSheetDemo"),
  Tuple2(AppRouter.expandIconDemo, "expandIconDemo"),
  Tuple2(AppRouter.expandIconDemoNew, "ExpandIconDemoNew"),
  Tuple2(AppRouter.gridViewDemo, "GridView"),
  Tuple2(AppRouter.gridPaperDemo, "gridPaperDemo"),
  Tuple2(AppRouter.menuDemo, "MenuDemo"),
  Tuple2(AppRouter.pageViewDemo, "PageViewDemo"),
  Tuple2(AppRouter.pageViewDemoOne, "pageViewDemoOne"),
  Tuple2(AppRouter.pageViewDemoThree, "PageViewDemoThree"),
  Tuple2(AppRouter.pickerDemo, "pickerDemo"),
  Tuple2(AppRouter.progressHudDemo, "ProgressHudDemo"),
  Tuple2(AppRouter.progressHudDemoNew, "ProgressHudDemoNew"),
  Tuple2(AppRouter.indicatorDemo, "indicatorDemo"),
  Tuple2(AppRouter.reorderableListViewDemo, "reorderableListViewDemo"),
  Tuple2(AppRouter.listDismissibleDemo, "recordListDemo"),
  Tuple2(AppRouter.segmentedControlDemo, "segmentControlDemo"),
  Tuple2(AppRouter.segmentedControlDemoOne, "segmentControlDemoOne"),
  Tuple2(AppRouter.segmentedButtonDemo, "SegmentedButtonDemo"),
  Tuple2(AppRouter.snackBarDemo, "SnackBar"),
  Tuple2(AppRouter.snackBarDemoOne, "SnackBar封装"),
  Tuple2(AppRouter.sliderDemo, "sliderDemo"),
  Tuple2(AppRouter.stepperDemo, "stepperDemo"),
  Tuple2(AppRouter.slidableDemo, "SlidableDemo"),
  Tuple2(AppRouter.tabBarDemo, "tabBarDemo"),
  Tuple2(AppRouter.textlessDemo, "textlessDemo"),
  Tuple2(AppRouter.textFieldDemo, "textFieldDemo"),
  Tuple2(AppRouter.textFieldDemoOne, "textFieldDemoOne"),
  Tuple2(AppRouter.textFieldDemoTwo, "textFieldDemoTwo"),
  Tuple2(AppRouter.textFieldWidgetDemo, "textFieldWidgetDemo"),
  Tuple2(AppRouter.layoutBuilderDemo, "layoutBuilderDemo"),
  Tuple2(AppRouter.tableDemo, "tableDemo"),
  Tuple2(AppRouter.nestedScrollViewDemo, "nestedScrollViewDemo"),
  Tuple2(AppRouter.absorbPointerDemo, "absorbPointerDemo"),
  Tuple2(AppRouter.willPopScopeDemo, "willPopScopeDemo"),
  Tuple2(AppRouter.futureBuilderDemo, "futureBuilderDemo"),
  Tuple2(AppRouter.streamBuilderDemo, "streamBuilderDemo"),
  Tuple2(AppRouter.indexedStackDemo, "indexedStackDemo"),
  Tuple2(AppRouter.responsiveColumnDemo, "responsiveColumnDemo"),
  Tuple2(AppRouter.offstageDemo, "offstageDemo"),
  Tuple2(AppRouter.bottomAppBarDemo, "bottomAppBarDemo"),
  Tuple2(AppRouter.calendarDatePickerDemo, "calendarDatePickerDemo"),
  Tuple2(AppRouter.chipDemo, "chipDemo"),
  Tuple2(AppRouter.chipFilterDemo, "chipFilterDemo"),
  Tuple2(AppRouter.bottomSheetDemo, "bottomSheetDemo"),
  Tuple2(AppRouter.timePickerDemo, "timePickerDemo"),
  Tuple2(AppRouter.shaderMaskDemo, "ShaderMaskDemo"),
  Tuple2(AppRouter.blurViewDemo, "blurViewDemo"),
  Tuple2(AppRouter.boxDemo, "boxDemo"),
  Tuple2(AppRouter.mouseRegionDemo, "mouseRegionDemo"),
  Tuple2(AppRouter.navigationBarDemo, "navigationBarDemo"),
  Tuple2(AppRouter.shortcutsDemo, "shortcutsDemo"),
  Tuple2(AppRouter.shortcutsDemoOne, "shortcutsDemoOne"),
  Tuple2(AppRouter.transformDemo, "动画"),
  Tuple2(AppRouter.fittedBoxDemo, "fittedBox"),
  Tuple2(AppRouter.coloredBoxDemo, "coloredBoxDemo"),
  Tuple2(AppRouter.positionedDirectionalDemo, "positionedDirectionalDemo"),
  Tuple2(AppRouter.statefulBuilderDemo, "statefulBuilderDemo"),
  Tuple2(AppRouter.valueListenableBuilderDemo, "valueListenableBuilderDemo"),
  Tuple2(AppRouter.overflowBarDemo, "水平溢出自动垂直排列"),
  Tuple2(AppRouter.navigationToolbarDemo, "navigationToolbar"),
  Tuple2(AppRouter.selectableTextDemo, "文字选择"),
  Tuple2(AppRouter.materialBannerDemo, "一个 Banner"),
  Tuple2(AppRouter.routeNameSearchPage, "自动填写"),
  Tuple2(AppRouter.rotatedBoxDemo, "rotatedBoxDemo"),
  Tuple2(AppRouter.dismissibleDemo, "左滑删除"),
  Tuple2(AppRouter.modalBarrierDemo, "静态蒙版"),
  Tuple2(AppRouter.bannerDemo, "角落价格标签"),
  Tuple2(AppRouter.listViewDemo, "listView"),
  Tuple2(AppRouter.listViewStyleDemo, "listViewStyleDemo"),
  Tuple2(AppRouter.builderDemo, "各种回调 builder"),
  Tuple2(AppRouter.stackDemo, "StackDemo"),
  Tuple2(AppRouter.stackDemoOne, "stackDemoOne"),
  Tuple2(AppRouter.stackDemoTwo, "stackDemoTwo"),
  Tuple2(AppRouter.wrapDemo, "流水自动换行"),
  Tuple2(AppRouter.inheritedWidgetDemo, "inheritedWidgetDemo 数据共享"),
  Tuple2(AppRouter.notificationListenerDemo, "notificationListenerDemo 数据共享"),
  Tuple2(AppRouter.notificationCustomDemo, "notificationCustomDemo 自定义通知"),
  Tuple2(AppRouter.scrollbarDemo, "scrollbarDemo 滚动指示器监听"),
  Tuple2(AppRouter.intrinsicHeightDemo, "intrinsicHeightDemo"),
  Tuple2(AppRouter.flexDemo, "flex 布局"),
  Tuple2(AppRouter.flexibleDemo, "flexible 布局"),
  Tuple2(AppRouter.physicalModelDemo, "physicalModelDemo"),
  Tuple2(AppRouter.visibilityDemo, "visibilityDemo"),
  Tuple2(AppRouter.ignorePointerDemo, "ignorePointerDemo"),
  Tuple2(AppRouter.boxShadowDemo, "BoxShadow 阴影"),
  Tuple2(AppRouter.borderDemo, "buttonBorderDemo"),
  Tuple2(AppRouter.overflowDemo, "overflowDemo"),
  Tuple2(AppRouter.flexibleSpaceDemo, "flexibleSpaceDemo"),
  Tuple2(AppRouter.nnHorizontalScrollWidgetDemo, "nnHorizontalScrollWidgetDemo"),
  Tuple2(AppRouter.interactiveViewerDemo, "图片缩放"),
  Tuple2(AppRouter.dateRangePickerDialogDemo, "日期范围组件"),
  Tuple2(AppRouter.mergeableMaterialDemo, "mergeableMaterialDemo"),
  Tuple2(AppRouter.navigationRailDemo, "navigationRailDemo"),
  Tuple2(AppRouter.listTileDemo, "listTileDemo"),
  Tuple2(AppRouter.refreshIndicatorDemo, "refreshIndicatorDemo"),
  Tuple2(AppRouter.refreshIndicatorDemoOne, "refreshIndicatorDemoOne"),
  Tuple2(AppRouter.showSearchDemo, "showSearchDemo"),
  Tuple2(AppRouter.tooltipDemo, "tooltipDemo"),
  Tuple2(AppRouter.filterDemo, "filteredDemo"),
  Tuple2(AppRouter.filterDemoOne, "NNFilterDemoOne"),
  Tuple2(AppRouter.fractionallySizedBoxDemo, "fractionallySizedBoxDemo"),
  Tuple2(AppRouter.listWheelScrollViewDemo, "listWheelScrollViewDemo"),
  Tuple2(AppRouter.nnsliverPersistentHeaderDemo, "nnsliverPersistentHeaderDemo"),
  Tuple2(AppRouter.nestedScrollViewDemoOne, "nestedScrollViewDemoOne"),
  Tuple2(AppRouter.nestedScrollViewDemoTwo, "nestedScrollViewDemoTwo"),
  Tuple2(AppRouter.expansionTileCard, "expansionTileCard"),
  Tuple2(AppRouter.dropBoxChoicDemo, "下拉菜单"),
  Tuple2(AppRouter.dropBoxChoicDemoNew, "下拉菜单New"),
  Tuple2(AppRouter.dropBoxMutiRowChoicDemo, "下拉菜单多行选择"),
  Tuple2(AppRouter.customSingleChildLayoutDemo, "customSingleChildLayoutDemo"),
  Tuple2(AppRouter.customMultiChildLayoutDemo, "customMultiChildLayoutDemo"),
  Tuple2(AppRouter.pageBuilderDemo, "pageBuilderDemo"),
  Tuple2(AppRouter.npageViewDemo, "npageViewDemo"),
  Tuple2(AppRouter.boxShadowDemoOne, "boxShadowDemoOne"),
  Tuple2(AppRouter.scaffoldBottomSheet, "scaffoldBottomSheet"),
  Tuple2(AppRouter.floatingActionButtonDemo, "floatingActionButtonDemo"),
  Tuple2(AppRouter.dropdownMenuDemo, "dropdownMenuDemo"),
  Tuple2(AppRouter.searchDemo, "searchDemo"),
  Tuple2(AppRouter.switchDemo, "switchDemo"),
  Tuple2(AppRouter.gestureDetectorDemo, "gestureDetectorDemo"),
  Tuple2(AppRouter.compositedTransformTargetDemo, "compositedTransformTargetDemo"),
  Tuple2(AppRouter.contextMenuDemo, "contextMenuDemo"),
  Tuple2(AppRouter.targetFollowerDemo, "targetFollowerDemo"),
  Tuple2(AppRouter.tapRegionDemo, "tapRegionDemo"),
  Tuple2(AppRouter.glowingOverscrollIndicatorDemo, "glowingOverscrollIndicatorDemo"),
  Tuple2(AppRouter.progressClipperDemo, "progressClipperDemo"),
  Tuple2(AppRouter.heroDemo, "heroDemo"),
  Tuple2(AppRouter.hitTestBehaviorDemo, "hitTestBehaviorDemo"),
  Tuple2(AppRouter.qrcodePage, "qrcodePage"),
  Tuple2(AppRouter.menuAnchorDemo, "menuAnchorDemo"),
  Tuple2(AppRouter.myMenuBarDemo, "myMenuBarDemo"),
  Tuple2(AppRouter.overlayPortalDemo, "overlayPortalDemo"),
  Tuple2(AppRouter.componentMiddlePage, "componentMiddlePage"),
  Tuple2(AppRouter.displayFeatureDemo, "displayFeatureDemo"),
  Tuple2(AppRouter.preferredSizeDemo, "preferredSizeDemo"),
  Tuple2(AppRouter.ntabBarPageDemo, "ntabBarPageDemo"),
  Tuple2(AppRouter.nTabBarViewCustomDemo, "nTabBarViewCustomDemo"),
  Tuple2(AppRouter.textFieldTabDemo, "textFieldTabDemo"),
  Tuple2(AppRouter.textPaintDemo, "textPaintDemo"),
  Tuple2(AppRouter.segmentedPageViewDemo, "segmentedPageViewDemo"),
  Tuple2(AppRouter.nRefreshViewDemo, "nRefreshListViewDemo"),
  Tuple2(AppRouter.nestedScrollViewDemoThree, "nestedScrollPageDemo"),
  Tuple2(AppRouter.formDemo, "formDemoPage"),
  Tuple2(AppRouter.choiceExpansionDemo, "choiceExpansionDemo"),
  Tuple2(AppRouter.riverPodPageCreate, "riverPodPageCreate"),
  Tuple2(AppRouter.getxRouteCreatePage, "getxRouteCreatePage"),
  Tuple2(AppRouter.getxControllerDemo, "getxControllerDemo"),
  Tuple2(AppRouter.nTransformViewDemo, "responsiveCreateViewDemo"),
  Tuple2(AppRouter.queueAlertDemo, "queueAlertDemo"),
  Tuple2(AppRouter.flutterPickerUtilDemo, "queueAlertDemo"),
  Tuple2(AppRouter.segmentVerticalDemo, "segmentVerticalDemo"),
  Tuple2(AppRouter.decoratedBoxTransitionDemo, "decoratedBoxTransitionDemo"),
  Tuple2(AppRouter.aeReportPage, "表单"),
  Tuple2(AppRouter.scaffoldDemo, "scaffoldDemo"),
  Tuple2(AppRouter.sliverMainAxisGroupDemoOne, "sliverMainAxisGroupDemoOne"),
  Tuple2(AppRouter.listBodyDemo, "listBodyDemo"),
  Tuple2(AppRouter.scanAnimationDemo, "scanAnimationDemo"),
  Tuple2(AppRouter.lerpDemo, "lerpDemo"),
  Tuple2(AppRouter.convertFlle, "convertTheme"),
  Tuple2(AppRouter.splitViewDemo, "splitViewDemo"),
  Tuple2(AppRouter.directoryTestDemo, "directoryTestDemo"),
  Tuple2(AppRouter.nestedNavigatorDemo, "nestedNavigatorDemo"),
  Tuple2(AppRouter.nTweenTransitionDemo, "nTweenTransitionDemo"),
  Tuple2(AppRouter.hapticFeedbackDemo, "hapticFeedbackDemo"),
  Tuple2(AppRouter.webviewDemo, "webviewDemo"),
  Tuple2(AppRouter.secureKeyboardDemo, "secureKeyboardDemo"),
  Tuple2(AppRouter.popScopeDemo, "popScopeDemo"),
  Tuple2(AppRouter.popScopeDemoOne, "popScopeDemoOne"),
  Tuple2(AppRouter.nestedScrollViewDemoHome, "nestedScrollViewDemoHome"),
  Tuple2(AppRouter.nestedScrollViewDemoFive, "nestedScrollViewDemoFive"),
  Tuple2(AppRouter.nestedScrollViewDemoSix, "nestedScrollViewDemoSix"),
  Tuple2(AppRouter.irregularClipperDemo, "irregularClipperDemo"),
  Tuple2(AppRouter.ocrPhotoDemo, "ocrPhotoDemo"),
  Tuple2(AppRouter.translationTextPage, "translationTextPage"),
  Tuple2(AppRouter.floatingButtonDemo, "floatingButtonDemo"),
  Tuple2(AppRouter.floatingButtonDemoOne, "floatingButtonDemoOne"),
  Tuple2(AppRouter.floatingButtonDemoTwo, "floatingButtonDemoTwo"),
  Tuple2(AppRouter.floatingButtonDemoThree, "floatingButtonDemoThree"),
  Tuple2(AppRouter.urlLauncherDemo, "urlLauncherDemo"),
  Tuple2(AppRouter.iteratorDemo, "iteratorDemo"),
  Tuple2(AppRouter.chemotherapyRegimenDrugCaculator, "chemotherapyRegimenDrugCaculator"),
  Tuple2(AppRouter.carouselViewDemo, "carouselViewDemo"),
];

var slivers = <Tuple2<String, String>>[
  Tuple2(AppRouter.sliverFamilyDemo, "SliverFamilyDemo"),
  Tuple2(AppRouter.sliverMainAxisGroupDemo, "sliverMainAxisGroupDemo"),
  Tuple2(AppRouter.twoDimensionalGridViewDemo, "twoDimensionalGridViewDemo"),
  Tuple2(AppRouter.listenerHeaderPage, "listenerHeaderPage"),
  Tuple2(AppRouter.nPinnedTabBarPageDemo, "nPinnedTabBarPageDemo"),
];

var specials = <Tuple2<String, String>>[
  Tuple2(AppRouter.yamlParsePage, "yaml解析"),
  Tuple2(AppRouter.compileEnvironmentPage, "compileEnvironmentPage"),
  Tuple2(AppRouter.appLifecycleObserverDemo, "appLifecycleObserverDemo"),
  Tuple2(AppRouter.themeColorDemo, "themeColor"),
  Tuple2(AppRouter.emojiPage, "emoji"),
  Tuple2(AppRouter.operatorDemo, "特殊操作符"),
  Tuple2(AppRouter.mediaQueryDemo, "mediaQuery"),
  Tuple2(AppRouter.mediaQueryDemoOne, "mediaQuery键盘"),
  Tuple2(AppRouter.appRouteObserverDemo, "页面路由监听"),
  Tuple2(AppRouter.appRouteObserverDemoOne, "页面路由监听1"),
  Tuple2(AppRouter.pageLifecycleObserverDemo, "页面生命周期监听"),
  Tuple2(AppRouter.pageLifecycleFuncTest, "页面生命方法测试"),
  Tuple2(AppRouter.systemIconsPage, "flutter 系统 Icons"),
  Tuple2(AppRouter.systemColorPage, "flutter 系统 颜色"),
  Tuple2(AppRouter.systemCurvesPage, "flutter Curves动画效果"),
  Tuple2(AppRouter.localImagePage, "本地图片"),
  Tuple2(AppRouter.providerRoute, "providerRoute"),
  Tuple2(AppRouter.stateManagerDemo, "状态管理"),
  Tuple2(AppRouter.tabBarPageViewDemo, "tabBarPageViewDemo"),
  Tuple2(AppRouter.tabBarReusePageDemo, "tabBarReusePageDemo"),
  Tuple2(AppRouter.githubRepoDemo, "githubRepoDemo"),
  Tuple2(AppRouter.hitTest, "hitTest"),
  Tuple2(AppRouter.textViewDemo, "textViewDemo"),
  Tuple2(AppRouter.flutterFFiTest, "ffi"),
  Tuple2(AppRouter.mergeImagesDemo, "图像合并"),
  Tuple2(AppRouter.mergeNetworkImagesDemo, "网络图像合并"),
  Tuple2(AppRouter.drawImageNineDemo, "图像拉伸"),
  Tuple2(AppRouter.promptBuilderDemo, "指引模板"),
  Tuple2(AppRouter.isolateDemo, "isolateDemo"),
  Tuple2(AppRouter.overlayDemo, "overlay弹窗"),
  Tuple2(AppRouter.overlayDemoOne, "overlay弹窗1"),
  Tuple2(AppRouter.overlayMixinDemo, "overlayMixinDemo"),
  Tuple2(AppRouter.boxConstraintsDemo, "boxConstraints"),
  Tuple2(AppRouter.gradientDemo, "渐变色"),
  Tuple2(AppRouter.imageBlendModeDemo, "图片渲染模式"),
  Tuple2(AppRouter.containerDemo, "containerDemo"),
  Tuple2(AppRouter.animatedContainerDemo, "animatedContainerDemo"),
  Tuple2(AppRouter.scrollControllerDemo, "滚动行为"),
  Tuple2(AppRouter.buttonStyleDemo, "按钮样式研究"),
  Tuple2(AppRouter.keyDemo, "key研究"),
  Tuple2(AppRouter.netStateListenerDemo, "netStateListenerDemo"),
  Tuple2(AppRouter.netStateListenerDemoOne, "mixin监听网络"),
  Tuple2(AppRouter.reflectDemo, "模型属性动态化赋值"),
  Tuple2(AppRouter.testFunction, "方法动态化"),
  Tuple2(AppRouter.pageViewAndBarDemo, "pageViewAndBarDemo"),
  Tuple2(AppRouter.mediaQueryScreeenDemo, "屏幕尺寸研究"),
  Tuple2(AppRouter.neomorphismHomePage, "拟物风格"),
  Tuple2(AppRouter.refreshListView, "refreshListView"),
  Tuple2(AppRouter.globalIsolateDemo, "globalIsolateDemo"),
  Tuple2(AppRouter.longCaptureWidgetDemo, "widget长截图"),
  Tuple2(AppRouter.imageStretchDemo, "图片拉伸"),
  Tuple2(AppRouter.drawCanvasDemo, "drawCanvas"),
  Tuple2(AppRouter.todoListTabPage, "todoListTabPage"),
  Tuple2(AppRouter.studentTabPage, "studentTabPage"),
  Tuple2(AppRouter.orderListTabPage, "orderListTabPage"),
  Tuple2(AppRouter.apiCreatePage, "apiCreatePage"),
  Tuple2(AppRouter.asyncDemo, "asyncDemo"),
  Tuple2(AppRouter.dataTypeDemo, "testDataTyeDemo"),
  Tuple2(AppRouter.audioPlayPageDemo, "audioPlayPage"),
  Tuple2(AppRouter.expressionsCalulatorDemo, "简单表达式计算"),
  Tuple2(AppRouter.localAuthDemo, "生物识别技术（例如指纹或面部识别）"),
  Tuple2(AppRouter.deviceBrightnessAndVolumeControllerDemo, "deviceBrightnessAndVolumeControllerDemo"),
];

var animateds = <Tuple2<String, String>>[
  // Tuple2(AppRouter.animatedIconDemo, "AnimatedIconDemo", ),
  Tuple2(AppRouter.animatedDemo, "animatedDemo"),
  Tuple2(AppRouter.animatedSwitcherDemo, "animatedSwitcherDemo"),
  Tuple2(AppRouter.animatedWidgetDemo, "animatedWidgetDemo"),
  Tuple2(AppRouter.animatedGroupDemo, "animatedGroupDemo"),
  Tuple2(AppRouter.animatedBuilderDemo, "animatedBuilderDemo"),
  Tuple2(AppRouter.animatedListDemo, "animatedListDemo"),
  Tuple2(AppRouter.animatedListSample, "animatedListSample"),
  Tuple2(AppRouter.animatedStaggerDemo, "staggerDemo"),
  Tuple2(AppRouter.animatedSizeDemo, "animatedSizeDemo"),
  Tuple2(AppRouter.animatedSizeDemoOne, "animatedSizeDemoOne"),
];

var customs = [
  Tuple2(AppRouter.datePickerPage, "DatePickerPage"),
  Tuple2(AppRouter.dateTimeDemo, "dateTimeDemo"),
  Tuple2(AppRouter.hudProgressDemo, "HudProgressDemo"),
  Tuple2(AppRouter.localNotifationDemo, "localNotifationDemo"),
  Tuple2(AppRouter.locationPopView, "locationPopView"),
  Tuple2(AppRouter.numberStepperDemo, "商品计数器"),
  Tuple2(AppRouter.numberFormatDemo, "数字格式化"),
  Tuple2(AppRouter.steperConnectorDemo, "steperConnectorDemo"),
  Tuple2(AppRouter.customSwipperDemo, "自定义轮播"),
  Tuple2(AppRouter.neumorphismDemo, "拟物按钮"),
  Tuple2(AppRouter.horizontalCellDemo, "水平 cell 布局"),
  Tuple2(AppRouter.listViewOneDemo, "跑马灯效果"),
  Tuple2(AppRouter.marqueeWidgetDemo, "跑马灯效果"),
  Tuple2(AppRouter.ticketDemo, "券"),
  Tuple2(AppRouter.myPopverDemo, "弹窗测试"),
  Tuple2(AppRouter.customScrollBarDemo, "自定义 ScrollBar"),
  Tuple2(AppRouter.enhanceTabBarDemo, "Tab 指示器支持固定宽度"),
  Tuple2(AppRouter.collectionNavWidgetDemo, "图文导航"),
  Tuple2(AppRouter.boxWidgetDemo, "boxWidgetDemo"),
  Tuple2(AppRouter.nSkeletonDemo, "骨架图"),
  Tuple2(AppRouter.nTreeDemo, "树形组件"),
  Tuple2(AppRouter.dialogChoiceChipDemo, "选择弹窗"),
  Tuple2(AppRouter.imChatPage, "聊天列表"),
  Tuple2(AppRouter.expandTextDemo, "可折叠文字"),
  Tuple2(AppRouter.uploadFileDemo, "上传demo"),
  Tuple2(AppRouter.fileUploadBoxDemo, "上传文件demo"),
  Tuple2(AppRouter.jsonToModel, "json转模型"),
  Tuple2(AppRouter.assetUploadBoxDemo, "assetUploadBoxDemo"),
  Tuple2(AppRouter.dashLineDemo, "dashLineDemo"),
  Tuple2(AppRouter.choiceBoxOneDemo, "choiceBoxOneDemo"),
  Tuple2(AppRouter.apiConvertPage, "APIConvertPage"),
  Tuple2(AppRouter.selectListPage, "selectListPage"),
  Tuple2(AppRouter.avatarGroupDemo, "indexAvatarGroupDemo"),
  Tuple2(AppRouter.appBarColorChangerDemo, "appBarColorChangerDemo"),
  Tuple2(AppRouter.footerButtonBarDemo, "footerButtonBarDemo"),
  Tuple2(AppRouter.sectionHeaderDemo, "sectionHeaderDemo"),
  Tuple2(AppRouter.nwebViewDemo, "nwebViewDemo"),
  Tuple2(AppRouter.iconConvertPage, "iconConvertPage"),
  Tuple2(AppRouter.alignmentDrawDemo, "alignmentDrawDemo"),
];

var vendors = <Tuple2<String, String>>[
  Tuple2(AppRouter.carouselSliderDemo, "carouselSliderDemo"),
  Tuple2(AppRouter.timelinesDemo, "timelinesDemo"),
  Tuple2(AppRouter.timelineDemo, "timelineDemo"),
  Tuple2(AppRouter.qrCodeScannerDemo, "扫描二维码"),
  Tuple2(AppRouter.qrFlutterDemo, "生成二维码"),
  Tuple2(AppRouter.scribbleDemo, "scribble 画板"),
  Tuple2(AppRouter.aestheticDialogsDemo, "aestheticDialogs 对话框"),
  Tuple2(AppRouter.customTimerDemo, "自定义计时器"),
  Tuple2(AppRouter.skeletonDemo, "骨架屏"),
  Tuple2(AppRouter.smartDialogPageDemo, "弹窗"),
  Tuple2(AppRouter.ratingBarDemo, "星评"),
  Tuple2(AppRouter.dragAndDropDemo, "文件拖拽"),
  Tuple2(AppRouter.popoverDemo, "popoverDemo"),
  Tuple2(AppRouter.badgesDemo, "badgesDemo"),
  Tuple2(AppRouter.flutterSwiperDemo, "flutterSwiperDemo"),
  Tuple2(AppRouter.flutterSwiperIndicatorDemo, "flutterSwiperIndicatorDemo"),
  Tuple2(AppRouter.visibilityDetectorDemo, "visibilityDetector 曝光检测"),
  Tuple2(AppRouter.svgaImageDemo, "svgaImageDemo"),
  Tuple2(AppRouter.providerDemo, "状态管理 - provider"),
  Tuple2(AppRouter.providerDemoOne, "状态管理 - providerDemoOne"),
  Tuple2(AppRouter.colorConverterDemo, "颜色转换"),
  Tuple2(AppRouter.wechatAssetsPickerDemo, "微信相册选择器"),
  Tuple2(AppRouter.wechatPhotoPickerDemo, "微信相册选择器组件封装"),
  Tuple2(AppRouter.azlistviewDemo, "分组列表"),
  Tuple2(AppRouter.slidableDemoOne, "滑动菜单"),
  Tuple2(AppRouter.soundPlayDemo, "声音播放"),
  Tuple2(AppRouter.wPopupMenuDemo, "微信聊天长按弹出框"),
  Tuple2(AppRouter.syncfusionFlutterDatepickerDemo, "日期多选"),
  Tuple2(AppRouter.tableCalenderMain, "日期"),
  Tuple2(AppRouter.keyboardAttachDemo, "keyboardAttachableDemo"),
  Tuple2(AppRouter.keyboardObserverDemo, "keyboardObserverDemo"),
  Tuple2(AppRouter.getxDemo, "getxDemo"),
  Tuple2(AppRouter.flutterPickersDemo, "flutterPickersDemo"),
  Tuple2(AppRouter.scanBarcodeDemo, "scanBarcodeDemo"),
  Tuple2(AppRouter.animatedModalBarrierDemo, "animatedModalBarrierDemo"),
  Tuple2(AppRouter.metaDataDemo, "metaDataDemo"),
  Tuple2(AppRouter.appLocaleChangePage, "appLocaleChangePage"),
  Tuple2(AppRouter.backgroundTaskDemo, "backgroundTaskDemo"),
  Tuple2(AppRouter.colorSchemeDemo, "colorSchemeDemo"),
  Tuple2(AppRouter.concurrentExecutorDemo, "concurrentExecutorDemo"),
  Tuple2(AppRouter.gameMathPage, "gameMathPage"),
  Tuple2(AppRouter.gameMathPageNew, "GameMathPageNew"),
  Tuple2(AppRouter.clickNotificationDemo, "clickNotificationDemo"),
  Tuple2(AppRouter.colorFilterDemo, "colorFilterDemo"),
  Tuple2(AppRouter.pageTopBackgroudImageDemo, "pageTopBackgroudImageDemo"),
  Tuple2(AppRouter.fingerViewDemo, "fingerViewDemo"),
  Tuple2(AppRouter.dividerDemo, "dividerDemo"),
  Tuple2(AppRouter.userDetailPage, "userDetailPage"),
  Tuple2(AppRouter.animatedToggleSwitchDemo, "animatedToggleSwitchDemo"),
  Tuple2(AppRouter.customTabbarPage, "customTabbarPage"),
  Tuple2(AppRouter.pageRouteDemo, "pageRouteDemo"),
  Tuple2(AppRouter.fontFeatureDemo, "fontFeatureDemo"),
  Tuple2(AppRouter.colorAnimationDemo, "colorAnimationDemo"),
  Tuple2(AppRouter.restorationMixinDemo, "restorationMixinDemo"),
  Tuple2(AppRouter.listenableDemo, "listenableDemo"),
  Tuple2(AppRouter.autocompletePage, "autocompletePage"),
  Tuple2(AppRouter.customRefreshIndicatorDemo, "customRefreshIndicatorDemo"),
  Tuple2(AppRouter.nestedScrollViewDemoSeven, "nestedScrollViewDemoSeven"),
  Tuple2(AppRouter.stackDemoThree, "stackDemoThree"),
  Tuple2(AppRouter.themeMaterial3Page, "themeMaterial3Page"),
  Tuple2(AppRouter.footballTeamPage, "footballTeamPage"),
  Tuple2(AppRouter.scrollablePositionedListDemo, "scrollablePositionedListDemo"),
];

var others = <Tuple2<String, String>>[
  Tuple2(AppRouter.unknown, "notFound"),
  Tuple2(AppRouter.firstPage, "firstPage"),
  Tuple2(AppRouter.fourthPage, "fourthPage"),
  Tuple2(AppRouter.loginPage, "LoginPage"),
  Tuple2(AppRouter.loginPageOne, "LoginPage2"),
  Tuple2(AppRouter.loginPageTwo, "loginPageTwo"),
  Tuple2(AppRouter.clipDemo, "clipDemo"),
  Tuple2(AppRouter.navgationBarDemo, "navgationBarDemo"),
  Tuple2(AppRouter.richTextDemo, "richTextDemo"),
  Tuple2(AppRouter.testPage, "testPage"),
  Tuple2(AppRouter.testPageOne, "testPageOne"),
  Tuple2(AppRouter.decorationDemo, "decorationDemo"),
  Tuple2(AppRouter.homeSrollDemo, "HomeSrollDemo"),
  Tuple2(AppRouter.homeNavDemo, "HomeNavDemo"),
  Tuple2(AppRouter.videoPlayerScreenDemo, "videoPlayerScreenDemo"),
  Tuple2(AppRouter.textFieldLoginDemo, "textFieldLoginDemo"),
  Tuple2(AppRouter.autoLayoutDemo, "自适应布局研究"),
  Tuple2(AppRouter.weatherInfoPage, "天气信息"),
];

var forms = <Tuple2<String, String>>[
  Tuple2(AppRouter.autofillGroupDemo, "autofillGroupDemo"),
  Tuple2(AppRouter.inputDatePickerFormFieldDemo, "inputDatePickerFormFieldDemo"),
];

var dataTypes = <Tuple2<String, String>>[
  Tuple2(AppRouter.defaultTabControllerDemo, "数据类型"),
  Tuple2(AppRouter.regExpDemo, "正则匹配"),
  Tuple2(AppRouter.enumDemo, "枚举研究"),
];
