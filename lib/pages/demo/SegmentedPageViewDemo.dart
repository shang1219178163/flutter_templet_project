import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/enhance/en_sliding_segmented_control/n_sliding_segmented_control.dart';
import 'package:flutter_templet_project/basicWidget/enhance/en_sliding_segmented_control/n_sliding_segmented_page_view.dart';

import 'package:get/get.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

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
  bool get hideApp => !"$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

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
                onChanged: (int index) {
                  DLog.d("onChanged: $index");
                  pageController.animateToPage(index, duration: Duration(milliseconds: 350), curve: Curves.ease);
                  // pageController.jumpToPage(index);
                },
                itemBuilder: (({String icon, String title}) e, bool isSelecetd) {
                  final color = isSelecetd ? Colors.white : Color(0xff737373);
                  final icon = isSelecetd ? e.icon : e.icon;

                  return Container(
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      // border: Border.all(color: Colors.blue),
                      // borderRadius: BorderRadius.all(Radius.circular(0)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Image(
                              image: icon.toAssetImage(),
                              width: 12,
                              height: 14,
                              color: color,
                            ),
                          ),
                        if (e.title.isNotEmpty)
                          Flexible(
                            child: Text(
                              e.title,
                              style: TextStyle(
                                fontSize: 14,
                                color: color,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
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
