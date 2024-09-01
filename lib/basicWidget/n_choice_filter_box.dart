//
//  ChoiceFilterBox.dart
//  projects
//
//  Created by shang on 2024/8/31 11:43.
//  Copyright © 2024/8/31 shang. All rights reserved.
//

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_choice_expansion_of_model.dart';
import 'package:flutter_templet_project/basicWidget/n_date_start_end.dart';
import 'package:flutter_templet_project/basicWidget/n_filter_drop_box.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/mixin/selectable_mixin.dart';
import 'package:flutter_templet_project/util/color_util.dart';

class NChoiceFilterBoxItemModel<T extends SelectableMixin> {
  NChoiceFilterBoxItemModel({
    required this.title,
    required this.models,
    required this.selectedModels,
    required this.selectedModelsTmp,
    this.hide = false,
    this.isSingle = false,
  });

  final String title;

  /// 选项组
  final List<T> models;

  final List<T> selectedModels;
  final List<T> selectedModelsTmp;

  /// 隐藏分组
  final bool hide;

  /// 是否单选
  final bool isSingle;

  bool get isNotEmpty => [
        selectedModels,
        selectedModelsTmp,
      ].isNotEmpty;

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['title'] = title;
    data['models'] = models.map((e) => e.toJson()).toList();
    data['selectedModels'] = selectedModels.map((e) => e.toJson()).toList();
    data['selectedModelsTmp'] =
        selectedModelsTmp.map((e) => e.toJson()).toList();
    data['hide'] = hide;
    data['isSingle'] = isSingle;
    return data;
  }

  @override
  String toString() {
    final result = toJson();
    result.removeWhere(
        (key, value) => !["selectedModels", "selectedModelsTmp"].contains(key));
    var encoder = JsonEncoder.withIndent('  '); // 使用带缩进的 JSON 编码器
    return encoder.convert(result);
  }
}

class NChoiceFilterBoxModel {
  NChoiceFilterBoxModel({
    required this.choices,
    this.startTime,
    this.startTimeTmp,
    this.endTime,
    this.endTimeTmp,
    this.hideDateRange = false,
  });

  /// 选项组
  final List<NChoiceFilterBoxItemModel> choices;

  /// 入组时间 - 开始
  String? startTime;
  String? startTimeTmp;

  /// 入组时间 - 结束
  String? endTime;
  String? endTimeTmp;

  /// 隐藏时间起止
  final bool hideDateRange;

  bool get isNotEmpty =>
      [
        startTime,
        endTime,
        startTimeTmp,
        endTimeTmp,
      ].where((e) => e != null).isNotEmpty &&
      choices.map((e) => e.isNotEmpty).contains(true);

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['choices'] = choices.map((e) => e.toString()).toList();
    data['startTime'] = startTime;
    data['startTimeTmp'] = startTimeTmp;
    data['endTime'] = endTime;
    data['endTimeTmp'] = endTimeTmp;
    return data;
  }

  @override
  String toString() {
    final result = toJson();
    final encoder = JsonEncoder.withIndent('  '); // 使用带缩进的 JSON 编码器
    return encoder.convert(result);
  }
}

/// 患者筛选弹窗(分组+状态+时段)
class NChoiceFilterBox extends StatefulWidget {
  NChoiceFilterBox({
    super.key,
    this.controller,
    required this.model,
    required this.isChanged,
    this.onInit,
    required this.onCancel,
    required this.onReset,
    required this.onConfirm,
    this.contentAlignment = Alignment.topCenter,
    this.onInitState,
    required this.child,
  });

  /// 控制器
  final ChoiceFilterBoxController? controller;

  final NChoiceFilterBoxModel model;

  /// 是否有改变
  final ValueNotifier<bool> isChanged;

  /// 筛选弹窗 - 初始化
  final VoidCallback? onInit;

  /// 筛选弹窗 - 取消
  final ValueChanged<NChoiceFilterBoxModel> onCancel;

  /// 筛选弹窗 - 重置
  final ValueChanged<NChoiceFilterBoxModel> onReset;

  /// 筛选弹窗 - 确定
  final ValueChanged<NChoiceFilterBoxModel> onConfirm;

  /// 内容对齐方式
  final Alignment contentAlignment;

  /// initState
  final VoidCallback? onInitState;

  /// 一般是列表组件
  final Widget child;

  @override
  State<NChoiceFilterBox> createState() => _NChoiceFilterBoxState();
}

class _NChoiceFilterBoxState extends State<NChoiceFilterBox>
    with SingleTickerProviderStateMixin {
  //筛选按钮是否高亮
  late final isHighlight = widget.isChanged;

  final filterController = NFilterDropBoxController();

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
  void didUpdateWidget(covariant NChoiceFilterBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    final isChange = widget.model != oldWidget.model;
    if (!isChange) {
      return;
    }
    // selectedModels = selectedModelsTmp = widget.model.selectedModels;
    // selectedTags = selectedTagsTmp = widget.selectedTags;
    // startTime = startTimeTmp = widget.startTime;
    // endTime = endTimeTmp = widget.endTime;
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
  List<Widget> getDropBoxSections() {
    final sections = [
      ...widget.model.choices.map((choice) {
        final i = widget.model.choices.indexOf(choice);

        return NChoiceExpansionOfModel<SelectableMixin>(
          title: choice.title,
          items: choice.models,
          isSingle: choice.isSingle,
          idCb: (e) => e.selectableId ?? "",
          titleCb: (e) => e.selectableName ?? "",
          selectedCb: (e) => choice.selectedModels
              .map((e) => e.selectableId)
              .contains(e.selectableId),
          onChanged: (list) {
            ddlog(
                "$widget ${choice.title}: ${list.map((e) => "${e.selectableName}_${e.isSelected}")}");
            widget.model.choices[i].selectedModelsTmp.clear();
            widget.model.choices[i].selectedModelsTmp.addAll(list);
          },
        );
      }),
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
            startDate: () => widget.model.startTimeTmp,
            endDate: () => widget.model.endTimeTmp,
            onStart: (dateStr) {
              ddlog("onStart: $dateStr");
              widget.model.startTimeTmp = dateStr;
            },
            onEnd: (dateStr) {
              ddlog("onEnd: $dateStr");
              widget.model.endTimeTmp = dateStr;
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

  /// 筛选弹窗 - 初始化
  void onFilterInit() {
    for (var i = 0; i < widget.model.choices.length; i++) {
      final choice = widget.model.choices[i];
      widget.model.choices[i].selectedModelsTmp.clear();
      widget.model.choices[i].selectedModelsTmp.addAll(choice.selectedModels);
    }

    widget.model.startTimeTmp = widget.model.startTime;
    widget.model.endTimeTmp = widget.model.endTime;
    updateHighlight();

    widget.onInit?.call();
  }

  /// 筛选弹窗 - 取消
  void onFilterCancel() {
    closeDropBox();
    for (var i = 0; i < widget.model.choices.length; i++) {
      widget.model.choices[i].selectedModelsTmp.clear();
    }

    if (widget.model.startTime == null) {
      widget.model.startTimeTmp = null;
    }
    if (widget.model.endTime == null) {
      widget.model.endTimeTmp = null;
    }

    updateHighlight();
    widget.onCancel(widget.model);
  }

  /// 筛选弹窗 - 重置过滤参数
  void onFilterReset() {
    closeDropBox();
    for (var i = 0; i < widget.model.choices.length; i++) {
      widget.model.choices[i].selectedModelsTmp.clear();
      widget.model.choices[i].selectedModels.clear();
    }

    widget.model.startTimeTmp = widget.model.startTime = null;
    widget.model.endTimeTmp = widget.model.endTime = null;
    isHighlight.value = false;

    widget.onReset(widget.model);
  }

  /// 筛选弹窗 - 确定过滤参数
  void onFilterConfirm() {
    closeDropBox();
    for (final choice in widget.model.choices) {
      choice.selectedModels.clear();
      choice.selectedModels.addAll(choice.selectedModelsTmp);
    }

    widget.model.startTime = widget.model.startTimeTmp;
    widget.model.endTime = widget.model.endTimeTmp;
    updateHighlight();

    widget.onConfirm(widget.model);
  }

  //选择的时候动态改变筛选按钮高亮状态
  void updateHighlight() {
    isHighlight.value = widget.model.isNotEmpty;
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
  _NChoiceFilterBoxState? _anchor;
  _NChoiceFilterBoxState? get anchor => _anchor;

  void _attach(_NChoiceFilterBoxState anchor) {
    _anchor = anchor;
  }

  void _detach(_NChoiceFilterBoxState anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }
}
