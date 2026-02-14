import 'dart:convert';

import 'package:dio/dio.dart';

extension RequestOptionsExt on RequestOptions {
  /// 请求调试信息
  String toDescription() {
    final pathNew = path.startsWith("http") ? path : "$baseUrl$path";

    var paramsStr = "";
    try {
      if (data is FormData) {
        // DLog.d(requestOptions.data);
      } else {
        paramsStr = jsonEncode(data ?? queryParameters);
      }
    } catch (e) {
      paramsStr = e.toString();
    }

    return """----------------------------------
requestUrl: $pathNew
method: $method
header: ${jsonEncode(headers)}
params: $paramsStr
""";
  }
}

extension ResponseExt on Response {
  /// 请求调试信息
  String toDescription() {
    var jsonStr = data;
    try {
      jsonStr = jsonEncode(data);
    } catch (e) {
      jsonStr = e.toString();
    }

    return """----------------------------------
${requestOptions.toDescription()}
jsonStr: 
$jsonStr
""";
  }
}

extension FormDataExt on FormData {
  /// 一次上传多个文件
  FormData addAll({String key = 'files', required List<(String filePath, String name)> list}) {
    final items = list.map((e) {
      return MapEntry(key, MultipartFile.fromFileSync(e.$1, filename: e.$2));
    }).toList();
    files.addAll(items);
    return this;
  }

  /// 一次上传多个文件
  FormData addAllNew({String key = 'files', required List<(String filePath, String name)> list}) {
    final items = list.map((e) {
      return MultipartFile.fromFileSync(e.$1, filename: e.$2);
    }).toList();
    return FormData.fromMap({key: items});
  }
}
