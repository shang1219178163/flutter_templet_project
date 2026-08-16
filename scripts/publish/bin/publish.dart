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

    final dryRun = results['dry-run'] as bool;
    // dry-run 自测模式下避免交互：未指定 --env 时直接取第一个环境
    final env = dryRun && (results['env'] as String).trim().isEmpty
        ? config.environments.first
        : _resolveEnv(results, config);
    final targets = _resolveTargets(results);
    final skipBuild = results['skip-build'] as bool;
    final skipUpload = results['skip-upload'] as bool;
    final skipNotify = results['skip-notify'] as bool;

    logger.info('项目: ${version.alias.isEmpty ? version.name : version.alias} '
        '版本: ${version.fullVersion} 环境: ${env.label}(${env.key}) 目标: ${targets.map((t) => t.label).join('/')}');

    if (dryRun) {
      _runDryRun(logger, config, version, env, targets, skipBuild, skipUpload, skipNotify);
      return;
    }

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
      final dingTalk = DingTalkNotifier(
        webhook: config.dingtalkWebhook,
        secret: config.dingtalkSecret,
        logger: logger,
      );
      await dingTalk.send(_buildDingTalkMessage(config, version, env, targets, uploads));
      final feishu = FeishuNotifier(
        webhook: config.feishuWebhook,
        secret: config.feishuSecret,
        logger: logger,
      );
      await feishu.send(_buildFeishuMessage(config, version, env, targets, uploads));
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
    ..addFlag('dry-run', help: '自测模式：只校验配置/参数并预览消息，不打包/上传/发送', defaultsTo: false)
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

/// dry-run 自测：校验配置与参数、预览将执行的步骤和通知消息，不做任何副作用
void _runDryRun(
  Logger logger,
  PublishConfig config,
  AppVersion version,
  BuildEnv env,
  List<BuildTarget> targets,
  bool skipBuild,
  bool skipUpload,
  bool skipNotify,
) {
  logger.info('===== DRY-RUN（自测模式，不执行任何实际操作） =====');

  // 配置校验
  logger.info('配置校验：');
  logger.info('  蒲公英 api_key: ${config.pgyerApiKey.isEmpty ? "❌ 未配置" : "✅ 已配置"}');
  logger.info('  蒲公英 install_password: ${config.pgyerInstallPassword.isEmpty ? "(空)" : "已设置"}');
  logger.info('  钉钉 webhook: ${config.dingtalkWebhook.isEmpty ? "❌ 未配置" : "✅ 已配置"}');
  logger.info('  飞书 webhook: ${config.feishuWebhook.isEmpty ? "❌ 未配置" : "✅ 已配置"}');
  logger.info('  可用环境: ${config.environments.map((e) => "${e.key}(${e.label})").join(', ')}');

  // 参数校验
  logger.info('参数校验：');
  logger.info('  目标平台: ${targets.map((t) => t.label).join(' / ')}');
  logger.info('  跳过打包: $skipBuild | 跳过上传: $skipUpload | 跳过通知: $skipNotify');

  // 通知消息预览
  if (!skipNotify) {
    logger.info('===== 通知消息预览 =====');
    final ding = _buildDingTalkMessage(config, version, env, targets, const []);
    logger.info('--- 钉钉 ---\n${ding.markdown}');
    final feishu = _buildFeishuMessage(config, version, env, targets, const []);
    logger.info('--- 飞书 ---\n${feishu.markdown}');
  }

  // 计划执行步骤
  logger.info('===== 计划执行 =====');
  if (skipBuild) {
    logger.info('  [跳过] 打包');
  } else {
    logger.info('  [执行] flutter build ${targets.map((t) => t.flag).join(', ')} --dart-define=app_env=${env.key}');
  }
  if (skipUpload) {
    logger.info('  [跳过] 蒲公英上传');
  } else {
    logger.info('  [执行] 上传蒲公英（无产物时自动跳过）');
  }
  if (skipNotify) {
    logger.info('  [跳过] 钉钉/飞书通知');
  } else {
    logger.info('  [执行] 发送钉钉 + 飞书通知');
  }
  logger.info('===== DRY-RUN 通过，未执行任何实际操作 =====');
}

/// 组装钉钉通知 markdown（钉钉 markdown 支持标题/粗体/链接/图片）
DingTalkMessage _buildDingTalkMessage(
  PublishConfig config,
  AppVersion version,
  BuildEnv env,
  List<BuildTarget> targets,
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

/// 组装飞书通知 markdown（飞书 card 的 markdown 不支持 `###` 标题与图片，
/// 链接使用标准 `[text](url)` 语法，二维码信息由下载链接承载）
FeishuMessage _buildFeishuMessage(
  PublishConfig config,
  AppVersion version,
  BuildEnv env,
  List<BuildTarget> targets,
  List<PgyerUploadResult> uploads,
) {
  final appName = version.alias.isEmpty ? version.name : version.alias;
  final title = '$appName 发布通知';
  final buf = StringBuffer('**$appName 发布通知**\n\n');
  buf.writeln('- **应用**：$appName');
  buf.writeln('- **版本**：${version.fullVersion}');
  buf.writeln('- **环境**：${env.label}（${env.key}）');
  buf.writeln('- **平台**：${targets.map((t) => t.label).join(' / ')}');
  for (final upload in uploads) {
    buf.writeln('- **蒲公英下载**：[${upload.downloadUrl}](${upload.downloadUrl})');
  }
  if (config.pgyerUpdateDescription.isNotEmpty) {
    buf.writeln('- **更新说明**：${config.pgyerUpdateDescription}');
  }
  return FeishuMessage(title: title, markdown: buf.toString());
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
