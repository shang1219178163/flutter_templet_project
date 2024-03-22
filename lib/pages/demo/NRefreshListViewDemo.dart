//
//  NRefreshListViewDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/3/22 18:04.
//  Copyright © 2024/3/22 shang. All rights reserved.
//






import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/NNet/NRefreshListView.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';
import 'package:flutter_templet_project/model/user_model.dart';
import 'package:get/get.dart';

class NRefreshListViewDemo extends StatefulWidget {

  const NRefreshListViewDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<NRefreshListViewDemo> createState() => _NRefreshListViewDemoState();
}

class _NRefreshListViewDemoState extends State<NRefreshListViewDemo> {

  bool get hideApp =>
      Get.currentRoute.toLowerCase() != "/$widget".toLowerCase();

  /// 获取上个页面传的参数
  /// userId --- 用户id
  late Map<String, dynamic> arguments = widget.arguments ?? Get.arguments;

  var dataList = ValueNotifier(<UserModel>[]);

  initData(){
    dataList.value = List.generate(20, (index) => UserModel(id: index, name: "index_$index"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp ? null : AppBar(
        title: Text("$widget"),
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
    return NRefreshListView<UserModel>(
      pageSize: 5,
      onRequest: (bool isRefresh, int page, int pageSize, last) async {

        return await requestList(pageNo: page, pageSize: pageSize);
      },
      itemBuilder: (BuildContext context, int index, e, onRefresh) {

        final map = e.toJson();
        map.removeWhere((key, value) => value == null);

        return InkWell(
          onTap: () {
            ddlog("${map}");
          },
          child: ListTile(
            title: Text("${map}"),
          ),
        );
      },
    );
  }

  /// 列表数据请求
  Future<List<UserModel>> requestList({
    required int pageNo,
    int pageSize = 20,
  }) async {
    await Future.delayed(Duration(milliseconds: 1500));

    final list = List.generate(pageSize, (index) {
      return UserModel(
        id: IntExt.random(min: 1000, max: 9999),
        // name: "index_$idx",
        name: generateChars(),
      );
    });
    return list;
  }

  String generateChars({int length = 4}) {
    final chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".toLowerCase().characters;
    var tmp = "";
    for (var i = 0; i < length; i++) {
      tmp += "${chars.characterAt(IntExt.random(max: chars.length))}";
    }
    return tmp;
  }
}
