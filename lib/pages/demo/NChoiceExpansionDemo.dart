import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_choice_box.dart';
import 'package:flutter_templet_project/basicWidget/n_choice_expansion.dart';
import 'package:flutter_templet_project/basicWidget/n_choice_expansion_of_model.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/basicWidget/n_resize.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/model/order_model.dart';
import 'package:flutter_templet_project/model/tag_detail_model.dart';
import 'package:flutter_templet_project/model/user_model.dart';
import 'package:get/get.dart';

class NChoiceExpansionDemo extends StatefulWidget {
  NChoiceExpansionDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<NChoiceExpansionDemo> createState() => _NChoiceExpansionDemoState();
}

class _NChoiceExpansionDemoState extends State<NChoiceExpansionDemo> {
  bool get hideApp => Get.currentRoute.toLowerCase() != "/$widget".toLowerCase();

  final _scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  bool isSingle = false;

  final tags = List.generate(
      10,
      (i) => TagDetailModel(
            id: i.toString(),
            name: "标签$i",
          )).toList();
  List<TagDetailModel> selectedTags = [];

  final users = List.generate(10, (i) {
    final model = UserModel(
      id: i.toString() ?? "",
      name: "订单$i",
    );
    model.isSelected = true;
    return model;
  }).toList();

  List<UserModel> selectedUsers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
              actions: [
                'done',
              ]
                  .map((e) => TextButton(
                        child: Text(
                          e,
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => debugPrint(e),
                      ))
                  .toList(),
            ),
      body: buildBody(),
    );
  }

  TagDetailModel? selectTag;

  buildBody() {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Column(children: [
          NPair(
            icon: NText("单选($isSingle)"),
            child: NResize(
              width: 40,
              height: 25,
              child: CupertinoSwitch(
                value: isSingle,
                onChanged: (bool val) {
                  isSingle = val;
                  setState(() {});
                },
              ),
            ),
          ),
          ...buildChoiceExpansions(),
        ]),
      ),
    );
  }

  List<Widget> buildChoiceExpansions() {
    return [
      NChoiceExpansion(
        title: '标签 单选(用对象 id 对比)',
        items: tags,
        titleCb: (e) => e.name ?? "",
        selectedCb: (e) => e.id == selectTag?.id,
        onSelected: (e) {
          if (selectTag == e) {
            selectTag = null;
          } else {
            selectTag = e;
          }
          DLog.d(e.name);
          // DLog.d(items.where((e) => e.isSelected).map((e) => e.name ?? ""));
        },
        itemBuilder: (e, isSelected) {
          // final isSelected = e.id == selectTag?.id;
          return buildItem(
            e: e,
            isSelected: isSelected,
            titleCb: (e) => e.name ?? "",
          );
        },
      ),
      NChoiceExpansionOfModel(
        title: '标签',
        items: tags,
        isSingle: isSingle,
        idCb: (e) => e.id ?? "",
        titleCb: (e) => e.name ?? "",
        selectedCb: (e) => selectedTags.map((e) => e.id).contains(e.id),
        onChanged: (list) {
          DLog.d("list: ${list.map((e) => "${e.name}_${e.isSelected}")}");
          selectedTags = list;
        },
        itemBuilder: (e, isSelected) {
          // final isSelected = selectedTags.map((e) => e.id).contains(e.id);
          return buildItem(
            e: e,
            isSelected: isSelected,
            titleCb: (e) => e.name ?? "",
          );
        },
      ),
      NChoiceExpansionOfModel(
        title: '人员',
        items: users,
        isSingle: isSingle,
        idCb: (e) => e.id ?? "",
        titleCb: (e) => e.name ?? "",
        selectedCb: (e) => selectedUsers.map((e) => e.id).contains(e.id),
        onChanged: (list) {
          DLog.d("list: ${list.map((e) => "${e.name}_${e.isSelected}")}");
          selectedUsers = list;
        },
        itemBuilder: (e, isSelected) {
          // final isSelected = selectedUsers.map((e) => e.id).contains(e.id);
          return buildItem(
            e: e,
            isSelected: isSelected,
            titleCb: (e) => e.name ?? "",
          );
        },
      ),
    ]
        .map((e) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: e,
            ))
        .toList();
  }

  /// 子元素自定义
  Widget buildItem<T>({
    required T e,
    required bool isSelected,
    required String Function(T e) titleCb,
    Color primaryColor = Colors.green,
  }) {
    final textColor = isSelected ? primaryColor : Color(0xff737373);
    final borderColor = isSelected ? primaryColor : Colors.transparent;
    final bgColor = textColor.withOpacity(0.1);

    final title = titleCb(e);

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: NText(
        title,
        fontSize: 14,
        color: textColor,
      ),
    );
  }
}
