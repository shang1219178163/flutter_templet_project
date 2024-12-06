//
//  ChemotherapyRegimenDrugCaculator.dart
//  flutter_templet_project
//
//  Created by shang on 2024/12/6 15:45.
//  Copyright © 2024/12/6 shang. All rights reserved.
//

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_button.dart';
import 'package:flutter_templet_project/basicWidget/n_menu_anchor.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/pages/medication_calculator.dart';
import 'package:flutter_templet_project/util/color_util.dart';
import 'package:get/get.dart';

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

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  final strategyMap = <String, TreatmentStrategy>{
    "GN": GNStrategy(),
    "FLOFIRINOX": FLOFIRINOXStrategy(),
    "MFLOFIRINOX": MFLOFIRINOXStrategy(),
  };

  String? strategyInitail;
  String? selectedStrategy;

  @override
  void didUpdateWidget(covariant ChemotherapyRegimenDrugCaculator oldWidget) {
    super.didUpdateWidget(oldWidget);
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
                        onPressed: () => debugPrint(e),
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
        child: Column(
          children: [
            FractionallySizedBox(
              widthFactor: 0.35,
              // alignment: Alignment.centerLeft,
              child: buildMenuAnchor(),
            ),
            OutlinedButton(onPressed: onCaculator, child: Text("onCaculator")),
          ].map((e) => Padding(padding: EdgeInsets.symmetric(vertical: 8), child: e)).toList(),
        ),
      ),
    );
  }

  /// 选择框
  Widget buildMenuAnchor() {
    return NMenuAnchor(
      style: MenuStyle(
        alignment: Alignment.centerLeft,
      ),
      values: strategyMap.keys.toList(),
      initialItem: strategyInitail,
      onChanged: (val) {
        selectedStrategy = val;
        final strategy = strategyMap[val];
        DLog.d("val: $selectedStrategy, ${strategy}");
        if (strategy == null) {
          return;
        }
        caculator(strategy: strategy);
      },
      equal: (a, b) => a == b,
      cbName: (e) => "$e",
      builder: (controller, selectedItem) {
        final name = selectedItem;
        final nameStyle = TextStyle(
          fontSize: 15,
          color: fontColor,
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
              border: Border.all(color: lineColor),
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
    // 输入患者身高和体重
    double height = 170.0; // 身高 (cm)
    double weight = 65.0; // 体重 (kg)

    // 计算GN方案
    var gnQuantities = GNStrategy().calculateDrugQuantities(height: height, weight: weight);
    DLog.d('GN方案药品数量: ${jsonEncode(gnQuantities.map((e) => e.toJson()).toList())}');

    // 计算FLOFIRINOX方案
    var flofirinoxQuantities = FLOFIRINOXStrategy().calculateDrugQuantities(height: height, weight: weight);
    DLog.d('FLOFIRINOX方案药品数量: ${jsonEncode(flofirinoxQuantities.map((e) => e.toJson()).toList())}');

    var mflofirinoxQuantities = MFLOFIRINOXStrategy().calculateDrugQuantities(height: height, weight: weight);
    DLog.d('mflofirinox 方案药品数量: ${jsonEncode(mflofirinoxQuantities.map((e) => e.toJson()).toList())}');
  }

  /// 计算选中方案
  void caculator({required TreatmentStrategy strategy}) {
    // 输入患者身高和体重
    double height = 170.0; // 身高 (cm)
    double weight = 65.0; // 体重 (kg)

    // 计算方案
    var gnQuantities = strategy.calculateDrugQuantities(height: height, weight: weight);
    DLog.d('$strategy 方案药品数量: ${jsonEncode(gnQuantities.map((e) => e.toJson()).toList())}');
  }
}
