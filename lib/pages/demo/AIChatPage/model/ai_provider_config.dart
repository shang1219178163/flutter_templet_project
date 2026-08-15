import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/model/ai_provider.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/parser/ai_chat_stream_source.dart';

/// 单个 provider 的运行态配置（独立持久化为一个 Map）
class AiProviderConfig {
  AiProviderConfig(this.provider)
      : baseUrl = provider.defaultBaseUrl,
        model = provider.defaultModel;

  final AiProvider provider;

  /// API Key；空时由调用方决定兜底（如 deepseek 用 kAiDefaultApiKey）
  String apiKey = '';

  /// chat completions 地址
  String baseUrl;

  /// 当前模型 id
  String model;

  /// 从接口拉取的模型 id 列表
  List<String> models = [];

  /// 由 chat completions 地址推导的 models 地址
  String get modelsUrl => resolveModelsUrl(baseUrl);

  Map<String, dynamic> toJson() => {
        'apiKey': apiKey,
        'baseUrl': baseUrl,
        'model': model,
        'models': models,
      };

  void applyJson(Map<String, dynamic> json) {
    final key = json['apiKey'];
    if (key is String) {
      apiKey = key;
    }
    final url = json['baseUrl'];
    if (url is String && url.isNotEmpty) {
      baseUrl = url;
    }
    final m = json['model'];
    if (m is String && m.isNotEmpty) {
      model = m;
    }
    final list = json['models'];
    if (list is List) {
      models = list.whereType<String>().toList();
    }
  }
}

/// provider → 整包配置的 CacheKey
CacheKey aiConfigCacheKey(AiProvider p) => switch (p) {
      AiProvider.deepseek => CacheKey.aiDeepseekConfig,
      AiProvider.kimi => CacheKey.aiKimiConfig,
    };
