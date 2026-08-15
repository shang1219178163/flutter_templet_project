import 'package:dio/dio.dart';

/// OpenAI 兼容非流式客户端：拉取模型列表。
///
/// 与流式 chat completions 分离，仅用于设置页刷新模型（DeepSeek / Kimi 等均可）。
class ApiClient {
  ApiClient({Dio? dio}) : dio = dio ?? Dio();

  final Dio dio;

  /// 获取模型 id 列表（未授权等会抛 [DioException]）
  Future<List<String>> fetchModels({
    required String apiKey,
    required String modelsUrl,
  }) async {
    final resp = await dio.get<dynamic>(
      modelsUrl.trim(),
      options: Options(headers: {
        if (apiKey.isNotEmpty) 'Authorization': 'Bearer $apiKey',
      }),
    );
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
