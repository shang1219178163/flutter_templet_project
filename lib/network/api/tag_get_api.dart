//
//  TagGetApi.dart
//  flutter_templet_project
//
//  Created by shang on 2024/5/4 17:23.
//  Copyright © 2024/5/4 shang. All rights reserved.
//

import 'package:flutter_templet_project/network/base_request_api.dart';

/// 标签 - 获取
class TagGetApi extends BaseRequestAPI {
  TagGetApi({
    this.userId,
    this.departmentId,
  });

  /// 对象ID
  String? userId;

  String? departmentId;

  @override
  String get requestURI {
    const url = '*/tags/get';
    return url;
  }

  @override
  HttpMethod get requestType => HttpMethod.GET;

  @override
  Map<String, dynamic> get requestParams {
    final map = <String, dynamic>{};

    if (userId != null) {
      map["userId"] = userId;
    }
    if (departmentId != null) {
      map["departmentId"] = departmentId;
    }
    return map;
  }

  @override
  (bool, String) get validateParams {
    if (userId?.isNotEmpty != true) {
      return (false, 'userId 不能为空');
    }
    if (departmentId?.isNotEmpty != true) {
      return (false, 'departmentId 不能为空');
    }
    return (true, "");
  }
}
