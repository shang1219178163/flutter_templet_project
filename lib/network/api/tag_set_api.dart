//
//  TagSetApi.dart
//  flutter_templet_project
//
//  Created by shang on 2024/5/4 17:23.
//  Copyright © 2024/5/4 shang. All rights reserved.
//

import 'package:flutter_templet_project/network/base_request_api.dart';

/// 标签 - 设置
class TagSetApi extends BaseRequestAPI {
  TagSetApi({
    required this.tagsId,
    this.userId,
    this.departmentId,
  });

  /// 标签ID
  List<String> tagsId;

  /// 对象ID
  String? userId;

  String? departmentId;

  @override
  String get requestURI {
    const url = '*/setTags';
    return url;
  }

  @override
  HttpMethod get requestType => HttpMethod.POST;

  @override
  Map<String, dynamic> get requestParams {
    final map = <String, dynamic>{};
    map["tagsId"] = tagsId;

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
    if (tagsId.isNotEmpty != true) {
      return (false, 'tagsId 不能为空');
    }
    if (userId?.isNotEmpty != true) {
      return (false, 'userId 不能为空');
    }
    if (departmentId?.isNotEmpty != true) {
      return (false, 'departmentId 不能为空');
    }
    return (true, "");
  }
}
