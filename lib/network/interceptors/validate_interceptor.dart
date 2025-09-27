//
//  ValidateInterceptor.dart
//  flutter_templet_project
//
//  Created by shang on 2024/4/12 09:04.
//  Copyright © 2024/4/12 shang. All rights reserved.
//

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/network/RequestError.dart';
import 'package:flutter_templet_project/network/base_request_api.dart';

/// 校验拦截器
class ValidateInterceptor extends QueuedInterceptor {
  ValidateInterceptor({
    required this.api,
  });

  final BaseRequestAPI api;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requestURI = options.path;
    if (options.path.endsWith("/") || requestURI.endsWith("undefined")) {
      debugPrint("❌ 无效请求: $requestURI");
      handler.resolve(Response(
        requestOptions: options,
        data: {
          "code": "",
          "message": RequestError.urlError.desc,
        },
      ));
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data is! Map<String, dynamic> ||
        (response.data as Map<String, dynamic>).isEmpty) {
      return handler.reject(DioException.badResponse(
        statusCode: response.statusCode ?? 500,
        requestOptions: response.requestOptions,
        response: response,
      ));
    }
    handler.next(response);
  }
}

/// 校验异常
class ValidateException extends DioException {
  ValidateException(RequestOptions options, {required this.err})
      : super(requestOptions: options);

  RequestError err;

  @override
  String toString() {
    return err.desc;
  }
}
