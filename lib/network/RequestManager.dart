//
//  RequestManager.dart
//  flutter_templet_project
//
//  Created by shang on 10/26/21 8:50 AM.
//  Copyright © 10/26/21 shang. All rights reserved.
//

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/network/RequestConfig.dart';
import 'package:flutter_templet_project/network/RequestError.dart';
import 'package:flutter_templet_project/network/base_request_api.dart';
import 'package:flutter_templet_project/network/dio_ext.dart';
import 'package:flutter_templet_project/network/proxy/dio_proxy.dart';
import 'package:flutter_templet_project/util/debug_log.dart';
import 'package:flutter_templet_project/vendor/easy_toast.dart';


class RequestManager extends BaseRequestAPI{
  // static const BASE_URL = "";
  static const CODE_SUCCESS = 200;
  static const CODE_TIME_OUT = -1;

  // 私有构造器
  RequestManager._();
  // 静态变量指向自身
  static final RequestManager _instance = RequestManager._();
  // 方案1：工厂构造方法获得实例变量
  factory RequestManager() => _instance;

  String? get token => CacheService().token;


  // Dio _dio = Dio();
  Dio getDio() {
    var dio = Dio();

    var options = BaseOptions();
    options.baseUrl = RequestConfig.baseUrl;
    options.connectTimeout = connectTimeout ?? Duration(milliseconds: 30000);
    options.receiveTimeout = receiveTimeout ?? Duration(milliseconds: 30000);
    options.responseType = ResponseType.json;
    options.headers = {
      'token': token,
      'Content-Type': 'application/json',
      'Connection':"keep-alive",
      'terminal': '*',
    };
    dio.options = options;


    final interceptor = InterceptorsWrapper(
      onRequest: (RequestOptions options, handler) {
        // print("请求之前");
        return handler.next(options);
      },
      onResponse: (Response response, handler) {
        // print("响应之前");
        DebugLog.d(response.toDescription());
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        return handler.next(e);
      }
    );
    dio.interceptors.add(interceptor);
    DioProxy.setProxy(dio);/// 添加抓包代理
    return dio;
  }

  Future<Map<String, dynamic>> request(BaseRequestAPI api) async {
    if (api.needToken && token?.isNotEmpty != true) {
      // debugPrint("❌ 无效请求: ${api.requestURI}\ntoken: $token");
      return {
        "code": RequestError.cancel,
        "message": RequestError.cancel.desc,
      };
    }

    final validateURLTuple = api.validateURL;
    if (!validateURLTuple.$1) {
      return {
        "code": RequestError.urlError,
        "message": validateURLTuple.$2,
      };
    }

    final validateParamsTuple = api.validateParams;
    if (!validateParamsTuple.$1) {
      return {
        "code": RequestError.paramsError,
        "message": validateParamsTuple.$2,
      };
    }

    if (api.shouldCache) {
      final cache = api.jsonFromCache();
      if (cache != null) {
        return cache;
      }
    }

    var response = await sendRequest(
      url: api.requestURI,
      method: api.requestType,
      queryParams: api.requestParams,
      data: api.requestParams,
    );
    return _handleResponse(response: response, api: api);
  }

  Future<Response<Map<String, dynamic>>?> sendRequest({
    required String url,
    required HttpMethod method,
    dynamic queryParams,
    dynamic data,
    Options? options,
    // MultipartFile? file,
    String? filePath,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final seperator = url.startsWith("/") ? "" : "/";
    var path = "${RequestConfig.baseUrl}$seperator$url";
    if (url.startsWith("http")) {
      path = url;
    }

    try {
      switch (method) {
        case HttpMethod.GET:
          return await getDio().get<Map<String, dynamic>>(path,
              queryParameters: queryParams,
              options: options,
          );
        case HttpMethod.PUT:
          return await getDio().put<Map<String, dynamic>>(path,
              queryParameters: queryParams,
              data: data,
              options: options,
          );
        case HttpMethod.POST:
          return await getDio().post<Map<String, dynamic>>(path,
              queryParameters: queryParams,
              data: data,
              options: options,
          );
        case HttpMethod.DELETE:
          return await getDio().delete<Map<String, dynamic>>(path,
              queryParameters: queryParams,
              data: data,
              options: options,
          );
        case HttpMethod.UPLOAD:
          {
            assert(filePath?.isNotEmpty == true, "上传文件路径不能为空");
            return await getDio().post(path,
              queryParameters: queryParams,
              data: data ?? FormData.fromMap({
                'dirName': 'APP',
                'files': await MultipartFile.fromFile(filePath!),
              }),
              options: options,
              onSendProgress: onSendProgress,
              onReceiveProgress: onReceiveProgress,
            );
          }
        case HttpMethod.DOWNLOAD:
          {
            return await getDio().get(path,
              queryParameters: queryParams,
              data: FormData.fromMap({
                'dirName': 'APP',
                'files': await MultipartFile.fromFile(filePath!),
              }),
              options: options ?? Options(
                responseType: ResponseType.bytes,
                followRedirects: false,
              ),
              onReceiveProgress: onReceiveProgress,
            );
          }
          default:
          // BrunoUti.showInfoToast('请求方式错误');
      }
    } on DioError catch (e) {
        // final message = RequestMsg.statusCodeMap['${e.response?.statusCode}']
        //     ?? RequestMsg.networkErrorSeverMsg;
      // BrunoUti.showInfoToast(message);
    } on Exception catch (e) {
      // BrunoUti.showInfoToast(e.toString());
    }
    return null;
  }

  Future<Map<String, dynamic>> upload({
    required String url,
    required String filePath,
    dynamic queryParams,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    List<String> errorCodes = const [],
  }) async {
    var formData = FormData.fromMap({
      'dirName': 'MY_APP',
      'files': await MultipartFile.fromFile(filePath),
    });
    var response = await sendRequest(
      url: url,
      method: HttpMethod.POST,
      queryParams: queryParams,
      data: formData,
    );
    return _handleResponse(response: response, errorCodes: errorCodes,);
  }

  Future<Map<String, dynamic>> download({
    required String url,
    dynamic queryParams,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    List<String> errorCodes = const [],
  }) async {
    var response = await sendRequest(
      url: url,
      method: HttpMethod.GET,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
      ),
    );
    return _handleResponse(response: response, errorCodes: errorCodes,);
  }

  Map<String, dynamic> _handleResponse({
    required Response? response,
    BaseRequestAPI? api,
    List<String> errorCodes = const [],
  }) {
    final resMap = response?.data as Map<String, dynamic>? ?? {};
    if (resMap.isEmpty || resMap.keys.contains("code") != true) {
      return {
        "code": RequestError.serverError,
        "message": RequestError.serverError.desc,
      };
    }

    final codeStr = resMap['code'];
    if (codeStr == 'OK') {
      if (api?.shouldCache == true && api?.canUpdateCache(resMap) == true) {
        api?.saveJsonOfCache(resMap);
      }
      return resMap;
    }

    if (api?.errorCodes.contains(codeStr) == true
        && errorCodes.contains(codeStr)) {
      return resMap;
    }

    switch (resMap['code']) {
      case 'AUTH_TOKEN_NOT_FOUND':
      case 'AUTH_TOKENT_REQUIRED':
      case 'TOKEN_VALIDATE_ERROR':
      case 'TOKEN_REQUIRED':
      // 此方法用于账号被踢时
      // 防止多个接口报token失效，重复进入登录页面
      //   CacheService().remove(CACHE_TOKEN);
      //   if (checkValve) return;
      //   checkValve = true;
      //   Timer(const Duration(seconds: 8), () {
      //     checkValve = false;
      //   });
        // 延迟，保证获取到_context
        Future.delayed(Duration.zero, () {
          // 重新登录
          // NavigatorUtil.goLoginRemovePage(_context);
        });
        break;
      case 'LOGIN_ID_FORBID_UPDATE':
        EasyToast.showInfoToast('该手机号已被绑定');
        break;
    //  微信授权时手机号是否存在
      case 'USER_LOGIN_INFO_NOT_FOUND':
      case 'WX_GET_ACCESS_TOKEN_EXCEPTION':
        break;
      default:
        EasyToast.showInfoToast(resMap['message']);
        break;
    }
    return resMap;
  }
}
