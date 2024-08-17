import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 订单逻辑类
class OrderController extends GetxController {
  /// 重写方法,避免页面退出之后的 update 调用导致的问题
  @override
  void update([List<Object>? ids, bool condition = true]) {
    if (!Get.isRegistered<OrderController>()) {
      return;
    }
    super.update();
  }

  /// 详情
  requestDetail() async {
    await Future.delayed(Duration(milliseconds: 1500));
    update();
  }

  /// 提交
  submit({
    required Map map,
  }) async {
    await Future.delayed(Duration(milliseconds: 1500));
    update();
  }
}
