import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/enum/ai_provider.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/parser/ai_env_service.dart';

/// 单个 provider 的运行态配置（整包持久化为一个 Map）
///
/// **不落盘 apiKey**：密钥只来自 `.env` / dart-define，避免 SharedPreferences 冻住旧 Key。
class AiProviderConfig {
  AiProviderConfig(this.provider)
      : baseUrl = provider.defaultBaseUrl,
        model = provider.defaultModel;

  final AiProvider provider;

  /// API Key；仅内存态，由 [resolveApiKey] 从环境注入
  String apiKey = '';

  /// chat completions 地址
  String baseUrl;

  /// 当前模型 id
  String model;

  /// 从接口拉取的模型 id 列表
  List<String> models = [];

  /// 由 chat completions 地址推导的 models 地址
  String get modelsUrl => resolveModelsUrl(baseUrl, fallbackBaseUrl: provider.defaultBaseUrl);

  /// 由 chat completions URL 推导 `/models` 地址
  static String resolveModelsUrl(
    String chatCompletionsUrl, {
    String? fallbackBaseUrl,
  }) {
    final t = chatCompletionsUrl.trim();
    if (t.isEmpty) {
      return resolveModelsUrl(fallbackBaseUrl ?? AiProvider.deepseek.defaultBaseUrl);
    }
    if (t.contains('/chat/completions')) {
      return t.replaceFirst('/chat/completions', '/models');
    }
    if (t.endsWith('/models')) {
      return t;
    }
    final base = t.endsWith('/') ? t.substring(0, t.length - 1) : t;
    return '$base/models';
  }

  /// 持久化字段（故意不含 apiKey）
  Map<String, dynamic> toJson() => {
        'baseUrl': baseUrl,
        'model': model,
        'models': models,
      };

  /// 从缓存 Map 回填字段（忽略历史 apiKey；空串 / 缺省不覆盖默认）
  void applyJson(Map<String, dynamic> json) {
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

  /// 空值 / 过期域名与模型回退到默认；有改动返回 true
  bool normalize() {
    var changed = false;
    if (baseUrl.isEmpty) {
      baseUrl = provider.defaultBaseUrl;
      changed = true;
    }
    if (model.isEmpty) {
      model = provider.defaultModel;
      changed = true;
    }
    // Kimi 旧域名 / 旧默认模型迁移
    if (provider == AiProvider.kimi) {
      if (baseUrl.contains('api.moonshot.ai')) {
        baseUrl = provider.defaultBaseUrl;
        changed = true;
      }
      if (model == 'moonshot-v1-8k') {
        model = provider.defaultModel;
        changed = true;
      }
    }
    return changed;
  }

  /// 始终从 .env / dart-define 解析（不读缓存，便于改 Key 后生效）
  void resolveApiKey() {
    apiKey = AiEnvService.keyFor(provider.name) ??
        (provider == AiProvider.deepseek ? kAiDefaultApiKey : '');
  }
}

/// provider → 整包配置 CacheKey
CacheKey aiConfigCacheKey(AiProvider p) => switch (p) {
      AiProvider.deepseek => CacheKey.aiDeepseekConfig,
      AiProvider.kimi => CacheKey.aiKimiConfig,
    };
