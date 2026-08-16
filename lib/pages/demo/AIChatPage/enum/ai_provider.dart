/// AI 模型提供商（均为 OpenAI 兼容接口）
enum AiProvider {
  deepseek(
    label: 'DeepSeek',
    desc: '深度求索',
    defaultBaseUrl: 'https://api.deepseek.com/chat/completions',
    defaultModel: 'deepseek-chat',
  ),
  kimi(
    label: 'Kimi (Moonshot)',
    desc: '月之暗面',
    // 中国区域名：账号 key 在中国区（api.moonshot.ai 国际区会 401）
    defaultBaseUrl: 'https://api.moonshot.cn/v1/chat/completions',
    defaultModel: 'kimi-k2.6',
  );

  const AiProvider({
    required this.label,
    required this.desc,
    required this.defaultBaseUrl,
    required this.defaultModel,
  });

  /// 展示名
  final String label;

  /// 中文描述
  final String desc;

  /// 默认 chat completions 地址
  final String defaultBaseUrl;

  /// 默认模型 id
  final String defaultModel;

  @override
  String toString() => label;
}
