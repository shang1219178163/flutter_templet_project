//
//  MedicationCalculator.dart
//  flutter_templet_project
//
//  Created by shang on 2024/12/6 15:45.
//  Copyright © 2024/12/6 shang. All rights reserved.
//

// 定义药物模型
import 'package:flutter/cupertino.dart';

/// 化疗药品
class ChemotherapyRegimenDrug {
  // 药品名称
  final String name;
  // 每单位体表面积的推荐剂量
  final double dosagePerBSA;

  /// 药品规格（单位：mg）
  final double specification;

  /// 推荐剂量（单位：mg）3位小数
  final double? recommendedDosage;

  /// 推荐剂数
  final int? recommendedQuantity;

  ChemotherapyRegimenDrug({
    required this.name,
    required this.dosagePerBSA,
    required this.specification,
    this.recommendedDosage,
    this.recommendedQuantity,
  });

  ChemotherapyRegimenDrug copyWith({
    String? name,
    double? dosagePerBSA,
    double? specification,
    double? recommendedDosage,
    int? recommendedQuantity,
  }) {
    return ChemotherapyRegimenDrug(
      name: name ?? this.name,
      dosagePerBSA: dosagePerBSA ?? this.dosagePerBSA,
      specification: specification ?? this.specification,
      recommendedDosage: recommendedDosage ?? this.recommendedDosage,
      recommendedQuantity: recommendedQuantity ?? this.recommendedQuantity,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['dosagePerBSA'] = dosagePerBSA;
    data['specification'] = specification;
    data['recommendedDosage'] = recommendedDosage;
    data['recommendedQuantity'] = recommendedQuantity;
    return data;
  }
}

// 定义方案策略接口
abstract class TreatmentStrategy {
  List<ChemotherapyRegimenDrug> get drugs => [];

  List<ChemotherapyRegimenDrug> calculateDrugQuantities({
    required double height,
    required double weight,
  }) {
    double bsa = BSAUtils.calculateBSA(height: height, weight: weight);

    final result = drugs.map((drug) {
      double recommendedDosage = drug.dosagePerBSA * bsa;
      final recommendedDosageNew = double.parse(recommendedDosage.toStringAsFixed(3)); // 3位小数
      int quantity = (recommendedDosageNew / drug.specification).ceil();
      return drug.copyWith(
        recommendedDosage: recommendedDosageNew,
        recommendedQuantity: quantity,
      );
    }).toList();
    return result;
  }
}

// GN方案策略
class GNStrategy extends TreatmentStrategy {
  @override
  List<ChemotherapyRegimenDrug> get drugs => [
        ChemotherapyRegimenDrug(name: "吉西他滨", dosagePerBSA: 1000, specification: 200), // 药品规格：0.2g
        ChemotherapyRegimenDrug(name: "紫杉醇", dosagePerBSA: 125, specification: 100), // 药品规格：100mg
      ];
}

// FLOFIRINOX方案策略
class FLOFIRINOXStrategy extends TreatmentStrategy {
  @override
  List<ChemotherapyRegimenDrug> get drugs => [
        ChemotherapyRegimenDrug(name: "奥沙利铂", dosagePerBSA: 85, specification: 50), // 药品规格：50mg
        ChemotherapyRegimenDrug(name: "伊立替康", dosagePerBSA: 180, specification: 300), // 药品规格：0.3g
        ChemotherapyRegimenDrug(name: "亚叶酸钙", dosagePerBSA: 400, specification: 25), // 药品规格：25mg
        ChemotherapyRegimenDrug(name: "氟尿嘧啶", dosagePerBSA: 400, specification: 10), // 药品规格：10mg，快速注射
      ];
}

// FLOFIRINOX方案策略
class MFLOFIRINOXStrategy extends TreatmentStrategy {
  @override
  List<ChemotherapyRegimenDrug> get drugs => [
        ChemotherapyRegimenDrug(name: "奥沙利铂", dosagePerBSA: 85, specification: 50), // 药品规格：50mg
        ChemotherapyRegimenDrug(name: "伊立替康", dosagePerBSA: 150, specification: 300), // 药品规格：0.3g
        ChemotherapyRegimenDrug(name: "亚叶酸钙", dosagePerBSA: 400, specification: 25), // 药品规格：25mg
        ChemotherapyRegimenDrug(name: "氟尿嘧啶", dosagePerBSA: 2400, specification: 10), // 药品规格：10mg，快速注射
      ];
}

// 计算上下文类
class TreatmentCalculator {
  TreatmentCalculator(this.strategy);

  final TreatmentStrategy strategy;

  List<ChemotherapyRegimenDrug> calculateDrugQuantities(double height, double weight) {
    return strategy.calculateDrugQuantities(height: height, weight: weight);
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
//   double bsa = BSAUtils.calculateBSA(height, weight);
//   print('体表面积: $bsa');
//
//   // 计算GN方案
//   var gnQuantities = GNStrategy().calculateDrugQuantities(bsa);
//   print('GN方案药品数量: $gnQuantities');
//
//   // 计算FLOFIRINOX方案
//   var flofirinoxQuantities = FLOFIRINOXStrategy().calculateDrugQuantities(bsa);
//   print('FLOFIRINOX方案药品数量: $flofirinoxQuantities');
// }
