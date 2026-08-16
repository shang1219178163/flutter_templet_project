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
    final data = resp.data;
    if (data is! Map) {
      throw const FormatException('模型列表响应格式错误');
    }
    final list = data['data'];
    if (list is! List) {
      return const [];
    }
    return [
      for (final e in list)
        if (e is Map && e['id'] is String) e['id'] as String,
    ];
  }
}
