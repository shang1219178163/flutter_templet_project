//
//  MapExtension.dart
//  flutter_templet_project
//
//  Created by shang on 2022/11/24 10:43.
//  Copyright © 2022/11/24 shang. All rights reserved.
//


import 'dart:convert';

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
