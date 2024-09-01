//
//  ChoiceFilterBox.dart
//  projects
//
//  Created by shang on 2024/8/31 11:43.
//  Copyright © 2024/8/31 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_choice_expansion_of_model.dart';
import 'package:flutter_templet_project/basicWidget/n_date_start_end.dart';
import 'package:flutter_templet_project/basicWidget/n_filter_drop_box.dart';
import 'package:flutter_templet_project/basicWidget/n_filter_section.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/model/fake_data_model.dart';
import 'package:flutter_templet_project/model/section_detail_model.dart';
import 'package:flutter_templet_project/model/status_detail_model.dart';
import 'package:flutter_templet_project/model/tag_detail_model.dart';
import 'package:flutter_templet_project/util/color_util.dart';

/// 患者筛选弹窗(分组+状态+时段)
class ChoiceFilterBox extends StatefulWidget {
  ChoiceFilterBox({
    super.key,
    this.controller,
    this.selectedModels = const [],
    this.selectedTags = const [],
    this.startTime,
    this.endTime,
    required this.isChanged,
    this.onInit,
    required this.onCancel,
    required this.onReset,
    required this.onConfirm,
    this.hideSection = false,
    this.hideStatus = false,
    this.hideDateRange = false,
    this.contentAlignment = Alignment.topCenter,
    this.onInitState,
    required this.child,
  });

  /// 控制器
  final ChoiceFilterBoxController? controller;

  List<FakeDataModel> selectedModels;

  List<TagDetailModel> selectedTags;

  /// 默认选择的时间起始
  String? startTime;

  /// 默认选择的时间截止
  String? endTime;

  /// 是否有改变
  final ValueNotifier<bool> isChanged;

  /// 筛选弹窗 - 初始化
  final VoidCallback? onInit;

  /// 筛选弹窗 - 取消
  final VoidCallback onCancel;

  /// 筛选弹窗 - 重置
  final VoidCallback onReset;

  /// 筛选弹窗 - 确定
  final ValueChanged<Map<String, dynamic>> onConfirm;

  /// 隐藏分组
  final bool hideSection;

  /// 隐藏状态
  final bool hideStatus;

  /// 隐藏时间起止
  final bool hideDateRange;

  /// 内容对齐方式
  final Alignment contentAlignment;

  /// initState
  final VoidCallback? onInitState;

  /// 一般是列表组件
  final Widget child;

  @override
  State<ChoiceFilterBox> createState() => _ChoiceFilterBoxState();
}

class _ChoiceFilterBoxState extends State<ChoiceFilterBox>
    with SingleTickerProviderStateMixin {
  //筛选按钮是否高亮
  late final isHighlight = widget.isChanged;

  final filterController = NFilterDropBoxController();

  /// 选项组
  List<FakeDataModel> get models => List.generate(
      20,
      (e) => FakeDataModel(
            id: "id_$e",
            name: "选项_$e",
          ));

  /// 标签组
  List<TagDetailModel> get tagModels => List.generate(
      20,
      (e) => TagDetailModel(
            id: "id_$e",
            name: "标签_$e",
          ));

  List<FakeDataModel> selectedModels = [];
  List<FakeDataModel> selectedModelsTmp = [];

  List<TagDetailModel> selectedTags = [];
  List<TagDetailModel> selectedTagsTmp = [];

  /// 入组时间 - 开始
  String? startTime;
  String? startTimeTmp;

  /// 入组时间 - 结束
  String? endTime;
  String? endTimeTmp;

  @override
  void dispose() {
    widget.controller?._detach(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(this);
    initData();
  }

  Future<void> initData() async {
    widget.onInitState?.call();
  }

  @override
  void didUpdateWidget(covariant ChoiceFilterBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    final isChange = widget.selectedModels != oldWidget.selectedModels ||
        widget.selectedTags != oldWidget.selectedTags ||
        widget.startTime != oldWidget.startTime ||
        widget.endTime != oldWidget.endTime ||
        widget.hideSection != oldWidget.hideSection ||
        widget.hideStatus != oldWidget.hideStatus ||
        widget.hideDateRange != oldWidget.hideDateRange;
    if (!isChange) {
      return;
    }
    selectedModels = selectedModelsTmp = widget.selectedModels;
    selectedTags = selectedTagsTmp = widget.selectedTags;
    startTime = startTimeTmp = widget.startTime;
    endTime = endTimeTmp = widget.endTime;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final sections = getDropBoxSections();

    return NFilterDropBox(
      controller: filterController,
      sections: sections,
      barrierColor: bgColor000000.withOpacity(0.52),
      onCancel: onFilterCancel,
      onReset: onFilterReset,
      onConfirm: onFilterConfirm,
      contentAlignment: widget.contentAlignment,
      child: widget.child,
    );
  }

  /// 筛选弹窗
  /// 筛选弹窗
  List<Widget> getDropBoxSections({
    bool isSingle = false,
  }) {
    final sections = [
      NChoiceExpansionOfModel(
        title: '标签',
        items: models,
        isSingle: isSingle,
        idCb: (e) => e.id ?? "",
        titleCb: (e) => e.name ?? "",
        selectedCb: (e) => selectedModels.map((e) => e.id).contains(e.id),
        onChanged: (list) {
          ddlog(
              "NChoiceExpansionOfModel: ${list.map((e) => "${e.name}_${e.isSelected}")}");
          selectedModelsTmp = list;
        },
      ),
      NChoiceExpansionOfModel(
        title: '标签',
        items: tagModels,
        // selectedItems: selectedTagModelsTmp,
        isSingle: isSingle,
        idCb: (e) => e.id ?? "",
        titleCb: (e) => e.name ?? "",
        selectedCb: (e) => selectedTags.map((e) => e.id).contains(e.id),
        onChanged: (list) {
          // ddlog(list.map((e) => "${e.name}_${e.isSelected}"));
          selectedTagsTmp = list;
          debugPrint(
              "重置 selectedTagModelsTmp: ${selectedTagsTmp.map((e) => e.name).toList()}");
          // setState((){});
        },
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              "入组时间",
              style: TextStyle(
                color: fontColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          NDateStartEnd(
            startDate: () => startTimeTmp,
            endDate: () => endTimeTmp,
            onStart: (dateStr) {
              ddlog("onStart: $dateStr");
              startTimeTmp = dateStr;
            },
            onEnd: (dateStr) {
              ddlog("onEnd: $dateStr");
              endTimeTmp = dateStr;
            },
          ),
        ],
      )
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
          if (sections.last == e) SizedBox(height: 8),
        ],
      );
    }).toList();
  }

  /// 筛选项 - 子元素样式自定义
  Widget buildItem<T>({
    required T e,
    required bool isSelected,
    required String Function(T e) titleCb,
  }) {
    Color primaryColor = context.primaryColor;

    final textColor = isSelected ? primaryColor : const Color(0xff737373);
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
        border: Border.all(color: borderColor, width: 0.5),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: NText(
        title,
        fontSize: 14,
        color: textColor,
      ),
    );
  }

  Widget buildDvider() {
    return Container(
      height: 8,
      margin: const EdgeInsets.only(top: 15),
      color: const Color(0xffF3F3F3),
    );
  }

  /// 筛选弹窗 - 初始化
  void onFilterInit() {
    selectedModelsTmp = selectedModels;
    selectedTagsTmp = selectedTags;

    startTimeTmp = startTime;
    endTimeTmp = endTime;
    updateHighlight();

    widget.onInit?.call();
  }

  /// 筛选弹窗 - 取消
  void onFilterCancel() {
    closeDropBox();
    selectedModelsTmp = [];
    selectedTagsTmp = [];
    if (startTime == null) {
      startTimeTmp = null;
    }
    if (endTime == null) {
      endTimeTmp = null;
    }

    updateHighlight();
    widget.onCancel();
  }

  /// 筛选弹窗 - 重置过滤参数
  void onFilterReset() {
    closeDropBox();
    selectedModels = selectedModelsTmp = [];
    selectedTags = selectedTagsTmp = [];
    startTime = startTimeTmp = null;
    endTime = endTimeTmp = null;

    isHighlight.value = false;

    widget.onReset();
  }

  /// 筛选弹窗 - 确定过滤参数
  void onFilterConfirm() {
    closeDropBox();
    selectedModels = selectedModelsTmp;
    selectedTags = selectedTagsTmp;
    startTime = startTimeTmp;
    endTime = endTimeTmp;
    updateHighlight();

    final val = <String, dynamic>{
      "selectedModels": selectedModels,
      "selectedTags": selectedTags,
      "startTime": startTime,
      "endTime": endTime,
    };
    widget.onConfirm(val);
  }

  //选择的时候动态改变筛选按钮高亮状态
  void updateHighlight() {
    isHighlight.value = [
      selectedModels,
      selectedTags,
      startTime,
      endTime,
      selectedModelsTmp,
      selectedTagsTmp,
      startTimeTmp,
      endTimeTmp,
    ].where((e) => e != null).isNotEmpty;
  }

  closeDropBox() {
    if (filterController.isVisible) {
      filterController.onToggle();
    }
  }

  closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

class ChoiceFilterBoxController {
  _ChoiceFilterBoxState? _anchor;
  _ChoiceFilterBoxState? get anchor => _anchor;

  void _attach(_ChoiceFilterBoxState anchor) {
    _anchor = anchor;
  }

  void _detach(_ChoiceFilterBoxState anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }
}
