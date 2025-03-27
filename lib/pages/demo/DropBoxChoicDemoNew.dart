import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_choice_filter_box.dart';
import 'package:flutter_templet_project/basicWidget/n_filter_button.dart';
import 'package:flutter_templet_project/basicWidget/n_filter_drop_box.dart';
import 'package:flutter_templet_project/basicWidget/n_refresh_view.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/n_textfield_search.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';
import 'package:flutter_templet_project/model/fake_data_model.dart';
import 'package:flutter_templet_project/model/tag_detail_model.dart';
import 'package:flutter_templet_project/model/user_model.dart';
import 'package:flutter_templet_project/util/Debounce.dart';
import 'package:flutter_templet_project/util/color_util.dart';

/// 筛选框重构
class DropBoxChoicDemoNew extends StatefulWidget {
  DropBoxChoicDemoNew({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _DropBoxChoicDemoNewState createState() => _DropBoxChoicDemoNewState();
}

class _DropBoxChoicDemoNewState extends State<DropBoxChoicDemoNew> {
  final refreshViewController = NRefreshViewController<UserModel>();

  final items = List.generate(9, (i) => i).toList();

  var searchText = "";
  late final searchtEditingController = TextEditingController();

  final _debounce = Debounce(delay: Duration(milliseconds: 500));

  ///显示筛选按钮
  final hasFilter = ValueNotifier(false);

  final isHighlight = ValueNotifier(false);

  final patientFilterController = ChoiceFilterBoxController();

  NFilterDropBoxController? get filterController =>
      patientFilterController.anchor?.filterController;

  final filterModel = NChoiceFilterBoxModel(
    choices: [
      NChoiceFilterBoxItemModel(
        title: "选项",
        models: List.generate(20, (i) => i)
            .map((e) => FakeDataModel(
                  id: "id_$e",
                  name: "选项_$e",
                ))
            .toList(),
        selectedModels: [],
        selectedModelsTmp: [],
        // isSingle: true,
      ),
      NChoiceFilterBoxItemModel(
        title: "标签",
        models: List.generate(20, (i) => i)
            .map((e) => TagDetailModel(
                  id: "id_$e",
                  name: "标签_$e",
                ))
            .toList(),
        selectedModels: [],
        selectedModelsTmp: [],
      ),
    ],

    /// 入组时间 - 开始
    startTime: null,
    startTimeTmp: null,

    /// 入组时间 - 结束
    endTime: null,
    endTimeTmp: null,
  );

  final filterDesc = ValueNotifier("");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildSearchBar(),
          Expanded(
            child: NChoiceFilterBox(
              controller: patientFilterController,
              model: filterModel,
              isChanged: isHighlight,
              // hideSection: true,
              // hideStatus: true,
              // hideDateRange: true,
              onClose: () {
                isHighlight.value = filterModel.isNotEmpty;
                DLog.d("isHighlight.value1: ${isHighlight.value}");
              },
              onCancel: (result) {
                // DLog.d(result);
                filterDesc.value = result.toString();
              },
              onReset: (result) {
                // DLog.d(result);
                filterDesc.value = result.toString();
                refreshViewController.onRefresh();
              },
              onConfirm: (result) {
                // DLog.d(result);
                filterDesc.value = result.toString();
                refreshViewController.onRefresh();
              },
              // filterHeader: Container(
              //   height: 35,
              //   color: Colors.green,
              // ),
              // filterFooter: Container(
              //   height: 35,
              //   color: Colors.yellow,
              // ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildFilterDesc(),
                  Expanded(
                    child: buildListView(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      padding: EdgeInsets.only(left: 16.w, right: 8.w, top: 12.w, bottom: 12.w),
      child: Row(
        children: [
          Expanded(
            child: NSearchTextField(
              placeholder: "搜索",
              backgroundColor: white,
              onChanged: (String value) {},
            ),
          ),
          SizedBox(width: 8),
          ValueListenableBuilder<bool>(
            valueListenable: isHighlight,
            builder: (context, value, child) {
              return NFilterButton(
                color: value == true ? context.primaryColor : fontColor,
                onPressed: () {
                  patientFilterController.anchor?.onFilterInit();
                  filterController?.onToggle();
                  patientFilterController.anchor?.closeKeyboard();
                  if (filterController!.isVisible) {
                    refreshFilter();
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildFilterDesc() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        filterDesc,
      ]),
      builder: (context, child) {
        if (filterDesc.value.isEmpty) {
          return SizedBox();
        }
        return Container(
          constraints: BoxConstraints(
            maxHeight: 400,
          ),
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NText(filterDesc.value),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildListView() {
    return NRefreshView<UserModel>(
      controller: refreshViewController,
      // tag: "${tabIndex.value}",
      onRequest: (bool isRefresh, int page, int pageSize, last) async {
        return requestList(
          pageNo: page,
          pageSize: pageSize,
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(
          height: 0.5,
          color: lineColor,
          indent: 16,
        );
      },
      itemBuilder: (BuildContext context, int index, e) {
        return InkWell(
          onTap: () {
            DLog.d("${e.toJson()}");
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
            child: ListTile(
              title: NText(e.name ?? ""),
            ),
          ),
        );
      },
    );
  }

  /// 列表数据请求
  Future<List<UserModel>> requestList({
    required int pageNo,
    int pageSize = 30,
  }) async {
    final models = List.generate(
        20,
        (index) => UserModel(
              name: "用户${4.generateChars()}",
              id: 4.generateChars(),
            ));
    return models;
  }

  /// 刷新筛选项
  refreshFilter() async {
    hasFilter.value = filterModel.choices.where((e) => e.isNotEmpty).isNotEmpty;
    debugPrint("hasFilter:${hasFilter.value}");
  }
}
