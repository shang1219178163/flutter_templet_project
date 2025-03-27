//
//  DrugDosageCalPage.dart
//  projects
//
//  Created by shang on 2024/12/12 11:29.
//  Copyright © 2024/12/12 shang. All rights reserved.
//

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/n_cupertino_picker_list_view.dart';
import 'package:flutter_templet_project/basicWidget/n_footer_button_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/n_textfield_unit.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/mixin/safe_set_state_mixin.dart';
import 'package:flutter_templet_project/pages/medication_calculator.dart';
import 'package:flutter_templet_project/util/color_util.dart';
import 'package:flutter_templet_project/util/get_util.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';
import 'package:get/get.dart';

/// 药品计量推荐
class DrugDosageCalPage extends StatefulWidget {
  const DrugDosageCalPage({
    super.key,
    required this.height,
    required this.weight,
    // required this.drugName,
    // required this.drugId,
    required this.drugFormulas,
    required this.drugFormulaSelected,
    required this.drugPlanSelected,
    required this.drugUseWaySelected,
    // this.dosage,
    this.onCancel,
    required this.onConfirm,
    this.onPatient,
  });

  /// 患者身高
  final String? height;

  /// 患者体重
  final String? weight;

  // /// 药品名称
  // final String? drugName;
  //
  // /// 药品id
  // final String? drugId;
  //
  // /// 推荐剂量
  // final double? dosage;

  /// 药品公式
  final List<ChemotherapyRegimenTreatmentStrategyEnum> drugFormulas;

  /// 药品选择公式
  final ChemotherapyRegimenTreatmentStrategyEnum? drugFormulaSelected;

  /// 药品方案选择默认
  final ChemotherapyRegimenTreatmentStrategyEnum? drugPlanSelected;

  /// 药品用药方式默认
  final DrugUseWayEnum? drugUseWaySelected;

  /// 取消
  final VoidCallback? onCancel;

  /// 确定
  final ValueChanged<ChemotherapyRegimenTreatmentStrategyEnum?> onConfirm;

  /// 患者身高体重回调
  final void Function(Map<String, dynamic> value)? onPatient;

  @override
  State<DrugDosageCalPage> createState() => _DrugDosageCalPageState();
}

class _DrugDosageCalPageState extends State<DrugDosageCalPage> with SafeSetStateMixin {
  // final drugDetailsController = Get.put(DrugDetailsController());

  late String? height = widget.height != "null" ? widget.height : null;
  late String? weight = widget.weight != "null" ? widget.weight : null;

  late List<ChemotherapyRegimenTreatmentStrategyEnum> drugFormulas = widget.drugFormulas;

  final drugFormulaSelectedVN = ValueNotifier<ChemotherapyRegimenTreatmentStrategyEnum?>(null);

  List<ChemotherapyRegimenTreatmentStrategyEnum> drugPlans = ChemotherapyRegimenTreatmentStrategyEnum.values;
  //
  late ChemotherapyRegimenTreatmentStrategyEnum? drugPlanSelected = widget.drugPlanSelected;

  List<DrugUseWayEnum> drugUseWays = DrugUseWayEnum.values;

  late DrugUseWayEnum? drugUseWaySelected = widget.drugUseWaySelected;

  final dosageVN = ValueNotifier<double?>(null);

  final focusNodeHeight = FocusNode();
  final focusNodeWeight = FocusNode();

  var isRequesting = false;

  @override
  void dispose() {
    onPatient();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    drugFormulaSelectedVN.value = widget.drugFormulaSelected;

    final heightNum = int.tryParse(height ?? "");
    final weightNum = int.tryParse(weight ?? "");
    if (heightNum == 0 || heightNum == null) {
      height = "";
    }

    if (weightNum == 0 || weightNum == null) {
      weight = "";
    }

    if (height?.isNotEmpty == true && weight?.isNotEmpty == true) {
      onCalulator();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // focusNode.requestFocus();
      // dosageVN.value = widget.dosage;
      // onCalulator();
    });
  }

  @override
  void didUpdateWidget(covariant DrugDosageCalPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (
        // oldWidget.drugId != widget.drugId ||
        //     oldWidget.drugName != widget.drugName ||
        oldWidget.weight != widget.weight ||
            oldWidget.height != widget.height ||
            // oldWidget.dosage != widget.dosage ||
            oldWidget.drugFormulas != widget.drugFormulas ||
            oldWidget.drugFormulaSelected != widget.drugFormulaSelected ||
            // oldWidget.drugPlanSelected != widget.drugPlanSelected ||
            oldWidget.drugUseWaySelected != widget.drugUseWaySelected) {
      weight = widget.weight ?? "";
      height = widget.height ?? "";
      drugFormulas = widget.drugFormulas;
      drugFormulaSelectedVN.value = widget.drugFormulaSelected;
      // drugPlanSelected = widget.drugPlanSelected;
      drugUseWaySelected = widget.drugUseWaySelected;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final drugName = drugPlanSelected?.strategy?.drugs.map((e) => e.name).join("、");

    return Container(
      padding: EdgeInsets.only(
        top: 12,
        left: 15,
        right: 15,
        bottom: max(12, MediaQuery.of(context).padding.bottom) - 8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 8),
            decoration: const BoxDecoration(
              color: Colors.transparent,
              // border: Border.all(color: Colors.blue),
            ),
            child: const NText(
              "化疗药品剂量计算器",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: fontColor,
              ),
            ),
          ),
          NTextfieldUnit(
            name: "身       高：",
            value: height ?? "",
            unit: "cm",
            focusNode: focusNodeHeight,
            keyboardType: const TextInputType.numberWithOptions(decimal: true), // 显示数字键盘
            inputFormatters: [
              // FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // 允许数字和小数点
              FilteringTextInputFormatter.digitsOnly, // 允许数字
              LengthLimitingTextInputFormatter(3),
            ],
            debounceMilliseconds: 500,
            onChanged: (value) async {
              DLog.d("身 高：$value");
              height = value;
              if (height?.isNotEmpty != true) {
                onClear(isFormula: false);
              }
              await onCalulator();
            },
          ),
          NTextfieldUnit(
            name: "体       重：",
            value: weight ?? "",
            focusNode: focusNodeWeight,
            unit: "kg",
            keyboardType: const TextInputType.numberWithOptions(decimal: true), // 显示数字键盘
            inputFormatters: [
              // FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // 允许数字和小数点
              FilteringTextInputFormatter.digitsOnly, // 允许数D字
              LengthLimitingTextInputFormatter(3),
            ],
            debounceMilliseconds: 500,
            onChanged: (value) async {
              DLog.d("体 重：$value");
              weight = value;
              if (weight?.isNotEmpty != true) {
                onClear(isFormula: false);
              }
              await onCalulator();
            },
          ),
          NTextfieldUnit(
            name: "化疗方案：",
            value: drugPlanSelected?.name ?? '',
            hitText: "请选择",
            onTap: () {
              DLog.d("化疗方案");

              // if (weight.toString().isNotEmpty != true || height.toString().isNotEmpty != true) {
              //   EasyToast.showToast("身高体重不能为空");
              //   return;
              // }

              int? initialItem;
              if (drugPlanSelected != null) {
                initialItem = drugPlans.indexOf(drugPlanSelected!);
              }

              GetBottomSheet.showCustom(
                hideDragIndicator: false,
                addUnconstrainedBox: false,
                // isScrollControlled: true,
                child: NCupertinoPickerListView(
                  title: '化疗方案',
                  cancelArrow: true,
                  onCancel: () async {
                    Navigator.of(context).pop();
                  },
                  items: drugPlans,
                  cbName: (e) => e.name,
                  initialItem: initialItem,
                  onSelectedItemChanged: (idx) async {
                    final select = drugPlans[idx];
                    drugPlanSelected = select;
                    DLog.d("化疗方案 drugPlanSelected：$drugPlanSelected");
                    await onCalulator();
                    final heightTmp = double.tryParse(height ?? "0") ?? 0;
                    final weightTmp = double.tryParse(weight ?? "0") ?? 0;
                    final bsa = BSAUtils.calculateBSA(height: heightTmp, weight: weightTmp);
                    drugPlanSelected?.strategy?.calculateDrugDosage(bsa: bsa);
                    setState(() {});
                  },
                ),
              );
            },
            readOnly: true,
            readOnlyFillColor: white,
            onChanged: (value) {
              DLog.d("化疗方案：$value");
            },
          ),
          NTextfieldUnit(
            enabled: false,
            name: "药品名称：",
            value: drugName ?? '',
            hitText: "请选择",
            onTap: () {
              DLog.d("药品名称");
            },
            readOnly: true,
            readOnlyFillColor: white,
            hideSuffix: true,
            onChanged: (value) {
              DLog.d("药品名称：$value");
            },
          ),
          NTextfieldUnit(
            // enabled: false,
            name: "用药方式：",
            value: drugUseWaySelected?.desc ?? "",
            hitText: "请选择",
            onTap: () {
              DLog.d("用药方式");

              var initialItem = 0;
              if (drugUseWaySelected != null) {
                initialItem = drugUseWays.indexOf(drugUseWaySelected!);
              }

              GetBottomSheet.showCustom(
                hideDragIndicator: false,
                addUnconstrainedBox: false,
                // isScrollControlled: true,
                child: NCupertinoPickerListView(
                  title: '用药方式',
                  cancelArrow: true,
                  onCancel: () async {
                    Navigator.of(context).pop();
                  },
                  items: drugUseWays,
                  cbName: (e) => e.desc,
                  initialItem: initialItem,
                  onSelectedItemChanged: (idx) async {
                    final select = drugUseWays[idx];
                    drugUseWaySelected = select;
                    DLog.d("用药方式 drugUseWaySelected：$drugUseWaySelected");
                    await onCalulator();
                    setState(() {});
                  },
                ),
              );
            },
            readOnly: true,
            readOnlyFillColor: white,
            // hideSuffix: true,
            onChanged: (value) {
              DLog.d("用药方式：$value");
            },
          ),
          NTextfieldUnit(
            enabled: false,
            name: "剂量公式：",
            value:
                drugPlanSelected?.strategy?.drugs.map((e) => e.remark ?? "").where((e) => e.isNotEmpty).join("、") ?? "",
            hitText: "",
            textColor: fontColor737373,
            maxLines: 10,
            onChanged: (value) {
              DLog.d("剂量公式：$value");
            },
            hideSuffix: true,
            readOnly: true,
            onTap: () {
              DLog.d("TextField clicked"); // 自定义点击逻辑
            },
          ),
          ValueListenableBuilder(
            valueListenable: dosageVN,
            builder: (context, dosage, child) {
              return NTextfieldUnit(
                enabled: false,
                name: "推荐剂量：",
                value: "${dosage ?? ""}",
                unit: "mg",
                hitText: "",
                textColor: fontColor737373,
                readOnly: true,
                onChanged: (value) {
                  DLog.d("推荐剂量：$value");
                },
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: NFooterButtonBar(
              // hideCancel: !readOnly,
              boxShadow: const [],
              // enable: enable,
              onCancel: () {
                Navigator.of(context).pop();
              },
              onConfirm: () async {
                if (isRequesting) {
                  ToastUtil.show("请等待计算结果再提交！");
                  return;
                }

                widget.onConfirm(drugPlanSelected);
                Navigator.of(context).pop();
              },
              padding: const EdgeInsets.only(
                  // top: 16,
                  // bottom: 16,
                  ),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
            ),
          ),
        ]
            .map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: e,
                ))
            .toList(),
      ),
    );
  }

  /// 计算
  Future<void> onCalulator() async {
    if (height == "null") {
      height = "";
    }

    if (weight == "null") {
      weight = "";
    }

    if (height?.isNotEmpty != true || weight?.isNotEmpty != true) {
      // EasyToast.showToast("身高体重不能为空");
      return;
    }

    // final first = widget.drugFormulas.firstWhereOrNull((e) {
    //   final samePlan = e.planType == drugPlanSelected?.name;
    //   final sameUseWay = e.useWay == drugUseWaySelected?.name;
    //   final result = samePlan && sameUseWay;
    //   return result;
    // });
    // if (first == null) {
    //   DLog.d("未匹配到方案：${drugPlanSelected}, ${drugUseWaySelected}");
    //   onClear(isFormula: true);
    //   return;
    // }

    // isRequesting = true; // 发起请求
    //
    // drugFormulaSelectedVN.value = first;
    // final formula = drugFormulaSelectedVN.value?.formula;
    // final result = await drugDetailsController.requestCalFormulasReultWithBSA(
    //   formula: formula,
    //   weight: weight,
    //   height: height,
    // );
    // DLog.d("requestCalFormulasReultWithBSA：$result");
    //
    // isRequesting = false; // 结束请求
    // if (result == null) {
    //   return;
    // }
    // drugFormulaSelectedVN.value?.dosage = result;
    // dosageVN.value = result;
  }

  /// 清除公式
  /// isFormula 为 true 清除选择的公式模型; false 仅清除计算结果
  void onClear({required bool isFormula}) {
    if (isFormula) {
      // 清除选择的公式模型
      drugFormulaSelectedVN.value = null;
    } else {
      // 仅清除计算结果
      // drugFormulaSelectedVN.value?.dosage = null;
    }
    dosageVN.value = null;
  }

  void onPatient() {
    // final double weightNew = double.tryParse(weight ?? "0") ?? 0;
    // final double heightNew = double.tryParse(height ?? "0") ?? 0;
    // if (weightNew <= 0 || heightNew <= 0) {
    //   // EasyToast.showToast("身高体重不能为空");
    //   return;
    // }

    widget.onPatient?.call({
      "height": height,
      "weight": weight,
    });
  }
}
