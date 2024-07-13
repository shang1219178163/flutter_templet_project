//
//  RequestManager.dart
//  flutter_templet_project
//
//  Created by shang on 10/26/21 8:50 AM.
//  Copyright © 10/26/21 shang. All rights reserved.
//

//Cronet https://juejin.cn/post/7358647510518497307

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/network/RequestConfig.dart';
import 'package:flutter_templet_project/network/RequestError.dart';
import 'package:flutter_templet_project/network/api/token_refersh_api.dart';
import 'package:flutter_templet_project/network/base_request_api.dart';
import 'package:flutter_templet_project/network/dio_ext.dart';
import 'package:flutter_templet_project/network/interceptors/token_interceptor.dart';
import 'package:flutter_templet_project/network/interceptors/validate_interceptor.dart';
import 'package:flutter_templet_project/network/proxy/dio_proxy.dart';
import 'package:flutter_templet_project/routes/APPRouter.dart';
import 'package:flutter_templet_project/util/tool_util.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';
import 'package:get/get.dart' as get_navigation;

class RequestManager extends BaseRequestAPI {
  // 私有构造器
  RequestManager._();

  static final RequestManager _instance = RequestManager._();

  // 方案1：工厂构造方法获得实例变量
  factory RequestManager() => _instance;

  String? get token => CacheService().token;

  // static const BASE_URL = "";
  static const CODE_SUCCESS = 200;
  static const CODE_TIME_OUT = -1;

  // final cacheStore = MemCacheStore(maxSize: 10485760, maxEntrySize: 1048576);
  // late final cacheOptions = CacheOptions(
  //   store: cacheStore,
  //   hitCacheOnErrorExcept: [], // for offline behaviour
  // );

  late final cacheInterceptor = DioCacheInterceptor(
    options: CacheOptions(
      store: MemCacheStore(maxSize: 10485760, maxEntrySize: 1048576),
      hitCacheOnErrorExcept: [], // for offline behaviour
    ),
  );

  // Dio _dio = Dio();
  Dio getDio(BaseRequestAPI? api) {
    var dio = Dio();
    // dio.httpClientAdapter = NativeAdapter();//支持 Cronet

    var options = BaseOptions();
    options.baseUrl = RequestConfig.baseUrl;
    options.connectTimeout = connectTimeout ?? Duration(milliseconds: 30000);
    options.receiveTimeout = receiveTimeout ?? Duration(milliseconds: 30000);
    options.responseType = ResponseType.json;
    options.headers = {
      'token': token,
      'Content-Type': 'application/json',
      'Connection': "keep-alive",
      'terminal': '*',
    };
    dio.options = options;

    final interceptor = QueuedInterceptorsWrapper(
      onRequest: (RequestOptions options, handler) {
        // print("请求之前");
        return handler.next(options);
      },
      onResponse: (Response response, handler) {
        // print("响应之前");
        ddlog(response.toDescription());
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        return handler.next(e);
      },
    );
    if (api != null) {
      dio.interceptors.add(ValidateInterceptor(api: api));
    }
    dio.interceptors.add(TokenInterceptor(dio: dio));
    dio.interceptors.add(interceptor);
    dio.interceptors.add(cacheInterceptor);

    DioProxy.setProxy(dio);

    /// 添加抓包代理
    return dio;
  }

  Future<Map<String, dynamic>> request(BaseRequestAPI api) async {
    api.route = get_navigation.Get.currentRoute; //进入当前页面
    if (api.needToken && token?.isNotEmpty != true) {
      // debugPrint("❌ 无效请求: ${api.requestURI}\ntoken: $token");
      return {
        "code": RequestError.cancel,
        "message": RequestError.cancel.desc,
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
      api: api,
    );
    return _handleResponse(response: response, api: api);
  }

  Future<Response<Map<String, dynamic>>?>
      sendRequest<T extends Map<String, dynamic>>({
    required String url,
    required HttpMethod method,
    dynamic queryParams,
    dynamic data,
    Options? options,
    // MultipartFile? file,
    String? filePath,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    BaseRequestAPI? api,
  }) async {
    final seperator = url.startsWith("/") ? "" : "/";
    var path = "${RequestConfig.baseUrl}$seperator$url";
    if (url.startsWith("http")) {
      path = url;
    }

    try {
      switch (method) {
        case HttpMethod.GET:
          return await getDio(api).get<T>(
            path,
            queryParameters: queryParams,
            options: options,
            cancelToken: api?.cancelToken,
          );
        case HttpMethod.PUT:
          return await getDio(api).put<T>(
            path,
            queryParameters: queryParams,
            data: data,
            options: options,
            cancelToken: api?.cancelToken,
          );
        case HttpMethod.POST:
          return await getDio(api).post<T>(
            path,
            queryParameters: queryParams,
            data: data,
            options: options,
            cancelToken: api?.cancelToken,
          );
        case HttpMethod.DELETE:
          return await getDio(api).delete<T>(
            path,
            queryParameters: queryParams,
            data: data,
            options: options,
            cancelToken: api?.cancelToken,
          );
        case HttpMethod.UPLOAD:
          {
            assert(filePath?.isNotEmpty == true, "上传文件路径不能为空");
            return await getDio(api).post(
              path,
              queryParameters: queryParams,
              data: data ??
                  FormData.fromMap({
                    'dirName': 'APP',
                    'files': await MultipartFile.fromFile(filePath!),
                  }),
              options: options,
              onSendProgress: onSendProgress,
              onReceiveProgress: onReceiveProgress,
              cancelToken: api?.cancelToken,
            );
          }
        case HttpMethod.DOWNLOAD:
          {
            assert(filePath?.isNotEmpty == true, "下载文件路径不能为空");
            return await getDio(api).get(
              path,
              queryParameters: queryParams,
              data: FormData.fromMap({
                'dirName': 'APP',
                'files': await MultipartFile.fromFile(filePath!),
              }),
              options: options ??
                  Options(
                    responseType: ResponseType.bytes,
                    followRedirects: false,
                  ),
              onReceiveProgress: onReceiveProgress,
              cancelToken: api?.cancelToken,
            );
          }
        default:
        // BrunoUti.showInfoToast('请求方式错误');
      }
    } on DioException catch (e) {
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
    BaseRequestAPI? api,
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
      api: api,
    );
    return _handleResponse(
      response: response,
      errorCodes: errorCodes,
    );
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
    return _handleResponse(
      response: response,
      errorCodes: errorCodes,
    );
  }

  Map<String, dynamic> _handleResponse({
    required Response? response,
    BaseRequestAPI? api,
    List<String> errorCodes = const [],
  }) {
    if (api?.route != get_navigation.Get.currentRoute) {
      //退出当前页面
      return {
        "code": RequestError.cancel,
        "message": "",
      };
    }
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

    if (api?.errorCodes.contains(codeStr) == true ||
        errorCodes.contains(codeStr)) {
      return resMap;
    }

    if ([
      'AUTH_TOKEN_NOT_FOUND',
      'AUTH_TOKENT_REQUIRED',
      'TOKEN_VALIDATE_ERROR',
      'TOKEN_REQUIRED',
    ].contains(codeStr)) {
      // 此方法用于账号被踢时,token失效
      ToolUtil.toLoginPage();
    } else {
      final hide = ![
        RequestError.urlError.desc,
      ].contains(resMap['message']);
      if (hide) {
        ToastUtil.show(resMap['message']); //TODO: 是否还需要次全局Toast?
      }
    }
    return resMap;
  }
}
