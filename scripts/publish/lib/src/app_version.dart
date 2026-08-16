/// 从 pubspec.yaml 解析版本号与项目别名。
library;

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

/// 应用版本信息
class AppVersion {
  AppVersion({required this.name, required this.alias, required this.versionName, required this.versionCode});

  /// 项目名（pubspec.name）
  final String name;

  /// 项目别名（pubspec.alias 自定义字段，可能为空）
  final String alias;

  /// 版本名，如 3.27.0
  final String versionName;

  /// 构建号，如 5
  final String versionCode;

  /// 完整版本串
  String get fullVersion => '$versionName+$versionCode';
}

/// 解析项目根目录（含 pubspec.yaml）的版本信息
AppVersion parseVersion(String rootDir) {
  final file = File(p.join(rootDir, 'pubspec.yaml'));
  if (!file.existsSync()) {
    throw FileSystemException('未找到 pubspec.yaml: ${file.path}');
  }
  final raw = loadYaml(file.readAsStringSync()) as Map;

  final name = raw['name']?.toString() ?? 'app';
  final alias = raw['alias']?.toString() ?? '';
  final version = raw['version']?.toString() ?? '0.0.0+0';

  final parts = version.split('+');
  return AppVersion(
    name: name,
    alias: alias,
    versionName: parts.isNotEmpty ? parts[0] : version,
    versionCode: parts.length > 1 ? parts[1] : '0',
  );
}
