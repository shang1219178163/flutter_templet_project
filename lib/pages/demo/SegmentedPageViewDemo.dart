import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_sliding_segmented_control.dart';
import 'package:flutter_templet_project/basicWidget/n_sliding_segmented_page_view.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:get/get.dart';

/// 带页面的滑动分段组件页面 NSlidingSegmentedPageView
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
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  late final pageController = PageController(initialPage: 0, keepPage: true);

  late final items = <({
    String title,
    String icon,
    Widget child,
  })>[
    (
      title: "医生",
      icon: Assets.imagesIconSegmentedControlDoctorGray,
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

  Widget buildBodyNew() {
    return NSlidingSegmentedPageView(
      items: items,
      selectedIndex: 1,
    );
  }

  Widget buildBody() {
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

  Widget buildSlidingSegmentedControl({
    Widget Function(NSlidingSegmentedControl segmentedControl)? segmentedBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ValueListenableBuilder<int>(
            valueListenable: selectedIndexVN,
            builder: (context, selectedIndex, child) {
              final segmentedControl = NSlidingSegmentedControl(
                items: items.map((e) => (title: e.title, icon: e.icon)).toList(),
                selectedIndex: selectedIndex,
                onChanged: (index) {
                  DLog.d("onChanged: $index");
                  pageController.animateToPage(index, duration: Duration(milliseconds: 350), curve: Curves.ease);
                  // pageController.jumpToPage(index);
                },
                itemBuilder: (({String icon, String title}) e, isSelecetd) {
                  return Text(e.title);
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
