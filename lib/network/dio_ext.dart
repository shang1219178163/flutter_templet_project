import 'dart:convert';

import 'package:dio/dio.dart';

extension RequestOptionsExt on RequestOptions {
  /// 请求调试信息
  String toDescription() {
    final pathNew = path.startsWith("http") ? path : "$baseUrl$path";

    var paramsStr = "";
    try {
      if (data is FormData) {
        final formData = data as FormData;
        var list = [...formData.fields];
        list.add(MapEntry("files.keys", formData.files.map((e) => e.key).join(", ")));
        paramsStr = jsonEncode(Map.fromEntries(list));
      } else {
        paramsStr = jsonEncode(data ?? queryParameters);
      }
    } catch (e) {
      paramsStr = e.toString();
    }

    return [
      "----------------------------------",
      "requestUrl: $pathNew",
      "method: $method",
      "header: ${jsonEncode(headers)}",
      "params: $paramsStr",
    ].join("\n");
//     return """----------------------------------
// requestUrl: $pathNew
// method: $method
// header: ${jsonEncode(headers)}
// params: $paramsStr
// """;
  }
}

extension ResponseExt on Response {
  /// 请求调试信息
  String toDescription({bool hasRequestOptions = true}) {
    var jsonStr = data;
    try {
      jsonStr = jsonEncode(data);
    } catch (e) {
      jsonStr = e.toString();
    }

    final list = ["jsonStr: ", "$jsonStr"];
    if (!hasRequestOptions) {
      return list.join("\n");
    }
    return [
      "----------------------------------",
      requestOptions.toDescription(),
      ...list,
    ].join("\n");
//     return """----------------------------------
// ${requestOptions.toDescription()}
// jsonStr:
// $jsonStr
// """;
  }
}

extension DioExceptionExt on DioException {
  /// 错误调试信息
  String toDescription() {
    final map = {
      "type": type,
      "code": response?.statusCode,
      "message": message,
      "data": response?.data,
    };
    final encoder = JsonEncoder.withIndent('  '); // 使用带缩进的 JSON 编码器
    return encoder.convert(map);
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
