//
//  LocationMixin.dart
//  flutter_templet_project
//
//  Created by shang on 2024/9/1 11:40.
//  Copyright © 2024/9/1 shang. All rights reserved.
//

// 定义一个 mixin，提供地址属性和相关方法
import 'package:flutter/cupertino.dart';
import 'package:flutter_templet_project/vendor/amap_location/location_detail_model.dart';

/// 为模型附加属性
mixin AddressMixin {
  // 添加一个新属性 address
  LocationDetailModel? _address;

  LocationDetailModel? get address => _address;

  set address(LocationDetailModel? value) {
    _address = value;
  }

  // 打印地址信息的方法
  void printAddress() {
    if (_address != null) {
      debugPrint('$this Address: ${address?.toJson()}');
    } else {
      debugPrint('$this Address is not set.');
    }
  }
}
