//
//  string_extension.dart
//  fluttertemplet
//
//  Created by shang on 8/3/21 11:41 AM.
//  Copyright © 8/3/21 shang. All rights reserved.
//


import 'dart:convert';

extension StringExt on String{
  static bool isNotEmpty(String s) {
    return s != null && s.isNotEmpty;
  }

  /// 获取匹配到的元素数组
  List<String> allMatchesByReg(RegExp regExp) {
    final reg = regExp.allMatches(this);
    final list = reg.map((e) => e.group(0)).whereType<String>().toList();
    return list;
  }
  ///首字母大写
  String toCapitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }

  /// 转我 int
  int? toInt() {
    return int.tryParse(this);
  }
  /// 转为 double
  double? toDouble() {
    return double.tryParse(this);
  }

  ///解析
  static parseResponse(dynamic data) {
    String result = "";
    if (data is Map) {
      result += json.encode(data);
    } else if (data is bool) {
      result += data.toString();
    } else if (data is String) {
      result += data;
    } else if (data is List) {
      result += json.encode(data);
    }
    return result;
  }

}