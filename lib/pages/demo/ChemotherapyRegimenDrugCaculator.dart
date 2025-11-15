//
//  ChemotherapyRegimenDrugCaculator.dart
//  flutter_templet_project
//
//  Created by shang on 2024/12/6 15:45.
//  Copyright © 2024/12/6 shang. All rights reserved.
//

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_templet_project/basicWidget/n_menu_anchor.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/extension/object_ext.dart';
import 'package:flutter_templet_project/pages/demo/drug_dosage_cal_page.dart';
import 'package:flutter_templet_project/pages/medication_calculator.dart';
import 'package:flutter_templet_project/util/get_util.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';

/// 化疗药品计算
class ChemotherapyRegimenDrugCaculator extends StatefulWidget {
  const ChemotherapyRegimenDrugCaculator({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<ChemotherapyRegimenDrugCaculator> createState() => _ChemotherapyRegimenDrugCaculatorState();
}

class _ChemotherapyRegimenDrugCaculatorState extends State<ChemotherapyRegimenDrugCaculator> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final _scrollController = ScrollController();

  // 输入患者身高和体重
  double height = 175.0; // 身高 (cm)
  double weight = 85.0; // 体重 (kg)
  double bsa = 0.0; // 体重 (kg)

  final strategyMap = ChemotherapyRegimenTreatmentStrategyEnum.map;
  ChemotherapyRegimenTreatmentStrategyEnum? selectedStrategy = ChemotherapyRegimenTreatmentStrategyEnum.GN;

  final dosageVN = ValueNotifier("");

  @override
  void initState() {
    super.initState();

    bsa = BSAUtils.calculateBSA(height: height, weight: weight);
    caculatorEnum(strategy: selectedStrategy);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
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
                          onPicker();
                        },
                      ))
                  .toList(),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NText("身高: $height"),
              NText("体重: $weight"),
              NText("体表面积: $bsa"),
              FractionallySizedBox(
                widthFactor: 0.40,
                alignment: Alignment.centerLeft,
                child: OutlinedButton(
                  onPressed: onCaculator,
                  child: Text("计算所有方案"),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 0.40,
                alignment: Alignment.centerLeft,
                child: buildMenuAnchor(),
              ),
              ValueListenableBuilder(
                valueListenable: dosageVN,
                builder: (context, value, child) {
                  if (value.isEmpty) {
                    return SizedBox();
                  }
                  return SelectableText("方案药品: \n$value");
                },
              ),
            ].map((e) => Padding(padding: EdgeInsets.symmetric(vertical: 8), child: e)).toList(),
          ),
        ),
      ),
    );
  }

  /// 选择框
  Widget buildMenuAnchor() {
    return NMenuAnchor<ChemotherapyRegimenTreatmentStrategyEnum>(
      style: MenuStyle(
        alignment: Alignment.centerLeft,
      ),
      values: strategyMap.keys.toList(),
      initialItem: selectedStrategy,
      onChanged: (val) {
        selectedStrategy = val;
        caculatorEnum(strategy: val);
      },
      equal: (a, b) => a == b,
      cbName: (e) => "${e?.name}",
      builder: (controller, selectedItem) {
        final name = selectedItem?.name;
        final nameStyle = TextStyle(
          fontSize: 15,
          color: AppColor.fontColor,
          fontWeight: FontWeight.w400,
        );
        return InkWell(
          onTap: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          child: Container(
            height: 36,
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColor.lineColor),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    name ?? "请选择",
                    style: nameStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Image(
                  image: AssetImage("assets/images/icon_arrow_down.png"),
                  width: 16,
                  height: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 计算所有方案
  void onCaculator() {
    // // 输入患者身高和体重
    // double height = 170.0; // 身高 (cm)
    // double weight = 65.0; // 体重 (kg)

    // // 计算体表面积
    // double bsa = BSAUtils.calculateBSA(height: height, weight: weight);
    // print('体表面积: $bsa');

    // 计算GN方案
    final gNCalculator = ChemotherapyRegimenTreatmentCalculator(GNStrategy());
    final gnDrugs = gNCalculator.calculateDrugDosage(bsa: bsa);
    DLog.d('GN方案: \n${jsonEncode(gnDrugs.map((e) => e.toJson()).toList())}');

    // 计算FLOFIRINOX方案
    final fLOFIRINOXCalculator = ChemotherapyRegimenTreatmentCalculator(FLOFIRINOXStrategy());
    final flofirinoxDrugs = fLOFIRINOXCalculator.calculateDrugDosage(bsa: bsa);
    DLog.d('FLOFIRINOX方案: \n${jsonEncode(flofirinoxDrugs.map((e) => e.toJson()).toList())}');

    final mFLOFIRINOXCalculator = ChemotherapyRegimenTreatmentCalculator(MFLOFIRINOXStrategy());
    final mflofirinoxDrugs = mFLOFIRINOXCalculator.calculateDrugDosage(bsa: bsa);
    DLog.d('mflofirinox 方案: \n${jsonEncode(mflofirinoxDrugs.map((e) => e.toJson()).toList())}');
  }

  /// 计算选中方案
  void caculatorEnum({required ChemotherapyRegimenTreatmentStrategyEnum? strategy}) {
    final drugs = strategy?.calculateDrugDosage(bsa: bsa) ?? [];
    final jsonStr = drugs.map((e) => e.toJson()).toList().formatedString();
    DLog.d('${strategy?.runtimeType} 方案药品: \n$jsonStr');
    dosageVN.value = jsonStr;
  }

  // /// 计算选中方案
  // void caculator({required ChemotherapyRegimenTreatmentStrategy strategy}) {
  //   // 计算方案
  //   var gnQuantities = strategy.calculateDrugQuantities(bsa: bsa);
  //   DLog.d('${strategy.runtimeType} 方案药品数量: \n${jsonEncode(gnQuantities.map((e) => e.toJson()).toList())}');
  // }

  void onPicker() {
    var heightTmp = 170.0; // 身高 (cm)
    var weightTmp = 65.0; // 体重 (kg)

    GetBottomSheet.showCustom(
      enableDrag: false,
      hideDragIndicator: false,
      isScrollControlled: true,
      child: DrugDosageCalPage(
        height: heightTmp.toString(),
        weight: weightTmp.toString(),
        // drugId: "drugId",
        // drugName: "drugName",
        drugFormulas: ChemotherapyRegimenTreatmentStrategyEnum.values,
        drugFormulaSelected: ChemotherapyRegimenTreatmentStrategyEnum.values.first,
        drugPlanSelected: ChemotherapyRegimenTreatmentStrategyEnum.values.first,
        drugUseWaySelected: DrugUseWayEnum.FAST,
        // dosage: scheduleInfo?.calFormula?.dosage,
        onPatient: (val) {},
        onConfirm: (value) {},
      ),
    );
  }
}
