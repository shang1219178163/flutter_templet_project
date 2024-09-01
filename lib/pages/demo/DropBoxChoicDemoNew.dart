import 'package:enhance_expansion_panel/enhance_expansion_panel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/choice_filter_box.dart';
import 'package:flutter_templet_project/basicWidget/n_cancel_and_confirm_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_choice_box.dart';
import 'package:flutter_templet_project/basicWidget/n_choice_expansion_of_model.dart';
import 'package:flutter_templet_project/basicWidget/n_date_start_end.dart';
import 'package:flutter_templet_project/basicWidget/n_filter_button.dart';
import 'package:flutter_templet_project/basicWidget/n_filter_drop_box.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/basicWidget/n_refresh_view.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/n_textfield_search.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/list_ext.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/model/order_model.dart';
import 'package:flutter_templet_project/model/tag_detail_model.dart';
import 'package:flutter_templet_project/model/user_model.dart';
import 'package:flutter_templet_project/util/Debounce.dart';
import 'package:flutter_templet_project/util/color_util.dart';
import 'package:flutter_templet_project/model/fake_data_model.dart';
import 'package:flutter_templet_project/vendor/flutter_pickers/flutter_picker_util.dart';
import 'package:get_storage/get_storage.dart';

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

  /// 选项组
  List<FakeDataModel> get models => items
      .map((e) => FakeDataModel(
            id: "id_$e",
            name: "选项_$e",
          ))
      .toList();
  List<FakeDataModel> selectedModels = [];
  List<FakeDataModel> selectedModelsTmp = [];

  /// 标签组
  List<TagDetailModel> get tagModels => items
      .map((e) => TagDetailModel(
            id: "id_$e",
            name: "标签_$e",
          ))
      .toList();
  List<TagDetailModel> selectedTags = [];
  List<TagDetailModel> selectedTagsTmp = [];

  /// 标签组
  List<OrderModel> get orders => items
      .map((e) => OrderModel(
            id: e,
            name: "订单_$e",
            pirce: IntExt.random(max: 1000, min: 100).toDouble(),
          ))
      .toList();
  List<OrderModel> selectedOrders = [];
  List<OrderModel> selectedOrdersTmp = [];

  /// 入组时间 - 开始
  String? startTime;
  String? startTimeTmp;

  /// 入组时间 - 结束
  String? endTime;
  String? endTimeTmp;

  final sectionDesc = ValueNotifier("");
  final tagDesc = ValueNotifier("");

  @override
  Widget build(BuildContext context) {
    bool isSingle = false; //单选多选

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildSearchBar(
            filterButton: ValueListenableBuilder<bool>(
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
          ),
          Expanded(
            child: ChoiceFilterBox(
              controller: patientFilterController,
              selectedModels: selectedModels,
              selectedTags: selectedTags,
              startTime: startTime,
              endTime: endTime,
              isChanged: isHighlight,
              // hideSection: true,
              // hideStatus: true,
              // hideDateRange: true,
              onCancel: () {},
              onReset: () {
                selectedModels = [];
                selectedTags = [];
                startTime = null;
                endTime = null;
                refreshViewController.onRefresh();
              },
              onConfirm: (map) {
                // DLog.d(map);
                selectedModels = map["selectedModels"] ?? [];
                selectedTags = map["selectedTags"] ?? [];
                startTime = map["startTime"];
                endTime = map["endTime"];
                refreshViewController.onRefresh();

                sectionDesc.value = selectedModels.map((e) => e.name).join(",");
                tagDesc.value = selectedTags.map((e) => e.name).join(",");
              },
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

  Widget buildSearchBar({
    required Widget filterButton,
  }) {
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
          filterButton,
        ],
      ),
    );
  }

  Widget buildFilterDesc() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        sectionDesc,
        tagDesc,
      ]),
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.green,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (sectionDesc.value.isNotEmpty) NText(sectionDesc.value),
              if (tagDesc.value.isNotEmpty) NText(tagDesc.value),
            ],
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
        return const Divider(height: 0.5, color: lineColor);
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
    String searchText = "";
    final models = List.generate(
        20,
        (index) => UserModel(
              name: "用户${4.generateChars()}",
              id: 4.generateChars(),
              tag: tagModels.randomOne?.name,
            ));
    return models;
  }

  void updateFitlerInfo() {
    tagDesc.value = selectedTags.map((e) => e.name).toList().join(", ");
    sectionDesc.value = selectedModels.map((e) => e.name).toList().join(", ");
  }

  /// 刷新筛选项
  refreshFilter() async {
    final fitterModels = [selectedModels, selectedTags];
    hasFilter.value = fitterModels.where((e) => e.isNotEmpty).isNotEmpty;
    debugPrint("hasFilter:${hasFilter.value}");
  }
}
