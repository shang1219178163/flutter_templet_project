
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_choice_expansion.dart';
import 'package:flutter_templet_project/basicWidget/n_choice_expansion_of_model.dart';
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
        onSelect: (e) {
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
      buildChoiceExpansion(
        items: items,
        isSingle: true,
        onChanged: (list){
          // ddlog(list.map((e) => "${e.name}_${e.isSelected}"));
        },
        onSingleChanged: (val){
          ddlog("onSingleChanged: ${val?.name}_${val?.isSelected}");
        }
      ),
      buildChoiceExpansion(
        items: items,
        isSingle: false,
        onChanged: (list){
          // ddlog(list.map((e) => "${e.name}_${e.isSelected}"));
        },
        itemBuilder: (e) {
          final isSelected = (e.isSelected == true);
          return buildItem(e: e, isSelected: isSelected);
        },
      ),
      NChoiceExpansionOfModel(
        title: '多多',
        items: items,
        isMuti: true,
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

  Widget buildChoiceExpansion<T extends TagDetailModel>({
    String title = "标签选择",
    required List<T> items,
    required bool isSingle,
    required ValueChanged<List<T>> onChanged,
    ValueChanged<T?>? onSingleChanged,
    Widget Function(T e)? itemBuilder,
  }) {
    return NChoiceExpansion(
      title: '$title(${isSingle ? "单选" : "多选"})',
      items: items,
      titleCb: (e) => e.name ?? "",
      selectedCb: (e) => e.isSelected == true,
      onSelect: (e) {
        // ddlog(e.name);
        for (final element in items) {
          if (element.id == e.id) {
            element.isSelected = !element.isSelected;
          } else {
            if (isSingle) {
              element.isSelected = false;
            }
          }
        }
        final selecetdItems = items.where((e) => e.isSelected).toList();
        // ddlog(selecetdItems.map((e) => e.name ?? ""));
        onChanged(selecetdItems);

        final first = selecetdItems.isEmpty ? null : selecetdItems.first;
        onSingleChanged?.call(first);
      },
      itemBuilder: itemBuilder,
    );
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