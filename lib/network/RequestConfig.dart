//
//  RequestConfig.dart
//  flutter_templet_project
//
//  Created by shang on 2024/1/6 10:58.
//  Copyright © 2024/1/6 shang. All rights reserved.
//

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:flutter_templet_project/util/dlog.dart';

/// 当前 api 环境
enum AppEnvironment {
  /// 开发环境
  dev('https://dev.*.cn'),

  /// 预测试环境
  beta('https://beta.*.cn'),

  /// 测试环境
  test('https://test.*.cn'),

  /// 预发布环境
  pre('https://pre.*.cn'),

  /// 生产环境
  prod('https://prod.*.cn');

  const AppEnvironment(
    this.origin,
  );

  /// 当前枚举对应的域名
  final String origin;

  /// name 转枚举
  static AppEnvironment fromName(String value) {
    final defaultValue = kDebugMode ? AppEnvironment.test : AppEnvironment.prod;
    final result = AppEnvironment.values.where((e) => e.name == value).firstOrNull ?? defaultValue;
    return result;
  }

  /// JSON -> Enum
  static AppEnvironment? fromJson(Map<String, dynamic> json) {
    assert(json['name'] is String, "json 必须包含 String 类型的 name");
    final name = json['name'] as String? ?? "";
    if (name.isEmpty) {
      return null;
    }
    final result = AppEnvironment.values.where((e) => e.name == name).firstOrNull;
    if ([AppEnvironment.dev].contains(result)) {
      CacheService().devOrigin = json['origin'];
    }
    return result;
  }

  /// Enum -> JSON
  Map<String, dynamic> toJson() {
    var originNew = origin;
    if ([AppEnvironment.dev].contains(this)) {
      //dev 需要修改 origin
      originNew = CacheService().devOrigin ?? origin;
    }
    return {'name': name, 'origin': originNew};
  }

  @override
  String toString() {
    return "$runtimeType: ${jsonEncode(toJson())}";
  }
}

///request config
class RequestConfig {
  static AppEnvironment current = AppEnvironment.dev;

  static void initFromEnvironment() {
    /// 从  --dart-define=app_env=beta 读取运行环境
    // ignore: do_not_use_environment -- 编译环境配置
    final env = const String.fromEnvironment("app_env");
    current = AppEnvironment.fromName(env);
    DLog.d("appEnv: $current");
  }

  /// 网络请求域名
  static String get baseUrl {
    final env = CacheService().env;
    if (env != null) {
      current = env;
      if (env == AppEnvironment.dev) {
        return CacheService().devOrigin ?? current.origin;
      }
    }
    return current.origin;
  }

  static String apiTitle = '/api/crm';
  static String ossImageUrl = 'https://yl-oss.yljt.cn';
  static const connectTimeout = 15000;
}

class RequestMsg {
  static String networkSucessMsg = "操作成功";
  static String networkErrorMsg = "网络连接失败,请稍后重试";
  static String networkErrorSeverMsg = '服务器响应超时，请稍后再试！';

  static Map<String, String> statusCodeMap = <String, String>{
    '401': '验票失败!',
    '403': '无权限访问!',
    '404': '404未找到!',
    '500': '服务器内部错误!',
    '502': '服务器内部错误!',
  };
}
