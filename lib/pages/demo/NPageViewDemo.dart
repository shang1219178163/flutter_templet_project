

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/APPThemeSettings.dart';
import 'package:flutter_templet_project/basicWidget/app_update_card.dart';
import 'package:flutter_templet_project/basicWidget/list_subtitle_cell.dart';
import 'package:flutter_templet_project/basicWidget/n_page_view.dart';
import 'package:flutter_templet_project/basicWidget/section_list_view.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/divider_ext.dart';
import 'package:flutter_templet_project/extension/list_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/model/mock_data.dart';
import 'package:flutter_templet_project/pages/tabBar_tabBarView_demo.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';


class NPageViewDemo extends StatefulWidget {

  NPageViewDemo({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _NPageViewDemoState createState() => _NPageViewDemoState();
}

class _NPageViewDemoState extends State<NPageViewDemo> {

  late var isTabBarVN = ValueNotifier(false);

  bool isThemeBg = false;

  bool isScrollable = false;

  bool isBottom = false;

  late final btns = <Tuple2<String, VoidCallback>>[
    Tuple2('主题', onThemeChange),
    Tuple2('位置', onPosition),
    Tuple2('颜色', onThemeBg),
    Tuple2('滑动', onScrollable),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        iconTheme: IconThemeData(color: Colors.white),
        actions: btns.map((e) => TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize: Size(50, 18),
          ),
          onPressed: e.item2,
          child: Text(e.item1,
            style: TextStyle(color: Colors.white),
          ),
        )).toList(),
        elevation: 0,
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return Column(
      children: [
        Expanded(
          child: NPageView(
            items: items,
            isScrollable: isScrollable,
            isThemeBg: isThemeBg,
            isBottom: isBottom,
            needSafeArea: false,
          ),
        ),
        Container(
          height: MediaQuery.of(context).viewPadding.bottom,
          color: isThemeBg && isBottom ? primaryColor : null,
        ),
      ],
    );
  }

  onThemeChange() {
    APPThemeService().changeTheme();
  }

  onPosition() {
    isBottom = !isBottom;
    setState(() {});
  }

  onThemeBg() {
    isThemeBg = !isThemeBg;
    setState(() {});
  }

  onScrollable() {
    isScrollable = !isScrollable;
    setState(() {});
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
        return Divider();
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
      headerList: tuples.map((e) => e.item1).toList(),
      itemList: tuples.map((e) => e.item2).toList()
          .map((e) => e.sorted((a, b) => a.item1.toLowerCase().compareTo(b.item1.toLowerCase()))).toList(),
      headerBuilder: (e) {
        return Container(
          // color: Colors.red,
          padding: EdgeInsets.only(top: 10, bottom: 8, left: 10, right: 15),
          child: Text(e, style: TextStyle(fontWeight: FontWeight.w600),),
        );
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