import 'package:enhance_expansion_panel/enhance_expansion_panel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_templet_project/basicWidget/enhance/enhance_expansion/en_expansion_tile.dart';

import 'package:flutter_templet_project/basicWidget/n_cancel_and_confirm_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_choice_box.dart';
import 'package:flutter_templet_project/basicWidget/n_choice_box_horizontal.dart';
import 'package:flutter_templet_project/basicWidget/n_filter_drop_box.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/util/Debounce.dart';
import 'package:flutter_templet_project/util/color_util.dart';
import 'package:flutter_templet_project/model/fake_data_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tuple/tuple.dart';

class DropBoxMutiRowChoicDemo extends StatefulWidget {
  DropBoxMutiRowChoicDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _DropBoxMutiRowChoicDemoState createState() =>
      _DropBoxMutiRowChoicDemoState();
}

class _DropBoxMutiRowChoicDemoState extends State<DropBoxMutiRowChoicDemo> {
  final items = List.generate(20, (i) => i).toList();

  var searchText = "";
  late final searchtEditingController = TextEditingController();

  final _debounce = Debounce(delay: Duration(milliseconds: 500));

  // final _throttle = Throttle(milliseconds: 500);

  final dropBoxController = NFilterDropBoxController();

  /// 数据源
  List<FakeDataModel> get models => items
      .map((e) => FakeDataModel(
            id: "id_$e",
            name: "选项_$e",
          ))
      .toList();

  /// 数据源
  List<FakeDataModel> get item1Models => items
      .map((e) => FakeDataModel(
            id: "id_$e",
            name: "选项1_$e",
          ))
      .toList();

  /// 数据源
  List<FakeDataModel> get item2Models => items
      .map((e) => FakeDataModel(
            id: "id_$e",
            name: "选项2_$e",
          ))
      .toList();

  /// 数据源
  List<FakeDataModel> get item3Models => items
      .map((e) => FakeDataModel(
            id: "id_$e",
            name: "选项3_$e",
          ))
      .toList();

  late final mutiRowItems = <NChoiceBoxHorizontalModel<FakeDataModel>>[
    NChoiceBoxHorizontalModel<FakeDataModel>(
      title: "第一行",
      models: models,
      // selectedModelsTmp: [],
      // selectedModels: [],
      isSingle: true,
    ),
    NChoiceBoxHorizontalModel<FakeDataModel>(
      title: "第二行",
      models: item1Models,
      // selectedModelsTmp: [],
      // selectedModels: [],
      isSingle: true,
    ),
    NChoiceBoxHorizontalModel<FakeDataModel>(
      title: "第三行",
      models: item2Models,
      // selectedModelsTmp: [],
      // selectedModels: [],
    ),
    NChoiceBoxHorizontalModel<FakeDataModel>(
      title: "第四行",
      models: item3Models,
      // selectedModelsTmp: [],
      // selectedModels: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    bool isSingle = true;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
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
      body: Column(
        children: [
          buildSearchAndFilterBar(
            onToggle: () {
              onFilterInit();
              dropBoxController.onToggle();
              ddlog("dropBoxController: ${dropBoxController.isVisible}");
              closeKeyboard();
            },
          ),
          Expanded(
            child: NFilterDropBox(
              controller: dropBoxController,
              sections: getDropBoxSections(isSingle: isSingle),
              onCancel: onFilterCancel,
              onReset: onFitlerReset,
              onConfirm: onFitlerConfirm,
              child: buildList(
                items: items.map((e) => "item_$e").toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildSearchAndFilterBar({
    required VoidCallback onToggle,
  }) {
    return Container(
      padding: EdgeInsets.only(left: 16.w, right: 8.w, top: 12.w, bottom: 12.w),
      child: Row(
        children: [
          Expanded(
            child: buildSearch(cb: (value) {
              searchText = value;
              //...
            }),
          ),
          SizedBox(
            width: 8,
          ),
          buildFilterBtn(
            onPressed: onToggle,
          ),
        ],
      ),
    );
  }

  buildSearch({String placeholder = "搜索", ValueChanged<String>? cb}) {
    return Container(
      height: 36.h,
      // width: 295.w,
      // padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.h),
      child: CupertinoSearchTextField(
        controller: searchtEditingController,
        padding: EdgeInsets.zero,
        // prefixIcon: Icon(Icons.search, color: Color(0xff999999), size: 20.h,),
        prefixIcon: Image(
          image: "icon_search.png".toAssetImage(),
          width: 14.w,
          height: 14.w,
        ),
        suffixIcon: Icon(
          Icons.clear,
          color: const Color(0xff999999),
          size: 20.h,
        ),
        prefixInsets:
            EdgeInsets.only(left: 14.w, top: 5, bottom: 5, right: 6.w),
        // padding: EdgeInsets.only(left: 3, top: 5, bottom: 5, right: 5),
        placeholder: placeholder,
        placeholderStyle: TextStyle(fontSize: 15.sp, color: fontColorBCBFC2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.w)),
            color: bgColor),
        onChanged: (String value) {
          _debounce(() {
            debugPrint('searchText: $value');
            cb?.call(value);
          });
        },
        onSubmitted: (String value) {
          _debounce(() {
            debugPrint('onSubmitted: $value');
            cb?.call(value);
          });
        },
      ),
    );
  }

  Widget buildFilterBtn({
    String title = "筛选",
    IconData? icon = Icons.fitbit,
    Color? color = Colors.blue,
    VoidCallback? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: NPair(
          icon: Icon(
            icon,
            color: color,
          ),
          child: Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          )),
    );
  }

  /// 筛选弹窗
  List<Widget> getDropBoxSections({
    bool isSingle = false,
  }) {
    final sections = [
      buildtMutiRowChoic(
        rows: mutiRowItems,
        // isSingle: isSingle,
        cbID: (e) => e.id ?? "",
        cbName: (e) => e.name ?? "",
        cbSelected: (row, e) {
          final result = row.selectedModelsTmp
              .map((e) => e.id ?? "")
              .toList()
              .contains(e.id);
          return result;
        },
        onChanged: (row) {
          debugPrint(
              "${row.title} selectedModelsTmp: ${row.selectedModelsTmp.map((e) => e.name).toList()}");
        },
        itemBuilder: (e, isSelected) {
          return buildItem(
            e: e,
            isSelected: isSelected,
            titleCb: (e) => e.name ?? "",
          );
        },
      ),
    ];

    return sections.map((e) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: e,
          ),
          if (sections.last != e)
            Container(
              height: 8,
              margin: const EdgeInsets.only(top: 15),
              color: Color(0xffF3F3F3),
            ),
          if (sections.last == e)
            SizedBox(
              height: 8,
            ),
        ],
      );
    }).toList();
  }

  /// 筛选弹窗 - 初始化
  void onFilterInit() {
    // selectedModelsTmp = selectedModels;
    // selectedTagsTmp = selectedTags;
    // selectedOrdersTmp = selectedOrders;
  }

  void onFilterCancel() {
    closeDropBox();
    // selectedModelsTmp = [];
    // selectedTagsTmp = [];
    // selectedOrdersTmp = [];
    // debugPrint("取消 selectedModels: ${selectedModels.map((e) => e.name).toList()}");
    // debugPrint("取消 selectedTagModels: ${selectedTags.map((e) => e.name).toList()}");
    // updateFitlerInfo();
  }

  /// 重置过滤参数
  onFitlerReset() {
    mutiRowItems.forEach((item) {
      item.selectedModelsTmp = [];
    });

    onFitlerConfirm();
    //请求
  }

  /// 确定过滤参数
  onFitlerConfirm() {
    closeDropBox();

    mutiRowItems.forEach((item) {
      item.selectedModels = item.selectedModelsTmp;
    });

    mutiRowItems.forEach((item) {
      debugPrint("""-------------------------------------------
title: ${item.title},
selectedModelsTmp: ${item.selectedModelsTmp.map((e) => e.name).toList()},
selectedModels: ${item.selectedModels.map((e) => e.name).toList()},""");
    });
    //请求
  }

  /// 多行标签选择
  Widget buildtMutiRowChoic<T>({
    required List<NChoiceBoxHorizontalModel<T>> rows,
    required String Function(T) cbID,
    required String Function(T) cbName,
    required bool Function(NChoiceBoxHorizontalModel<T> row, T e) cbSelected,
    required ValueChanged<NChoiceBoxHorizontalModel<T>> onChanged,
    Widget? Function(T e, bool isSelected)? itemBuilder,
    bool isExpand = false,
    int collapseCount = 2,
    double itemHeight = 30,
  }) {
    return StatefulBuilder(builder: (context, setState) {
      final rowsNew = isExpand ? rows : rows.take(collapseCount).toList();

      onToggle() {
        isExpand = !isExpand;
        setState(() {});
      }

      return Column(
        children: [
          ...rowsNew.map((row) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Text(
                    "${row.title}: ",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Container(
                      height: itemHeight,
                      width: double.maxFinite,
                      child: NChoiceBoxHorizontal<T>(
                        isSingle: row.isSingle,
                        onChanged: (value) {
                          row.selectedModelsTmp =
                              value.map((e) => e.data).toList();
                          onChanged(row);
                        },
                        items: row.models
                            .map((e) => ChoiceBoxModel<T>(
                                  id: cbID(e),
                                  title: cbName(e),
                                  isSelected: cbSelected(row, e),
                                  data: e,
                                ))
                            .toList(),
                        itemBuilder: itemBuilder,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 1),
            child: GestureDetector(
              onTap: onToggle,
              child:
                  Icon(isExpand ? Icons.arrow_drop_up : Icons.arrow_drop_down),
            ),
          ),
        ],
      );
    });
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
      alignment: Alignment.center,
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

  buildList({required List<String> items}) {
    return Material(
      // color: Colors.transparent,
      child: ListView.separated(
        padding: EdgeInsets.all(0),
        itemCount: items.length,
        cacheExtent: 10,
        itemBuilder: (context, index) {
          final e = items[index];
          return ListTile(
            title: Text(e),
            onTap: () {
              debugPrint(e);
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: .5,
            indent: 15,
            endIndent: 15,
            color: Color(0xFFe4e4e4),
          );
        },
      ).toCupertinoScrollbar(),
    );
  }

  closeDropBox() {
    dropBoxController.onToggle();
  }

  closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
