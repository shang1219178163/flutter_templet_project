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
  String operator *(int value) {
    var result = '';
    for (var i = 0; i < value; i++) {
      result += this;
    }
    return result;
  }

  /// 本地图片路径
  String toPng() {
    if (this.endsWith(".png")) {
      return "assets/images/$this";
    }
    return "assets/images/$this.png";
  }
  /// 本地图片路径
  String toJpg() {
    if (this.endsWith(".jpg")) {
      return "assets/images/$this";
    }
    return "assets/images/$this.jpg";
  }
  /// 本地图片路径
  String toSvg() {
    if (this.endsWith(".svg")) {
      return "assets/images/$this";
    }
    return "assets/images/$this.svg";
  }

  /// 图片名称转 AssetImage(带类型)
  AssetImage toAssetImage({
    AssetBundle? bundle,
    String? package,
  }) => AssetImage("assets/images/$this",
    bundle: bundle,
    package: package
  );

  /// 返回 png 图片的 AssetImage
  AssetImage toPngAssetImage({
    String? package,
    AssetBundle? bundle,
  }) => toPng().toAssetImage(package: package, bundle: bundle);

  /// 返回 jpg 图片的 AssetImage
  AssetImage toJpgAssetImage({
    String? package,
    AssetBundle? bundle,
  }) => toJpg().toAssetImage(package: package, bundle: bundle);

  /// 返回 svg 图片的 AssetImage
  AssetImage toSvgAssetImage({
    String? package,
    AssetBundle? bundle,
  }) => toSvg().toAssetImage(package: package, bundle: bundle);

  /// 同 int.parse(this)
  int get parseInt => int.parse(this);
  /// 同 int.tryParse(this)
  int? get tryParseInt => int.tryParse(this);
  /// 同 double.parse(this)
  double get parseDouble => double.parse(this);
  /// 同 double.tryParse(this)
  double? get tryParseDouble => double.tryParse(this);

  /// 获取匹配到的元素数组
  List<String> allMatchesByReg(RegExp regExp) {
    final reg = regExp.allMatches(this);
    final list = reg.map((e) => e.group(0)).whereType<String>().toList();
    return list;
  }

  ///首字母大写
  String toCapitalize() {
    if (length == 0) return this;
    return "${substring(0, 1).toUpperCase()}${substring(1)}";
  }

  ///驼峰命名法, ["_", "-"].contains(separator)
  String camlCase(String separator, {bool isUpper = true}) {
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
  String uncamlCase(String separator) {
    var reg = RegExp(r'[A-Z]');
    if (!reg.hasMatch(separator)) {
      return this;
    }
    return split("").map((e) {
      final index = indexOf(e);
      // ddlog([e, index, reg.hasMatch(e) && index != 0]);
      return reg.hasMatch(e) && index != 0 ? "$separator${e.toLowerCase()}" : e.toLowerCase();
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

  ///解析
  static parseResponse(dynamic data) {
    var result = "";
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