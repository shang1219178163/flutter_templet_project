//
//  NRefreshListViewDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/3/22 18:04.
//  Copyright © 2024/3/22 shang. All rights reserved.
//






import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/NNet/NRefreshListView.dart';
import 'package:flutter_templet_project/basicWidget/n_network_image.dart';
import 'package:flutter_templet_project/basicWidget/n_selected_cell.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/value_notifier_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/mixin/selected_mixin.dart';
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

  final refreshListViewController = NRefreshListViewController<UserModel>();

  var dataList = ValueNotifier(<UserModel>[]);

  var isEditVN = ValueNotifier(false);
  var selectedList = ValueNotifier(<UserModel>[]);

  initData(){
    dataList.value = List.generate(20, (index) => UserModel(
        id: index + 1000,
        name: "用户_$index",
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp ? null : AppBar(
        title: Text("$widget"),
        actions: [
          ValueListenableBuilder(
             valueListenable: isEditVN,
             builder: (context,  isEdit, child){

               final title = isEdit ? "取消" : "选择";
                return TextButton(
                  onPressed: (){
                    isEditVN.value = !isEditVN.value;
                  },
                  child: Text(title,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              }
          ),
        ],
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return Column(
      children: [
        ValueListenableBuilder(
            valueListenable: selectedList,
            builder: (context,  list, child){

              final items = list.map((e) => {
                // "id": e.id,
                "name": e.name,
                // "isSelected": e.isSelected,
              }).toList();
              ddlog(items);

              final count = list.length;
              var desc = "已选择 $count";
              desc = items.join(",");
              return NText("已选择 $desc", maxLines: 100,);
            }
        ),
        Expanded(
          child: ValueListenableBuilder(
             valueListenable: isEditVN,
             builder: (context, isEdit, child){

              return NRefreshListView<UserModel>(
                controller: refreshListViewController,
                pageSize: 10,
                onRequest: (bool isRefresh, int page, int pageSize, last) async {
                  return requestList(isRefresh: isRefresh, pageNo: page, pageSize: pageSize);
                },
                itemBuilder: (BuildContext context, int index, e) {

                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {

                      void onTap() {
                        ddlog("onSelected: ${e.toJson()}");
                      }

                      void onToggle() {
                        e.isSelected = !e.isSelected;
                        ddlog("onSelected: ${e.isSelected}");
                        setState((){});

                        if (e.isSelected) {
                          selectedList.value.add(e);
                        } else {
                          selectedList.value.remove(e);
                        }
                        selectedList.value = [...selectedList.value];
                      }

                      final title = [e.name, e.id, e.isSelected].join(",");
                      final subtitle = "一个特立独行的灵魂";

                      final child = ListTile(
                        dense: true,
                        onTap: !isEdit ? onTap : onToggle,
                        leading: NNetworkImage(
                          url: "",
                          placehorder: AssetImage("img_placeholder_patient.png".toPath()),
                          width: 40,
                          height: 40,
                        ),
                        title: Text(title,
                          style: TextStyle(
                            fontSize: 14,
                            color: e.isSelected ? context.primaryColor : null,
                          ),
                        ),
                        subtitle: Text(subtitle,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      );

                      if (!isEdit) {
                        return child;
                      }

                      return NSelectedCell(
                        isSelected: e.isSelected,
                        onToggle: onToggle,
                        child: child,
                      );
                    }
                  );
                },
              );
            }
          ),
        ),

      ],
    );
  }

  /// 列表数据请求
  Future<List<UserModel>> requestList({
    required bool isRefresh,
    required int pageNo,
    int pageSize = 20,
  }) async {
    await Future.delayed(Duration(milliseconds: 1500));

    final list = List.generate(pageSize, (index) {
      return UserModel(
        // id: IntExt.random(min: 1000, max: 9999),
        id: 1000 + index,
        name: "用户_$index",
        // name: generateChars(),
      );
    });

    if (isRefresh) {
      selectedList.value = [];
    }
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
