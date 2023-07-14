

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_placeholder.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/tab_bar_indicator_fixed.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/uti/color_uti.dart';
import 'package:tuple/tuple.dart';

class PageViewDemoOne extends StatefulWidget {

  PageViewDemoOne({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _PageViewDemoOneState createState() => _PageViewDemoOneState();
}

class _PageViewDemoOneState extends State<PageViewDemoOne> with SingleTickerProviderStateMixin {
  late final scrollController = ScrollController();

  late final List<Tuple3<String, Widget, List<ItemModel>>> _tabItems = [
    Tuple3("团队患者", buildPageViewChild(), []),
    Tuple3("我的患者", buildPageViewChild(), []),
  ];

  List<Tuple3<String, Widget, List<ItemModel>>> get tabItems =>
      _tabItems.where((e) => e.item3.isNotEmpty).toList();

  final tabIndex = ValueNotifier(0);

  late final _tabController = TabController(length: _tabItems.length, vsync: this);

  late final _pageController = PageController(initialPage: tabIndex.value, keepPage: true);


  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    debugPrint("${DateTime.now()} $widget initState");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => debugPrint(e),)
        ).toList(),
      ),
      body: buildBody()
    );
  }


  buildBody() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Offstage(
            offstage: _tabItems.length <= 1,
            child: Column(
              children: [
                buildTab(
                  controller: _tabController,
                  tabs: _tabItems.map((e) => Tab(
                    text: e.item1,
                  )).toList(),
                  onTap: (int index) async {
                    // debugPrint("buildTab: $index");
                    tabIndex.value = index;
                    _pageController.jumpToPage(index);
                  }
                ),
                SizedBox(height: 8.w,),
                buildDebugInfo(),
              ],
            ),
          ),
          if (tabItems.isEmpty) buildDebugInfo(),
          Expanded(
            child: buildPageView(),
          ),
        ],
      ),
    );
  }

  Widget buildTab({
    required TabController? controller,
    required List<Widget> tabs,
    required ValueChanged<int>? onTap,
    Color? color = Colors.blue,
  }) {

    Color? primary = color ?? context.primaryColor;
    return PreferredSize(
      preferredSize: Size(double.maxFinite, 30.h),
      child: SizedBox(
        height: 40.h,
        child: TabBar(
          controller: controller,
          // isScrollable: tabScrollable,
          indicatorColor: color,
          labelPadding: EdgeInsets.zero,
          labelColor: color,
          labelStyle: TextStyle(
            color: primary,
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
              color: primary,
          ),
          onTap: onTap,
          tabs: tabs,
        ),
      ),
    );
  }

  Widget buildPageView({bool needRemovePadding = false}) {
    return Stack(
      children: [
        PageView(
          controller: _pageController,
          onPageChanged: (index) {
            tabIndex.value = index;
            _tabController.animateTo(index);
            // setState(() {});
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
        ),
        if(_tabItems.isNotEmpty)Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 40,
          child: Container(
            // color: Colors.black12,
            child: ValueListenableBuilder<int>(
               valueListenable: tabIndex,
               builder: (context, value, child){

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(
                    _tabItems.length,
                        (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: CircleAvatar(
                        radius: 5,
                        backgroundColor: index == value
                            ? Colors.greenAccent
                            : Colors.white30,
                      ),
                    ),
                  ),
                );
              }
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPageViewChild() {
    return Container(color: ColorExt.random,);
  }

  Widget buildPlaceholder() {
    return NPlaceholder(
      imageAndTextSpacing: 10.h,
      onTap: () async {
        debugPrint("NPlaceholder");

      },
    );
  }

  // Widget buildPageViewNew({
  //   required PageView pageView,
  //
  // }) {
  //
  //   final itemCount = (pageView.childrenDelegate as SliverChildListDelegate).children.length;
  //   return Scaffold(
  //     // will make use of Stack Widget, so that One Widget can we placed on top
  //     body: Stack(
  //       children: [
  //         pageView,
  //         Positioned(
  //           bottom: 0,
  //           left: 0,
  //           right: 0,
  //           height: 40,
  //           child: Container(
  //             color: Colors.black12,
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: List<Widget>.generate(
  //                 itemCount,
  //                  (index) => Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 8),
  //                     child: CircleAvatar(
  //                         radius: 5,
  //                         backgroundColor: _activePage == index
  //                             ? Colors.greenAccent
  //                             : Colors.white30,
  //                       ),
  //                     ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  /// Debug 信息
  Widget buildDebugInfo() {
    return SizedBox();
  }

  jumpToPage(int page) {
    if (!_pageController.hasClients) {
      return;
    }
    _pageController.jumpToPage(page);
  }



}


class ItemModel {
  ItemModel({
    required this.icon,
    required this.name,
    required this.cb,
});

  String icon;

  String name;

  VoidCallback cb;
}