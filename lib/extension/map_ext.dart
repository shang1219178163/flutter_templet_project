//
//  MapExtension.dart
//  flutter_templet_project
//
//  Created by shang on 2022/11/24 10:43.
//  Copyright © 2022/11/24 shang. All rights reserved.
//


import 'dart:convert';

import 'package:flutter/cupertino.dart';

extension MapExt on Map<String, dynamic>{

  // static bool isEmpty(Map? val) {
  //   return val == null || val.isEmpty;
  // }
  //
  // static bool isNotEmpty(Map? val) {
  //   return val != null && val.isNotEmpty;
  // }

  Map get reversed => {
    for (var e in entries) e.value: e.key,
  };

  // 拼接键值成字符串
  String join({String char = '&'}) {
    if (keys.isEmpty) {
      return '';
    }
    var paramStr = '';
    forEach((key, value) {
      paramStr += '$key=$value$char';
    });
    final result = paramStr.substring(0, paramStr.length - 1);
    return result;
  }

  /// 递归遍历
  recursion(void Function(String key, dynamic value)? cb) {
    forEach((key, value) {
      cb?.call(key, value);
      recursion(cb);
    });
  }



}

/// 请求结果脱壳
extension MapResponseExt on Map<String, dynamic>{

  /// 数据请求
  ///
  /// onResult 根据 response 返回和泛型 T 对应的值(默认值取 response["result"])
  /// defaultValue 默认值
  ///
  /// return (请求是否成功, 提示语)
  /// 备注: isSuccess == false 且 message为空一般为断网
  Future<({bool isSuccess, String message, T result})> fetchResult<T>({
    required T Function(Map<String, dynamic> response)? onResult,
    required T defaultValue,
  }) async {
    final response = this;
    if (response.isEmpty) {
      return (isSuccess: false, message: "", result: defaultValue); //断网
    }
    bool isSuccess = response['code'] == "OK";
    String message = response["message"] as String? ?? "";
    final resultNew =
        onResult?.call(response) ?? response["result"] as T? ?? defaultValue;
    return (isSuccess: isSuccess, message: message, result: resultNew);
  }

  /// 返回布尔值的数据请求
  ///
  /// onTrue 根据字典返回 true 的判断条件(默认判断 response["result"] 布尔值真假)
  /// onBefore 请求前
  /// onAfter 请求后
  ///
  /// return (请求是否成功, 提示语)
  Future<({bool isSuccess, String message})> fetchBool({
    bool Function(Map<String, dynamic> response)? onTrue,
    bool defaultValue = false,
    VoidCallback? onBefore,
    VoidCallback? onAfter,
  }) async {
    onBefore?.call();
    final tuple = await fetchResult<bool>(
      onResult: onTrue,
      defaultValue: defaultValue,
    );
    onAfter?.call();
    return (isSuccess: tuple.isSuccess, message: tuple.message);
  }

  /// 返回列表类型请求接口
  ///
  /// onList 根据字典返回数组;(默认取 response["result"] 对应的数组值)
  ///
  /// return (请求是否成功, 提示语, 数组)
  Future<({bool isSuccess, String message, List<T> result})>
      fetchList<T extends Map<String, dynamic>>({
    List<T> Function(Map<String, dynamic> response)? onList,
    List<T> defaultValue = const [],
  }) async {
    final tuple = await fetchResult<List<T>>(
      onResult: onList ?? (response) {
        final result = response["result"];
        if (result is List) {
          // dart: _GrowableList 与 List 无法 as 强转
          return List<T>.from(result);
        }
        return result as List<T>;
      },
      defaultValue: defaultValue,
    );
    return tuple;
  }

  /// 返回模型列表类型请求接口
  ///
  /// onList 根据字典返回数组;(默认取 response["result"] 对应的数组值)
  /// defaultValue 默认值空数组
  /// onModel 字典转模型
  ///
  /// return (请求是否成功, 提示语, 模型数组)
  /// 备注: isSuccess == false 且 message为空一般为断网
  Future<({bool isSuccess, String message, List<M> result})> fetchModels<M>({
    List<Map<String, dynamic>> Function(Map<String, dynamic> response)? onList,
    List<Map<String, dynamic>> defaultValue = const [],
    required M Function(Map<String, dynamic> json) onModel,
  }) async {
    final tuple = await fetchList<Map<String, dynamic>>(
      onList: onList,
      defaultValue: defaultValue,
    );
    final list = tuple.result;
    final models = list.map(onModel).toList();
    return (isSuccess: tuple.isSuccess, message: tuple.message, result: models);
  }


}