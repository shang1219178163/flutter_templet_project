//
//  RequestManager.dart
//  flutter_templet_project
//
//  Created by shang on 10/26/21 8:50 AM.
//  Copyright © 10/26/21 shang. All rights reserved.
//

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/network/RequestConfig.dart';
import 'package:flutter_templet_project/network/base_request_api.dart';
import 'package:flutter_templet_project/network/proxy/dio_proxy.dart';
import 'package:flutter_templet_project/service/cache_service.dart';

import 'package:get_storage/get_storage.dart';
import 'package:flutter_templet_project/network/FileManager.dart';



class RequestManager{
  static const BASE_URL = "";
  static const CODE_SUCCESS = 200;
  static const CODE_TIME_OUT = -1;

  // 私有构造器
  RequestManager._();
  // 静态变量指向自身
  static final RequestManager _instance = RequestManager._();
  // 方案1：工厂构造方法获得实例变量
  factory RequestManager() => _instance;

  // Dio _dio = Dio();
  Dio get _dio {

    final interceptorsWrapper = InterceptorsWrapper(
      onRequest: (RequestOptions options, handler) {
        // print("请求之前");
        return handler.next(options);
      },
      onResponse: (Response response, handler) {
        // print("响应之前");
        return handler.next(response);
      },
      onError: (DioError e, handler) {
        return handler.next(e);
      });

    var dio = Dio();
    var options = BaseOptions();
    options.baseUrl = RequestConfig.baseUrl;
    options.connectTimeout = Duration(milliseconds: 15000);
    options.receiveTimeout = Duration(milliseconds: 10000);
    options.responseType = ResponseType.json;
    options.headers = {
      'token': CacheService().getToken(),
      'Content-Type': 'application/json',
      'terminal': '*',
    };
    dio.options = options;

    dio.interceptors.add(interceptorsWrapper);
    DioProxy.setProxy(dio);/// 添加抓包代理
    return dio;
  }

  Future<dynamic> request(BaseRequestAPI api) async {
    if (!api.validateParams) {
      throw Exception("参数校验失败");
      /// api中弹提示;
      // return <String, dynamic>{};
    }

    if (api.shouldCache && api.jsonFromCache() != null) {
      return api.jsonFromCache();
    }

    var response = await sendRequest(
      api.requestURI,
      method: api.requestType,
      queryParams: api.requestParams,
      data: api.requestParams,
    );
    // if (api.shouldCache) {
    //   api.saveJsonOfCache(response);
    // }
    return _handleResponse(response, api: api);
  }

  Future sendRequest(
      String apiPath,
      {
        required HttpMethod method,
        dynamic queryParams,
        dynamic data,
        Options? options,
        // MultipartFile? file,
        String? filePath,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    final url = "${RequestConfig.baseUrl}/${apiPath}";
    // if (kDebugMode) {
    //   debugPrint("url: $url, ${queryParams}");
    // }
    try {
      switch (method) {
        case HttpMethod.GET:
          return await _dio.get(url, queryParameters: queryParams, options: options);
        case HttpMethod.PUT:
          return await _dio.put(url, queryParameters: queryParams, data: data, options: options);
        case HttpMethod.POST:
          return await _dio.post(url, queryParameters: queryParams, data: data, options: options);
        case HttpMethod.DELETE:
          return await _dio.delete(url, queryParameters: queryParams, data: data, options: options);
        case HttpMethod.UPLOAD:
          {
            assert(filePath?.isNotEmpty == true, "上传文件路径不能为空");
            return await _dio.post(url,
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
            return await _dio.get(url,
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
        final message = RequestMsg.statusCodeMap['${e.response?.statusCode}']
            ?? RequestMsg.networkErrorSeverMsg;
      // BrunoUti.showInfoToast(message);
    } on Exception catch (e) {
      // BrunoUti.showInfoToast(e.toString());
    }
    return null;
  }

  Future<dynamic> upload(String url, String path, {
    dynamic queryParams,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    var formData = FormData.fromMap({
      'dirName': 'MY_APP',
      'files': await MultipartFile.fromFile(path),
    });
    var response = await sendRequest(
      url,
      method: HttpMethod.POST,
      queryParams: queryParams,
        data: formData,
    );
    return _handleResponse(response);
  }

  Future<dynamic> download(String url, {
    dynamic queryParams,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    var response = await sendRequest(
      url,
      method: HttpMethod.GET,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
      ),
    );
    return _handleResponse(response);
  }

  _handleResponse(Response? response, {BaseRequestAPI? api}) {
    final data = response?.data;
    if (data == null) return {};
    // var jsonStr = jsonEncode(response.data);
    // debugPrint("jsonStr: ${jsonStr}");

    // var resMap = jsonDecode(response.data);
    var resMap = data as Map<String, dynamic>;
    if (data['code'] == 'OK') {
      if (api?.shouldCache == true && api?.canUpdateCache(data) == true) {
        api?.saveJsonOfCache(data);
      }
      return data;
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
        // BrunoUti.showInfoToast('该手机号已被绑定');
        break;
    //  微信授权时手机号是否存在
      case 'USER_LOGIN_INFO_NOT_FOUND':
      case 'WX_GET_ACCESS_TOKEN_EXCEPTION':
        break;
      default:
        // BrunoUti.showInfoToast(resMap['message']);
        break;
    }
    return resMap;
  }
}
