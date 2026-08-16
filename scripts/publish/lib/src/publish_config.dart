/// 发布配置：从 config.yaml 读取密钥与环境映射。
library;

import 'dart:io';

import 'package:yaml/yaml.dart';

/// 构建环境映射项
class BuildEnv {
  BuildEnv({required this.key, required this.label});

  /// 环境 key，会作为 `--dart-define=app_env=<key>`
  final String key;

  /// 展示名，用于日志与钉钉通知
  final String label;
}

/// 发布配置
class PublishConfig {
  PublishConfig({
    required this.pgyerApiKey,
    required this.pgyerUpdateDescription,
    required this.pgyerInstallPassword,
    required this.dingtalkWebhook,
    required this.dingtalkSecret,
    required this.feishuWebhook,
    required this.feishuSecret,
    required this.environments,
    required this.appKey,
  });

  /// 蒲公英 API Key
  final String pgyerApiKey;

  /// 蒲公英更新说明（可空）
  final String pgyerUpdateDescription;

  /// 蒲公英安装密码（可空）
  final String pgyerInstallPassword;

  /// 钉钉 Webhook
  final String dingtalkWebhook;

  /// 钉钉加签 Secret（可空）
  final String dingtalkSecret;

  /// 飞书 Webhook
  final String feishuWebhook;

  /// 飞书签名 Secret（可空）
  final String feishuSecret;

  /// 构建环境列表
  final List<BuildEnv> environments;

  /// 蒲公英应用 key（可空）
  final String appKey;

  /// 从 yaml 文件加载配置
  static PublishConfig fromFile(String path) {
    final file = File(path);
    if (!file.existsSync()) {
      throw FileSystemException('配置文件不存在: $path\n请复制 config.yaml.example 为 config.yaml 并填写密钥');
    }
    final raw = loadYaml(file.readAsStringSync()) as Map;
    return fromYaml(raw);
  }

  /// 从 yaml map 解析配置
  static PublishConfig fromYaml(Map<dynamic, dynamic> raw) {
    final pgyer = _asMap(raw['pgyer']);
    final dingtalk = _asMap(raw['dingtalk']);
    final feishu = _asMap(raw['feishu']);
    final build = _asMap(raw['build']);

    final envList = (build['environments'] as List? ?? [])
        .map((e) => BuildEnv(key: _asString(_asMap(e)['key']), label: _asString(_asMap(e)['label'])))
        .toList();
    if (envList.isEmpty) {
      throw ArgumentError('config.yaml 中 build.environments 不能为空');
    }

    return PublishConfig(
      pgyerApiKey: _asString(pgyer['api_key']),
      pgyerUpdateDescription: _asString(pgyer['update_description']),
      pgyerInstallPassword: _asString(pgyer['install_password']),
      dingtalkWebhook: _asString(dingtalk['webhook']),
      dingtalkSecret: _asString(dingtalk['secret']),
      feishuWebhook: _asString(feishu['webhook']),
      feishuSecret: _asString(feishu['secret']),
      environments: envList,
      appKey: _asString(build['app_key']),
    );
  }

  static Map<dynamic, dynamic> _asMap(dynamic v) => v is Map ? v : const {};

  static String _asString(dynamic v) => v?.toString() ?? '';
}
