//
//  http.dart
//  flutter_templet_project
//
//  Created by shang on 7/26/21 3:57 PM.
//  Copyright © 7/26/21 shang. All rights reserved.
//



import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';

import 'package:get_storage/get_storage.dart';

import 'fileManager.dart';


enum RequestMethod { GET, POST, PUT, DELETE, DOWNLOAD }

class RequestClient{

  BaseRequestAPI api;

  RequestClient(this.api);

  /// 网络请求
  Future request<T>({
    FormData? formData,
    Function(int sent, int total)? onProgress,
    required Function(T result) onSuccess,
    required Function(String error) onError,
  }) async {
    if (api.validateParams == false) {
      ddlog("${api.requestURI} 参数校验失败 ${api.requestParams}");
      return;
    }

    final options = BaseOptions(
      baseUrl: api.requestURI,
      headers: api.requestHeaders,
      queryParameters: api.requestParams,
      connectTimeout: Duration(milliseconds: 20000),
      receiveTimeout: Duration(milliseconds: 5000)
    );

    var _dio = Dio(api.requestBaseOptions ?? options);

    // Directory directory = await getApplicationDocumentsDirectory();
    // var cookieJar = PersistCookieJar(storage: FileStorage(directory.path + "/.cookies/"));
    // final cookieManager = CookieManager(cookieJar);
    // dio.interceptors.add(cookieManager);

    FileManager.getDocumentsDirPath().then((value) {
      var cookieJar = PersistCookieJar(storage: FileStorage("$value/.cookies/"));
      _dio.interceptors.add(CookieManager(cookieJar));
    });

    final interceptorsWrapper = InterceptorsWrapper(
    onRequest: (RequestOptions options, handler) {
      debugPrint("请求之前");
      return handler.next(options);
    },
    onResponse: (Response response, handler) {
      debugPrint("响应之前");
      return handler.next(response);
    },
    onError: (DioError e, handler) {
      print("错误之前");
      handleError(e);
      return handler.next(e);
    });

    late Response response;
    try {
      switch (api.requestType) {
        case RequestMethod.GET:
          {
            response = await _dio.get(api.requestURI, queryParameters: api.requestParams);
          }
          break;
        case RequestMethod.POST:
          {
            if (formData != null) {
              response = await _dio.post(api.requestURI,
                  data: formData,
                  onSendProgress: onProgress,
                  options: Options(contentType: "multipart/form-data"));
            } else {
              response = await _dio.post(api.requestURI, data: api.requestParams, onSendProgress: onProgress);
            }
          }
          break;
        case RequestMethod.PUT:
          {
            response = await _dio.put(api.requestURI, data: api.requestParams, onSendProgress: onProgress);
          }
          break;
        case RequestMethod.DELETE:
          {
            response = await _dio.delete(api.requestURI, data: api.requestParams);
          }
          break;
        default:
          break;
      }

      var statusCode = response.statusCode ?? -1;
      if (statusCode < 200) {
        onError("request errorCode: $statusCode ${response.statusMessage}");
        return;
      }

      // if (response.data is String) {
      //   response.data = JsonCodec().decode(response.data);
      // }
      onSuccess(response.data);
    } on DioError catch (exception) {
      onError(exception.toString());
    }
  }

  static Future get(String url, {Map<String, dynamic>? params, ProgressCallback? onReceiveProgress}) async {
    final options = BaseOptions(
        baseUrl: url,
        queryParameters: params,
        connectTimeout: const Duration(milliseconds: 20000),
        receiveTimeout: const Duration(milliseconds: 5000)
    );

    var dio = Dio(options);

    late Response response;
    try {
        response = await dio.get(url, queryParameters: params, onReceiveProgress: onReceiveProgress);
    } on DioError catch (exception) {
      print(exception.toString());
    }
    ddlog(response.requestOptions.toString());
    return response;
  }

  /// 请求下载
  Future requestDownload<T>(
      String url,
      String savePath,{
        Map<String, dynamic>? queryParameters,
        ProgressCallback? onReceiveProgress,
        required Function(T result) onSuccess,
        required Function(String error) onError}) async {
    final options = BaseOptions(
        baseUrl: url,
        queryParameters: queryParameters,
        connectTimeout: const Duration(milliseconds: 20000),
        receiveTimeout: const Duration(milliseconds: 5000));

    var _dio = Dio(options);

    late Response response;
    try {
      response = await _dio.download(url, savePath, onReceiveProgress: onReceiveProgress);
    } on DioError catch (exception) {
      onError(exception.toString());
    }

    var statusCode = response.statusCode ?? -1;
    if (statusCode < 200) {
      onError("request errorCode: $statusCode ${response.statusMessage}");
      return;
    }
    return response;
  }

  ///error统一处理
  static void handleError(DioError e) {
    var message = "";
    switch (e.type) {
      case DioErrorType.connectionTimeout:
        message = "连接超时";
        break;
      case DioErrorType.sendTimeout:
        message = "请求超时";
        break;
      case DioErrorType.receiveTimeout:
        message = "响应超时";
        break;
      case DioErrorType.badResponse:
        message = "出现异常";
        break;
      case DioErrorType.cancel:
        message = "请求取消";
        break;
      default:
        message = "未知错误";
        break;
    }
    debugPrint(message);
  }
}

///请求基类
abstract class BaseRequestAPI {
  ///url
  String get requestURI;
  /// get/post...
  RequestMethod get requestType;

  Map<String, dynamic> get requestParams => {};

  Map<String, dynamic>? get requestHeaders {
    var timestamp = DateTime.now().millisecondsSinceEpoch;
    return {
      'timestamp': '$timestamp',
      'Content-Type': 'application/json;charset=utf-8',
      'accountToken': "",
    // 'useid': id,
    // 'appVersion': '6.3.0',
    };
  }

  bool get validateParams => true;

  // bool shouldCache => false;

  bool get needLogin => true;

  bool get printLog => false;

  // BaseOptions? get requestBaseOptions => null;

  BaseOptions? get requestBaseOptions {
    final options = BaseOptions(
        baseUrl: requestURI,
        headers: requestHeaders,
        queryParameters: requestParams,
        connectTimeout: Duration(milliseconds: 20000),
        receiveTimeout: Duration(milliseconds: 5000)
    );

    return options;
  }
}


class LoginApi extends BaseRequestAPI{
  @override
  // TODO: implement requestType
  RequestMethod get requestType => throw UnimplementedError();

  @override
  // TODO: implement requestURI
  String get requestURI => throw UnimplementedError();

  // @override
  // // TODO: implement validateParams
  // bool get validateParams => super.validateParams;

}
