//
//  DebugLogInterceptor.dart
//  flutter_templet_project
//
//  Created by shang on 2026/9/1 17:22.
//  Copyright © 2026/9/1 shang. All rights reserved.
//

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_templet_project/network/dio_ext.dart';
import 'package:flutter_templet_project/util/dlog.dart';

/// 日志拦截器
class DebugLogInterceptor extends QueuedInterceptor {
  DebugLogInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (needLog(options)) {
      DLog.d(options.toDescription()); //add test by bin
    }
    handler.next(options);
  }

  @override
  Future<void> onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (needLog(response.requestOptions)) {
      DLog.d(response.toDescription(hasRequestOptions: false));
    }

    handler.next(response);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (needLog(err.requestOptions)) {
      DLog.d(err.toDescription());
    }
    handler.next(err);
  }

  /// 是否需要打印日志
  bool needLog(RequestOptions requestOptions) {
    if (!kDebugMode) {
      return false;
    }
    final items = <bool>[
      // requestOptions.extra["isLog"] == true,
      // requestOptions.path.contains("/live-home"),
      // requestOptions.path == Api.customerInfo,
    ];

    return items.any((e) => e == true);
  }
}
