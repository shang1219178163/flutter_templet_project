//
//  PatientFilterBox.dart
//  projects
//
//  Created by shang on 2024/8/31 11:43.
//  Copyright © 2024/8/31 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_date_start_end.dart';
import 'package:flutter_templet_project/basicWidget/n_filter_drop_box.dart';
import 'package:flutter_templet_project/basicWidget/n_filter_section.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/model/section_detail_model.dart';
import 'package:flutter_templet_project/model/status_detail_model.dart';
import 'package:flutter_templet_project/util/color_util.dart';

/// 患者筛选弹窗(分组+状态+时段)
class PatientFilterBox extends StatefulWidget {
  const PatientFilterBox({
    super.key,
    this.controller,
    this.selectedSectionModel,
    this.selectedStatusModel,
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
  final PatientFilterBoxController? controller;

  /// 默认选择的分组
  final SectionDetailModel? selectedSectionModel;

  /// 默认选择的状态
  final StatusDetailModel? selectedStatusModel;

  /// 默认选择的时间起始
  final String? startTime;

  /// 默认选择的时间截止
  final String? endTime;

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
  State<PatientFilterBox> createState() => _PatientFilterBoxState();
}

class _PatientFilterBoxState extends State<PatientFilterBox>
    with SingleTickerProviderStateMixin {
  //筛选按钮是否高亮
  late final isHighlight = widget.isChanged;

  final filterController = NFilterDropBoxController();

  /// 疾病组
  final sectionModels = CacheService().getModels(
    key: CACHE_PATIENT_SECTION_MODEL,
    modelCb: (json) => SectionDetailModel.fromJson(json),
  );

  /// 选中组数据
  SectionDetailModel? selectedSectionModel;

  /// 临时选中组数据
  SectionDetailModel? selectedSectionModelTmp;

  /// 标签组
  final statusModels = CacheService().getModels(
    key: CACHE_PATIENR_STATUS_MODEL,
    modelCb: (json) => StatusDetailModel.fromJson(json),
  );

  /// 选中状态签数据
  StatusDetailModel? selectedStatusModel;

  /// 临时选中状态数据
  StatusDetailModel? selectedStatusModelTmp;

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
  void didUpdateWidget(covariant PatientFilterBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    final isChange =
        widget.selectedSectionModel != oldWidget.selectedSectionModel ||
            widget.selectedStatusModel != oldWidget.selectedStatusModel ||
            widget.startTime != oldWidget.startTime ||
            widget.endTime != oldWidget.endTime ||
            widget.hideSection != oldWidget.hideSection ||
            widget.hideStatus != oldWidget.hideStatus ||
            widget.hideDateRange != oldWidget.hideDateRange;
    if (!isChange) {
      return;
    }
    selectedSectionModel =
        selectedSectionModelTmp = widget.selectedSectionModel;
    selectedStatusModel = selectedStatusModelTmp = widget.selectedStatusModel;
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
  List<Widget> getDropBoxSections({
    bool hasShadow = false,
  }) {
    return [
      if (!widget.hideSection && sectionModels.isNotEmpty)
        Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: NFilterSection(
                title: "分组",
                items: sectionModels.where((e) => !e.isLockStatus).toList(),
                cbID: (e) => e.id ?? "",
                cbName: (e) => e.name ?? "",
                cbSelected: (e) => e.id == selectedSectionModelTmp?.id,
                onSingleChanged: (val) {
                  selectedSectionModelTmp = val;
                  updateHighlight();
                },
                itemBuilder: (e, isSelected) {
                  return buildItem(
                    e: e,
                    isSelected: isSelected,
                    titleCb: (e) => e.name ?? "",
                  );
                },
              ),
            ),
            if (sectionModels.isNotEmpty) buildDvider(),
          ],
        ),
      if (!widget.hideStatus && statusModels.isNotEmpty)
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: NFilterSection(
                title: "状态",
                items: statusModels,
                cbID: (e) => e.id ?? "",
                cbName: (e) => e.name ?? "",
                cbSelected: (e) => e.id == selectedStatusModelTmp?.id,
                onSingleChanged: (val) {
                  selectedStatusModelTmp = val;
                  updateHighlight();
                },
                itemBuilder: (e, isSelected) {
                  return buildItem(
                    e: e,
                    isSelected: isSelected,
                    titleCb: (e) => e.name ?? "",
                  );
                },
              ),
            ),
            if (!widget.hideDateRange) buildDvider(),
          ],
        ),
      if (!widget.hideDateRange)
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
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
                      DLog.d("onStart: $dateStr");
                      startTimeTmp = dateStr;
                    },
                    onEnd: (dateStr) {
                      DLog.d("onEnd: $dateStr");
                      endTimeTmp = dateStr;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
    ];
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
    selectedSectionModelTmp = selectedSectionModel;
    selectedStatusModelTmp = selectedStatusModel;

    startTimeTmp = startTime;
    endTimeTmp = endTime;
    updateHighlight();

    widget.onInit?.call();
  }

  /// 筛选弹窗 - 取消
  void onFilterCancel() {
    selectedSectionModelTmp = null;
    selectedStatusModelTmp = null;

    if (startTime == null) {
      startTimeTmp = null;
    }
    if (endTime == null) {
      endTimeTmp = null;
    }
    updateHighlight();
    closeDropBox();

    widget.onCancel();
  }

  /// 筛选弹窗 - 重置过滤参数
  void onFilterReset() {
    selectedSectionModel = selectedSectionModelTmp = null;
    selectedStatusModel = selectedStatusModelTmp = null;
    startTime = startTimeTmp = null;
    endTime = endTimeTmp = null;

    isHighlight.value = false;

    closeDropBox();
    widget.onReset();
  }

  /// 筛选弹窗 - 确定过滤参数
  void onFilterConfirm() {
    selectedSectionModel = selectedSectionModelTmp;
    selectedStatusModel = selectedStatusModelTmp;
    startTime = startTimeTmp;
    endTime = endTimeTmp;
    updateHighlight();

    closeDropBox();
    final val = <String, dynamic>{
      "selectedSectionModel": selectedSectionModel,
      "selectedStatusModel": selectedStatusModel,
      "startTime": startTime,
      "endTime": endTime,
    };
    widget.onConfirm(val);
  }

  //选择的时候动态改变筛选按钮高亮状态
  void updateHighlight() {
    isHighlight.value = [
      selectedSectionModel,
      selectedStatusModel,
      startTime,
      endTime,
      selectedSectionModelTmp,
      selectedStatusModelTmp,
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

class PatientFilterBoxController {
  _PatientFilterBoxState? _anchor;
  _PatientFilterBoxState? get anchor => _anchor;

  void _attach(_PatientFilterBoxState anchor) {
    _anchor = anchor;
  }

  void _detach(_PatientFilterBoxState anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }
}
