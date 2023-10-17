
import 'dart:convert';

import 'package:dio/dio.dart';

extension ResponseExt on Response{
  /// 请求调试信息
  String toDescription() {
    final jsonStr = jsonEncode(data);
    // final jsonStr = "";
    // debugPrint("jsonStr: ${jsonStr}");

    return """----------------------------------
requestUrl: ${requestOptions.path},
method: ${requestOptions.method},
header: ${jsonEncode(requestOptions.headers)},
params: ${jsonEncode(requestOptions.data ?? requestOptions.queryParameters)},
jsonStr: $jsonStr
""";
  }

}