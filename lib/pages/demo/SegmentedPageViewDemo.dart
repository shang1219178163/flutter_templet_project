import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/enhance/en_sliding_segmented_control/n_sliding_segmented_control.dart';
import 'package:flutter_templet_project/basicWidget/enhance/en_sliding_segmented_control/n_sliding_segmented_page_view.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:get/get.dart';

class SegmentedPageViewDemo extends StatefulWidget {
  SegmentedPageViewDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<SegmentedPageViewDemo> createState() => _SegmentedPageViewDemoState();
}

class _SegmentedPageViewDemoState extends State<SegmentedPageViewDemo> {
  bool get hideApp =>
      Get.currentRoute.toLowerCase() != "/$widget".toLowerCase();

  final _scrollController = ScrollController();

  late final pageController = PageController(initialPage: 0, keepPage: true);

  late final items = <({
    String title,
    String icon,
    Widget child,
  })>[
    (
      title: "医生",
      icon: "icon_segmented_control_doctor_gray.png",
      child: Container(
        color: ColorExt.random,
      ),
    ),
    (
      title: "健管师",
      icon: "",
      child: Container(
        color: ColorExt.random,
      ),
    ),
  ];

  late final selectedIndexVN = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
            ),
      body: buildBodyNew(),
    );
  }

  buildBodyNew() {
    return NSlidingSegmentedPageView(
      items: items,
      selectedIndex: 1,
    );
  }

  buildBody() {
    return buildSlidingSegmentedControl(
        // segmentedBuilder: (NSlidingSegmentedControl segmentedControl) {
        //   return Container(
        //     // padding: EdgeInsets.symmetric(horizontal: 48, vertical: 14),
        //     padding: EdgeInsets.only(left: 48, right: 48, top: 12, bottom: 16),
        //     decoration: BoxDecoration(
        //       color: Colors.yellow,
        //       // border: Border.all(color: Colors.blue),
        //       // borderRadius: BorderRadius.all(Radius.circular(0)),
        //     ),
        //     child: segmentedControl,
        //   );
        // },
        );
  }

  buildSlidingSegmentedControl({
    Widget Function(NSlidingSegmentedControl segmentedControl)?
        segmentedBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ValueListenableBuilder<int>(
            valueListenable: selectedIndexVN,
            builder: (context, selectedIndex, child) {
              final segmentedControl = NSlidingSegmentedControl(
                items:
                    items.map((e) => (title: e.title, icon: e.icon)).toList(),
                selectedIndex: selectedIndex,
                onChanged: (int index) {
                  ddlog("onChanged: $index");
                  pageController.animateToPage(index,
                      duration: Duration(milliseconds: 350),
                      curve: Curves.ease);
                  // pageController.jumpToPage(index);
                },
              );

              return segmentedBuilder?.call(segmentedControl) ??
                  Container(
                    padding: EdgeInsets.only(
                      left: 48,
                      right: 48,
                      top: 12,
                      bottom: 16,
                    ),
                    decoration: BoxDecoration(
                        // color: Colors.green,
                        // border: Border.all(color: Colors.blue),
                        // borderRadius: BorderRadius.all(Radius.circular(0)),
                        ),
                    child: segmentedControl,
                  );
            }),
        Expanded(
          child: buildPageView(),
        ),
      ],
    );
  }

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        selectedIndexVN.value = index;
      },
      children: items.map((e) => e.child).toList(),
    );
  }
}
