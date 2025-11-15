//
//  ExpressionsCalulatorDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/12/16 10:31.
//  Copyright © 2024/12/16 shang. All rights reserved.
//

import 'dart:math';

import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';

import 'package:flutter_templet_project/mixin/expression_formula_mxin.dart';
import 'package:get/get.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

/// 表达式计算
class ExpressionsCalulatorDemo extends StatefulWidget {
  const ExpressionsCalulatorDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<ExpressionsCalulatorDemo> createState() => _ExpressionsCalulatorDemoState();
}

class _ExpressionsCalulatorDemoState extends State<ExpressionsCalulatorDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final _scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  List<ExpressionCalulator> items = [
    ExpressionCalulator(
      title: "公式计算",
      formula: "cos(x)*cos(x)+sin(x)*sin(x)==1",
      params: {"x": pi / 5, "cos": cos, "sin": sin},
    ),
    ExpressionCalulator(
      title: "公式计算1",
      formula: "(0.0061 × h + 0.0128 × 54 - 0.1529) × w ÷ 50",
      params: {
        "h": 160.0,
        "w": 85.0,
      },
    ),
  ];

  @override
  void didUpdateWidget(covariant ExpressionsCalulatorDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: ListView.separated(
        controller: _scrollController,
        itemCount: items.length,
        itemBuilder: (_, index) {
          final e = items[index];

          return ListTile(
            // leading: NText(e.formula ?? ""),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                NSectionBox(
                  title: "公式:",
                  style: TextStyle(fontSize: 14),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  divider: SizedBox(),
                  child: NText(
                    e.formula ?? "",
                    fontSize: 12,
                  ),
                ),
                NSectionBox(
                  title: "参数:",
                  style: TextStyle(fontSize: 14),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  divider: SizedBox(),
                  child: NText(
                    e.params.toString() ?? "",
                    fontSize: 12,
                  ),
                ),
                if (e.result != null)
                  NSectionBox(
                    title: "计算结果:",
                    style: TextStyle(fontSize: 14),
                    divider: SizedBox(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: NText(
                      e.result?.toString() ?? "",
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
            trailing: ElevatedButton(
              style: TextButton.styleFrom(
                // padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: Size(24, 28),
                // foregroundColor: Colors.blue,
              ),
              onPressed: () {
                e.result = e.calulator();
                if (e.result is double) {
                  e.result = (e.result as double).toStringAsFixed(3);
                }
                setState(() {});
              },
              child: Text("计算"),
            ),
          );
        },
        separatorBuilder: (_, index) {
          return Divider(height: 0.5);
        },
      ),
    );
  }

  dynamic onCalulator() {
    try {
      var formula = "(0.0061 × 165 + 0.0128 × 54 - 0.1529) × 85 ÷ 50";
      // 定义公式（将 × 替换为 *，÷ 替换为 /）
      formula = formula.replaceAll("×", "*").replaceAll("÷", "/");
      DLog.d("formula: $formula");

      final params = {
        "h": 160.0,
        "w": 85.0,
      };

      final evaluator = const ExpressionEvaluator();
      var result = evaluator.eval(Expression.parse(formula), params);
      DLog.d("result: $result");
      return result;
    } catch (e) {
      debugPrint("$this $e");
    }
    return null;
  }
}

class ExpressionCalulator with ExpressionFormulaMxin {
  ExpressionCalulator({
    required this.title,
    required this.formula,
    required this.params,
    this.result,
  });

  String title;
  String formula;
  Map<String, dynamic> params;

  dynamic result;

  dynamic calulator() {
    return formulaCalulator(formula: formula, params: params);
  }

  factory ExpressionCalulator.fromJson(Map<String, dynamic> json) {
    return ExpressionCalulator(
      title: json['title'],
      formula: json['formula'],
      params: json['params'],
      result: json['result'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['formula'] = formula;
    data['params'] = params;
    data['result'] = result;
    return data;
  }
}
