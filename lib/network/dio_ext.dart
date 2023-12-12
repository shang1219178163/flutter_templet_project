
import 'dart:convert';

import 'package:dio/dio.dart';

extension ResponseExt on Response{
  /// 请求调试信息
  String toDescription() {
    var jsonStr = data;
    try {
      jsonStr = jsonEncode(data);
    } catch (e) {
      jsonStr = e.toString();
    }

    return """----------------------------------
requestUrl: ${requestOptions.path},
method: ${requestOptions.method},
header: ${jsonEncode(requestOptions.headers)},
params: ${jsonEncode(requestOptions.data ?? requestOptions.queryParameters)},
jsonStr: 
$jsonStr
""";
  }

}