

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_persistent_header_delegate.dart';
import 'package:flutter_templet_project/basicWidget/n_tab_bar_page.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';


class SliverTabBarDemo extends StatefulWidget {

  SliverTabBarDemo({
    super.key, 
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<SliverTabBarDemo> createState() => _SliverTabBarDemoState();
}

class _SliverTabBarDemoState extends State<SliverTabBarDemo> with SingleTickerProviderStateMixin {

  bool get hideApp => Get.currentRoute.toLowerCase() != "/$widget".toLowerCase();


  late final List<Tuple2<String, Widget>> items = [
    Tuple2("人群画像", buildPage()),
    Tuple2("患者病史", buildPage()),
    Tuple2("健康指标", buildPage()),
    Tuple2("异常指标", buildPage()),
  ];


  late final tabController = TabController(length: items.length, vsync: this);

  final scrollController = ScrollController();

  final offsetY = ValueNotifier(0.0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(() {
      // offsetY.value = scrollController.position.pixels;
      // ddlog("offsetY.value: ${offsetY.value}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black.withOpacity(0.05),
      appBar: AppBar(
        // systemOverlayStyle: YlSystemOverlayStyle.dark,
        // backgroundColor: Colors.transparent,
        title: const Text('患者分析'),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverAppBar(
          // primary: true,
          // automaticallyImplyLeading: false,
          // expandedHeight: 200,
          toolbarHeight: 0,
          pinned: true,
          forceMaterialTransparency: true,
        ),
        SliverPersistentHeaderBuilder(
          pinned: true,
          max: 200,
          min: 0,
          builder: (ctx, offset, overlapsContent) {

            return Container(
              color: Colors.red,
            );
          }
        ),
        SliverPersistentHeaderBuilder(
          pinned: true,
          max: 48,
          min: 48,
          builder: (ctx, offset, overlapsContent) {
            return SizedBox.expand(
              child: Container(
                // margin: const EdgeInsets.only(top: 48),
                // padding: const EdgeInsets.only(top: 48),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(width: 0, color: Color(0xFFE5E5E5))
                  ),
                ),
                child: TabBar(
                  controller: tabController,
                  tabAlignment: TabAlignment.center,
                  labelColor: context.primaryColor,
                  labelPadding: const EdgeInsets.only(left: 8, right: 8),
                  labelStyle: TextStyle(fontWeight: FontWeight.w500,),
                  padding: EdgeInsets.zero,
                  indicatorWeight: 2,
                  indicatorColor: context.primaryColor,
                  isScrollable: false,
                  tabs: items.map((e) => Tab(text: e.item1)).toList(),
                ),
              ),
            );
          },
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return ListTile(
              title: Text('Item $index'),
          );
        }, childCount: 20),),
        // SliverToBoxAdapter(
        //   child: AnimatedBuilder(
        //       animation: Listenable.merge([
        //         tabController,
        //         offsetY,
        //       ]),
        //       builder: (context, child){
        //
        //         return MediaQuery.removePadding(
        //           context: context,
        //           // removeBottom: true,
        //           removeTop: true,
        //           child: items[tabController.index].item2,
        //         );
        //       }
        //   ),
        // ),
        // SliverFillRemaining(
        //   child: AnimatedBuilder(
        //       animation: Listenable.merge([
        //         tabController,
        //         offsetY,
        //       ]),
        //       builder: (context, child){
        //
        //         return MediaQuery.removePadding(
        //           context: context,
        //           // removeBottom: true,
        //           removeTop: true,
        //           child: items[tabController.index].item2,
        //         );
        //       }
        //   ),
        // ),
      ],
    );
  }

  Widget buildPage() {
    final scrollController = ScrollController();

    final titles = List.generate(20, (index) => index);
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      child: Scrollbar(
        controller: scrollController,
        child: ListView.builder(
          controller: scrollController,
          itemCount: titles.length,
          itemBuilder: (_, index){

            return ListTile(
              title: Text("${tabController.index} 选项_$index"),
            ).toColoredBox(color: ColorExt.random);
          }
        ),
      ),
    );
  }
}
