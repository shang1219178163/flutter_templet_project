//
//  ExpressionFormulaMxin.dart
//  flutter_templet_project
//
//  Created by shang on 2024/12/16 11:36.
//  Copyright © 2024/12/16 shang. All rights reserved.
//

import 'package:expressions/expressions.dart';
import 'package:flutter/cupertino.dart';

/// 表达公式计算
mixin ExpressionFormulaMxin {
  /// 表达公式计算
  dynamic formulaCalulator({required String formula, required Map<String, dynamic> params}) {
    try {
      // 定义公式（将 × 替换为 *，÷ 替换为 /）
      var formulaNew = formula.replaceAll("×", "*").replaceAll("÷", "/");
      DLog.d("$runtimeType formulaNew: $formulaNew");

      final evaluator = const ExpressionEvaluator();
      var result = evaluator.eval(Expression.parse(formulaNew), params);
      DLog.d("$runtimeType result: $result");
      return result;
    } catch (e) {
      debugPrint("$runtimeType $e");
    }
    return null;
  }
}
