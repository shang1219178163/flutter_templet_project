//
//  UserApiProvider.dart
//  flutter_templet_project
//
//  Created by shang on 2024/3/13 21:57.
//  Copyright © 2024/3/13 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/model/order_model.dart';

/// 订单接口集合
class OrderProvider<E extends OrderModel> extends ChangeNotifier {
  OrderProvider();

  /// 查
  Future<E?> read() async {
    notifyListeners();
    return null;
  }

  /// 查
  Future<List<E>> readList() async {
    notifyListeners();
    return [];
  }

  /// 查
  Future<({int code, String message})> update() async {
    notifyListeners();
    return (code: 0, message: "请求成功");
  }

  /// 查
  Future<({int code, String message})> create() async {
    notifyListeners();
    return (code: 0, message: "请求成功");
  }

  /// 查
  Future<({int code, String message})> delete() async {
    notifyListeners();
    return (code: 0, message: "请求成功");
  }
}
