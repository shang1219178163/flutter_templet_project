//
//  ObjectExtension.dart
//  flutter_templet_project
//
//  Created by shang on 10/12/22 4:54 PM.
//  Copyright © 10/12/22 shang. All rights reserved.
//

// class ObjectBaseModel {
//   ///运算符重载
//   dynamic operator [](String key) {
//     final keys = this.toJson().keys.toList();
//     return keys.contains(key) ? this.toJson()[key] : null;
//   }
//
//   ///运算符重载
//   void operator []=(String key, dynamic value) {
//     this.toJson()[key] = value;
//   }
//
//   Map<String, dynamic> toJson() {
//     return {};
//   }
//
//   // ObjectBaseModel modelFromJson(Map<String, dynamic>) {
//   //
//   // }
// }

import 'dart:convert';

import 'package:flutter/cupertino.dart';

abstract class ObjectEnhanceMixin {
  ///运算符重载
  dynamic operator [](String key) {
    // final keys = this.toJson().keys.toList();
    // return keys.contains(key) ? this.toJson()[key] : null;
  }

  ///运算符重载
  void operator []=(String key, dynamic value) {
    // this.toJson()[key] = value;
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}

extension ObjectExt on Object {
  ///运算符重载
  List operator *(int value) {
    var result = [];
    for (var i = 0; i < value; i++) {
      result.add(this);
    }
    return result;
  }

  /// 转字符串
  String? tryJsonEncode<T>(
      {Object? Function(Object? nonEncodable)? toEncodable}) {
    try {
      final result = jsonEncode(this, toEncodable: toEncodable);
      return result;
    } catch (e) {
      debugPrint("❌tryJsonEncode: $e");
      return null;
    }
  }
}

extension DynamicExt<T> on T {
  /// 返回可选值或者 `else` 闭包返回的值
  /// 例如. nullable.or(else: {
  /// ... code
  /// })
  T orElse(T Function() block) {
    return this ?? block();
  }

  T or(T v) {
    return this ?? v;
  }
}

// extension on dynamic{
//
//   dynamic or({required dynamic callback()}) async {
//     return this ?? callback();
//   }
//
// }

// extension NullExt on Null{
//
//   dynamic or({required dynamic callback()}) async {
//     return
//   }
//
// }
