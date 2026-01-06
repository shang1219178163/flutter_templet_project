//
//  TestPage.dart
//  flutter_templet_project
//
//  Created by shang on 12/2/21 2:16 PM.
//  Copyright © 12/2/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_templet_project/basicWidget/team_title_gradient_widget.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/AppRes.dart';
import 'package:http/http.dart' as http;
// import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with SingleTickerProviderStateMixin {
  late var items = <({String name, VoidCallback action})>[
    (name: "splitMapJoin", action: onSplit),
    (name: "日期时间", action: onTime),
    (name: "测试", action: onTest),
  ];

  late final tabController = TabController(length: items.length, vsync: this);

  final textStyle = TextStyle(overflow: TextOverflow.ellipsis);

  @override
  void initState() {
    super.initState();

    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        debugPrint("_tabController:${tabController.index}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(AppRes.image.urls[5]),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(widget.title ?? "$widget"),
        bottom: buildAppBarBottom(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildWrap(),
            TeamNameMatchGradientWidget(
              logo: '',
              name: "主队队名",
              awayLogo: '',
              awayName: "客队队名",
              awayColor: Colors.green,
            ),
            SizedBox(height: 34),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget buildAppBarBottom() {
    // final items = List.generate(
    //     6,
    //     (index) => Container(
    //           padding: EdgeInsets.symmetric(horizontal: 8),
    //           child: Text('item_$index'),
    //         )).toList();
    // return PreferredSize(
    //   preferredSize: Size.fromHeight(36),
    //   child: Container(
    //     height: 36,
    //     decoration: BoxDecoration(
    //       color: Colors.green,
    //       border: Border.all(color: Colors.blue),
    //       borderRadius: BorderRadius.all(Radius.circular(0)),
    //     ),
    //     child: Row(
    //       children: items,
    //     ),
    //   ),
    // );

    return TabBar(
      controller: tabController,
      isScrollable: true,
      // labelColor: context.primaryColor,
      // unselectedLabelColor: Theme.of(context).colorScheme.primary,
      tabs: List.generate(6, (index) {
        return Tab(
          text: 'item_$index',
        );
      }).toList(),
      // indicatorSize: TabBarIndicatorSize.label,
      // indicatorPadding: EdgeInsets.only(left: 6, right: 6),
    );
  }

  Widget buildWrap() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      alignment: WrapAlignment.start,
      children: items
          .map((e) => ActionChip(
                avatar: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(e.name.characters.first.toUpperCase()),
                ),
                label: Text(e.name),
                onPressed: e.action,
              ))
          .toList(),
    );
  }

  void onSplit() {}

  onTime() {
    const a = true;
    final b = "nested ${a ? "strings" : "can"} be wrapped by a double quote";

    final val = "1# 8ji#2_3I  ".toInt();
    DLog.d("val: $val");

    final duration = Duration(milliseconds: 146 * 1000);
    DLog.d("duration: $duration");

    DLog.d("toTimeNew: ${duration.toTimeNew()}");
    DLog.d("toTime: ${duration.toStringFormat()}");

    DLog.d("list: ${[
      duration.inHours.remainder(24),
      duration.inMinutes.remainder(60),
      duration.inSeconds.remainder(60),
    ]}");
  }

  void onTest() {
    ScrollNotificationObserver.maybeOf(context);
    Scrollable.maybeOf(context);
  }

  Future<void> _onPressed(int e) async {
    final file = await FileExt.fromAssets("assets/images/icon_skipping.gif");
    DLog.d("file: ${file.fileSizeDesc}");
  }

  Future<XFile> multipartFileToXFile(http.MultipartFile file) async {
    final bytes = await file.finalize().toBytes();
    final xFile = XFile.fromData(bytes, name: file.filename ?? "unknown_file");
    return xFile;
  }
}
