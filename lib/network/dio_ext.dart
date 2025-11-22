import 'dart:convert';

import 'package:dio/dio.dart';

extension ResponseExt on Response {
  /// 请求调试信息
  String toDescription() {
    var jsonStr = data;
    var paramsStr = "";

    try {
      jsonStr = jsonEncode(data);
      if (requestOptions.data is FormData) {
        // DLog.d(requestOptions.data);
      } else {
        paramsStr = jsonEncode(requestOptions.data ?? requestOptions.queryParameters);
      }
    } catch (e) {
      jsonStr = e.toString();
    }

    return """----------------------------------
requestUrl: ${requestOptions.path},
method: ${requestOptions.method},
header: ${jsonEncode(requestOptions.headers)},
params: $paramsStr,
jsonStr: 
$jsonStr
""";
  }
}
