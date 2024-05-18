//
//  TagListApi.dart
//  flutter_templet_project
//
//  Created by shang on 2024/5/4 17:24.
//  Copyright © 2024/5/4 shang. All rights reserved.
//

import 'dart:convert';

import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:flutter_templet_project/network/base_request_api.dart';

/// 标签列表获取
class TagListApi extends BaseRequestAPI {
  TagListApi({
    this.departmentId,
  });

  /// 机构ID
  String? departmentId;

  @override
  String get requestURI {
    const url = '*/tags/list';
    return url;
  }

  @override
  HttpMethod get requestType => HttpMethod.GET;

  @override
  Map<String, dynamic> get requestParams {
    final map = <String, dynamic>{};

    map["departmentId"] = departmentId;
    return map;
  }

  @override
  (bool, String) get validateParams {
    if (departmentId?.isNotEmpty != true) {
      return (false, 'departmentId 不能为空');
    }
    return (true, "");
  }

  @override
  bool get shouldCache => false;

  String get _cacheKey => requestURI + jsonEncode(requestParams);

  @override
  Future<bool> saveJsonOfCache(Map<String, dynamic>? map) async {
    return CacheService().setMap(_cacheKey, map);
  }

  @override
  Map<String, dynamic>? jsonFromCache() {
    final result = CacheService().getMap(_cacheKey);
    return result;
  }

  @override
  Future<bool>? removeCache() {
    return CacheService().remove(_cacheKey);
  }
}
