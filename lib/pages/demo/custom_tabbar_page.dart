import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/basicWidget/n_slidable_tabbar.dart';
import 'package:flutter_templet_project/basicWidget/tab/model/n_tabbar_data_model.dart';
import 'package:flutter_templet_project/basicWidget/tab/n_chrome_tab.dart';
import 'package:flutter_templet_project/basicWidget/tab/n_chrome_tab_bar.dart';
import 'package:flutter_templet_project/basicWidget/tab/n_outline_tabbar.dart';
import 'package:flutter_templet_project/basicWidget/tab/n_tab_outline_item.dart';

import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class CustomTabbarPage extends StatefulWidget {
  const CustomTabbarPage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<CustomTabbarPage> createState() => _CustomTabbarPageState();
}

class _CustomTabbarPageState extends State<CustomTabbarPage> {
  late final theme = Theme.of(context);
  late final tabBarTheme = theme.tabBarTheme;

  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  final chromeTabController = NChromeTabController();

  final indexVN = ValueNotifier(1);

  final items = [
    NTabbarDataModel(
      title: "全部预测",
      value: "all",
      bg: AssetImage("assets/images/bg_tab_left.png"),
      bgColor: Colors.blue,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.purple,
      ),
    ),
    NTabbarDataModel(
      title: "足球预测",
      value: "football",
      bg: AssetImage("assets/images/bg_tab_center.png"),
      bgColor: Colors.yellow,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.green,
      ),
    ),
    NTabbarDataModel(
      title: "篮球预测",
      value: "basketball",
      bg: AssetImage("assets/images/bg_tab_right.png"),
      bgColor: Colors.green,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.blue,
      ),
    ),
  ];

  late final itemsNew = [
    NTabbarDataModel(
      title: "全部预测",
      value: "all",
      bg: AssetImage("assets/images/bg_tab_left.png"),
    ),
    NTabbarDataModel(
      title: "足球预测",
      value: "football",
      bg: AssetImage("assets/images/bg_tab_center.png"),
    ),
    NTabbarDataModel(
      title: "篮球预测",
      value: "basketball",
      bg: AssetImage("assets/images/bg_tab_right.png"),
    ),
  ];

  final titles = List.generate(9, (i) => "选项$i");
  final titleIndexVN = ValueNotifier(1);

  @override
  void didUpdateWidget(covariant CustomTabbarPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder(
              valueListenable: indexVN,
              builder: (context, i, child) {
                final str = ["index: $i", "${items[i]}"].join("\n");
                return Text(str);
              },
            ),
            Row(
              children: [
                ...items.map((e) {
                  final hideSeperator = e == items.last;
                  return Expanded(
                    child: Container(
                      padding: EdgeInsets.only(right: hideSeperator ? 0 : 8),
                      child: OutlinedButton(
                        onPressed: () {
                          final i = items.indexOf(e);
                          // chromeTabController.jumpTo(i);
                          indexVN.value = i;
                          titleIndexVN.value = i;
                        },
                        child: Text(e.title),
                      ),
                    ),
                  );
                }),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColor.bgColorF7F7F7,
              ),
              child: NSectionBox(
                hide: true,
                title: "NChromeTabBar - itemsNew",
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12).copyWith(bottom: 0),
                divider: SizedBox(),
                child: NChromeTabBar(
                  items: itemsNew,
                  indexVN: indexVN,
                  // onChanged: (v) {},
                  bgColor: AppColor.bgColorF7F7F7,
                  selectedBgColor: Colors.white,
                ),
              ),
            ),
            NSectionBox(
              hide: true,
              title: "NChromeTabBar - items",
              child: NChromeTabBar(
                items: items,
                indexVN: indexVN,
                // onChanged: (v) {},
                // itemBuilder: buildItemBuilder,
              ),
            ),
            NSectionBox(
              title: "NChromeTab",
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12).copyWith(bottom: 0),
              child: NChromeTab(
                controller: chromeTabController,
                items: titles,
                indexVN: indexVN,
                // onChanged: (v) {},
                tabAlignment: TabAlignment.fill,
                // itemBuilder: buildItemBuilderOne,
              ),
            ),
            NSectionBox(
              title: "NChromeTab - itemBuilder",
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12).copyWith(bottom: 0),
              child: NChromeTab(
                controller: chromeTabController,
                items: titles,
                indexVN: indexVN,
                // onChanged: (v) {},
                itemBuilder: buildItemBuilderOne,
              ),
            ),
            NSectionBox(
              title: "NChromeTab - isScrollable",
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12).copyWith(bottom: 0),
              child: NChromeTab(
                controller: chromeTabController,
                items: titles,
                indexVN: indexVN,
                // onChanged: (v) {},
                isScrollable: true,
                itemPadding: EdgeInsets.symmetric(horizontal: 50),
                // itemBuilder: buildItemBuilderOne,
              ),
            ),
            NSectionBox(
              // hide: true,
              title: "NOutlineTabbar - items",
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              child: NOutlineTabbar(
                items: titles.sublist(0, 2),
                indexVN: titleIndexVN,
                onChanged: (v) {},
                height: 30,
                itemWidth: 80,
                // itemPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                // itemBuilder: buildItemBuilderTwo,
              ),
            ),
            NSectionBox(
              // hide: true,
              title: "NOutlineTabbar - isWrap",
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
              child: Container(
                // decoration: BoxDecoration(
                //   border: Border.all(color: Colors.blue),
                // ),
                child: NOutlineTabbar(
                  key: ValueKey("value"),
                  items: titles,
                  indexVN: titleIndexVN,
                  isWrap: true,
                  itemWidth: 80,
                  onChanged: (v) {},
                  itemBuilder: buildItemBuilderTwo,
                ),
              ),
            ),
            NSectionBox(
              // hide: true,
              title: "NOutlineTabbar - isScrollable",
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
              child: Container(
                // decoration: BoxDecoration(
                //   border: Border.all(color: Colors.blue),
                // ),
                child: NOutlineTabbar(
                  items: titles,
                  indexVN: titleIndexVN,
                  isScrollable: true,
                  itemWidth: 86,
                  itemPadding: EdgeInsets.zero,
                  onChanged: (v) {},
                  itemBuilder: buildItemBuilderTwo,
                ),
              ),
            ),
            NSectionBox(
              hide: true,
              title: "NSlidableTabbar",
              child: NSlidableTabbar(
                items: List.generate(3, (i) => "选项$i"),
                onChanged: (int v) {
                  DLog.d(v);
                },
              ),
            ),
          ].map((e) {
            return Container(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 10),
              child: e,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget buildItemBuilder(BuildContext context, int i) {
    final e = items[i];
    switch (i) {
      case 1:
        {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image(
                image: AssetImage("assets/images/icon_football.png"),
                width: 16,
                height: 16,
              ),
              SizedBox(width: 4),
              Text(e.title, style: e.style),
            ],
          );
        }
        break;
      case 2:
        {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image(
                image: AssetImage("assets/images/icon_basketball.png"),
                width: 16,
                height: 16,
              ),
              SizedBox(width: 4),
              Text(e.title, style: e.style),
            ],
          );
        }
        break;
      default:
        break;
    }
    return Text(e.title, style: e.style);
  }

  Widget buildItemBuilderOne(BuildContext context, int i) {
    final e = items[i];
    final isSelected = indexVN.value == i;

    final bgColor = e.bgColor;
    final colorFilter = bgColor == null ? null : ColorFilter.mode(bgColor, BlendMode.srcIn);
    final image = isSelected
        ? DecorationImage(
            image: e.bg!,
            fit: BoxFit.fill,
            colorFilter: colorFilter,
          )
        : null;

    Widget imgPrefix = SizedBox();
    switch (i) {
      case 1:
        {
          imgPrefix = Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: Image(
              image: AssetImage("assets/images/icon_football.png"),
              width: 16,
              height: 16,
            ),
          );
        }
        break;
      case 2:
        {
          imgPrefix = Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: Image(
              image: AssetImage("assets/images/icon_basketball.png"),
              width: 16,
              height: 16,
            ),
          );
        }
        break;
      default:
        break;
    }
    return Container(
      // padding: widget.itemPadding,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        image: image,
      ),
      child: Container(
        alignment: Alignment.center,
        // decoration: BoxDecoration(
        //   color: Colors.transparent,
        //   border: Border.all(color: Colors.blue),
        // ),
        child: Flex(
          direction: Axis.horizontal,
          mainAxisSize: MainAxisSize.min,
          children: [
            imgPrefix,
            Text(e.title, style: e.style),
          ],
        ),
      ),
    );
  }

  Widget buildItemBuilderTwo(BuildContext context, int i) {
    final e = titles[i];
    final isSelected = titleIndexVN.value == i;

    return NTabOutlineItem(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      title: e,
      isSelected: isSelected,
      fontColor: Colors.green,
      unselectedFontColor: Colors.black54,
      builder: (_, child) {
        return Flex(
          direction: Axis.horizontal,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Image(
                image: AssetImage("assets/images/icon_football.png"),
                width: 16,
                height: 16,
              ),
            ),
            Flexible(child: child),
          ],
        );
      },
    );
  }
}
