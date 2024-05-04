import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_templet_project/network/RequestConfig.dart';
import 'package:flutter_templet_project/network/RequestError.dart';
import 'package:flutter_templet_project/network/RequestManager.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';

enum HttpMethod {
  GET,
  PUT,
  POST,
  PATCH,
  DELETE,
  UPLOAD,
  DOWNLOAD,
}

/// 请求基类
abstract class BaseRequestAPI {
  ///url
  String get requestURI {
    // TODO: implement requestURI
    throw UnimplementedError();
  }

  /// get/post...
  HttpMethod get requestType => HttpMethod.GET;

  Map<String, dynamic> get requestParams => {};

  Map<String, dynamic>? get requestHeaders {
    var timestamp = DateTime.now().millisecondsSinceEpoch;
    return {
      'Content-Type': 'application/json;charset=utf-8',
      'timestamp': '$timestamp',
      'token': "",
    };
  }

  /// url 验证
  (bool, String) get validateURL {
    if (requestType == HttpMethod.GET) {
      final isError =
          requestURI.endsWith("/") || requestURI.endsWith("undefined");
      if (isError) {
        return (false, RequestError.urlError.desc);
      }
    }
    return (true, "");
  }

  /// 传参验证
  (bool, String) get validateParams => (true, "");

  /// 毫秒
  Duration? get connectTimeout => null;

  /// 毫秒
  Duration? get receiveTimeout => null;

  bool get needToken => true;

  bool get shouldCache => false;

  /// 接口调用地方处理异常code
  List<String> get errorCodes => [];

  bool canUpdateCache(Map<String, dynamic>? map) {
    if (map == null) {
      return false;
    }

    if (!mapEquals(jsonFromCache(), map)) {
      return true;
    }
    return false;
  }

  bool saveJsonOfCache(Map<String, dynamic>? map) {
    // TODO: implement saveJsonOfCache
    // throw UnimplementedError();
    return false;
  }

  Map<String, dynamic>? jsonFromCache() {
    // TODO: implement jsonFromCache
    // throw UnimplementedError();
    return null;
  }

  Future<bool>? removeCache() {
    // TODO: implement jsonFromCache
    // throw UnimplementedError();
    return Future.value(false);
  }

  CancelToken get cancelToken => CancelToken();

  /// 取消请求
  void fetchCancel() {
    cancelToken.cancel('fetchCancel');
  }

  /// 发起请求
  Future<Map<String, dynamic>> fetch() async {
    final response = await RequestManager().request(this);
    return response;
  }

  /// 数据请求
  ///
  /// onResult 根据 response 返回和泛型 T 对应的值(默认值取 response["result"])
  /// defaultValue 默认值
  ///
  /// return (请求是否成功, 提示语)
  /// 备注: isSuccess == false 且 message为空一般为断网
  Future<({bool isSuccess, String message, T result})> fetchResult<T>({
    T Function(Map<String, dynamic> response)? onResult,
    required T defaultValue,
  }) async {
    BaseRequestAPI api = this;
    final response = await api.fetch();
    if (response.isEmpty) {
      return (isSuccess: false, message: "", result: defaultValue); //断网
    }
    bool isSuccess = response["code"] == "OK";
    String message = response["message"] ?? "";
    final result = response["result"] as T? ?? defaultValue;
    final resultNew = onResult?.call(response) ?? result ?? defaultValue;
    return (isSuccess: isSuccess, message: message, result: resultNew);
  }

  /// 返回布尔值的数据请求
  ///
  /// onTrue 根据字典返回 true 的判断条件(默认判断 response["result"] 布尔值真假)
  /// defaultValue 默认值 false,
  /// hasLoading 是否展示 loading
  ///
  /// return (请求是否成功, 提示语, response["result"]对应的值,为空返回默认值)
  /// 备注: isSuccess == false 且 message为空一般为断网
  Future<({bool isSuccess, String message, bool result})> fetchBool({
    bool Function(Map<String, dynamic> response)? onTrue,
    bool defaultValue = false,
    bool hasLoading = true,
  }) async {
    if (hasLoading) {
      ToastUtil.loading("请求中");
    }
    final tuple = await fetchResult<bool>(
      onResult: onTrue,
      defaultValue: defaultValue,
    );
    if (hasLoading) {
      ToastUtil.hideLoading();
    }
    return tuple;
  }

  /// 返回列表类型请求接口(T 只能是基础类型,不能是模型)
  ///
  /// onList 根据字典返回数组;(默认取 response["result"] 对应的数组值)
  /// defaultValue 默认值空数组
  ///
  /// return (请求是否成功, 提示语, 数组)
  /// 备注: isSuccess == false 且 message为空一般为断网
  Future<({bool isSuccess, String message, List<T> result})>
      fetchList<T extends Map<String, dynamic>>({
    List<T> Function(Map<String, dynamic> response)? onList,
    required List<dynamic> Function(Map<String, dynamic> response) onValue,
    List<T> defaultValue = const [],
  }) async {
    final tuple = await fetchResult<List<T>>(
      onResult: onList ??
          (response) {
            final result = onValue(response);
            return List<T>.from(result);
          },
      defaultValue: defaultValue,
    );
    return tuple;
  }

  /// 返回模型列表类型请求接口
  ///
  /// onList 根据字典返回数组;(默认取 response["result"] 对应的数组值)
  /// defaultValue 默认值空数组
  /// onModel 字典转模型
  ///
  /// return (请求是否成功, 提示语, 模型数组)
  /// 备注: isSuccess == false 且 message为空一般为断网
  Future<({bool isSuccess, String message, List<M> result})> fetchModels<M>({
    required List<Map<String, dynamic>> Function(Map<String, dynamic> response)
        onValue,
    List<Map<String, dynamic>> Function(Map<String, dynamic> response)? onList,
    List<Map<String, dynamic>> defaultValue = const [],
    required M Function(Map<String, dynamic> json) onModel,
  }) async {
    final tuple = await fetchList<Map<String, dynamic>>(
      onList: onList,
      onValue: onValue,
      defaultValue: defaultValue,
    );
    final list = tuple.result;
    final models = list.map(onModel).toList();
    return (isSuccess: tuple.isSuccess, message: tuple.message, result: models);
  }
}

/// 请求分页基类
class BasePageRequestApi extends BaseRequestAPI {
  BasePageRequestApi({
    this.pageNo = 1,
    this.pageSize = 30,
  });

  int pageNo;

  int pageSize;
}
