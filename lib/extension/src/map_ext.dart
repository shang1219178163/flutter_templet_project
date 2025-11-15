//
//  MapExtension.dart
//  flutter_templet_project
//
//  Created by shang on 2022/11/24 10:43.
//  Copyright © 2022/11/24 shang. All rights reserved.
//

import 'dart:convert';

import 'package:flutter/foundation.dart';

extension MapExt on Map<String, dynamic> {
  Map get reversed => {
        for (final e in entries) e.value: e.key,
      };

  /// 相等判断
  bool equal(Map<String, dynamic> other) {
    return mapEquals(this, other);
  }

  // 拼接键值成字符串
  String toQueryString() {
    if (isEmpty) {
      return '';
    }

    // 转换 Map 的值为字符串
    var stringParams = map((key, value) {
      if (value is List) {
        return MapEntry(key, value.join(',')); // 将 List 转为逗号分隔的字符串
      }
      return MapEntry(key, value.toString());
    });

    // 转换为查询字符串
    var queryString = Uri(queryParameters: stringParams).query;
    return queryString;
  }

  /// 递归遍历
  recursion(void Function(String k, dynamic v)? cb) {
    forEach((key, value) {
      cb?.call(key, value);
      recursion(cb);
    });
  }

  /// 过滤满足条件的键值对
  Map<String, dynamic> filter(bool Function(String k, dynamic v) test) {
    final map = <String, dynamic>{};
    for (final e in entries) {
      if (test(e.key, e.value)) {
        map[e.key] = e.value;
      }
    }
    return map;
  }

  Map<String, dynamic> get asMapHash => map((k, v) => MapEntry(k, "$v,${v.hashCode}"));

  /// 带缩进转换
  String convertByIndent({String indent = '  '}) {
    final encoder = JsonEncoder.withIndent(indent); // 使用带缩进的 JSON 编码器
    final result = encoder.convert(this);
    return result;
  }

  /********************************请求结果脱壳********************************/

  /// 数据请求
  ///
  /// onResult 根据 response 返回和泛型 T 对应的值(默认值取 response["result"])
  /// defaultValue 默认值
  ///
  /// return (请求是否成功, 提示语)
  /// 备注: isSuccess == false 且 message为空一般为断网
  Future<({bool isSuccess, String message, T? result})> fetchResult<T>({
    required T Function(Map<String, dynamic> response)? onResult,
    required T? defaultValue,
  }) async {
    final response = this;
    if (response.isEmpty) {
      return (isSuccess: false, message: "", result: defaultValue); //断网
    }
    var isSuccess = response['code'] == "OK";
    var message = response["message"] as String? ?? "";
    final resultNew = onResult?.call(response) ?? response["result"] as T? ?? defaultValue;
    return (isSuccess: isSuccess, message: message, result: resultNew);
  }

  /// 返回布尔值的数据请求
  ///
  /// onTrue 根据字典返回 true 的判断条件(默认判断 response["result"] 布尔值真假)
  /// onBefore 请求前
  /// onAfter 请求后
  ///
  /// return (请求是否成功, 提示语)
  Future<({bool isSuccess, String message, bool result})> fetchBool({
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
    return (
      isSuccess: tuple.isSuccess,
      message: tuple.message,
      result: tuple.result ?? defaultValue,
    );
  }

  /// 返回列表类型请求接口
  ///
  /// onList 根据字典返回数组;(默认取 response["result"] 对应的数组值)
  ///
  /// return (请求是否成功, 提示语, 数组)
  Future<({bool isSuccess, String message, List<T> result})> fetchList<T extends Map<String, dynamic>>({
    List<T> Function(Map<String, dynamic> response)? onList,
    required List<dynamic> Function(Map<String, dynamic> response) onValue,
    List<T> defaultValue = const [],
  }) async {
    final tuple = await fetchResult<List<T>>(
      onResult: onList ??
          (response) {
            final result = response["result"];
            if (result is List) {
              // dart: _GrowableList 与 List 无法 as 强转
              return List<T>.from(result);
            }
            return result as List<T>;
          },
      defaultValue: defaultValue,
    );
    return (
      isSuccess: tuple.isSuccess,
      message: tuple.message,
      result: tuple.result ?? defaultValue,
    );
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
    required List<dynamic> Function(Map<String, dynamic> response) onValue,
    List<Map<String, dynamic>> Function(Map<String, dynamic> response)? onList,
    List<Map<String, dynamic>> defaultValue = const [],
    required M Function(Map<String, dynamic> json) onModel,
  }) async {
    final tuple = await fetchList<Map<String, dynamic>>(
      onList: onList,
      onValue: onValue,
      defaultValue: defaultValue,
    );
    final list = tuple.result;
    final models = list.map(onModel).toList();
    return (isSuccess: tuple.isSuccess, message: tuple.message, result: models);
  }
}

extension MapNullExt on Map? {
  /// 可选值是否为空
  bool get isNotEmptyNew => (this ?? {}).isNotEmpty;
}

extension MapGenericExt<K, V> on Map<K, V> {
  /// 排序
  /// value - 用来对比的值
  /// isAsc - 默认升序 true;
  /// compare 对比算法,默认 value(a).compareTo(value(b))
  Map<K, V> sortedBy(
    Comparable Function(MapEntry<K, V> v) value, {
    bool isAsc = true,
    int Function(MapEntry<K, V> a, MapEntry<K, V> b)? compare,
  }) {
    final entries = this.entries.toList();

    /// 排序
    sortCompare(a, b) {
      if (compare != null) {
        return isAsc ? compare(a, b) : compare(b, a);
      }

      final result = isAsc ? value(a).compareTo(value(b)) : value(b).compareTo(value(a));
      return result;
    }

    entries.sort(sortCompare);
    return Map<K, V>.fromEntries(entries);
  }
}
