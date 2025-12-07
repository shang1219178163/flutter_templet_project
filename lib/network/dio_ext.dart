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
