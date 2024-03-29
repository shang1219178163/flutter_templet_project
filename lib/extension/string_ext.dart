//
//  string_ext.dart
//  flutter_templet_project
//
//  Created by shang on 8/3/21 11:41 AM.
//  Copyright © 8/3/21 shang. All rights reserved.
//


import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';

typedef TransformCallback<E> = E Function(E e);

extension StringExt on String{

  static bool isEmpty(String? val) {
    return val == null || val.isEmpty;
  }

  static bool isNotEmpty(String? val) {
    return val != null && val.isNotEmpty;
  }

  ///运算符重载
  bool operator > (String val) {
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

  /// 移除左边
  String trimLeftChar(String char) {
    var result = this;
    if (result.startsWith(char)) {
      result = result.substring(char.length);
    }
    return result;
  }

  /// 移除右边
  String trimRightChar(String char) {
    var result = this;
    if (result.endsWith(char)) {
      result = result.substring(0, result.length - char.length);
    }
    return result;
  }

  /// 移除两端
  String trimChar(String char) {
    var result = trimLeftChar(char).trimRightChar(char);
    return result;
  }

  /// 添加前缀后缀
  String padding({String prefix = "", String suffix = "",}) {
    var result = this;
    if (!result.startsWith(prefix)) {
      result = "$prefix$result";
    }
    if (!result.endsWith(suffix)) {
      result = "$result$suffix";
    }
    return result;
  }

  /// 转 Map<String, dynamic>
  Map<String, dynamic>? decodeMap({Object? Function(Object? key, Object? value)? reviver}) {
    if (this.isEmpty) {
      return null;
    }

    try {
      final result = jsonDecode(this, reviver: reviver) as Map<String, dynamic>?;
      return result;
    } catch (exception) {
      debugPrint("decodeMap: exception: $exception");
      return null;
    }
  }

  /// 转 List<T>
  List<T>? decodeList<T>({Object? Function(Object? key, Object? value)? reviver}) {
    if (this.isEmpty) {
      return null;
    }

    try {
      final result = jsonDecode(this, reviver: reviver) as List<T>?;
      return result;
    } catch (exception) {
      debugPrint("decodeList: exception: $exception");
      return null;
    }
  }

  /// 本地图片路径
  String toPath([String dir = "assets/images",]) {
    return "$dir/$this";
  }

  /// 图片名称转 AssetImage
  AssetImage toAssetImage({AssetBundle? bundle, String? package,}) {
    final assetName = startsWith("assets/images/") ? this : "assets/images/$this";
    return AssetImage(assetName,
        bundle: bundle,
        package: package
    );
  }

  /// 同 int.parse(this)
  int get parseInt => int.parse(this);
  /// 同 int.tryParse(this)
  int? get tryParseInt => int.tryParse(this);
  /// 同 double.parse(this)
  double get parseDouble => double.parse(this);
  /// 同 double.tryParse(this)
  double? get tryParseDouble => double.tryParse(this);

  /// 针对 Dart 字符串优化的 64 位哈希算法 FNV-1a
  int get fastHash {
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

  /// 获取匹配到的元素数组
  List<String> allMatchesByReg(RegExp regExp) {
    final reg = regExp.allMatches(this);
    final list = reg.map((e) => e.group(0)).whereType<String>().toList();
    return list;
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

  /// 转为 int
  int? toInt() {
    final regInt = RegExp(r"[0-9]");
    final regIntNon = RegExp(r"[^0-9]");

    if (contains(regInt)) {
      final result = replaceAll(regIntNon, '');
      return int.tryParse(result);
    }
    return int.tryParse(this);
  }

  /// 用多个字符串分割文本
  List<String> splitBySet(Set<String> set) {
    var pattern = set.map((d) => RegExp.escape(d)).join('|');
    var parts = split(RegExp(pattern, multiLine: true));
    return parts;
  }

  ///解析
  static parseResponse(dynamic data) {
    try {
      var result = "";
      if (data is Map) {
        result += jsonEncode(data);
      }
      else if (data is List) {
        result += jsonEncode(data);
      }
      else if (data is bool || data is num) {
        result += data.toString();
      }
      else if (data is String) {
        result += data;
      }
      return result;
    } catch (e) {
      debugPrint("parseResponse $e");
    }
  }

  /// 处理字符串中包含数字排序异常的问题
  int compareCustom(String b) {
    var a = this;

    var regInt = RegExp(r"[0-9]");
    var regIntNon = RegExp(r"[^0-9]");

    if (a.contains(regInt) && b.contains(regInt)) {
      final one = int.parse(a.replaceAll(regIntNon, ''));
      final two = int.parse(b.replaceAll(regIntNon, ''));
      return one.compareTo(two);
    }
    return a.compareTo(b);
  }

  /// 用字符切分字符串
  seperatorByChars({
    TransformCallback<String>? cb,
    String source = '[A-Z]',
    bool multiLine = false,
    bool caseSensitive = true,
    bool unicode = false,
    bool dotAll = false
  }) {
    final reg = RegExp(source,
      multiLine: multiLine,
      caseSensitive: caseSensitive,
      unicode: unicode,
      dotAll: dotAll,
    );

    final matchs = reg.allMatches(this);
    // for (final Match m in matchs) {
    //   String match = m[0]!;
    //   print(match);
    // }
    final seperators = matchs.map((e) => e[0] ?? "").where((e) => e.isNotEmpty).toList();

    var result = this;
    seperators.forEach((e) => result = result.replaceAll(e, cb?.call(e) ?? e));
    return result;
  }

  /// 获取 pattern 的大小写变种(模糊化)
  String? blurred({
    bool multiLine = false,
    bool unicode = false,
    bool dotAll = false,
  }) {
    final regexp = RegExp(this,
      caseSensitive: false,
      multiLine: multiLine,
      unicode: unicode,
      dotAll: dotAll
    );
    final match = regexp.firstMatch(this);
    final matchedText = match?.group(0);
    return matchedText;
  }

  /// 以 pattern 分割字符串为3元素数组
  List<String> seperator(String pattern) {
    final matchedText = pattern.blurred();
    if (matchedText == null || !contains(matchedText)) {
      return [this];
    }

    var index = indexOf(matchedText);
    var endIndex = index + matchedText.length;

    final leftStr = substring(0, index);
    final sub = substring(index, endIndex);
    final rightStr = substring(endIndex);
    return [leftStr, sub, rightStr];
  }

  /// 获取掺杂高亮的富文本
  InlineSpan formSpan(String pattern, {TextStyle? nomalStyle, TextStyle? highlightStyle}) {
    var strs = seperator(pattern);
    if (strs.length <= 1) {
      final items = strs.map((e) => TextSpan(
        text: e,
        style: highlightStyle
      )).toList();
      return TextSpan(children: items);
    }

    var spans = strs.map((e) => TextSpan(
      text: e,
      style: strs.indexOf(e) == 1 ? highlightStyle : nomalStyle
    )).toList();
    return TextSpan(children: spans);
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

    if (!url.contains(".aliyuncs.com")){ // 如果不是阿里OSS的图片直接返回
      return url;
    }
    return url;
  }

}

// extension StringCryptExt on String{
//   toMd5() {
//     Uint8List content = const Utf8Encoder().convert(this);
//     Digest digest = md5.convert(content);
//     return digest.toString();
//   }
// }