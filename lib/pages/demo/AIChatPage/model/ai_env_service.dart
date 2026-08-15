import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// 从 `.env` 加载各 AI provider 的 API Key。
///
/// `.env` 为 JSON 列表：`[{ "name": "deepseek", "key": "sk-xxx" }, ...]`，
/// `name` 与 [AiProvider] 枚举名对应。文件被 git 忽略，仅存在于本地。
class AiEnvService {
  static final Map<String, String> _keys = {};

  /// 应用启动时调用一次，从 assets 读取并解析
  static Future<void> load() async {
    try {
      final raw = await rootBundle.loadString('.env');
      final list = jsonDecode(raw) as List;
      _keys.clear();
      for (final e in list) {
        if (e is! Map) {
          continue;
        }
        final name = e['name'];
        final key = e['key'];
        if (name is String && key is String && name.isNotEmpty) {
          _keys[name] = key;
        }
      }
    } catch (e) {
      debugPrint('AiEnvService.load failed: $e');
    }
  }

  /// 取指定 provider 的 key；未配置返回 null
  static String? keyFor(String providerName) => _keys[providerName];
}
