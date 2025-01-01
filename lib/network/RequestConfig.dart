//
//  RequestConfig.dart
//  flutter_templet_project
//
//  Created by shang on 2024/1/6 10:58.
//  Copyright © 2024/1/6 shang. All rights reserved.
//

import 'package:flutter/foundation.dart';
import 'package:flutter_templet_project/cache/cache_service.dart';

/// 当前 api 环境
enum AppEnvironment {
  /// 开发环境
  dev('https://*.cn'),

  /// 预测试环境
  beta('https://*.cn'),

  /// 测试环境
  test('https://*.cn'),

  /// 预发布环境
  pre('https://*.cn'),

  /// 生产环境
  prod('https://*.cn');

  const AppEnvironment(
    this.origin,
  );

  /// 当前枚举对应的域名
  final String origin;

  /// 字符串转类型
  static AppEnvironment? fromString(String? val) {
    if (val == null || !val.contains(",")) {
      return null;
    }

    final list = val.split(",");
    if (list.length != 2) {
      return null;
    }

    final first = list[0];
    final isEnumType = AppEnvironment.values.map((e) => e.name).contains(first);
    if (!isEnumType) {
      return null;
    }
    return AppEnvironment.values.firstWhere((e) => e.name == first);
  }

  /// name 转枚举
  static AppEnvironment fromName(String name) {
    for (final e in AppEnvironment.values) {
      if (e.name == name) {
        return e;
      }
    }
    return kDebugMode ? AppEnvironment.test : AppEnvironment.prod;
  }

  @override
  String toString() {
    if (this == AppEnvironment.dev) {
      return "$name,${CacheService().devOrigin ?? origin}";
    }
    return "$name,$origin";
  }
}

///request config
class RequestConfig {
  static AppEnvironment current = AppEnvironment.dev;

  static void initFromEnvironment() {
    /// 从  --dart-define=app_env=beta 读取运行环境
    final env = const String.fromEnvironment("app_env");
    current = AppEnvironment.fromName(env);
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
