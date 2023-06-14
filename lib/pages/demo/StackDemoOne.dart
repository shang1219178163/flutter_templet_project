

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/tab_bar_indicator_fixed.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';

import 'package:flutter_templet_project/uti/color_uti.dart';
import 'package:tuple/tuple.dart';

class StackDemoOne extends StatefulWidget {

  StackDemoOne({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _StackDemoOneState createState() => _StackDemoOneState();
}

class _StackDemoOneState extends State<StackDemoOne> with SingleTickerProviderStateMixin {

  late final List<Tuple2<String, Widget>> _tabItems = [
    Tuple2("患者档案", buildPaticentRecord()),
    Tuple2("全病程轨迹", buildPaticentDepartmentPage()),
    Tuple2("日程", buildPaticentSchedule()),
  ];
  late final _tabController = TabController(length: _tabItems.length, vsync: this);

  late final _pageController = PageController(initialPage: 0, keepPage: true);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
        ),
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => debugPrint(e),)
        ).toList(),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    final paddingTop = MediaQuery.of(context).viewPadding.top;
    final cardSize = Size(343.w, (161 + 24 + 108).w);

    final height = max(16.w, MediaQuery.of(context).viewPadding.bottom);
    return Column(
      children: [
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  Container(
                    height: 172.h,
                    decoration: BoxDecoration(
                      color: Colors.yellowAccent,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: "bg_mine.png".toAssetImage(),
                      )
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      debugPrint("${DateTime.now()}: InkWell");
                    },
                    child: Container(
                      color: Colors.transparent,
                      height: cardSize.height,
                      child: const Text("数据获取失败"),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: (paddingTop + kToolbarHeight + 20).h,
                bottom: 1.w,
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildListBox(),
                        Expanded(
                          child: buildFooter(),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
        Container(
          color: ColorExt.random,
          height: height,
        ),
      ],
    );
  }

  buildListBox() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8.w)),
      ),
      child: Column(
          children: [
            Container(
              height: 76.w,
              color: ColorExt.random,
            ),
            ...Container(
              height: 46.w,
              color: ColorExt.random,
            )*3,
          ]),
    );
  }

  buildFooter() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildTab(
            controller: _tabController,
            tabs: _tabItems.map((e) => Tab(
              text: e.item1,
            )).toList(),
            onTap: (int index) async {
              debugPrint("buildTab: $index");
              _pageController.jumpToPage(index);
            }
        ),
        SizedBox(height: 12.w,),
        Expanded(
          child: buildPageView(),
        ),
      ],
    );
  }

  buildTab({
    required TabController? controller,
    required List<Widget> tabs,
    required ValueChanged<int>? onTap,
    Color color = Colors.blue,
  }) {
    return PreferredSize(
      preferredSize: Size(double.maxFinite, 30.h),
      child: SizedBox(
        height: 50.h,
        child: TabBar(
          controller: controller,
          // isScrollable: tabScrollable,
          indicatorColor: color,
          labelPadding: EdgeInsets.zero,
          labelColor: color,
          labelStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelColor: fontColor[20],
          unselectedLabelStyle: TextStyle(
            // color: primary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
          indicator: TabBarIndicatorFixed(
              width: 32.w,
              height: 2.h,
              color: color
          ),
          onTap: onTap,
          tabs: tabs,
        ),
      ),
    );
  }

  Widget buildPageView({bool needRemovePadding = false}) {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        _tabController.animateTo(index);
        setState(() {});
      },
      children: _tabItems.map((e) {
        if (!needRemovePadding) {
          return e.item2;
        }
        return MediaQuery.removePadding(
          removeTop: true,
          removeBottom: true,
          context: context,
          child: e.item2,
        );
      }).toList(),
    );
  }

  Widget buildPaticentRecord() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          TextButton(
            onPressed: (){
              debugPrint("患者档");
            },
            child: Text("患者档案"),
          ),
        ],
      ),
    );
  }

  Widget buildPaticentDepartmentPage() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          TextButton(
            onPressed: (){
              debugPrint("患者档");
            },
            child: Text("患者档案"),
          ),
        ],
      ),
    );

  }

  Widget buildPaticentSchedule() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ...Padding(
            padding: EdgeInsets.symmetric(vertical: 16.w),
            child: TextButton(
              onPressed: (){
                debugPrint("日程");
              },
              child: Text("日程"),
            ),
          )*3,
        ],
      ),
    );

  }

}