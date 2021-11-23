//
//  HttpManager.dart
//  fluttertemplet
//
//  Created by shang on 10/26/21 8:50 AM.
//  Copyright © 10/26/21 shang. All rights reserved.
//



import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:fluttertemplet/dartExpand/ddlog.dart';
import 'package:fluttertemplet/network/RequestClient.dart';

import 'package:get_storage/get_storage.dart';

import 'fileManager.dart';


// enum RequestMethod { GET, POST, PUT, DELETE, DOWNLOAD }

class HttpManager{
  static const BASE_URL = "...";

  static const CODE_SUCCESS = 200;
  static const CODE_TIME_OUT = -1;

  // static HttpManager _instance = HttpManager._internal(api: null);
  //
  // factory HttpManager() => _instance;
  //
  // HttpManager._internal({required BaseHttpRequestAPI api}) {
  //
  // }
  Dio _dio = Dio();

  BaseHttpRequestAPI api;

  HttpManager(this.api);

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

    _dio.options = api.requestBaseOptions ?? BaseOptions(
        baseUrl: BASE_URL,
        // baseUrl: api.requestURI.contains(BASE_URL) ? api.requestURI : BASE_URL + api.requestURI,
        headers: api.requestHeaders,
        queryParameters: api.requestParams,
        connectTimeout: 20000,
        receiveTimeout: 5000);

    // Directory directory = await getApplicationDocumentsDirectory();
    // var cookieJar = PersistCookieJar(storage: FileStorage(directory.path + "/.cookies/"));
    // final cookieManager = CookieManager(cookieJar);
    // dio.interceptors.add(cookieManager);

    FileManager.getDocumentsDirPath().then((value) {
      var cookieJar = PersistCookieJar(storage: FileStorage(value + "/.cookies/"));
      _dio.interceptors.add(CookieManager(cookieJar));
    });

    // final interceptorsWrapper = InterceptorsWrapper(
    // onRequest: (RequestOptions options, handler) {
    //   print("请求之前");
    //   return handler.next(options);
    // },
    // onResponse: (Response response, handler) {
    //   print("响应之前");
    //   return handler.next(response);
    // },
    // onError: (DioError e, handler) {
    //   print("错误之前");
    //   handleError(e);
    //   return handler.next(e);
    // });

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
      if (statusCode != CODE_SUCCESS) {
        onError("$statusCode,${response.statusMessage}");
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

}

///请求基类
abstract class BaseHttpRequestAPI {
  ///url
  String get requestURI;
  /// get/post...
  RequestMethod get requestType;

  Map<String, dynamic> get requestParams => {};

  Map<String, dynamic>? get requestHeaders {
    var timestamp = DateTime.now().millisecondsSinceEpoch;
    return {
      'timestamp': '${timestamp}',
      'Content-Type': 'application/json;charset=utf-8',
      'accountToken': '${""}',
      // 'useid': id,
      // 'appVersion': '6.3.0',
    };
  }

  bool get validateParams => true;

  bool get needLogin => true;

  bool get printLog => false;

  BaseOptions? get requestBaseOptions {
    final options = BaseOptions(
        baseUrl: requestURI,
        headers: requestHeaders,
        queryParameters: requestParams,
        connectTimeout: 20000,
        receiveTimeout: 5000);

    return options;
  }

  // parse(Map<dynamic, dynamic> data);
}


// class UserApi extends BaseHttpRequestAPI{
//   @override
//   // TODO: implement requestType
//   RequestMethod get requestType => RequestMethod.GET;
//
//   @override
//   // TODO: implement requestURI
//   String get requestURI => "";
//
//
//   String id;
//
//   UserApi({required this.id});
// }
