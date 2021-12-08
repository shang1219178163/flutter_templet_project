//
//  string_extension.dart
//  flutter_templet_project
//
//  Created by shang on 8/3/21 11:41 AM.
//  Copyright © 8/3/21 shang. All rights reserved.
//


import 'dart:convert';

import 'package:flutter_templet_project/extensions/ddlog.dart';

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
    if (this.length == 0) return this;
    return "${this.substring(0, 1).toUpperCase()}${this.substring(1)}";
  }

  ///驼峰命名法, ["_", "-"].contains(separator)
  String camlCase(String separator, {bool isUpper = true}) {
    assert(["_", "-"].contains(separator));
    if (!this.contains(separator)) return this;
    return this.split(separator).map((e) {
      final index = e.indexOf(this);
      return index == 0 && isUpper == false ? e : e.toCapitalize();
    }).join("");
  }
  ///反驼峰命名法
  String uncamlCase(String separator) {
    RegExp reg = new RegExp(r'[A-Z]');
    if (!reg.hasMatch(separator)) {
      return this;
    }
    return this.split("").map((e) {
      final index = this.indexOf(e);
      // ddlog([e, index, reg.hasMatch(e) && index != 0]);
      return reg.hasMatch(e) && index != 0 ? "${separator}${e.toLowerCase()}" : e.toLowerCase();
    }).join("");
  }

  /// 转我 int
  int? parseInt() {
    return int.tryParse(this);
  }

  /// 转为 double
  double? parseDouble() {
    return double.tryParse(this);
  }

  ///解析
  static parseResponse(dynamic data) {
    String result = "";
    if (data is Map) {
      result += json.encode(data);
    } else if (data is bool || data is num) {
      result += data.toString();
    } else if (data is String) {
      result += data;
    } else if (data is List) {
      result += json.encode(data);
    }
    return result;
  }

}