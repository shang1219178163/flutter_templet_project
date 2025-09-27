//
//  ValidateInterceptor.dart
//  flutter_templet_project
//
//  Created by shang on 2024/4/12 09:04.
//  Copyright © 2024/4/12 shang. All rights reserved.
//

import 'package:dio/dio.dart';
import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:flutter_templet_project/network/api/token_refersh_api.dart';

/// token 刷新拦截器
class TokenInterceptor extends QueuedInterceptor {
  TokenInterceptor({required this.dio});

  final Dio dio;

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    //令牌失效
    if (err.response?.statusCode == 403) {
      try {
        final api = TokenRefreshApi();
        final res = await api.fetchResult<String>(defaultValue: "");
        var newAccessToken = res.result;
        if (newAccessToken.isEmpty) {
          super.onError(err, handler);
        }
        CacheService().token = newAccessToken;

        var requestOptions = err.requestOptions;
        requestOptions.headers["token"] = CacheService().token;
        final opts = Options(method: requestOptions.method);

        final response = await dio.request(
          requestOptions.path,
          options: opts,
          cancelToken: requestOptions.cancelToken,
          onReceiveProgress: requestOptions.onReceiveProgress,
          data: requestOptions.data,
          queryParameters: requestOptions.queryParameters,
        );
        handler.resolve(response);
      } catch (e) {
        // debugPrint("$this $e");
        handler.next(err);
      }
    }
    super.onError(err, handler);
  }
}
