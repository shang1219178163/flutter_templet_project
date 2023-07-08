


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

  bool get validateParams => true;

  bool get needLogin => true;

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



// ///请求基类
// abstract class BaseHttpRequestAPI {
//   ///url
//   String get requestURI;
//   /// get/post...
//   HttpMethod get requestType;
//
//   Map<String, dynamic> get requestParams => {};
//
//   Map<String, dynamic>? get requestHeaders {
//     var timestamp = DateTime.now().millisecondsSinceEpoch;
//     return {
//       'Content-Type': 'application/json;charset=utf-8',
//       'timestamp': '$timestamp',
//       'accountToken': "",
//       // 'useid': id,
//       // 'appVersion': '6.3.0',
//     };
//   }
//
//   bool get validateParams => true;
//
//   bool get needLogin => true;
//
//   bool get printLog => false;
//
//   BaseOptions? get requestBaseOptions {
//     final options = BaseOptions(
//         baseUrl: requestURI,
//         headers: requestHeaders,
//         queryParameters: requestParams,
//         connectTimeout: const Duration(milliseconds: 20000),
//         receiveTimeout: const Duration(milliseconds: 5000)
//     );
//
//     return options;
//   }
//
//   // parse(Map<dynamic, dynamic> data);
// }