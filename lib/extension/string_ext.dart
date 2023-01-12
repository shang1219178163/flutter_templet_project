//
//  string_ext.dart
//  flutter_templet_project
//
//  Created by shang on 8/3/21 11:41 AM.
//  Copyright © 8/3/21 shang. All rights reserved.
//


import 'dart:convert';
import 'package:flutter_templet_project/extension/ddlog.dart';

extension StringExt on String{

  ///运算符重载
  String operator *(int value) {
    var result = '';
    for (var i = 0; i < value; i++) {
      result += this;
    }
    return result;
  }

  int get parseInt => int.parse(this);
  int? get tryParseInt => int.tryParse(this);
  double get parseDouble => double.parse(this);
  double? get tryParseDouble => double.tryParse(this);

  String get toPath => 'images/$this';

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

  /// 转为 int
  int? toInt() {
    RegExp regInt = new RegExp(r"[0-9]");
    RegExp regIntNon = new RegExp(r"[^0-9]");

    if (this.contains(regInt)) {
      final result = this.replaceAll(regIntNon, '');
      return int.tryParse(result);
    }
    return int.tryParse(this);
  }

  ///解析
  static parseResponse(dynamic data) {
    String result = "";
    if (data is Map) {
      result += json.encode(data);
    } else if (data is List) {
      result += json.encode(data);
    } else if (data is bool || data is num) {
      result += data.toString();
    } else if (data is String) {
      result += data;
    }
    return result;
  }

  /// 处理字符串中包含数字排序异常的问题
  int compareCustom(String b) {
    String a = this;

    RegExp regInt = new RegExp(r"[0-9]");
    RegExp regIntNon = new RegExp(r"[^0-9]");

    if (a.contains(regInt) && b.contains(regInt)) {
      final one = int.parse(a.replaceAll(regIntNon, ''));
      final two = int.parse(b.replaceAll(regIntNon, ''));
      return one.compareTo(two);
    }
    return a.compareTo(b);
  }
}