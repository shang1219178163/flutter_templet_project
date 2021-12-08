//
//  TabBarPageViewDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/22/21 2:32 PM.
//  Copyright © 10/22/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_subtitle_cell.dart';
import 'package:flutter_templet_project/extensions/color_extension.dart';
import 'package:flutter_templet_project/extensions/divider_extension.dart';
import 'package:flutter_templet_project/extensions/list_extension.dart';
import 'package:flutter_templet_project/extensions/string_extension.dart';
import 'package:flutter_templet_project/main.dart';
import 'package:flutter_templet_project/basicWidget/app_update_card.dart';
import 'package:flutter_templet_project/extensions/ddlog.dart';
import 'package:flutter_templet_project/mockData/mock_data.dart';
import 'package:flutter_templet_project/basicWidget/section_list_view.dart';
import 'package:flutter_templet_project/routes/APPRouter.dart';

import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

import 'package:flutter_templet_project/extensions/widget_extension.dart';


class TabBarPageViewDemo extends StatefulWidget {

  final String? title;

  TabBarPageViewDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _TabBarPageViewDemoState createState() => _TabBarPageViewDemoState();
}

class _TabBarPageViewDemoState extends State<TabBarPageViewDemo> with SingleTickerProviderStateMixin {
  late TabController _tabController = TabController(length: items.length, vsync: this);

  late PageController _pageController = PageController(initialPage: 0, keepPage: true);

  @override
  void initState() {
    super.initState();

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
        actions: [
          TextButton(
            onPressed: (){
              Get.toNamed(APPRouter.stateManagerDemo, arguments: "状态管理");
            },
            child: Text("状态管理", style: TextStyle(color: Colors.white),),
          ),
        ],
        // bottom: _buildTabBar(),
      ),
      body: _buildPageView(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
        onPressed: () {
          ddlog(["a", 18, null, true, ["1", "2", "3"], {"a": "aa", "b": "bb"}]);
          ddlog(_list);
        },
      ),
      // persistentFooterButtons: persistentFooterButtons(),

    );
  }

  PreferredSize _buildPreferredSize(Widget child) {
    return PreferredSize(
        child: Theme(
          data: Theme.of(context).copyWith(accentColor: Colors.white),
          child: Container(
            height: 40,
            alignment: Alignment.center, //圆点居中
            //给自定义导航栏设置圆点控制器
            child: child,
          ),
        ),
        preferredSize: Size.fromHeight(48)
    );
  }

  TabBar _buildTabBar() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      tabs: items.map((e) => Tab(text: e.item1)).toList(),
      indicatorSize: TabBarIndicatorSize.label,
      // indicatorPadding: EdgeInsets.only(left: 6, right: 6),
      onTap: (index){
        setState(() {
          _tabController.animateTo(index);
          ddlog(index);
        });
      },
    );
  }
  Material _buildBottomNavigationBar() {
    final textColor = Theme.of(context).colorScheme.secondary;
    final bgColor = Colors.white;

    // final bgColor = Theme.of(context).colorScheme.secondary;
    // final textColor = Colors.white;

    return Material(
      color: bgColor,
      child: SafeArea(
        child: TabBar(
          controller: _tabController,
          tabs: items.map((e) => Tab(text: e.item1)).toList(),
          labelColor: textColor,
          indicator: BoxDecoration(
            border: Border(
              top: BorderSide(
                  // color: textColor ,
                  color: textColor,
                  width: 3.0
              ),
            ),
          ),
          onTap: (index){
            ddlog(index);
            setState(() {
              // _tabController.animateTo(index);
              _pageController.jumpToPage(index);
            });
          },
        ),
      )
    );
  }


  Widget _buildPageView() {
    return
      PageView(
        controller: _pageController,
        // children: _pages.map((e) => Tab(text: e.item1)).toList(),
        children: items.map((e) => e.item2).toList(),
        onPageChanged: (index) {
          setState(() {
            _tabController.animateTo(index);
          });
        },
      );
  }


  List<Widget> persistentFooterButtons() {
    return [
      TextButton(
        child: Text(
          'Button 1',
        ),
        onPressed: () => setState(() => print('button1 tapped')),
      ),
      IconButton(
        icon: Icon(Icons.map),
        onPressed: () => setState(() => print('button1 tapped')),
      ),
      IconButton(
        icon: Icon(Icons.mail),
        onPressed: () => setState(() => print('button1 tapped')),
      ),
    ];
  }

  List<Tuple2<String, Widget>> items = [
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

    Tuple2('升级列表(新)', ListView.separated(
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
      headerList: ["特殊功能", "动画相关", "系统组件demo", "自定义组件", "其它"],
      itemList: [_specials, _animateds, _list, _customeWidgets, _others]
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
            Get.toNamed(e.item1, arguments: e);
            if (e.item1.toLowerCase().contains("loginPage".toLowerCase())){
              Get.offNamed(e.item1, arguments: e.item1);
            } else {
              Get.toNamed(e.item1, arguments: e.item1);
            }
          },
        );
      },
    ),),
  ];
}

var _list = [
  Tuple2(APPRouter.alertDialogDemoPage, "AlertDialog", ),
  Tuple2(APPRouter.alertSheetDemoPage, "AlertSheet", ),
  Tuple2(APPRouter.appWebViewDemoPage, "appWebViewDemoPage", ),

  Tuple2(APPRouter.backdropFilterDemo, "backdropFilterDemo", ),

  Tuple2(APPRouter.cupertinoTabScaffoldDemo, "CupertinoTabScaffoldDemo", ),
  Tuple2(APPRouter.cupertinoFormDemo, "cupertinoFormDemo", ),
  Tuple2(APPRouter.contextMenuActionDemo, "cupertinoFormDemo", ),

  Tuple2(APPRouter.dateTableDemo, "dateTableDemoPage", ),
  Tuple2(APPRouter.draggableDemoPage, "draggableDemoPage", ),
  Tuple2(APPRouter.draggableScrollableSheetDemoPage, "draggableScrollableSheetDemoPage", ),

  Tuple2(APPRouter.enlargeStrategyDemo, "enlargeStrategyDemo", ),
  Tuple2(APPRouter.expandIconDemo, "expandIconDemo", ),
  Tuple2(APPRouter.expandIconDemoNew, "ExpandIconDemoNew", ),

  Tuple2(APPRouter.gridViewDemoPage, "GridView", ),
  Tuple2(APPRouter.gridPaperDemo, "gridPaperDemo", ),

  Tuple2(APPRouter.menuDemo, "MenuDemo", ),

  Tuple2(APPRouter.pageViewDemo, "PageViewDemo", ),
  Tuple2(APPRouter.pageViewTabBarWidget, "PageViewTabBarWidget", ),

  Tuple2(APPRouter.pickerDemoPage, "pickerDemoPage", ),
  Tuple2(APPRouter.progressHudDemo, "ProgressHudDemo", ),
  Tuple2(APPRouter.progressHudDemoNew, "ProgressHudDemoNew", ),
  Tuple2(APPRouter.progressIndicatorDemoPage, "ProgressIndicatorDemo", ),

  Tuple2(APPRouter.reorderableListViewDemoPage, "reorderableListViewDemoPage", ),
  Tuple2(APPRouter.recordListDemo, "textFieldDemoPage", ),
  Tuple2(APPRouter.rangerSliderDemoPage, "rangerSliderDemoPage", ),

  Tuple2(APPRouter.segmentControlDemoPage, "segmentControlDemoPage", ),
  Tuple2(APPRouter.snackBarDemo, "SnackBar", ),
  Tuple2(APPRouter.stepperDemoPage, "stepperDemoPage", ),
  Tuple2(APPRouter.sliverAppBarDemoPage, "SliverAppBarDemo", ),
  Tuple2(APPRouter.sliverFamilyDemo, "SliverFamilyDemo", ),
  Tuple2(APPRouter.sliverFamilyPageViewDemo, "sliverFamilyPageViewDemo", ),
  Tuple2(APPRouter.sliverPersistentHeaderDemo, "sliverPersistentHeaderDemo", ),

  Tuple2(APPRouter.tabBarDemoPage, "tabBarDemoPage", ),
  Tuple2(APPRouter.textlessDemo, "textlessDemo", ),
  Tuple2(APPRouter.textFieldDemo, "textFieldDemo", ),

  Tuple2(APPRouter.layoutBuilderDemo, "layoutBuilderDemo", ),
  Tuple2(APPRouter.tableDemo, "tableDemo", ),
  Tuple2(APPRouter.nestedScrollViewDemo, "nestedScrollViewDemo", ),

  Tuple2(APPRouter.popoverDemo, "popoverDemo", ),

];

var _specials = [
  Tuple2(APPRouter.systemIconsPage, "flutter 系统 Icons", ),
  Tuple2(APPRouter.providerRoute, "providerRoute", ),
  Tuple2(APPRouter.stateManagerDemo, "状态管理", ),

  Tuple2(APPRouter.tabBarPageViewDemo, "tabBarPageViewDemo", ),
];

var _animateds = [
  // Tuple2(APPRouter.animatedIconDemoPage, "AnimatedIconDemoPage", ),
  Tuple2(APPRouter.animatedDemoPage, "AnimatedDemo", ),

  Tuple2(APPRouter.animatedSwitcherDemo, "animatedSwitcherDemo", ),
  Tuple2(APPRouter.animatedWidgetDemo, "animatedWidgetDemo", ),

];

var _customeWidgets = [
  Tuple2(APPRouter.datePickerPage, "DatePickerPage", ),
  Tuple2(APPRouter.dateTimeDemo, "dateTimeDemo", ),
  Tuple2(APPRouter.hudProgressDemo, "HudProgressDemo", ),
  Tuple2(APPRouter.localNotifationDemoPage, "localNotifationDemoPage", ),
  Tuple2(APPRouter.locationPopView, "locationPopView", ),
  Tuple2(APPRouter.numberStepperDemo, "NumberStepperDemo", ),
  Tuple2(APPRouter.numberFormatDemo, "numberFormatDemo", ),

];

var _others = [
  Tuple2(APPRouter.richTextDemo, "richTextDemo", ),
  Tuple2(APPRouter.loginPage, "LoginPage", ),
  Tuple2(APPRouter.loginPage2, "LoginPage2", ),
  Tuple2(APPRouter.githubRepoDemo, "githubRepoDemo", ),

];
