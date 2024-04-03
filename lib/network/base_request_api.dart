


import 'package:flutter/foundation.dart';
import 'package:flutter_templet_project/network/RequestConfig.dart';
import 'package:flutter_templet_project/network/RequestError.dart';
import 'package:flutter_templet_project/network/RequestManager.dart';
import 'package:flutter_templet_project/vendor/easy_toast.dart';


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
class BaseRequestAPI {
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
      final isError = requestURI.endsWith("/") || requestURI.endsWith("undefined");
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

  Future<bool>? removeCache(){
    // TODO: implement jsonFromCache
    // throw UnimplementedError();
    return Future.value(false);
  }

  /// 发起请求
  Future<Map<String, dynamic>> fetch() async {
    final response = await RequestManager().request(this);
    return response;
  }

  /// 数据请求
  ///
  /// onResult 根据 response 返回和泛型 T 对应的值(默认值取 response["result"])
  ///
  /// return (请求是否成功, 提示语)
  Future<({bool isSuccess, String message, T? result})> fetchResult<T>({
    required T Function(Map<String, dynamic> response)? onResult,
  }) async {
    BaseRequestAPI api = this;
    final response = await api.fetch();
    if (response.isEmpty) {
      return (isSuccess: false, message: "", result: null);//断网
    }
    bool isSuccess = response["code"] == "OK";
    String message = response["message"] ?? "";
    final result = response["result"] as T?;
    final resultNew = onResult?.call(response) ?? result;
    return (isSuccess: isSuccess, message: message, result: resultNew);
  }

  /// 返回布尔值的数据请求
  ///
  /// onSuccess 根据字典返回 true 的判断条件(默认判断 response["result"] 布尔值真假)
  /// hasLoading 是否展示 loading
  ///
  /// return (请求是否成功, 提示语)
  Future<({bool isSuccess, String message})> fetchBool({
    bool Function(Map<String, dynamic> response)? onSuccess,
    bool hasLoading = true,
  }) async {
    final tuple = await fetchResult<bool>(
      onResult: (response) {
        final result = onSuccess?.call(response) ?? response["result"] ?? false;
        return result;
      },
    );
    return (isSuccess: tuple.isSuccess, message: tuple.message);
  }

  /// 返回列表类型请求接口
  ///
  /// onList 根据字典返回数组;(默认取 response["result"] 对应的数组值)
  ///
  /// return (请求是否成功, 提示语, 数组)
  Future<({bool isSuccess, String message, List<T> list})>
      fetchList<T extends Map<String, dynamic>>({
    List<T> Function(Map<String, dynamic> response)? onList,
  }) async {
    final tuple = await fetchResult<List<T>>(
      onResult: (response) {
        final result = onList?.call(response) ?? response["result"] as List<T>? ?? <T>[];
        return result;
      },
    );
    final list = tuple.result ?? <T>[];
    return (isSuccess: tuple.isSuccess, message: tuple.message, list: list);
  }

  // /// 返回布尔值的数据请求
  // ///
  // /// onSuccess 根据字典返回 true 的判断条件(默认判断 response["result"] 布尔值真假)
  // /// hasLoading 是否展示 loading
  // ///
  // /// return (请求是否成功, 提示语)
  // Future<({bool isSuccess, String message})> fetchBool({
  //   bool Function(Map<String, dynamic> response)? onSuccess,
  //   bool hasLoading = true,
  // }) async {
  //   BaseRequestAPI api = this;
  //   if (hasLoading) {
  //     EasyToast.showLoading("请求中");
  //   }
  //   final response = await api.fetch();
  //   if (hasLoading) {
  //     EasyToast.hideLoading();
  //   }
  //   if (response.isEmpty) {
  //     return (isSuccess: false, message: "");
  //   }
  //
  //   String message = response["message"] ?? "";
  //   final result = (response["result"] as bool?) ?? false;
  //   final resultNew = onSuccess?.call(response) ?? result;
  //
  //   bool isSuccess = response["code"] == "OK" && resultNew;
  //   return (isSuccess: isSuccess , message: message);
  // }
  //
  // /// 返回列表类型请求接口
  // ///
  // /// onList 根据字典返回数组;(默认取 response["result"] 对应的数组值)
  // ///
  // /// return (请求是否成功, 提示语, 数组)
  // Future<({bool isSuccess, String message, List<T> list})>
  //     fetchList<T extends Map<String, dynamic>>({
  //   List<T> Function(Map<String, dynamic> response)? onList,
  // }) async {
  //   BaseRequestAPI api = this;
  //   final response = await api.fetch();
  //   if (response.isEmpty) {
  //     return (isSuccess: false, message: "", list: <T>[]);
  //   }
  //   bool isSuccess = response["code"] == "OK";
  //   String message = response["message"] ?? "";
  //   final result = (response["result"] as List<T>?) ?? <T>[];
  //   final items = onList?.call(response) ?? result;
  //   return (isSuccess: isSuccess, message: message, list: items);
  // }

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
