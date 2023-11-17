


import 'package:flutter_templet_project/network/RequestError.dart';

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

  bool get needToken => true;

  bool get shouldCache => false;

  bool canUpdateCache(Map<String, dynamic>? map) {
    if (map == null) {
      return false;
    }
    if (jsonFromCache() != map) {
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
// parse(Map<dynamic, dynamic> data);
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
