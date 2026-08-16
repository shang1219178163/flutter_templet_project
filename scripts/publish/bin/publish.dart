/// 一键发布 CLI：命令编排 + 打包 + 蒲公英上传 + 钉钉/飞书通知。
///
/// 用法（在项目根目录下执行）：
///   dart run scripts/publish/bin/publish.dart --env test --target android
///   dart run scripts/publish/bin/publish.dart --env pre --target ios
///   dart run scripts/publish/bin/publish.dart --env prod --target all
///   dart run scripts/publish/bin/publish.dart --skip-build --skip-upload   # 只发通知
library;

import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as p;

import 'package:publish_cli/publish_cli.dart';

const _scriptDir = 'scripts/publish';
const _configFileName = 'config.yaml';

void main(List<String> arguments) async {
  final logger = Logger();
  try {
    final rootDir = _findRootDir();
    final configPath = p.join(rootDir, _scriptDir, _configFileName);
    final config = PublishConfig.fromFile(configPath);
    final version = parseVersion(rootDir);

    final parser = _buildParser();
    final results = parser.parse(arguments);
    if (results['help'] as bool) {
      stdout.writeln(parser.usage);
      return;
    }

    final env = _resolveEnv(results, config);
    final targets = _resolveTargets(results);
    final skipBuild = results['skip-build'] as bool;
    final skipUpload = results['skip-upload'] as bool;
    final skipNotify = results['skip-notify'] as bool;

    logger.info('项目: ${version.alias.isEmpty ? version.name : version.alias} '
        '版本: ${version.fullVersion} 环境: ${env.label}(${env.key}) 目标: ${targets.map((t) => t.label).join('/')}');

    // 1. 打包（支持多平台；all = Android + iOS）
    final builds = <BuildResult>[];
    if (skipBuild) {
      logger.warn('跳过打包（--skip-build）');
    } else {
      final builder = FlutterBuilder(rootDir: rootDir, logger: logger);
      for (final target in targets) {
        final build = await builder.build(target: target, envKey: env.key);
        builds.add(build);
        logger.success('打包完成: ${build.outputPath}');
      }
    }

    // 2. 上传蒲公英
    final uploads = <PgyerUploadResult>[];
    if (skipUpload) {
      logger.warn('跳过蒲公英上传（--skip-upload）');
    } else if (builds.isEmpty) {
      logger.warn('无构建产物，跳过上传');
    } else {
      final uploader = PgyerUploader(
        apiKey: config.pgyerApiKey,
        updateDescription: config.pgyerUpdateDescription,
        installPassword: config.pgyerInstallPassword,
        logger: logger,
      );
      for (final build in builds) {
        final upload = await uploader.upload(build.outputPath);
        uploads.add(upload);
      }
    }

    // 3. 钉钉 + 飞书通知
    if (skipNotify) {
      logger.warn('跳过通知（--skip-notify）');
    } else {
      final message = _buildMessage(config, version, env, targets, builds, uploads);
      final dingTalk = DingTalkNotifier(
        webhook: config.dingtalkWebhook,
        secret: config.dingtalkSecret,
        logger: logger,
      );
      await dingTalk.send(message);
      final feishu = FeishuNotifier(
        webhook: config.feishuWebhook,
        secret: config.feishuSecret,
        logger: logger,
      );
      await feishu.send(message);
    }

    _printSummary(logger, version, env, targets, builds, uploads);
  } catch (e) {
    logger.error('发布失败: $e');
    exitCode = 1;
  }
}

/// 从当前目录向上查找包含 pubspec.yaml 的项目根目录
String _findRootDir() {
  var dir = Directory.current;
  while (!File(p.join(dir.path, 'pubspec.yaml')).existsSync()) {
    final parent = dir.parent;
    if (parent.path == dir.path) {
      throw StateError('未找到项目根目录（含 pubspec.yaml），请进入项目目录后运行');
    }
    dir = parent;
  }
  return dir.path;
}

ArgParser _buildParser() {
  return ArgParser()
    ..addOption('env', abbr: 'e', help: '构建环境 key（test/pre/prod）', defaultsTo: '')
    ..addOption('target', abbr: 't', help: '构建目标：android / ios / all', defaultsTo: 'android')
    ..addFlag('skip-build', help: '跳过打包', defaultsTo: false)
    ..addFlag('skip-upload', help: '跳过蒲公英上传', defaultsTo: false)
    ..addFlag('skip-notify', help: '跳过钉钉/飞书通知', defaultsTo: false)
    ..addFlag('help', abbr: 'h', help: '显示帮助', defaultsTo: false);
}

/// 解析环境：优先 --env，其次交互选择
BuildEnv _resolveEnv(ArgResults results, PublishConfig config) {
  final given = (results['env'] as String).trim();
  if (given.isNotEmpty) {
    final match = config.environments.where((e) => e.key == given).toList();
    if (match.isEmpty) {
      throw ArgumentError('未知环境 key: $given（可选 ${config.environments.map((e) => e.key).join('/')}）');
    }
    return match.first;
  }
  // 未指定时交互选择
  stdout.writeln('请选择环境：');
  for (var i = 0; i < config.environments.length; i++) {
    stdout.writeln('  ${i + 1}: ${config.environments[i].key} (${config.environments[i].label})');
  }
  stdout.write('> ');
  final input = stdin.readLineSync()?.trim() ?? '';
  final idx = int.tryParse(input);
  if (idx == null || idx < 1 || idx > config.environments.length) {
    return config.environments.first;
  }
  return config.environments[idx - 1];
}

/// 解析构建目标：all = [android, ios]，否则单个
List<BuildTarget> _resolveTargets(ArgResults results) {
  final given = (results['target'] as String).trim();
  if (given == 'all') {
    return [BuildTarget.android, BuildTarget.ios];
  }
  final target = BuildTarget.values.firstWhere(
    (t) => t.flag == given,
    orElse: () => throw ArgumentError('未知 target: $given（可选 android/ios/all）'),
  );
  return [target];
}

/// 组装通知 markdown（钉钉与飞书共用内容）
DingTalkMessage _buildMessage(
  PublishConfig config,
  AppVersion version,
  BuildEnv env,
  List<BuildTarget> targets,
  List<BuildResult> builds,
  List<PgyerUploadResult> uploads,
) {
  final appName = version.alias.isEmpty ? version.name : version.alias;
  final title = '$appName 发布通知';
  final buf = StringBuffer('### $title\n\n');
  buf.writeln('- **应用**：$appName');
  buf.writeln('- **版本**：${version.fullVersion}');
  buf.writeln('- **环境**：${env.label}（${env.key}）');
  buf.writeln('- **平台**：${targets.map((t) => t.label).join(' / ')}');
  for (final upload in uploads) {
    buf.writeln('- **蒲公英下载**：[${upload.downloadUrl}](${upload.downloadUrl})');
    if (upload.buildShortcut.isNotEmpty) {
      buf.writeln('- **二维码**：![二维码](${upload.buildShortcut})');
    }
  }
  if (config.pgyerUpdateDescription.isNotEmpty) {
    buf.writeln('- **更新说明**：${config.pgyerUpdateDescription}');
  }
  return DingTalkMessage(title: title, markdown: buf.toString());
}

void _printSummary(
  Logger logger,
  AppVersion version,
  BuildEnv env,
  List<BuildTarget> targets,
  List<BuildResult> builds,
  List<PgyerUploadResult> uploads,
) {
  logger.success('===== 发布完成 =====');
  logger.success('应用: ${version.alias.isEmpty ? version.name : version.alias} ${version.fullVersion}');
  logger.success('环境: ${env.key} 平台: ${targets.map((t) => t.label).join('/')}');
  for (final build in builds) {
    logger.success('产物: ${build.outputPath}');
  }
  for (final upload in uploads) {
    logger.success('下载: ${upload.downloadUrl}');
  }
}
