import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/model/user_model.dart';

/// 单选/多选模型
class SelectListPage extends StatefulWidget {
  SelectListPage({
    super.key,
  });

  @override
  State<SelectListPage> createState() => _SelectListPageState();
}

class _SelectListPageState extends State<SelectListPage> {
  final _scrollController = ScrollController();

  bool isMultiple = true;

  late final List<UserModel> models = List.generate(20, (i) {
    return UserModel(
      id: i.toString(),
      name: "选项_$i",
    );
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    isMultiple = !isMultiple;
                    setState(() {});
                  },
                ))
            .toList(),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return SelectList(
      models: models,
      isMultiple: isMultiple,
      onSelected: (List<UserModel> items) {
        DLog.d(items.map((e) => (e.name,)));
      },
    );
  }
}

class SelectList extends StatefulWidget {
  SelectList({
    super.key,
    this.isMultiple = true,
    required this.models,
    required this.onSelected,
  });

  bool isMultiple;

  List<UserModel> models;

  ValueChanged<List<UserModel>> onSelected;

  @override
  State<SelectList> createState() => _SelectListState();
}

class _SelectListState extends State<SelectList> {
  final _scrollController = ScrollController();

  late final List<UserModel> models = widget.models;

  late final dataList = ValueNotifier(models);

  /// 当前选择个数
  late final selectedCount = ValueNotifier(models.where((e) => e.isSelected == true).length);

  /// 是否全选
  bool get isAll => dataList.value.where((e) => e.isSelected != true).isEmpty;

  /// 已选择
  List<UserModel> get selectedItems => dataList.value.where((e) => e.isSelected == true).toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: buildList()),
        buildBottomSheet(),
      ],
    );
  }

  Widget buildList() {
    return Container(
      child: Scrollbar(
        controller: _scrollController,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: dataList.value.length,
          itemBuilder: (context, i) {
            final e = dataList.value[i];

            onTap() {
              e.isSelected = !e.isSelected;
              // DLog.d(e.toJson());
              setState(() {});

              updateSelectedCount();

              if (!widget.isMultiple) {
                dataList.value.forEach((item) {
                  item.isSelected = (e == item);
                });
                widget.onSelected([e]);
              }
            }

            return InkWell(
              onTap: onTap,
              child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    // border: Border.all(color: Colors.blue),
                    // borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Checkbox(
                          value: e.isSelected == true,
                          onChanged: (bool? value) {
                            onTap();
                          },
                        ),
                        title: NText(e.name ?? "--"),
                        subtitle: NText("第$i位候选人"),
                      ),
                      Divider(
                        indent: 70,
                        height: 1,
                      ),
                    ],
                  )),
            );
          },
        ),
      ),
    );
  }

  Widget buildBottomSheet() {
    if (!widget.isMultiple) {
      return SizedBox();
    }

    return Container(
      height: 65,
      padding: EdgeInsets.only(
        left: 16,
        top: 12,
        right: 16,
        bottom: max(12, MediaQuery.of(context).padding.bottom),
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // CheckboxListTile
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              // minimumSize: Size(50, 30),
              // backgroundColor: Colors.red
            ),
            onPressed: () {
              // DLog.d("isAll: $isAll");
              // DLog.d(dataList.value
              //     .where((e) => e.isSelected != true)
              //     .map((e) => (e.name, e.isSelected)).toList());

              if (isAll) {
                dataList.value.forEach((e) {
                  e.isSelected = false;
                  // e.isSelected = !isAll;
                });
              } else {
                dataList.value.forEach((e) {
                  e.isSelected = true;
                  // e.isSelected = !isAll;
                });
              }
              setState(() {});
              updateSelectedCount();
              // DLog.d(selectedItems);
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(isAll ? Icons.check_box : Icons.check_box_outline_blank),
                ),
                Text("全选"),
              ],
            ),
          ),
          AnimatedBuilder(
              animation: Listenable.merge([
                selectedCount,
                dataList,
              ]),
              builder: (context, child) {
                return Container(
                  width: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    // border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                  child: NText("(${selectedCount.value}/${dataList.value.length})"),
                );
              }),
          SizedBox(
            width: 30,
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                widget.onSelected(selectedItems);
              },
              child: Text("确定"),
            ),
          )
        ],
      ),
    );
  }

  updateSelectedCount() {
    selectedCount.value = selectedItems.length;
  }
}
