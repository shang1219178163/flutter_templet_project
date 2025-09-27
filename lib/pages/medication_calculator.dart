//
//  MedicationCalculator.dart
//  flutter_templet_project
//
//  Created by shang on 2024/12/6 15:45.
//  Copyright © 2024/12/6 shang. All rights reserved.
//

// 定义药物模型
import 'package:flutter/cupertino.dart';

/// 药品使用类型
enum DrugUseWayEnum {
  FAST("FAST", "快速注射"),
  SUSTAIN("SUSTAIN", "持续输注");

  const DrugUseWayEnum(this.name, this.desc);

  final String name;
  final String desc;
}

/// 化疗药品
class ChemotherapyRegimenDrug {
  ChemotherapyRegimenDrug({
    required this.name,
    required this.dosagePerBSA,
    required this.specification,
    // required this.formula,
    this.recommendedDosage,
    this.recommendedQuantity,
    this.remark,
  });

  // 药品名称
  final String name;
  // 每单位体表面积的推荐剂量
  final double dosagePerBSA;

  /// 药品规格（单位：mg）
  final double specification;

  /// 药品剂量公式
  // final String formula;

  /// 推荐剂量（单位：mg）3位小数
  final double? recommendedDosage;

  /// 推荐剂数
  final int? recommendedQuantity;

  /// 备注
  final String? remark;

  ChemotherapyRegimenDrug copyWith({
    String? name,
    double? dosagePerBSA,
    double? specification,
    // String? formula,
    double? recommendedDosage,
    int? recommendedQuantity,
    String? remark,
  }) {
    return ChemotherapyRegimenDrug(
      name: name ?? this.name,
      dosagePerBSA: dosagePerBSA ?? this.dosagePerBSA,
      specification: specification ?? this.specification,
      // formula: formula ?? this.formula,
      recommendedDosage: recommendedDosage ?? this.recommendedDosage,
      recommendedQuantity: recommendedQuantity ?? this.recommendedQuantity,
      remark: remark ?? this.remark,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['dosagePerBSA'] = dosagePerBSA;
    data['specification'] = specification;
    // data['formula'] = formula;
    data['recommendedDosage'] = recommendedDosage;
    data['recommendedQuantity'] = recommendedQuantity;
    data['remark'] = remark;
    return data;
  }
}

// 定义方案策略接口
abstract class ChemotherapyRegimenTreatmentStrategy {
  /// 药品组合
  List<ChemotherapyRegimenDrug> get drugs => [];

  /// 计算推荐剂量
  List<ChemotherapyRegimenDrug> calculateDrugDosage({
    required double bsa,
  }) {
    final result = drugs.map((drug) {
      var recommendedDosage = drug.dosagePerBSA * bsa;
      final recommendedDosageNew = double.parse(recommendedDosage.toStringAsFixed(3)); // 3位小数
      var quantity = (recommendedDosageNew / drug.specification).ceil();
      return drug.copyWith(
        recommendedDosage: recommendedDosageNew,
        recommendedQuantity: quantity,
        remark: "默认计算公式",
      );
    }).toList();
    return result;
  }
}

// GN方案策略
class GNStrategy extends ChemotherapyRegimenTreatmentStrategy {
  @override
  List<ChemotherapyRegimenDrug> get drugs => [
        ChemotherapyRegimenDrug(name: "吉西他滨", dosagePerBSA: 1000, specification: 200), // 药品规格：0.2g
        ChemotherapyRegimenDrug(name: "吉西他滨", dosagePerBSA: 1000, specification: 1000), // 药品规格：1g
        ChemotherapyRegimenDrug(name: "紫杉醇", dosagePerBSA: 125, specification: 100), // 药品规格：100mg
      ];
}

// FLOFIRINOX方案策略
class FLOFIRINOXStrategy extends ChemotherapyRegimenTreatmentStrategy {
  @override
  List<ChemotherapyRegimenDrug> get drugs => [
        ChemotherapyRegimenDrug(name: "奥沙利铂", dosagePerBSA: 85, specification: 50), // 药品规格：50mg
        ChemotherapyRegimenDrug(name: "伊立替康", dosagePerBSA: 180, specification: 300), // 药品规格：0.3g
        ChemotherapyRegimenDrug(name: "亚叶酸钙", dosagePerBSA: 400, specification: 100), // 药品规格：25mg
        ChemotherapyRegimenDrug(name: "氟尿嘧啶", dosagePerBSA: 400, specification: 250), // 药品规格：10mg，快速注射
      ];

  /// 计算推荐剂量
  @override
  List<ChemotherapyRegimenDrug> calculateDrugDosage({
    required double bsa,
  }) {
    final result = drugs.map((drug) {
      var recommendedDosage = drug.dosagePerBSA * bsa;
      final recommendedDosageNew = double.parse(recommendedDosage.toStringAsFixed(3)); // 3位小数
      var quantity = (recommendedDosageNew / drug.specification).ceil();
      return drug.copyWith(
        recommendedDosage: recommendedDosageNew,
        recommendedQuantity: quantity,
        remark: "FLOFIRINOX 计算公式",
      );
    }).toList();
    return result;
  }
}

// FLOFIRINOX方案策略
class MFLOFIRINOXStrategy extends ChemotherapyRegimenTreatmentStrategy {
  @override
  List<ChemotherapyRegimenDrug> get drugs => [
        ChemotherapyRegimenDrug(name: "奥沙利铂", dosagePerBSA: 85, specification: 50), // 药品规格：50mg
        ChemotherapyRegimenDrug(name: "伊立替康", dosagePerBSA: 150, specification: 300), // 药品规格：0.3g
        ChemotherapyRegimenDrug(name: "亚叶酸钙", dosagePerBSA: 400, specification: 100), // 药品规格：25mg
        ChemotherapyRegimenDrug(name: "氟尿嘧啶", dosagePerBSA: 2400, specification: 250), // 药品规格：10mg，快速注射
      ];

  /// 计算推荐剂量
  @override
  List<ChemotherapyRegimenDrug> calculateDrugDosage({
    required double bsa,
  }) {
    final result = drugs.map((drug) {
      var recommendedDosage = drug.dosagePerBSA * bsa;
      final recommendedDosageNew = double.parse(recommendedDosage.toStringAsFixed(3)); // 3位小数
      var quantity = (recommendedDosageNew / drug.specification).ceil();
      return drug.copyWith(
        recommendedDosage: recommendedDosageNew,
        recommendedQuantity: quantity,
        remark: "mFLOFIRINOX 计算公式",
      );
    }).toList();
    return result;
  }
}

// 计算上下文类
class ChemotherapyRegimenTreatmentCalculator {
  ChemotherapyRegimenTreatmentCalculator(this.strategy);

  ChemotherapyRegimenTreatmentStrategy strategy;

  List<ChemotherapyRegimenDrug> calculateDrugDosage({required double bsa}) {
    return strategy.calculateDrugDosage(bsa: bsa);
  }
}

// enum ChemotherapyRegimenTreatmentStrategyEnum1 {
//   GN(name: "GN", desc: "方案GN", strategy: GNStrategy()),
//
//   FLOFIRINOX(name: "FLOFIRINOX", desc: '方案FLOFIRINOX'),
//
//   mFLOFIRINOX(name: "mFLOFIRINOX", desc: '方案mFLOFIRINOX');
//
//   const ChemotherapyRegimenTreatmentStrategyEnum1({
//     required this.name,
//     required this.desc,
//     required this.strategy,
//   });
//
//   /// 当前枚举值对应的 name
//   final String name;
//
//   /// 当前枚举对应的 描述文字
//   final String desc;
//   final ChemotherapyRegimenTreatmentStrategy strategy;
// }

/// 化疗方案枚举
enum ChemotherapyRegimenTreatmentStrategyEnum {
  GN(name: "GN", desc: "方案GN"),

  FLOFIRINOX(name: "FLOFIRINOX", desc: '方案FLOFIRINOX'),

  mFLOFIRINOX(name: "mFLOFIRINOX", desc: '方案mFLOFIRINOX');

  const ChemotherapyRegimenTreatmentStrategyEnum({
    required this.name,
    required this.desc,
  });

  /// 当前枚举值对应的 name
  final String name;

  /// 当前枚举对应的 描述文字
  final String desc;

  /// 方案集合(因为 enum 子项无法支持声明类常量)
  static Map<ChemotherapyRegimenTreatmentStrategyEnum, ChemotherapyRegimenTreatmentStrategy> get map => {
        GN: GNStrategy(),
        FLOFIRINOX: FLOFIRINOXStrategy(),
        mFLOFIRINOX: MFLOFIRINOXStrategy(),
      };

  ChemotherapyRegimenTreatmentStrategy? get strategy => map[this];

  /// 计算
  List<ChemotherapyRegimenDrug>? calculateDrugDosage({required double bsa}) {
    final strategy = ChemotherapyRegimenTreatmentStrategyEnum.map[this];
    return strategy?.calculateDrugDosage(bsa: bsa);
  }
}

// 体表面积工具类
class BSAUtils {
  static double calculateBSA({required double height, required double weight}) {
    final bsa = 0.0061 * height + 0.0128 * weight - 0.1529;
    debugPrint('BSAUtils 体表面积: $bsa');
    return bsa;
  }
}

// // 主函数
// void main() {
//   // 输入患者身高和体重
//   double height = 170.0; // 身高 (cm)
//   double weight = 65.0; // 体重 (kg)
//
//   // 计算体表面积
//   double bsa = BSAUtils.calculateBSA(height: height, weight: weight);
//   print('体表面积: $bsa');
//
//   // 计算GN方案
//   final gNCalculator = ChemotherapyRegimenTreatmentCalculator(GNStrategy());
//   final gnQuantities = gNCalculator.calculateDrugQuantities(bsa: bsa);
//   print('GN方案药品数量: $gnQuantities');
//
//   // 计算FLOFIRINOX方案
//   final flofirinoxCalculator = ChemotherapyRegimenTreatmentCalculator(FLOFIRINOXStrategy());
//   final flofirinoxQuantities = flofirinoxCalculator.calculateDrugQuantities(bsa: bsa);
//   print('FLOFIRINOX方案药品数量: $flofirinoxQuantities');
//
//   // 计算mFLOFIRINOX方案
//   final mflofirinoxCalculator = ChemotherapyRegimenTreatmentCalculator(MFLOFIRINOXStrategy());
//   final mflofirinoxQuantities = mflofirinoxCalculator.calculateDrugQuantities(bsa: bsa);
//   print('mFLOFIRINOX方案药品数量: $flofirinoxQuantities');
// }
