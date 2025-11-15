//
//  string_ext.dart
//  flutter_templet_project
//
//  Created by shang on 8/3/21 11:41 AM.
//  Copyright © 8/3/21 shang. All rights reserved.
//

import 'dart:convert';
import 'package:flutter/cupertino.dart';

extension StringExt on String {
  ///运算符重载
  bool operator >(String val) {
    return compareTo(val) == 1;
  }

  ///运算符重载
  String operator *(int value) {
    var result = '';
    for (var i = 0; i < value; i++) {
      result += this;
    }
    return result;
  }

  /// 转为 int
  int? toInt() {
    return int.tryParse(this);
  }

  double? toDouble() {
    return double.tryParse(this);
  }

  /// 超过 max ...
  String toShort({
    int max = 10,
  }) {
    if (length < (max + 1)) {
      return this;
    }
    final result = "${substring(0, max)}...";
    return result;
  }

  /// 通过步长切割字符串
  ///
  /// from - 开始索引,默认 0
  /// to - 结束索引, 默认总长
  /// by - 每次分割最大长度,默认1
  List<String> splitStride({int from = 0, int? to, int by = 1}) {
    final count = to ?? length;

    var result = <String>[];
    for (var i = from; i < count; i += by) {
      var end = (i + by) < count ? (i + by) : count;
      result.add(substring(i, end));
    }

    return result;
  }

  /// 转类型 T
  T? tryJsonDecode<T>({Object? Function(Object? key, Object? value)? reviver}) {
    try {
      final result = jsonDecode(this, reviver: reviver) as T?;
      return result;
    } catch (e) {
      debugPrint("❌tryJsonDecode: $e");
      return null;
    }
  }

  /// 转 Map<String, dynamic>
  Map<String, dynamic>? decodeMap({Object? Function(Object? key, Object? value)? reviver}) {
    return tryJsonDecode<Map<String, dynamic>>(reviver: reviver);
  }

  /// 转 List<T>
  List<T>? decodeList<T>({
    Object? Function(Object? key, Object? value)? reviver,
  }) {
    return tryJsonDecode<List<T>>(reviver: reviver);
  }

  /// 本地图片路径
  String toPath([String dir = "assets/images"]) {
    return "$dir/$this";
  }

  /// 图片名称转 AssetImage
  AssetImage toAssetImage({AssetBundle? bundle, String? package}) {
    final assetName = startsWith("assets/images/") ? this : "assets/images/$this";
    return AssetImage(assetName, bundle: bundle, package: package);
  }

  /// 同 int.tryParse(this)
  int? get tryParseInt => int.tryParse(this);

  /// 同 double.tryParse(this)
  double? get tryParseDouble => double.tryParse(this);

  /// 针对 Dart 字符串优化的 64 位哈希算法 FNV-1a
  int get fastHash {
    // ignore: avoid_js_rounded_ints
    var hash = 0xcbf29ce484222325;

    var i = 0;
    while (i < length) {
      final codeUnit = codeUnitAt(i++);
      hash ^= codeUnit >> 8;
      hash *= 0x100000001b3;
      hash ^= codeUnit & 0xFF;
      hash *= 0x100000001b3;
    }

    return hash;
  }

  ///首字母大写
  String toCapitalize() {
    if (length <= 1) {
      return this;
    }
    return "${substring(0, 1).toUpperCase()}${substring(1)}";
  }

  ///驼峰命名法, ["_", "-"].contains(separator)
  String toCamlCase(String separator, {bool isUpper = true}) {
    assert(["_", "-"].contains(separator));
    if (!contains(separator)) {
      return this;
    }

    return split(separator).map((e) {
      final index = e.indexOf(this);
      return index == 0 && isUpper == false ? e : e.toCapitalize();
    }).join("");
  }

  ///反驼峰命名法
  String toUncamlCase([String separator = "_"]) {
    var reg = RegExp(r'[A-Z]');
    return split("").map((e) {
      final i = indexOf(e);
      return e.contains(reg) ? "${i == 0 ? "" : separator}${e.toLowerCase()}" : e;
    }).join("");
  }

  /// 用多个字符串分割文本
  List<String> splitSet(Set<String> set) {
    var pattern = set.map((d) => RegExp.escape(d)).join('|');
    var parts = split(RegExp(pattern, multiLine: true));
    return parts;
  }

  /// 通过链接中最后出出现的数字的后边转驼峰
  /// "/v1/api2/article/catalog/query"
  String splitByLastNumberAndPascal() {
    pascal({required List<String> parts}) {
      final buffer = StringBuffer();
      for (final p in parts) {
        buffer.write(p[0].toUpperCase() + p.substring(1));
      }
      return buffer.toString();
    }

    String path = this;
    // 去掉开头和结尾 "/"
    path = path.replaceAll(RegExp(r'^/+|/+$'), '');

    // 查找最后一个数字
    final match = RegExp(r'\d+').allMatches(path).lastOrNull;
    if (match == null) {
      final result = pascal(parts: path.split("/"));
      return result;
    }

    // 从最后一个数字开始切分
    final rest = path.substring(match.end);

    // 按 "/" 拆分剩余部分
    final segs = rest.split('/').where((e) => e.isNotEmpty).toList();
    final result = pascal(parts: segs);
    return result;
  }

  /// 填满一行
  String filledLine({
    required int maxLength,
    String fill = ' ',
    Alignment alignment = Alignment.center,
  }) {
    var text = this;

    final fillCount = maxLength - text.length;
    final left = List.filled(fillCount ~/ 2, fill);
    final right = List.filled(fillCount - left.length, fill);
    var result = left.join() + text + right.join();
    if (alignment.x < 0) {
      result = text + left.join() + right.join();
    } else if (alignment.x > 0) {
      result = left.join() + right.join() + text;
    }
    return result;
  }

  /// 字符串版本对比
  ///
  /// - separator 分隔符;
  /// - absent 长度不同时补位字符串;
  /// - caseSensitive 是否大小写敏感;
  ///
  int compareVersion(
    String version2, {
    String separator = ".",
    String absent = "0",
    bool caseSensitive = true,
  }) {
    var version1 = this;
    // 将版本号字符串分割成整数列表
    var v1 = version1.split(separator).toList();
    var v2 = version2.split(separator).toList();

    // 获取最大长度
    var maxLength = v1.length > v2.length ? v1.length : v2.length;

    // 补全较短的版本号列表
    for (var i = v1.length; i < maxLength; i++) {
      v1.add(absent);
    }
    for (var i = v2.length; i < maxLength; i++) {
      v2.add(absent);
    }

    // 比较每个部分的值
    for (var i = 0; i < maxLength; i++) {
      final a = caseSensitive ? v1[i] : v1[i].toLowerCase();
      final b = caseSensitive ? v2[i] : v2[i].toLowerCase();
      final result = a.compareTo(b);
      if (result != 0) {
        return result;
      }
    }

    // 如果所有部分都相等，则返回 0
    return 0;
  }

  /// 处理字符串中包含数字排序异常的问题
  int compareContainInt(String b) {
    var a = this;

    // var regInt = RegExp(r"[0-9]");
    // var regIntNon = RegExp(r"[^0-9]");

    final aNonIntPart = a.replaceAll(RegExp(r'\d+$'), '');
    final bNonIntPart = b.replaceAll(RegExp(r'\d+$'), '');
    if (aNonIntPart != bNonIntPart) {
      return a.compareTo(b);
    }

    final aIntPart = a.replaceAll(aNonIntPart, '');
    final bIntPart = b.replaceAll(bNonIntPart, '');

    final aInt = int.tryParse(aIntPart);
    final bInt = int.tryParse(bIntPart);
    if (aInt == null || bInt == null) {
      return 0;
    }
    return aInt.compareTo(bInt);
  }

  /// url 阿里云存储处理
  processAliOSS({
    int? cacheWidth,
    int? cacheHeight,
  }) {
    var url = this;
    var isOSS = (url.indexOf('x-oss-process=image/resize') > 0);

    var specialImg = (url.contains('.gif')) && cacheWidth != null;
    if (specialImg && !isOSS) {
      return url;
    }

    final extra = url.endsWith('?') ? "" : "?";
    url = '$url$extra&x-oss-process=image/resize,w_$cacheWidth';

    if (!url.contains(".aliyuncs.com")) {
      // 如果不是阿里OSS的图片直接返回
      return url;
    }
    return url;
  }
}

extension StringNullableExt on String? {
  /// 字符串为空
  bool get isEmpty => (this ?? "").isEmpty;

  /// 字符串不为空
  bool get isNotEmpty => (this ?? "").isNotEmpty;

  /// 转 double
  double? toDouble() {
    final result = double.tryParse(this ?? "");
    return result;
  }

  /// 转 int
  int? toInt() {
    final result = int.tryParse(this ?? "");
    return result;
  }
}
