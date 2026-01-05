import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_slidable_tabbar.dart';
import 'package:flutter_templet_project/basicWidget/tab/model/n_tabbar_data_model.dart';
import 'package:flutter_templet_project/basicWidget/tab/n_chrome_tab_bar.dart';
import 'package:flutter_templet_project/basicWidget/tab/n_outline_tabbar.dart';

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
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

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
            NChromeTabBar(
              items: itemsNew,
              indexVN: indexVN,
              // onChanged: (v) {},
              bgColor: AppColor.bgColorF7F7F7,
              selectedBgColor: Colors.white,
            ),
            NChromeTabBar(
              items: items,
              indexVN: indexVN,
              // onChanged: (v) {},
              itemBuilder: buildItemBuilder,
            ),
            NOutlineTabbar(
              items: items,
              indexVN: indexVN,
              onChanged: (v) {},
              itemBuilder: buildItemBuilder,
            ),
            NSlidableTabbar(
              items: List.generate(3, (i) => "选项$i"),
              onChanged: (int v) {
                DLog.d(v);
              },
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
}
