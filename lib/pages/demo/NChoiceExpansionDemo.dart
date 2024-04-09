
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_choice_expansion.dart';
import 'package:flutter_templet_project/basicWidget/n_choice_expansion_of_model.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/basicWidget/n_resize.dart';
import 'package:flutter_templet_project/basicWidget/n_section_header.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/model/tag_detail_model.dart';
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

  final items = List.generate(20, (i) => TagDetailModel(
    id: i.toString(),
    name: "标签$i",
  )).toList();

  bool isSingle = false;


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

  TagDetailModel? selectTag;

  buildBody() {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Column(
            children: [
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
            ]
        ),
      ),
    );
  }

  List<Widget> buildChoiceExpansions() {
    return [
      NChoiceExpansion(
        title: '标签 单选',
        items: items,
        titleCb: (e) => e.name ?? "",
        selectedCb: (e) => e.id == selectTag?.id,
        onSelected: (e) {
          if (selectTag == e) {
            selectTag = null;
          } else {
            selectTag = e;
          }
          ddlog(e.name);
          // ddlog(items.where((e) => e.isSelected).map((e) => e.name ?? ""));
        },
        itemBuilder: (e) {
          final isSelected = (e.id == selectTag?.id);
          return buildItem(e: e, isSelected: isSelected, primaryColor: Colors.red);
        },
      ),
      NChoiceExpansionOfModel(
        title: '多多',
        items: items,
        isSingle: isSingle,
        onChanged: (list){
          ddlog(list.map((e) => "${e.name}_${e.isSelected}"));
        },
        itemBuilder: (e) {
          final isSelected = (e.isSelected == true);
          return buildItem(e: e, isSelected: isSelected);
        },
      ),
    ];
  }

  /// 子元素自定义
  Widget buildItem<T extends TagDetailModel>({
    required T e,
    required bool isSelected,
    Color primaryColor = Colors.green,
  }) {
    final textColor = isSelected ? primaryColor : Color(0xff737373);
    final borderColor = isSelected ? primaryColor : Colors.transparent;
    final bgColor = textColor.withOpacity(0.1);

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
        e.name ?? "",
        fontSize: 14,
        color: textColor,
      ),
    );
  }
}