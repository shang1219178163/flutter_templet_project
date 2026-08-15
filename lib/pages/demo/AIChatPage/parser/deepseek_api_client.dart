import 'package:dio/dio.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/parser/ai_chat_stream_source.dart';

/// DeepSeek 模型列表接口地址（与 chat completions 不同 path）
const kAiDefaultModelsUrl = 'https://api.deepseek.com/models';

/// DeepSeek 非流式 API 客户端：连通性检查、拉取模型列表。
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
    final map = resp.data as Map<String, dynamic>;
    final list = (map['data'] as List?) ?? const [];
    return list.map((e) => (e as Map<String, dynamic>)['id'] as String).toList();
  }

  /// 检查 API Key 与服务连通性：能拉到模型列表即视为正常。
  ///
  /// [chatCompletionsUrl] 非空时会推导 `/models` 地址，与设置页请求地址保持一致。
  Future<({bool ok, String message})> checkConnection({
    required String apiKey,
    String? chatCompletionsUrl,
  }) async {
    if (apiKey.isEmpty) {
      return (ok: false, message: 'API Key 为空');
    }
    final modelsUrl = chatCompletionsUrl == null || chatCompletionsUrl.trim().isEmpty
        ? baseUrl
        : resolveModelsUrl(chatCompletionsUrl);
    try {
      final models = await fetchModels(apiKey: apiKey, modelsUrl: modelsUrl);
      return (ok: true, message: '连接正常，共 ${models.length} 个模型\n$modelsUrl');
    } on DioException catch (e) {
      return (ok: false, message: '${dioErrorText(e)}\n$modelsUrl');
    } catch (e) {
      return (ok: false, message: '$e\n$modelsUrl');
    }
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
