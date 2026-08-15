import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// DeepSeek 模型列表接口地址（与 chat completions 不同 path）
const kAiDefaultModelsUrl = 'https://api.deepseek.com/models';

/// OpenAI 兼容非流式客户端：拉取模型列表。
class DeepseekApiClient {
  DeepseekApiClient({
    Dio? dio,
    this.baseUrl = kAiDefaultModelsUrl,
  }) : dio = dio ?? Dio();

  final Dio dio;

  /// 默认模型列表 GET 地址（可被 [modelsUrl] 参数覆盖）
  final String baseUrl;

  /// 获取模型 id 列表（未授权等会抛 [DioException]）
  Future<List<String>> fetchModels({
    required String apiKey,
    String? modelsUrl,
  }) async {
    final url = (modelsUrl == null || modelsUrl.trim().isEmpty) ? baseUrl : modelsUrl.trim();
    final resp = await dio.get<dynamic>(
      url,
      options: Options(headers: {
        if (apiKey.isNotEmpty) 'Authorization': 'Bearer $apiKey',
      }),
    );
    // 打印原始 JSON，便于核对接口返回
    final rawJson = resp.data is String
        ? resp.data as String
        : jsonEncode(resp.data);
    debugPrint('[DeepseekApiClient] models response ($url):\n$rawJson');

    final map = resp.data as Map<String, dynamic>;
    final list = (map['data'] as List?) ?? const [];
    return list.map((e) => (e as Map<String, dynamic>)['id'] as String).toList();
  }

  /// 将 Dio 错误转成可读中文提示
  String dioErrorText(DioException e) {
    final code = e.response?.statusCode;
    return switch (code) {
      401 => 'API Key 无效（401）',
      null => '网络异常：${e.message}',
      _ => '请求失败（$code）：${e.message}',
    };
  }
}
