import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/model/user_model.dart';
import 'package:flutter_templet_project/util/dlog.dart';

/// 单选/多选模型
class SelectListDemo extends StatefulWidget {
  SelectListDemo({
    super.key,
  });

  @override
  State<SelectListDemo> createState() => _SelectListDemoState();
}

class _SelectListDemoState extends State<SelectListDemo> {
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
      onSelected: (items) {
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

  final bool isMultiple;

  final List<UserModel> models;

  final ValueChanged<List<UserModel>> onSelected;

  @override
  State<SelectList> createState() => _SelectListState();
}

class _SelectListState extends State<SelectList> {
  late final themeData = Theme.of(context);
  late final primary = themeData.colorScheme.primary;
  late final isDark = themeData.brightness == Brightness.dark;

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
        child: ListView.separated(
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

            return ListTile(
              dense: true,
              onTap: onTap,
              leading: Checkbox(
                value: e.isSelected == true,
                onChanged: (value) {
                  onTap();
                },
              ),
              title: NText(e.name ?? "--"),
              subtitle: NText("第$i位候选人"),
            );
          },
          separatorBuilder: (_, i) => Divider(),
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
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(width: 16),
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
            },
          ),
          SizedBox(width: 30),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: primary,
                // border: Border.all(color: Colors.blue),
              ),
              child: Text(
                "确定",
                style: TextStyle(
                  color: themeData.colorScheme.onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'PingFang SC',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  updateSelectedCount() {
    selectedCount.value = selectedItems.length;
  }
}
